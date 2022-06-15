import 'package:flutter/material.dart';
import 'package:sharp_parking_app/services/user_services.dart';
import 'package:sharp_parking_app/utils/colors.dart';
import 'package:sharp_parking_app/widgets/loaders/page_loader.dart';

class UserScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UserScreenState(); 
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; 
    return FutureBuilder(
      future: UserServices().tokenToUser(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 0.1 * size.height),
                  TextButton(
                    onPressed: () => {
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
                  SizedBox(height: 0.05 * size.height),
                  Container(
                    height: size.height * 0.06,
                    width: size.width * 0.4,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        primary: primaryColor,
                      ),
                      onPressed: () => {
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.edit_outlined, 
                            color: Colors.white, 
                            size: 20
                          ),
                          SizedBox(
                            width: 10
                          ),
                          Text(
                            'Edit profile',
                            textAlign:TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            )
                          ),
                        ],
                      )
                    )
                  ),
                  SizedBox(height: 0.05 * size.height),
                  
                  SizedBox(height: size.height * 0.01),
                  Container(
                    padding: EdgeInsets.only(left: 30),
                    height: size.height * 0.04,
                    width: size.width,
                    color: Colors.grey.shade300,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Settings',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: greyColor,
                          letterSpacing: 3,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            height: size.height * 0.08,
                            width: size.width,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                enableFeedback: false,
                              ),
                              onPressed: () => {
                                UserServices.logout(context),
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(left: 20),
                                        child:Icon(
                                          Icons.logout, 
                                          color: Colors.black87, 
                                          size: 25
                                        ),
                                      )
                                      
                                    ],
                                  ),
                                  SizedBox(
                                    width: 20
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Logout',
                                          textAlign:TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black87
                                          )
                                        ),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(right: 20),
                                        child: Icon(
                                          Icons.arrow_forward_ios_outlined, 
                                          color: Colors.black87, 
                                          size: 20
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              )
                            )
                          ),
                        ],
                      )
                    ],
                  ),
                ]
              )
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