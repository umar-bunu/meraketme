// ignore_for_file: file_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  void init() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(onDidReceiveLocalNotification:
            (myint, mystring, mystring2, mystrig3) async {
      debugPrint('received');
    });

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: null);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future showNotification(
      {bool? ios, bool? android, required String message}) async {
    if (Platform.isAndroid && android != null) {
      debugPrint('notification sent');
      AndroidNotificationDetails androidPlatformChannelSpecifics =
          const AndroidNotificationDetails(
              'channelId' 'Local Notification',
              'Hi' //Required for Android 8.0 or after
                  'Your food is on its way', //Required for Android 8.0 or after
              'Your food will arrive soon', //Required for Android 8.0 or after
              importance: Importance.high,
              playSound: true,
              priority: Priority.high);
      var generalNotificationDetails =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
          0, 'Hi', 'Your food is on its way', generalNotificationDetails);
    } else if (Platform.isIOS && ios != null) {
      const IOSNotificationDetails iosNotificationDetails =
          IOSNotificationDetails(
        subtitle: 'Your food is on its way',
      );
      const generalNotificationDetails =
          NotificationDetails(iOS: iosNotificationDetails);
      await flutterLocalNotificationsPlugin.show(
          0, 'HI', 'Your food is on its way🕙', generalNotificationDetails);
    }
  }

  Future notifyItemOnWay(String vendorName) async {
    if (Platform.isAndroid) {
      debugPrint('notification sent');
      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
              'channelId' 'Local Notification',
              'Hi' //Required for Android 8.0 or after
                  '$vendorName is set and on its way', //Required for Android 8.0 or after
              'Your order will arrive soon', //Required for Android 8.0 or after
              importance: Importance.high,
              playSound: true,
              priority: Priority.high);
      var generalNotificationDetails =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
          0,
          'Hi',
          'Your order from $vendorName is set and on its way',
          generalNotificationDetails);
    } else if (Platform.isIOS) {
      IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails(
        subtitle: 'Your order from $vendorName is set and on its way',
      );
      var generalNotificationDetails =
          NotificationDetails(iOS: iosNotificationDetails);
      await flutterLocalNotificationsPlugin.show(
          0,
          'HI',
          'Your order from $vendorName is set and on its way',
          generalNotificationDetails);
    }
  }
}
