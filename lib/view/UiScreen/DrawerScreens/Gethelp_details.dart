import 'package:attendy/utils/Constant/Colors.dart';
import 'package:attendy/utils/Constant/FontWeight.dart';
import 'package:attendy/utils/Constant/LocalCustomWidgets.dart';
import 'package:flutter/material.dart';

import '../../Dashboard/Dashboard.dart';

class GetHelp_details extends StatefulWidget {
  const GetHelp_details({Key? key}) : super(key: key);

  @override
  State<GetHelp_details> createState() => _GetHelp_detailsState();
}

class _GetHelp_detailsState extends State<GetHelp_details> {
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
    ));
  }
}
