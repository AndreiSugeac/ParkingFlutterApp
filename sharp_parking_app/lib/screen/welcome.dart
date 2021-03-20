import 'package:flutter/material.dart';

import 'package:sharp_parking_app/constants/colors.dart';
import './login.dart';
import './signup.dart';
import 'package:sharp_parking_app/constants/icons/sharp_icon.dart';
import 'package:sharp_parking_app/constants/buttons/long_button.dart';
import 'package:sharp_parking_app/constants/buttons/transparent_button.dart';

class WelcomeScreen extends StatelessWidget {
  
  bool next() {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        SizedBox(height: 0.07 * size.height),
        IconSharP(),
        Container(
          child: Text(
            'Welcome',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
            )
          ),
          alignment: Alignment.center,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(45, 45, 45, 0),
            child: Text(
              'Some say that sharing is caring, so that\'s why we are delighted to indroduce you to SharP, our modern solution for a well known problem. That\'s right, SharP is a park sharing system which makes every user able to share their parking spots with eachother, by using smart parking blocks that can be accessed only by other users of SharP.',
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
              style: TextStyle(color: greyColor),
            ),
          ),
        ),
        LongButton('SIGN IN', primaryColor, Login(), true, next),
        TransparentButton('CREATE NEW ACCOUNT', SignUp()),
      ],
    );
  }
}