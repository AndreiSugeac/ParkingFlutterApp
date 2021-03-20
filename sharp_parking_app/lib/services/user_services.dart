import 'package:dio/dio.dart';
import 'package:sharp_parking_app/constants/toasts/warning_toast.dart';
 
class UserServices {
  Dio dio = new Dio();
  String url = 'http://10.0.2.2:3000';

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
}