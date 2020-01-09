import 'package:dpa/store/global/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

abstract class StoreConnectedState<W extends StatefulWidget>
    extends CustomStoreConnectedState<W, Store> {
  Store converter(Store store) => store;
}

abstract class CustomStoreConnectedState<W extends StatefulWidget, O>
    extends State<W> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, O>(
      converter: converter,
      builder: buildWithStore,
    );
  }

  O converter(Store store);

  Widget buildWithStore(BuildContext context, O output);
}