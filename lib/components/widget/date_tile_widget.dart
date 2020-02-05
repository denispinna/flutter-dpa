import 'package:dpa/theme/colors.dart';
import 'package:dpa/theme/dimens.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTile extends StatelessWidget {
  final DateTime date;

  const DateTile(this.date) : super();

  @override
  Widget build(BuildContext context) {
    if (date == null) return null;

    var weekDay = DateFormat("EEEE").format(date).substring(0, 3).toUpperCase();
    var day = DateFormat("d").format(date);
    var month = DateFormat("MMMM").format(date).substring(0, 3).toUpperCase();

    return Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimens.xxxxs),
        child: Container(
          width: Dimens.date_tile_width,
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: AspectRatio(
              aspectRatio: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    weekDay,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: Dimens.font_s,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    maxLines: 1,
                  ),
                  Text(
                    day,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: Dimens.font_s,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    maxLines: 1,
                  ),
                  Text(
                    month,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: Dimens.font_s,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    maxLines: 1,
                  )
                ],
              ),
            ),
          ),
          decoration: BoxDecoration(
              color: MyColors.blue_google.withOpacity(0.5),
              border: Border.all(
                color: Colors.transparent,
                width: Dimens.xxxxs,
              ),
              borderRadius:
                  new BorderRadius.all(const Radius.circular(Dimens.s))),
        ));
  }
}

class DateTileWide extends StatelessWidget {
  final DateTime date;

  const DateTileWide(this.date) : super();

  @override
  Widget build(BuildContext context) {
    if (date == null) return null;

    var weekDay = new DateFormat("EEEE d - MMMM y").format(date).toUpperCase();

    return Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimens.s),
        child: Container(
          height: Dimens.date_title_height,
          width: Dimens.date_tile_width,
          child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Center(
                child: Text(
                  weekDay,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: Dimens.font_m,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  maxLines: 1,
                ),
              )),
          decoration: BoxDecoration(
              color: MyColors.blue_google.withOpacity(0.5),
              border: Border.all(
                color: Colors.transparent,
                width: Dimens.xxxxs,
              ),
              borderRadius:
                  new BorderRadius.all(const Radius.circular(Dimens.xxs))),
        ));
  }
}

class DateTitle extends StatelessWidget {
  final DateTime date;

  const DateTitle(this.date) : super();

  @override
  Widget build(BuildContext context) {
    if (date == null) return null;

    var weekDay = new DateFormat("EEEE, d MMMM").format(date).toUpperCase();

    return Text(
        weekDay,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: Dimens.font_sm,
            fontWeight: FontWeight.bold,
            color: MyColors.light_gray),
        maxLines: 1,
      );
  }
}
