import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _notifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    await _setupFirebaseMessaging();
  }

  Future<void> _setupFirebaseMessaging() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
  }

  void _handleForegroundMessage(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      _notifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'gym_bro_notifications',
            'Gym Bro Notifications',
            channelDescription: 'Notifications for workout reminders and updates',
            importance: Importance.max,
            priority: Priority.high,
            color: const Color(0xFF39FF14),
          ),
        ),
      );
    }
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    print('Message clicked!');
  }

  void _onNotificationTapped(NotificationResponse notificationResponse) {
    print('Notification tapped: ${notificationResponse.payload}');
  }

  Future<void> showWorkoutReminder() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'gym_bro_notifications',
      'Gym Bro Notifications',
      channelDescription: 'Notifications for workout reminders',
      importance: Importance.max,
      priority: Priority.high,
      color: Color(0xFF39FF14),
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notifications.show(
      0,
      'Workout Reminder',
      'Time to hit the gym! 💪',
      platformChannelSpecifics,
    );
  }

  Future<void> showWaterReminder() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'gym_bro_notifications',
      'Gym Bro Notifications',
      channelDescription: 'Notifications for water intake',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      color: Color(0xFF39FF14),
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notifications.show(
      1,
      'Hydration Reminder',
      'Time to drink water! 💧',
      platformChannelSpecifics,
    );
  }

  Future<void> showProteinReminder() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'gym_bro_notifications',
      'Gym Bro Notifications',
      channelDescription: 'Notifications for protein intake',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      color: Color(0xFF39FF14),
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notifications.show(
      2,
      'Protein Reminder',
      'Don\'t forget your protein goals! 🥩',
      platformChannelSpecifics,
    );
  }
}
