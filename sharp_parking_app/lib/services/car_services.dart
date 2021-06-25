import 'package:dio/dio.dart';
import 'package:sharp_parking_app/utils/url.dart';
import 'package:sharp_parking_app/widgets/toasts/warning_toast.dart';

class CarServices {
  Dio dio = new Dio();
  String url = Url.serverURL;

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