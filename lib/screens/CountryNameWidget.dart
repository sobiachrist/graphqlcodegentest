import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart'; // Import GraphQLClient

class CountryNameWidget extends StatefulWidget {
  final GraphQLClient client;

  const CountryNameWidget({super.key, required this.client});

  @override
  _CountryNameWidgetState createState() => _CountryNameWidgetState();
}

class _CountryNameWidgetState extends State<CountryNameWidget> {
  String? country1Name;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () => _fetchCountryName("UZ"),
          child: const Text('Get Uzbekistan'),
        ),
        const SizedBox(height: 16), // Add margin between buttons
        ElevatedButton(
          onPressed: () => _fetchCountryName("TN"),
          child: const Text('Get Tunisia'),
        ),
        if (country1Name != null)
          Container(
            margin: const EdgeInsets.only(top: 16), // Add top margin
            child: Text(
              'Selected Country : $country1Name',
              style: const TextStyle(fontSize: 16),
            ),
          ),
      ],
    );
  }

  Future<void> _fetchCountryName(String countryCode) async {
    const String getCountryQuery = r'''
      query getCountry($code: ID!) {
        country(code: $code) {
          name
        }
      }
    ''';

    final QueryOptions options = QueryOptions(
      document: gql(getCountryQuery),
      variables: {'code': countryCode},
    );

    final QueryResult result = await widget.client.query(options);

    if (result.hasException) {
      print('GraphQL Error: ${result.exception.toString()}');
      // Handle error if needed
    } else {
      final String countryName = result.data!['country']['name'];
      print('GraphQL SUCCESS: $countryName');

      setState(() {
        country1Name = countryName;
      });
    }
  }
}
