import 'package:dpa/components/logger.dart';

abstract class StatApi {
  Future setupDefaultItems();
}

class StatApiImpl extends StatApi {
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
