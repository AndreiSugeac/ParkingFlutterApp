import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sharp_parking_app/DTO/User.dart';
import 'package:sharp_parking_app/screen/scheduler.dart';
// import 'package:flutter_blue/gen/flutterblue.pb.dart';
// import 'package:sharp_parking_app/services/ble_services.dart';
// import 'package:sharp_parking_app/services/bluetooth_services.dart';
// import 'package:sharp_parking_app/services/bluetooth_services.dart';
import 'package:sharp_parking_app/services/parking_spot_services.dart';
import 'package:sharp_parking_app/utils/colors.dart';
import 'package:sharp_parking_app/widgets/buttons/parking_block_button.dart';
import 'package:sharp_parking_app/widgets/icons/available_parking.dart';
import 'package:sharp_parking_app/widgets/icons/raised_block_icon.dart';
import 'package:sharp_parking_app/widgets/loaders/page_loader.dart';
import 'package:sharp_parking_app/widgets/toasts/success_toast.dart';
import 'package:sharp_parking_app/widgets/toasts/warning_toast.dart';

class ParkingBlock extends StatefulWidget {

  final User owner;
  ParkingBlock(this.owner);

  @override
  _ParkingBlockState createState() => _ParkingBlockState(owner);
}

class _ParkingBlockState extends State<ParkingBlock> {

  final User _owner;

  _ParkingBlockState(this._owner);

  bool _lowered = false;

  bool _raised = true;

  bool _connected = false;

  FlutterBlue _flutterBlue = FlutterBlue.instance;

  StreamSubscription scanSubscription;

  List<BluetoothService> _services = new List<BluetoothService>();

  BluetoothService _communicationService;

  List<BluetoothCharacteristic> _characteristics = new List<BluetoothCharacteristic>(); 

  BluetoothCharacteristic _communicationCharacteristic;

  BluetoothDevice _bleDevice;

  final List<BluetoothDevice> devicesList = new List<BluetoothDevice>();

  @override
  void initState() {
    super.initState();
    // _getDevice();
    _flutterBlue.state.listen((state) => {
      if(state == BluetoothState.off) {
        WarningToast('Please turn Bluetooth on!').showToast()
      }
      else if(state == BluetoothState.on) {
        scanForDevices()
      }
     });
  //   _flutterBlue.connectedDevices
  //      .asStream()
  //      .listen((List<BluetoothDevice> devices) {
  //    for (BluetoothDevice device in devices) {
  //      _addDeviceTolist(device);
  //    }
  //  });
  //  _flutterBlue.scanResults.listen((List<ScanResult> results) {
  //    for (ScanResult result in results) {
  //      _addDeviceTolist(result.device);
  //    }
  //  });
  //  _flutterBlue.startScan(timeout: Duration(seconds: 5));
  }

  void scanForDevices() async {
    scanSubscription = _flutterBlue.scan(timeout: Duration(seconds: 10)).listen((scanResult) async {
      if(scanResult.device.name.contains('ParkingBlock')) {
        _addDeviceTolist(scanResult.device);

        stopScanning();
      }
    });
  }

  void stopScanning() {
    _flutterBlue.stopScan();
    scanSubscription.cancel();
  }

  void lowerParkingBlock(parkingSpotId, available) async {
    if(_communicationCharacteristic != null) {
      try {
        await _communicationCharacteristic.write(utf8.encode('1' + '\r\n'));
        final changeAvailability = await ParkingSpotServices().updateAvailability(parkingSpotId, available);
      } on Exception catch(err) {
        print(err);
        return;
      }
    
      setState(() {
        _lowered = true;
        _raised = false;
      });
    }
  }

  void raiseParkingBlock(parkingSpotId, available) async {
    if(_communicationCharacteristic != null) {
      try {
        await _communicationCharacteristic.write(utf8.encode('0' + '\r\n'));
        final changeAvailability = await ParkingSpotServices().updateAvailability(parkingSpotId, available);
      } on Exception catch(err) {
        print(err);
        return;
      }

      setState(() {
        _lowered = false;
        _raised = true;
      });
    }
  }

