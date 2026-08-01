package util;

import java.io.IOException;
import java.util.logging.FileHandler;
import java.util.logging.Level;
import java.util.logging.LogRecord;
import java.util.logging.Logger;
import java.util.logging.SimpleFormatter;

// ✅ Centralized logger setup used by all Operation impl classes.
// Uses java.util.logging (built into the JDK) - no new JAR dependencies.
// Writes to a rotating file "trs-app.log" in Tomcat's catalina.base
// directory, using an auto-flushing handler so entries hit disk
// immediately instead of waiting for the server to shut down.
public class AppLogger {

    // ✅ Flushes to disk after every single log record.
    private static class FlushingFileHandler extends FileHandler {
        public FlushingFileHandler(String pattern, int limit, int count, boolean append) throws IOException {
            super(pattern, limit, count, append);
        }

        @Override
        public synchronized void publish(LogRecord record) {
            super.publish(record);
            flush();
        }
    }

    private static FileHandler fileHandler;
    private static boolean initialized = false;

    private static synchronized void initHandler() {
        if (initialized) return;
        try {
            String baseDir = System.getProperty("catalina.base");
            if (baseDir == null || baseDir.trim().isEmpty()) {
                baseDir = System.getProperty("user.home");
            }
            String logPath = baseDir + java.io.File.separator + "trs-app.log";

            System.out.println("AppLogger writing log file to: " + logPath);

            fileHandler = new FlushingFileHandler(logPath, 5 * 1024 * 1024, 3, true);
            fileHandler.setFormatter(new SimpleFormatter());
            fileHandler.setLevel(Level.ALL);
        } catch (IOException e) {
            System.err.println("AppLogger: could not create log file handler - " + e.getMessage());
        }
        initialized = true;
    }

    public static Logger getLogger(Class<?> clazz) {
        initHandler();
        Logger logger = Logger.getLogger(clazz.getName());
        if (fileHandler != null) {
            boolean alreadyAttached = false;
            for (var h : logger.getHandlers()) {
                if (h == fileHandler) {
                    alreadyAttached = true;
                    break;
                }
            }
            if (!alreadyAttached) {
                logger.addHandler(fileHandler);
            }
        }
        logger.setLevel(Level.ALL);
        return logger;
    }
}