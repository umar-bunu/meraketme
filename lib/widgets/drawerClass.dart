// ignore_for_file: file_names

import 'package:meraketme/screens/Profile.dart';
import 'package:meraketme/screens/shopping_cart.dart';

import '../screens/home.dart';
import '../screens/login.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DrawerClass extends StatelessWidget {
  const DrawerClass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => const Login()));
            },
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => const Profile()));
              },
              child: Container(
                height: 150.0,
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
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.025,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: const Text(
                '   Home',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              onTap: () {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: const Text(
                  '   Favorites',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                onTap: () async {},
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: const Text(
                  '   My orders',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                onTap: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const ShoppingCart()));
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: const Text(
                  '   Log out',
                  style: TextStyle(fontSize: 18, color: Colors.red),
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
          ),
        ]));
  }
}