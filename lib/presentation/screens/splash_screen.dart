import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../controllers/auth_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => Get.find<AuthController>().checkSession());
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 46,
              backgroundColor: AppTheme.orange,
              child: Icon(Icons.play_circle_fill_rounded, size: 52, color: Colors.white),
            ),
            SizedBox(height: 18),
            Text(
              AppConstants.appName,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: AppTheme.dark),
            ),
            SizedBox(height: 6),
            Text(AppConstants.appSubtitle),
            SizedBox(height: 22),
            CircularProgressIndicator(color: AppTheme.orange),
          ],
        ),
      ),
    );
  }
}
