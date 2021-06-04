import 'package:flutter/material.dart';

class User {
  final String id;
  String firstName;
  String lastName;
  String email;
  Object cars;
  String parkingSpotId;

  User({
    @required this.id, 
    @required this.firstName, 
    @required this.lastName, 
    @required this.email,
    @required this.cars,
    this.parkingSpotId
  });

  factory User.fromJson(Map<String, dynamic> json) => new User(
        id: json["_id"] == null ? null : json["_id"],
        firstName: json["firstName"] == null ? null : json["firstName"],
        lastName: json["lastName"] == null ? null : json["lastName"],
        email: json["email"] == null ? null : json["email"],
        cars: json["cars"] == null ? null : json["cars"],
        parkingSpotId: json["parkingSpot"] == null ? null : json["parkingSpot"]
    );

    Map<String, dynamic> toJson() => {
      "id": id == null ? null : id,
      "firstName": firstName == null ? null : firstName,
      "lastName": lastName == null ? null : lastName,
      "email": email == null ? null : email,
      "cars" : cars == null ? null : cars
    };
}