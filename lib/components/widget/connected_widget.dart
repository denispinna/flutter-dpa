import 'package:dpa/components/widget/lifecycle_widget.dart';
import 'package:dpa/store/global/app_actions.dart';
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

abstract class CustomStoreConnectedStateWithLifecycle<W extends StatefulWidget, O>
    extends LifecycleWidgetState<W> {
  final String path;
  Function updateCurrentPath;

  CustomStoreConnectedStateWithLifecycle(this.path);

  @override
  Widget buildWithLifecycle(BuildContext context) {
    return StoreConnector<AppState, Store>(
        converter: (store) => store,
        builder: (context, store) {
          updateCurrentPath = () {
            if (store.state.currentPath != path)
              store.dispatch(RouteUpdatedAction(path));
          };
          O output = converter(store);
          return buildWithStore(context, output);
        });
  }

  void onResume() {
    if (updateCurrentPath != null) updateCurrentPath();
  }

  O converter(Store store);

  Widget buildWithStore(BuildContext context, O output);
}

abstract class ScreenState<W extends StatefulWidget> extends CustomStoreConnectedStateWithLifecycle<W, Function> {
  ScreenState(String path): super(path);
  Function popAction;

  @override
  Function converter(Store store) {
    popAction = () => store.dispatch(RouteAction(type: RouteActionType.Pop));
    return _pop;
  }

  Future<bool> _pop() async {
    return true;
  }

  @override
  Widget buildWithStore(BuildContext context, Function popFunction) {
    return new WillPopScope(
      onWillPop: popFunction,
      child: buildScreenWidget(context),
    );
  }

  Widget buildScreenWidget(BuildContext context);
}