import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dpa/components/app_localization.dart';
import 'package:dpa/components/fire_db_component.dart';
import 'package:dpa/components/logger.dart';
import 'package:dpa/components/widget/centerHorizontal.dart';
import 'package:dpa/components/widget/stat_list_item.dart';
import 'package:dpa/models/stat_item.dart';
import 'package:dpa/models/user.dart';
import 'package:dpa/services/auth.dart';
import 'package:dpa/store/global/app_state.dart';
import 'package:dpa/theme/colors.dart';
import 'package:dpa/theme/dimens.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
  static const ITEM_PER_PAGE = 10;
  static final contentKey = ValueKey(TAG);
  final authApi = AuthAPI.instance;
  var error;
  List<StatItem> stats;
  bool isLoading = false;
  bool lastPageReached = false;
  DocumentSnapshot lastDocument;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadNextPage(true);

    scrollController.addListener(() {
      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.25;
      if (maxScroll - currentScroll <= delta) {
        _loadNextPage(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, User>(
        converter: (store) => store.state.user, builder: buildWithUser);
  }

  Widget buildWithUser(BuildContext context, User user) {
    if (user == null) return Container();
    _persisAndRecoverContent(context);

    if (error != null) {
      Logger.logError(TAG, "Error on fetching stats", error);
      return Center(
          child: Text(
              AppLocalizations.of(context).translate('generic_error_message')));
    }

    if (stats == null) {
      return Center(
        child: Container(
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(MyColors.second),
          ),
        ),
      );
    } else {
      return _renderStats();
    }
  }

  Future _loadNextPage(bool firstPage) async {
    if (isLoading || lastPageReached) return;

    isLoading = true;
    setState(() {});
    this.error = null;
    final query = await FireDb.instance
        .getOrderedStats(lastVisible: lastDocument, limit: ITEM_PER_PAGE)
        .getDocuments()
        .catchError((error) => {this.error = error});

    if (this.error != null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    final documents = query.documents;
    final items = await compute(parseStats, documents);
    if (stats == null) stats = List<StatItem>();
    /* We do not want to add the items from the first page if some other items were recovered from an earlier state */
    if (!(firstPage && stats.length > 0)) {
      stats.addAll(items);
    }
    if (documents.length > 0) lastDocument = documents.last;
    lastPageReached = items.length < ITEM_PER_PAGE;
    setState(() {
      isLoading = false;
    });
  }

  Widget _renderStats() {
    _persisAndRecoverContent(context);
    if (stats.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(
            Dimens.xs,
            Dimens.xs,
            Dimens.xs,
            0,
        ),
        child: ListView(
          controller: scrollController,
          children: stats.map((stat) {
            return StatListItem(stat);
          }).toList(),
        ),
      );
    } else {
      return _emptyState();
    }
  }

  Widget _emptyState() {
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

  void _persisAndRecoverContent(BuildContext context) {
    if (stats == null) {
      stats =
          PageStorage.of(context).readState(context, identifier: contentKey);
    } else {
      persistContent(context);
    }
  }

  Future persistContent(BuildContext context) async {
    PageStorage.of(context).writeState(context, stats, identifier: contentKey);
  }
}
