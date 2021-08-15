// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class TempShoppingCart extends StatefulWidget {
  const TempShoppingCart({Key? key}) : super(key: key);

  @override
  _TempShoppingCartState createState() => _TempShoppingCartState();
}

class _TempShoppingCartState extends State<TempShoppingCart> {
  String _error = '';
  final LocalStorage _storage = LocalStorage('items');
  Future _getCartItems() async {}

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Shopping Cart',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder(
          future: _storage.ready,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List _cartContents = _storage.getItem('cartItems');
              return ListView(
                shrinkWrap: true,
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  ...(_cartContents
                      .map((element) => Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ElevatedButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.resolveWith(
                                          (states) => Colors.black),
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith(
                                          (states) => Colors.white),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      child: Image.network(
                                        element['picture'],
                                        height: 130,
                                        width: 130,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  element['name'],
                                                  style: const TextStyle(
                                                      fontSize: 18),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text('By ' +
                                                    element['restaurant'])
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Text(
                                                'N' +
                                                    (double.parse(element[
                                                                'price']) *
                                                            element['quantity'])
                                                        .toString(),
                                                style: const TextStyle(
                                                    fontSize: 18.5),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Align(
                                            alignment: Alignment.bottomLeft,
                                            heightFactor: 2,
                                            child: Text(
                                              element['messageToSeller'],
                                              overflow: TextOverflow.ellipsis,
                                            ))
                                      ],
                                    )
                                  ],
                                )),
                          ))
                      .toList())
                ],
              );
            } else {
              return const Align(
                alignment: Alignment.center,
                child: Text('loading'),
              );
            }
          }),
    );
  }
}
