// ignore_for_file: file_names

import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meraketme/screens/shopping_cart.dart';
import 'package:meraketme/services/FireStoreServices.dart';
import 'package:meraketme/widgets/expandedFoodToOrder.dart';

class OrderHistory extends StatefulWidget {
  var userData;
  OrderHistory({Key? key, this.userData}) : super(key: key);

  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'My Orders',
          style: TextStyle(color: Colors.purple),
        ),
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
                    ...(_snapData.map((element) => GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: (BuildContext context) => Wrap(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.favorite,
                                                color: Colors.purple,
                                              ),
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                icon: const Icon(
                                                  Icons.cancel_outlined,
                                                  color: Colors.purple,
                                                  size: 30,
                                                )),
                                          ],
                                        ),
                                        ExpanedFoodToOrder(
                                          foodItem: element,
                                          screenHeight: _height,
                                          screenwidth: _width,
                                        )
                                      ],
                                    ));
                          },
                          child: Card(
                              elevation: 5,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: element['data']['picture'],
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        height: _width * 0.25,
                                        width: _width * 0.25,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            onError: (error, stack) {
                                              debugPrint(error.toString());
                                            },
                                            image: imageProvider,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      placeholder: (context, url) {
                                        debugPrint(url);
                                        return const CircularProgressIndicator();
                                      },
                                      errorWidget: (context, url, error) =>
                                          Container(
                                              height: _width * 0.25,
                                              width: _width * 0.25,
                                              alignment: Alignment.center,
                                              child: const Icon(
                                                Icons.error,
                                                color: Colors.purple,
                                              )),
                                    ),
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              element['data']['itemName'],
                                              style:
                                                  const TextStyle(fontSize: 18),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text('By ' +
                                                element['data']['vendorName'])
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      width: _width * 0.25,
                                      child: Text(
                                        'N' +
                                            (double.parse(element['data']
                                                            ['price']
                                                        .toString()) *
                                                    double.parse(element['data']
                                                            ['quantity']
                                                        .toString()))
                                                .toString(),
                                        style: const TextStyle(fontSize: 18.5),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        )))
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
