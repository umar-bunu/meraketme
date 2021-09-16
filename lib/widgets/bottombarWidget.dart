// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meraketme/screens/Profile.dart';
import 'package:meraketme/screens/Restaurants.dart';
import 'package:meraketme/screens/home.dart';
import 'package:meraketme/screens/orderHistory.dart';
import 'package:meraketme/screens/shopping_cart.dart';
import 'package:meraketme/services/FireStoreServices.dart';

class BottomBarWidget extends StatefulWidget {
  BottomBarWidget({Key? key}) : super(key: key);

  @override
  _BottomBarWidgetState createState() => _BottomBarWidgetState();
}

class _BottomBarWidgetState extends State<BottomBarWidget>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  int _selectedIndex = 0;
  List _foodList = [];
  List _restaurantList = [];
  List _foodListByPromos = [];
  var _userData;

  void _onItemClicked(int index) {
    setState(() {
      _selectedIndex = index;
      tabController.index = _selectedIndex;
    });
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.email)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              DocumentSnapshot _docSnap = snapshot.data as DocumentSnapshot;
              if (!_docSnap.exists) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          content: const Text(
                              'You have not set up your profile yet.\nWould you like to'
                              ' set it up now?'),
                          actions: [
                            ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) => Colors.red)),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel')),
                            const SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) => Colors.red)),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Profile()));
                                },
                                child: const Text('Cancel')),
                          ],
                        ));
              }
              Map _userData = {'id': _docSnap.id, 'data': _docSnap.data()};

              return TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: tabController,
                children: [
                  Home(userData: _userData),
                  Restaurants(
                    userData: _userData,
                  ),
                  const ShoppingCart(),
                  OrderHistory(userData: _userData),
                  Profile(userData: _userData)
                ],
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Error. Could Not load data'),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.restaurant_outlined,
              ),
              label: 'Restaurants'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_basket_outlined), label: 'My Basket'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.history_outlined,
              ),
              label: 'My Orders'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person_outline,
              ),
              label: 'Settings'),
        ],
        unselectedItemColor: Colors.purple,
        selectedItemColor: Colors.purple,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontSize: 17),
        currentIndex: _selectedIndex,
        onTap: _onItemClicked,
        showUnselectedLabels: true,
      ),
    );
  }
}
