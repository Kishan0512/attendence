import 'dart:async';
import 'package:attendy/A_SQL_Trigger/Notification_api.dart';
import 'package:flutter/foundation.dart';
import '../main.dart';
import 'Leave_api.dart';
import 'SharePref.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

ValueNotifier<List> leave = ValueNotifier([]);

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
      iosConfiguration: IosConfiguration(),
      androidConfiguration: AndroidConfiguration(
          onStart: onStart,
          isForegroundMode: false,
          autoStartOnBoot: true,
          autoStart: true));
  await service.startService();
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }
  service.on('stopService').listen((event) {
    service.stopSelf();
  });
  Timer.periodic(const Duration(seconds: 10), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        await GetLeaveAlert();
      }
    }
  });
}

GetLeaveAlert() async {
  List leave = await Notification_Api.NotificationSelect("False");
  if (leave.isNotEmpty) {
    //showNotification(leave);
  }
}

Future<void> showNotification(List<dynamic> Notify) async {
  for (int i = 0; i < Notify.length; i++) {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'channelId',
      'channelName',
      importance: Importance.high,
      priority: Priority.high,
      category: AndroidNotificationCategory.message,
      ticker: 'ticker',
      setAsGroupSummary: true,
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          'Accept',
          'Accept',
        ),
        AndroidNotificationAction(
          'Reject',
          'Reject',
        ),
        AndroidNotificationAction(
          'Mark_As_Read',
          'Mark as Read',
        ),
      ],
    );
    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);
    await flutterLocalNotificationsPlugin.show(
      i, // Notification ID
      'Attendy', // Notification title
      '${Notify[i]['username'].toString()} add leave of ${Notify[i]['fromDate']} days.',
      // Notification body
      platformDetails, // Notification details
      payload: 'data', // Optional payload
    );
  }
}

@pragma('vm:entry-point')
Future<void> initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    // onDidReceiveNotificationResponse: onTapNotification,
    onDidReceiveBackgroundNotificationResponse: onReplyNotification,
  );
}

@pragma('vm:entry-point')
onReplyNotification(NotificationResponse details) async {
  String CompanyID =
      await SharedPref.read_string(SrdPrefkey.companyId.toString()) ?? "";
  List<dynamic> reply = await Leave_api.LeaveNotification1(CompanyID);
  if (details.actionId == 'Mark_As_Read') {
    Map Data = {
      "id": reply[0]['_id'],
      "leaveId": reply[0]['leaveId']['_id'].toString(),
      "EmployeeId": reply[0]['EmployeeId']['_id'].toString(),
      "day": reply[0]['day'],
      "fromDate": reply[0]['fromDate'],
      "toDate": reply[0]['toDate'],
      "reason": reply[0]['reason'],
      "Time": DateTime.now().toLocal().toString(),
      "read": "read",
      "status": "Pending"
    };
    await Leave_api.LeaveUpdate(Data);
  } else if (details.actionId == 'Reject') {
    Map Data = {
      "id": reply[0]['_id'],
      "leaveId": reply[0]['leaveId']['_id'].toString(),
      "EmployeeId": reply[0]['EmployeeId']['_id'].toString(),
      "day": reply[0]['day'],
      "fromDate": reply[0].value['fromDate'],
      "toDate": reply[0]['toDate'],
      "reason": reply[0]['reason'],
      "Time": DateTime.now().toLocal().toString(),
      "read": "read",
      "status": "Rejected"
    };
    await Leave_api.LeaveUpdate(Data);
  } else {
    Map Data = {
      "id": reply[0]['_id'].toString(),
      "leaveId": reply[0]['leaveId']['_id'].toString(),
      "EmployeeId": reply[0]['EmployeeId']['_id'].toString(),
      "day": reply[0]['day'].toString(),
      "fromDate": reply[0]['fromDate'].toString(),
      "toDate": reply[0]['toDate'].toString(),
      "reason": reply[0]['reason'].toString(),
      "Time": DateTime.now().toLocal().toString(),
      "read": "read",
      "status": "Approved"
    };
    await Leave_api.LeaveUpdate(Data);
  }
}
