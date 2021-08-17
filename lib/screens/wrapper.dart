import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:meraketme/main.dart';
import 'package:meraketme/services/NotificationServices.dart';

import 'home.dart';
import 'login.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  Future selectNotification(String? payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => FirebaseAuth.instance.currentUser == null
              ? Login(
                  payload: payload,
                )
              : Home(
                  payload: payload,
                )),
    );
  }

  void getInitializations() async {
    await Firebase.initializeApp();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
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
        NotificationService()
            .showNotification(ios: ios != null, android: android != null);
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
    FirebaseMessaging.onMessage.listen((event) {
      RemoteNotification? notification = event.notification;
      debugPrint('this message is to stay for ' + event.ttl.toString());
      debugPrint(event.toString());
      AndroidNotification? android = event.notification?.android;
      AppleNotification? ios = event.notification?.apple;
      if (notification != null && (android != null || ios != null)) {
        NotificationService()
            .showNotification(ios: ios != null, android: android != null);
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
    try {
      FirebaseAuth.instance.currentUser == null
          ? Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const Login()))
          : Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const Home()));
    } catch (e) {
      debugPrint(e.toString());
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content:
                  const Text('Something went wrong, please restart the app'),
              actions: [
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => Colors.yellow)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'okay',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ))
              ],
            );
          });
    }
  }

  @override
  void initState() {
    super.initState();
    getInitializations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnimatedTextKit(
      animatedTexts: [TyperAnimatedText('Loading...')],
      totalRepeatCount: 15,
    ));
  }
}
