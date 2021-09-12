// ignore_for_file: file_names

import 'package:flutter/material.dart';

class Products extends StatefulWidget {
  const Products({Key? key}) : super(key: key);

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: FutureBuilder(
          future: null,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            if (snapshot.hasData) {
              var snapMap = snapshot.data as Map;
              return ListView(
                children: [],
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [Text('loading')],
              );
            }
          },
        ));
  }
}
