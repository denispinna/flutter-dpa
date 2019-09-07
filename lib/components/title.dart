import 'package:dpa/theme/dimens.dart';
import 'package:flutter/material.dart';

class MyTitle extends StatelessWidget {
  final String text;

  MyTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          Dimens.padding_xxxxl, 0, Dimens.padding_xxxxl, Dimens.padding_l),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: Dimens.font_l, fontWeight: FontWeight.bold),
        maxLines: 3,
      ),
    );
  }
}
