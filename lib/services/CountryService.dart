import 'package:graphql_flutter/graphql_flutter.dart';


class CountryService {
  final GraphQLClient client;

  CountryService(this.client);

  Future<Map<String, String>> getCountry(String countryCode) async {
    const String getCountryQuery = r'''
      query getCountry($code: String!) {
        country(code: $code) {
          name
          capital
        }
      }
    ''';

    final QueryOptions options = QueryOptions(
      document: gql(getCountryQuery),
      variables: {'code': countryCode},
    );

    final QueryResult result = await client.query(options);

    if (result.hasException) {
      throw Exception('GraphQL Error: ${result.exception.toString()}');
    }

    return {
      'name': result.data!['country']['name'],
      'capital': result.data!['country']['capital'] ?? 'N/A',
    };
  }

  Future<List<Map<String, String>>> getAllCountriesAndCapitals() async {
    const String getAllCountriesQuery = r'''
      query getAllCountries {
        countries {
          name
          capital
        }
      }
    ''';

    final QueryOptions options = QueryOptions(
      document: gql(getAllCountriesQuery),
    );

    final QueryResult result = await client.query(options);

    if (result.hasException) {
      throw Exception('GraphQL Error: ${result.exception.toString()}');
    }

    final List<dynamic> countryData = result.data!['countries'];
    return countryData
        .map<Map<String, String>>((country) => {
      'name': country['name'],
      'capital': country['capital'] ?? 'N/A',
    })
        .toList();
  }
}

