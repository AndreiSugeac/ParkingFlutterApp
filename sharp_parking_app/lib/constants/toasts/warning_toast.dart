
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class WarningToast {
  final String _message;

  WarningToast(this._message);

  Future<bool> showToast() {
   return Fluttertoast.showToast(
      msg: _message,
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 5, 
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16
    );
  }
}
