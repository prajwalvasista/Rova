import 'package:shared_preferences/shared_preferences.dart';

/// Class containing 'SharedPreferences' instance, all data will be
/// stored/read using this class
class MySharedPref {
  // static const userType = "user_type";
  static const accessToken = "access_token";
  static const applicationIdentifierKey = "application_identifier";
  static const applicationLogoImageKey = "application_logo";
  static const userDataKey = "user_info";
  static const savedAddress = "saved_address";

  final SharedPreferences _pref;

  MySharedPref(this._pref);

  /// Save access token
  void saveAccessToken(String token) {
    _pref.setString(accessToken, token);
  }

  void saveUserData(dynamic data) {
    _pref.setString(userDataKey, data);
  }

  // address
  void saveUserAddress(dynamic data) {
    _pref.setString(savedAddress, data);
  }

  getUserData() {
    return _pref.getString(userDataKey) ?? "";
  }

  // get address
  getUserAddress() {
    return _pref.getString(savedAddress) ?? "";
  }

  /// Get access token
  String getAccessToken() {
    return _pref.getString(accessToken) ?? "";
  }

  /// logout the user
  void logout() {
    _pref.remove(accessToken);
    _pref.remove(userDataKey);

    _pref.clear();
  }
}
