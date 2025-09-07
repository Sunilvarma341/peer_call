// core/firebase/signaling_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class SignalingRepo {
  SignalingRepo();
  final _db = FirebaseFirestore.instance;
  
  Future<String> createRoom(Map<String, dynamic> offer, String uid) async {
    final ref = _db.collection('rooms').doc();
    await ref.set({
      'offer': offer,
      'status': 'created',
      'createdBy': uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return ref.id;
  }

  Future<void> setAnswer(String roomId, Map<String, dynamic> answer) {
    return _db.collection('rooms').doc(roomId).update({
      'answer': answer,
      'status': 'answered',
    });
  }

  Stream<Map<String, dynamic>?> listenRoom(String roomId) {
    return _db.collection('rooms').doc(roomId).snapshots().map((d) => d.data());
  }

  Future<void> addCallerCandidate(String roomId, Map<String, dynamic> cand) {
    return _db
        .collection('rooms')
        .doc(roomId)
        .collection('candidates_caller')
        .add(cand);
  }

  Future<void> addCalleeCandidate(String roomId, Map<String, dynamic> cand) {
    return _db
        .collection('rooms')
        .doc(roomId)
        .collection('candidates_callee')
        .add(cand);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> listenCallerCandidates(
    String roomId,
  ) {
    return _db
        .collection('rooms')
        .doc(roomId)
        .collection('candidates_callee')
        .snapshots(); // callee -> read here
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> listenCalleeCandidates(
    String roomId,
  ) {
    return _db
        .collection('rooms')
        .doc(roomId)
        .collection('candidates_caller')
        .snapshots(); // caller -> read here
  }

  Future<void> endRoom(String roomId) async {
    final room = _db.collection('rooms').doc(roomId);
    await room.update({'status': 'ended'});
    // Optional: delete candidates subcollections
    // (Use Cloud Functions or a batched delete)
  }
}
