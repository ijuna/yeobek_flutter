library storage_hive;

export 'src/mobile/storage_impl.dart'
  if (dart.library.html) 'src/web/storage_impl.dart';
