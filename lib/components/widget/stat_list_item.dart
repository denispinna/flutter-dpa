import 'package:dpa/components/widget/date_widget.dart';
import 'package:dpa/components/widget/image_preview.dart';
import 'package:dpa/components/widget/mood_widget.dart';
import 'package:dpa/components/widget/pructivity_widget.dart';
import 'package:dpa/models/mood.dart';
import 'package:dpa/models/stat_entry.dart';
import 'package:dpa/models/stat_item.dart';
import 'package:dpa/theme/dimens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class StatListWidget extends StatefulWidget {
  final DateStatEntry stat;

  const StatListWidget({@required this.stat});

  @override
  _StatListWidgetState createState() => _StatListWidgetState();
}

class _StatListWidgetState extends State<StatListWidget> {
  @override
  Widget build(BuildContext context) {
    Widget content;
    if (widget.stat.expanded)
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
            if (widget.stat.imageUrl != null)
              Center(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, Dimens.s, 0, 0),
                    child: ImagePreview(pathOrUrl: widget.stat.imageUrl)),
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
                SizedBox(height: Dimens.xxxxs),
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
    widget.stat.expanded = !widget.stat.expanded;
    setState(() {});
  }
}
