import 'package:flutter/material.dart';
import './screen/welcome.dart';

void main() => runApp(SharpApp());

class SharpApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Roboto'),
      home: Scaffold(
        body: WelcomeScreen(),
      )
    );
  }
}
