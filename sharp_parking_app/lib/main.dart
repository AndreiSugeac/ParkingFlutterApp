import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:sharp_parking_app/screen/home.dart';
import 'package:sharp_parking_app/utils/colors.dart';
import 'package:sharp_parking_app/utils/secure_storage.dart';
import './screen/welcome.dart';

void main() => runApp(SharpApp());

class SharpApp extends StatelessWidget {

  Future<bool> userLogedIn() async {
    bool result = false;
    var token;
    Map<String, dynamic> payload;
    await SecureStorage.readSecureData('token').then((tkn) => token = tkn);

    if(token != null) {
      bool isExpired = Jwt.isExpired(token);
      if(!isExpired) {
        payload = Jwt.parseJwt(token);
        result = true;
      }
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool> (
      future: userLogedIn(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            theme: ThemeData(fontFamily: 'Roboto'),
            home: Scaffold(
              body: snapshot.data == true ? Home() : WelcomeScreen(),
            )
          );
        } else {
          return CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color> (primaryColor),
          );
        }
      }
    );
  }
}
