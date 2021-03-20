import 'package:flutter/material.dart';

import 'package:sharp_parking_app/constants/icons/sharp_icon.dart';
import 'package:sharp_parking_app/constants/colors.dart';
import 'package:sharp_parking_app/constants/toasts/success_toast.dart';
import 'package:sharp_parking_app/constants/toasts/warning_toast.dart';
import 'package:sharp_parking_app/screen/home.dart';
import 'package:sharp_parking_app/services/user_services.dart';

class Login extends StatefulWidget {
  _Login createState() => _Login();
}

class _Login extends State<Login> {

  var token;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<String> authentication() async {
    var tkn;
    await UserServices().authenticate(_emailController.text, _passwordController.text).then((val) {
      if(val != null && val?.data['success']) {
        tkn = val.data['token'];
        SuccessToast('Welcome ' + _emailController.text).showToast();
      } else {
        WarningToast('User ' + _emailController.text + ' could not be authenticated!');
        tkn = null;
      }
    });
    return tkn;
  }

  @override
  Widget build(BuildContext context) {
    FocusNode passwordFocusNode = new FocusNode();
    Size size = MediaQuery.of(context).size;
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: <Widget>[
            SizedBox(height: 0.07 * size.height),
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
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          focusColor: primaryColor,
                          hintText: 'Enter email',
                        ),
                      ),
                      SizedBox(height: 0.035 * size.height),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
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
            // LongButton('SIGN IN', primaryColor, Home(token), true, authentication),
            Container(
              width: 0.75 * size.width,
              height: 0.06 * size.height,
              child: RaisedButton(
                onPressed: () async {
                  token = await authentication();
                  if(token != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Home(token)),
                    );
                  }
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
          ],
        ),
      )
    );
  }
}