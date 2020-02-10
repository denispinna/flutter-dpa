import 'dart:developer' as developer;

class Logger {
  static void log(String tag, String message) {
    if (message == null) message = "null";

    developer.log(message, name: tag);
  }

  static void logError(String tag, String message, dynamic error) {
    if (message == null) message = "null";

    developer.log(message, name: tag, error: error);
  }
}
