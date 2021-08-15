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
}
