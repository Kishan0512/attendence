import 'package:attendy/utils/Constant/Colors.dart';
import 'package:attendy/utils/Constant/FontWeight.dart';
import 'package:attendy/utils/Constant/LocalCustomWidgets.dart';
import 'package:flutter/material.dart';

import '../../Dashboard/Dashboard.dart';

class VersionDetailScreen extends StatefulWidget {
  const VersionDetailScreen({Key? key}) : super(key: key);

  @override
  State<VersionDetailScreen> createState() => _VersionDetailScreenState();
}

class _VersionDetailScreenState extends State<VersionDetailScreen> {
  @override
  Widget build(BuildContext context) {
    Future<bool> onBackPress() {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return Dashboard();
      },));
      return Future.value(false);
    }
    return WillPopScope(
        onWillPop: () => onBackPress(),
    child: Scaffold(
      backgroundColor: Colorr.themcolor50,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomWidgets.poppinsText(
                "Attendance Messenger", Colorr.themcolor, 18, FWeight.fW600),
            CustomWidgets.poppinsText(
                "Version  2.23.1.76", Colorr.themcolor, 13, FWeight.fW600),
            Image.asset(
              "images/logo.webp",
              height: 200,
              width: 200,
            ),
            CustomWidgets.poppinsText(
                "2022 2023", Colorr.themcolor, 13, FWeight.fW600),
          ],
        ),
      ),
    ));
  }
}
