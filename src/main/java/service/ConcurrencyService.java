package service;

import model.UserPojo;
import model.TrainPojo;

import operations.TrainOperation;
import operations.UserOperation;
import implementor.TrainOperationImpl;
import implementor.UserOperationImpl;

import java.util.concurrent.*;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.locks.ReentrantLock;
import java.util.concurrent.locks.ReadWriteLock;
import java.util.concurrent.locks.ReentrantReadWriteLock;
import java.util.concurrent.ConcurrentHashMap;
import java.util.List;
import java.util.ArrayList;
import java.util.Map; // ✅ NEW IMPORT - used by processWaitlistPromotion()

public class ConcurrencyService {
    
    // Virtual Threads
    private static final ExecutorService virtualThreadExecutor = Executors.newVirtualThreadPerTaskExecutor();
    
    // ThreadPoolExecutor for Booking
    private static final ThreadPoolExecutor bookingThreadPool = new ThreadPoolExecutor(
        10, 50, 60L, TimeUnit.SECONDS,
        new ArrayBlockingQueue<>(100),
        new ThreadPoolExecutor.CallerRunsPolicy()
    );
    
    // ConcurrentHashMap + ReentrantLock
    private static final ConcurrentHashMap<String, ReentrantLock> seatLocks = new ConcurrentHashMap<>();
    
    // AtomicInteger counters
    private static final AtomicInteger activeBookingCount = new AtomicInteger(0);
    private static final AtomicInteger todaysBookingCount = new AtomicInteger(0);
    
    // BlockingQueue
    private static final BlockingQueue<BookingRequest> bookingQueue = new LinkedBlockingQueue<>(500);
    
    // ReadWriteLock
    private static final ReadWriteLock trainSearchLock = new ReentrantReadWriteLock(true);
    
    // ForkJoinPool
    private static final ForkJoinPool reportForkJoinPool = new ForkJoinPool(
        Runtime.getRuntime().availableProcessors(),
        ForkJoinPool.defaultForkJoinWorkerThreadFactory,
        null,
        true
    );

    private static final TrainOperation trainOperation = new TrainOperationImpl();
    private static final UserOperation userOperation = new UserOperationImpl();
    
    // ==================== CACHE PER ROUTE ====================
    private static final ConcurrentHashMap<String, List<TrainPojo>> searchCache = new ConcurrentHashMap<>();
    private static final ConcurrentHashMap<String, Long> cacheTimestamps = new ConcurrentHashMap<>();
    private static final long CACHE_DURATION_MS = 60000;
    
    // ==================== GETTER METHODS ====================
    
    public static int getActiveBookingCount() { 
        return activeBookingCount.get(); 
    }
    
    public static int getTodaysBookingCount() { 
        return todaysBookingCount.get(); 
    }
    
    public static int getQueueSize() { 
        return bookingQueue.size(); 
    }
    
    public static int getActiveThreadCount() { 
        return bookingThreadPool.getActiveCount(); 
    }
    
    public static long getCompletedTaskCount() { 
        return bookingThreadPool.getCompletedTaskCount(); 
    }
    
    public static int getSeatLockCount() { 
        return seatLocks.size(); 
    }

    // ==================== SEAT LOCK ACCESSOR ====================
    public static ReentrantLock getSeatLock(String key) {
        return seatLocks.computeIfAbsent(key, k -> new ReentrantLock(true));
    }
    
    // ==================== BUSINESS METHODS ====================
    
    public CompletableFuture<UserPojo> bookTicketAsync(UserPojo pojo) {
        activeBookingCount.incrementAndGet();
        
        return CompletableFuture.supplyAsync(() -> {
            try {
                BookingRequest request = new BookingRequest(pojo);
                bookingQueue.put(request);
                return pojo;
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                activeBookingCount.decrementAndGet();
                throw new CompletionException(e);
            }
        }, virtualThreadExecutor).exceptionally(ex -> {
            activeBookingCount.decrementAndGet();
            return null;
        });
    }

