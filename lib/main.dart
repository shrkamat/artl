import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:gql/ast.dart';

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

String qCountry = r"""
query {
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
    return GraphQLProvider(
      child: HomePage(),
      client: client,
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
              print(continents[index]['name']);
              return ListTile(
                title: Text(continents[index]['name']),
              );
            },
            itemCount: continents.length,
          );
        },
      ),
    );
  }
}
