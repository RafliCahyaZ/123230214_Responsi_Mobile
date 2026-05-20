import 'package:get/get.dart';

import '../../core/utils/app_snackbar.dart';
import '../../data/services/notification_service.dart';

class NotificationController extends GetxController {
  NotificationController(this._notificationService);

  final NotificationService _notificationService;
  final RxBool isScheduling = false.obs;

  Future<void> showWatchReminder() async {
    await _notificationService.showStaticWatchNotification();
    AppSnackbar.success('Notifikasi nonton berhasil dikirim.');
  }

  Future<void> scheduleDailyReminder() async {
    isScheduling.value = true;
    try {
      await _notificationService.scheduleDailyReminder();
      AppSnackbar.success('Reminder harian pukul 19.00 berhasil dibuat.');
    } catch (e) {
      AppSnackbar.error(e.toString());
    } finally {
      isScheduling.value = false;
    }
  }
}
