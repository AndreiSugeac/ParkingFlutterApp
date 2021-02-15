import 'package:flutter/material.dart';

class LongButton extends StatelessWidget {
  final Color _btnColor;
  final String _btnText;
  final Widget _btnRoute;

  LongButton(this._btnText, this._btnColor, this._btnRoute);
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: 0.75 * size.width,
      height: 0.06 * size.height,
      child: RaisedButton(
        onPressed: () {
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => _btnRoute),
          );
        },
        child: Text(
          _btnText,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
        color: _btnColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
      ),
    );
  }
}