import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dpa/components/app_localization.dart';
import 'package:dpa/components/fire_db_component.dart';
import 'package:dpa/components/logger.dart';
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
  @override
  State<StatefulWidget> createState() => StatsHistoryWidgetState();
}

class StatsHistoryWidgetState extends State<StatsHistoryWidget> {
  static const TAG = "StatsHistoryWidget";
  final authApi = AuthAPI.instance;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, User>(
        converter: (store) => store.state.user, builder: buildWithUser);
  }

  Widget buildWithUser(BuildContext context, User user) {
    if (user == null) return Container();

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
            return Center(
                child: Padding(
              padding: const EdgeInsets.all(Dimens.l),
              child: SpinKitCubeGrid(color: MyColors.second),
            ));
          default:
            return new ListView(
              children:
                  snapshot.data.documents.map((DocumentSnapshot document) {
                return new StatListItem(StatItem.fromFirestoreData(document.data));
              }).toList(),
            );
        }
      },
    );
  }
}

class StatListItem extends StatelessWidget {
  final StatItem stat;

  const StatListItem(this.stat);

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      title: new Text(stat.date.toIso8601String()),
      subtitle: new Text(stat.comment),
    );
  }

}
