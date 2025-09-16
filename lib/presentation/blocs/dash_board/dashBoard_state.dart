part of 'dash_board_export.dart';

class DashBoardState {
  DashBoardState({
    this.currentIndex = 0,
    this.allUsersList = const [],
    this.localUser,
    this.currentCall,
  });
  int currentIndex = 0;
  List<UserModel> allUsersList;
  final UserModel? localUser;
  final CallRoom? currentCall;

  DashBoardState copyWith({
    int? currentIndex,
    List<UserModel>? allUsersList,
    UserModel? localUser,
    CallRoom? currentCall,
  }) {
    return DashBoardState(
      currentIndex: currentIndex ?? this.currentIndex,
      allUsersList: allUsersList ?? this.allUsersList,
      localUser: localUser ?? this.localUser,
      currentCall: currentCall ?? this.currentCall,
    );
  }

  DashBoardState clear() {
    return DashBoardState(
      currentIndex: currentIndex,
      allUsersList: allUsersList,
      localUser: localUser,
      currentCall: null,
    );
  }
}
