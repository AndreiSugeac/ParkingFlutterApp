import 'package:flutter/material.dart';

class ParkingSpot {
  final String id;
  Map location;
  Map parkingBlock;
  Map schedule;
  bool available;

  ParkingSpot({
    @required this.id, 
    @required this.location,
    @required this.parkingBlock,
    @required this.schedule,
    @required this.available
  });

  factory ParkingSpot.fromJson(Map<String, dynamic> json) => new ParkingSpot(
        id: json["_id"] == null ? null : json["_id"],
        location: json["location"] == null ? null : json["location"],
        parkingBlock: json["parkingBlock"] == null ? null : json["parkingBlock"],
        available: json["available"] == null ? null : json["available"],
        schedule: json["schedule"] == null ? null : json["schedule"]
    );

    Map<String, dynamic> toJson() => {
      "id": id == null ? null : id,
      "location": location == null ? null : location,
      "parkingBlock" : parkingBlock == null ? null : parkingBlock,
      "available": available == null ? null : available,
      "schedule": schedule == null ? null : schedule,
    };
}