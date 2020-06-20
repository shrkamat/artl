import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:artl/gql_connection.dart';

String qCountry = r"""
query GetCountries($code : ID!){
  continent(code: $code) {
    code
    name
    countries {
      code
      name
    }
  }
}
""";

class Country extends StatefulWidget {
  final String countryCode;

  const Country({Key key, this.countryCode}) : super(key: key);

  @override
  _CountryState createState() => _CountryState();
}

class _CountryState extends State<Country> {
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: GqlConnection.instance.client,
      child: Scaffold(
        appBar: AppBar(
          title: Text("ARTL-Country"),
        ),
        body: Query(
          options: QueryOptions(
              documentNode: gql(qCountry),
              variables: <String, dynamic>{"code": widget.countryCode}),
          builder: (
            QueryResult result, {
            Refetch refetch,
            FetchMore fetchMore,
          }) {
            if (result.hasException) {
              return Text(result.exception.toString());
            }

            if (result.loading) {
              return Text('Loading');
            }

            List<dynamic> countries = result.data['continent']['countries'];

            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(countries[index]['name']),
                );
              },
              itemCount: countries.length,
            );
          },
        ),
      ),
    );
  }
}
