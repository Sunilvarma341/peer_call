import 'dart:developer';

import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:peer_call/core/app_navigator.dart';
import 'package:peer_call/core/pages.dart';
import 'package:peer_call/data/models/call_model.dart';
import 'package:peer_call/data/repositories/signaling_repo.dart';

class CallKitService {
  CallKitService._();
  static final CallKitService instance = CallKitService._();

  Future<void> showIncomingCall(CallRoom room) async {
    try {
      final existingCalls = await FlutterCallkitIncoming.activeCalls();
      if (existingCalls.isNotEmpty) {
        log("⚠️ Skipping incoming call, one already active");
        return;
      }

      final params = CallKitParams(
        id: room.callId,
        nameCaller: room.createdBy.isEmpty ? 'sunilvarma' : room.createdBy,
        appName: 'peercall',
        handle: room.createdBy,
        type: 1,
        duration: 30000,
        extra: {'roomId': room.callId},
        android: AndroidParams(
          isCustomNotification: true,
          isShowLogo: true,
          // ringtonePath: 'system_ringtone_default',
          backgroundColor: '#0955fa',
          backgroundUrl: 'https://yourcdn.com/bg.png',
          actionColor: '#4CAF50',
        ),
        ios: IOSParams(
          iconName: 'CallKitLogo',
          handleType: 'generic',
          maximumCallGroups: 2,
          supportsVideo: true,
          maximumCallsPerCallGroup: 1,
        ),
      );

      await FlutterCallkitIncoming.showCallkitIncoming(params);
    } catch (e) {
      log("$e FlutterCallkitIncoming ");
    }
  }

  Future<void> endCall(String callId) async {
    await FlutterCallkitIncoming.endCall(callId);
  }

  Future<void> listenEvents() async {
    FlutterCallkitIncoming.onEvent.listen((event) {
      final roomId = event?.body['extra']['roomId'] ?? '';
      switch (event!.event) {
        case Event.actionCallAccept:
          Future.microtask(() {
            AppNavigator.router.push(
              PAGE.callScreen.path,
              extra: {'joinRoomId': roomId},
            );
          });
          break;
        case Event.actionCallDecline:
          print("Call declined");
          SignalingRepo.instance.endRoom(roomId);
          break;
        case Event.actionCallEnded:
          print("Call ended ${event.body}  ");
          SignalingRepo.instance.endRoom(roomId);
          break;
        case Event.actionCallTimeout:
          SignalingRepo.instance.endRoom(roomId);
          break;
        default:
          break;
      }
    });
  }
}
