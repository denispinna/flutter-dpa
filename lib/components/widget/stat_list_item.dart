import 'package:cached_network_image/cached_network_image.dart';
import 'package:dpa/components/widget/date_widget.dart';
import 'package:dpa/components/widget/mood_widget.dart';
import 'package:dpa/components/widget/pructivity_widget.dart';
import 'package:dpa/models/mood.dart';
import 'package:dpa/models/stat_item.dart';
import 'package:dpa/theme/colors.dart';
import 'package:dpa/theme/dimens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
    final mood = Mood.values[widget.stat.mood.toInt() - 1];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Dimens.s),
        child: Column(
          children: <Widget>[
            DateTitle(
              date: widget.stat.date,
              fontSize: Dimens.m,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, Dimens.s, 0, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    mood.icon,
                    SizedBox(width: Dimens.s),
                    MoodLabel(mood)
                  ],
                ),
              ),
            ),
            if(widget.stat.imageUrl != null) Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, Dimens.s, 0, 0),
                child: CachedNetworkImage(
                  placeholder: (context, url) => CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(MyColors.second),
                  ),
                  imageUrl: widget.stat.imageUrl,
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, Dimens.s, 0, 0),
                child: ProductivityDetailWidget(widget.stat.productivity),
              ),
            ),
            if (widget.stat.comment != null && widget.stat.comment.length > 0)
              Padding(
                padding: const EdgeInsets.fromLTRB(0, Dimens.s, 0, 0),
                child: Text(
                  widget.stat.comment,
                  style: TextStyle(
                    fontSize: Dimens.font_ml,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
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
                DateTitle(date: widget.stat.date),
                Container(height: Dimens.xxxxs),
                MoodLabel(mood),
                ProductivityListWidget(widget.stat.productivity),
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
