import 'package:flutter_ble_lib/flutter_ble_lib.dart';

class BleSingletonServices {

  BleSingletonServices.privateConstructor();

  static final BleSingletonServices _instance = BleSingletonServices.privateConstructor();

  static BleSingletonServices get instance => _instance;

  final BleManager _bleManager = BleManager();

  BleManager get bleManager => _bleManager;
}