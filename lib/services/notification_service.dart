import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  Future<void> initialize() async {
    NotificationSettings settings =
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    print(
      'Notification permission: ${settings.authorizationStatus}',
    );

    // Subscribe this device to all BMI Tracker notifications
    await _messaging.subscribeToTopic('bmi_all_users');

    print('Subscribed to bmi_all_users');

    // Get FCM token
    String? token = await _messaging.getToken();

    print('======================================');
    print('FCM TOKEN:');
    print(token);
    print('======================================');

    _messaging.onTokenRefresh.listen((newToken) {
      print('New FCM Token: $newToken');
    });

    FirebaseMessaging.onMessage.listen(
          (RemoteMessage message) {
        print('======================================');
        print('Notification received');
        print('Title: ${message.notification?.title}');
        print('Body: ${message.notification?.body}');
        print('======================================');
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen(
          (RemoteMessage message) {
        print('Notification opened');
      },
    );
  }
}

