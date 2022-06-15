import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:sharp_parking_app/utils/colors.dart';
import 'package:sharp_parking_app/widgets/buttons/long_button.dart';
import 'package:sharp_parking_app/widgets/icons/sharp_icon.dart';
import 'package:sharp_parking_app/widgets/toasts/success_toast.dart';
import 'package:sharp_parking_app/widgets/toasts/warning_toast.dart';
import 'package:sharp_parking_app/screen/login.dart';
import 'package:sharp_parking_app/services/user_services.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  // Response of the sign up request
  bool response;

  bool isButtonDisabled = true;

  // Form validtion
  final GlobalKey<FormState> _firstForm = GlobalKey<FormState>();

  // first page controllers
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

  // second page controllers
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _firstNameController.addListener(_validateFirstPageFields);
    _lastNameController.addListener(_validateFirstPageFields);
    _emailController.addListener(_validateFirstPageFields);
    _passwordController.addListener(_validateFirstPageFields);
    _confirmPassController.addListener(_validateFirstPageFields);
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
    _brandController.dispose();
    _modelController.dispose();
    super.dispose();
  }

  _validateFirstPageFields() {
    var res = _firstForm.currentState.validate();
    isButtonDisabled = !res;
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
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          resizeToAvoidBottomInset: false,
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
                      child: buildFirstPage(size),
                    ),
                  ),
                  // Container(
                  //   margin: EdgeInsets.only(bottom: 30),
                  //   child: Row(
                  //     mainAxisSize: MainAxisSize.min,
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: <Widget>[
                  //       for (int i = 1; i < 3; i++)
                  //         PageIndicator(i == pageNr),
                  //     ],
                  //   ),
                  // ),
                ]
              )
            )
          )
        )
      )
    );
  }

  Widget buildFirstPage(size) {
    return  Form(
      key: _firstForm,
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
          SizedBox(height: 0.05 * size.height),
          LongButton('SIGN UP', primaryColor, Login(), true, register),
        ],
      ),
    );
  }

  // Widget buildSecondPage(size) {
  //   return Form(
  //     key: _secondForm,
  //     child: Column(
  //       children: <Widget>[
  //         TextFormField(
  //           controller: _brandController,
  //           validator: (val) {
  //             if(_brandController.text.isEmpty) {
  //               return '* mandatory';
  //             }
  //             return null;
  //           },
  //           decoration: InputDecoration(
  //             labelText: 'Car brand',
  //             focusColor: primaryColor,
  //             hintText: 'Enter your car brand',
  //           ),
  //         ),
  //         SizedBox(height: 0.02 * size.height),
  //         TextFormField(
  //           controller: _modelController,
  //           validator: (val) {
  //             if(_modelController.text.isEmpty) {
  //               return '* mandatory';
  //             }
  //             return null;
  //           },
  //           decoration: InputDecoration(
  //             labelText: 'Car model',
  //             focusColor: primaryColor,
  //             hintText: 'Enter your car model',
  //           ),
  //         ),
  //         SizedBox(height: 0.02 * size.height),
  //         TextFormField(
  //           controller: _licensePlateController,
  //           validator: (val) {
  //             if(_licensePlateController.text.isEmpty) {
  //               return '* mandatory';
  //             }
  //             return null;
  //           },
  //           decoration: InputDecoration(
  //             labelText: 'License plate',
  //             focusColor: primaryColor,
  //             hintText: 'Enter your car\'s license plate',
  //           ),
  //         ),
  //         SizedBox(height: 0.02 * size.height),
  //         TextFormField(
  //           controller: _colorController,
  //           validator: (val) {
  //             if(_colorController.text.isEmpty) {
  //               return "* mandatory";
  //             }
  //             return null;
  //           },
  //           decoration: InputDecoration(
  //             labelText: 'Car color',
  //             focusColor: primaryColor,
  //             hintText: 'Enter the color of your car',
  //           ),
  //         ),
  //         SizedBox(height: 0.05 * size.height),
  //         LongButton('SIGN UP', primaryColor, Login(), true, register),
  //         SizedBox(height: 0.0075 * size.height),
  //         Container(
  //           padding: EdgeInsetsDirectional.only(top: 5, bottom: 15),
  //           alignment: Alignment.center,
  //           child: TextButton(
  //             onPressed: () => {
  //               setState(() {
  //                   pageNr = 1;
  //                   _brandController.clear();
  //                   _modelController.clear();
  //                   _licensePlateController.clear();
  //                   _colorController.clear();
  //                 })
  //             }, 
  //             child: Text(
  //               'Back',
  //               textAlign: TextAlign.center,
  //               style: TextStyle(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.w500,
  //                 color: Colors.black87,
  //               ),
  //             )
  //           )
  //         )
  //       ],
  //     ),
  //   );
  // }
}