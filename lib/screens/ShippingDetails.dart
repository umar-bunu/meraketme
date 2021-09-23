// ignore_for_file: file_names

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/src/list_extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:meraketme/screens/AddressEdit.dart';
import 'package:meraketme/screens/addAddress.dart';
import 'package:meraketme/services/FireStoreServices.dart';
import 'package:meraketme/services/OtherServices.dart';

class ShippingDetails extends StatefulWidget {
  const ShippingDetails({Key? key}) : super(key: key);

  @override
  _ShippingDetailsState createState() => _ShippingDetailsState();
}

class _ShippingDetailsState extends State<ShippingDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.purple),
      ),
      body: Container(
        alignment: Alignment.center,
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('shippingDetails')
                .doc(FirebaseAuth.instance.currentUser!.email)
                .collection('locations')
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Could not load data.'),
                );
              }
              if (snapshot.hasData) {
                var snapMapTemp = snapshot.data as QuerySnapshot;
                var snapMap = snapMapTemp.docs
                    .map((doc) => ({'id': doc.id, 'data': doc.data()}));
                return ListView(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    ...(snapMap.map((element) {
                      Map elementMap = element as Map;
                      return Card(
                          child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddressEdit(
                                        addRessData: element,
                                      )));
                        },
                        leading: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.home,
                              size: 30,
                            )
                          ],
                        ),
                        title: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              elementMap['data']['street'].toString(),
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                              overflow: TextOverflow.clip,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              elementMap['data']['doorNum'].toString() +
                                  '\n' +
                                  elementMap['data']['aptName'].toString() +
                                  '\nApt Num: ' +
                                  elementMap['data']['aptNum'].toString(),
                              style: const TextStyle(fontSize: 17),
                              overflow: TextOverflow.clip,
                            )
                          ],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [Icon(Icons.navigate_next_rounded)],
                        ),
                      ));
                    }).toList()),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.deepPurple),
                              padding: MaterialStateProperty.resolveWith(
                                  (states) =>
                                      const EdgeInsets.symmetric(vertical: 5))),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const AddAddress()));
                          },
                          child: const Icon(
                            Icons.add_box_rounded,
                            size: 30,
                          )),
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                );
              }
              return Center(
                child: AnimatedTextKit(
                  repeatForever: true,
                  animatedTexts: [
                    FadeAnimatedText('Loading...',
                        textStyle: const TextStyle(fontSize: 22)),
                    FadeAnimatedText('Please wait...',
                        textStyle: const TextStyle(fontSize: 22))
                  ],
                ),
              );
            }),
      ),
    );
  }
}
