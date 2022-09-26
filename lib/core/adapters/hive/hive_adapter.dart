import 'package:hive/hive.dart';

import 'user_image_path.dart';

class HiveAdapters {
  HiveAdapters.init() {
    Hive.registerAdapter(DataModelAdapter());
  }
}
