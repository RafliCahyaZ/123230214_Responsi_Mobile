import 'package:get/get.dart';

import '../../core/routes/app_routes.dart';
import '../../core/utils/app_snackbar.dart';
import '../../data/services/auth_service.dart';
import 'favorite_controller.dart';

class AuthController extends GetxController {
  AuthController(this._authService);

  final AuthService _authService;

  final RxBool isLoading = false.obs;
  final RxString username = ''.obs;

  Future<void> checkSession() async {
    isLoading.value = true;
    try {
      final loggedIn = await _authService.isLoggedIn();
      if (loggedIn) {
        username.value = await _authService.getUsername();
        await _refreshFavoriteAfterLogin();
        Get.offAllNamed(AppRoutes.main);
      } else {
        Get.offAllNamed(AppRoutes.login);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login({required String usernameInput, required String passwordInput}) async {
    final cleanUsername = usernameInput.trim();
    if (cleanUsername.isEmpty || passwordInput.trim().isEmpty) {
      AppSnackbar.error('Username dan password wajib diisi.');
      return;
    }

    isLoading.value = true;
    try {
      await _authService.saveLogin(username: cleanUsername, password: passwordInput);
      username.value = cleanUsername;
      await _refreshFavoriteAfterLogin();
      AppSnackbar.success('Selamat datang, $cleanUsername!');
      Get.offAllNamed(AppRoutes.main);
    } catch (e) {
      AppSnackbar.error(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    username.value = '';
    Get.offAllNamed(AppRoutes.login);
  }

  Future<void> _refreshFavoriteAfterLogin() async {
    if (Get.isRegistered<FavoriteController>()) {
      await Get.find<FavoriteController>().loadFavorites();
    }
  }
}
