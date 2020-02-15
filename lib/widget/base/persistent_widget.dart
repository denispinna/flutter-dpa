import 'package:flutter/material.dart';

abstract class Persistent<T> {
  T content;

  T initContent();

  void persistOrRecoverContent(BuildContext context) {
    (content == null) ? recoverContent(context) : persistContent(context);
    if (content == null) content = initContent();
  }

  void recoverContent(BuildContext context) => content =
      PageStorage.of(context).readState(context, identifier: contentKey);

  Future persistContent(BuildContext context) async => PageStorage.of(context)
      .writeState(context, content, identifier: contentKey);

  //TODO: check the runtimetype value
  ValueKey get contentKey => ValueKey(runtimeType.toString());
}
