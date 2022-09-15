import 'package:cloud_firestore/cloud_firestore.dart';

extension DocumentSnapshotDTO on DocumentSnapshot {
  Map<String, dynamic> toMap() {
    return {'id': id, ...data() as Map<String, dynamic>};
  }
}
