// features/call/views/call_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peer_call/core/app_navigator.dart';
import 'package:peer_call/data/local_storage/local_storage.dart';
import 'package:peer_call/presentation/blocs/call_bloc/call_export.dart';
import 'package:peer_call/presentation/screens/call/call_controls.dart';
import 'package:provider/provider.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class CallScreen extends StatefulWidget {
  final String? joinRoomId;
  final String? createdUid;
  const CallScreen({super.key, this.joinRoomId, this.createdUid});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  @override
  void initState() {
    super.initState();
    _callInit();
  }

  void _callInit() async {
    final localStorage = context.read<LocalStorage>();
    final vm = context.read<CallBloc>();
    if (widget.joinRoomId == null) {
      final user = await localStorage.getUser();
      vm.add(
        CreateRoomEvemt(
          uid: widget.createdUid ?? "",
          localUid: user?.uid ?? '',
        ),
      );
    } else {
      vm.add(JoinRoomEvent(roomId: widget.joinRoomId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.read<CallBloc>();
    final nv = context.read<AppNavigator>();
    return BlocBuilder<CallBloc, CallState>(
      builder: (context, state) {
        print(" RTC video view ${vm.local} ======= ${vm.remote}");
        return Scaffold(
          appBar: AppBar(title: const Text('PeerCall')),
          body: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Expanded(child: RTCVideoView(vm.remote)),
                    Expanded(
                      child: RTCVideoView(
                        vm.local,
                        mirror: true,
                        objectFit:
                            RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                      ),
                    ),
                  ],
                ),
              ),
              CallControls(
                inCall: state.inCall,
                micMuted: state.micMuted,
                onToggleMic: () {
                  vm.add(ToggleMicEvent());
                },
                onSwitchCamera: () {
                  vm.add(SwitchCameraEvent());
                },
                onHangUp: () {
                  vm.add(
                    HangCallEvent(
                      pop: () {
                        nv.pop();
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "State: ${vm.state.phase}  | Room: ${vm.state.roomId ?? '-'}",
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
