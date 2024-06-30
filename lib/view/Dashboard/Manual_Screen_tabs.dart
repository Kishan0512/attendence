import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:attendy/A_SQL_Trigger/Con_List.dart';
import 'package:attendy/A_SQL_Trigger/Con_Usermast.dart';
import 'package:attendy/A_SQL_Trigger/Employee_Add_api.dart';
import 'package:attendy/A_SQL_Trigger/Shift_Add_api.dart';
import 'package:attendy/A_SQL_Trigger/Shift_typee_add_api.dart';
import 'package:attendy/utils/Constant/Colors.dart';
import 'package:attendy/utils/Constant/FontWeight.dart';
import 'package:attendy/utils/Constant/LocalCustomWidgets.dart';
import 'package:attendy/A_SQL_Trigger/Employee_Add_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../A_SQL_Trigger/Attendance_api.dart';
import '../Employee/Attendance.dart';

class ManualTabs extends StatefulWidget {
  const ManualTabs({Key? key}) : super(key: key);

  @override
  State<ManualTabs> createState() => _ManualTabsState();
}

class _ManualTabsState extends State<ManualTabs>
    with SingleTickerProviderStateMixin {
  String TimeIn = "";
  String _currentTime = '';
  String TimeOut = "";
  bool attend = true;
  List<dynamic> Attendance = [];
  DateTime now = DateTime.now();
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          _animationController.forward();
        } else if (status == AnimationStatus.completed) {
          _animationController.repeat();
        }
      });
    _animationController.forward();
    getTime();
    getdata();
  }

  getdata() async {
    Con_List.Allshift_Select = await Shift_Add_api.shift_Select();
    Con_List.shift_typeetSelect = await Shift_typee_api.shift_typeeSelect();
    Con_List.AllEmployee = await AllEmployee_api.EmployeeSelect();
    if (Con_List.Attandance.length % 2 == 0) {
      setState(() {
        attend = true;
      });
    } else {
      setState(() {
        attend = false;
      });
    }

    SetTime();
  }

  SetTime() {
    if (Constants_Usermast.employeeId.isNotEmpty) {
      String ShiftId = Con_List.AllEmployee.firstWhere(
              (element) =>
                  element['_id'] == Constants_Usermast.employeeId.toString(),
              orElse: () => {
                    'ShiftId': {'_id': ""}
                  })['ShiftId']['_id']
          .toString();
      String Timein = Con_List.Allshift_Select.firstWhere(
              (element) => element['_id'] == ShiftId.toString(),
              orElse: () => {'inTime': ''})['inTime']
          .toString();
      String Timeout = Con_List.Allshift_Select.firstWhere(
              (element) => element['_id'] == ShiftId.toString(),
              orElse: () => {'outTime': ''})['outTime']
          .toString();
      DateTime inTime = DateTime.parse(Timein).toLocal();
      TimeIn = DateFormat("hh:mm a").format(inTime);
      DateTime outTime = DateTime.parse(Timeout).toLocal();
      TimeOut = DateFormat("hh:mm a").format(outTime);
      setState(() {});
    }
  }

  getTime() {
    Timer.periodic(Duration(seconds: 1), (Timer timer) {
      // Get the current time
      DateTime now = DateTime.now();
      // Format the time as "05:26 PM"
      String formattedTime = DateFormat('hh:mm a').format(now);
      _currentTime = formattedTime;
      if (mounted) {
        setState(() {});
      }
    });
  }
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd MMM yyyy').format(now);

    return Constants_Usermast.IOS == true
        ? SingleChildScrollView(
            child: Column(
              children: [
                CupertinoButton(
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  child: Image.asset("images/punchIN.webp", height: 300),
                ),
                Text(
                  formattedDate.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "PoppinsM",
                    color: Colorr.themcolor300,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  _currentTime,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Poppins",
                    color: Colorr.themcolor300,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                CustomWidgets.height(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Shift Timing",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: Colorr.themcolor500,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      time(
                          "images/clockIN.webp",
                          Constants_Usermast.statuse != "ADMIN"
                              ? Constants_Usermast.employeeId != null
                                  ? TimeIn
                                  : ""
                              : "",
                          " Punch In"),
                      CustomWidgets.width(5),
                      time(
                          "images/clockIN.webp",
                          Constants_Usermast.statuse != "ADMIN"
                              ? Constants_Usermast.employeeId != null
                                  ? TimeOut
                                  : ""
                              : "",
                          " Punch Out"),
                    ],
                  ),
                )
              ],
            ),
          )
        : SingleChildScrollView(
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Map data = {
                      "companyId": Constants_Usermast.companyId.toString(),
                      "employeeId": Constants_Usermast.employeeId.toString(),
                      // "employeeId": "6488392bfdfc8d1929ad83da",
                      "type": "Attandance",
                      "timeIn": "",
                      "timeOut": "",
                      "overTime": "",
                      "faceId": Constants_Usermast.FaceID.toString()
                    };
                    Attendance_api.AttendanceInsert(data).then((value) async {
                      if (value == 200) {
                        String formattedDate =
                            DateFormat('dd MMM yyyy').format(now);
                        Con_List.Attandance.add({
                          'time': '${DateTime.now()}',
                          'data':
                              "${Constants_Usermast.name.toString()} $formattedDate $_currentTime"
                        });
                        setState(() {
                          attend = !attend;
                        });
                      } else {
                        CustomWidgets.showToast(
                            context, "$value can't be pass null value", false);
                      }
                    });
                  },
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      CustomPaint(
                          painter: MyCustomPainter(_animation.value),
                          child: Container(
                            height: 350,
                          )
                          //       attend
                          //           ? Image.asset("images/punchIN.webp", height: 300)
                          //           : Image.asset("images/punchOUT.webp", height: 300),
                          ),
                      attend
                          ? Positioned(
                              top: 26.5,
                              child: Image.asset(
                                  "images/punchIN-removebg-preview.webp",
                                  fit: BoxFit.fill,
                                  height: 300))
                          : Positioned(
                              top: 26.5,
                              child: Image.asset("images/punchOUTdemo.webp",
                                  fit: BoxFit.fill, height: 300)),
                    ],
                  ),
                ),
                Text(
                  formattedDate.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "PoppinsM",
                      color: Colorr.themcolor,
                      fontSize: 16,
                      fontWeight: FWeight.fW500),
                ),
                Text(
                  _currentTime,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "Poppins",
                      color: Colorr.themcolor,
                      fontSize: 20,
                      fontWeight: FWeight.fW500),
                ),
                CustomWidgets.height(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Shift Timing",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: Colorr.themcolor500,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      time(
                          "images/clockIN.webp",
                          Constants_Usermast.statuse != "ADMIN"
                              ? Constants_Usermast.employeeId != null
                                  ? TimeIn
                                  : TimeIn
                              : TimeIn,
                          " Punch In"),
                      CustomWidgets.width(5),
                      time(
                          "images/clockIN.webp",
                          Constants_Usermast.statuse != "ADMIN"
                              ? Constants_Usermast.employeeId != null
                                  ? TimeOut
                                  : TimeOut
                              : TimeOut,
                          " Punch Out"),
                    ],
                  ),
                )
              ],
            ),
          );
  }

  Widget time(String image, String time, String detailText) {
    return Column(
      children: [
        SizedBox(
          height: 50,
          width: 50,
          child: Image.asset(
            image,
          ),
        ),
        Text(
          time,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: "PoppinsM",
              color: Colorr.themcolor,
              fontSize: 15,
              fontWeight: FWeight.fW500),
        ),
        Text(
          detailText,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: "PoppinsR",
              color: Colorr.themcolor,
              fontSize: 12,
              fontWeight: FWeight.fW400),
        ),
      ],
    );
  }
}

class MyCustomPainter extends CustomPainter {
  final double animationValue;
  MyCustomPainter(this.animationValue);
  @override
  void paint(Canvas canvas, Size size) {
    for (int value = 5; value >= 0; value--) {
      circle(canvas, Rect.fromLTRB(0, 0, size.width, size.height),
          value + animationValue);
    }
  }
  void circle(Canvas canvas, Rect rect, double value) {
    Paint paint = Paint()
      ..color = Colorr.themcolor.withOpacity(
          (1 - (value / 5)).clamp(.0, 1)) // Set the fill color to transparent
      ..style =
          PaintingStyle.stroke // Set the painting style to stroke (border)
      ..strokeWidth = 2.0; // Set the border width

    canvas.drawCircle(rect.center,
        sqrt((rect.width * .25 * rect.width * .25) * value / 4), paint);
  }
  @override
  bool shouldRepaint(MyCustomPainter oldDelegate) {
    return true;
  }
}
