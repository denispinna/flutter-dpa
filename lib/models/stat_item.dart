import 'package:flutter/cupertino.dart';

abstract class StatItem<T> {
  final String key;
  final String userEmail;
  final bool displayInList;
  final bool isCustom;
  final bool isEnabled;
  final bool localizedLabel;
  final int position;
  final String inputLabel;
  final String outputLabel;
  final Color color;

  const StatItem({
    @required this.key,
    @required this.userEmail,
    @required this.inputLabel,
    @required this.outputLabel,
    @required this.localizedLabel,
    @required this.color,
    @required this.displayInList,
    @required this.isCustom,
    @required this.isEnabled,
    @required this.position,
  });

  Widget getInputWidget({
    @required BuildContext context,
    @required Function(T) onValueChanged,
    T initialValue,
  });

  Widget getOutputListWidget({
    @required BuildContext context,
    @required T value,
  });

  Widget getOutputDetailWidget({
    @required BuildContext context,
    @required T value,
  });
}

class QuantityStatItem extends StatItem<double> {
  final double min;
  final double max;

  const QuantityStatItem({
    @required String key,
    @required String userEmail,
    @required bool isCustom,
    @required bool isEnabled,
    @required bool localizedLabel,
    @required bool displayInList,
    @required String inputLabel,
    @required String outputLabel,
    @required Color color,
    @required int position,
    @required this.min,
    @required this.max,
  }) : super(
          userEmail: userEmail,
          isCustom: isCustom,
          isEnabled: isEnabled,
          key: key,
          inputLabel: inputLabel,
          outputLabel: outputLabel,
          localizedLabel: localizedLabel,
          color: color,
          position: position,
          displayInList: displayInList,
        );

  @override
  Widget getInputWidget({
    @required BuildContext context,
    @required Function(double) onValueChanged,
    double initialValue,
  }) {
    // TODO: implement getInputWidget
    return null;
  }

  Widget getOutputDetailWidget({
    @required BuildContext context,
    @required double value,
  }) {
    // TODO: implement getOutputDetailWidget
    return null;
  }

  @override
  Widget getOutputListWidget({
    @required BuildContext context,
    @required double value,
  }) {
    // TODO: implement getOutputListWidget
    return null;
  }
}

class TextStatItem extends StatItem<String> {
  final int maxLength;

  const TextStatItem({
    @required String key,
    @required String userEmail,
    @required bool isCustom,
    @required bool isEnabled,
    @required bool displayInList,
    @required String inputLabel,
    @required String outputLabel,
    @required String type,
    @required bool localizedLabel,
    @required Color color,
    @required int position,
    @required this.maxLength,
  }) : super(
          userEmail: userEmail,
          isCustom: isCustom,
          isEnabled: isEnabled,
          key: key,
          inputLabel: inputLabel,
          outputLabel: outputLabel,
          localizedLabel: localizedLabel,
          color: color,
          position: position,
          displayInList: displayInList,
        );

  Widget getInputWidget({
    @required BuildContext context,
    @required Function(String) onValueChanged,
    String initialValue,
  }) {
    // TODO: implement getInputWidget
    return null;
  }

  @override
  Widget getOutputDetailWidget({
    @required BuildContext context,
    @required String value,
  }) {
    // TODO: implement getOutputDetailWidget
    return null;
  }

  @override
  Widget getOutputListWidget({
    @required BuildContext context,
    @required String value,
  }) {
    // TODO: implement getOutputListWidget
    return null;
  }
}

class McqStatItem extends StatItem<String> {
  final List<String> choices;

  const McqStatItem({
    @required String key,
    @required String userEmail,
    @required bool isCustom,
    @required bool isEnabled,
    @required bool displayInList,
    @required String inputLabel,
    @required String outputLabel,
    @required String type,
    @required bool localizedLabel,
    @required Color color,
    @required int position,
    @required this.choices,
  }) : super(
          userEmail: userEmail,
          isCustom: isCustom,
          isEnabled: isEnabled,
          key: key,
          inputLabel: inputLabel,
          outputLabel: outputLabel,
          localizedLabel: localizedLabel,
          color: color,
          position: position,
          displayInList: displayInList,
        );

  @override
  Widget getInputWidget({
    @required BuildContext context,
    @required Function(String) onValueChanged,
    String initialValue,
  }) {
    // TODO: implement getInputWidget
    return null;
  }

  @override
  Widget getOutputDetailWidget({
    @required BuildContext context,
    @required String value,
  }) {
    // TODO: implement getOutputDetailWidget
    return null;
  }

  @override
  Widget getOutputListWidget({
    @required BuildContext context,
    @required String value,
  }) {
    // TODO: implement getOutputListWidget
    return null;
  }
}

//final _fakeComments = [
//  'Lorem ipsum dolor sit amet, nunc aenean urna dolor consectetuer, hymenaeos placerat velit quisque non nullam vitae.',
//  'Lorem ipsum dolor sit amet, vel donec urna, odio integer, sed aliquam nonummy.',
//  'Lorem ipsum dolor sit amet, magna diam erat donec sapien faucibus interdum, accumsan ac adipiscing, ornare gravida, nec platea eu ut magna dui.',
//  'Lorem ipsum dolor sit amet, viverra commodo soluta id ornare donec, eget risus molestie metus porttitor pulvinar, orci a et aenean ut sem.',
//  'Lorem ipsum dolor sit amet, vitae non, eget ipsum, diam condimentum praesent pellentesque.',
//];
//final _fakeImages = [
//  'https://images.unsplash.com/photo-1541364983171-a8ba01e95cfc?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80',
//  'https://images.unsplash.com/photo-1515536765-9b2a70c4b333?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=676&q=80',
//  'https://images.unsplash.com/photo-1433162653888-a571db5ccccf?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1350&q=80',
//  'https://images.unsplash.com/photo-1505628346881-b72b27e84530?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80',
//  'https://images.unsplash.com/photo-1438283173091-5dbf5c5a3206?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80',
//];
//
//List<StatItem> _fakeData;
//
//void postRandomStats(String email) {
//  if (_fakeData != null) return;
//  final today = DateTime.now();
//  final initialDate = DateTime.utc(2019, 1, 1).add(Duration(hours: 12));
//  var nextDate = initialDate;
//  while (nextDate.isBefore(today)) {
//    final item = _generateFakeStat(email, nextDate);
//    FireDb.instance.postStat(item).then(
//          (result) => print(item.date.toString() + " posted"),
//          onError: (error) => print(error),
//        );
//    nextDate = nextDate.add(Duration(days: 1));
//  }
//}
//
//StatItem _generateFakeStat(String email, DateTime date) {
//  var random = new Random();
//  final mood = (random.nextInt(5) + 1).toDouble();
//  double productivity = random.nextInt(5).toDouble();
//  if (random.nextBool()) {
//    productivity = (productivity > 0) ? productivity - 0.5 : productivity;
//  }
//  final comment = _fakeComments[random.nextInt(_fakeComments.length)];
//  final imageUrl = _fakeImages[random.nextInt(_fakeImages.length)];
//
//  return StatItem(
//    userEmail: email,
//    date: date,
//    mood: mood,
//    comment: comment,
//    imageUrl: imageUrl,
//    productivity: productivity,
//  );
//}
