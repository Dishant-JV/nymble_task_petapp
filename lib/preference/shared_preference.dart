import 'package:shared_preferences/shared_preferences.dart';

Future<List<String>> getPrefList(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? stringList = prefs.getStringList(key) ?? [];
  return stringList;
}

Future<bool> setPrefList(String key, List<String> value) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, value);
    return true;
  } catch (e) {
    print('Error saving String List: $e');
    return false;
  }
}

Future<bool> checkIfKeyExists(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.containsKey(key);
}

Future<void> removePreference(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove(key);
}
