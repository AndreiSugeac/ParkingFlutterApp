import 'package:flutter/material.dart';
import 'package:sharp_parking_app/services/parking_spot_services.dart';
import 'package:sharp_parking_app/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:sharp_parking_app/widgets/toasts/warning_toast.dart';

class Scheduler extends StatefulWidget {

  Map schedule;
  String parkingSpotId;

  Scheduler(this.schedule, this.parkingSpotId);

  @override
  _SchedulerState createState() => _SchedulerState(this.schedule, this.parkingSpotId);
}

class _SchedulerState extends State<Scheduler> {

  Map schedule;
  String parkingSpotId;
  bool isActive;

  _SchedulerState(this.schedule, this.parkingSpotId) {
    isActive = schedule != null ? schedule['isActive'] : false;
    _startDateTime = schedule != null ? DateTime.parse(schedule['startDate']) : DateTime.now();
    _startTimeOfDay = schedule != null ? TimeOfDay(hour:int.parse(schedule['startTime'].split(":")[0]),minute: int.parse(schedule['startTime'].split(":")[1])) : TimeOfDay.now();
    _endTimeOfDay = schedule != null ? TimeOfDay(hour:int.parse(schedule['endTime'].split(":")[0]),minute: int.parse(schedule['endTime'].split(":")[1])) : TimeOfDay.now();
    _endDateTime = schedule != null ? DateTime.parse(schedule['endDate']) : DateTime.now();
  }
  
  DateTime _startDateTime;
  TimeOfDay _startTimeOfDay;

  DateTime _endDateTime;
  TimeOfDay _endTimeOfDay;

  Future<Null> selectStartDate(BuildContext context) async {
    final DateTime startDate = await showDatePicker(
      context: context, 
      initialDate: _startDateTime, 
      firstDate: new DateTime(2020), 
      lastDate: new DateTime(2023),
    );

    if(startDate != null && startDate != _startDateTime) {
      print('Date selected: ' + DateFormat("yyyy-MM-dd").format(startDate));
      setState(() {
        _startDateTime = startDate;
      });
    }
  }
  
  Future<Null> selectStartTime(BuildContext context) async {
    final TimeOfDay startTime = await showTimePicker(
      context: context, 
      initialTime: _startTimeOfDay, 
    );

    if(startTime != null && startTime != _startTimeOfDay) {
      print('Time selected: ' + startTime.toString());
      setState(() {
        _startTimeOfDay = startTime;
      });
    }
  }

  Future<void> setSchedule() async {
    try {
      final result = await ParkingSpotServices().updateSchedule(parkingSpotId,
        DateFormat("yyyy-MM-dd").format(_startDateTime), 
        _startTimeOfDay.hour.toString() + ':' + _startTimeOfDay.minute.toString(), 
        _endTimeOfDay.hour.toString() + ':' + _endTimeOfDay.minute.toString(), 
        DateFormat("yyyy-MM-dd").format(_endDateTime),
        !isActive);
    } on Exception catch(err) {
      var warning = WarningToast(err.toString());
      warning.showToast();
      return null;
    }

    setState(() {
      isActive = !isActive;
    });
  }

  Future<void> removeSchedule() async {
    try {
      final result = await ParkingSpotServices().updateSchedule(parkingSpotId,
        DateFormat("yyyy-MM-dd").format(_startDateTime), 
        _startTimeOfDay.hour.toString() + ':' + _startTimeOfDay.minute.toString(), 
        _endTimeOfDay.hour.toString() + ':' + _endTimeOfDay.minute.toString(), 
        DateFormat("yyyy-MM-dd").format(_endDateTime),
        !isActive);
    } on Exception catch(err) {
      var warning = WarningToast(err.toString());
      warning.showToast();
      return null;
    }

    setState(() {
      isActive = !isActive;
    });
  }

  Future<Null> selectEndTime(BuildContext context) async {
    final TimeOfDay endTime = await showTimePicker(
      context: context, 
      initialTime: _endTimeOfDay, 
    );

    if(endTime != null && endTime != _startTimeOfDay) {
      print('Time selected: ' + endTime.toString());
      setState(() {
        _endTimeOfDay = endTime;
      });
    }
  }

