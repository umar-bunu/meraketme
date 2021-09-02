// ignore_for_file: file_names

import 'package:flutter/painting.dart';
import 'package:meraketme/screens/Profile.dart';
import 'package:meraketme/screens/Restaurants.dart';
import 'package:meraketme/screens/orderHistory.dart';
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
        child: Flex(direction: Axis.vertical, children: <Widget>[
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
                  'Settings',
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
      ListTile(
        leading: const Icon(
          Icons.home_outlined,
          color: Colors.purple,
        ),
        title: const Text(
          'Home',
          style: TextStyle(
              fontSize: 18, color: Colors.black, fontWeight: FontWeight.w400),
        ),
        onTap: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const Home()));
        },
      ),
      ListTile(
        leading: const Icon(
          Icons.history_outlined,
          color: Colors.purple,
        ),
        title: const Text(
          'My Orders',
          style: TextStyle(
              fontSize: 18, color: Colors.black, fontWeight: FontWeight.w400),
        ),
        onTap: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const OrderHistory()));
        },
      ),
      ListTile(
        leading: const Icon(
          Icons.shopping_basket_outlined,
          color: Colors.purple,
        ),
        title: const Text(
          'My Basket',
          style: TextStyle(
              fontSize: 18, color: Colors.black, fontWeight: FontWeight.w400),
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const ShoppingCart()));
        },
      ),
      ListTile(
        leading: const Icon(
          Icons.restaurant_outlined,
          color: Colors.purple,
        ),
        title: const Text(
          'Restaurants',
          style: TextStyle(
              fontSize: 18, color: Colors.black, fontWeight: FontWeight.w400),
        ),
        onTap: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const Restaurants()));
        },
      ),
      ListTile(
        leading: const Icon(
          Icons.exit_to_app_outlined,
          color: Colors.red,
        ),
        title: const Text(
          'Log Out',
          style: TextStyle(
              fontSize: 18, color: Colors.red, fontWeight: FontWeight.w400),
        ),
        onTap: () async {
          await FirebaseAuth.instance.signOut();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const Login()));
        },
      ),
    ]));
  }
}
