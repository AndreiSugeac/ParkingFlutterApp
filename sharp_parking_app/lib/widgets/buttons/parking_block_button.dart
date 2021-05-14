import 'package:flutter/material.dart';
import 'package:sharp_parking_app/utils/colors.dart';

class ParkingBlockButton extends StatelessWidget {
  final Widget _btnIcon;
  final dynamic _btnAction;
  final bool _isEnabled;

  ParkingBlockButton(this._btnIcon, this._btnAction, this._isEnabled);

  // Button styles
  final ButtonStyle raisedBtnStyle = ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30)
    ),
    padding: EdgeInsets.all(0.0),
  );
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: 0.26 * size.width,
      height: 0.14 * size.height,
      child: ElevatedButton(
        onPressed: _isEnabled ? () => {
          _btnAction()
        } : () => {},
        style: raisedBtnStyle,
        child: Ink(
          decoration: BoxDecoration(
            gradient: _isEnabled ? LinearGradient(colors: [primaryColor, secondaryGradientColor],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ) : LinearGradient(colors: [Colors.grey.shade300, Colors.grey.shade500],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(20)
          ),
          child: _btnIcon,
        ),
      ),
    );
  }
}