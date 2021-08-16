import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/wrapper.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  '123',
  'High Importance Notification',
  'This channel is used for important notifications',
  importance: Importance.high,
  enableLights: true,
  playSound: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('a background message just showed up: ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);

  //remember that you haven't made any notification settigns for ios
  runApp(MaterialApp(
    theme: ThemeData(
        colorScheme: const ColorScheme.light(
            primary: Colors.purple,
            primaryVariant: Colors.white,
            onSurface: Colors.white,
            secondary: Colors.white,
            background: Colors.white60,
            onPrimary: Colors.white,
            secondaryVariant: Colors.black,
            error: Colors.red),
        textTheme: const TextTheme().apply(
            fontFamily: GoogleFonts.encodeSans().fontFamily,
            bodyColor: Colors.black,
            displayColor: Colors.black)),
    home: const Wrapper(),
    debugShowCheckedModeBanner: false,
  ));
}
