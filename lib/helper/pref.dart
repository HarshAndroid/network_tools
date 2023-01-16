//for accessing hive database
import 'package:hive/hive.dart';

class Pref {
  static late Box box;

  static Future<void> openBox() async {
    box = await Hive.openBox('data');
  }

  // enable or disable dark mode
  static bool get autoLogin => box.get('autoLogin') ?? false;
  static set autoLogin(bool v) => box.put('autoLogin', v);

  // latitude & longitude
  static double get lat => box.get('lat') ?? 0;
  static set lat(double v) => box.put('lat', v);

  static double get long => box.get('long') ?? 0;
  static set long(double v) => box.put('long', v);
}
