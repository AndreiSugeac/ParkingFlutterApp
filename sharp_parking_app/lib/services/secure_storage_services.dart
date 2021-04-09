import 'dart:convert';

import 'package:sharp_parking_app/DTO/Car.dart';
import 'package:sharp_parking_app/utils/secure_storage.dart';

class SecureStorageServices {

  static Future<Car> getSelectedCarSS() async {
    var value = await SecureStorage.readSecureData('selectedCar');
    var json = value != null ? jsonDecode(value) : null;
    var car = json != null ? Car.fromJson(json) : null;
    return car;
  }
}