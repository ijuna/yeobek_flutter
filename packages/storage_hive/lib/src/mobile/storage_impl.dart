import 'package:hive_flutter/hive_flutter.dart';

class StorageImpl {
  Future<void> init() async {
    await Hive.initFlutter();
  }
}
