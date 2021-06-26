import 'package:flutter/material.dart';
import 'package:sharp_parking_app/services/places_services.dart';
import 'package:sharp_parking_app/utils/suggestion.dart';

class AddressSearch extends SearchDelegate<Suggestion> {

  AddressSearch(this.sessionToken) {
    placeProvider = PlacesServices(sessionToken);
  }

  final sessionToken;
  PlacesServices placeProvider;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: FutureBuilder(
          future: query == "" ? null : placeProvider.fetchSuggestions(query, Localizations.localeOf(context).languageCode),
          builder: (context, snapshot) => query == '' ? 
            Container(
              padding: EdgeInsets.all(16.0),
              child: Text('Enter your parking destination'),
            ) : snapshot.hasData ? 
            ListView.builder(
              itemBuilder: (context, index) => ListTile(
                title:
                    Text((snapshot.data[index] as Suggestion).name),
                subtitle: Text((snapshot.data[index] as Suggestion).formattedAddress),
                onTap: () {
                  close(context, snapshot.data[index] as Suggestion);
                },
              ),
              itemCount: snapshot.data.length,
            ) : 
            Container(child: Text('Searching...')),
              )
    );
  }
}