import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sharp_parking_app/DTO/Car.dart';
import 'package:sharp_parking_app/services/car_services.dart';
import 'package:sharp_parking_app/services/secure_storage_services.dart';
import 'package:sharp_parking_app/utils/colors.dart';
import 'package:sharp_parking_app/utils/secure_storage.dart';
import 'package:sharp_parking_app/widgets/loaders/page_loader.dart';

class MyCarsScreen extends StatefulWidget {
  final String id;

  MyCarsScreen(this.id);

  @override
  State<StatefulWidget> createState() => _MyCarsScreenState(id);


}

class _MyCarsScreenState extends State<MyCarsScreen> {
  
  final String id;

  bool isSelected = false;

  _MyCarsScreenState(this.id);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: CarServices().getCarById(id),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            home: Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: Icon(
                              Icons.directions_car_outlined
                            ),
                            title: Text(
                              snapshot.data.data['car']['brand'] + ' ' +  snapshot.data.data['car']['model'],
                              style: TextStyle(
                                fontSize: 18
                              ),
                            ),
                            subtitle: Text(
                              snapshot.data.data['car']['licensePlate'],
                              style: TextStyle(
                                fontSize: 16
                              ),
                            ),
                            trailing: FutureBuilder(
                              future: SecureStorageServices.getSelectedCarSS(),
                              builder: (context, snapshot1) {
                                if(snapshot1.connectionState == ConnectionState.done && snapshot1.data != null) {
                                  return Icon(
                                    Icons.check,
                                    size: 20,
                                  );
                                } else {
                                  return SizedBox();
                                }
                              }
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              TextButton(
                                child: Text(
                                  'SELECT',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                  primary: primaryColor,
                                ),
                                onPressed: () {
                                  var json = jsonEncode((Car.fromJson(snapshot.data.data['car'])).toJson());
                                  SecureStorage.writeSecureData(
                                    'selectedCar', 
                                    (
                                      json
                                    )
                                  );
                                  setState(() {
                                    isSelected = true;
                                  });
                                },
                              ),
                              const SizedBox(width: 8),
                              TextButton(
                                child: Text(
                                  'UNSELECT',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                  primary: primaryColor,
                                ),
                                onPressed: () {
                                  SecureStorage.deleteSecureData('selectedCar');
                                  setState(() {
                                    isSelected = false;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          );
        }
        else {
          return PageLoader();
        }
      }
    );
  }
}