  Future<Null> selectEndDate(BuildContext context) async {
    final DateTime endDate = await showDatePicker(
      context: context, 
      initialDate: _endDateTime, 
      firstDate: new DateTime(2020), 
      lastDate: new DateTime(2023),
    );

    if(endDate != null && endDate != _endDateTime) {
      print('Date selected: ' + DateFormat("yyyy-MM-dd").format(endDate));
      setState(() {
        _endDateTime = endDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: size.height * 0.1),
          Container(
            alignment: Alignment.center,
            child: Text(
              'SCHEDULER',
              style: TextStyle(color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600
              ),
            ),
          ),
          SizedBox(height: size.height * 0.075),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Text(
              'Make a schedule for your parking spot in order to share it with the SharP community.',
              textAlign: TextAlign.center,
              style: TextStyle(color: greyColor),
            ),
          ),
          SizedBox(height: size.height * 0.075),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Start date: ' + DateFormat("yyyy-MM-dd").format(_startDateTime),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  SizedBox(height: size.height * 0.075),
                  Container(
                    child: _startTimeOfDay.hour < 10 && _startTimeOfDay.minute >= 10 ? 
                    Text(
                      'Start time: ' + '0' +_startTimeOfDay.hour.toString() + ':' + _startTimeOfDay.minute.toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500
                      ),
                    ) : _startTimeOfDay.hour < 10 && _startTimeOfDay.minute < 10 ? 
                    Text(
                      'Start time: ' + '0' +_startTimeOfDay.hour.toString() + ':' + '0' +  _startTimeOfDay.minute.toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500
                      )
                    ) : _startTimeOfDay.hour >= 10 && _startTimeOfDay.minute < 10 ? 
                    Text(
                    'Start time: ' +_startTimeOfDay.hour.toString() + ':' + '0' +  _startTimeOfDay.minute.toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500
                      )
                    ) : Text(
                      'Start time: ' +_startTimeOfDay.hour.toString() + ':'+  _startTimeOfDay.minute.toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500
                      )
                    )
                  ),
                  SizedBox(height: size.height * 0.065),
                  Container(
                    child: _endTimeOfDay.hour < 10 && _endTimeOfDay.minute >= 10 ? 
                    Text(
                      'End time: ' + '0' +_endTimeOfDay.hour.toString() + ':' + _endTimeOfDay.minute.toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500
                      ),
                    ) : _endTimeOfDay.hour < 10 && _endTimeOfDay.minute < 10 ? 
                    Text(
                      'End time: ' + '0' +_endTimeOfDay.hour.toString() + ':' + '0' +  _endTimeOfDay.minute.toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500
                      )
                    ) : _endTimeOfDay.hour >= 10 && _endTimeOfDay.minute < 10 ? 
                    Text(
                    'End time: ' +_endTimeOfDay.hour.toString() + ':' + '0' +  _endTimeOfDay.minute.toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500
                      )
                    ) : Text(
                      'End time: ' +_endTimeOfDay.hour.toString() + ':'+  _endTimeOfDay.minute.toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500
                      )
                    )
                  ),
                  SizedBox(height: size.height * 0.075),
                  Text(
                    'End date: ' + DateFormat("yyyy-MM-dd").format(_endDateTime),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ]
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () => {
                        selectStartDate(context)
                      }, 
                      child: Text(
                        'SELECT',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: primaryColor
                      ),
                    ),
                    SizedBox(height: size.height * 0.025),
                    ElevatedButton(
                      onPressed: () => {
                        selectStartTime(context)
                      }, 
                      child: Text(
                        'SELECT',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: primaryColor
                      ),
                    ),
                    SizedBox(height: size.height * 0.025),
                    ElevatedButton(
                      onPressed: () => {
                        selectEndTime(context)
                      }, 
                      child: Text(
                        'SELECT',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: primaryColor
                      ),
                    ),
                    SizedBox(height: size.height * 0.025),
                    ElevatedButton(
                      onPressed: () => {
                        selectEndDate(context)
                      }, 
                      child: Text(
                        'SELECT',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: primaryColor
                      ),
                    )
                  ]
                ) 
              ),
            ],
          ),
          SizedBox(height: size.height * 0.06),
          Container(
            alignment: Alignment.center,
            height: size.height * 0.06,
            width: size.width * 0.75,
            child: ElevatedButton(
              onPressed: !isActive ? () => {
                setSchedule()
              } : () => {}, 
              child: Text(
                'SET SCHEDULE',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: isActive ? greyColor : primaryColor,
                minimumSize: Size(size.width * 0.75, size.height * 0.06)
              ),
            ),
          ),
          SizedBox(height: size.height * 0.035),
          Container(
            alignment: Alignment.center,
            height: size.height * 0.06,
            width: size.width * 0.75,
            child: ElevatedButton(
              onPressed: isActive ? () => {
                removeSchedule()
              } : () => {}, 
              child: Text(
                'REMOVE SCHEDULE',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: isActive ? primaryColor : greyColor,
                minimumSize: Size(size.width * 0.75, size.height * 0.06)
              ),
            ),
          )
        ]
      )
    );
  }
}