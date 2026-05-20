import 'package:get/get.dart';

import '../../presentation/screens/anime_detail_screen.dart';
import '../../presentation/screens/login_screen.dart';
import '../../presentation/screens/main_shell_screen.dart';
import '../../presentation/screens/splash_screen.dart';
import 'app_routes.dart';

class AppPages {
  const AppPages._();

  static final pages = <GetPage>[
    GetPage(name: AppRoutes.splash, page: () => const SplashScreen()),
    GetPage(name: AppRoutes.login, page: () => const LoginScreen()),
    GetPage(name: AppRoutes.main, page: () => const MainShellScreen()),
    GetPage(name: AppRoutes.detail, page: () => const AnimeDetailScreen()),
  ];
}
