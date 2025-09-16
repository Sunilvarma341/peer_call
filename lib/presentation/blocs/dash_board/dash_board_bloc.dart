part of 'dash_board_export.dart';

class DashBoardBloc extends Bloc<DashBoardEvent, DashBoardState> {
  final DashboardRepo dashBoardRepo;
  final SignalingRepo repo;
  final LocalStorage localStorage;
  final AppNavigator appNav;

  CallKitService get callKit => CallKitService.instance;

  DashBoardBloc({
    required this.dashBoardRepo,
    required this.repo,
    required this.localStorage,
    required this.appNav,
  }) : super(DashBoardState()) {
    on<BottomNavIndexChanged>((event, emit) {
      emit(state.copyWith(currentIndex: event.index));
    });
    on<GetAllUsersList>((event, emit) async {
      try {
        final res = await dashBoardRepo.getAllUsers();
        final user = await localStorage.getUser();
        print("localuser: $user");
        emit(state.copyWith(allUsersList: res, localUser: user));
        add(ListenCallRooms(uid: user?.uid ?? ""));
      } catch (e) {
        AppSnackbar.show("Failed to find the users list");
      }
    });
    on<ListenCallRooms>(_listenCallRoomHandle);
    on<CallRoomCreated>((event, emit) {
      emit(state.copyWith(currentCall: event.callRoom));
    });
  }

  void _listenCallRoomHandle(
    ListenCallRooms event,
    Emitter<DashBoardState> emit,
  ) {
    log("👂 Listening for active call for user: ${event.uid}");
    try {
      CallKitService.instance.listenEvents();
      repo.listenAllRooms(event.uid).listen((CallRoom? room) {
        if (appNav.isCallScreenOpen() || room == null) {
          log("The user alredy in  the call room: $room");
          return;
        }
        log("📞   Active room update: $room)}");
        add(CallRoomCreated(room));
        if (room.status == 'created') {
          callKit.showIncomingCall(room);
        } else if (room.status == 'ended') {
          callKit.endCall(room.callId);
        } else if (room.status == 'answered') {
          log("call answered ");
        }
      });
    } catch (e) {
      log("❌ ListenCallRooms error: $e");
    }
  }
}
