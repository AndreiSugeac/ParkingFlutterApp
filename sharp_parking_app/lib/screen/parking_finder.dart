import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sharp_parking_app/constants/colors.dart';

class ParkingFinder extends StatefulWidget {
  @override
  _ParkingFinderState createState() => _ParkingFinderState();
}

class _ParkingFinderState extends State<ParkingFinder> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.grey.shade200,
                          primary: Colors.black,
                        ),
                        child: Text(
                          'Search parking destination',
                          style: TextStyle(
                            fontSize: 16,
                          ),
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
                          child: SvgPicture.asset('assets/icons/HomeIcon.svg', width: size.width * 0.075, height: size.width * 0.075, color: primaryColor,),
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
                      children: <Widget> [
                        Column(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                'My Car',
                                textAlign: TextAlign.start,
                                textDirection: TextDirection.ltr,
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                  color: Colors.black,
                                )
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'BV88CCO',
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
                        ),
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
}