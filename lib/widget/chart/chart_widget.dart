import 'package:dpa/models/stat_entry.dart';
import 'package:dpa/models/stat_entry_parser.dart';
import 'package:dpa/services/api.dart';
import 'package:dpa/widget/base/connected_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class GlobalChartsScreen extends StatefulWidget {
  @override
  _GlobalChartsScreenState createState() => _GlobalChartsScreenState();
}

class _GlobalChartsScreenState extends StateWithLoading<GlobalChartsScreen> {
  List<StatEntry> entries;

  @override
  Widget buildWidget(BuildContext context) {
    return ChartWidget(entries);
  }

  @override
  Future loadFunction() async {
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    final snapshot = await API.statApi
        .getStats(from: firstDayOfMonth, to: now)
        .getDocuments();
    entries = await compute(parseStatEntries, snapshot.documents);
  }
}

class ChartWidget extends StatelessWidget {
  final List<StatEntry> entries;

  const ChartWidget(this.entries);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        entries.length.toString(),
      ),
    );
  }
}
