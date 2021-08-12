// ignore_for_file: camel_case_types

import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:meraketme/widgets/showSuccessAlert.dart';

class Food_view extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final selectedFood;
  const Food_view({Key? key, required this.selectedFood}) : super(key: key);

  @override
  _Food_viewState createState() => _Food_viewState();
}

class _Food_viewState extends State<Food_view> {
  int _noOfItems = 1;
  bool _isloading = false;
  String _messageToSeller = '';

  bool _isShowingSuccessAlert = false;

  Future _addedToCart() async {
    setState(() {
      _isShowingSuccessAlert = true;
    });
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isShowingSuccessAlert = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    return Container(
        color: Colors.white38,
        height: _height * 0.8,
        child: Stack(
          children: [
            ListView(
              shrinkWrap: true,
              children: [
                Image.network(
                  widget.selectedFood['data']['picture'],
                  height: _width,
                  width: _width,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            'Pieces',
                          ),
                          Container(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                _noOfItems.toString(),
                                textAlign: TextAlign.center,
                              )),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _noOfItems = _noOfItems + 1;
                                    });
                                  },
                                  child: const Icon(Icons.arrow_drop_up)),
                              GestureDetector(
                                  onTap: () {
                                    if (_noOfItems > 1) {
                                      setState(() {
                                        _noOfItems -= 1;
                                      });
                                    }
                                  },
                                  child: const Icon(Icons.arrow_drop_down))
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextField(
                        onChanged: (value) {
                          _messageToSeller = value.trim();
                        },
                        keyboardType: TextInputType.multiline,
                        maxLines: 2,
                        decoration: const InputDecoration(
                            icon: Icon(Icons.notes),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.purple)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.purple)),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.purple)),
                            labelText: 'Notes for seller',
                            hintText:
                                'Tell them how you want it. Eg: I want it spicy',
                            labelStyle: TextStyle(color: Colors.black)),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ElevatedButton(
                          style: ButtonStyle(
                              padding: MaterialStateProperty.resolveWith(
                                  (states) => const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 15))),
                          onPressed: () async {
                            setState(() {
                              _isloading = true;
                            });
                            try {
                              LocalStorage _storage = LocalStorage('items');
                              await _storage.ready;

                              var currentItems = _storage.getItem('cartItems');

                              if (currentItems == null) {
                                currentItems = [
                                  {
                                    'picture': widget.selectedFood['data']
                                        ['picture'],
                                    'name': widget.selectedFood['data']['name'],
                                    'price': widget.selectedFood['data']
                                        ['price'],
                                    'quantity': _noOfItems,
                                    'vendor': widget.selectedFood['data']
                                        ['vendor'],
                                    'messageToSeller': _messageToSeller,
                                    'restaurant': widget.selectedFood['data']
                                        ['restaurant']
                                  }
                                ];
                                await _storage.setItem(
                                    'cartItems', currentItems);
                              } else {
                                currentItems.add({
                                  'messageToSeller': _messageToSeller,
                                  'picture': widget.selectedFood['data']
                                      ['picture'],
                                  'name': widget.selectedFood['data']['name'],
                                  'price': widget.selectedFood['data']['price'],
                                  'quantity': _noOfItems,
                                  'vendor': widget.selectedFood['data']
                                      ['vendor'],
                                  'restaurant': widget.selectedFood['data']
                                      ['restaurant']
                                });
                                await _storage.setItem(
                                    'cartItems', currentItems);
                              }
                              _addedToCart();
                              setState(() {
                                _isloading = false;
                              });
                            } catch (e) {
                              setState(() {
                                _isloading = false;
                              });
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        title: const Text(
                                          'Oops',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16),
                                        ),
                                        content: Text(
                                          e.toString(),
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16),
                                        ),
                                        actions: [
                                          ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Okay'))
                                        ],
                                      ));
                            }
                          },
                          child: const Text('Add to Cart')),
                    ],
                  ),
                )
              ],
            ),
            _isloading
                ? Container(
                    height: _height,
                    color: Colors.white.withOpacity(0.5),
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.purple,
                    ))
                : const SizedBox(),
            _isShowingSuccessAlert ? const ShowSuccessAlert() : const SizedBox()
          ],
        ));
  }
}
