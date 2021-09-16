import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageKeywords {
  static const String boardGameList = "BOARD_GAME_LIST";
  static const String img = "img";
  static const String tutorialDone = "td";
}

class LocalStorage {
  LocalStorage._();

  factory LocalStorage({SharedPreferences? sharedPreferences}) {
    if (sharedPreferences != null) {
      _instance._sharedPreferences = sharedPreferences;
    }
    return _instance;
  }

  static late final LocalStorage _instance = LocalStorage._();
  late final SharedPreferences _sharedPreferences;

  Future<bool> write(String key, String value) {
    return _sharedPreferences.setString(key, value);
  }

  String? read(String key) {
    return _sharedPreferences.getString(key);
  }

  Future<bool> clear() {
    return _sharedPreferences.clear();
  }
}
