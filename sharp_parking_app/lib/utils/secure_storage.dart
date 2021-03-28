import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  // Methods
  static Future readSecureData(String key) async {
    String readData = await _secureStorage.read(key: key);
    return readData;
  }

  static Future readAllSecureStorage() async {
    Map<String, String> readData = await _secureStorage.readAll();
    return readData;
  }

  static Future writeSecureData(String key, String value) async {
    var writeData = await _secureStorage.write(key: key, value: value);
    return writeData;
  }

  static Future deleteSecureData(String key) async {
    var deleteData = await _secureStorage.delete(key: key);
    return deleteData;
  }

  static Future deleteAllSecureData() async {
    return await _secureStorage.deleteAll();
  }
}