import 'package:attendy/utils/Constant/LocalCustomWidgets.dart';
import 'package:flutter/material.dart';

import '../Dashboard/Dashboard.dart';

class Payrollitems extends StatefulWidget {
  const Payrollitems({Key? key}) : super(key: key);

  @override
  State<Payrollitems> createState() => _PayrollitemsState();
}

class _PayrollitemsState extends State<Payrollitems> {
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
      // appBar: CustomWidgets.appbar("Payroll items", [], context),
      appBar: CustomWidgets.appbar(title: "Employee Salary",action:  [
      ],context:  context,onTap: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return Dashboard();
        },));
      },),
    ));
  }
}
