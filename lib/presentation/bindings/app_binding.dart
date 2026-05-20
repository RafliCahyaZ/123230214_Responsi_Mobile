import 'package:get/get.dart';

import '../../data/services/api_service.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/favorite_service.dart';
import '../../data/services/location_service.dart';
import '../../data/services/notification_service.dart';
import '../controllers/anime_controller.dart';
import '../controllers/auth_controller.dart';
import '../controllers/detail_controller.dart';
import '../controllers/favorite_controller.dart';
import '../controllers/location_controller.dart';
import '../controllers/main_shell_controller.dart';
import '../controllers/notification_controller.dart';

class AppBinding extends Bindings {
  AppBinding({NotificationService? notificationService}) : _notificationService = notificationService;

  final NotificationService? _notificationService;

  @override
  void dependencies() {
    Get.put<ApiService>(ApiService(), permanent: true);
    Get.put<AuthService>(AuthService(), permanent: true);
    Get.put<FavoriteService>(FavoriteService(), permanent: true);
    Get.put<NotificationService>(_notificationService ?? NotificationService(), permanent: true);
    Get.put<LocationService>(LocationService(), permanent: true);

    Get.put<AuthController>(AuthController(Get.find<AuthService>()), permanent: true);
    Get.put<FavoriteController>(FavoriteController(Get.find<FavoriteService>()), permanent: true);
    Get.put<AnimeController>(AnimeController(Get.find<ApiService>()), permanent: true);
    Get.put<MainShellController>(MainShellController(), permanent: true);
    Get.put<LocationController>(LocationController(Get.find<LocationService>()), permanent: true);
    Get.put<NotificationController>(NotificationController(Get.find<NotificationService>()), permanent: true);
    Get.put<DetailController>(
      DetailController(Get.find<ApiService>(), Get.find<NotificationService>()),
      permanent: true,
    );
  }
}
