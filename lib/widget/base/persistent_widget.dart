import 'package:flutter/material.dart';

abstract class Persistent<T> {
  final _bucket = new PageStorageBucket();
  T content;

  T initContent();

  Widget buildWithStorage(Widget child) {
    return PageStorage(
      child: child,
      bucket: _bucket,
      key: contentKey,
    );
  }

  void persistOrRecoverContent({
    @required BuildContext context,
    bool initIfNull = true,
  }) =>
      (content == null)
          ? recoverContent(
              context: context,
              initIfNull: initIfNull,
            )
          : persistContent(context: context);

  void recoverContent({
    @required BuildContext context,
    bool initIfNull = true,
  }) {
    content =
        PageStorage.of(context).readState(context, identifier: contentKey);
    if (content == null) content = initContent();
  }

  Future persistContent({
    @required BuildContext context,
  }) async =>
      PageStorage.of(context)
          .writeState(context, content, identifier: contentKey);

  ValueKey get contentKey => ValueKey(runtimeType.toString());
}
