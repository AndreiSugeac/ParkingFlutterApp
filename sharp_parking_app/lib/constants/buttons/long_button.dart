import 'package:flutter/material.dart';
import 'package:sharp_parking_app/constants/colors.dart';

class LongButton extends StatelessWidget {
  final Color _btnColor;
  final String _btnText;
  final Widget _btnRoute;
  final bool _isBtnActive;
  final Function _btnAction;

  LongButton(this._btnText, this._btnColor, this._btnRoute, this._isBtnActive, this._btnAction);

  // Button styles
  final ButtonStyle raisedBtnStyle = ElevatedButton.styleFrom(
    primary: primaryColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(7),
    ),
  );
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: 0.75 * size.width,
      height: 0.06 * size.height,
      child: ElevatedButton(
        onPressed: _isBtnActive ? () async {
          var response = await _btnAction();
          if(response == true) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => _btnRoute),
            );
          }
        } : null,
        child: Text(
          _btnText,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
        style: raisedBtnStyle,
      ),
    );
  }
}