// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FireStoreServices {
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
        var _query2 = await FirebaseFirestore.instance
            .collection('foods')
            .doc(element.data()['item'])
            .get();
        var _mappedResult = _query2.data();
        _mappedResult!.addAll(element.data());
        _docs.add({'id': element.id, 'data': _mappedResult});
      }
      debugPrint(_docs.toString());

      return _docs;
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      return Future.error(e.code);
    }
  }
}
