import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sharp_parking_app/DTO/ParkingSpot.dart';
import 'package:sharp_parking_app/services/address_search_services.dart';
import 'package:sharp_parking_app/services/parking_spot_services.dart';
import 'package:sharp_parking_app/utils/colors.dart';
import 'package:sharp_parking_app/utils/suggestion.dart';
import 'package:uuid/uuid.dart';

class ParkingFinder extends StatefulWidget {
  @override
  _ParkingFinderState createState() => _ParkingFinderState();
}

class _ParkingFinderState extends State<ParkingFinder> {
  @override

  LatLng _initialPosition = LatLng(44.43654626488017, 26.103229052858346);

  Completer<GoogleMapController> _mapController = Completer();

  final _controller = TextEditingController();

  dynamic response;

  StreamSubscription positionUpdate;

  Set<Marker> _markers = HashSet<Marker>();

  bool showRedirect;

  ParkingSpot selectedParkingSpot;

  TimeOfDay _startTimeOfDay;

  TimeOfDay _endTimeOfDay;

  @override
  void initState() {
    super.initState();
    //_setMarkerIcon();
    showRedirect = false;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) async {
    _mapController.complete(controller);

    response = await ParkingSpotServices().getAvailableParkingSpots();
    List<ParkingSpot> parkingSpots = new List<ParkingSpot>();
    DateTime filterDate = DateTime.now();
    TimeOfDay filterTime = TimeOfDay.now();

    for(var parkingSpot in response.data["parkingSpots"]) {
      var schedule = await ParkingSpotServices().getSchedulerByParkingSpotId(parkingSpot["id"]);
      var location = await ParkingSpotServices().getLocationByParkingSpotId(parkingSpot["id"]);
      ParkingSpot spot = ParkingSpot.fromJson(parkingSpot);
      spot.schedule = schedule.data["schedule"];
      spot.location = location.data["location"];
      DateTime startDate = DateTime.parse(spot.schedule['startDate']);
      TimeOfDay startTime = TimeOfDay(hour:int.parse(spot.schedule['startTime'].split(":")[0]),minute: int.parse(spot.schedule['startTime'].split(":")[1]));
      TimeOfDay endTime = TimeOfDay(hour:int.parse(spot.schedule['endTime'].split(":")[0]),minute: int.parse(spot.schedule['endTime'].split(":")[1]));
      DateTime endDate = DateTime.parse(spot.schedule['endDate']);
      if((filterDate.isAfter(startDate) || filterDate.compareTo(endDate) == 0) && 
        (filterDate.isBefore(endDate) || filterDate.compareTo(endDate) == 0) && 
        filterTime.hour * 60 + filterTime.minute >= startTime.hour * 60 + startTime.minute && 
        filterTime.hour * 60 + filterTime.minute < endTime.hour * 60 + endTime.minute ) {  
          parkingSpots.add(spot);
      }
    }
    int i = 0;

    setState(() {
      for(var parkingSpot in parkingSpots) {
        i++;
        final selected = parkingSpot;
        _markers.add(
          Marker(
            markerId: MarkerId(selected.id.toString()),
            position: LatLng(parkingSpot.location["latitude"], parkingSpot.location["longitude"]),
            infoWindow: InfoWindow(
              title: 'Parking Spot ' + i.toString(),
              snippet: 'Dummy parking spot ' + i.toString(),
            ),
            onTap: () {
              setState(() {
                showRedirect = !showRedirect;
                selectedParkingSpot = selected;
                _startTimeOfDay = TimeOfDay(hour: int.parse(selectedParkingSpot.schedule['startTime'].toString().split(":")[0]), minute: int.parse(selectedParkingSpot.schedule['startTime'].toString().split(":")[1]));
                _endTimeOfDay = TimeOfDay(hour: int.parse(selectedParkingSpot.schedule['endTime'].toString().split(":")[0]), minute: int.parse(selectedParkingSpot.schedule['endTime'].toString().split(":")[1]));
              });
            }
            //icon: _markerIcon
          )
        );
      }
    });
  }

