import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static Future<void> handler(RemoteMessage message) async {
    print(message.notification!.body!.toString());
  }

  static Future<void> initialize() async {
    await Firebase.initializeApp();

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    FirebaseMessaging.onBackgroundMessage(handler);
  }
}
