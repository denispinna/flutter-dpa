import 'package:dpa/components/logger.dart';
import 'package:dpa/components/widget/lifecycle_widget.dart';
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
    Logger.log(runtimeType.toString(), "build");

    return StoreConnector<AppState, O>(
      converter: converter,
      builder: buildWithStore,
    );
  }

  O converter(Store store);

  Widget buildWithStore(BuildContext context, O output);
}

abstract class CustomConnectedScreenState<W extends StatefulWidget, O>
    extends ScreenState<W> {
  @override
  Widget buildScreenWidget(BuildContext context) {
    return StoreConnector<AppState, O>(
      converter: converter,
      builder: buildWithStore,
    );
  }

  O converter(Store store);

  Widget buildWithStore(BuildContext context, O output);
}

abstract class CustomStoreConnectedStateWithLifecycle<W extends StatefulWidget,
    O> extends LifecycleWidgetState<W> {
  CustomStoreConnectedStateWithLifecycle();

  @override
  Widget buildWithLifecycle(BuildContext context) {
    return StoreConnector<AppState, Store>(
        converter: (store) => store,
        builder: (context, store) {
          O output = converter(store);
          return buildWithStore(context, output);
        });
  }

  O converter(Store store);

  Widget buildWithStore(BuildContext context, O output);
}
