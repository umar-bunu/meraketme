// ignore_for_file: camel_case_types

import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

  List _toppings = [];
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
  void initState() {
    super.initState();
    setState(() {
      _toppings = widget.selectedFood['data']['toppings'].keys
          .map((key) => {'key': key, 'isSelected': false})
          .toList();
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
                          const Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Text(
                              'Pieces',
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (_noOfItems > 1) {
                                setState(() {
                                  _noOfItems -= 1;
                                });
                              }
                            },
                            child: const Icon(
                              Icons.arrow_back_ios_new,
                              size: 17,
                            ),
                          ),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: SizedBox(
                                width: 30,
                                child: Text(
                                  _noOfItems.toString(),
                                  textAlign: TextAlign.center,
                                ),
                              )),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _noOfItems = _noOfItems + 1;
                              });
                            },
                            child: const Icon(
                              Icons.arrow_forward_ios,
                              size: 17,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                        child: Divider(
                          color: Colors.grey[850],
                        ),
                      ),
                      SizedBox(
                        width: _width,
                        height: 50,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: _toppings.length,
                            itemBuilder: (context, index) {
                              return Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    color: _toppings[index]['isSelected']
                                        ? Colors.green.withOpacity(0.1)
                                        : Colors.red.withOpacity(0.1),
                                    border: const Border(
                                        bottom: BorderSide(
                                            color: Colors.black, width: 0.5))),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _toppings[index] = {
                                        'key': _toppings[index]['key'],
                                        'isSelected': !_toppings[index]
                                            ['isSelected']
                                      };
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      SizedBox(
                                          width: 80,
                                          child: Text(
                                            _toppings[index]['key'],
                                            style:
                                                const TextStyle(fontSize: 16),
                                            overflow: TextOverflow.ellipsis,
                                          )),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Icon(_toppings[index]['isSelected']
                                          ? Icons.cancel_outlined
                                          : Icons.add)
                                    ],
                                  ),
                                ),
                              );
                            }),
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
                                    'id': widget.selectedFood['id'],
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
                                        ['restaurant'],
                                    'toppings': _toppings
                                        .where(
                                            (element) => element['isSelected'])
                                        .toList()
                                  }
                                ];
                                await _storage.setItem(
                                    'cartItems', currentItems);
                              } else {
                                currentItems.add({
                                  'id': widget.selectedFood['id'],
                                  'messageToSeller': _messageToSeller,
                                  'picture': widget.selectedFood['data']
                                      ['picture'],
                                  'name': widget.selectedFood['data']['name'],
                                  'price': widget.selectedFood['data']['price'],
                                  'quantity': _noOfItems,
                                  'vendor': widget.selectedFood['data']
                                      ['vendor'],
                                  'restaurant': widget.selectedFood['data']
                                      ['restaurant'],
                                  'toppings': _toppings
                                      .where((element) => element['isSelected'])
                                      .toList()
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
