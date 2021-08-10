import 'package:flutter/material.dart';

import 'screens/wrapper.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
        colorScheme: const ColorScheme.light(
            primary: Colors.yellow,
            primaryVariant: Colors.black,
            onSurface: Colors.black,
            secondary: Colors.white,
            background: Colors.white60,
            onPrimary: Colors.black,
            secondaryVariant: Colors.white,
            error: Colors.red),
        textTheme: const TextTheme()
            .apply(bodyColor: Colors.black, displayColor: Colors.black)),
    home: Wrapper(),
    debugShowCheckedModeBanner: false,
  ));
}
