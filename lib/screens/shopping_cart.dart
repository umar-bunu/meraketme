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
  Future _getCartItems() async {}

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

              return SizedBox(
                height: _height,
                child: AnimatedList(
                    initialItemCount: _cartContents.length,
                    itemBuilder: (BuildContext context, index, animation) {
                      return index < _cartContents.length
                          ? SlideTransition(
                              position: _offsetAnimation,
                              child: Padding(
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
                                            _cartContents[index]['picture'],
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
                                                      _cartContents[index]
                                                          ['name'],
                                                      style: const TextStyle(
                                                          fontSize: 18),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    Text('By ' +
                                                        _cartContents[index]
                                                            ['restaurant'])
                                                  ],
                                                ),
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
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
                                                        Text(
                                                          'N' +
                                                              (double.parse(_cartContents[
                                                                              index]
                                                                          [
                                                                          'price']) *
                                                                      _cartContents[
                                                                              index]
                                                                          [
                                                                          'quantity'])
                                                                  .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  fontSize:
                                                                      18.5),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ],
                                                    )),
                                              ],
                                            ),
                                            Align(
                                                alignment: Alignment.bottomLeft,
                                                heightFactor: 2,
                                                child: Text(
                                                  _cartContents[index]
                                                      ['messageToSeller'],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ))
                                          ],
                                        )
                                      ],
                                    )),
                              ),
                            )
                          : const SizedBox();
                    }),
              );
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
