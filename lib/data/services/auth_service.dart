import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';

class AuthService {
  Future<void> saveLogin({required String username, required String password}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.sessionLoggedInKey, true);
    await prefs.setString(AppConstants.sessionUsernameKey, username.trim());
    await prefs.setString(AppConstants.sessionPasswordKey, password);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppConstants.sessionLoggedInKey) ?? false;
  }

  Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.sessionUsernameKey) ?? '';
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.sessionLoggedInKey);
    await prefs.remove(AppConstants.sessionUsernameKey);
    await prefs.remove(AppConstants.sessionPasswordKey);
  }
}