    // ==================== WAITLIST PROMOTION (NEW) ====================
    // ✅ NEW METHOD - called by a Controller right after a CONFIRMED booking is
    // cancelled and a real seat has been freed. Looks up the oldest WAITING
    // booking for that train+date (if any) and, if one exists, hands it off
    // to the SAME bookingQueue + virtual-thread workers that were previously
    // dead scaffolding - so promotion genuinely runs through your real
    // concurrency machinery, not just a plain method call.
    public void processWaitlistPromotion(int trainId, String journeyDate, int seatId) {
        Map<String, Object> nextWaiting = userOperation.getNextWaitlistBooking(trainId, journeyDate);
        if (nextWaiting == null) {
            return; // nobody waiting - the seat simply stays available for normal booking
        }

        UserPojo promotionPojo = new UserPojo();
        promotionPojo.setBookingId((Integer) nextWaiting.get("bookingId"));
        promotionPojo.setJourneyDate(journeyDate);

        activeBookingCount.incrementAndGet();
        BookingRequest request = new BookingRequest(promotionPojo, true, seatId);
        try {
            bookingQueue.put(request);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            activeBookingCount.decrementAndGet();
        }
    }
    
    // ==================== SEARCH METHOD ====================
    
    public List<TrainPojo> searchTrainsWithLock(TrainPojo pojo) {
        trainSearchLock.readLock().lock();
        try {
            int sourceId = pojo.getSourceStationId();
            int destId = pojo.getDestinationStationId();
            
            String cacheKey = sourceId + "_" + destId;
            Long timestamp = cacheTimestamps.get(cacheKey);
            
            if (timestamp != null && (System.currentTimeMillis() - timestamp) < CACHE_DURATION_MS) {
                List<TrainPojo> cached = searchCache.get(cacheKey);
                if (cached != null) {
                    return cached;
                }
            }
            
            List<TrainPojo> results = trainOperation.searchTrains(pojo);
            
            searchCache.put(cacheKey, results);
            cacheTimestamps.put(cacheKey, System.currentTimeMillis());
            
            return results;
        } finally {
            trainSearchLock.readLock().unlock();
        }
    }
    
    // ==================== Cache Management Methods ====================
    
    public void clearSearchCache() {
        trainSearchLock.writeLock().lock();
        try {
            searchCache.clear();
            cacheTimestamps.clear();
        } finally {
            trainSearchLock.writeLock().unlock();
        }
    }
    
    // ==================== Train Management Methods ====================
    
    public void updateTrainWithLock(TrainPojo pojo) {
        trainSearchLock.writeLock().lock();
        try {
            trainOperation.updateTrain(pojo);
            clearSearchCache();
        } finally {
            trainSearchLock.writeLock().unlock();
        }
    }
    
    public void addTrainWithLock(TrainPojo pojo) {
        trainSearchLock.writeLock().lock();
        try {
            trainOperation.addTrain(pojo);
            clearSearchCache();
        } finally {
            trainSearchLock.writeLock().unlock();
        }
    }
    
    public void removeTrainWithLock(TrainPojo pojo) {
        trainSearchLock.writeLock().lock();
        try {
            trainOperation.removeTrain(pojo);
            clearSearchCache();
        } finally {
            trainSearchLock.writeLock().unlock();
        }
    }
    
    // ==================== REPORT GENERATION ====================
    
    public String generateAllReportsParallel() {
        long startTime = System.currentTimeMillis();
        
        ReportTask revenueTask = new ReportTask("Revenue");
        ReportTask bookingTask = new ReportTask("Booking");
        ReportTask passengerTask = new ReportTask("Passenger");
        ReportTask trainTask = new ReportTask("Train");
        
        reportForkJoinPool.execute(revenueTask);
        reportForkJoinPool.execute(bookingTask);
        reportForkJoinPool.execute(passengerTask);
        reportForkJoinPool.execute(trainTask);
        
        String revenueReport = revenueTask.join();
        String bookingReport = bookingTask.join();
        String passengerReport = passengerTask.join();
        String trainReport = trainTask.join();
        
        long endTime = System.currentTimeMillis();
        
        StringBuilder combinedReport = new StringBuilder();
        combinedReport.append("=".repeat(50)).append("\n");
        combinedReport.append("📋 COMPLETE SYSTEM REPORT\n");
        combinedReport.append("Generated using ForkJoinPool\n");
        combinedReport.append("Time taken: ").append(endTime - startTime).append("ms\n");
        combinedReport.append("=".repeat(50)).append("\n\n");
        combinedReport.append(revenueReport).append("\n");
        combinedReport.append(bookingReport).append("\n");
        combinedReport.append(passengerReport).append("\n");
        combinedReport.append(trainReport).append("\n");
        combinedReport.append("=".repeat(50)).append("\n");
        
        return combinedReport.toString();
    }
    