  Future<void> _connectToDevice() async {
    Future<bool> returnValue;
    try {
      await _bleDevice.connect(autoConnect: false).timeout(Duration(seconds:10), onTimeout: (){
        debugPrint('timeout occured');
        returnValue = Future.value(false);
        _bleDevice.disconnect();
      }).then((data) {
        if(returnValue == null)
        {
          debugPrint('connection successful');
          returnValue = Future.value(true);
        }
      });
    } on Exception catch(err) {
      print(err);
      return;
    } finally {
      if(returnValue == Future.value(false)) {
        WarningToast('Unable to connect to parking block!').showToast();
      } else if(returnValue == null) {
        SuccessToast('Connected to parking block!').showToast();
      }
    }

    setState(() {
          _connected = true;
    });
  }

  // void _getDevice() {
  //     setState(() {
  //       _bleDevice = BleServices.createBLEDevice('BT05', '00:13:AA:00:B5:96', DeviceBtType.LE);
  //     });
  // }

  Future<void> _getServices(String serviceId) async {
    if(_connected) {
      List<BluetoothService> services = await _bleDevice.discoverServices();
      services.forEach((service) {
        _services.add(service);
      });
      _communicationService = _services.firstWhere((service) => service.uuid == Guid(serviceId)); //Guid("0000ffe0-0000-1000-8000-00805f9b34fb"));
    }
  }

  void _getCharacteristics(String characteristicId) {
    if(_connected && _services != null) {
      _services.forEach((service) {
        service.characteristics.forEach((characteristic) {
          _characteristics.add(characteristic);
        });
      });
      _communicationCharacteristic = _characteristics.firstWhere((characteristic) => characteristic.uuid == Guid(characteristicId)); //Guid("0000ffe1-0000-1000-8000-00805f9b34fb"));
    }
  }

  Future<void> _disconnectDevice() async {
    
    try {
      await _bleDevice.disconnect();
    } on Exception catch(err) {
      print(err);
      return;
    }
    
    setState(() {
      _connected = false;
    });
  }

  _addDeviceTolist(final BluetoothDevice device) {
    if (!devicesList.contains(device)) {
     setState(() {
       devicesList.add(device);
     });
   }
  }

