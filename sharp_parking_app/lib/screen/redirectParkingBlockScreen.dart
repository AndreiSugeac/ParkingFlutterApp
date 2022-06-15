import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sharp_parking_app/DTO/ParkingSpot.dart';
import 'package:sharp_parking_app/services/parking_spot_services.dart';
import 'package:sharp_parking_app/utils/colors.dart';
import 'package:sharp_parking_app/widgets/buttons/parking_block_button.dart';
import 'package:sharp_parking_app/widgets/icons/available_parking.dart';
import 'package:sharp_parking_app/widgets/icons/raised_block_icon.dart';
import 'package:sharp_parking_app/widgets/toasts/success_toast.dart';
import 'package:sharp_parking_app/widgets/toasts/warning_toast.dart';

class RedirectParkingBlock extends StatefulWidget {

  final ParkingSpot parkingSpot;
  RedirectParkingBlock(this.parkingSpot);

  @override
  _RedirectParkingBlockState createState() => _RedirectParkingBlockState(parkingSpot);
}

class _RedirectParkingBlockState extends State<RedirectParkingBlock> {

  final ParkingSpot _parkingSpot;

  _RedirectParkingBlockState(this._parkingSpot);

  bool _lowered = false;

  bool _raised = true;

  bool _connected = false;

  bool _availability;

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
    _availability = _parkingSpot.available;
    _flutterBlue.state.listen((state) => {
      if(state == BluetoothState.off) {
        WarningToast('Please turn Bluetooth on!').showToast()
      }
      else if(state == BluetoothState.on) {
        scanForDevices()
      }
     });
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
        _availability = false;
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
        _availability = true;
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
            SizedBox(height: 0.02 * size.height),
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
            SizedBox(height: size.height * 0.01),
            Container(
              height: 60,
              width: 250,
              alignment: Alignment.center,
              child: _connected ? ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: primaryColor
                ),
                child: Text(
                  'Disconnect',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => {
                  _disconnectDevice()
                },
              ) : 
              ElevatedButton(
                onPressed: () async => {
                  _bleDevice = devicesList.firstWhere((device) => device.id == DeviceIdentifier(_parkingSpot.parkingBlock['macAddress'])), // DeviceIdentifier("00:13:AA:00:B5:96")
                  await _connectToDevice(),
                  await _getServices(_parkingSpot.parkingBlock['serviceUUID']),
                  _getCharacteristics(_parkingSpot.parkingBlock['characteristicUUID'])
                }, 
                child: Text(
                  'Connect',
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
                        color: _connected ? (_availability ? secondaryColor : Colors.grey.shade500) : Colors.grey.shade500,
                        fontSize: 17
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    ParkingBlockButton(_parkingSpot.id, false, AvailableParkingIcon(), _connected ? (_availability ? lowerParkingBlock : () => {}) : () => {}, _bleDevice != null ? (_connected && _availability) : false, _connected ? (_availability ? secondaryColor : Colors.grey.shade500) : Colors.grey.shade500),
                  ],
                ),
                SizedBox(width: size.width * 0.1),
                Column(
                  children: <Widget>[
                    Text(
                      'Block',
                      style: TextStyle(
                        color: _connected ? (!_availability ? thirdColor : Colors.grey.shade500) : Colors.grey.shade500,
                        fontSize: 17
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    ParkingBlockButton(_parkingSpot.id, true, RaisedBlockIcon(), _connected ? (!_availability ? raiseParkingBlock : () => {}) : () => {}, _bleDevice != null ? (_connected && !_availability) : false, _connected ? (!_availability ? thirdColor : Colors.grey.shade500) : Colors.grey.shade500),
                  ],
                )
              ],
            ),
          ],
        )
      )
    );      
  }
}