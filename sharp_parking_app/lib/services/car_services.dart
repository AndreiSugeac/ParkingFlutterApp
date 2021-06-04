import 'package:dio/dio.dart';
import 'package:sharp_parking_app/widgets/toasts/warning_toast.dart';

class CarServices {
  Dio dio = new Dio();
  //String url = 'http://10.0.2.2:3000';
  String url = 'http://192.168.1.12:3000'; // contine ip adress ul de acasa de la Stupini
  // String url = 'http://192.168.0.107:3000'; // contine ip adress ul de la Rosetti

  insertCar(brand, model, licensePlate, color) async {
    try {
      final response = await dio.post(url + '/cars/add', data: {
        "brand": brand,
        "model": model,
        "licensePlate": licensePlate,
        "color": color
      }, options: Options(contentType: Headers.formUrlEncodedContentType));
      return response;
    } on DioError catch(err) {
      var warning = WarningToast(err.response.data['msg']);
      warning.showToast();
      return null;
    }
  }

  getCarById(id) async {
    try {
      final car = await dio.get(url + '/cars/get/' + id, options: Options(contentType: Headers.formUrlEncodedContentType));

      return car;
    } on DioError catch(err) {
      var warning = WarningToast(err.response.data['msg']);
      warning.showToast();
      return null;
    }
  }
}