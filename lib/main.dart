import 'package:flutter/material.dart';
import '../../services/GraphQLClientSetup.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'services/CountryService.dart';
import 'screens/CountryScreen.dart';

class MyApp extends StatelessWidget {
  final GraphQLClient client;

  const MyApp({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: ValueNotifier<GraphQLClient>(client),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: CountryScreen(countryService: CountryService(client)),
      ),
    );
  }
}

void main() {
  final ValueNotifier<GraphQLClient> clientNotifier =
  GraphQLClientSetup.initializeClient();
  runApp(MyApp(client: clientNotifier.value));
}



