import 'package:dio/dio.dart';
import 'package:sharp_parking_app/widgets/toasts/warning_toast.dart';

class ParkingSpotServices {
  Dio dio = new Dio();
  // String url = 'http://10.0.2.2:3000';
  // String url = 'http://192.168.1.12:3000'; // contine ip adress ul de acasa de la Stupini
  String url = 'http://192.168.0.116:3000'; // contine ip adress ul de la Rosetti

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

  getAvailableParkingSpots() async {
    try {
      final parkingSpots = await dio.get(url + '/parkingSpot/available/get', options: Options(contentType: Headers.formUrlEncodedContentType));

      return parkingSpots;
    } on DioError catch(err) {
      var warning = WarningToast(err.response.data['msg']);
      warning.showToast();
      return null;
    }
  }

  updateAvailability(parkingSpotId, available) async {
    try {
      final spot = await dio.put(url + '/update/available/parkingSpot', data: {
        "parkingSpotId": parkingSpotId,
        "available": available
      }, options: Options(contentType: Headers.formUrlEncodedContentType));
      return spot;
    } on DioError catch(err) {
      var warning = WarningToast(err.response.data['msg']);
      warning.showToast();
      return null;
    }
  }

  updateSchedule(parkingSpotId, startDate, startTime, endTime, endDate, isActive) async {
    try {
      final parkingSpot = await dio.put(url + '/update/parkingSpot/schedule', data: {
        "parkingSpotId": parkingSpotId,
        "startDate": startDate,
        "startTime": startTime,
        "endTime": endTime,
        "endDate": endDate,
        "isActive": isActive
      }, options: Options(contentType: Headers.formUrlEncodedContentType));
      return parkingSpot;
    } on DioError catch(err) {
      var warning = WarningToast(err.response.data['msg']);
      warning.showToast();
      return null;
    }
  }
}