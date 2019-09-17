
class StatItem {
  DateTime date;
  final String imageUrl;
  final String userEmail;

  StatItem({this.userEmail, this.imageUrl}) {
   this.date = DateTime.now();
  }

  Map<String, dynamic> toFirestoreData() {
    return <String, dynamic>{
      'date': date,
      'userEmail': userEmail,
      'imageUrl': imageUrl,
    };
  }
}