import 'package:flutter/material.dart';
import '../services/CountryService.dart';
import 'CountryNameWidget.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class CountryScreen extends StatelessWidget {
  final CountryService countryService;

  //fetch country screen
  const CountryScreen({super.key, required this.countryService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Countries and Capitals'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              _navigateToCountryNameWidget(context, countryService.client);
            },
            child: const Text('Get countries with UZ and TN codes'),
          ),
          FutureBuilder<List<Map<String, String>>>(
            future: countryService.getAllCountriesAndCapitals(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final List<Map<String, String>> countriesAndCapitals =
                snapshot.data!;
                return Expanded(
                  child: ListView.builder(
                    itemCount: countriesAndCapitals.length,
                    itemBuilder: (context, index) {
                      final country = countriesAndCapitals[index];
                      return Column(
                        children: [
                          ListTile(
                            title: Text(
                              country['name'] ?? 'N/A',
                              style: const TextStyle(fontSize: 18, color: Colors.black), // Increase font size and set color
                            ),
                            subtitle: Text(
                              country['capital'] ?? 'N/A',
                              style: const TextStyle(fontSize: 14, color: Colors.grey), // Decrease font size and set color
                            ),
                          ),
                          Container( // Add a container to apply margin to the divider
                            margin: const EdgeInsets.symmetric(horizontal: 16), // Adjust the margin as needed
                            child: const Divider(
                              color: Colors.grey, // Set the color to grey
                              height: 1, // Set the height to control the thickness
                              thickness: 1, // Set the thickness of the divider
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );

              }
            },
          ),
        ],
      ),
    );
  }
}


void _navigateToCountryNameWidget(BuildContext context, GraphQLClient client) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => CountryNameWidget(client: client)));
}

