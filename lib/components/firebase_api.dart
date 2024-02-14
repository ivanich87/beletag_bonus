import 'package:beletag/models/Lists.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title:' + message.notification!.title.toString());
  print('Body:' + message.notification!.body.toString());
}

class FirebaseApi{
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    final FCMToken = await _firebaseMessaging.getToken();
    print('Токен для пуш уведомлений на андройде: ' + FCMToken.toString());
    Globals.setFCM(FCMToken.toString());
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}