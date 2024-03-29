import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:meraketme/main.dart';
import 'package:meraketme/services/NotificationServices.dart';
import 'package:meraketme/widgets/bottombarWidget.dart';

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
  void getInitializations() async {
    await Firebase.initializeApp();
    var token = await FirebaseMessaging.instance.getToken();
    print('device token' + token.toString());
    try {
      FirebaseAuth.instance.currentUser == null
          ? Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const Login()))
          : Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => BottomBarWidget()));
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
