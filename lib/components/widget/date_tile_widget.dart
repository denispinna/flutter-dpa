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
        padding: const EdgeInsets.all(Dimens.xxxxs),
        child: Container(
          width: Dimens.date_tile_width,
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: AspectRatio(
              aspectRatio: 2/3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    weekDay,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: Dimens.font_s,
                        fontWeight: FontWeight.bold,
                        color: MyColors.second),
                    maxLines: 1,
                  ),
                  Text(
                    day,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: Dimens.font_s,
                        fontWeight: FontWeight.bold,
                        color: MyColors.second),
                    maxLines: 1,
                  ),
                  Text(
                    month,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: Dimens.font_s,
                        fontWeight: FontWeight.bold,
                        color: MyColors.second),
                    maxLines: 1,
                  )
                ],
              ),
            ),
          ),
          decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                color: MyColors.second,
                width: Dimens.xxxxs,
              ),
              borderRadius:
                  new BorderRadius.all(const Radius.circular(Dimens.s))),
        ));
  }
}
