// data/models/call_room.dart
class CallRoom {
  final String id;
  final Map<String, dynamic>? offer;
  final Map<String, dynamic>? answer;
  final String status;
  final String createdBy;

  CallRoom({
    required this.id,
    this.offer,
    this.answer,
    required this.status,
    required this.createdBy,
  });

  Map<String, dynamic> toMap() => {
    'offer': offer,
    'answer': answer,
    'status': status,
    'createdBy': createdBy,
  };

  factory CallRoom.fromMap(String id, Map<String, dynamic> m) => CallRoom(
    id: id,
    offer: m['offer'],
    answer: m['answer'],
    status: m['status'] ?? 'created',
    createdBy: m['createdBy'] ?? '',
  );
}
