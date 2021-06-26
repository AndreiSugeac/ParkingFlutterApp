import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart';
import 'package:sharp_parking_app/utils/suggestion.dart';

class PlacesServices {
  final client = Client();

  PlacesServices(this.sessionToken);

  final sessionToken;

  final apiKey = 'AIzaSyAJGP0ksxkw8qXSSi-YgZSRDExZ_EwrU6U';

  Future<List<Suggestion>> fetchSuggestions(String input, String lang) async {
    final request =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&fields=formatted_address,geometry,name,place_id,plus_code,types&language=$lang&key=$apiKey&sessiontoken=$sessionToken,components=country:ro';
    final response = await client.get(request);

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        // compose suggestions in a list
        return result['candidates']
            .map<Suggestion>((p) => Suggestion(p['place_id'], p['name'], p['description'], p['formatted_address'], p['geometry']['location']['lat'],  p['geometry']['location']['lng']))
            .toList();
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return [];
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  // Future<Place> getPlaceDetailFromId(String placeId) async {
  //   final request =
  //       'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=address_component&key=$apiKey&sessiontoken=$sessionToken';
  //   final response = await client.get(request);

  //   if (response.statusCode == 200) {
  //     final result = json.decode(response.body);
  //     if (result['status'] == 'OK') {
  //       final components =
  //           result['result']['address_components'] as List<dynamic>;
  //       // build result
  //       final place = Place();
  //       components.forEach((c) {
  //         final List type = c['types'];
  //         if (type.contains('street_number')) {
  //           place.streetNumber = c['long_name'];
  //         }
  //         if (type.contains('route')) {
  //           place.street = c['long_name'];
  //         }
  //         if (type.contains('locality')) {
  //           place.city = c['long_name'];
  //         }
  //         if (type.contains('postal_code')) {
  //           place.zipCode = c['long_name'];
  //         }
  //       });
  //       return place;
  //     }
  //     throw Exception(result['error_message']);
  //   } else {
  //     throw Exception('Failed to fetch suggestion');
  //   }
  // }
}

// class Place {
//   String streetNumber;
//   String street;
//   String city;
//   String zipCode;

//   Place({
//     this.streetNumber,
//     this.street,
//     this.city,
//     this.zipCode,
//   });

//   @override
//   String toString() {
//     return 'Place(streetNumber: $streetNumber, street: $street, city: $city, zipCode: $zipCode)';
//   }
// }