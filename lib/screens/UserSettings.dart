// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meraketme/screens/Profile.dart';
import 'package:meraketme/screens/ShippingDetails.dart';
import 'package:meraketme/screens/login.dart';

class UserSettings extends StatefulWidget {
  var userData;
  UserSettings({Key? key, this.userData}) : super(key: key);

  @override
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            const SizedBox(
              height: 20,
            ),
            Card(
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Profile(
                                userData: widget.userData,
                              )));
                },
                leading: const Icon(
                  Icons.person_outlined,
                  color: Colors.purple,
                ),
                title: const Text('My info', style: TextStyle(fontSize: 18)),
                trailing: const Icon(Icons.chevron_right_rounded),
              ),
            ),
            Card(
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ShippingDetails()));
                },
                leading: const Icon(
                  Icons.navigation_outlined,
                  color: Colors.purple,
                ),
                title:
                    const Text('My Addresses', style: TextStyle(fontSize: 18)),
                trailing: const Icon(Icons.chevron_right_rounded),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Card(
                child: ListTile(
                  onTap: () async {
                    while (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => const Login()));
                  },
                  leading: const Icon(
                    Icons.exit_to_app_outlined,
                    color: Colors.red,
                    size: 30,
                  ),
                  title: const Text(
                    'Log out',
                    style: TextStyle(color: Colors.red, fontSize: 18),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
