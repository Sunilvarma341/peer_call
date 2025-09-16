// core/firebase/signaling_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peer_call/data/models/call_model.dart';

class SignalingRepo {
  SignalingRepo._();
  static final SignalingRepo instance = SignalingRepo._();
  final _db = FirebaseFirestore.instance;

  Future<String> createRoom(
    Map<String, dynamic> offer,
    String uid,
    String createdFor,
    String roomId,
  ) async {
    final ref = _db.collection('rooms').doc(roomId);
    await ref.set({
      'offer': offer,
      'status': 'created',
      'createdBy': uid,
      'createdAt': FieldValue.serverTimestamp(),
      'createdFor': createdFor,
      'callId': roomId,
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

  /// Listen to all active rooms related to me
  // Stream<List<Map<String, dynamic>>> listenMyRooms(String myUid) {
  //   return _db
  //       .collection('rooms')
  //       .where('status', isNotEqualTo: 'ended') // only active calls
  //       .where(
  //         Filter.or(
  //           Filter('createdBy', isEqualTo: myUid),
  //           Filter('createdFor', isEqualTo: myUid),
  //         ),
  //       )
  //       .snapshots()
  //       .map(
  //         (snapshot) => snapshot.docs
  //             .map((doc) => {...doc.data(), 'id': doc.id})
  //             .toList(),
  //       );
  // }

  Stream<CallRoom?> listenAllRooms(String createdFor) {
    return _db
        .collection('rooms')
        // .where('createdFor', isEqualTo: createdFor)
        .where(
          Filter.and(
            Filter('createdFor', isEqualTo: createdFor),
            Filter('status', isEqualTo: 'created'),
          ),
        )
        .limit(1)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) return null;
          final doc = snapshot.docs.first;
          return CallRoom.fromMap(doc.data());
        });
  }

  // Stream<CallRoom?> listenActiveRoom(String uid) {
  //   return _db
  //       .collection('rooms')
  //       .where('createdFor', isEqualTo: uid)
  //       // .where('status', isNotEqualTo: 'ended')
  //       .limit(1) // only get the latest one
  //       .snapshots()
  //       .map((snapshot) {
  //         if (snapshot.docs.isEmpty) return null;
  //         final doc = snapshot.docs.first;
  //         return CallRoom.fromMap(doc.data());
  //       });
  // }
}
