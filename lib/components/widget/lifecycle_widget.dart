import 'package:dpa/store/global/app_actions.dart';
import 'package:dpa/store/global/app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

abstract class ScreenState<T extends StatefulWidget>
    extends LifecycleWidgetState<T> {
  final String path;
  Function updateCurrentPath;

  ScreenState(this.path);

  Widget buildWithChild(Widget child) {
    return StoreConnector<AppState, Function>(
        converter: (store) => () {
              if (store.state.currentPath != path)
                store.dispatch(RouteUpdatedAction(path));
            },
        builder: (context, updateFunction) {
          updateCurrentPath = updateFunction;
          return super.buildWithChild(child);
        });
  }

  void onResume() {
    if (updateCurrentPath != null) updateCurrentPath();
  }
}

abstract class LifecycleWidgetState<T extends StatefulWidget> extends State<T>
    with WidgetsBindingObserver {
  Widget buildWithChild(Widget child) {
    return StoreConnector<AppState, Function>(
        converter: (store) => () => store.dispatch(
            RouteAction(destination: null, type: RouteActionType.Pop)),
        builder: (context, popFunction) {
          return WillPopScope(
              child: child,
              onWillPop: () {
                popFunction();
                return new Future(() => false);
              });
        });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // user returned to our app
      onResume();
    } else if (state == AppLifecycleState.inactive) {
      // app is inactive
    } else if (state == AppLifecycleState.paused) {
      // user is about quit our app temporally
      onPause();
    } else if (state == AppLifecycleState.detached) {
      // app detached
    }
  }

  void onPause() {}

  void onResume() {}
}
