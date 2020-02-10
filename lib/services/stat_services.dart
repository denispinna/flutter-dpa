import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dpa/components/fire_db_component.dart';
import 'package:dpa/components/logger.dart';
import 'package:dpa/services/auth_services.dart';

abstract class StatApi {
  Future setupDefaultItems();
  Query getOrderedStats({DocumentSnapshot lastVisible, int limit});
}

class StatApiImpl extends StatApi {
  static final instance = StatApiImpl();

  @override
  Query getOrderedStats({DocumentSnapshot lastVisible, int limit = 10}) {
    final query = FireDb.instance.stats
        .where('userEmail', isEqualTo: AuthAPI.instance.user.email)
        .orderBy('date', descending: true)
        .limit(limit);
    return (lastVisible != null)
        ? query.startAfterDocument(lastVisible)
        : query;
  }

  @override
  Future setupDefaultItems() async {
    bool itemsExist = await defaultItemsExist()
        .catchError((e) => Logger.logError(runtimeType.toString(), "Error while fetching default items", e));
    if(itemsExist)
      return;
  }

  Future<bool> defaultItemsExist() async {
    return false;
  }
}
