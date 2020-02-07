import 'package:dpa/components/widget/connected_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:redux/src/store.dart';

class ActionWidget extends StatefulWidget {
  static const PATH = "/";
  final String initialRoute;

  const ActionWidget({@required this.initialRoute});

  @override
  _ActionWidgetState createState() => _ActionWidgetState();
}

class _ActionWidgetState extends CustomStoreConnectedStateWithLifecycle<
    ActionWidget, Function(BuildContext)> {
  bool pushInitialRoute = true;
  Function(BuildContext) lastAction;

  @override
  Widget buildWithStore(BuildContext context, Function(BuildContext) action) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => processAction(context, action));
    return Scaffold();
  }

  @override
  Function(BuildContext) converter(Store store) {
    return store.state.function;
  }

  void processAction(BuildContext context, Function(BuildContext) action) {
    if (pushInitialRoute) {
      Navigator.pushNamed(context, widget.initialRoute);
      pushInitialRoute = false;
    } else if (action != null && lastAction != action) {
      lastAction = action;
      action(context);
    }
  }
}
