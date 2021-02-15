import 'package:flutter/material.dart';

class TransparentButton extends StatelessWidget {
  final String _btnText;
  final Widget _btnRoute;

  TransparentButton(this._btnText, this._btnRoute);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
        onPressed: () {
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => _btnRoute),
          );
        },
        color: Colors.transparent,
        child: Text(
          _btnText,
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}