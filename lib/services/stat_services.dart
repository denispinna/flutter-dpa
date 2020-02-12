import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dpa/components/db/fire_db_component.dart';
import 'package:dpa/components/logger.dart';
import 'package:dpa/models/remote_stat_item.dart';
import 'package:dpa/models/stat_entry.dart';
import 'package:dpa/models/stat_entry_parser.dart';
import 'package:dpa/models/stat_item.dart';
import 'package:dpa/models/stat_item_parser.dart';
import 'package:dpa/provider/stat_item_provider.dart';
import 'package:dpa/services/auth_services.dart';
import 'package:flutter/material.dart';

abstract class StatApi {
  Future setupDefaultItems();

  Query getOrderedStats({DocumentSnapshot lastVisible, int limit});

  Query getStats({
    @required DateTime from,
    @required DateTime to,
  });

  Query getEnabledStatItems();

  Future<DocumentReference> postStatEntry(StatEntry stat);
}

class StatApiImpl extends StatApi {
  FireDb fireDb = FireDb.instance;

  @override
  Query getOrderedStats({DocumentSnapshot lastVisible, int limit = 10}) {
    final query = fireDb.stats
        .where(StatEntryFields.userEmail.label,
            isEqualTo: AuthAPI.instance.user.email)
        .orderBy(StatEntryFields.date.label, descending: true)
        .limit(limit);
    return (lastVisible != null)
        ? query.startAfterDocument(lastVisible)
        : query;
  }

  @override
  Query getStats({
    @required DateTime from,
    @required DateTime to,
  }) {
    final query = fireDb.stats
        .where(StatEntryFields.userEmail.label,
            isEqualTo: AuthAPI.instance.user.email)
        .where(
          StatEntryFields.date.label,
          isGreaterThanOrEqualTo: from,
          isLessThanOrEqualTo: to,
        )
        .orderBy(StatEntryFields.date.label, descending: true);

    return query;
  }

  //TODO: filter on enabled
  @override
  Query getEnabledStatItems() {
    return fireDb.statsItems
        .where(StatItemField.user_email.label,
            isEqualTo: AuthAPI.instance.user.email)
        .orderBy(StatItemField.position.label);
  }

  @override
  Future setupDefaultItems() async {
    bool itemsExist = await _defaultItemsExist().catchError((e) =>
        Logger.logError(
            runtimeType.toString(), "Error while fetching default items", e));
    if (itemsExist) return;

    final items = getDefaultStatItems();
    for (final item in items) {
      await postStatItem(item);
    }
  }

  Future postStatItem(StatItem item) async {
    return await fireDb.statsItems.add(item.toFirestoreData());
  }

  @override
  Future<DocumentReference> postStatEntry(StatEntry stat) async {
    return await fireDb.stats.add(stat.toFirestoreData());
  }

  Future<bool> _defaultItemsExist() async {
    final query = fireDb.statsItems
        .where(StatItemField.user_email.label,
            isEqualTo: AuthAPI.instance.user.email)
        .limit(1);

    final result = await query.getDocuments().catchError((error) => {
          Logger.logError(runtimeType.toString(),
              "Error while fetching default items", error)
        });

    if (result != null && result.documents.length > 0)
      return true;
    else
      return false;
  }
}
