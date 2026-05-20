import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../core/constants/app_constants.dart';

class NotificationService {
  NotificationService() {
    tz.initializeTimeZones();
  }

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _plugin.initialize(settings);

    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission();
  }

  NotificationDetails _favoriteDetails() {
    const android = AndroidNotificationDetails(
      AppConstants.favoriteNotificationChannelId,
      AppConstants.favoriteNotificationChannelName,
      channelDescription: 'Notifikasi ketika anime ditambahkan ke favorit.',
      importance: Importance.high,
      priority: Priority.high,
    );
    return const NotificationDetails(android: android);
  }

  NotificationDetails _promoDetails() {
    const android = AndroidNotificationDetails(
      AppConstants.promoNotificationChannelId,
      AppConstants.promoNotificationChannelName,
      channelDescription: 'Reminder promo dan jadwal nonton Keripikroll.',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );
    return const NotificationDetails(android: android);
  }

  Future<void> showFavoriteNotification(String animeTitle) async {
    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'Anime ditambahkan',
      '$animeTitle berhasil masuk Favorite Keripikroll.',
      _favoriteDetails(),
    );
  }

  Future<void> showStaticWatchNotification() async {
    await _plugin.show(
      101,
      'Keripikroll',
      'Waktunya lanjut nonton anime favoritmu!',
      _promoDetails(),
    );
  }

  Future<void> scheduleDailyReminder() async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, 19, 0);
    if (scheduled.isBefore(now)) scheduled = scheduled.add(const Duration(days: 1));

    //await _plugin.zonedSchedule(
      //202,
     // 'Animeks Reminder',
      //'Cek anime favoritmu malam ini.',
     // scheduled,
    //  _promoDetails(),
    //  androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
     // matchDateTimeComponents: DateTimeComponents.time,
    //);
  }
}
