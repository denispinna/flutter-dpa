import 'package:dpa/store/global/app_actions.dart';
import 'package:dpa/store/global/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class NavWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NavState();
}

class NavState extends State<NavWidget> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, NavUpdateItem>(
      converter: (store) => NavUpdateItem(
          state: store.state,
          updateDestination: (destination)
          => store.dispatch(RouteUpdatedAction(destination))),
      builder: (context, item) {
        if (item.state.shouldUpdateNav())
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => updateNavigation(context, item));
        return Container();
      },
    );
  }

  void updateNavigation(BuildContext context, NavUpdateItem item) {
    final action = item.state.routeAction;
    if (action == null) return;

    switch (action.type) {
      case RouteActionType.Pop:
        if (action.destination != null)
          Navigator.popUntil(context, ModalRoute.withName(action.destination));
        else
          Navigator.pop(context);
        break;
      case RouteActionType.Push:
        Navigator.pushNamed(context, action.destination);
        break;
      case RouteActionType.Replace:
        Navigator.pushReplacementNamed(context, action.destination);
        break;
    }
    item.updateDestination(action.destination);
  }
}

class NavUpdateItem {
  final AppState state;
  final Function(String) updateDestination;

  NavUpdateItem({this.state, this.updateDestination});
}
