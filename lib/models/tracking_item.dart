import 'package:cloud_firestore/cloud_firestore.dart';

class TrackingItem {
  String id;
  String name;
  DateTime lastDate;
  String? notes;
  int? repeatDays;
  bool notify; // New field

  TrackingItem({
    required this.id,
    required this.name,
    required this.lastDate,
    this.notes,
    this.repeatDays,
    this.notify = false, // Default to false
  });

  factory TrackingItem.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
    final data = snapshot.data();
    print('Raw repeatDays from Firestore: ${data?['repeatDays']}');
    return TrackingItem(
      id: snapshot.id,
      name: data?['name'],
      lastDate: (data?['lastDate'] as Timestamp).toDate(),
      notes: data?['notes'],
      repeatDays: data?['repeatDays'] as int?,
      notify: data?['notify'] ?? false, // Read notify field, default to false
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'lastDate': Timestamp.fromDate(lastDate),
      'notes': notes,
      'repeatDays': repeatDays,
      'notify': notify, // Include notify field
    };
  }

  TrackingItem copyWith({
    String? id,
    String? name,
    DateTime? lastDate,
    String? notes,
    int? repeatDays,
    bool? notify,
  }) {
    return TrackingItem(
      id: id ?? this.id,
      name: name ?? this.name,
      lastDate: lastDate ?? this.lastDate,
      notes: notes ?? this.notes,
      repeatDays: repeatDays ?? this.repeatDays,
      notify: notify ?? this.notify,
    );
  }
}
