// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class FireStoreServices {
  Future getRestaurantsByPopular(String state, String lga) async {
    try {
      var docsnap = await FirebaseFirestore.instance
          .collection('users')
          .where('isVendor', isEqualTo: 'true')
          .where('state', isEqualTo: state)
          .where('lga', isEqualTo: lga)
          .orderBy('hits')
          .get();
      List docs = docsnap.docs.map((e) => e.id).toList();

      List resDocs =
          docsnap.docs.map((e) => {'id': e.id, 'data': e.data()}).toList();
      if (docs.isEmpty) {
        return [];
      }
      docsnap = await FirebaseFirestore.instance
          .collection('foods')
          .where('vendor', whereIn: docs)
          .orderBy('orders', descending: true)
          .get();
      var docList = docsnap.docs
          .map((e) => {
                'id': e.id,
                'data': e.data(),
              })
          .toList();
      Map whatToReturn = {'foods': docList, 'restaurants': resDocs};
      return whatToReturn;
    } on FirebaseException catch (e) {
      return Future.error(e.code);
    }
  }

  Future getUserData(email) async {
    try {
      return await FirebaseFirestore.instance
          .collection('users')
          .doc(email)
          .get();
    } catch (e) {
      return {};
    }
  }

  Future getShippingDetails(user) async {
    var _query = await FirebaseFirestore.instance
        .collection('shippingDetails')
        .where('email', isEqualTo: user)
        .get();
    var _docs = _query.docs
        .map((element) => {'id': element.id, 'data': element.data()});
    return _docs.toList();
  }

  Future getOrderHistory(user) async {
    try {
      debugPrint('19');
      var _query = await FirebaseFirestore.instance
          .collection('orderHistory')
          .where('customer', isEqualTo: user)
          .get();
      List _docs = [];

      for (var element in _query.docs) {
        _docs.add({'id': element.id, 'data': element.data()});
      }

      return _docs;
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      return Future.error(e.code);
    }
  }

  Future placeOrder(var items) async {
    try {
      for (var itemData in items) {
        await FirebaseFirestore.instance.collection('orderHistory').add({
          'customer': FirebaseAuth.instance.currentUser!.email,
          'customerName': FirebaseAuth.instance.currentUser!.displayName,
          'isDelivered': false,
          'isMade': false,
          'item': itemData['id'],
          'name': itemData['name'],
          'messagetoSeller': itemData['messageToSeller'],
          'quantity': itemData['quantity'],
          'shouldSendAgain': true,
          'timeStamp': FieldValue.serverTimestamp(),
          'picture': itemData['picture'],
          'vendorName': itemData['restaurant'],
          'price': itemData['price'],
          'toppings': itemData['toppings']
              .map(
                (eachItem) => eachItem == itemData['toppings'].last
                    ? eachItem['key'].toString()
                    : eachItem['key'].toString() + ', ',
              )
              .toList()
              .toString()
        });
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  Future makeOrderFromHistory(var item) async {
    try {
      var itemToAdd = item;
      itemToAdd['shouldSendAgain'] = true;
      itemToAdd['timeStamp'] = FieldValue.serverTimestamp();
      itemToAdd['isMade'] = false;
      itemToAdd['isDelivered'] = false;
      await FirebaseFirestore.instance
          .collection('orderHistory')
          .add(itemToAdd);
    } on FirebaseException catch (e) {
      return Future.error(e.code);
    }
  }

  Future getRestaurants(String state, String lga) async {
    try {
      var _docs = await FirebaseFirestore.instance
          .collection('users')
          .where('isVendor', isEqualTo: 'true')
          .where('state', isEqualTo: state)
          .where('lga', isEqualTo: lga)
          .orderBy('hits')
          .get();
      List _restaurants =
          _docs.docs.map((e) => {'id': e.id, 'data': e.data()}).toList();
      for (int i = 0; i < 6; i++) {
        _restaurants.add(_restaurants[i]);
      }
      return _restaurants;
    } on FirebaseException catch (e) {
      return Future.error(e.code);
    }
  }

  Future getRestaurantDetails(String restaurant) async {
    try {
      var _docs = await FirebaseFirestore.instance
          .collection('foods')
          .where('vendor', isEqualTo: restaurant.toString())
          .get();
      List _restaurants =
          _docs.docs.map((e) => {'id': e.id, 'data': e.data()}).toList();
      for (int i = 0; i < 6; i++) {
        _restaurants.add(_restaurants[i]);
      }
      return _restaurants;
    } on FirebaseException catch (e) {
      return Future.error(e.code);
    }
  }
}
