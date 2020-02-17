import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dpa/components/app_localization.dart';
import 'package:dpa/models/stat_entry.dart';
import 'package:dpa/models/stat_entry_parser.dart';
import 'package:dpa/models/stat_item.dart';
import 'package:dpa/models/stat_item_parser.dart';
import 'package:dpa/services/api.dart';
import 'package:dpa/services/auth_services.dart';
import 'package:dpa/theme/colors.dart';
import 'package:dpa/theme/dimens.dart';
import 'package:dpa/widget/base/connected_widget.dart';
import 'package:dpa/widget/base/persistent_widget.dart';
import 'package:dpa/widget/centerHorizontal.dart';
import 'package:dpa/widget/stat/stat_list_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:redux/src/store.dart';

class StatsHistoryWidget extends StatefulWidget {
  const StatsHistoryWidget({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StatsHistoryWidgetState();
}

class _StatsHistoryWidgetState
    extends StoreConnectedState<StatsHistoryWidget, List<StatItem>> {
  @override
  Widget buildWithStore(BuildContext context, List<StatItem> statItems) {
    return StatHistoryList(statItems);
  }

  @override
  List<StatItem> converter(Store store) => store.state.statItems;
}

class StatHistoryList extends StatefulWidget {
  final List<StatItem> statItems;

  const StatHistoryList(this.statItems);

  @override
  _StatHistoryListState createState() => _StatHistoryListState();
}

class _StatHistoryListState extends StateWithLoading<StatHistoryList> with Persistent<_StatHistoryListStateContent>{
  static const TAG = "StatsHistoryWidget";
  static const ITEM_PER_PAGE = 10;
  final authApi = AuthAPI.instance;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    recoverContent(context: context);
    scrollController.addListener(() {
      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.25;
      if (maxScroll - currentScroll <= delta) {
        _loadNextPage();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    persistContent(context: context);
    return buildWidget(context);
  }

  @override
  Widget buildWidget(BuildContext context) {
    persistContent(context: context);
    return new RefreshIndicator(
      child: _renderStats(),
      onRefresh: _refreshData,
    );
  }

  Future<void> _refreshData() async {
    content = initContent();
    isLoading = false;
    await Future.delayed(Duration(milliseconds: 500));
    await load();
  }

  @override
  Future loadFunction() async {
    await _loadNextPage(isFirstPage: true);
  }

  @override
  bool shouldLoad() => content.stats == null;

  Future _loadNextPage({bool isFirstPage = false}) async {
    QuerySnapshot query;
    if (isFirstPage) {
      query = await API.statApi
          .getOrderedStats(lastVisible: content.lastDocument, limit: ITEM_PER_PAGE)
          .getDocuments();
    } else {
      if (isLoading || content.isLoadingNext || content.lastPageReached) return;
      setState(() {
        content.isLoadingNext = true;
      });
      query = await API.statApi
          .getOrderedStats(lastVisible: content.lastDocument, limit: ITEM_PER_PAGE)
          .getDocuments()
          .catchError((error) {});
    }

    final documents = query.documents;
    final items = await compute(parseStatEntries, documents);
    if (content.stats == null) content.stats = List<StatEntry>();
    /* We do not want to add the items from the first page if some other items were recovered from an earlier state */
    if (!(isFirstPage && content.stats.length > 0)) {
      content.stats.addAll(items);
    }
    if (documents.length > 0) content.lastDocument = documents.last;
    content.lastPageReached = items.length < ITEM_PER_PAGE;

    /* We delay the setState to let the user see the loading icon instead of blinking on a fast network */
    await Future.delayed(Duration(milliseconds: 200));
    if (mounted) setState(() => content.isLoadingNext = false);
  }

  Widget _renderStats() {
    if(content.stats == null)
      return buildLoadingWidget(context);
    else if (content.stats.isNotEmpty) {
      List<Widget> items = List();
      items.addAll(content.stats.map((stat) {
        return StatListWidget(
          statEntry: stat,
          statItems: widget.statItems.toKeyTypeMap(),
        );
      }).toList());

      if (content.isLoadingNext) {
        items.add(Center(
          child: Container(
            margin: const EdgeInsets.all(Dimens.xxs),
            child: CircularProgressIndicator(
              valueColor:
                  new AlwaysStoppedAnimation<Color>(MyColors.accent_color_2),
            ),
          ),
        ));
      }

      return Padding(
        padding: const EdgeInsets.fromLTRB(
          Dimens.xs,
          Dimens.xs,
          Dimens.xs,
          0,
        ),
        child: ListView(
          controller: scrollController,
          children: items,
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

  @override
  _StatHistoryListStateContent initContent() => _StatHistoryListStateContent();
}

class _StatHistoryListStateContent {
  List<StatEntry> stats;
  bool isLoadingNext = false;
  bool lastPageReached = false;
  DocumentSnapshot lastDocument;
}
