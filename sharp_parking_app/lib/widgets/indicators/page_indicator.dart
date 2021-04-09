import 'package:flutter/material.dart';
import 'package:sharp_parking_app/utils/colors.dart';

class PageIndicator extends StatefulWidget {
  bool isActive;

  PageIndicator(this.isActive);

  @override
  _PageIndicatorState createState() => _PageIndicatorState();
}

class _PageIndicatorState extends State<PageIndicator> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      height: widget.isActive ? 12 : 10,
      width: widget.isActive ? 12 : 10,
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: widget.isActive ? primaryColor : Colors.purple.shade100,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}