  ListView _buildListViewOfDevices() {
    List<Container> containers = new List<Container>();
    for (BluetoothDevice device in devicesList) {
      if(device.name.contains('ParkingBlock')) {
        containers.add(
          Container(
            height: 500,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text(device.name == '' ? '(unknown device)' : device.name),
                      Text(device.id.toString()),
                    ],
                  ),
                ),
                Column(
                  children: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue
                      ),
                      child: _connected ? Text(
                        'Disconnect',
                        style: TextStyle(color: Colors.white),
                      ) : Text(
                        'Connect',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: !_connected ? () => {
                        _bleDevice = device,
                        _connectToDevice()
                      } : () => {
                        _bleDevice = device,
                        _disconnectDevice()
                      },
                    ),
                    ElevatedButton(
                      style: _connected ? ElevatedButton.styleFrom(
                        primary: primaryColor
                      ) : ElevatedButton.styleFrom(
                        primary: Colors.grey
                      ),
                      child: Text(
                        'Get Services',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: _connected ? () => {
                        //_getServices()
                      } : () => {
                      },
                    ),
                    ElevatedButton(
                      style: _connected ? ElevatedButton.styleFrom(
                        primary: primaryColor
                      ) : ElevatedButton.styleFrom(
                        primary: Colors.grey
                      ),
                      child: Text(
                        'Get Characteristics',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: _connected ? () => {
                        //_getCharacteristics()
                      } : () => {
                      },
                    ),
                    ElevatedButton(
                      style: _connected ? ElevatedButton.styleFrom(
                        primary: primaryColor
                      ) : ElevatedButton.styleFrom(
                        primary: Colors.grey
                      ),
                      child: Text(
                        'Raise',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: _connected && _lowered ? () => {
                      } : () => {
                      },
                    ),
                    ElevatedButton(
                      style: _connected ? ElevatedButton.styleFrom(
                        primary: primaryColor
                      ) : ElevatedButton.styleFrom(
                        primary: Colors.grey
                      ),
                      child: Text(
                        'Lower',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: _connected && _raised ? () => {
                      } : () => {
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      }
    }
 
    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        ...containers,
      ],
    );
  }

  // Container _buildParkingBlockContainer() {
  //   Container container;
  //   //_bleDevice = devicesList.firstWhere((device) => device.id == DeviceIdentifier("00:13:AA:00:B5:96"));
  //   if(_bleDevice != null) {
  //     container = Container(
  //       height: 60,
  //       width: 250,
  //       alignment: Alignment.center,
  //       child:ElevatedButton(
  //         style: ElevatedButton.styleFrom(
  //           primary: Colors.blue
  //         ),
  //         child: _connected ? Text(
  //           'Disconnect',
  //           style: TextStyle(color: Colors.white),
  //         ) : Text(
  //           'Connect',
  //           style: TextStyle(color: Colors.white),
  //         ),
  //         onPressed: !_connected ? () async => {
  //           _bleDevice = devicesList.firstWhere((device) => device.id == DeviceIdentifier("00:13:AA:00:B5:96")),
  //           await _connectToDevice(),
  //           await _getServices(),
  //           _getCharacteristics()
  //         } : () => {
  //           _bleDevice = devicesList.firstWhere((device) => device.id == DeviceIdentifier("00:13:AA:00:B5:96")),
  //           _disconnectDevice()
  //         },
  //       )
  //     );
  //   }
  //   else {
  //     container = Container(
  //       alignment: Alignment.center,
  //       child: Text(
  //         'Your parking block could not be found!',
  //         style: TextStyle(
  //           fontSize: 18,
  //           color: Colors.red,
  //         ),
  //       ),
  //     );
  //   }

  //   return container;
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: ParkingSpotServices().getParkingSpotById(_owner.parkingSpot),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          return WillPopScope(
            onWillPop: () async {
              if(_connected) {
                await _disconnectDevice().then((value) {
                  return !_connected;
                });
              }
              else {
                return true;
              }
            },

            child: Scaffold(
        // body: _buildListViewOfDevices()
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 0.07 * size.height),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: Container(
                      height: 200.0,
                      width: 200.0,
                      color: Colors.white,
                      child: Container(
                        width: 0.25 * size.height,
                        height: 0.25 * size.height,
                        child: SvgPicture.asset('assets/icons/parked-car.svg'),
                        alignment: Alignment.center,
                      ),
                      alignment: Alignment.center,
                    ),
                  ),
                  SizedBox(height: 0.025 * size.height),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Personal parking spot',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.025),
                  Container(
                    height: size.height * 0.075,
                    width: size.width * 0.45,
                    alignment: Alignment.center,
                    child: _connected ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: primaryColor
                      ),
                      child: Text(
                        'DISCONNECT',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () => {
                        _disconnectDevice()
                      },
                    ) : 
                    ElevatedButton(
                      onPressed: () async => {
                        _bleDevice = devicesList.firstWhere((device) => device.id == DeviceIdentifier(snapshot.data.data['parkingSpot']['parkingBlock']['macAddress'])), // DeviceIdentifier("00:13:AA:00:B5:96")
                        await _connectToDevice(),
                        await _getServices(snapshot.data.data['parkingSpot']['parkingBlock']['serviceUUID']),
                        _getCharacteristics(snapshot.data.data['parkingSpot']['parkingBlock']['characteristicUUID'])
                      }, 
                      child: Text(
                        'CONNECT',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: secondaryColor
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text(
                            'Access',
                            style: TextStyle(
                              color: _connected ? secondaryColor : Colors.grey.shade500,
                              fontSize: 17
                            ),
                          ),
                          SizedBox(height: size.height * 0.02),
                          ParkingBlockButton(snapshot.data.data['parkingSpot']['_id'], false, AvailableParkingIcon(), lowerParkingBlock, _bleDevice != null ? (_connected && _raised) : false, _connected ? secondaryColor : Colors.grey.shade500),
                        ],
                      ),
                      SizedBox(width: size.width * 0.1),
                      Column(
                        children: <Widget>[
                          Text(
                            'Block',
                            style: TextStyle(
                              color: _connected ? thirdColor : Colors.grey.shade500,
                              fontSize: 17
                            ),
                          ),
                          SizedBox(height: size.height * 0.02),
                          ParkingBlockButton(snapshot.data.data['parkingSpot']['_id'], true, RaisedBlockIcon(), raiseParkingBlock, _bleDevice != null ? (_connected && _lowered) : false, _connected ? thirdColor : Colors.grey.shade500)
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: size.height * 0.05),
                  Container(
                    height: size.height * 0.1,
                    width: size.width * 0.6,
                    alignment: Alignment.center,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(15.0),
                        ),
                        primary: secondaryColor,
                      ),
                      onPressed: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Scheduler(snapshot.data.data['parkingSpot'].containsKey('schedule')? snapshot.data.data['parkingSpot']['schedule'] : null, snapshot.data.data['parkingSpot']['_id'])),
                        )
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.date_range, 
                            color: Colors.grey.shade500, 
                            size: 40
                          ),
                          SizedBox(
                            width: 10
                          ),
                          Text(
                            'SCHEDULE',
                            textAlign:TextAlign.center,
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w800,
                            )
                          ),
                        ],
                      )
                    )
                  ),
                ],
              )
            )
          );      
        } else {
          return PageLoader();
        }
      }
      // : _buildListViewOfDevices(),
    );
  }
}

