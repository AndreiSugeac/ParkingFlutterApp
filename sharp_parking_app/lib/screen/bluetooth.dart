// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

// class BluetoothDevice extends StatefulWidget {
//   @override
//   _BluetoothDeviceState createState() => _BluetoothDeviceState();
// }

// class _BluetoothDeviceState extends State<BluetoothDevice> {

//   BluetoothState _bluetoothState = BluetoothState.UNKNOWN;

//   BluetoothConnection _bluetoothConnection;

//   FlutterBluetoothSerial _bluetoothSerial = FlutterBluetoothSerial.instance;

//   List<BluetoothDevice> _bluetoothDevices = [];

//   bool isBtDeviceConnected() {
//     if(_bluetoothConnection != null && _bluetoothConnection.isConnected) {
//       return true;
//     }

//     return false;
//   }

//   Future<void> getPairedDevices() async {
//     List<BluetoothDevice> devices = [];

//     try {
//       devices = (await _bluetoothSerial.getBondedDevices()).cast<BluetoothDevice>();
//     } on PlatformException {
//       print("Error");
//     }

//     if(!mounted) {
//       return;
//     }

//     setState(() {
//       _bluetoothDevices = devices;
//     });
//   }

//   Future<void> enableBluetooth() async {

//     _bluetoothState = await FlutterBluetoothSerial.instance.state;

//     if(_bluetoothState == BluetoothState.STATE_OFF) {
//       await FlutterBluetoothSerial.instance.requestEnable();

//       await getPairedDevices();
//     } 
//     else {
//       await getPairedDevices();
//     }

//   }

//   @override
//   void initState() {
//     super.initState();

//     FlutterBluetoothSerial.instance.state.then((state) {
//       setState(() {
//         _bluetoothState = state;
//       });
//     });

//     enableBluetooth();

//     FlutterBluetoothSerial.instance.onStateChanged().listen((BluetoothState state) {
//       setState(() {
//         _bluetoothState = state;

//         getPairedDevices();
//       });
//     });    
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(

//     );
//   }
// }