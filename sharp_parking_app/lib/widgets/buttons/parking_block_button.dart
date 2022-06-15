import 'package:flutter/material.dart';
import 'package:sharp_parking_app/utils/colors.dart';

class ParkingBlockButton extends StatelessWidget {
  final int parkingSpotId;
  final bool available;
  final Widget _btnIcon;
  final dynamic _btnAction;
  final bool _isEnabled;
  final Color color;

  ParkingBlockButton(this.parkingSpotId, this.available, this._btnIcon, this._btnAction, this._isEnabled, this.color);

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
          _btnAction(this.parkingSpotId, this.available)
        } : () => {},
        style: raisedBtnStyle,
        child: Ink(
          decoration: BoxDecoration(
            color: this.color,
            borderRadius: BorderRadius.circular(20)
          ),
          child: _btnIcon,
        ),
      ),
    );
  }
}