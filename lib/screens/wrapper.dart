import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:meraketme/main.dart';

import 'home.dart';
import 'login.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  void _getData() async {
    //  try {
    FirebaseMessaging.onMessage.listen((event) {
      RemoteNotification? notification = event.notification;
      AndroidNotification? android = event.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            int.parse(channel.id),
            channel.name,
            channel.description,
            NotificationDetails(
                android: AndroidNotificationDetails(
                    channel.id, channel.name, channel.description,
                    playSound: true,
                    color: Colors.purple,
                    icon: '@mipmap/ic_launcher')));
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print('a new onmessageopenedapp event was published');
      RemoteNotification? notification = event.notification;
      AndroidNotification? android = event.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: Text(notification.title.toString()),
                  content: SingleChildScrollView(
                    child: Text(notification.body.toString()),
                  ),
                ));
      }
    });

    //   FirebaseAuth.instance.currentUser == null
    //       ? Navigator.pushReplacement(
    //           context,
    //           MaterialPageRoute(
    //               builder: (BuildContext context) => const Login()))
    //       : Navigator.pushReplacement(
    //           context,
    //           MaterialPageRoute(
    //               builder: (BuildContext context) => const Home()));
    // } catch (e) {
    //   print(e.toString());
    //   showDialog(
    //       context: context,
    //       builder: (BuildContext context) {
    //         print('something went wrong');
    //         return AlertDialog(
    //           content:
    //               const Text('Something went wrong, please restart the app'),
    //           actions: [
    //             ElevatedButton(
    //                 style: ButtonStyle(
    //                     backgroundColor: MaterialStateProperty.resolveWith(
    //                         (states) => Colors.yellow)),
    //                 onPressed: () {
    //                   Navigator.pop(context);
    //                 },
    //                 child: const Text(
    //                   'okay',
    //                   style: TextStyle(color: Colors.black, fontSize: 18),
    //                 ))
    //           ],
    //         );
    //       });
    // }
  }

  @override
  void initState() {
    super.initState();

    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            AnimatedTextKit(
              animatedTexts: [TyperAnimatedText('Loading...')],
              totalRepeatCount: 15,
            ),
            ElevatedButton(
                onPressed: () async {
                  print('clicked');
                  print(channel.id);
                  await flutterLocalNotificationsPlugin.show(
                      int.parse(channel.id),
                      'title',
                      'body',
                      const NotificationDetails(
                          android: AndroidNotificationDetails(
                              '123', 'title', 'yo',
                              importance: Importance.high,
                              priority: Priority.high,
                              playSound: true,
                              color: Colors.purple,
                              icon: '@mipmap/ic_launcher')));
                },
                child: const Text('click me'))
          ],
        ),
      ),
    ));
  }
}
