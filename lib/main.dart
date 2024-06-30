//todo                                                  /*  ॐ નમઃ શિવાય  */
import 'dart:async';
import 'dart:io';
import 'package:attendy/A_SQL_Trigger/Notification_api.dart';
import 'package:attendy/view/Employee/JoinigLetter.dart';
import 'package:attendy/view/Employee/OfferLetter.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'A_SQL_Trigger/Con_Usermast.dart';
import 'A_SQL_Trigger/Leave_api.dart';
import 'A_SQL_Trigger/SharePref.dart';
import 'A_SQL_Trigger/Notification.dart';
import 'Screens/FirstScreen.dart';

List<CameraDescription> cameras = [];
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await initializeNotifications();
  await initializeService();
  await Firebase.initializeApp();
  Constants_Usermast.Login =
      await SharedPref.read_bool(SrdPrefkey.login.toString()) ?? false;
  SharedPref.SyncUserData();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    // TODO: implement initState
    FlutterBackgroundService().invoke("setAsBackground");
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    if (Platform.isAndroid) {
      Constants_Usermast.IOS = false;
    } else if (Platform.isIOS) {
      Constants_Usermast.IOS = true;
    }
  }
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        FlutterBackgroundService().invoke("setAsBackground");
        print('App is in the foreground');
        break;
      case AppLifecycleState.inactive:
        FlutterBackgroundService().invoke("setAsForeground");
        print('App is in an inactive state');
        break;
      case AppLifecycleState.paused:
        FlutterBackgroundService().invoke("setAsForeground");
        print('App is in the background');
        break;
      case AppLifecycleState.detached:
        FlutterBackgroundService().invoke("setAsForeground");
        print('App is detached');
        break;
    }
  }

  Widget build(BuildContext context) {
    return Constants_Usermast.IOS == true
        ? const CupertinoApp(
            debugShowCheckedModeBanner: false,
            home: FirstScreen(),
          )
        : MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Offerletter(),
          );
  }
}

