part of "dash_board_export.dart";

class DashBoardEvent {}

class BottomNavIndexChanged extends DashBoardEvent {
  final int index;
  BottomNavIndexChanged(this.index);
}

class GetAllUsersList extends DashBoardEvent {
  GetAllUsersList(); 
}