    // ==================== INNER CLASSES ====================
    
    private static class BookingRequest {
        private final UserPojo userPojo;
        private final long timestamp;
        private final boolean promotion; // ✅ NEW
        private final int seatId;        // ✅ NEW - only meaningful when promotion == true
        
        public BookingRequest(UserPojo userPojo) {
            this(userPojo, false, 0);
        }

        // ✅ NEW CONSTRUCTOR - used for waitlist promotion jobs
        public BookingRequest(UserPojo userPojo, boolean promotion, int seatId) {
            this.userPojo = userPojo;
            this.timestamp = System.currentTimeMillis();
            this.promotion = promotion;
            this.seatId = seatId;
        }
        
        public UserPojo getUserPojo() {
            return userPojo;
        }
        
        public long getTimestamp() {
            return timestamp;
        }

        public boolean isPromotion() { return promotion; } // ✅ NEW
        public int getSeatId() { return seatId; }           // ✅ NEW
    }
    
    public static class ReportTask extends RecursiveTask<String> {
        private final String reportType;
        
        public ReportTask(String reportType) {
            this.reportType = reportType;
        }
        
        @Override
        protected String compute() {
            try { 
                Thread.sleep(50); 
            } catch (InterruptedException e) {}
            
            StringBuilder report = new StringBuilder();
            report.append("📊 ").append(reportType).append(" Report:\n");
            
            switch(reportType) {
                case "Revenue":
                    report.append("   Total Revenue: ₹1,25,00,000\n");
                    report.append("   Today's Revenue: ₹50,000\n");
                    report.append("   UPI Payments: ₹45,00,000\n");
                    report.append("   Card Payments: ₹55,00,000\n");
                    report.append("   Net Banking: ₹25,00,000\n");
                    break;
                case "Booking":
                    report.append("   Total Bookings: 15,000\n");
                    report.append("   Confirmed Bookings: 12,000\n");
                    report.append("   Cancelled Bookings: 3,000\n");
                    break;
                case "Passenger":
                    report.append("   Total Users: 8,500\n");
                    report.append("   Active Users: 6,200\n");
                    report.append("   New Users This Month: 1,200\n");
                    break;
                case "Train":
                    report.append("   Total Trains: 25\n");
                    report.append("   Active Trains: 22\n");
                    report.append("   Inactive Trains: 3\n");
                    break;
                default:
                    report.append("   No data available\n");
            }
            return report.toString();
        }
    }
    
    // ==================== STATIC INITIALIZER ====================
    static {
        System.out.println("ConcurrencyService Initialized");
        
        for (int i = 0; i < 5; i++) {
            virtualThreadExecutor.submit(() -> {
                while (true) {
                    try {
                        BookingRequest request = bookingQueue.take();
                        processBookingRequest(request);
                    } catch (InterruptedException e) {
                        Thread.currentThread().interrupt();
                        break;
                    }
                }
            });
        }
    }
    
    private static void processBookingRequest(BookingRequest request) {
        UserPojo pojo = request.getUserPojo();

        // ✅ CHANGED (per-seat lock granularity): the key now identifies a
        // specific seat+date instead of an entire train+date, so two
        // different-seat bookings on the same train no longer block each
        // other unnecessarily.
        String seatKey = request.isPromotion()
                ? request.getSeatId() + "_" + pojo.getJourneyDate()
                : pojo.getSeatId() + "_" + pojo.getJourneyDate();
        ReentrantLock lock = seatLocks.computeIfAbsent(seatKey, k -> new ReentrantLock(true));
        
        lock.lock();
        try {
            CompletableFuture.supplyAsync(() -> {
                if (request.isPromotion()) {
                    // ✅ NEW: waitlist promotion path
                    userOperation.promoteWaitlistBooking(pojo.getBookingId(), request.getSeatId());
                } else {
                    userOperation.bookTicket(pojo);
                }
                todaysBookingCount.incrementAndGet();
                return pojo;
            }, bookingThreadPool).join();
        } finally {
            lock.unlock();
            if (request.isPromotion()) {
                activeBookingCount.decrementAndGet(); // ✅ NEW - balances the increment in processWaitlistPromotion()
            }
        }
    }
}