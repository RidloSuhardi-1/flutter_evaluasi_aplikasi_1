import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  setValue(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  getValue(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key) ? prefs.getString(key)! : '';
  }
}
