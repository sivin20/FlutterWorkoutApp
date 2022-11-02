import 'package:cloud_firestore/cloud_firestore.dart';

class Push {
  final String userId;
  final DateTime date;
  final Map<String, Map<String, String>> dumbell_bench;
  final Map<String, Map<String, String>> tri_pushdown_rod;

  Push(
      {required this.userId,
      required this.date,
      required this.dumbell_bench,
      required this.tri_pushdown_rod});

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'date': date,
      'dumbell_bench': dumbell_bench,
      'tri:_pushdowns_rod': tri_pushdown_rod,
    };
  }

  Push.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : userId = doc.data()!['userId'],
        date = doc.data()!['date'],
        dumbell_bench = doc.data()!['dumbell_bench'],
        tri_pushdown_rod = doc.data()!['tri_pushdowns_rod'];
}
