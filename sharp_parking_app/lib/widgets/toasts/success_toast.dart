import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SuccessToast {
  final String _message;

  SuccessToast(this._message);

  Future<bool> showToast() {
   return Fluttertoast.showToast(
      msg: _message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16
    );
  }
}