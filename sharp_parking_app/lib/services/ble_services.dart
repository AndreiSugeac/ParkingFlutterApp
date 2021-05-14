// import 'package:flutter_blue/flutter_blue.dart';
// import 'package:flutter_blue/gen/flutterblue.pb.dart' as proto;

// enum DeviceBtType {
//   LE,
//   CLASSIC,
//   DUAL,
//   UNKNOWN
// }

// class BleServices {

//   static BluetoothDevice createBLEDevice(String deviceName, String deviceIdentifier, DeviceBtType deviceBtType) {
//     proto.BluetoothDevice device = proto.BluetoothDevice.create();
//     device.name = deviceName;
//     device.remoteId = deviceIdentifier;

//     switch(deviceBtType) {
//       case DeviceBtType.LE:
//         device.type = proto.BluetoothDevice_Type.LE;
//         break;
//       case DeviceBtType.CLASSIC:
//         device.type = proto.BluetoothDevice_Type.CLASSIC;
//         break;
//       case DeviceBtType.DUAL:
//         device.type = proto.BluetoothDevice_Type.DUAL;
//         break;
//       case DeviceBtType.UNKNOWN:
//         device.type = proto.BluetoothDevice_Type.UNKNOWN;
//         break;
//     }

//     return BluetoothDevice.fromProto(device);
//   }

  
// }