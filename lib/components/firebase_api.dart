import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../models/Lists.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title:' + message.notification!.title.toString());
  print('Body:' + message.notification!.body.toString());
}

class FirebaseApi{
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    print('Начало запроса прав _firebaseMessaging');
    await _firebaseMessaging.requestPermission().timeout(Duration(seconds: 2));
    print('Получение токена');
    final FCMToken = await _firebaseMessaging.getToken().timeout(Duration(seconds: 2));
    print('Токен для пуш уведомлений на андройде: ' + FCMToken.toString());
    Globals.setFCM(FCMToken.toString());
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    //--//подключаем локальные уведомления flutter_local_notifications
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description: 'This channel is used for important notifications.', // description
      importance: Importance.max,
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    //--\\подключаем локальные уведомления flutter_local_notifications

    //--//обрабатываем сами локальные уведомления
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Пришло локальное уведомление');
      final notification = message.notification;
      final android = message.notification?.android;

      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: '@mipmap/launcher_icon',//android.smallIcon,
                // other properties...
              ),
            ));
      }
    });
    //--\\обрабатываем сами локальные уведомления
  }
}