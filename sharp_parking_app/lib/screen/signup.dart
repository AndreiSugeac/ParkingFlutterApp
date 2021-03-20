import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:sharp_parking_app/constants/buttons/long_button.dart';

import 'package:sharp_parking_app/constants/colors.dart';
import 'package:sharp_parking_app/constants/icons/sharp_icon.dart';
import 'package:sharp_parking_app/constants/toasts/success_toast.dart';
import 'package:sharp_parking_app/constants/toasts/warning_toast.dart';
import 'package:sharp_parking_app/screen/login.dart';
import 'package:sharp_parking_app/services/user_services.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  // Response of the sign up request
  bool response;

  // Form validtion
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPassController = TextEditingController();

  RegExp emailRegEx = new RegExp(
    r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
    caseSensitive: false,
    multiLine: false,
  );

  @override
  void initState() {
    super.initState();

    _firstNameController.addListener(_validateField);
    _lastNameController.addListener(_validateField);
    _emailController.addListener(_validateField);
    _passwordController.addListener(_validateField);
    _confirmPassController.addListener(_validateField);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  _validateField() {
    _form.currentState.validate();
  }

  Future<bool> register() async { 
    try {
      await UserServices().register(_firstNameController.text, _lastNameController.text, 
                                    _emailController.text, _passwordController.text).then((val) {
        if(val != null && val.data['success']) {
          response = val.data['success'];
          SuccessToast('User registered successfully!').showToast();
        } else {
          response = val.data['success'];
          WarningToast('User could not be registered!').showToast();
        }
      });
      return response;
    } on DioError catch(err) {
      print(err.message);
      return false;
    }
  }

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
                      key: _form,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: _firstNameController,
                            validator: (val) {
                              if(_firstNameController.text.isEmpty) {
                                return '* mandatory';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'First name',
                              focusColor: primaryColor,
                              hintText: 'Enter your first name',
                            ),
                          ),
                          SizedBox(height: 0.02 * size.height),
                          TextFormField(
                            controller: _lastNameController,
                            validator: (val) {
                              if(_lastNameController.text.isEmpty) {
                                return '* mandatory';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Last name',
                              focusColor: primaryColor,
                              hintText: 'Enter your last name',
                            ),
                          ),
                          SizedBox(height: 0.02 * size.height),
                          TextFormField(
                            controller: _emailController,
                            validator: (val) {
                              if(_emailController.text.isEmpty) {
                                return '* mandatory';
                              }
                              if(!emailRegEx.hasMatch(_emailController.text)) {
                                return 'Email address not valid!';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Email',
                              focusColor: primaryColor,
                              hintText: 'Enter your email',
                            ),
                          ),
                          SizedBox(height: 0.02 * size.height),
                          TextFormField(
                            controller: _passwordController,
                            validator: (val) {
                              if(_passwordController.text.isEmpty) {
                                return "* mandatory";
                              }
                              return null;
                            },
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              focusColor: primaryColor,
                              hintText: 'Enter a password',
                            ),
                          ),
                          SizedBox(height: 0.02 * size.height),
                          TextFormField(
                            controller: _confirmPassController,
                            validator: (val) {
                              if(_confirmPassController.text.isEmpty){
                                return "* mandatory";
                              }
                              else if(_confirmPassController.text != _passwordController.text) {
                                return "Password and Confirm Password not matching!";
                              }
                              return null;
                            },
                            obscureText: true,
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
                LongButton('SING UP', primaryColor, Login(), true, register),
              ],
            ),
          ),
        ),
      ),
    );
  }
}