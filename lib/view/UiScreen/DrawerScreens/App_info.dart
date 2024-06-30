import 'package:attendy/utils/Constant/Colors.dart';
import 'package:attendy/utils/Constant/FontWeight.dart';
import 'package:attendy/utils/Constant/LocalCustomWidgets.dart';
import 'package:flutter/material.dart';

import '../../Dashboard/Dashboard.dart';

class App_info extends StatefulWidget {
  const App_info({Key? key}) : super(key: key);

  @override
  State<App_info> createState() => _App_infoState();
}

class _App_infoState extends State<App_info> {
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
      appBar: CustomWidgets.appbar(title: "App Info",action:  [
      ],context:  context,onTap: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return Dashboard();
        },));
      },),
      backgroundColor: Colorr.themcolor50,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Center(
                child: Image.asset(
              "images/policyLogo.webp",
              height: 170,
            )),
          ),
          Text(
            "Attendance Punch",
            textAlign: TextAlign.start,
            style: TextStyle(
                fontFamily: "Poppins",
                color: Colorr.themcolor,
                fontSize: 28,
                fontWeight: FWeight.fW600),
          ),
          Text(
            "Version 1.11.10.29",
            textAlign: TextAlign.start,
            style: TextStyle(
                fontFamily: "PoppinsM",
                color: Colorr.themcolor300,
                fontSize: 20,
                fontWeight: FWeight.fW500),
          ),
          Container(
            height: 200,
            width: 200,
            color: Colorr.Grey,
          ),
          Text(
            "2022 - 2023 1.11.10.29",
            textAlign: TextAlign.start,
            style: TextStyle(
                fontFamily: "PoppinsM",
                color: Colorr.themcolor300,
                fontSize: 20,
                fontWeight: FWeight.fW500),
          ),
        ],
      ),
    ));
  }
}
