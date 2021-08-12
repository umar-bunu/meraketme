// ignore_for_file: file_names

import '../screens/home.dart';
import '../screens/login.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DrawerClass extends StatelessWidget {
  const DrawerClass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(padding: EdgeInsets.zero, children: <Widget>[
      GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const Login()));
        },
        child: Container(
          height: 120.0,
          color: Colors.purple,
          child: const DrawerHeader(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Profile',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListTile(
          title: const Text(
            'Home',
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
          onTap: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => const Home()));
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListTile(
          title: const Text(
            'Log out',
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
          onTap: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => const Login()));
          },
        ),
      ),
    ]));
  }
}
