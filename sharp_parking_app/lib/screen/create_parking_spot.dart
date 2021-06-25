import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sharp_parking_app/screen/home.dart';
import 'package:sharp_parking_app/screen/login.dart';
import 'package:sharp_parking_app/services/parking_spot_services.dart';
import 'package:sharp_parking_app/services/user_services.dart';
import 'package:sharp_parking_app/utils/colors.dart';
import 'package:sharp_parking_app/utils/secure_storage.dart';
import 'package:sharp_parking_app/widgets/buttons/long_button.dart';
import 'package:sharp_parking_app/widgets/icons/sharp_icon.dart';
import 'package:sharp_parking_app/widgets/toasts/success_toast.dart';
import 'package:sharp_parking_app/widgets/toasts/warning_toast.dart';

class CreateParkingSpot extends StatefulWidget {

  final String _userId;

  CreateParkingSpot(this._userId);

  @override
  _CreateParkingSpotState createState() => _CreateParkingSpotState(_userId);
}

class _CreateParkingSpotState extends State<CreateParkingSpot> {

  final String _userId;

  _CreateParkingSpotState(this._userId);

  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  bool response;

  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _macAddressController = TextEditingController();
  final _serviceIdController = TextEditingController();
  final _characteristicIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _latitudeController.addListener(_validateFields);
    _longitudeController.addListener(_validateFields);
    _macAddressController.addListener(_validateFields);
    _serviceIdController.addListener(_validateFields);
    _characteristicIdController.addListener(_validateFields);
  }

  @override
  void dispose() {
    _latitudeController.dispose();
    _longitudeController.dispose();
    _macAddressController.dispose();
    _serviceIdController.dispose();
    _characteristicIdController.dispose();
    super.dispose();
  }

  _validateFields() {
    var res = _form.currentState.validate();
  }

  Future<bool> createParkingBlock() async {
    try {
      var parkingSpot = await ParkingSpotServices().addParkingSpot(_latitudeController.text, _longitudeController.text, _macAddressController.text, _serviceIdController.text, _characteristicIdController.text);
      if(parkingSpot != null && parkingSpot.data['success']) {
        var temp = parkingSpot.data["spot"]['_id'];
        var alr = 1;

        await UserServices().addParkingSpotForUser(_userId, parkingSpot.data["spot"]['_id']).then((value) {
          if(value != null && value.data['success']) {
            response = value.data['success'];
            UserServices.logout(context);
            SuccessToast('Parking spot was successfully created!').showToast();
          } 
          else {
            response = value.data['success'];
            WarningToast(parkingSpot.data['msg']).showToast();
          }
        });
      } 
      else {
        WarningToast(parkingSpot.data['msg']).showToast();
      } 
      return response;
    } on DioError catch(err) {
      print(err.message);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: MaterialApp(
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            reverse: true,
            child: Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 0.1 * size.height),
                  Container(
                    child: Text(
                      'Create your parking spot',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      )
                    ),
                    alignment: Alignment.center,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(40, 50, 40, 20),
                    child: Theme(
                      data: ThemeData(
                        fontFamily: 'Roboto',
                        primaryColor: primaryColor,
                      ),
                      child: Form(
                        key: _form,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: _latitudeController,
                              validator: (val) {
                                if(_latitudeController.text.isEmpty) {
                                  return '* mandatory';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Latitude',
                                focusColor: primaryColor,
                                hintText: 'Enter the latitude of your parking spot location',
                              ),
                            ),
                            SizedBox(height: 0.02 * size.height),
                            TextFormField(
                              controller: _longitudeController,
                              validator: (val) {
                                if(_longitudeController.text.isEmpty) {
                                  return '* mandatory';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Longitude',
                                focusColor: primaryColor,
                                hintText: 'Enter the longitude of your parking spot location',
                              ),
                            ),
                            SizedBox(height: 0.02 * size.height),
                            TextFormField(
                              controller: _macAddressController,
                              validator: (val) {
                                if(_macAddressController.text.isEmpty) {
                                  return '* mandatory';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'MAC Address',
                                focusColor: primaryColor,
                                hintText: 'Enter the MAC Address of your parking block',
                              ),
                            ),
                            SizedBox(height: 0.02 * size.height),
                            TextFormField(
                              controller: _serviceIdController,
                              validator: (val) {
                                if(_serviceIdController.text.isEmpty) {
                                  return '* mandatory';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Service UUID',
                                focusColor: primaryColor,
                                hintText: 'Enter the service UUID of your parking block',
                              ),
                            ),
                            SizedBox(height: 0.02 * size.height),
                            TextFormField(
                              controller: _characteristicIdController,
                              validator: (val) {
                                if(_characteristicIdController.text.isEmpty) {
                                  return '* mandatory';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Characteristic UUID',
                                focusColor: primaryColor,
                                hintText: 'Enter the characteristic UUID of your parking block',
                              ),
                            ),
                            SizedBox(height: 0.05 * size.height),
                            LongButton('CREATE', primaryColor, Login(), true, createParkingBlock),
                          ],
                        ),
                      )
                    )
                  )
                ]
              )
            )
          )
        )
      )
    );
  }
}