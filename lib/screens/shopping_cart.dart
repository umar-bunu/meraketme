import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({Key? key}) : super(key: key);

  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: const Offset(1.5, 0.0),
    end: Offset.zero,
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.elasticIn,
  ));

  String _error = '';
  final LocalStorage _storage = LocalStorage('items');

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    _controller.forward();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Order Cart',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder(
          future: _storage.ready,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List _cartContents = _storage.getItem('cartItems');
              if (_cartContents.isEmpty) {
                return const Center(
                  child: Text(
                    'You have no item in your cart.\n Have you made any order yet?',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17),
                  ),
                );
              }
              return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.price_check_outlined),
                          label: const Text(
                            'Proceed to check out',
                            style: TextStyle(fontSize: 17),
                          )),
                      SizedBox(
                        height: _height * 0.8,
                        child: AnimatedList(
                            initialItemCount: _cartContents.length,
                            itemBuilder:
                                (BuildContext context, index, animation) {
                              return index < _cartContents.length
                                  ? SlideTransition(
                                      position: _offsetAnimation,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        child: ElevatedButton(
                                            onPressed: () {},
                                            style: ButtonStyle(
                                              foregroundColor:
                                                  MaterialStateProperty
                                                      .resolveWith((states) =>
                                                          Colors.black),
                                              backgroundColor:
                                                  MaterialStateProperty
                                                      .resolveWith((states) =>
                                                          Colors.white),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Image.network(
                                                  _cartContents[index]
                                                      ['picture'],
                                                  height: _width * 0.25,
                                                  width: _width * 0.25,
                                                  fit: BoxFit.contain,
                                                ),
                                                SizedBox(
                                                  width: _width * 0.35,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            _cartContents[index]
                                                                ['name'],
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        18),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                          Text('By ' +
                                                              _cartContents[
                                                                      index][
                                                                  'restaurant']),
                                                          Text(
                                                            'N' +
                                                                (double.parse(_cartContents[index]
                                                                            [
                                                                            'price']) *
                                                                        _cartContents[index]
                                                                            [
                                                                            'quantity'])
                                                                    .toString(),
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        18.5),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                          Text(
                                                            'Toppings: ' +
                                                                _cartContents[
                                                                            index]
                                                                        [
                                                                        'toppings']
                                                                    .map(
                                                                      (eachItem) =>
                                                                          eachItem['key']
                                                                              .toString() +
                                                                          ', ',
                                                                    )
                                                                    .toList()
                                                                    .toString(),
                                                            style: const TextStyle(
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                fontSize: 16),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                    width: 60,
                                                    child: Column(
                                                      children: [
                                                        IconButton(
                                                            onPressed: () {
                                                              if (mounted) {
                                                                setState(() {
                                                                  _cartContents
                                                                      .removeAt(
                                                                          index);
                                                                });
                                                                _storage.setItem(
                                                                    'cartItems',
                                                                    _cartContents);
                                                              }

                                                              build(context);
                                                            },
                                                            icon: const Icon(
                                                                Icons.delete)),
                                                        ElevatedButton(
                                                            onPressed: () {},
                                                            child: const Text(
                                                                'Pay')),
                                                      ],
                                                    )),
                                              ],
                                            )),
                                      ),
                                    )
                                  : const SizedBox();
                            }),
                      ),
                    ],
                  ));
            } else {
              return const Align(
                alignment: Alignment.center,
                child: Text(
                  'loading',
                  style: TextStyle(color: Colors.black),
                ),
              );
            }
          }),
    );
  }
}
