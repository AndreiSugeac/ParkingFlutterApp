import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        Container(
          width: 0.25 * size.width,
          height: 0.15 * size.height,
          child: SvgPicture.asset('assets/icons/SharPLogo.svg'),
          alignment: Alignment.center,
        ),
        Container(
          child: Text(
            'Welcome',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
            )
          ),
          alignment: Alignment.center,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(45),
            child: Text(
              'Some say that sharing is caring, so that\'s why we are delighted to indroduce you to SharP, our modern solution for a well known problem. That\'s right, SharP is a park sharing system which makes every user able to share their parking spots with eachother, by using smart parking blocks that can be accessed only by other users of SharP.',
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
              style: TextStyle(color: Color.fromRGBO(112, 112, 112, 1)),
            ),
          ),
        )
      ],
    );
  }
}