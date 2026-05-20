class AppConstants {
  const AppConstants._();

  static const String appName = 'Animeks';
  static const String appSubtitle = 'Responsi Praktikum Mobile IF-D';

  static const String kitsuBaseUrl = 'https://kitsu.io/api/edge';
  static const String animeListPath = '/anime/?page[limit]=20&page[offset]=0';

  static const String authBoxKey = 'animeks_auth';
  static const String favoriteBoxName = 'favorite_anime_box';
  static const String sessionLoggedInKey = 'is_logged_in';
  static const String sessionUsernameKey = 'username';
  static const String sessionPasswordKey = 'password';

  static const String favoriteNotificationChannelId = 'favorite_channel';
  static const String favoriteNotificationChannelName = 'Favorite Notification';
  static const String promoNotificationChannelId = 'promo_channel';
  static const String promoNotificationChannelName = 'Animeks Promo';
}
