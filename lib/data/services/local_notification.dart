import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:peer_call/core/app_navigator.dart';
import 'package:peer_call/core/pages.dart';
import 'package:peer_call/data/models/call_model.dart';

class LocalNotification {
  LocalNotification._();
  static final LocalNotification instance = LocalNotification._();
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  Future<void> initNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);
    final bool? granted = await _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    if (granted == true) {
      await _notifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (resp) {
          if (resp.payload != null) {
            // Navigate to call screen with roomId
            final roomId = resp.payload!;
            // You can use Navigator or AppNavigator here
            print("User tapped incoming call for roomId: $roomId");
            AppNavigator.router.push(
              PAGE.callScreen.path,
              extra: {'joinRoomId': roomId},
            );
          }
        },
      );
    } else {
      print("permission not granted ");
    }
  }

  Future<void> showIncomingCallNotification(CallRoom room) async {
    const androidDetails = AndroidNotificationDetails(
      'call_channel',
      'Calls',
      channelDescription: 'Incoming call notifications',
      importance: Importance.max,
      priority: Priority.high,
      fullScreenIntent: true,
      ticker: 'Incoming call',
    );

    const details = NotificationDetails(android: androidDetails);

    await _notifications.show(
      0, // notification id
      "📞 Incoming Call",
      "User ${room.createdBy} is calling you",
      details,
      payload: room.callId,
    );
  }
}
