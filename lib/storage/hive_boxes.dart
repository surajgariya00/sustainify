import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Boxes {
  static const entries = 'entries';
  static const settings = 'settings';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<Map>(entries);
    await Hive.openBox(settings);
  }
}
