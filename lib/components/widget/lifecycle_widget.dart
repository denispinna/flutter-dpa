import 'package:dpa/components/logger.dart';
import 'package:dpa/util/view_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class LifecycleWidgetState<T extends StatefulWidget> extends State<T>
    with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    Logger.log(runtimeType.toString(), "build");
    return buildWithLifecycle(context);
  }

  Widget buildWithLifecycle(BuildContext context);

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

abstract class ScreenState<W extends StatefulWidget>
    extends LifecycleWidgetState<W> {
  @override
  Widget buildWithLifecycle(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async {
        if (leaveAppOnPop) {
          askToLeaveApp(context);
          return false;
        } else if (Navigator.canPop(context))
          return true;
        else
          return false;
      },
      child: buildScreenWidget(context),
    );
  }

  Widget buildScreenWidget(BuildContext context);

  bool get leaveAppOnPop => false;
}
