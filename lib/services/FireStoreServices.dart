// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

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
      var _query = await FirebaseFirestore.instance
          .collection('orderHistory')
          .where('email', isEqualTo: user)
          .get();
      List _docs =
          _query.docs.map((e) => {'id': e.id, 'data': e.data()}).toList();
      return _docs;
    } on FirebaseException catch (e) {
      return Future.error(e.code);
    }
  }
}
