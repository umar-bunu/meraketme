// ignore_for_file: file_names

import 'package:firebase_messaging/firebase_messaging.dart';

class Notifications {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  Future initialize(context) async {
    // _firebaseMessaging.configure();
  }
}
