import 'package:cloud_firestore/cloud_firestore.dart';

class StatItem {
  DateTime date;
  bool expanded;
  final String imageUrl;
  final String userEmail;
  final String comment;
  final double mood;
  final double productivity;

  StatItem(
      {DateTime date,
      this.userEmail,
      this.imageUrl,
      this.comment,
      this.mood,
      this.productivity}) {
    this.date = date != null ? date : DateTime.now();
    expanded= false;
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

  static StatItem fromFirestoreData(Map<String, dynamic> data) {
    final date = data['date'] as Timestamp;
    final userEmail = data['userEmail'];
    final imageUrl = data['imageUrl'];
    final mood = data['mood'];
    final productivity = data['productivity'];
    final comment = data['comment'];

    return StatItem(
        date: date.toDate(),
        userEmail: userEmail,
        imageUrl: imageUrl,
        mood: mood,
        productivity: productivity,
        comment: comment);
  }
}
