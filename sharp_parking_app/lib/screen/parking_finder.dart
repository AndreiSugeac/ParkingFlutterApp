import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sharp_parking_app/DTO/Car.dart';
import 'package:sharp_parking_app/services/secure_storage_services.dart';
import 'package:sharp_parking_app/services/user_services.dart';
import 'package:sharp_parking_app/utils/colors.dart';
import 'package:sharp_parking_app/widgets/loaders/page_loader.dart';

class ParkingFinder extends StatefulWidget {
  @override
  _ParkingFinderState createState() => _ParkingFinderState();
}

class _ParkingFinderState extends State<ParkingFinder> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: UserServices().tokenToUser(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            body: Stack(
              children: <Widget> [
                Column(
                  children: <Widget>[
                    Container(
                      height: size.height * 0.80,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(44.43654626488017, 26.103229052858346),
                          zoom: 16,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: size.height * 0.20,
                      child:Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 15),
                            height: size.height * 0.1,
                            width: size.width * 0.90,
                            // alignment: AlignmentDirectional.topCenter,
                            child: TextButton(
                              onPressed: () => {},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Search parking',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black87
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Icon(
                                    Icons.search,
                                    size: 22,
                                    color: Colors.black87,
                                  )
                                ]
                              ),
                            ),
                          ),
                          Expanded(
                            // width: size.width * 0.125,
                            // height: size.width * 0.125, 
                            child: ElevatedButton(
                              child: Ink(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18)
                                ),
                                child: SvgPicture.asset('assets/icons/HomeIcon.svg', width: size.width * 0.075, height: size.width * 0.075, color: primaryColor),
                              ),
                              onPressed: () => {
                                Navigator.pop(context)
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18)
                                ),
                                padding: EdgeInsets.all(0.0),
                              ),
                            ),
                          ),
                        ]
                      ),
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.transparent,
                        ),
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ]
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 40, 15, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      // Menu button
                      Container(
                        width: size.width * 0.125,
                        height: size.width * 0.125,
                        child: ElevatedButton(
                          child: Ink(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18)
                            ),
                            child: SvgPicture.asset('assets/icons/HamburgerMenuIcon.svg', width: size.width * 0.05, height: size.width * 0.05),
                          ),
                          onPressed: () => {},
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18)
                            ),
                            padding: EdgeInsets.all(0.0),
                          ),
                        ),
                      ),
                      Container(
                        width: size.width * 0.3,
                        height: size.width * 0.125,
                        child: ElevatedButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget> [
                              FutureBuilder<Car>(
                                future:SecureStorageServices.getSelectedCarSS(),
                                builder: (context, snapshot1) {
                                  if(snapshot1.connectionState == ConnectionState.done && snapshot1.data != null) {
                                    return Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Center(
                                          child: Text(
                                            snapshot1.data.licensePlate,
                                            textAlign: TextAlign.start,
                                            textDirection: TextDirection.ltr,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 13,
                                              color: Colors.black,
                                            )
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                  else {
                                    return Column();
                                  }
                                }
                              ),
                              SizedBox(width: 5),
                              Expanded(
                                child:Container(
                                  child: Ink(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(18)
                                    ),
                                    child: SvgPicture.asset('assets/icons/CarIcon.svg', width: size.width * 0.09, height: size.width * 0.09),
                                  ),
                                ),
                              ),
                            ]
                          ),
                          onPressed: () => {},
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18)
                            ),
                            alignment: Alignment.centerRight,
                          ),
                        ),
                      ),
                    ]
                  ),
                ),
              ]
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