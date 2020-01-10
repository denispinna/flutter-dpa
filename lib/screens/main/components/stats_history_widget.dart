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
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
        if (snapshot.hasError) {
          Logger.logError(TAG, "Error on fetching stats", snapshot.error);
          return Center(
              child: Text(AppLocalizations.of(context).translate('or')));
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            if (stats != null) {
              return renderStats();
            }
            return Center(
                child: Padding(
              padding: const EdgeInsets.all(Dimens.l),
              child: SpinKitCubeGrid(color: MyColors.second),
            ));
          default:
            stats = snapshot.data.documents.map((DocumentSnapshot document) {
              return StatItem.fromFirestoreData(document.data);
            }).toList();
            return renderStats();
        }
      },
    );
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
              style:
                  TextStyle(color: MyColors.title, fontSize: Dimens.font_xxl),
            ),
          )),
          Padding(padding: const EdgeInsets.all(Dimens.s)),
          CenterHorizontal(Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.xxxxxl),
            child: Text(
              AppLocalizations.of(context).translate('stats_empty_comment'),
              style: TextStyle(color: MyColors.title, fontSize: Dimens.font_l),
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
}

class StatListItem extends StatelessWidget {
  final StatItem stat;

  const StatListItem(this.stat);

  @override
  Widget build(BuildContext context) {
    if (stat.expanded)
      return buildExpandedTile(context);
    else
      return buildCollapsedTile(context);
  }

  Widget buildExpandedTile(BuildContext context) {
    return new ListTile(
      title: new Text(stat.date.toIso8601String()),
      subtitle: new Text(stat.comment ?? ""),
    );
  }

  Widget buildCollapsedTile(BuildContext context) {
    return new ListTile(
      title: new Text(stat.date.toIso8601String()),
      leading: DateTile(stat.date),
    );
  }
}
