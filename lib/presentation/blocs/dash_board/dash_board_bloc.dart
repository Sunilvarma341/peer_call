part of 'dash_board_export.dart';

class DashBoardBloc extends Bloc<DashBoardEvent, DashBoardState> {
  final DashboardRepo dashBoardRepo;
  DashBoardBloc({required this.dashBoardRepo}) : super(DashBoardState()) {
    on<BottomNavIndexChanged>((event, emit) {
      emit(state.copyWith(currentIndex: event.index));
    });
    on<GetAllUsersList>((event, emit) async {
      try {
        final res = await dashBoardRepo.getAllUsers();
        emit(state.copyWith(allUsersList: res));
      } catch (e) {
        AppSnackbar.show("Failed to find the users list"); 
      }
    });
  }
}
