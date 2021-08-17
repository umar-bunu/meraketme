// ignore_for_file: file_names

import 'package:flutter/material.dart';

class ShowSuccessAlert extends StatefulWidget {
  const ShowSuccessAlert({Key? key}) : super(key: key);

  @override
  _ShowSuccessAlertState createState() => _ShowSuccessAlertState();
}

class _ShowSuccessAlertState extends State<ShowSuccessAlert> {
  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.white.withOpacity(0.5),
      child: Align(
        alignment: Alignment.center,
        child: Container(
            height: _width * 0.7 < 200 ? _width * 0.7 : 200,
            width: _width * 0.7 < 200 ? _width * 0.7 : 200,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: SizedBox(
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.thumb_up,
                    size: 70,
                    color: Colors.purple,
                  ),
                  Text('Done')
                ],
              ),
            )),
      ),
    );
  }
}
