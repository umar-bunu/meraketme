import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:meraketme/services/FireStoreServices.dart';
import 'package:meraketme/widgets/showLoadingPage.dart';
import 'package:meraketme/widgets/showSuccessAlert.dart';

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
  bool _isShowingSuccessMessage = false;
  bool _isLoading = false;
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
        body: Stack(
          children: [
            FutureBuilder(
                future: _storage.ready,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List _cartContents = _storage.getItem('cartItems');
                    debugPrint(_cartContents.toString());
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
                                onPressed: () async {
                                  if (_isLoading) {
                                    return;
                                  }
                                  try {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    await FireStoreServices()
                                        .placeOrder(_cartContents);

                                    setState(() {
                                      _isShowingSuccessMessage = true;
                                    });

                                    _isLoading = false;
                                    Timer(const Duration(seconds: 3), () {
                                      setState(() {
                                        _isShowingSuccessMessage = false;
                                        _cartContents.clear();
                                      });
                                    });
                                    _storage.setItem(
                                        'cartItems', _cartContents);
                                  } catch (e) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                              title:
                                                  const Text('Error occured'),
                                              content: Text(e.toString()),
                                              actions: [
                                                ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('Ok'))
                                              ],
                                            ));
                                  }
                                },
                                icon: const Icon(Icons.fact_check_outlined),
                                label: const Text(
                                  'Check-out all orders',
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10.0),
                                              child: ElevatedButton(
                                                  onPressed: () {
                                                    showModalBottomSheet(
                                                        context: context,
                                                        builder:
                                                            (BuildContext
                                                                    context) =>
                                                                SizedBox(
                                                                  width:
                                                                      _width *
                                                                          0.8,
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            4.0),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .stretch,
                                                                      children: [
                                                                        const SizedBox(
                                                                          height:
                                                                              15,
                                                                        ),
                                                                        CachedNetworkImage(
                                                                          imageUrl:
                                                                              _cartContents[index]['picture'],
                                                                          imageBuilder: (context, imageProvider) =>
                                                                              Container(
                                                                            height:
                                                                                _width * 0.7,
                                                                            width:
                                                                                _width * 0.7,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              image: DecorationImage(
                                                                                onError: (error, stack) {
                                                                                  debugPrint(error.toString());
                                                                                },
                                                                                image: imageProvider,
                                                                                fit: BoxFit.contain,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          placeholder:
                                                                              (context, url) {
                                                                            debugPrint(url);
                                                                            return const CircularProgressIndicator();
                                                                          },
                                                                          errorWidget: (context, url, error) =>
                                                                              const Icon(Icons.error),
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              15,
                                                                        ),
                                                                        Text(
                                                                          'Quantity: ' +
                                                                              _cartContents[index]['quantity'].toString(),
                                                                          style:
                                                                              const TextStyle(fontSize: 18),
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              15,
                                                                        ),
                                                                        Text(
                                                                            'Total Price: N' +
                                                                                (_cartContents[index]['quantity'] * double.parse(_cartContents[index]['price'])).toString(),
                                                                            textAlign: TextAlign.center,
                                                                            style: const TextStyle(fontSize: 18),
                                                                            overflow: TextOverflow.ellipsis),
                                                                        const SizedBox(
                                                                          height:
                                                                              15,
                                                                        ),
                                                                        Text(
                                                                          'Toppings: ' +
                                                                              _cartContents[index]['toppings']
                                                                                  .map(
                                                                                    (eachItem) => eachItem == _cartContents[index]['toppings'].last ? eachItem['key'].toString() : eachItem['key'].toString() + ', ',
                                                                                  )
                                                                                  .toString(),
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style:
                                                                              const TextStyle(fontSize: 18),
                                                                        ),
                                                                        ElevatedButton(
                                                                            onPressed:
                                                                                () async {
                                                                              if (_isLoading) {
                                                                                return;
                                                                              }
                                                                              try {
                                                                                setState(() {
                                                                                  _isLoading = true;
                                                                                });
                                                                                await FireStoreServices().placeOrder([
                                                                                  _cartContents[index]
                                                                                ]);
                                                                                Navigator.pop(context);
                                                                                setState(() {
                                                                                  _isShowingSuccessMessage = true;
                                                                                  debugPrint(_cartContents.removeAt(index).toString());
                                                                                });
                                                                                _storage.setItem('cartItems', _cartContents);
                                                                                _isLoading = false;
                                                                                Timer(const Duration(seconds: 3), () {
                                                                                  setState(() {
                                                                                    _isShowingSuccessMessage = false;
                                                                                  });
                                                                                });
                                                                              } catch (e) {
                                                                                setState(() {
                                                                                  _isLoading = false;
                                                                                });
                                                                                showDialog(
                                                                                    context: context,
                                                                                    builder: (BuildContext context) => AlertDialog(
                                                                                          title: const Text('Error occured'),
                                                                                          content: Text(e.toString()),
                                                                                          actions: [
                                                                                            ElevatedButton(
                                                                                                onPressed: () {
                                                                                                  Navigator.pop(context);
                                                                                                },
                                                                                                child: const Text('Ok'))
                                                                                          ],
                                                                                        ));
                                                                              }
                                                                            },
                                                                            child:
                                                                                const Text('Place Order', style: TextStyle(fontSize: 17)))
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ));
                                                  },
                                                  style: ButtonStyle(
                                                    foregroundColor:
                                                        MaterialStateProperty
                                                            .resolveWith(
                                                                (states) =>
                                                                    Colors
                                                                        .black),
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .resolveWith(
                                                                (states) =>
                                                                    Colors
                                                                        .white),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      CachedNetworkImage(
                                                          imageUrl:
                                                              _cartContents[
                                                                      index]
                                                                  ['picture'],
                                                          imageBuilder: (context,
                                                                  imageProvider) =>
                                                              Container(
                                                                height: _width *
                                                                    0.25,
                                                                width: _width *
                                                                    0.25,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  image:
                                                                      DecorationImage(
                                                                    onError: (error,
                                                                        stack) {
                                                                      debugPrint(
                                                                          error
                                                                              .toString());
                                                                    },
                                                                    image:
                                                                        imageProvider,
                                                                    fit: BoxFit
                                                                        .contain,
                                                                  ),
                                                                ),
                                                              ),
                                                          placeholder: (context,
                                                                  url) =>
                                                              const CircularProgressIndicator(),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              const Icon(Icons
                                                                  .error_outline)),
                                                      SizedBox(
                                                        width: _width * 0.45,
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
                                                                  _cartContents[
                                                                          index]
                                                                      ['name'],
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          18),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                                Text('By ' +
                                                                    _cartContents[
                                                                            index]
                                                                        [
                                                                        'restaurant']),
                                                                Text(
                                                                  'N' +
                                                                      (double.parse(_cartContents[index]['price']) *
                                                                              _cartContents[index]['quantity'])
                                                                          .toString(),
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          18.5),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                                Text(
                                                                  'Toppings: ' +
                                                                      _cartContents[index]
                                                                              [
                                                                              'toppings']
                                                                          .map(
                                                                            (eachItem) => eachItem == _cartContents[index]['toppings'].last
                                                                                ? eachItem['key'].toString()
                                                                                : eachItem['key'].toString() + ', ',
                                                                          )
                                                                          .toList()
                                                                          .toString(),
                                                                  style: const TextStyle(
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      fontSize:
                                                                          16),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                )
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
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
            _isShowingSuccessMessage
                ? const ShowSuccessAlert()
                : const SizedBox(),
            _isLoading ? ShowLoadingPage() : const SizedBox()
          ],
        ));
  }
}
