part of 'dash_board_export.dart';

class DashBoardState {
  DashBoardState({this.currentIndex = 0, this.allUsersList = const []});
  int currentIndex = 0;
  List<UserModel> allUsersList;

  


  DashBoardState copyWith({int? currentIndex, List<UserModel>? allUsersList}) {
    return DashBoardState(
      currentIndex: currentIndex ?? this.currentIndex,
      allUsersList: allUsersList ?? this.allUsersList,
    );
  }
}
