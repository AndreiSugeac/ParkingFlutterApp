import 'package:flutter/material.dart';
import 'package:sharp_parking_app/utils/colors.dart';

class PageLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: CircularProgressIndicator(
                strokeWidth: 7.5,
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              )
            )
          ]
        )
      )
    );
  }
}