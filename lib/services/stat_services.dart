import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dpa/components/fire_db_component.dart';
import 'package:dpa/components/logger.dart';
import 'package:dpa/models/stat_entry.dart';
import 'package:dpa/models/stat_item.dart';
import 'package:dpa/models/stat_parser.dart';
import 'package:dpa/provider/stat_item_provider.dart';
import 'package:dpa/services/auth_services.dart';

abstract class StatApi {
  Future setupDefaultItems();
  Query getOrderedStats({DocumentSnapshot lastVisible, int limit});
  Future<DocumentReference> postStatEntry(DateStatEntry stat);
}

class StatApiImpl extends StatApi {
  FireDb fireDb = FireDb.instance;

  @override
  Query getOrderedStats({DocumentSnapshot lastVisible, int limit = 10}) {
    final query = fireDb.stats
        .where('userEmail', isEqualTo: AuthAPI.instance.user.email)
        .orderBy('date', descending: true)
        .limit(limit);
    return (lastVisible != null)
        ? query.startAfterDocument(lastVisible)
        : query;
  }

  @override
  Future setupDefaultItems() async {
    bool itemsExist = await _defaultItemsExist()
        .catchError((e) => Logger.logError(runtimeType.toString(), "Error while fetching default items", e));
    if(itemsExist)
      return;

    final items = getDefaultStatItems();
    for(final item in items) {
      await postStatItem(item);
    }
  }

  Future postStatItem(StatItem item) async {
    return await fireDb.statsItems.add(item.toFirestoreData());
  }

  @override
  Future<DocumentReference> postStatEntry(DateStatEntry stat) async {
   return await fireDb.stats.add(stat.toFirestoreData());
  }

  Future<bool> _defaultItemsExist() async {
    final query = fireDb.statsItems
        .where('userEmail', isEqualTo: AuthAPI.instance.user.email)
        .limit(1);

    final result = await query.getDocuments()
        .catchError((error) => {Logger.logError(runtimeType.toString(), "Error while fetching default items", error)});

    if(result != null && result.documents.length > 0)
      return true;
    else
      return false;
  }
}
