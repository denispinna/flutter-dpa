import 'package:dpa/components/app_localization.dart';
import 'package:dpa/components/widget/date_tile_widget.dart';
import 'package:dpa/components/widget/mood_label.dart';
import 'package:dpa/models/mood.dart';
import 'package:dpa/models/stat_item.dart';
import 'package:dpa/theme/colors.dart';
import 'package:dpa/theme/dimens.dart';
import 'package:dpa/theme/icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class StatListItem extends StatefulWidget {
  final StatItem stat;

  const StatListItem(this.stat);

  @override
  _StatListItemState createState() => _StatListItemState();
}

class _StatListItemState extends State<StatListItem> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (expanded)
      content = buildExpandedTile(context);
    else
      content = buildCollapsedTile(context);

    return GestureDetector(
      onTap: () {
        toggleExpand();
      },
      child: content,
    );
  }

  Widget buildExpandedTile(BuildContext context) {
    return Card(
      child: ListTile(
        title: DateTileWide(widget.stat.date),
        subtitle: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimens.s),
                    child: Text(
                      AppLocalizations.of(context).translate('mood'),
                      style: TextStyle(
                          fontSize: Dimens.font_m,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
                  ),
                  Mood.values[widget.stat.mood.toInt() - 1].icon,
                ],
              ),
            ),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimens.s),
                    child: Text(
                      AppLocalizations.of(context).translate('productivity'),
                      style: TextStyle(
                          fontSize: Dimens.font_m,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
                  ),
                  RatingBar(
                    initialRating: widget.stat.productivity,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: Dimens.history_tile_icon_width,
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: MyColors.yellow,
                    ),
                    ignoreGestures: true,
                  )
                ],
              ),
            ),
            if (widget.stat.comment != null && widget.stat.comment.length > 0)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimens.s, vertical: Dimens.m),
                  child: Text(
                    widget.stat.comment,
                    style: TextStyle(
                        fontSize: Dimens.font_ml, color: Colors.black),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildCollapsedTile(BuildContext context) {
    Mood mood = Mood.values[widget.stat.mood.toInt() - 1];

    return Card(
      elevation: Dimens.xxxxs,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Dimens.s,
          horizontal: Dimens.s,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: Dimens.xs,
              ),
              child: mood.icon,
            ),
            Container(width: Dimens.s),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                DateTitle(widget.stat.date),
                Container(height: Dimens.xxxxs),
                MoodLabel(mood),
                RatingBar(
                  initialRating: widget.stat.productivity,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: Dimens.history_tile_icon_width,
                  itemBuilder: (context, _) => Icon(
                    MyIcons.star,
                    color: MyColors.yellow,
                  ),
                  unratedColor: MyColors.light,
                  ignoreGestures: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void toggleExpand() {
    setState(() {
      expanded = !expanded;
    });
  }
}
