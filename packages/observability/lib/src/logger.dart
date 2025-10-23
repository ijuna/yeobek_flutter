import 'package:logging/logging.dart';

Logger createLogger(String name) {
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((e) {
    // ignore: avoid_print
    print(
      '${e.level.name} ${e.time.toIso8601String()} ${e.loggerName}: ${e.message}',
    );
  });
  return Logger(name);
}
