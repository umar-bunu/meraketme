import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({Key? key}) : super(key: key);

  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  String _error = '';
  final LocalStorage _storage = LocalStorage('items');
  Future _getCartItems() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Your cart',
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
                      .map((element) => Card(
                              child: ListTile(
                            leading: CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(
                                    element['picture'],
                                    scale: 0.1)),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 4),
                            title: Text(element['name'] +
                                ' (' +
                                element['restaurant'] +
                                ')'),
                            subtitle: Text(element['messageToSeller']),
                            trailing: Text('N' +
                                (double.parse(element['price']) *
                                        element['quantity'])
                                    .toString()),
                          )))
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
