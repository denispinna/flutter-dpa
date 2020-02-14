import 'dart:collection';
import 'dart:math';

import 'package:dpa/models/stat_entry.dart';
import 'package:dpa/provider/stat_item_provider.dart';
import 'package:dpa/services/api.dart';

final _fakeComments = [
  'Lorem ipsum dolor sit amet, nunc aenean urna dolor consectetuer, hymenaeos placerat velit quisque non nullam vitae.',
  'Lorem ipsum dolor sit amet, vel donec urna, odio integer, sed aliquam nonummy.',
  'Lorem ipsum dolor sit amet, magna diam erat donec sapien faucibus interdum, accumsan ac adipiscing, ornare gravida, nec platea eu ut magna dui.',
  'Lorem ipsum dolor sit amet, viverra commodo soluta id ornare donec, eget risus molestie metus porttitor pulvinar, orci a et aenean ut sem.',
  'Lorem ipsum dolor sit amet, vitae non, eget ipsum, diam condimentum praesent pellentesque.',
];
final _fakeImages = [
  'https://images.unsplash.com/photo-1541364983171-a8ba01e95cfc?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80',
  'https://images.unsplash.com/photo-1515536765-9b2a70c4b333?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=676&q=80',
  'https://images.unsplash.com/photo-1433162653888-a571db5ccccf?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1350&q=80',
  'https://images.unsplash.com/photo-1505628346881-b72b27e84530?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80',
  'https://images.unsplash.com/photo-1438283173091-5dbf5c5a3206?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80',
];

List<StatEntry> _fakeData;

void postRandomStats() {
  if (_fakeData != null) return;
  final today = DateTime.now();
  final initialDate = DateTime.utc(2019, 1, 1).add(Duration(hours: 12));
  var nextDate = initialDate;
  while (nextDate.isBefore(today)) {
    final item = _generateFakeStat(nextDate);
    API.statApi.postStatEntry(item).then(
          (result) => print(item.date.toString() + " posted"),
          onError: (error) => print(error),
        );
    nextDate = nextDate.add(Duration(days: 1));
  }
}

StatEntry _generateFakeStat(DateTime date) {
  var random = new Random();
  final mood = (random.nextInt(10) > 7)
      ? (random.nextInt(2) + 1).toDouble()
      : (random.nextInt(3) + 3).toDouble();
  double productivity = (random.nextInt(10) > 7)
      ? random.nextInt(3).toDouble()
      : (random.nextInt(2) + 3).toDouble();

  if (random.nextBool()) {
    productivity = (productivity > 0) ? productivity - 0.5 : productivity;
  }
  final comment = _fakeComments[random.nextInt(_fakeComments.length)];
  final imageUrl = _fakeImages[random.nextInt(_fakeImages.length)];

  HashMap<String, dynamic> elements = HashMap();
  elements[DefaultStatItem.default_mood.label] = mood;
  elements[DefaultStatItem.default_comment.label] = comment;
  elements[DefaultStatItem.default_picture.label] = imageUrl;
  elements[DefaultStatItem.default_productivity.label] = productivity;

  return StatEntry(date: date, elements: elements);
}
