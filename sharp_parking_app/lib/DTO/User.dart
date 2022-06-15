import 'package:flutter/material.dart';

class User {
  final int id;
  String firstName;
  String lastName;
  String email;
  Object cars;
  String parkingSpot;

  User({
    @required this.id, 
    @required this.firstName, 
    @required this.lastName, 
    @required this.email,
    this.cars,
    this.parkingSpot
  });

  factory User.fromJson(Map<String, dynamic> json) => new User(
        id: json["id"] == null ? null : json["id"],
        firstName: json["firstName"] == null ? null : json["firstName"],
        lastName: json["lastName"] == null ? null : json["lastName"],
        email: json["email"] == null ? null : json["email"],
    );

    Map<String, dynamic> toJson() => {
      "id": id == null ? null : id,
      "firstName": firstName == null ? null : firstName,
      "lastName": lastName == null ? null : lastName,
      "email": email == null ? null : email
    };
}