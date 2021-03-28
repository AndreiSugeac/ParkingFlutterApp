import 'package:flutter/material.dart';
import 'package:sharp_parking_app/utils/colors.dart';

class LocationIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return 
      Container(
          child: Icon(Icons.location_on, color: pinkColor, size: 60),
          alignment: Alignment.center,
    );
  }
}