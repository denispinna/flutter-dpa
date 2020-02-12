import 'dart:async';

import 'package:dpa/components/app_localization.dart';
import 'package:dpa/components/logger.dart';
import 'package:dpa/components/widget/loading_widget.dart';
import 'package:dpa/store/global/app_state.dart';
import 'package:dpa/theme/colors.dart';
import 'package:dpa/theme/dimens.dart';
import 'package:dpa/theme/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:redux/redux.dart';

abstract class StoreConnectedState<W extends StatefulWidget, O>
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

abstract class StateWithLoading<W extends StatefulWidget> extends State<W> {
  dynamic error;
  bool isLoading = true;

  bool get displayDataWidget => !isLoading;


  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context) {
    Logger.log(runtimeType.toString(), "build");
    return (error != null)
        ? buildErrorWidget(context)
        : (displayDataWidget)
            ? buildDataWidget(context)
            : buildLoadingWidget(context);
  }

  Widget buildLoadingWidget(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.light,
      body: LoadingWidget(showLabel: false),
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
    if (showLoading)
      setState(() {
        isLoading = true;
      });
    await loadFunction().then(onSuccess).catchError(onError);
  }

  Future loadFunction();

  Future retry() async {
    error = null;
    isLoading = true;
    setState(() {});
    await Future.delayed(Duration(milliseconds: 500));
    error = null;
    load();
  }

  void onError(dynamic error) {
    isLoading = false;
    this.error = error;
    Logger.logError(
        this.runtimeType.toString(), "Error while fetching data", error);
    setState(() {});
  }

  FutureOr onSuccess(dynamic value) {
    isLoading = false;
    setState(() {});
  }

  Widget buildDataWidget(BuildContext context);
}
