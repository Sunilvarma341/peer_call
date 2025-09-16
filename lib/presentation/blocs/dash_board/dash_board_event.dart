part of "dash_board_export.dart";

class DashBoardEvent {}

class BottomNavIndexChanged extends DashBoardEvent {
  final int index;
  BottomNavIndexChanged(this.index);
}

class GetAllUsersList extends DashBoardEvent {
  GetAllUsersList(); 
}


class ListenCallRooms extends DashBoardEvent {
  final String uid;
  ListenCallRooms({required this.uid});
}

class CallRoomCreated extends DashBoardEvent {
  final CallRoom callRoom;
  CallRoomCreated(this.callRoom);
}