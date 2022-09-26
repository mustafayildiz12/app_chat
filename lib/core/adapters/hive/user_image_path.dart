import 'package:hive/hive.dart';

part 'user_image_path.g.dart';

@HiveType(typeId: 0)
class DataModel {
  @HiveField(0)
  final String imagePath;

  DataModel({required this.imagePath});
}
