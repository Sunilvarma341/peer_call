// features/call/widgets/call_controls.dart
import 'package:flutter/material.dart';

class CallControls extends StatelessWidget {
  final bool inCall;
  final bool micMuted;
  final VoidCallback onToggleMic;
  final VoidCallback onSwitchCamera;
  final VoidCallback onHangUp;

  const CallControls({
    super.key,
    required this.inCall,
    required this.micMuted,
    required this.onToggleMic,
    required this.onSwitchCamera,
    required this.onHangUp,
  });

  @override
  Widget build(BuildContext context) {
    if (!inCall) return const SizedBox.shrink();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(icon: Icon(micMuted ? Icons.mic_off : Icons.mic), onPressed: onToggleMic),
        IconButton(icon: const Icon(Icons.cameraswitch), onPressed: onSwitchCamera),
        IconButton(icon: const Icon(Icons.call_end), color: Colors.red, onPressed: onHangUp),
      ],
    );
  }
}
