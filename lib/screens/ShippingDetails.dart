// ignore_for_file: file_names

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:collection/src/list_extensions.dart';

import 'package:flutter/material.dart';
import 'package:meraketme/screens/AddressEdit.dart';
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
        child: FutureBuilder(
            future: FireStoreServices().getShippingDetails(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Could not load data.'),
                );
              }
              if (snapshot.hasData) {
                var snapMap = snapshot.data as List<Map>;
                return ListView(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    ...(snapMap.mapIndexed((index, element) {
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
                        leading: const Icon(
                          Icons.home,
                          size: 30,
                        ),
                        title: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              element['data']['street'].toString(),
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w500),
                              overflow: TextOverflow.clip,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              element['data']['doorNum'].toString() +
                                  '\n' +
                                  element['data']['aptName'].toString() +
                                  '\nApt Num: ' +
                                  element['data']['aptNum'].toString(),
                              style: const TextStyle(fontSize: 17),
                              overflow: TextOverflow.clip,
                            )
                          ],
                        ),
                        trailing: const Icon(Icons.navigate_next_rounded),
                      ));
                    }).toList())
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
