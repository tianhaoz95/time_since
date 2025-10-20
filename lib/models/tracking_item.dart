import 'package:cloud_firestore/cloud_firestore.dart';

class TrackingItem {
  String id;
  String name;
  DateTime lastDate;
  String? notes;

  TrackingItem({
    required this.id,
    required this.name,
    required this.lastDate,
    this.notes,
  });

  factory TrackingItem.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
    final data = snapshot.data();
    return TrackingItem(
      id: snapshot.id,
      name: data?['name'],
      lastDate: (data?['lastDate'] as Timestamp).toDate(),
      notes: data?['notes'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'lastDate': Timestamp.fromDate(lastDate),
      'notes': notes,
    };
  }
}
