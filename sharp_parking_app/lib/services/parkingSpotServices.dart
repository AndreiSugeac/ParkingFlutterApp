import 'package:dio/dio.dart';
import 'package:sharp_parking_app/widgets/toasts/warning_toast.dart';

class ParkingSpotServices {
  Dio dio = new Dio();
  // String url = 'http://10.0.2.2:3000';
  String url = 'http://192.168.1.12:3000'; // contine ip adress ul de acasa de la Stupini
  // String url = 'http://192.168.0.107:3000'; // contine ip adress ul de la Rosetti

  getParkingSpotById(id) async {
    try {
      final parkingSpot = await dio.get(url + '/parkingSpot/get/' + id, options: Options(contentType: Headers.formUrlEncodedContentType));

      return parkingSpot;
    } on DioError catch(err) {
      var warning = WarningToast(err.response.data['msg']);
      warning.showToast();
      return null;
    }
  }

  addParkingSpot(latitude, longitude, macAddress, serviceUUID, characteristicUUID) async {
    try {
      final parkingSpot = await dio.post(url + '/parkingSpot/add', data: {
        "latitude": latitude,
        "longitude": longitude,
        "macAddress": macAddress,
        "serviceUUID": serviceUUID,
        "characteristicUUID": characteristicUUID
      }, options: Options(contentType: Headers.formUrlEncodedContentType));
      return parkingSpot;
    } on DioError catch(err) {
      var warning = WarningToast(err.response.data['msg']);
      warning.showToast();
      return null;
    }
  }
}