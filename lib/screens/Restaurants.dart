// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:meraketme/services/FireStoreServices.dart';

class Restaurants extends StatefulWidget {
  const Restaurants({Key? key}) : super(key: key);

  @override
  _RestaurantsState createState() => _RestaurantsState();
}

class _RestaurantsState extends State<Restaurants> {
  String _loadingError = '';
  List _restaurantList = [];
  Future _getRestaurants() async {
    try {
      var _tempList = await FireStoreServices().getRestaurants();

      for (var element in _tempList) {}
      setState(() {
        _loadingError = '';
      });
    } catch (e) {
      setState(() {
        _loadingError = e.toString();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getRestaurants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(),
    );
  }
}
