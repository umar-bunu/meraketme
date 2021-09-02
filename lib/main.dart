import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
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
  debugPrint('a background message just showed up: ${message.data.toString()}');
  await NotificationService().notifyItemOnWay(message.data.toString());
}

Future selectNotification(String? payload) async {
  if (payload != null) {
    debugPrint('notification payload: $payload');
  }
  // await Navigator.push(
  //   context,
  //   MaterialPageRoute(
  //       builder: (context) => FirebaseAuth.instance.currentUser == null
  //           ? Login(
  //               payload: payload,
  //             )
  //           : Home(
  //               payload: payload,
  //             )),
  // );
}

Future _setUpIsolate() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings();

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: selectNotification);
  debugPrint('about to start receiving messages');
  FirebaseMessaging.onBackgroundMessage((event) async {
    debugPrint(event.toString());
    AndroidNotification? android = event.notification?.android;
    AppleNotification? ios = event.notification?.apple;
    RemoteNotification? notification = event.notification;

    if (notification != null && (android != null || ios != null)) {
      NotificationService().notifyItemOnWay(event.data.toString());
      flutterLocalNotificationsPlugin.show(
          int.parse(channel.id),
          channel.name,
          channel.description,
          NotificationDetails(
            android: AndroidNotificationDetails(
                channel.id, channel.name, channel.description,
                playSound: true,
                channelShowBadge: true,
                priority: Priority.high,
                icon: '@mipmap/ic_launcher'),
          ));
    }
  });
  FirebaseMessaging.onMessage.listen((event) async {
    debugPrint('listening for events');

    RemoteNotification? notification = event.notification;
    debugPrint('message is' + event.data['whatToSend'].toString());
    debugPrint('this message is to stay for ' + event.ttl.toString());
    await NotificationService()
        .notifyItemOnWay(event.data['whatToSend'].toString());
    debugPrint(event.toString());
    AndroidNotification? android = event.notification?.android;
    AppleNotification? ios = event.notification?.apple;
    if (notification != null && (android != null || ios != null)) {
      debugPrint('netered the if');
      NotificationService().notifyItemOnWay(event.data.toString());
      await flutterLocalNotificationsPlugin.show(
          int.parse(channel.id),
          channel.name,
          channel.description,
          NotificationDetails(
            android: AndroidNotificationDetails(
                channel.id, channel.name, channel.description,
                playSound: true,
                channelShowBadge: true,
                priority: Priority.high,
                icon: '@mipmap/ic_launcher'),
          ));
    }
  });

  FirebaseMessaging.instance.onTokenRefresh.listen((event) {
    FirebaseFirestore.instance
        .collection(('user'))
        .doc(FirebaseAuth.instance.currentUser!.email)
        .update({'token': event});
  });
  // final DatabaseReference db = FirebaseDatabase().reference();
  // db.child("restaurants").push().child('vendor_id').set('-MiCZjGpgOoZZQjKGJS6');

  // bool _isLisetening = false;

  // Timer.periodic(const Duration(seconds: 60), (_) async {
  //   if (FirebaseAuth.instance.currentUser != null && !_isLisetening) {
  //     // debugPrint('listening');
  //     FirebaseFirestore.instance
  //         .collection('orderHistory')
  //         .where('customer',
  //             isEqualTo: FirebaseAuth.instance.currentUser!.email)
  //         .snapshots()
  //         .listen((event) async {
  //       _isLisetening = true;
  //       //   debugPrint(
  //       //     'elements that changed ' + event.docChanges.length.toString());
  //       for (var element in event.docChanges) {
  //         // debugPrint(element.doc.id.toString() +
  //         //     ' should send again ' +
  //         //     element.doc.data()!['shouldSendAgain'].toString() +
  //         //     ' ismade ' +
  //         //     element.doc.data()!['isMade'].toString());

  //         if (element.doc.data()!['isMade'] &&
  //             element.doc.data()!['shouldSendAgain']) {
  //           //   debugPrint('will be updted: ' + element.doc.id);
  //           await NotificationService()
  //               .notifyItemOnWay(element.doc.data()!['vendorName']);
  //           await FirebaseFirestore.instance
  //               .collection('orderHistory')
  //               .doc(element.doc.id)
  //               .update({'shouldSendAgain': false});
  //         }
  //       }
  //     });
  //   } else {
  //     debugPrint('user not signed in');
  //     _isLisetening = false;
  //   }
  // });
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
