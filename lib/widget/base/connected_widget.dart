import 'dart:async';

import 'package:dpa/components/app_localization.dart';
import 'package:dpa/components/logger.dart';
import 'package:dpa/store/global/app_state.dart';
import 'package:dpa/theme/colors.dart';
import 'package:dpa/theme/dimens.dart';
import 'package:dpa/theme/images.dart';
import 'package:dpa/widget/base/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:redux/redux.dart';

abstract class StoreConnectedState<W extends StatefulWidget, O>
    extends State<W> {
  @override
  Widget build(BuildContext context) {
    Logger.log(runtimeType.toString(), "build $this");

    return StoreConnector<AppState, O>(
      converter: converter,
      builder: buildWithStore,
    );
  }

  O converter(Store store);

  Widget buildWithStore(BuildContext context, O output);
}

//TODO: Add an empty state
//TODO: Add pull to refresh
abstract class StateWithLoading<W extends StatefulWidget> extends State<W> {
  dynamic error;
  bool isLoading = true;

  bool get displayDataWidget => !isLoading;

  @override
  void initState() {
    super.initState();
    Logger.log(runtimeType.toString(), 'initState $this');
    if (shouldLoad())
      load();
    else
      isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    onBuild(context);
    Logger.log(runtimeType.toString(), 'build $this');
    return (error != null)
        ? buildErrorWidget(context)
        : (displayDataWidget)
        ? buildWidget(context)
        : buildLoadingWidget(context);
  }

  Widget buildLoadingWidget(BuildContext context) {
    Widget loading = LoadingWidget(showLabel: false);
    if (backgroundColor == null) {
      return loading;
    }
    return Scaffold(
      backgroundColor: backgroundColor,
      body: loading,
    );
  }

  Widget buildErrorWidget(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.light,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(MyImages.error,
                height: Dimens.error_icon_width,
                width: Dimens.error_icon_width),
            SizedBox(height: Dimens.s),
            Text(
              AppLocalizations.of(context).translate('generic_error_message'),
              style:
              TextStyle(fontSize: Dimens.font_xl, color: MyColors.second),
            ),
            SizedBox(height: Dimens.s),
            RaisedButton(
              elevation: Dimens.xxs,
              color: MyColors.white,
              onPressed: () => retry(),
              child: Text(AppLocalizations.of(context).translate('retry')),
            )
          ],
        ),
      ),
    );
  }

  Future load({bool showLoading = false}) async {
    Logger.log(runtimeType.toString(), 'load $this');
    if (showLoading && mounted) {
      setState(() {
        isLoading = true;
      });
    }
    await loadFunction().then(onSuccess).catchError(onError);
  }

  Future loadFunction();

  Future retry() async {
    error = null;
    isLoading = true;
    if (mounted) setState(() {});
    await Future.delayed(Duration(milliseconds: 500));
    error = null;
    load();
  }

  void onError(dynamic error, StackTrace stackTrace) {
    isLoading = false;
    this.error = error;
    Logger.logError(
        this.runtimeType.toString(), "Error while loading", error,
        stackTrace: stackTrace);
    if (mounted) setState(() {});
  }

  FutureOr onSuccess(dynamic value) {
    isLoading = false;
    if (mounted) setState(() {});
  }

  Color get backgroundColor => MyColors.light;

  Widget buildWidget(BuildContext context);

  void onBuild(BuildContext context) {}

  bool shouldLoad() => true;
}
