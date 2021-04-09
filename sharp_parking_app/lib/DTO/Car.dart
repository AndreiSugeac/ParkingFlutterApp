import 'package:flutter/material.dart';

class Car {
  final int id;
  String brand;
  String model;
  String licensePlate;
  String color;

  Car({
    @required this.id, 
    @required this.brand, 
    @required this.model, 
    @required this.licensePlate,
    @required this.color
  });

  factory Car.fromJson(Map<String, dynamic> json) => new Car(
        id: json["_id"] == null ? null : json["_id"],
        brand: json["brand"] == null ? null : json["brand"],
        model: json["model"] == null ? null : json["model"],
        licensePlate: json["licensePlate"] == null ? null : json["licensePlate"],
        color: json["color"] == null ? null : json["color"]
    );

    Map<String, dynamic> toJson() => {
      "_id": id == null ? null : id,
      "brand": brand == null ? null : brand,
      "model": model == null ? null : model,
      "licensePlate": licensePlate == null ? null : licensePlate,
      "color" : color == null ? null : color
    };
}