// import 'dart:convert';
// import 'dart:typed_data';
// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:flutter_ble_lib/flutter_ble_lib.dart';
// import 'package:sharp_parking_app/services/bluetooth_services.dart';
// import 'package:sharp_parking_app/utils/colors.dart';
// import 'package:sharp_parking_app/widgets/buttons/parking_block_button.dart';
// import 'package:sharp_parking_app/widgets/icons/available_parking.dart';
// import 'package:sharp_parking_app/widgets/icons/raised_block_icon.dart';

// class ParkingBlock extends StatefulWidget {

//   ParkingBlock();

//   @override
//   _ParkingBlockState createState() => _ParkingBlockState();
// }

// class _ParkingBlockState extends State<ParkingBlock> {

//   bool _lowered = false;

//   bool _raised = true;

//   bool _connected = false;

//   final BleSingletonServices _ble = BleSingletonServices.instance;

//   BluetoothState _bleState;

//   Peripheral _parkingBlock;

//   List<Service> _services;

//   List<Characteristic> _characteristics;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_){
//       createClient();
//     });
//     getDevice();
//   }

//   @override
//   void dispose() {
//     disconnectFromParkingBlock();
//     destroyClient();
//     super.dispose();
//   }

//   createClient() async {
//     await _ble.bleManager.createClient();
//   }

//   destroyClient() async {
//     await _ble.bleManager.destroyClient();
//   }

//   enableBluetooth() async {
//     await _ble.bleManager.enableRadio();
//   }

//   void getDevice() {
//     try {
//       // _bleManager.startPeripheralScan().listen((scanResult) {
//       //   print("Scanned peripheral name is: " + scanResult.peripheral.name);
//       //   _parkingBlock = scanResult.peripheral;
//       //   _bleManager.stopPeripheralScan();
//       // });
//       // _ble.bleManager.startPeripheralScan(
//       // ).listen((scanResult) {
//       //     //Scan one peripheral and stop scanning
//       //     _parkingBlock = scanResult.peripheral;
//       //     print("Scanned Peripheral ${scanResult.peripheral.name}");
//       //     _ble.bleManager.stopPeripheralScan();
//       // });
//       _parkingBlock = _ble.bleManager.createUnsafePeripheral("00:13:AA:00:B5:96");
//     } on Exception catch(err) {
//       print(err);
//     }
//   }

//   Future<void> connectToParkingBlock() async {
//     try {
//       await _parkingBlock.connect(timeout: Duration(seconds: 10), refreshGatt: true);
//     } on Exception catch(err) {
//       print(err);
//     }
//   }

