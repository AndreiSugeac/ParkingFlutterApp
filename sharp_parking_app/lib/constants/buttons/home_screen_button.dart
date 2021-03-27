import 'package:flutter/material.dart';
import 'package:sharp_parking_app/constants/colors.dart';

class HomeScreenBtn extends StatelessWidget {
  final Widget _btnIcon;
  final dynamic _btnRoute;

  HomeScreenBtn(this._btnIcon, this._btnRoute);

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
      width: 0.23 * size.width,
      height: 0.17 * size.height,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => _btnRoute),
            );
        },
        style: raisedBtnStyle,
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [primaryColor, secondaryGradientColor],
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