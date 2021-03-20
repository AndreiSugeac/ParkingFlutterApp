import 'package:flutter/material.dart';

class User {
  final String id;
  String firstName;
  String lastName;
  String email;

  User({
    @required this.id, 
    @required this.firstName, 
    @required this.lastName, 
    @required this.email
  });

  factory User.fromJson(Map<String, dynamic> json) => new User(
        id: json["_id"] == null ? null : json["_id"],
        firstName: json["firstName"] == null ? null : json["firstName"],
        lastName: json["lastName"] == null ? null : json["lastName"],
        email: json["email"] == null ? null : json["email"]
    );

    Map<String, dynamic> toJson() => {
      "id": id == null ? null : id,
      "firstName": firstName == null ? null : firstName,
      "lastName": lastName == null ? null : lastName,
      "email": email == null ? null : email
    };
}