//   Future<void> disconnectFromParkingBlock() async {
//     if(_connected == true) {
//       try {
//         await _parkingBlock.disconnectOrCancelConnection();
//       } on Exception catch (err) {
//         print(err);
//       }
//     }
//   }

//   Future<void> checkConnection() async {
//     bool isConnected;
//     try {
//       isConnected = await _parkingBlock.isConnected();
//     } on Exception catch (err) {
//       print(err);
//       return;
//     } finally {
//       setState(() {
//         _connected = isConnected;
//       });
//     }
//   }

//   Future<void> getServicesAndCharacteristics() async {
//     List<Service> services;
//     List<Characteristic> characteristics;
//     if(_connected == true) {
//       try {
//         services = await _parkingBlock.services();
//         characteristics = await _parkingBlock.characteristics("0000FFE0-0000-1000-8000-00805F9B34FB");
//       } on Exception catch (err) {
//         print(err);
//       }

//       setState(() {
//         _services = services;
//         _characteristics = characteristics;
//       });
//     }
//   }

//   Future<void> lowerParkingBlock() async {
//     try {
//       await _parkingBlock.writeCharacteristic("0000FFE0-0000-1000-8000-00805F9B34FB", 
//                                               "0000FFE1-0000-1000-8000-00805F9B34FB", 
//                                               Uint8List.fromList([1]), false);
//     } on Exception catch (err) {
//       print(err);
//       return;
//     }
//   }

//   Future<void> raiseParkingBlock() async {
//     try {
//       await _parkingBlock.writeCharacteristic("0000FFE0-0000-1000-8000-00805F9B34FB", 
//                                               "0000FFE1-0000-1000-8000-00805F9B34FB", 
//                                               Uint8List.fromList([0]), false);
//     } on Exception catch (err) {
//       print(err);
//       return;
//     }
//   }


//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: <Widget>[
//           SizedBox(height: 0.07 * size.height),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(30.0),
//             child: Container(
//               height: 200.0,
//               width: 200.0,
//               color: Colors.white,
//               child: Icon(Icons.local_parking, color: Colors.black87, size: 100,),
//               alignment: Alignment.center,
//             ),
//           ),
//           SizedBox(height: 0.02 * size.height),
//           Container(
//             alignment: Alignment.center,
//             child: Text(
//               'Personal parking spot',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w700
//               ),
//             ),
//           ),
//           Container(
//             alignment: Alignment.center,
//             child: Text(
//               ''
//             )
//           ),
//           SizedBox(height: size.height * 0.01),
//           Container(
//             alignment: Alignment.center,
//             width: size.width * 0.75,
//             height: size.height * 0.15,
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 primary: secondaryColor,
//                 // padding: EdgeInsets.all(0.0),
//               ),
//               onPressed: _connected ? () async => {
//                 await disconnectFromParkingBlock(),
//                 await checkConnection()
//               } : () async => {
//                 await connectToParkingBlock(),
//                 await checkConnection(), 
//                 await getServicesAndCharacteristics()
//               },
//               child: _connected ? Text(
//                 'Disconnect'
//               ) : 
//               Text(
//                 'Connect'
//               ),
//             )
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               Column(
//                 children: <Widget>[
//                   Text(
//                     'Access',
//                     style: TextStyle(
//                       color: primaryColor,
//                       fontSize: 17
//                     ),
//                   ),
//                   SizedBox(height: size.height * 0.02),
//                   ParkingBlockButton(AvailableParkingIcon(), lowerParkingBlock, _parkingBlock!= null ? (_connected && _raised) : false),
//                 ],
//               ),
//               SizedBox(width: size.width * 0.1),
//               Column(
//                 children: <Widget>[
//                   Text(
//                     'Block',
//                     style: TextStyle(
//                       color: Colors.grey.shade500,
//                       fontSize: 17
//                     ),
//                   ),
//                   SizedBox(height: size.height * 0.02),
//                   ParkingBlockButton(RaisedBlockIcon(), raiseParkingBlock, _parkingBlock != null ? (_connected && _lowered) : false)
//                 ],
//               )
//             ],
//           )
//         ],
//       ) 
//       // : _buildListViewOfDevices(),
//     );
//   }
// }