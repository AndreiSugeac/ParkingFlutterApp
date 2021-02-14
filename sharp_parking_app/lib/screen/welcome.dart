import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:sharp_parking_app/constants/colors.dart';
import './login.dart';
import './signup.dart';


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
              fontWeight: FontWeight.w700,
              fontSize: 20,
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
        ),
        Container(
          width: 0.75 * size.width,
          child: RaisedButton(
            onPressed: () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
            child: Text(
              'SIGN IN',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
            color: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
            ),
          ),
        ),
        Container(
          child: FlatButton(
            onPressed: () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignUp()),
              );
            },
            color: Colors.transparent,
            child: Text(
              'CREATE A NEW ACCOUNT',
              style: TextStyle(color: Colors.black),
            ),
          ),
        )
      ],
    );
  }
}