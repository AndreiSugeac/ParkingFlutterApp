import 'package:flutter/material.dart';

class LongButton extends StatelessWidget {
  final Color _btnColor;
  final String _btnText;
  final Widget _btnRoute;
  final bool _isBtnActive;
  final Function _btnAction;

  LongButton(this._btnText, this._btnColor, this._btnRoute, this._isBtnActive, this._btnAction);
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: 0.75 * size.width,
      height: 0.06 * size.height,
      child: RaisedButton(
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
        color: _btnColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
      ),
    );
  }
}