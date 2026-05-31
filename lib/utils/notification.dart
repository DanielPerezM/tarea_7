/*import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class notificationF {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> initNotifications() async {
    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    final token = await _messaging.getToken();
    debugPrint('FCM TOKEN: $token');

    await _messaging.subscribeToTopic('ruta_tiempo');
    debugPrint('Suscrito al tema: ruta_tiempo');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('===== NOTIFICACIÓN EN FOREGROUND =====');
      debugPrint('Título: ${message.notification?.title}');
      debugPrint('Body: ${message.notification?.body}');
      debugPrint('Data: ${message.data}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('===== NOTIFICACIÓN ABIERTA =====');
      debugPrint('Data: ${message.data}');
    });
  }
}
*/
