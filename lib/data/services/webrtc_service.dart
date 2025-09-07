// core/webrtc/webrtc_service.dart
import 'dart:developer';

import 'package:flutter_webrtc/flutter_webrtc.dart';

class WebRTCService {
  RTCPeerConnection? _pc;
  MediaStream? _localStream;
  MediaStream? get localStream => _localStream;
  final mediaDevices = navigator.mediaDevices;
  final _config = {
    'iceServers': [
      {'urls': 'stun:stun.l.google.com:19302'}, // add TURN for NAT traversal
      // {'urls': 'turn:your.turn.server:3478', 'username': 'user', 'credential': 'pass'},
    ],
  };

  final _constraints = {'mandatory': {}, 'optional': []};

  final localRenderer = RTCVideoRenderer();
  final remoteRenderer = RTCVideoRenderer();

  Future<void> initRenders() async {
    await localRenderer.initialize();
    await remoteRenderer.initialize();
  }

  Future<void> getUserMedia({bool audio = true, bool video = true}) async {
    _localStream = await mediaDevices.getUserMedia({
      "audio": audio,
      "video": video
          ? {
              "facingMode": "user",
              "width": {'ideal': 1280},
              "height": {'ideal': 720},
            }
          : false,
    });
    log("$_localStream", name: "LOCAL MEDIA STREAM");
    localRenderer.srcObject = _localStream;
    printLocalStreamInfo(_localStream);
  }

  void printLocalStreamInfo(MediaStream? stream) {
    if (stream == null) {
      print("❌ Local stream is null");
      return;
    }

    print("🎥 Local Media Stream Info:");
    print("Stream ID: ${stream.id}");

    // Audio tracks
    for (var track in stream.getAudioTracks()) {
      print("🔊 Audio Track:");
      print("  ID: ${track.id}");
      print("  Kind: ${track.kind}");
      print("  Enabled: ${track.enabled}");
      print("  Muted: ${track.muted}");
    }

    // Video tracks
    for (var track in stream.getVideoTracks()) {
      print("📹 Video Track:");
      print("  ID: ${track.id}");
      print("  Kind: ${track.kind}");
      print("  Enabled: ${track.enabled}");
      print("  Muted: ${track.muted}");
    }
    for (var track in _localStream!.getTracks()) {
      print("====  traccking $track ======");
    }
  }

  Future<RTCPeerConnection> createAPeerConnection() async {
    try {
      _pc = await createPeerConnection(_config, _constraints);

      //  add local track
      for (MediaStreamTrack track in _localStream!.getTracks()) {
        await _pc!.addTrack(track, _localStream!);
      }

      //  add remote track
      _pc!.onTrack = (RTCTrackEvent e) {
        if (e.streams.isNotEmpty) {
          remoteRenderer.srcObject = e.streams.first;
        }
      };

      return _pc!;
    } catch (e) {
      log("$e", name: "CREATE PEER CONNECTION ERROR ");
      rethrow;
    }
  }

  Future<RTCSessionDescription> createOffer() async {
    final offer = await _pc!.createOffer({'offerToReceiveVideo': 1});
    _pc!.setLocalDescription(offer);
    return offer;
  }

  Future<RTCSessionDescription> createAnswer() async {
    final answer = await _pc!.createAnswer({'offerToReceiveVideo': 1});
    _pc!.setLocalDescription(answer);
    return answer;
  }

  Future<void> setRemoteDiscription(Map<String, dynamic> sdp) async {
    await _pc!.setRemoteDescription(
      RTCSessionDescription(sdp['sdp'], sdp['type']),
    );
  }

  void onIceCandidate(void Function(RTCIceCandidate) handler) {
    _pc!.onIceCandidate = handler;
  }

  Future<void> addCandidate(Map<String, dynamic> c) async {
    _pc!.addCandidate(
      RTCIceCandidate(c['candidate'], c['sdpMid'], c['sdpMLineIndex']),
    );
  }

  Future<void> switchCamera() async {
    final videoTrack = _localStream?.getVideoTracks().first;
    log(" videotracks: $videoTrack", name: "VIDEO TRACKS");
    await Helper.switchCamera(videoTrack!);
  }

  Future<void> muteMic(bool mute) async {
    final audioTrack = _localStream?.getAudioTracks().first;
    audioTrack?.enabled = !mute;
  }

  Future<void> dispose() async {
    await localRenderer.dispose();
    await remoteRenderer.dispose();
    await _localStream?.dispose();
    await _pc?.close();
  }
}
