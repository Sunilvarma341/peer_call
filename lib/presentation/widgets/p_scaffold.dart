import 'package:flutter/material.dart';

class PScaffold extends StatelessWidget {
  const PScaffold({
    super.key,
    this.body,
    this.appBar,
    this.bottomAppBar,
    this.isLoading = false,
  });
  final Widget? body;
  final PreferredSizeWidget? appBar;
  final BottomAppBar? bottomAppBar;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(appBar: appBar, body: body, bottomNavigationBar: bottomAppBar),

        if (isLoading)
          AbsorbPointer(
            absorbing: false,
            child: Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }
}
