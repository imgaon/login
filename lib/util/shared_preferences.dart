import 'package:shared_preferences/shared_preferences.dart';

final prefs = _Prefs();

class _Prefs {
  late SharedPreferences prefs;

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }
}