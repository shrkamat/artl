import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import "package:artl/gql_connection.dart";
import 'package:artl/country.dart';

void main() {
  runApp(MaterialApp(
    title: "ARTL",
    home: ArtlApp(),
  ));
}

String qContinents = r"""
query {
  continents {
    code
    name
  }
}
""";

class ArtlApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HttpLink link = HttpLink(
      uri: "https://countries.trevorblades.com/",
    );
    final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
      GraphQLClient(
          link: link as Link,
          cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject)),
    );

    var conn = GqlConnection(client);

    return GraphQLProvider(
      child: HomePage(),
      client: conn.client,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ARTL")),
      body: Query(
        options: QueryOptions(documentNode: gql(qContinents)),
        builder: (QueryResult result,
            {VoidCallback refetch, FetchMore fetchMore}) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }
          if (result.loading) {
            return Text('Loading');
          }
          List<dynamic> continents = result.data['continents'];

          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(continents[index]['name']),
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) {
                        return CountryPage();
                  }));
                },
              );
            },
            itemCount: continents.length,
          );
        },
      ),
    );
  }
}
