import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sharp_parking_app/screen/create_parking_spot.dart';
import 'package:sharp_parking_app/screen/parking_block.dart';
import 'package:sharp_parking_app/screen/user.dart';
import 'package:sharp_parking_app/widgets/buttons/home_screen_button.dart';
import 'package:sharp_parking_app/utils/colors.dart';
import 'package:sharp_parking_app/widgets/icons/location_icon.dart';
import 'package:sharp_parking_app/widgets/icons/parking_block_icon.dart';
import 'package:sharp_parking_app/screen/parking_finder.dart';
import 'package:sharp_parking_app/services/user_services.dart';
import 'package:sharp_parking_app/widgets/loaders/page_loader.dart';

class Home extends StatefulWidget {

  _Home createState() => _Home();
}

class _Home extends State<Home> {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light
    )); 
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: UserServices().tokenToUser(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            home: Scaffold(
              body: Column(
                children: <Widget>[
                  SizedBox(height: 0.07 * size.height),
                  TextButton(
                    onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UserScreen()),
                      )
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),//or 15.0
                            child: Container(
                              height: 60.0,
                              width: 60.0,
                              color: primaryColor,
                              child: Icon(Icons.person, color: Colors.white, size: 40.0),
                              alignment: Alignment.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  snapshot.data.firstName + ' ' + snapshot.data.lastName,
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  snapshot.data.email,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color.fromRGBO(112, 112, 112, 1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 0.08 * size.height),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Parking',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        ' made easy',
                        style: TextStyle(
                          color: secondaryColor,
                          fontSize: 30,
                        )
                      )
                    ],
                  ),
                  SizedBox(height: 0.02 * size.height),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 50, 20, 0),
                    child: snapshot.data.parkingSpot != null ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        HomeScreenBtn(ParkingBlockIcon(), ParkingBlock(snapshot.data)),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Parking spot',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 22,
                                  ),
                                ),
                                SizedBox(height: 0.01 * size.height),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                  child: Text(
                                    'Access your parking spot by lowering the parking block. Also you can make schedules for when your parking spot can be available for other users.',
                                    textAlign: TextAlign.center,
                                    textDirection: TextDirection.ltr,
                                    style: TextStyle(color: greyColor),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ) : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        HomeScreenBtn(ParkingBlockIcon(), CreateParkingSpot(snapshot.data.id)),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Set your parking',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 22,
                                  ),
                                ),
                                SizedBox(height: 0.01 * size.height),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                  child: Text(
                                    'You don\'t have a parking spot assigned to your account. Create one and share it with our community. Your spot will be secured with the help of our smart parking blocks.',
                                    textAlign: TextAlign.center,
                                    textDirection: TextDirection.ltr,
                                    style: TextStyle(color: greyColor),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.02,),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 50, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        HomeScreenBtn(LocationIcon(), ParkingFinder()),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Find Parking',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 22,
                                  ),
                                ),
                                SizedBox(height: 0.01 * size.height),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                  child: Text(
                                    'Select your preferred parking spot near your destination. The parking spots are available in a time interval set by the owner, so you can access any spot, as long as you fit that interval.',
                                    textAlign: TextAlign.center,
                                    textDirection: TextDirection.ltr,
                                    style: TextStyle(color: greyColor),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ), 
                ],
              )
            )
          );
        } else {
          return PageLoader();
        }
      }
    );
  }
}