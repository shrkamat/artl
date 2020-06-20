import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GqlConnection {
  ValueNotifier<GraphQLClient> client;

  static final GqlConnection _inst = GqlConnection._internal();

  GqlConnection._internal();

  factory GqlConnection(ValueNotifier<GraphQLClient> client) {
    _inst.client = client;
    return _inst;
  }

  static GqlConnection get instance => _inst;
}

