import 'package:flutter/material.dart';

class TransparentButton extends StatelessWidget {
  final String _btnText;
  final Widget _btnRoute;

  TransparentButton(this._btnText, this._btnRoute);

  // Button style
  final ButtonStyle transparentBtnStyle = TextButton.styleFrom(
    backgroundColor: Colors.transparent,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        onPressed: () {
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => _btnRoute),
          );
        },
        child: Text(
          _btnText,
          style: TextStyle(color: Colors.black),
        ),
        style: transparentBtnStyle,
      ),
    );
  }
}