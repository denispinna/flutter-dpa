import 'dart:developer' as developer;

class Logger {
  static void log(String tag, String message) {
    developer.log(message, name: tag);
  }

  static void logError(String tag, String message, Error error) {
    developer.log(
        message,
        name: tag,
        error: error,
        stackTrace: error.stackTrace);
  }
}