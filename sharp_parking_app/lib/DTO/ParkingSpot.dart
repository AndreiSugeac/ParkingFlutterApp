import 'package:flutter/material.dart';

class ParkingSpot {
  final int id;
  Map location;
  Map parkingBlock;
  Map schedule;
  bool available;

  ParkingSpot({
    this.id, 
    this.location,
    this.schedule,
    this.available
  });

  factory ParkingSpot.fromJson(Map<String, dynamic> json) => new ParkingSpot(
        id: json["id"] == null ? null : json["id"],
        location: json["location"] == null ? null : json["location"],
        available: json["available"] == null ? null : json["available"],
        schedule: json["schedule"] == null ? null : json["schedule"]
    );

    Map<String, dynamic> toJson() => {
      "id": id == null ? null : id,
      "location": location == null ? null : location,
      "available": available == null ? null : available,
      "schedule": schedule == null ? null : schedule,
    };
}