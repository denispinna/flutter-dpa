import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DateStatEntry {
  final String id;
  DateTime date;
  final String imageUrl;
  final String userEmail;
  final String comment;
  final double mood;
  final double productivity;
  bool expanded;

  DateStatEntry(
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

  static DateStatEntry fromFirestoreData(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data;
    final date = data['date'] as Timestamp;
    final userEmail = data['userEmail'];
    final imageUrl = data['imageUrl'];
    final mood = data['mood'];
    final productivity = data['productivity'];
    final comment = data['comment'];

    return DateStatEntry(
        id: document.documentID,
        date: date.toDate(),
        userEmail: userEmail,
        imageUrl: imageUrl,
        mood: mood,
        productivity: productivity,
        comment: comment);
  }
}

class StatItemEntry<T> {
  final String id;
  final String statItemId;
  final T value;

  StatItemEntry({
    @required this.id,
    @required this.statItemId,
    @required this.value,
  });
}
