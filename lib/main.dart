import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/constants/app_constants.dart';
import 'core/routes/app_pages.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'data/services/notification_service.dart';
import 'presentation/bindings/app_binding.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox(AppConstants.favoriteBoxName);

  final notificationService = NotificationService();
  await notificationService.initialize();

  runApp(KeripikrollApp(notificationService: notificationService));
}

class KeripikrollApp extends StatelessWidget {
  const KeripikrollApp({super.key, required this.notificationService});

  final NotificationService notificationService;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
      initialBinding: AppBinding(notificationService: notificationService),
    );
  }
}

