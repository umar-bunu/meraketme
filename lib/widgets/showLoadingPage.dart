// ignore_for_file: file_names

import 'package:flutter/material.dart';

class ShowLoadingPage extends StatefulWidget {
  ShowLoadingPage({Key? key}) : super(key: key);

  @override
  _ShowLoadingPageState createState() => _ShowLoadingPageState();
}

class _ShowLoadingPageState extends State<ShowLoadingPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.white.withOpacity(0.5),
      alignment: Alignment.center,
      child: const CircularProgressIndicator(
        color: Colors.purple,
      ),
    );
  }
}
