import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dpa/components/app_localization.dart';
import 'package:dpa/components/fire_db_component.dart';
import 'package:dpa/components/logger.dart';
import 'package:dpa/components/widget/centerHorizontal.dart';
import 'package:dpa/components/widget/date_tile_widget.dart';
import 'package:dpa/models/stat_item.dart';
import 'package:dpa/models/user.dart';
import 'package:dpa/services/auth.dart';
import 'package:dpa/store/global/app_state.dart';
import 'package:dpa/theme/colors.dart';
import 'package:dpa/theme/dimens.dart';
import 'package:dpa/theme/images.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_redux/flutter_redux.dart';

List<StatItem> parseStats(List<DocumentSnapshot> documents) {
  return documents.map((DocumentSnapshot document) {
    return StatItem.fromFirestoreData(document);
  }).toList();
}

class StatsHistoryWidget extends StatefulWidget {
  const StatsHistoryWidget({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => StatsHistoryWidgetState();
}

class StatsHistoryWidgetState extends State<StatsHistoryWidget> {
  static const TAG = "StatsHistoryWidget";
  static final contentKey = ValueKey(TAG);
  final authApi = AuthAPI.instance;
  List<StatItem> stats;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, User>(
        converter: (store) => store.state.user, builder: buildWithUser);
  }

  Widget buildWithUser(BuildContext context, User user) {
    if (user == null) return Container();
    persisAndRecoverContent(context);

    return StreamBuilder<QuerySnapshot>(
      stream: FireDb.instance.orderedStats.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        persisAndRecoverContent(context);
        if (snapshot.hasError) {
          Logger.logError(TAG, "Error on fetching stats", snapshot.error);
          return Center(
              child: Text(AppLocalizations.of(context).translate('or')));
        }
        Widget content;

        if (snapshot.hasData) {
          content = FutureBuilder<List<StatItem>>(
            future: processStats(snapshot.data.documents),
            builder: (context, result) {
              if (result.hasError) print(result.error);
              if (result.hasData) {
                addAll(result.data);
                return renderStats();
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(MyColors.second),
                  ),
                );
              }
            },
          );
        } else if (stats != null) {
          content = renderStats();
        } else {
          content = Center(
              child: Padding(
            padding: const EdgeInsets.all(Dimens.l),
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(MyColors.second),
            ),
          ));
        }

        return Padding(
            padding: const EdgeInsets.all(Dimens.xs), child: content);
      },
    );
  }

  Future<List<StatItem>> processStats(List<DocumentSnapshot> documents) async {
    return compute(parseStats, documents);
  }

  Widget renderStats() {
    persisAndRecoverContent(context);
    if (stats.isNotEmpty) {
      return new ListView(
        children: stats.map((stat) {
          return new StatListItem(stat);
        }).toList(),
      );
    } else {
      return emptyState();
    }
  }

  Widget emptyState() {
    return Center(
        child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: <Widget>[
          CenterHorizontal(Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.xxxl),
            child: Text(
              AppLocalizations.of(context).translate('stats_empty_title'),
              style: TextStyle(color: MyColors.dark, fontSize: Dimens.font_xxl),
            ),
          )),
          Padding(padding: const EdgeInsets.all(Dimens.s)),
          CenterHorizontal(Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.xxxxxl),
            child: Text(
              AppLocalizations.of(context).translate('stats_empty_comment'),
              style: TextStyle(color: MyColors.dark, fontSize: Dimens.font_l),
            ),
          )),
        ]));
  }

  void persisAndRecoverContent(BuildContext context) {
    if (stats == null) {
      stats =
          PageStorage.of(context).readState(context, identifier: contentKey);
    } else {
      PageStorage.of(context)
          .writeState(context, stats, identifier: contentKey);
    }
  }

  void addAll(List<StatItem> data) {
    if(stats == null)
      stats = List<StatItem>();

    stats.addAll(data);
  }
}

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
                  getMoodIcon(widget.stat.mood.toInt()),
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
                    itemSize: Dimens.rating_icon_width,
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
    return Card(
      child: ListTile(
          title: CenterHorizontal(RatingBar(
            initialRating: widget.stat.productivity,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: Dimens.rating_icon_width,
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: MyColors.yellow,
            ),
            ignoreGestures: true,
          )),
          leading: DateTile(widget.stat.date),
          trailing: getMoodIcon(widget.stat.mood.toInt()),
          contentPadding: EdgeInsets.all(Dimens.s)),
    );
  }

  void toggleExpand() {
    setState(() {
      expanded = !expanded;
    });
  }
}
