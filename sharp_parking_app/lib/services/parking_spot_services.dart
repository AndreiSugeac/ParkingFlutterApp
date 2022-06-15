import 'package:dio/dio.dart';
import 'package:sharp_parking_app/utils/url.dart';
import 'package:sharp_parking_app/widgets/toasts/warning_toast.dart';

class ParkingSpotServices {
  Dio dio = new Dio();

  String url = Url.serverURL;

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

  getParkingSpotByUserId(id) async {
    try {
      String _id = id.toString();
      final parkingSpot = await dio.get(url + '/parkingSpot/byUser/get/' + _id, options: Options(contentType: Headers.formUrlEncodedContentType));

      return parkingSpot;
    } on DioError catch(err) {
      var warning = WarningToast(err.response.data['msg']);
      warning.showToast();
      return null;
    }
  }

  getSchedulerByParkingSpotId(id) async {
    try {
      String _id = id.toString();
      final scheduler = await dio.get(url + '/scheduler/byParkingSpotId/get/' + _id, options: Options(contentType: Headers.formUrlEncodedContentType));

      return scheduler;
    } on DioError catch(err) {
      var warning = WarningToast(err.response.data['msg']);
      warning.showToast();
      return null;
    }
  }

  getLocationByParkingSpotId(id) async {
    try {
      String _id = id.toString();
      final scheduler = await dio.get(url + '/location/byParkingSpotId/get/' + _id, options: Options(contentType: Headers.formUrlEncodedContentType));

      return scheduler;
    } on DioError catch(err) {
      var warning = WarningToast(err.response.data['msg']);
      warning.showToast();
      return null;
    }
  }

  addParkingSpot(latitude, longitude) async {
    try {
      final parkingSpot = await dio.post(url + '/parkingSpot/add', data: {
        "latitude": latitude,
        "longitude": longitude
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