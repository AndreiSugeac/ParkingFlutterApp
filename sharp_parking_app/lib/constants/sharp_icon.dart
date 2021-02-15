import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconSharP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return 
      Container(
          width: 0.25 * size.width,
          height: 0.15 * size.height,
          child: SvgPicture.asset('assets/icons/SharPLogo.svg'),
          alignment: Alignment.center,
    );
  }
}