import 'package:flutter/material.dart';

class ParkingSpot {
  final String id;
  Object location;
  Object parkingBlock;

  ParkingSpot({
    @required this.id, 
    @required this.location,
    @required this.parkingBlock
  });

  factory ParkingSpot.fromJson(Map<String, dynamic> json) => new ParkingSpot(
        id: json["_id"] == null ? null : json["_id"],
        location: json["location"] == null ? null : json["location"],
        parkingBlock: json["parkingBlock"] == null ? null : json["parkingBlock"]
    );

    Map<String, dynamic> toJson() => {
      "id": id == null ? null : id,
      "location": location == null ? null : location,
      "parkingBlock" : parkingBlock == null ? null : parkingBlock
    };
}