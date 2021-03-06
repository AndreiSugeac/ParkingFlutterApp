import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:sharp_parking_app/DTO/User.dart';
import 'package:sharp_parking_app/screen/login.dart';
import 'package:sharp_parking_app/utils/secure_storage.dart';
import 'package:sharp_parking_app/utils/url.dart';
import 'package:sharp_parking_app/widgets/toasts/warning_toast.dart';
 
class UserServices {
  Dio dio = new Dio();
  String url = Url.serverURL; // contine ip adress ul de la Rosetti

  Future<Response> register(firstName, lastName, email, password) async {
    try {
      final response =  await dio.post(url + '/register/user', data: {
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "password": password
      }, options: Options(contentType: Headers.formUrlEncodedContentType));
      return response;
    }
    on DioError catch(err) {
      var warning = WarningToast(err.response.data['msg']);
      warning.showToast();
      return null;
    }
  }

  authenticate(email, password) async {
    try {
      return await dio.post(url + '/authenticate/user', data: {
        "email": email,
        "password": password
      }, options: Options(contentType: Headers.formUrlEncodedContentType));
    }
    on DioError catch(err) {
      var warning = WarningToast(err.response.data['msg']);
      warning.showToast();
    }
  }

  static void logout(context) async {
    try {
      var res = await SecureStorage.deleteAllSecureData();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (BuildContext context) => Login()), 
          (Route<dynamic> route) => false);
    } catch (err) {
      var warning = WarningToast(err.response.data['msg']);
      warning.showToast();
    }
  }

  getAllUsers() async {
    // make GET request
    try{
      return await dio.get(url, options: Options(contentType: Headers.formUrlEncodedContentType));
    }
    on DioError catch(err) {
      var warning = WarningToast(err.response.statusMessage);
      warning.showToast();
    }
  }

  Future<Response> addParkingSpotForUser(userId, parkingSpotId) async {
    try {
      final response =  await dio.put(url + '/update/user/parkingSpot/' + userId.toString() + '/' + parkingSpotId.toString(), options: Options(contentType: Headers.formUrlEncodedContentType));
      return response;
    }
    on DioError catch(err) {
      var warning = WarningToast(err.response.data['msg']);
      warning.showToast();
      return null;
    }
  }

  Future<User> tokenToUser() async {
    return User.fromJson(Jwt.parseJwt(await SecureStorage.readSecureData('token')));
  }
}