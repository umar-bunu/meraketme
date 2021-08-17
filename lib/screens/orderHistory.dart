// ignore_for_file: file_names

import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meraketme/services/FireStoreServices.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({Key? key}) : super(key: key);

  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('My Orders'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        child: FutureBuilder(
          future: FireStoreServices()
              .getOrderHistory(FirebaseAuth.instance.currentUser!.email),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              List _snapData = snapshot.data as List;
              if (_snapData.isEmpty) {
                return const Center(
                  child: Text(
                    'You have no orders yet. \n Your order list is displayed here',
                    style: TextStyle(fontSize: 17),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                return ListView(
                  shrinkWrap: true,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    ...(_snapData.map((element) => Card(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.network(
                                    element['data']['picture'],
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.contain,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        element['data']['name'],
                                        style: const TextStyle(fontSize: 18),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                          'By ' + element['data']['restaurant'])
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      'N' +
                                          (double.parse(element['data']
                                                      ['price']) *
                                                  double.parse(element['data']
                                                      ['quantity']))
                                              .toString(),
                                      style: const TextStyle(fontSize: 18.5),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ))))
                  ],
                );
              }
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error occured\n' + snapshot.error.toString(),
                  style: const TextStyle(fontSize: 17),
                  textAlign: TextAlign.center,
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.purple,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
