// ignore_for_file: file_names

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meraketme/services/FireStoreServices.dart';
import 'package:meraketme/widgets/showLoadingPage.dart';
import 'package:meraketme/widgets/showSuccessAlert.dart';

class ExpanedFoodToOrder extends StatefulWidget {
  final foodItem;
  final screenHeight;
  final screenwidth;
  const ExpanedFoodToOrder(
      {Key? key, required this.foodItem, this.screenHeight, this.screenwidth})
      : super(key: key);

  @override
  _ExpanedFoodToOrderState createState() => _ExpanedFoodToOrderState();
}

class _ExpanedFoodToOrderState extends State<ExpanedFoodToOrder> {
  bool _isloading = false;
  bool _isShowingSuccessMessage = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: widget.screenHeight * 0.70,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CachedNetworkImage(
                imageUrl: widget.foodItem['data']['picture'],
                imageBuilder: (context, imageProvider) => Image(
                  image: imageProvider,
                ),
                placeholder: (context, url) {
                  debugPrint(url);
                  return const CircularProgressIndicator();
                },
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              Text(
                widget.foodItem['data']['item'],
                style: const TextStyle(fontSize: 18),
                overflow: TextOverflow.ellipsis,
              ),
              Text('By ' + widget.foodItem['data']['vendorName']),
              const Divider(
                thickness: 1.0,
                color: Colors.purple,
              ),
              Text(
                'Total Price: N' +
                    (double.parse(widget.foodItem['data']['price']) *
                            double.parse(widget.foodItem['data']['quantity']))
                        .toString(),
                style: const TextStyle(fontSize: 18.5),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'Quantity: ' + widget.foodItem['data']['quantity'],
                style: const TextStyle(fontSize: 17),
              ),
              Text('Message To vendor: ' +
                  widget.foodItem['data']['messagetoSeller']),
              ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      _isloading = true;
                    });
                    try {
                      await FireStoreServices()
                          .makeOrderFromHistory(widget.foodItem);

                      setState(() {
                        _isloading = false;
                        _isShowingSuccessMessage = true;
                      });
                      Timer(Duration(seconds: 3), () {
                        setState(() {
                          _isShowingSuccessMessage = false;
                        });
                      });
                    } catch (e) {
                      setState(() {
                        _isloading = false;
                      });
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                title: const Text('Oops'),
                                content: Text(
                                    e.toString() + '\n Please try again later'),
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
                  child: const Text(
                    'Order with same details',
                    style: TextStyle(fontSize: 17),
                  )),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
        _isloading ? ShowLoadingPage() : const SizedBox(),
        _isShowingSuccessMessage ? const ShowSuccessAlert() : const SizedBox()
      ],
    );
  }
}
