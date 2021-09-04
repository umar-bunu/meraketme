import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meraketme/services/NotificationServices.dart';

import 'screens/wrapper.dart';

Future _setUpIsolate() async {
  var initialMessage = await FirebaseMessaging.instance.getInitialMessage();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    if (message.notification != null) {
      await NotificationService()
          .notifyItemOnWay(message.notification!.body.toString());
    }
    print('message just popped: ' + message.notification!.body.toString());
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null && !kIsWeb) {
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'launch_background',
            ),
          ));
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('A new onMessageOpenedApp event was published!');
  });
  // var serverKey = 'AAAAakBflmk:APA91bEfOJfqM1d1OsVlwGrohVHtzxW63MTk-wD2U_z41'
  //     'jN4E6PnbCALoelqIerWfebo0Co36rAIxXVTCWIsTWHOD3HOMI5ESaEOVMKtZfgxKrCJI1ir'
  //     'd5kzL1FLPYOZublC-OwjoaRE';
  // QuerySnapshot ref = await FirebaseFirestore.instance
  //     .collection('users')
  //     .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
  //     .get();
  // print(ref.docs.first.data().toString());
  // try {
  //   ref.docs.forEach((snapshot) async {
  //     Map snapmap = snapshot.data() as Map;
  //     http.Response response = await http.post(
  //       Uri.parse('https://fcm.googleapis.com/fcm/send'),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json',
  //         'Authorization': 'key=$serverKey',
  //       },
  //       body: jsonEncode(
  //         <String, dynamic>{
  //           'notification': <String, dynamic>{
  //             'body': 'this is a body',
  //             'title': 'this is a title'
  //           },
  //           'priority': 'high',
  //           'data': <String, dynamic>{
  //             'click_action': 'FLUTTER_NOTIFICATION_CLICK',
  //             'id': '1',
  //             'status': 'done'
  //           },
  //           'to': snapmap["token"],
  //         },
  //       ),
  //     );

  //     print('response: ' + response.body.toString());
  //   });
  // } catch (e) {
  //   print("error push notification");
  // }
}

/// Define a top-level named handler which background/terminated messages will
/// call.
///
/// To verify things are working, check out the native platform logs.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print(
      'Handling a background message ${message.notification!.body.toString()}');
  if (message.notification != null) {
    await NotificationService()
        .notifyItemOnWay(message.notification!.body.toString());
  }
}

/// Create a [AndroidNotificationChannel] for heads up notifications
AndroidNotificationChannel channel = const AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

/// Initialize the [FlutterLocalNotificationsPlugin] package.
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  await _setUpIsolate();

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
