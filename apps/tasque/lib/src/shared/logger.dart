import 'dart:developer' as dev;

/// Logs a message to the console.
void log(Object? message, [Object? error, StackTrace? stackTrace]) {
  dev.log(
    message.toString(),
    name: 'dev',
    error: error,
    stackTrace: stackTrace,
  );
}
