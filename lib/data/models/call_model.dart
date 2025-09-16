// data/models/call_room.dart
class CallRoom {
  final String callId;
  final Map<String, dynamic>? offer;
  final Map<String, dynamic>? answer;
  final String status;
  final String createdBy;
  final String createdFor;
  // final DateTime? createdAt;

  CallRoom({
    this.callId = "",
    this.offer,
    this.answer,
    required this.status,
    required this.createdBy,
    required this.createdFor,
    // this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'callId': callId,
    'offer': offer,
    'answer': answer,
    'status': status,
    'createdBy': createdBy,
    'createdFor': createdFor,
    // 'createdAt': createdAt,
  };

  factory CallRoom.fromMap(Map<String, dynamic> m) => CallRoom(
    offer: m['offer'],
    answer: m['answer'],
    status: m['status'] ?? 'created',
    createdBy: m['createdBy'] ?? '',
    createdFor: m['createdFor'] ?? '',
    callId: m['callId'] ?? '',
    // createdAt: m['createdAt'],
  );
}
