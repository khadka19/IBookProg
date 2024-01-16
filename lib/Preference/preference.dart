import 'package:shared_preferences/shared_preferences.dart';

class UserPreference {
  static setUserPreference(String key, String value) async {
    try {
      var prefResponse = await SharedPreferences.getInstance();
      prefResponse.setString(key, value);
    // ignore: empty_catches
    } catch (e) {
    }
  }

  static getUserPreference(String key) async {
    try {
      var prefs = await SharedPreferences.getInstance();
      var prefResponse = prefs.getString(key);
      return prefResponse;
    // ignore: empty_catches
    } catch (e) {
    }
  }

  static removeUserPreference(String key) async {
    try {
      var prefs = await SharedPreferences.getInstance();
      var prefResponse = prefs.remove(key);
      return prefResponse;
    // ignore: empty_catches
    } catch (e) {
    }
  }





}


