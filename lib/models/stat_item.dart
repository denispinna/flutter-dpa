import 'package:cloud_firestore/cloud_firestore.dart';

class StatItem {
  final String id;
  DateTime date;
  final String imageUrl;
  final String userEmail;
  final String comment;
  final double mood;
  final double productivity;
  bool expanded;

  StatItem(
      {DateTime date,
      this.id = "",
      this.userEmail,
      this.imageUrl,
      this.comment,
      this.mood,
      this.productivity,
      this.expanded = false}) {
    this.date = date != null ? date : DateTime.now();
  }

  Map<String, dynamic> toFirestoreData() {
    return <String, dynamic>{
      'date': date,
      'userEmail': userEmail,
      'imageUrl': imageUrl,
      'mood': mood,
      'productivity': productivity,
      'comment': comment,
    };
  }

  static StatItem fromFirestoreData(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data;
    final date = data['date'] as Timestamp;
    final userEmail = data['userEmail'];
    final imageUrl = data['imageUrl'];
    final mood = data['mood'];
    final productivity = data['productivity'];
    final comment = data['comment'];

    return StatItem(
        id: document.documentID,
        date: date.toDate(),
        userEmail: userEmail,
        imageUrl: imageUrl,
        mood: mood,
        productivity: productivity,
        comment: comment);
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
