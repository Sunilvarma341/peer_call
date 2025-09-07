part of 'call_export.dart';
class CallState {
  final String phase;
  final String roomId;
  final bool inCall;
  final bool micMuted;
  final String cameraFacing; // "front" or "back" as example
  final bool hungUp;

  const CallState({
    this.phase = 'idle',
    this.roomId = '',
    this.inCall = false,
    this.micMuted = false,
    this.cameraFacing = 'front',
    this.hungUp = false,
  });

  // CopyWith method
  CallState copyWith({
    String? phase,
    String? roomId,
    bool? inCall,
    bool? micMuted,
    String? cameraFacing,
    bool? hungUp,
  }) {
    return CallState(
      phase: phase ?? this.phase,
      roomId: roomId ?? this.roomId,
      inCall: inCall ?? this.inCall,
      micMuted: micMuted ?? this.micMuted,
      cameraFacing: cameraFacing ?? this.cameraFacing,
      hungUp: hungUp ?? this.hungUp,
    );
  }

  // ToJson method
  Map<String, dynamic> toJson() {
    return {
      'phase': phase,
      'roomId': roomId,
      'inCall': inCall,
      'micMuted': micMuted,
      'cameraFacing': cameraFacing,
      'hungUp': hungUp,
    };
  }

  // FromJson factory
  factory CallState.fromJson(Map<String, dynamic> json) {
    return CallState(
      phase: json['phase'] ?? 'idle',
      roomId: json['roomId'] ?? '',
      inCall: json['inCall'] ?? false,
      micMuted: json['micMuted'] ?? false,
      cameraFacing: json['cameraFacing'] ?? 'front',
      hungUp: json['hungUp'] ?? false,
    );
  }
}
