part of 'call_export.dart';

class CallBloc extends Bloc<CallEvent, CallState> {
  final WebRTCService _rtc;
  final SignalingRepo _repo;
  CallBloc(WebRTCService rtcService, SignalingRepo repo)
    : _rtc = rtcService,
      _repo = repo,
      super(CallState()) {
    on<CreateRoomEvemt>(_createRoomHandle);
    on<JoinRoomEvent>(_joinRoomHandle);
    on<ToggleMicEvent>(_toggleMicHandle);
    on<SwitchCameraEvent>(_switchCameraHandle);
    on<HangCallEvent>(_hangCall);
    on(
      (PhaseUpdateEvent event, Emitter<CallState> emit) =>
          emit(state.copyWith(phase: event.phase)),
    );
  }

  RTCVideoRenderer get local => _rtc.localRenderer;
  RTCVideoRenderer get remote => _rtc.remoteRenderer;
  final _db = FirebaseFirestore.instance;
  StreamSubscription? _roomSub;
  StreamSubscription? _candSub;

  Future<void> init() async {
    await _rtc.initRenders();
    l.log("initialized rtcvideo renderer");
  }

  @override
  Future<void> close() {
    _rtc.dispose();
    l.log(" class bloc closed trigger ");
    return super.close();
  }

  Future<void> _createRoomHandle(
    CreateRoomEvemt event,
    Emitter<CallState> emit,
  ) async {
    try {
      emit(state.copyWith(phase: "creating"));
      final localUid = event.localUid;
      // creating a roomId
      final roomId = Uuid().v4();
      await _rtc.getUserMedia();
      await _rtc.createAPeerConnection();

      _rtc.onIceCandidate((RTCIceCandidate ice) {
        l.log("onIceCandidate: |||| ${ice.toMap()}");
        _repo.addCallerCandidate(roomId, {
          'candidate': ice.candidate,
          'sdpMid': ice.sdpMid,
          'sdpMLineIndex': ice.sdpMLineIndex,
        });
      });
      final offer = await _rtc.createOffer();
      final roomid = await _repo.createRoom(
        {'type': offer.type, 'sdp': offer.sdp},
        localUid,
        event.createdFor,
        roomId,
      );
      print(" roomid : $roomid  ============  $roomId");
      emit(state.copyWith(roomId: roomId, phase: 'connecting', inCall: true));

      // listening for answers
      _roomSub = _repo.listenRoom(roomId).listen((data) async {
        if (data == null) return;
        final answer = data['answer'];
        if (answer != null) {
          await _rtc.setRemoteDiscription(answer);
          add(PhaseUpdateEvent(phase: 'connected'));
        }
      });

      // listen for calee
      _candSub = _repo.listenCalleeCandidates(roomId).listen((snap) {
        for (var doc in snap.docChanges) {
          _rtc.addCandidate(doc.doc.data()!);
        }
      });
    } catch (e) {
      l.log("$e", name: "CREATE ROOM ERROR");
      AppSnackbar.show("Something went wrong");
    }
  }

  Future<void> _joinRoomHandle(
    JoinRoomEvent event,
    Emitter<CallState> emit,
  ) async {
    emit(state.copyWith(phase: "joining"));
    await _rtc.getUserMedia();
    await _rtc.createAPeerConnection();

    // When we generate ICE, write to callee candidates
    _rtc.onIceCandidate((c) {
      _repo.addCallerCandidate(event.roomId, {
        'candidate': c.candidate,
        'sdpMid': c.sdpMid,
        'sdpMLineIndex': c.sdpMLineIndex,
      });
    });

    // read offer => set remote description  => create & write answer
    final roomSnap = await _db.collection('rooms').doc(event.roomId).get();
    final offer = roomSnap.data()?['offer'];
    await _rtc.setRemoteDiscription(offer);

    final answer = await _rtc.createAnswer();
    await _repo.setAnswer(event.roomId, {
      'type': answer.type,
      'sdp': answer.sdp,
    });

    emit(
      state.copyWith(roomId: event.roomId, inCall: true, phase: 'connected'),
    );

    _candSub = _repo.listenCallerCandidates(event.roomId).listen((snap) {
      for (var doc in snap.docChanges) {
        _rtc.addCandidate(doc.doc.data()!);
      }
    });
  }

  void _toggleMicHandle(ToggleMicEvent event, Emitter<CallState> emit) async {
    final next = !state.micMuted;
    await _rtc.muteMic(next);
    emit(state.copyWith(micMuted: next));
  }

  void _switchCameraHandle(
    SwitchCameraEvent event,
    Emitter<CallState> emit,
  ) async {
    await _rtc.switchCamera();
  }

  void _hangCall(HangCallEvent event, Emitter<CallState> emit) async {
    final id = state.roomId;

    emit(state.copyWith(phase: 'ended', inCall: false));

    await _candSub?.cancel();
    await _roomSub?.cancel();
    await _rtc.dispose();

    if (id != null) {
      try {
        l.log("  hnaging call  $id  ");
        await _repo.endRoom(id);
        event.pop();
      } catch (e) {
        print("Room already deleted or not found: $e");
      }
    }
  }
}
