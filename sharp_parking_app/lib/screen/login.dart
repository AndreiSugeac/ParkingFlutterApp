import 'package:flutter/material.dart';

import 'package:sharp_parking_app/constants/sharp_icon.dart';
import 'package:sharp_parking_app/constants/colors.dart';
import 'package:sharp_parking_app/constants/buttons/long_button.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FocusNode passwordFocusNode = new FocusNode();

    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: <Widget>[
            SizedBox(height: 50),
            IconSharP(),
            Container(
              child: Text(
                'Log In',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                )
              ),
              alignment: Alignment.center,
            ),
            SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(40, 50, 40, 20),
              child: Theme(
                data: ThemeData(
                  fontFamily: 'Roboto',
                  primaryColor: primaryColor,
                ),
                child: Form(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                          focusColor: primaryColor,
                          hintText: 'Enter email',
                        ),
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        focusNode: passwordFocusNode,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          focusColor: primaryColor,
                          hintText: 'Enter your password',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              child: FlatButton(
                onPressed: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
                color: Colors.transparent,
                child: Text(
                  'Forgot your password?',
                  style: TextStyle(color: primaryColor),
                ),
              ),
              alignment: Alignment.topRight,
              padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
            ),
            Container(
              child: CheckboxListTile(
                value: false, 
                onChanged: null,
                checkColor: Colors.white,
                activeColor: primaryColor,
                title: Text(
                  'Keep me signed in',
                ),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.fromLTRB(40, 0, 30, 0),
              ),
              alignment: Alignment.center,
            ),
            LongButton('SIGN IN', primaryColor, Login()),
          ],
        ),
      )
    );
  }
}