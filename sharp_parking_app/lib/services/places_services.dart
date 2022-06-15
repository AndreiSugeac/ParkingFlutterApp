import 'dart:convert';
import 'package:http/http.dart';
import 'package:sharp_parking_app/utils/suggestion.dart';
import 'package:sharp_parking_app/widgets/toasts/warning_toast.dart';

class PlacesServices {
  final client = Client();

  PlacesServices(this.sessionToken);

  final sessionToken;

  final apiKey = '';

  Future<List<Suggestion>> getSuggestions(String input, String lang) async {
    final request = 'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&fields=formatted_address,geometry,name,place_id,plus_code,types&language=$lang&key=$apiKey&sessiontoken=$sessionToken,components=country:ro';
    final response = await client.get(request);

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        return result['candidates']
            .map<Suggestion>((p) => Suggestion(p['place_id'], p['name'], p['description'], p['formatted_address'], p['geometry']['location']['lat'],  p['geometry']['location']['lng']))
            .toList();
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return [];
      }
      WarningToast(result['error_message']).showToast();
      return [];
    } else {
      WarningToast("Error while providing the suggestions.").showToast();
      return [];
    }
  }
}
