import 'package:flutter/material.dart';
import 'package:sharp_parking_app/constants/buttons/long_button.dart';

import 'package:sharp_parking_app/constants/colors.dart';
import 'package:sharp_parking_app/constants/icons/sharp_icon.dart';

class SignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
          reverse: true,
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              children: <Widget>[
                SizedBox(height: 0.07 * size.height),
                IconSharP(),
                Container(
                  child: Text(
                    'Create an account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    )
                  ),
                  alignment: Alignment.center,
                ),
                Container(
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
                              labelText: 'First name',
                              focusColor: primaryColor,
                              hintText: 'Enter your first name',
                            ),
                          ),
                          SizedBox(height: 0.02 * size.height),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Last name',
                              focusColor: primaryColor,
                              hintText: 'Enter your last name',
                            ),
                          ),
                          SizedBox(height: 0.02 * size.height),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Email',
                              focusColor: primaryColor,
                              hintText: 'Enter your email',
                            ),
                          ),
                          SizedBox(height: 0.02 * size.height),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Password',
                              focusColor: primaryColor,
                              hintText: 'Enter a password',
                            ),
                          ),
                          SizedBox(height: 0.02 * size.height),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Confirm password',
                              focusColor: primaryColor,
                              hintText: 'Enter again the password',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 0.05 * size.height),
                LongButton('SING UP', primaryColor, SignUp()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}