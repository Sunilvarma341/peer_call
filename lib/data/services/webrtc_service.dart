// core/webrtc/webrtc_service.dart
import 'dart:developer';

import 'package:flutter_webrtc/flutter_webrtc.dart';

class WebRTCService {
  RTCPeerConnection? _pc;
  MediaStream? _localStream;
  MediaStream? get localStream => _localStream;
  final mediaDevices = navigator.mediaDevices;
  // final _config = {
  //   'iceServers': [
  //     {'urls': 'stun:stun.l.google.com:19302'}, // add TURN for NAT traversal
  //     // {'urls': 'turn:your.turn.server:3478', 'username': 'user', 'credential': 'pass'},
  //   ],
  // };
  static const Map<String, dynamic> _config = {
    'iceServers': [
      {
        'urls': [
          'stun:stun1.l.google.com:19302',
          'stun:stun2.l.google.com:19302',
        ],
      },
    ],
  };

  final _constraints = {'mandatory': {}, 'optional': []};

  late RTCVideoRenderer localRenderer;
  late RTCVideoRenderer remoteRenderer;

  Future<void> initRenders() async {
    localRenderer = RTCVideoRenderer();
    remoteRenderer = RTCVideoRenderer();
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
        print("✅ Added local track: ${track.kind}");
      }

      _pc!.onAddStream = (MediaStream stream) {
        remoteRenderer.srcObject = stream;
      };

      //  add remote track
      // _pc!.onTrack = (RTCTrackEvent e) {
      //   if (e.streams.isNotEmpty) {
      //     remoteRenderer.srcObject = e.streams.first;
      //   }
      // };
      _pc!.onTrack = (RTCTrackEvent e) {
        print("onTrack event: ${e.streams.length} streams");
        if (e.streams.isNotEmpty) {
          remoteRenderer.srcObject = e.streams.first;
          for (var track in e.streams.first.getTracks()) {
            print("==== remote stream  traccking ${track} ======");
          }
          print("Remote stream set to renderer: ${e.streams.first.id}");
          print(
            "Remote video tracks: ${e.streams.first.getVideoTracks().length}",
          );
          print("Remote tracks count: ${e.streams.first.getTracks().length}");
          print("remoteRenderer.srcObject: ${remoteRenderer.srcObject}");
          // Check if the renderer is ready
          print("remoteRenderer.value.isInitialized: ${remoteRenderer.value}");
        } else {
          print("No remote streams received in onTrack");
        }
      };

      _pc!.onIceConnectionState = (state) {
        print("🌍 ICE connection state: $state");
      };
      _pc!.onConnectionState = (state) {
        print("📡 Peer connection state: $state");
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
    try {
      print("======================================    ${sdp['sdp']}");
      final desc = RTCSessionDescription(sdp['sdp'], sdp['type']);
      await _pc!.setRemoteDescription(desc);
      print("✅ Remote description set: type=${desc.type}");
      print("✅ SDP length: ${desc.sdp?.length}");
    } catch (e, st) {
      print("❌ Failed to set remote description: $e");
      print(st);
    }
  }

  void onIceCandidate(void Function(RTCIceCandidate) handler) {
    _pc!.onIceCandidate = handler;
  }

  Future<void> addCandidate(Map<String, dynamic> c) async {
    try {
      print("📩 Adding ICE candidate...");
      print("  candidate: ${c['candidate']}");
      print("  sdpMid: ${c['sdpMid']}");
      print("  sdpMLineIndex: ${c['sdpMLineIndex']}");

      final ice = RTCIceCandidate(
        c['candidate'],
        c['sdpMid'],
        c['sdpMLineIndex'],
      );

      await _pc!.addCandidate(ice);

      print("✅ ICE candidate successfully added");
    } catch (e, st) {
      print("❌ Failed to add ICE candidate: $e");
      print(st);
    }
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
