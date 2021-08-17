import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meraketme/services/NotificationServices.dart';

import 'screens/wrapper.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'High_importance_channel',
    'High Importance Notification',
    'This channel is used for important notifications',
    importance: Importance.high,
    playSound: true);

// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
const IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings();
const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('a background message just showed up: ${message.messageId}');
}

Future _setUpIsolate() async {
  Timer.periodic(const Duration(seconds: 60), (_) async {
    if (FirebaseAuth.instance.currentUser != null) {
      var _docs = await FirebaseFirestore.instance
          .collection('orderHistory')
          .where('customer',
              isEqualTo: FirebaseAuth.instance.currentUser!.email)
          .where('isMade', isEqualTo: true)
          .where('isDelivered', isEqualTo: false)
          .where('shouldSendAgain', isEqualTo: true)
          .get();
      for (var element in _docs.docs) {
        debugPrint(element.toString());
        await NotificationService()
            .notifyItemOnWay(element.data()['vendorName']);
        await FirebaseFirestore.instance
            .collection('orderHistory')
            .doc(element.id)
            .update({'shouldSendAgain': false});
      }
    } else {
      debugPrint('user not signed in');
    }
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  _setUpIsolate();
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
