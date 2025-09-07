part of 'call_export.dart';

abstract class CallEvent {}

class CreateRoomEvemt extends CallEvent {
  final String uid;
  final String localUid;
  CreateRoomEvemt({required this.uid, required this.localUid});
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
