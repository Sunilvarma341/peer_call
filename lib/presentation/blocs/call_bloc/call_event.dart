part of 'call_export.dart';

abstract class CallEvent {}

class CreateRoomEvemt extends CallEvent {
  final String createdFor;
  final String localUid;
  CreateRoomEvemt({required this.createdFor, required this.localUid});
}

class JoinRoomEvent extends CallEvent {
  final String roomId;
  JoinRoomEvent({required this.roomId});
}

class ToggleMicEvent extends CallEvent {}

class SwitchCameraEvent extends CallEvent {}

class HangCallEvent extends CallEvent {
  final VoidCallback pop;
  HangCallEvent({required this.pop});
}

class PhaseUpdateEvent extends CallEvent {
  final String phase;
  PhaseUpdateEvent({required this.phase}); 
}