  Future<void> unsubscribeFromPositionUpdate() async {
    await positionUpdate.cancel();
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: () async {
          await unsubscribeFromPositionUpdate().then((value) {
            return true;
          });
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: SingleChildScrollView(
              child: Stack(
            children: <Widget> [
              Column(
                children: <Widget>[
                  Container(
                    height: size.height * 0.80,
                    child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      
                      initialCameraPosition: CameraPosition(
                        target: _initialPosition,
                        zoom: 16,
                      ),
                      onTap: (LatLng latLng) {
                        setState(() {
                          showRedirect = false;
                        });
                      },
                      markers: _markers,
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: size.height * 0.20,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.fromLTRB(0, 0, 7.5, 3),
                            height: size.height * 0.1,
                            width: size.width * 0.60,
                            // alignment: AlignmentDirectional.topCenter,
                            // child: TextField(
                            //   controller: _controller,
                            //   onTap: () async {
                            //     // should show search screen here
                            //     showSearch(
                            //       context: context,
                            //       // we haven't created AddressSearch class
                            //       // this should be extending SearchDelegate
                            //       delegate: AddressSearch(),
                            //     );
                            //   },
                            //   decoration: InputDecoration(
                            //     icon: Container(
                            //       alignment: Alignment.center,
                            //       margin: EdgeInsets.only(left: 20),
                            //       width: 10,
                            //       height: 10,
                            //       child: Icon(
                            //         Icons.search,
                            //         size: 22,
                            //         color: Colors.black87,
                            //       ),
                            //     ),
                            //     hintText: "Search parking",
                            //     hintStyle: TextStyle(
                            //       fontSize: 18,
                            //       fontWeight: FontWeight.w600,
                            //       color: Colors.black87
                            //     ),
                            //     border: InputBorder.none,
                            //     contentPadding: EdgeInsets.only(left: 8.0, top: 16.0),
                            //   ),
                            // ),
                            child: TextButton(
                              onPressed: () async {
                                final sessionToken = Uuid().v4();
                                final Suggestion result = await showSearch(
                                  context: context,
                                  delegate: AddressSearch(sessionToken),
                                );
                                if (result != null) {
                                  setState(() {
                                    _controller.text = result.description;
                                    _initialPosition = LatLng(result.lat, result.lng);
                                  });

                                  final GoogleMapController controller = await _mapController.future;
                                  controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
                                    target: _initialPosition,
                                    zoom: 16,
                                  )));
                                }
                              },
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
                        ),
                          Expanded(
                            child: Container(
                              width: size.width * 0.15,
                              height: size.width * 0.15,
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
                                ),
                              ),
                            ),
                          ),
                      ]
                    ),
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
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
                padding: showRedirect ? EdgeInsets.only(left: 15, top: size.height * 0.8 - size.width * 0.3) : EdgeInsets.zero,
                child: showRedirect ? Container( 
                  width: size.width * 0.50,
                  height: size.width * 0.25,
                  color: Colors.transparent,
                  child: ElevatedButton(
                    onPressed: () => {
                    //   Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => RedirectParkingBlock(selectedParkingSpot)),
                    // )
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        Ink(
                          child: SvgPicture.asset('assets/icons/RedirectButton.svg', width: size.width * 0.15, height: size.width * 0.15),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 15, 0, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Parking spot',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.05,
                              ),
                              Row(
                                children: <Widget>[
                                  SvgPicture.asset('assets/icons/schedule-24px.svg', width: size.width * 0.04, height: size.width * 0.04, color: greyColor,),
                                  Container(
                                    child: _startTimeOfDay.hour < 10 && _startTimeOfDay.minute >= 10 ? 
                                    Text(
                                      '0' +_startTimeOfDay.hour.toString() + ':' + _startTimeOfDay.minute.toString() + ' - ',
                                      style: TextStyle(
                                        color: greyColor,
                                        fontSize: 10,
                                      ),
                                    ) : _startTimeOfDay.hour < 10 && _startTimeOfDay.minute < 10 ? 
                                    Text(
                                      '0' +_startTimeOfDay.hour.toString() + ':' + '0' +  _startTimeOfDay.minute.toString() + ' - ',
                                      style: TextStyle(
                                        color: greyColor,
                                        fontSize: 10,
                                      ),
                                    ) : _startTimeOfDay.hour >= 10 && _startTimeOfDay.minute < 10 ? 
                                    Text(
                                    _startTimeOfDay.hour.toString() + ':' + '0' +  _startTimeOfDay.minute.toString() + ' - ',
                                      style: TextStyle(
                                        color: greyColor,
                                        fontSize: 10,
                                      
                                      ),
                                    ) : Text(
                                      _startTimeOfDay.hour.toString() + ':'+  _startTimeOfDay.minute.toString() + ' - ',
                                      style: TextStyle(
                                        color: greyColor,
                                        fontSize: 10,
                                      ),
                                    )
                                  ),
                                  Container(
                                    child: _endTimeOfDay.hour < 10 && _endTimeOfDay.minute >= 10 ? 
                                    Text(
                                      '0' +_endTimeOfDay.hour.toString() + ':' + _endTimeOfDay.minute.toString(),
                                      style: TextStyle(
                                        color: greyColor,
                                        fontSize: 10,
                                      ),
                                    ) : _endTimeOfDay.hour < 10 && _endTimeOfDay.minute < 10 ? 
                                    Text(
                                      '0' +_endTimeOfDay.hour.toString() + ':' + '0' +  _endTimeOfDay.minute.toString(),
                                      style: TextStyle(
                                        color: greyColor,
                                        fontSize: 10,
                                      ),
                                    ) : _endTimeOfDay.hour >= 10 && _endTimeOfDay.minute < 10 ? 
                                    Text(
                                    _endTimeOfDay.hour.toString() + ':' + '0' +  _endTimeOfDay.minute.toString(),
                                      style: TextStyle(
                                        color: greyColor,
                                        fontSize: 10,
                                      ),
                                    ) : Text(
                                      _endTimeOfDay.hour.toString() + ':'+  _endTimeOfDay.minute.toString(),
                                      style: TextStyle(
                                        color: greyColor,
                                        fontSize: 10,
                                      ),
                                    )
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ) : null,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(15, 40, 15, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    // Menu button
                    // Container(
                    //   width: size.width * 0.125,
                    //   height: size.width * 0.125,
                    //   child: ElevatedButton(
                    //     child: Ink(
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(18)
                    //       ),
                    //       child: SvgPicture.asset('assets/icons/HamburgerMenuIcon.svg', width: size.width * 0.05, height: size.width * 0.05),
                    //     ),
                    //     onPressed: () => {},
                    //     style: ElevatedButton.styleFrom(
                    //       primary: Colors.white,
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(18)
                    //       ),
                    //       padding: EdgeInsets.all(0.0),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(width: 0),
                    // Container(
                    //   width: size.width * 0.3,
                    //   height: size.width * 0.125,
                    //   child: ElevatedButton(
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       crossAxisAlignment: CrossAxisAlignment.center,
                    //       children: <Widget> [
                    //         FutureBuilder<Car>(
                    //           future:SecureStorageServices.getSelectedCarSS(),
                    //           builder: (context, snapshot1) {
                    //             if(snapshot1.connectionState == ConnectionState.done && snapshot1.data != null) {
                    //               return Column(
                    //                 mainAxisAlignment: MainAxisAlignment.center,
                    //                 children: <Widget>[
                    //                   Center(
                    //                     child: Text(
                    //                       snapshot1.data.licensePlate,
                    //                       textAlign: TextAlign.start,
                    //                       textDirection: TextDirection.ltr,
                    //                       style: TextStyle(
                    //                         fontWeight: FontWeight.w700,
                    //                         fontSize: 12,
                    //                         color: Colors.black,
                    //                       )
                    //                     ),
                    //                   ),
                    //                 ],
                    //               );
                    //             }
                    //             else {
                    //               return Column();
                    //             }
                    //           }
                    //         ),
                    //         SizedBox(width: 3),
                    //         Expanded(
                    //           child:Container(
                    //             child: Ink(
                    //               decoration: BoxDecoration(
                    //                 borderRadius: BorderRadius.circular(18)
                    //               ),
                    //               child: SvgPicture.asset('assets/icons/CarIcon.svg', width: size.width * 0.09, height: size.width * 0.09),
                    //             ),
                    //           ),
                    //         ),
                    //       ]
                    //     ),
                    //     onPressed: () => {},
                    //     style: ElevatedButton.styleFrom(
                    //       primary: Colors.white,
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(18)
                    //       ),
                    //       alignment: Alignment.centerRight,
                    //     ),
                    //   ),
                    // ),
                  ]
                ),
              ),
            ]
          )
        )
          )
      )
    );
  }
}