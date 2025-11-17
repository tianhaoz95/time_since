import 'package:cloud_firestore/cloud_firestore.dart';

class TrackingItem {
  String id;
  String name;
  DateTime lastDate;
  String? notes;
  int? repeatDays;
  bool notify;
  DateTime? createdAt; // New field

  TrackingItem({
    required this.id,
    required this.name,
    required this.lastDate,
    this.notes,
    this.repeatDays,
    this.notify = false,
    this.createdAt, // Initialize createdAt
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
      createdAt: (data?['createdAt'] as Timestamp?)?.toDate(), // Read createdAt field
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'lastDate': Timestamp.fromDate(lastDate),
      'notes': notes,
      'repeatDays': repeatDays,
      'notify': notify, // Include notify field
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null, // Include createdAt field
    };
  }

  TrackingItem copyWith({
    String? id,
    String? name,
    DateTime? lastDate,
    String? notes,
    int? repeatDays,
    bool? notify,
    DateTime? createdAt,
  }) {
    return TrackingItem(
      id: id ?? this.id,
      name: name ?? this.name,
      lastDate: lastDate ?? this.lastDate,
      notes: notes ?? this.notes,
      repeatDays: repeatDays ?? this.repeatDays,
      notify: notify ?? this.notify,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
