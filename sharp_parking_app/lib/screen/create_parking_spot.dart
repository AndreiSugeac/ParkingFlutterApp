import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sharp_parking_app/screen/login.dart';
import 'package:sharp_parking_app/services/parking_spot_services.dart';
import 'package:sharp_parking_app/services/user_services.dart';
import 'package:sharp_parking_app/utils/colors.dart';
import 'package:sharp_parking_app/widgets/buttons/long_button.dart';
import 'package:sharp_parking_app/widgets/toasts/success_toast.dart';
import 'package:sharp_parking_app/widgets/toasts/warning_toast.dart';

class CreateParkingSpot extends StatefulWidget {

  final int _userId;

  CreateParkingSpot(this._userId);

  @override
  _CreateParkingSpotState createState() => _CreateParkingSpotState(_userId);
}

class _CreateParkingSpotState extends State<CreateParkingSpot> {

  final int _userId;

  _CreateParkingSpotState(this._userId);

  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  bool response;

  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _latitudeController.addListener(_validateFields);
    _longitudeController.addListener(_validateFields);
  }

  @override
  void dispose() {
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  _validateFields() {
    var res = _form.currentState.validate();
  }

  Future<bool> createParkingBlock() async {
    try {
      var parkingSpot = await ParkingSpotServices().addParkingSpot(_latitudeController.text, _longitudeController.text);
      if(parkingSpot != null && parkingSpot.data['success']) {
        var temp = parkingSpot.data["spot"]['id'];
        var alr = 1;

        await UserServices().addParkingSpotForUser(_userId, parkingSpot.data["spot"]['id']).then((value) {
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
        debugShowCheckedModeBanner: false,
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