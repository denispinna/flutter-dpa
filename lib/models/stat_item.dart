import 'package:cloud_firestore/cloud_firestore.dart';

class StatItem {
  final String id;
  DateTime date;
  final String imageUrl;
  final String userEmail;
  final String comment;
  final double mood;
  final double productivity;

  StatItem(
      {DateTime date,
      this.id = "",
      this.userEmail,
      this.imageUrl,
      this.comment,
      this.mood,
      this.productivity}) {
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
