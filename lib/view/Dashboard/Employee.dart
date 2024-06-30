import 'dart:async';
import 'dart:developer';
import 'package:attendy/A_SQL_Trigger/Con_Usermast.dart';
import 'package:attendy/utils/Constant/LocalCustomWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:attendy/A_SQL_Trigger/api_page.dart';
import '../../A_SQL_Trigger/Attendance_api.dart';
import '../../A_SQL_Trigger/Con_List.dart';
import '../../A_SQL_Trigger/Employee_Add_api.dart';
import '../../A_SQL_Trigger/Overtime_api.dart';
import '../../A_SQL_Trigger/Shift_Add_api.dart';
import '../../utils/Constant/Colors.dart';
import '../../utils/DroupDown/custom_dropdown.dart';
import 'Dashboard.dart';

class Employee extends StatefulWidget {
  const Employee({Key? key}) : super(key: key);

  @override
  State<Employee> createState() => _EmployeeState();
}

class _EmployeeState extends State<Employee> {
  bool DateRange = true;
  bool SelectedDay = false;
  int internetConn = 0;
  TextEditingController Singleday = TextEditingController();
  TextEditingController Singleday1 = TextEditingController();
  TextEditingController Day = TextEditingController();
  TextEditingController Employee = TextEditingController();
  TextEditingController Employee1 = TextEditingController();
  TextEditingController dropdownValue = TextEditingController();
  TextEditingController dropdownValue1 = TextEditingController();
  double height = 0;
  List<String> FilterList = ["Today", "Yesterday", "Custom Date"];
  Map<String, double> dataMap = {};

  // double _value = 0;
  double Total_hrs = 0;
  double Week_hrs = 0;
  double Month_hrs = 0;
  double Overtime_hrs = 0;
  double Total_Wor = 0;
  double Week_Wor = 0;
  double Month_Wor = 0;
  double width = -0;
  String formattedDate = "";
  final DateTime now = DateTime.now();
  final DateFormat dateFormat = DateFormat('dd MMM, yyyy\nEEEE');
  int touchedIndex = -1;
  List<dynamic> SelectedEmployee = [];
  List<dynamic> SelectedEmployee1 = [];
  List<String> AllEmployee = [];
  List<dynamic> EmployeeAttendance = [];

  @override
  @override
  void initState() {
    super.initState();
    getdata();

    CheakInternet();
    get_Statistics(Con_List.AllEmployee.firstWhere(
      (element) => element['_id'] == Constants_Usermast.employeeId,
      orElse: () => {"FirstName": ""},
    )['FirstName']
        .toString());
  }

  getdata() async {
    Con_List.AllEmployee = await AllEmployee_api.EmployeeSelect();
    DateTime currentDate1 = DateTime.now();
    String formattedDate1 = DateFormat('yyyy-MM-dd').format(currentDate1);
    EmployeeAttendance =
        await Attendance_api.FilterApiSingalDate(formattedDate1);
    // Con_List.AllAttandance = await Attendance_api.AttendanceSelect();
    Con_List.AllEmployee.forEach((element) {
      if (element['isActive'] == true) {
        AllEmployee.add(element['FirstName']);
      }
    });
    if (Constants_Usermast.statuse == "ADMIN") {
      SelectedEmployee = EmployeeAttendance;
      SelectedEmployee1 = EmployeeAttendance;
      Employee.text = Con_List.AllEmployee.firstWhere((element) =>
              element['_id'].toString() ==
              Constants_Usermast.employeeId.toString())['FirstName']
          .toString();
      Employee1.text = Con_List.AllEmployee.firstWhere((element) =>
              element['_id'].toString() ==
              Constants_Usermast.employeeId.toString())['FirstName']
          .toString();
      var temp = EmployeeAttendance.where(
              (e) => e['employeeId']['_id'] == Constants_Usermast.employeeId)
          .toList();
      SelectedEmployee1 = temp;
      SelectedEmployee = temp;
      setState(() {});
    } else {
      var temp = EmployeeAttendance.where(
              (e) => e['employeeId']['_id'] == Constants_Usermast.employeeId)
          .toList();
      SelectedEmployee1 = temp;
      SelectedEmployee = temp;

      Con_List.Users = await api_page.userSelect();
      Employee.text = Con_List.Users.firstWhere(
              (e) => (e['employeeId'] != null
                  ? e['employeeId']['_id'] == Constants_Usermast.employeeId
                  : false),
              orElse: () => {"name": ""})['name']
          .toString();
    }
    if (mounted) {
      setState(() {});
    }
  }

  bool areEqual(dynamic a, dynamic b) {
    return a["timeIn"] == b["timeIn"] &&
        a["timeOut"] == b["timeOut"] &&
        a["employeeId"] == b["employeeId"];
  }

  CheakInternet() async {
    internetConn = await CustomWidgets.CheakConnectionInternet();
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Widget build(BuildContext context) {
    formattedDate = dateFormat.format(now);
    height = MediaQuery.of(context).size.height - kToolbarHeight;
    width = MediaQuery.of(context).size.width;
    dataMap = {
      Constants_Usermast.employeeId.isEmpty
          ? "Absent"
          : EmployeeAttendance.where((element) =>
                  element['employeeId']['_id'] ==
                  Constants_Usermast.employeeId).isEmpty
              ? "Absent"
              : "Present": 5
    };
    Future<bool> onBackPress() {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return Dashboard();
        },
      ));
      return Future.value(false);
    }

    return WillPopScope(
        onWillPop: () => onBackPress(),
        child: Constants_Usermast.IOS == true
            ? CupertinoPageScaffold(
                navigationBar: CupertinoNavigationBar(
                    backgroundColor: Colorr.themcolor,
                    leading: CupertinoButton(
                      child:
                          Icon(Icons.arrow_back_ios_new, color: Colorr.White),
                      onPressed: () {
                        Navigator.pushReplacement(context, CupertinoPageRoute(
                          builder: (context) {
                            return Dashboard();
                          },
                        ));
                      },
                    ),
                    middle: Text(
                      Constants_Usermast.statuse == "ADMIN"
                          ? "Employee Dashboard"
                          : "Dashboard",
                      style: TextStyle(color: Colorr.White),
                    )),
                child: Container(
                  height: height,
                  width: width,
                  padding: EdgeInsets.all(10),
                  color: Colorr.Backgroundd,
                  child: SingleChildScrollView(
                      child: Column(
                    children: [
                      Container(
                        height: height / 2.8,
                        width: width,
                        padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                        decoration: BoxDecoration(
                            color: Colorr.White,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CustomWidgets.width(width / 35),
                                  Image.asset("images/checking-attendance.webp",
                                      height: height / 25, width: width / 20),
                                  CustomWidgets.width(width / 70),
                                  Text("Today Status",
                                      style: TextStyle(
                                          fontSize: width * 0.04,
                                          color: Colorr.FontColor,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Poppins')),
                                  Spacer(),
                                  Container(
                                    height:
                                        MediaQuery.of(context).size.height / 16,
                                    width:
                                        MediaQuery.of(context).size.width / 2.5,
                                    margin: EdgeInsets.only(
                                      right: MediaQuery.of(context).size.width *
                                          0.01,
                                      top: MediaQuery.of(context).size.width *
                                          0.02,
                                      bottom:
                                          MediaQuery.of(context).size.width *
                                              0.02,
                                    ),
                                    child: CustomWidgets.textFieldIOS(
                                        hintText: FilterList.first,
                                        controller: dropdownValue,
                                        readOnly: true,
                                        onTap: () {
                                          CustomWidgets.SelectDroupDown(
                                              context: context,
                                              items: FilterList,
                                              onSelectedItemChanged: (int) {
                                                dropdownValue.text =
                                                    FilterList[int];
                                                if (dropdownValue.text ==
                                                    "Today") {
                                                } else if (dropdownValue.text ==
                                                    "Yesterday") {
                                                } else if (dropdownValue.text ==
                                                    "Custom Date") {
                                                  showCupertinoDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return StatefulBuilder(
                                                        builder: (context,
                                                            setState1) {
                                                          return CupertinoAlertDialog(
                                                            title: Text(
                                                              "Select Custom Date",
                                                              style: TextStyle(
                                                                  fontSize: 14),
                                                            ),
                                                            content: Container(
                                                              height:
                                                                  height / 2.5,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  CustomWidgets
                                                                      .height(
                                                                          10),
                                                                  CustomWidgets.textFieldIOS(
                                                                      hintText:
                                                                          "Select Date",
                                                                      readOnly:
                                                                          true,
                                                                      controller:
                                                                          Singleday,
                                                                      suffix: GestureDetector(
                                                                          onTap: () => CustomWidgets.selectDateIOS(
                                                                              Future: true,
                                                                              context: context,
                                                                              controller: Singleday),
                                                                          child: CustomWidgets.DateIconIOS())),
                                                                  Spacer(),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceEvenly,
                                                                    children: [
                                                                      CustomWidgets.confirmButton(
                                                                          onTap: () {
                                                                            Singleday.text =
                                                                                "";
                                                                            Navigator.pop(context);
                                                                            setState1(() {});
                                                                          },
                                                                          height: height / 20,
                                                                          width: width / 3.5,
                                                                          text: "Cancel"),
                                                                      CustomWidgets.confirmButton(
                                                                          onTap: () {
                                                                            Navigator.pop(context);
                                                                            setState1(() {});
                                                                          },
                                                                          height: height / 20,
                                                                          width: width / 3.5,
                                                                          text: "Done"),
                                                                    ],
                                                                  ),
                                                                  CustomWidgets
                                                                      .height(
                                                                          height /
                                                                              50)
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                  );
                                                }
                                                setState(() {});
                                              });
                                        },
                                        suffix: CustomWidgets
                                            .aarowCupertinobutton()),
                                  )
                                ],
                              ),
                              AspectRatio(
                                aspectRatio: 2,
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: PieChart(
                                      dataMap: dataMap,
                                      centerTextStyle: TextStyle(
                                          fontSize: height * 0.02,
                                          color: Colorr.themcolor,
                                          fontFamily: 'Poppins',
                                          backgroundColor: Colorr.White),
                                      animationDuration:
                                          Duration(milliseconds: 800),
                                      chartLegendSpacing: height * 0.10,
                                      baseChartColor: Colors.white,
                                      chartRadius:
                                          MediaQuery.of(context).size.width /
                                              1.5,
                                      colorList: [
                                        Constants_Usermast.employeeId.isEmpty
                                            ? Colors.red
                                            : EmployeeAttendance.where(
                                                    (element) =>
                                                        element['employeeId']
                                                            ['_id'] ==
                                                        Constants_Usermast
                                                            .employeeId).isEmpty
                                                ? Colors.red
                                                : Colors.green
                                      ],
                                      initialAngleInDegree: 0,
                                      chartType: ChartType.ring,
                                      ringStrokeWidth: 15,
                                      centerText: "Today",
                                      legendOptions: LegendOptions(
                                        showLegendsInRow: false,
                                        legendPosition: LegendPosition.right,
                                        showLegends: true,
                                        legendShape: BoxShape.circle,
                                        legendTextStyle: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      chartValuesOptions: ChartValuesOptions(
                                        showChartValueBackground: true,
                                        showChartValues: false,
                                        showChartValuesInPercentage: false,
                                        showChartValuesOutside: false,
                                        decimalPlaces: 1,
                                      ),
                                      // gradientList: ---To add gradient colors---
                                      // emptyColorGradient: ---Empty Color gradient---
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                      ),
                      Container(
                        height: height / 2.4,
                        width: width,
                        padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                        margin: EdgeInsets.only(top: 10, bottom: 10),
                        decoration: BoxDecoration(
                            color: Colorr.White,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CustomWidgets.width(width / 35),
                                Image.asset(
                                  "images/checking-attendance.webp",
                                  height: height / 25,
                                  width: width / 20,
                                ),
                                CustomWidgets.width(width / 70),
                                Text("Today Attendance",
                                    style: TextStyle(
                                        fontSize: width * 0.042,
                                        color: Colorr.FontColor,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Poppins')),
                                Spacer(),
                                Container(
                                  alignment: Alignment.center,
                                  height: height / 20,
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colorr.themcolor500,
                                      // Set the desired border color here
                                      width: 2, // Set the desired border width
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.calendar_month_outlined,
                                    color: Colorr.themcolor500,
                                  ),
                                ),
                                CustomWidgets.width(width / 35),
                                Text(
                                  formattedDate,
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Colorr.themcolor500,
                                      fontSize: width * 0.03),
                                )
                              ],
                            ),
                            CustomWidgets.height(height * 0.01),
                            Expanded(
                                child: Container(
                              margin: EdgeInsets.all(5),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colorr.themcolor200,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Con_List.AllAttandance.isEmpty
                                  ? Center(
                                      child: CustomWidgets.NoDataImage(context),
                                    )
                                  : ListView.builder(
                                      itemCount: Con_List.AllAttandance.length,
                                      itemBuilder: (context, index) {
                                        String formattedTime = "";
                                        String formattedTime1 = "";
                                        if (Con_List.AllAttandance[index]
                                                ['timeIn'] !=
                                            null) {
                                          String timeim = Con_List
                                              .AllAttandance[index]['timeIn']
                                              .toString();
                                          DateTime t =
                                              DateTime.parse(timeim).toLocal();
                                          String formattedDateTime = DateFormat(
                                                  'yyyy-MM-dd hh:mm:ss a')
                                              .format(t);
                                          DateTime dateTime = DateFormat(
                                                  'yyyy-MM-dd hh:mm:ss a')
                                              .parse(formattedDateTime);
                                          formattedTime = DateFormat('hh:mm a')
                                              .format(dateTime);
                                        }
                                        if (Con_List.AllAttandance[index]
                                                ['timeOut'] !=
                                            null) {
                                          String timeout = Con_List
                                              .AllAttandance[index]['timeOut']
                                              .toString();
                                          DateTime t =
                                              DateTime.parse(timeout).toLocal();
                                          String formattedDateTime = DateFormat(
                                                  'yyyy-MM-dd hh:mm:ss a')
                                              .format(t);
                                          DateTime dateTime = DateFormat(
                                                  'yyyy-MM-dd hh:mm:ss a')
                                              .parse(formattedDateTime);
                                          formattedTime1 = DateFormat('hh:mm a')
                                              .format(dateTime);
                                        }
                                        return Column(
                                          children: [
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  CustomWidgets.width(10),
                                                  index == 0
                                                      ? Image(
                                                          height: height / 20,
                                                          image: AssetImage(
                                                              "images/7.png"))
                                                      : Image(
                                                          height: height / 20,
                                                          image: AssetImage(
                                                              "images/2.png")),
                                                  CustomWidgets.width(20),
                                                  Text("Punch in",
                                                      style: TextStyle(
                                                          color: Colorr.White,
                                                          fontFamily: 'Poppins',
                                                          fontSize:
                                                              width * 0.035)),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: width * 0.11,
                                                        right: width * 0.02),
                                                    child: Icon(Icons.alarm,
                                                        color: Colorr.White,
                                                        size: 14),
                                                  ),
                                                  Text(
                                                    formattedTime.toString(),
                                                    style: TextStyle(
                                                        color: Colorr.White,
                                                        fontFamily: 'Poppins',
                                                        fontSize:
                                                            width * 0.035),
                                                  )
                                                ]),
                                            Con_List.AllAttandance[index]
                                                        ['timeOut'] !=
                                                    null
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                        CustomWidgets.width(10),
                                                        index ==
                                                                Con_List.AllAttandance
                                                                        .length -
                                                                    1
                                                            ? Image(
                                                                height:
                                                                    height / 20,
                                                                image: AssetImage(
                                                                    "images/1.png"))
                                                            : Image(
                                                                height:
                                                                    height / 20,
                                                                image: AssetImage(
                                                                    "images/1.png")),
                                                        CustomWidgets.width(20),
                                                        Text("Punch out",
                                                            style: TextStyle(
                                                                color: Colorr
                                                                    .White,
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize:
                                                                    width *
                                                                        0.035)),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: width *
                                                                      0.085,
                                                                  right: width *
                                                                      0.02),
                                                          child: Icon(
                                                              Icons.alarm,
                                                              color:
                                                                  Colorr.White,
                                                              size: 14),
                                                        ),
                                                        Text(
                                                          formattedTime1
                                                              .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colorr.White,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontSize: width *
                                                                  0.035),
                                                        )
                                                      ])
                                                : Container(),
                                          ],
                                        );
                                      },
                                    ),
                            ))
                          ],
                        ),
                      ),
                      Container(
                        height: height / 2.5,
                        width: width,
                        padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                        decoration: BoxDecoration(
                            color: Colorr.White,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            CustomWidgets.height(10),
                            Constants_Usermast.statuse == "ADMIN"
                                ? CustomWidgets.textFieldIOS(
                                    hintText: 'Select Employee',
                                    controller: Employee,
                                    readOnly: true,
                                    onTap: () {
                                      CustomWidgets.SelectDroupDown(
                                          context: context,
                                          items: AllEmployee,
                                          onSelectedItemChanged: (int) async {
                                            Employee.text = AllEmployee[int];
                                            Con_List.AllAttandance =
                                                await Attendance_api
                                                    .AttendanceSelect();
                                            SelectedEmployee = [];

                                            SelectedEmployee = Con_List
                                                    .AllAttandance
                                                .where((e) =>
                                                    Con_List.AllEmployee.firstWhere(
                                                                (element) =>
                                                                    element[
                                                                        'FirstName'] ==
                                                                    Employee
                                                                        .text)[
                                                            '_id']
                                                        .toString() ==
                                                    e['employeeId']['_id']
                                                        .toString()).toList();
                                            setState(() {});
                                          });
                                    },
                                    suffix:
                                        CustomWidgets.aarowCupertinobutton())
                                : Container(),
                            Row(
                              children: [
                                CustomWidgets.width(width / 30),
                                Image.asset(
                                  "images/checking-attendance.webp",
                                  height: height / 25,
                                  width: width / 20,
                                ),
                                CustomWidgets.width(width / 70),
                                Text("Attendance List",
                                    style: TextStyle(
                                        fontSize: width * 0.042,
                                        color: Colorr.FontColor,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Poppins')),
                                Spacer(),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height / 16,
                                  width:
                                      MediaQuery.of(context).size.width / 2.5,
                                  margin: EdgeInsets.only(
                                    right: MediaQuery.of(context).size.width *
                                        0.01,
                                    top: MediaQuery.of(context).size.width *
                                        0.02,
                                    bottom: MediaQuery.of(context).size.width *
                                        0.02,
                                  ),
                                  child: CustomWidgets.textFieldIOS(
                                      hintText: FilterList.first,
                                      controller: dropdownValue1,
                                      readOnly: true,
                                      onTap: () {
                                        CustomWidgets.SelectDroupDown(
                                            context: context,
                                            items: FilterList,
                                            onSelectedItemChanged: (int) async {
                                              dropdownValue1.text =
                                                  FilterList[int];
                                              if (dropdownValue1.text ==
                                                  "Today") {
                                                DateTime currentDate1 =
                                                    DateTime.now();
                                                String formattedDate1 =
                                                    DateFormat('yyyy-MM-dd')
                                                        .format(currentDate1);
                                                SelectedEmployee1 =
                                                    await Attendance_api
                                                        .FilterApiSingalDate(
                                                            formattedDate1);
                                                setState(() {});
                                              } else if (dropdownValue1.text ==
                                                  "Yesterday") {
                                              } else if (dropdownValue1.text ==
                                                  "Custom Date") {
                                                showCupertinoDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return StatefulBuilder(
                                                      builder:
                                                          (context, setState1) {
                                                        return CupertinoAlertDialog(
                                                          title: Text(
                                                            "Select Custom Date",
                                                            style: TextStyle(
                                                                fontSize: 14),
                                                          ),
                                                          content: Container(
                                                            height:
                                                                height / 2.5,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                CustomWidgets
                                                                    .height(10),
                                                                CustomWidgets.textFieldIOS(
                                                                    hintText:
                                                                        "Select Date",
                                                                    readOnly:
                                                                        true,
                                                                    controller:
                                                                        Singleday1,
                                                                    suffix: GestureDetector(
                                                                        onTap: () => CustomWidgets.selectDateIOS(
                                                                            Future:
                                                                                true,
                                                                            context:
                                                                                context,
                                                                            controller:
                                                                                Singleday1),
                                                                        child: CustomWidgets
                                                                            .DateIconIOS())),
                                                                Spacer(),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceEvenly,
                                                                  children: [
                                                                    CustomWidgets.confirmButton(
                                                                        onTap: () {
                                                                          Singleday.text =
                                                                              "";
                                                                          Navigator.pop(
                                                                              context);
                                                                          setState1(
                                                                              () {});
                                                                        },
                                                                        height: height / 20,
                                                                        width: width / 3.5,
                                                                        text: "Cancel"),
                                                                    CustomWidgets.confirmButton(
                                                                        onTap: () {
                                                                          Navigator.pop(
                                                                              context);
                                                                          setState1(
                                                                              () {});
                                                                        },
                                                                        height: height / 20,
                                                                        width: width / 3.5,
                                                                        text: "Done"),
                                                                  ],
                                                                ),
                                                                CustomWidgets
                                                                    .height(
                                                                        height /
                                                                            50)
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                );
                                              }
                                              setState(() {});
                                            });
                                      },
                                      suffix:
                                          CustomWidgets.aarowCupertinobutton()),
                                ),
                              ],
                            ),
                            Divider(
                              color: Colorr.Black54,
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(top: 8),
                                child: SingleChildScrollView(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Theme(
                                      data: Theme.of(context).copyWith(
                                          dividerColor: Colors.transparent),
                                      child: DataTable(
                                          showBottomBorder: true,
                                          dataRowHeight: 30,
                                          columnSpacing: 40,
                                          columns: [
                                            DataColumn(
                                              label: Text('No',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: 'Poppins',
                                                      color: Colorr.IconColor)),
                                            ),
                                            DataColumn(
                                              label: Text('Name',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: 'Poppins',
                                                      color: Colorr.IconColor)),
                                            ),
                                            DataColumn(
                                              label: Text('Date',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: 'Poppins',
                                                      color: Colorr.IconColor)),
                                            ),
                                            DataColumn(
                                              label: Text('Day',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: 'Poppins',
                                                      color: Colorr.IconColor)),
                                            ),
                                            DataColumn(
                                              label: Text('Time In',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: 'Poppins',
                                                      color: Colorr.IconColor)),
                                            ),
                                            DataColumn(
                                              label: Text('Time Out',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: 'Poppins',
                                                      color: Colorr.IconColor)),
                                            ),
                                          ],
                                          rows: SelectedEmployee.asMap()
                                              .entries
                                              .map((entry) {
                                            int index = entry.key + 1;
                                            final e = entry.value;
                                            String formattedTime = "";
                                            String formattedTime1 = "";
                                            String dayName = "";
                                            if (e['timeIn'] != null) {
                                              String timeim =
                                                  e['timeIn'].toString();
                                              DateTime t =
                                                  DateTime.parse(timeim)
                                                      .toLocal();
                                              String formattedDateTime =
                                                  DateFormat(
                                                          'yyyy-MM-dd hh:mm:ss a')
                                                      .format(t);
                                              DateTime dateTime = DateFormat(
                                                      'yyyy-MM-dd hh:mm:ss a')
                                                  .parse(formattedDateTime);
                                              formattedTime =
                                                  DateFormat('hh:mm a')
                                                      .format(dateTime);
                                              DateTime date = DateTime.parse(
                                                  timeim.substring(0, 10));
                                              dayName = getDayName(date);
                                            }
                                            if (e['timeOut'] != null) {
                                              String timeout =
                                                  e['timeOut'].toString();
                                              DateTime t =
                                                  DateTime.parse(timeout)
                                                      .toLocal();
                                              String formattedDateTime =
                                                  DateFormat(
                                                          'yyyy-MM-dd hh:mm:ss a')
                                                      .format(t);
                                              DateTime dateTime = DateFormat(
                                                      'yyyy-MM-dd hh:mm:ss a')
                                                  .parse(formattedDateTime);
                                              formattedTime1 =
                                                  DateFormat('hh:mm a')
                                                      .format(dateTime);
                                            }
                                            return DataRow(cells: [
                                              DataCell(Text(
                                                index.toString(),
                                                style: TextStyle(
                                                    fontSize: width * 0.03,
                                                    fontFamily: 'Poppins',
                                                    color: Colorr.themcolor300),
                                              )),
                                              DataCell(Text(
                                                e['employeeId']['FirstName']
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: width * 0.03,
                                                    fontFamily: 'Poppins',
                                                    color: Colorr.themcolor300),
                                              )),
                                              DataCell(Text(
                                                  CustomWidgets
                                                      .DateFormatchange(
                                                          e['createdAt']),
                                                  style: TextStyle(
                                                    fontSize: width * 0.03,
                                                    color: Colorr.themcolor300,
                                                    fontFamily: 'Poppins',
                                                  ))),
                                              DataCell(Text(dayName,
                                                  style: TextStyle(
                                                      fontSize: width * 0.03,
                                                      fontFamily: 'Poppins',
                                                      color: Colorr
                                                          .themcolor300))),
                                              DataCell(Text(formattedTime,
                                                  style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      color:
                                                          Colorr.themcolor300,
                                                      fontSize: width * 0.03))),
                                              DataCell(Text(formattedTime1,
                                                  style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      color:
                                                          Colorr.themcolor300,
                                                      fontSize: width * 0.03))),
                                            ]);
                                          }).toList()),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: height * 0.48,
                        width: width,
                        margin: EdgeInsets.only(top: 10, bottom: 10),
                        padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                        decoration: BoxDecoration(
                            color: Colorr.White,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(children: [
                          Row(
                            children: [
                              CustomWidgets.width(width / 30),
                              Image.asset(
                                "images/statistics.webp",
                                height: height / 25,
                                width: width / 20,
                              ),
                              CustomWidgets.width(width / 35),
                              Text("Statistics",
                                  style: TextStyle(
                                      fontSize: width * 0.042,
                                      color: Colorr.FontColor,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins')),
                            ],
                          ),
                          CustomWidgets.height(10),
                          Container(
                            height: height / 12,
                            padding: EdgeInsets.only(right: 10, left: 10),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colorr.themcolor500),
                                borderRadius: BorderRadius.circular(5)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomWidgets.height(5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Today",
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            color: Colorr.themcolor,
                                            fontSize: width * 0.035)),
                                    CupertinoSlider(
                                      min: 0.0,
                                      max: 9,
                                      activeColor: Colors.green,
                                      thumbColor: Colorr.White,
                                      value: 5,
                                      onChanged: (value) {},
                                    ),
                                    Text("6/9 hrs",
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            color: Colorr.themcolor500,
                                            fontSize: width * 0.035)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          CustomWidgets.height(10),
                          Container(
                            height: height / 12,
                            padding: EdgeInsets.only(right: 10, left: 10),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colorr.themcolor500),
                                borderRadius: BorderRadius.circular(5)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomWidgets.height(5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("This Week",
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            color: Colorr.themcolor,
                                            fontSize: width * 0.035)),
                                    CupertinoSlider(
                                      min: 0.0,
                                      max: 9,
                                      activeColor: Colors.green,
                                      thumbColor: Colorr.White,
                                      value: 5,
                                      onChanged: (value) {},
                                    ),
                                    Text("6/9 hrs",
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            color: Colorr.themcolor500,
                                            fontSize: width * 0.035)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          CustomWidgets.height(10),
                          Container(
                            height: height / 12,
                            padding: EdgeInsets.only(right: 10, left: 10),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colorr.themcolor500),
                                borderRadius: BorderRadius.circular(5)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomWidgets.height(5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("This Month",
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            color: Colorr.themcolor,
                                            fontSize: width * 0.035)),
                                    CupertinoSlider(
                                      min: 0.0,
                                      max: 9,
                                      activeColor: Colors.green,
                                      thumbColor: Colorr.White,
                                      value: 5,
                                      onChanged: (value) {},
                                    ),
                                    Text("6/9 hrs",
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            color: Colorr.themcolor500,
                                            fontSize: width * 0.035)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          CustomWidgets.height(10),
                          Container(
                            height: height / 12,
                            padding: EdgeInsets.only(right: 10, left: 10),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colorr.themcolor500),
                                borderRadius: BorderRadius.circular(5)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomWidgets.height(5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Overtime",
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            color: Colorr.themcolor,
                                            fontSize: width * 0.035)),
                                    CupertinoSlider(
                                      min: 0.0,
                                      max: 9,
                                      activeColor: Colors.green,
                                      thumbColor: Colorr.White,
                                      value: 5,
                                      onChanged: (value) {},
                                    ),
                                    Text("6/9 hrs",
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            color: Colorr.themcolor500,
                                            fontSize: width * 0.035)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ]),
                      )
                    ],
                  )),
                ))
            : Scaffold(
                appBar: CustomWidgets.appbar(
                  title: Constants_Usermast.statuse == "ADMIN"
                      ? "Employee Dashboard"
                      : "Dashboard",
                  action: [
                    IconButton(
                        splashRadius: 20,
                        onPressed: () async {
                          Employee.text = "";
                          Employee1.text = "";
                          dropdownValue.text = "";
                          dropdownValue1.text = "";
                          String formattedDate1 =
                              DateFormat('yyyy-MM-dd').format(DateTime.now());
                          EmployeeAttendance =
                              await Attendance_api.FilterApiSingalDate(
                                  formattedDate1);
                          SelectedEmployee = EmployeeAttendance;
                          SelectedEmployee1 = EmployeeAttendance;
                          setState(() {});
                        },
                        icon: Icon(
                          Icons.refresh,
                          color: Colors.white,
                        ))
                  ],
                  context: context,
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) {
                        return Dashboard();
                      },
                    ));
                  },
                ),
                body: mainwidget(),
              ));
  }

  Widget mainwidget() {
    if (internetConn == 1) {
      return Container(
        height: height,
        width: width,
        padding: EdgeInsets.all(10),
        color: Colorr.Backgroundd,
        child: SingleChildScrollView(
          child: Column(children: [
            Container(
              height: height / 3,
              width: width,
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              decoration: BoxDecoration(
                  color: Colorr.White, borderRadius: BorderRadius.circular(10)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomWidgets.width(width / 35),
                        Image.asset("images/checking-attendance.webp",
                            height: height / 25, width: width / 20),
                        CustomWidgets.width(width / 70),
                        Text("Today Status",
                            style: TextStyle(
                                fontSize: width * 0.04,
                                color: Colorr.FontColor,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins')),
                        Spacer(),
                        Container(
                          height: MediaQuery.of(context).size.height / 20,
                          width: MediaQuery.of(context).size.width / 2.5,
                          margin: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width * 0.01,
                            top: MediaQuery.of(context).size.width * 0.02,
                            bottom: MediaQuery.of(context).size.width * 0.02,
                          ),
                          child: CustomDropdown(
                            listItemStyle: TextStyle(fontSize: 12),
                            hintStyle: TextStyle(color: Colorr.themcolor),
                            selectedStyle: TextStyle(
                                fontSize: 12, color: Colorr.themcolor),
                            hintText: FilterList.first,
                            controller: dropdownValue,
                            items: FilterList,
                            onChanged: (value) async {
                              if (value == "Today") {
                                List<dynamic> temp = await Attendance_api.FilterApiSingalDate1(DateFormat("yyyy-MM-dd").format(DateTime.now()));
                                EmployeeAttendance = temp.where((element) => element.containsKey('timeIn') ? true :false).toList();
                                setState(() {});
                              } else if (value == "Yesterday") {
                                  var temp = await Attendance_api.FilterApiSingalDate1(DateFormat("yyyy-MM-dd").format(DateTime.now().subtract(Duration(days: 1))));
                                  EmployeeAttendance = temp.where((element) => element.containsKey('timeIn') ? true :false).toList();
                                  setState(() {});
                              } else if (value == "Custom Date") {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return StatefulBuilder(
                                      builder: (context, setState1) {
                                        return Dialog(
                                          child: Container(
                                            height: height / 2.5,
                                            child: Column(
                                              children: [
                                                AppBar(
                                                  backgroundColor:
                                                      Colorr.themcolor,
                                                  centerTitle: true,
                                                  automaticallyImplyLeading:
                                                      false,
                                                  elevation: 0,
                                                  title: Text(
                                                      "Select Custom Date",
                                                      style: TextStyle(
                                                          fontSize: 14)),
                                                  actions: [
                                                    IconButton(
                                                        splashRadius: 18,
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                          setState1(() {
                                                            Singleday.text = "";
                                                          });
                                                        },
                                                        icon: Icon(Icons.close))
                                                  ],
                                                ),
                                                CustomWidgets.height(10),
                                                CustomWidgets.textField(
                                                    hintText: "Select Date",
                                                    readOnly: true,
                                                    controller: Singleday,
                                                    suffixIcon: InkWell(
                                                        onTap: () => CustomWidgets
                                                            .selectDate(
                                                                context:
                                                                    context,
                                                                controller:
                                                                    Singleday,
                                                                Future: true),
                                                        child: CustomWidgets
                                                            .DateIcon())),
                                                Spacer(),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    CustomWidgets.confirmButton(
                                                        onTap: () async {
                                                          Singleday.text = "";
                                                          setState1(() {});

                                                          Navigator.pop(context);
                                                        },
                                                        height: height / 20,
                                                        width: width / 3,
                                                        text: "Cancel"),
                                                    CustomWidgets.confirmButton(
                                                        onTap: () async {
                                                          var temp = await Attendance_api.FilterApiSingalDate1(DateFormat("yyyy-MM-dd").format(DateFormat('dd-MM-yyyy').parse(Singleday.text)));
                                                          EmployeeAttendance = temp.where((element) => element.containsKey('timeIn') ? true :false).toList();
                                                          setState(() {});
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        height: height / 20,
                                                        width: width / 3,
                                                        text: "Done"),
                                                  ],
                                                ),
                                                CustomWidgets.height(
                                                    height / 50)
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        )
                      ],
                    ),
                    AspectRatio(
                      aspectRatio: 2,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: PieChart(
                            dataMap: dataMap,
                            centerTextStyle: TextStyle(
                                fontSize: height * 0.02,
                                color: Colorr.themcolor,
                                fontFamily: 'Poppins',
                                backgroundColor: Colorr.White),
                            animationDuration: Duration(milliseconds: 800),
                            chartLegendSpacing: height * 0.10,
                            baseChartColor: Colors.white,
                            chartRadius:
                                MediaQuery.of(context).size.width / 1.5,
                            colorList: [
                              Constants_Usermast.employeeId.isEmpty
                                  ? Colors.red
                                  : EmployeeAttendance.where((element) =>
                                          element['employeeId']['_id'] ==
                                          Constants_Usermast.employeeId).isEmpty
                                      ? Colors.red
                                      : Colors.green
                            ],
                            initialAngleInDegree: 0,
                            chartType: ChartType.ring,
                            ringStrokeWidth: 15,
                            centerText: "Today",
                            legendOptions: const LegendOptions(
                              showLegendsInRow: false,
                              legendPosition: LegendPosition.right,
                              showLegends: true,
                              legendShape: BoxShape.circle,
                              legendTextStyle: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            chartValuesOptions: const ChartValuesOptions(
                              showChartValueBackground: true,
                              showChartValues: false,
                              showChartValuesInPercentage: false,
                              showChartValuesOutside: false,
                              decimalPlaces: 1,
                            ),
                            // gradientList: ---To add gradient colors---
                            // emptyColorGradient: ---Empty Color gradient---
                          ),
                        ),
                      ),
                    ),
                  ]),
            ),
            Container(
              height: height / 2.4,
              width: width,
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              margin: EdgeInsets.only(top: 10, bottom: 10),
              decoration: BoxDecoration(
                  color: Colorr.White, borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  Row(
                    children: [
                      CustomWidgets.width(width / 35),
                      Image.asset(
                        "images/checking-attendance.webp",
                        height: height / 25,
                        width: width / 20,
                      ),
                      CustomWidgets.width(width / 70),
                      Text("Today Attendance",
                          style: TextStyle(
                              fontSize: width * 0.042,
                              color: Colorr.FontColor,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins')),
                      Spacer(),
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colorr.themcolor500,
                            // Set the desired border color here
                            width: 2, // Set the desired border width
                          ),
                        ),
                        child: CircleAvatar(
                          radius: height / 40,
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.white,
                          child: Align(
                            alignment: Alignment.center,
                            child: IconButton(
                                onPressed: null,
                                icon: Icon(
                                  Icons.calendar_month_outlined,
                                  size: width * 0.05,
                                  color: Colorr.themcolor500,
                                )),
                          ),
                        ),
                      ),
                      CustomWidgets.width(width / 35),
                      Text(
                        formattedDate,
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colorr.themcolor500,
                            fontSize: width * 0.03),
                      )
                    ],
                  ),
                  CustomWidgets.height(height * 0.01),
                  Constants_Usermast.statuse == "ADMIN"
                      ? CustomDropdown.search(
                          listItemStyle: CustomWidgets.style(),
                          hintText: 'Select Employee',
                          controller: Employee1,
                          items: AllEmployee,
                          onChanged: (value) async {
                            DateTime currentDate1 = DateTime.now();
                            String formattedDate1 =
                                DateFormat('yyyy-MM-dd').format(currentDate1);
                            SelectedEmployee1 =
                                await Attendance_api.FilterApiSingalDate(
                                    formattedDate1);
                            SelectedEmployee1 = SelectedEmployee1.where((e) =>
                                e['employeeId']['FirstName'] ==
                                Employee1.text).toList();

                            setState(() {});
                          },
                        )
                      : Container(),
                  Expanded(
                      child: Container(
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colorr.themcolor200,
                        borderRadius: BorderRadius.circular(10)),
                    child: SelectedEmployee1.isEmpty
                        ? Center(
                            child: Image.asset(
                                height: MediaQuery.of(context).size.height / 8,
                                "images/NoData.webp"))
                        : ListView.builder(
                            physics: ClampingScrollPhysics(),
                            itemCount: SelectedEmployee1.length,
                            itemBuilder: (context, index) {
                              String formattedTime = "";
                              String formattedTime1 = "";
                              SelectedEmployee1.sort((b, a) => b['timeIn']
                                  .toString()
                                  .compareTo(a['timeIn']));
                              if (SelectedEmployee1[index]['timeIn'] != null) {
                                String timeim = SelectedEmployee1[index]
                                        ['timeIn']
                                    .toString();
                                DateTime t = DateTime.parse(timeim).toLocal();
                                String formattedDateTime =
                                    DateFormat('yyyy-MM-dd hh:mm:ss a')
                                        .format(t);
                                DateTime dateTime =
                                    DateFormat('yyyy-MM-dd hh:mm:ss a')
                                        .parse(formattedDateTime);
                                formattedTime =
                                    DateFormat('hh:mm a').format(dateTime);
                              }
                              if (SelectedEmployee1[index]['timeOut'] != null) {
                                String timeout = SelectedEmployee1[index]
                                        ['timeOut']
                                    .toString();
                                DateTime t = DateTime.parse(timeout).toLocal();
                                String formattedDateTime =
                                    DateFormat('yyyy-MM-dd hh:mm:ss a')
                                        .format(t);
                                DateTime dateTime =
                                    DateFormat('yyyy-MM-dd hh:mm:ss a')
                                        .parse(formattedDateTime);
                                formattedTime1 =
                                    DateFormat('hh:mm a').format(dateTime);
                              }
                              return Column(
                                children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        CustomWidgets.width(10),
                                        index == 0
                                            ? Image(
                                                height: height / 20,
                                                image:
                                                    AssetImage("images/7.png"))
                                            : Image(
                                                height: height / 20,
                                                image:
                                                    AssetImage("images/2.png")),
                                        CustomWidgets.width(20),
                                        Text("Punch in",
                                            style: TextStyle(
                                                color: Colorr.White,
                                                fontFamily: 'Poppins',
                                                fontSize: width * 0.035)),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: width * 0.11,
                                              right: width * 0.02),
                                          child: Icon(Icons.alarm,
                                              color: Colorr.White, size: 14),
                                        ),
                                        Text(
                                          formattedTime.toString(),
                                          style: TextStyle(
                                              color: Colorr.White,
                                              fontFamily: 'Poppins',
                                              fontSize: width * 0.035),
                                        )
                                      ]),
                                  SelectedEmployee1[index]['timeOut'] != null
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                              CustomWidgets.width(10),
                                              index ==
                                                      SelectedEmployee1.length -
                                                          1
                                                  ? Image(
                                                      height: height / 20,
                                                      image: AssetImage(
                                                          "images/1.png"))
                                                  : Image(
                                                      height: height / 20,
                                                      image: AssetImage(
                                                          "images/1.png")),
                                              CustomWidgets.width(20),
                                              Text("Punch out",
                                                  style: TextStyle(
                                                      color: Colorr.White,
                                                      fontFamily: 'Poppins',
                                                      fontSize: width * 0.035)),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: width * 0.085,
                                                    right: width * 0.02),
                                                child: Icon(Icons.alarm,
                                                    color: Colorr.White,
                                                    size: 14),
                                              ),
                                              Text(
                                                formattedTime1.toString(),
                                                style: TextStyle(
                                                    color: Colorr.White,
                                                    fontFamily: 'Poppins',
                                                    fontSize: width * 0.035),
                                              )
                                            ])
                                      : Container(),
                                ],
                              );
                            },
                          ),
                  ))
                ],
              ),
            ),
            Container(
              height: height / 2.5,
              width: width,
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              decoration: BoxDecoration(
                  color: Colorr.White, borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  CustomWidgets.height(10),
                  Constants_Usermast.statuse == "ADMIN"
                      ? CustomDropdown.search(
                          excludeSelected: false,
                          listItemStyle: CustomWidgets.style(),
                          hintText: 'Select Employee',
                          controller: Employee,
                          items: AllEmployee,
                          onChanged: (value) async {
                            get_Statistics(Employee.text);
                            String formattedDate1 =
                                DateFormat('yyyy-MM-dd').format(DateTime.now());
                            SelectedEmployee =
                                await Attendance_api.FilterApiSingalDate(
                                    formattedDate1);
                            SelectedEmployee = SelectedEmployee.where((e) =>
                                e['employeeId']['FirstName'] ==
                                Employee.text).toList();
                            setState(() {});
                          },
                        )
                      : Container(),
                  Row(
                    children: [
                      CustomWidgets.width(width / 30),
                      Image.asset(
                        "images/checking-attendance.webp",
                        height: height / 25,
                        width: width / 20,
                      ),
                      CustomWidgets.width(width / 70),
                      Text("Attendance List",
                          style: TextStyle(
                              fontSize: width * 0.042,
                              color: Colorr.FontColor,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins')),
                      Spacer(),
                      Container(
                        height: MediaQuery.of(context).size.height / 20,
                        width: MediaQuery.of(context).size.width / 2.5,
                        margin: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * 0.01,
                          top: MediaQuery.of(context).size.width * 0.02,
                          bottom: MediaQuery.of(context).size.width * 0.02,
                        ),
                        child: CustomDropdown(
                          hintStyle: TextStyle(fontSize: 12),
                          selectedStyle:
                              TextStyle(fontSize: 12, color: Colorr.themcolor),
                          listItemStyle: TextStyle(fontSize: 12),
                          hintText: FilterList.first,
                          controller: dropdownValue1,
                          items: FilterList,
                          onChanged: (value) async {
                            if (value == "Today") {
                              DateTime currentDate1 = DateTime.now();
                              String formattedDate1 =
                                  DateFormat('yyyy-MM-dd').format(currentDate1);
                              SelectedEmployee = [];
                              SelectedEmployee =
                                  await Attendance_api.FilterApiSingalDate(
                                      formattedDate1);
                              if (Constants_Usermast.statuse != "ADMIN") {
                                SelectedEmployee = SelectedEmployee.where(
                                    (element) =>
                                        element['employeeId']['_id'] ==
                                        Constants_Usermast.employeeId).toList();
                              }
                              if (Employee.text.isNotEmpty &&
                                  Constants_Usermast.statuse == "ADMIN") {
                                SelectedEmployee = SelectedEmployee.where(
                                    (element) =>
                                        element['employeeId']['FirstName'] ==
                                        Employee.text).toList();
                              }
                              setState(() {});
                            } else if (value == "Yesterday") {
                              DateTime currentDate1 =
                                  DateTime.now().subtract(Duration(days: 1));
                              String formattedDate1 =
                                  DateFormat('yyyy-MM-dd').format(currentDate1);
                              SelectedEmployee = [];
                              SelectedEmployee =
                                  await Attendance_api.FilterApiSingalDate(
                                      formattedDate1);
                              if (Constants_Usermast.statuse != "ADMIN") {
                                SelectedEmployee = SelectedEmployee.where(
                                    (element) =>
                                        element['employeeId']['_id'] ==
                                        Constants_Usermast.employeeId).toList();
                              }
                              if (Employee.text.isNotEmpty &&
                                  Constants_Usermast.statuse == "ADMIN") {
                                SelectedEmployee = SelectedEmployee.where(
                                    (element) =>
                                        element['employeeId']['FirstName'] ==
                                        Employee.text).toList();
                              }
                              setState(() {});
                            } else if (value == "Custom Date") {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return StatefulBuilder(
                                    builder: (context, setState1) {
                                      return Dialog(
                                        child: Container(
                                          height: height / 2.5,
                                          child: Column(
                                            children: [
                                              AppBar(
                                                backgroundColor:
                                                    Colorr.themcolor,
                                                centerTitle: true,
                                                automaticallyImplyLeading:
                                                    false,
                                                elevation: 0,
                                                title: Text(
                                                    "Select Custom Date",
                                                    style: TextStyle(
                                                        fontSize: 14)),
                                                actions: [
                                                  IconButton(
                                                      splashRadius: 18,
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        setState1(() {});
                                                      },
                                                      icon: Icon(Icons.close))
                                                ],
                                              ),
                                              CustomWidgets.height(10),
                                              CustomWidgets.textField(
                                                  hintText: "Select Date",
                                                  readOnly: true,
                                                  controller: Singleday1,
                                                  suffixIcon: InkWell(
                                                      onTap: () => CustomWidgets
                                                          .selectDate(
                                                              context: context,
                                                              controller:
                                                                  Singleday1,
                                                              Future: true),
                                                      child: CustomWidgets
                                                          .DateIcon())),
                                              Spacer(),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  CustomWidgets.confirmButton(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                      height: height / 20,
                                                      width: width / 3,
                                                      text: "Cancel"),
                                                  CustomWidgets.confirmButton(
                                                      onTap: () async {
                                                        final inputFormat =
                                                            DateFormat(
                                                                "dd-MM-yyyy");
                                                        DateTime dateTime =
                                                            inputFormat.parse(
                                                                Singleday1
                                                                    .text);
                                                        final outputFormat =
                                                            DateFormat(
                                                                "yyyy-MM-dd");
                                                        String formattedDate =
                                                            outputFormat.format(
                                                                dateTime);
                                                        SelectedEmployee = [];
                                                        SelectedEmployee =
                                                            await Attendance_api
                                                                .FilterApiSingalDate(
                                                                    formattedDate);
                                                        if (Constants_Usermast
                                                                .statuse !=
                                                            "ADMIN") {
                                                          SelectedEmployee = SelectedEmployee
                                                              .where((element) =>
                                                                  element['employeeId']
                                                                      ['_id'] ==
                                                                  Constants_Usermast
                                                                      .employeeId).toList();
                                                        }
                                                        if (Employee.text
                                                                .isNotEmpty &&
                                                            Constants_Usermast
                                                                    .statuse ==
                                                                "ADMIN") {
                                                          SelectedEmployee = SelectedEmployee
                                                              .where((element) =>
                                                                  element['employeeId']
                                                                      [
                                                                      'FirstName'] ==
                                                                  Employee
                                                                      .text).toList();
                                                        }
                                                        Navigator.pop(context);
                                                        setState(() {});
                                                      },
                                                      height: height / 20,
                                                      width: width / 3,
                                                      text: "Done"),
                                                ],
                                              ),
                                              CustomWidgets.height(height / 50)
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: Colorr.Black54,
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 8),
                      child: SingleChildScrollView(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Theme(
                            data: Theme.of(context)
                                .copyWith(dividerColor: Colors.transparent),
                            child: DataTable(
                                showBottomBorder: true,
                                dataRowHeight: 30,
                                columnSpacing: 40,
                                columns: [
                                  DataColumn(
                                    label: Text('No',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Poppins',
                                            color: Colorr.IconColor)),
                                  ),
                                  DataColumn(
                                    label: Text('Name',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Poppins',
                                            color: Colorr.IconColor)),
                                  ),
                                  DataColumn(
                                    label: Text('Date',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Poppins',
                                            color: Colorr.IconColor)),
                                  ),
                                  DataColumn(
                                    label: Text('Day',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Poppins',
                                            color: Colorr.IconColor)),
                                  ),
                                  DataColumn(
                                    label: Text('Time In',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Poppins',
                                            color: Colorr.IconColor)),
                                  ),
                                  DataColumn(
                                    label: Text('Time Out',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Poppins',
                                            color: Colorr.IconColor)),
                                  ),
                                ],
                                rows: SelectedEmployee.asMap()
                                    .entries
                                    .map((entry) {
                                  int index = entry.key + 1;
                                  final e = entry.value;
                                  String formattedTime = "";
                                  String formattedTime1 = "";
                                  String dayName = "";
                                  if (e['timeIn'] != null) {
                                    String timeim = e['timeIn'].toString();
                                    DateTime t =
                                        DateTime.parse(timeim).toLocal();
                                    String formattedDateTime =
                                        DateFormat('yyyy-MM-dd hh:mm:ss a')
                                            .format(t);
                                    DateTime dateTime =
                                        DateFormat('yyyy-MM-dd hh:mm:ss a')
                                            .parse(formattedDateTime);
                                    formattedTime =
                                        DateFormat('hh:mm a').format(dateTime);
                                    DateTime date =
                                        DateTime.parse(timeim.substring(0, 10));
                                    dayName = getDayName(date);
                                  }
                                  if (e['timeOut'] != null) {
                                    String timeout = e['timeOut'].toString();
                                    DateTime t =
                                        DateTime.parse(timeout).toLocal();
                                    String formattedDateTime =
                                        DateFormat('yyyy-MM-dd hh:mm:ss a')
                                            .format(t);
                                    DateTime dateTime =
                                        DateFormat('yyyy-MM-dd hh:mm:ss a')
                                            .parse(formattedDateTime);
                                    formattedTime1 =
                                        DateFormat('hh:mm a').format(dateTime);
                                  }
                                  return DataRow(cells: [
                                    DataCell(Text(
                                      index.toString(),
                                      style: TextStyle(
                                          fontSize: width * 0.03,
                                          fontFamily: 'Poppins',
                                          color: Colorr.themcolor300),
                                    )),
                                    DataCell(Text(
                                      e.containsKey('FirstName')
                                          ? e['FirstName']
                                          : e.containsKey('employeeData')
                                              ? e['employeeData'][0]
                                                      ['FirstName']
                                                  .toString()
                                              : e['employeeId']['FirstName']
                                                  .toString(),
                                      style: TextStyle(
                                          fontSize: width * 0.03,
                                          fontFamily: 'Poppins',
                                          color: Colorr.themcolor300),
                                    )),
                                    DataCell(Text(
                                        CustomWidgets.DateFormatchange(
                                            e['createdAt']),
                                        style: TextStyle(
                                          fontSize: width * 0.03,
                                          color: Colorr.themcolor300,
                                          fontFamily: 'Poppins',
                                        ))),
                                    DataCell(Text(dayName,
                                        style: TextStyle(
                                            fontSize: width * 0.03,
                                            fontFamily: 'Poppins',
                                            color: Colorr.themcolor300))),
                                    DataCell(Text(formattedTime,
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            color: Colorr.themcolor300,
                                            fontSize: width * 0.03))),
                                    DataCell(Text(formattedTime1,
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            color: Colorr.themcolor300,
                                            fontSize: width * 0.03))),
                                  ]);
                                }).toList()),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: height / 1.7,
              width: width,
              margin: EdgeInsets.only(top: 10, bottom: 10),
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              decoration: BoxDecoration(
                  color: Colorr.White, borderRadius: BorderRadius.circular(10)),
              child: Column(children: [
                Row(
                  children: [
                    CustomWidgets.width(width / 30),
                    Image.asset(
                      "images/statistics.webp",
                      height: height / 25,
                      width: width / 20,
                    ),
                    CustomWidgets.width(width / 35),
                    Text("Statistics",
                        style: TextStyle(
                            fontSize: width * 0.042,
                            color: Colorr.FontColor,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins')),
                  ],
                ),
                CustomWidgets.height(10),
                Container(
                  height: height / 9,
                  padding: EdgeInsets.only(right: 10, left: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colorr.themcolor500),
                      borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomWidgets.height(5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Today",
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colorr.themcolor,
                                  fontSize: width * 0.035)),
                          Text(
                              "${Total_Wor.toString().length > 4 ? Total_Wor.toString().substring(0, Total_Wor.toString().indexOf(".") + 3) : Total_Wor}/$Total_hrs hrs",
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colorr.themcolor500,
                                  fontSize: width * 0.035)),
                        ],
                      ),
                      Slider(
                        min: 0.0,
                        max: Total_hrs,
                        activeColor: Colors.green,
                        inactiveColor: Colors.green.shade50,
                        thumbColor: Colorr.White,
                        value: Total_Wor,
                        onChanged: (value) {},
                      )
                    ],
                  ),
                ),
                CustomWidgets.height(10),
                Container(
                  height: height / 9,
                  padding: EdgeInsets.only(right: 10, left: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colorr.themcolor500),
                      borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomWidgets.height(5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("This Week",
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colorr.themcolor,
                                  fontSize: width * 0.035)),
                          Text("$Week_Wor/$Week_hrs hrs",
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colorr.themcolor500,
                                  fontSize: width * 0.035)),
                        ],
                      ),
                      Slider(
                        min: 0.0,
                        max: Week_hrs,
                        activeColor: Colors.red,
                        inactiveColor: Colors.red.shade50,
                        thumbColor: Colorr.White,
                        value: Week_Wor,
                        onChanged: (value) {
                          setState(() {});
                        },
                      )
                    ],
                  ),
                ),
                CustomWidgets.height(10),
                Container(
                  height: height / 9,
                  padding: EdgeInsets.only(right: 10, left: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colorr.themcolor500),
                      borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomWidgets.height(5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("This Month",
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colorr.themcolor,
                                  fontSize: width * 0.035)),
                          Text("$Month_Wor/$Month_hrs hrs",
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colorr.themcolor500,
                                  fontSize: width * 0.035)),
                        ],
                      ),
                      Slider(
                        min: 0.0,
                        max: Month_hrs,
                        activeColor: Colors.blue,
                        inactiveColor: Colors.blue.shade50,
                        thumbColor: Colorr.White,
                        value: Month_Wor,
                        onChanged: (value) {
                          setState(() {});
                        },
                      )
                    ],
                  ),
                ),
                CustomWidgets.height(10),
                Container(
                  height: height / 9,
                  padding: EdgeInsets.only(right: 10, left: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colorr.themcolor500),
                      borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomWidgets.height(5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Overtime",
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colorr.themcolor,
                                  fontSize: width * 0.035)),
                          Text("$Overtime_hrs hrs/$Total_hrs hrs",
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colorr.themcolor500,
                                  fontSize: width * 0.035)),
                        ],
                      ),
                      Slider(
                        min: 0.0,
                        max: Overtime_hrs,
                        activeColor: Colors.yellowAccent,
                        inactiveColor: Colors.yellow.shade100,
                        thumbColor: Colorr.White,
                        value: Overtime_hrs,
                        onChanged: (value) {
                          setState(() {});
                        },
                      )
                    ],
                  ),
                ),
              ]),
            )
          ]),
        ),
      );
    } else if (internetConn == 2) {
      return CustomWidgets.NoInternetImage(context);
    } else {
      return CustomWidgets.Circularprogress(context);
    }
  }

  String getDayName(DateTime date) {
    List<String> daysOfWeek = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    int dayIndex = date.weekday - 1;
    return daysOfWeek[dayIndex];
  }

  get_Statistics(String employeess) async {
    int THour = 0;
    int TMin = 0;
    int TSec = 0;
    int WHour = 0;
    int WMin = 0;
    int WSec = 0;
    int MHour = 0;
    int MMin = 0;
    int MSec = 0;
    String Shify = "";
    String Employeeid = "";
    String total = "";
    List ToTal_overtime = [];
    List<dynamic> Total_hour = [];
    List<dynamic> Overtime = [];
    Map Total_Atte = {};
    Employeeid = Con_List.AllEmployee.where(
            (element) => element['FirstName'].toString() == employeess)
        .first['_id']
        .toString();
    Total_Atte = await Attendance_api.StatisticsAttendence(Employeeid);
    Total_hour = await Shift_Add_api.shift_Select();
    Overtime = await Overtime_api.Overtime_Select();
    Shify = Con_List.AllEmployee.where(
            (element) => element['FirstName'].toString() == employeess)
        .first['ShiftId']['_id']
        .toString();
    Employeeid = Con_List.AllEmployee.where(
            (element) => element['FirstName'].toString() == employeess)
        .first['_id']
        .toString();
    total = Total_hour.firstWhere((element) =>
            element['_id'].toString() == Shify.toString())['fullHours']
        .toString();
    total = total.replaceAll(":", ".").trim();
    total = total.replaceAll(" ", "").trim();
    total = total.replaceAll("-", "").trim();
    THour = Total_Atte['today']['hours'];
    TMin = Total_Atte['today']['minutes'];
    TSec = int.parse(Total_Atte['today']['seconds'].toString());
    WHour = Total_Atte['week']['hours'];
    WMin = Total_Atte['week']['minutes'];
    WSec = int.parse(Total_Atte['week']['seconds'].toString());
    MHour = Total_Atte['month']['hours'];
    MMin = Total_Atte['month']['minutes'];
    MSec = int.parse(Total_Atte['month']['seconds'].toString());
    TMin = TMin + (THour * 60) + (TSec ~/ 60);
    WMin = WMin + (WHour * 60) + (WSec ~/ 60);
    MMin = MMin + (MHour * 60) + (MSec ~/ 60);

    int hours = TMin ~/ 60;
    int remainingMinutes = TMin % 60;
    String formattedTime =
        '$hours.${remainingMinutes.toString().padLeft(2, '0')}';
    Total_Wor = double.parse(formattedTime.toString());
    Total_hrs = double.parse(total);
    int Whours = WMin ~/ 60;
    int WremainingMinutes = WMin % 60;
    String WformattedTime =
        '$Whours.${WremainingMinutes.toString().padLeft(2, '0')}';
    Week_Wor = double.parse(WformattedTime.toString());
    Week_hrs = double.parse(total) * 6;
    int Mhours = MMin ~/ 60;
    int MremainingMinutes = MMin % 60;
    String MformattedTime =
        '$Mhours.${MremainingMinutes.toString().padLeft(2, '0')}';
    Month_Wor = double.parse(MformattedTime.toString());
    final daysInMonth =
        DateUtils.getDaysInMonth(DateTime.now().year, DateTime.now().month);
    Month_hrs =
        double.parse(total) * (double.parse(daysInMonth.toString()) - 4);

    ToTal_overtime = Overtime.where((element) =>
            element['employeeId'] == Employeeid &&
            element['overTimeDate'].toString().substring(0, 10) ==
                "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, "0").toString()}-${DateTime.now().day.toString().padLeft(2,"0")}")
        .map((e) => e['overTimeHours'])
        .toList();
    int totalMinutes = 0;
    ToTal_overtime.forEach((element) {
      final time = element.toString().contains("-")
          ? element.toString().substring(1, element.toString().length - 1)
          : element;
      final parts = time.split(time.toString().contains(":") ? ":" : ".");
      final Ohoure = int.parse(parts[0]);
      final Ominutes = int.parse(parts[1]);
      totalMinutes = totalMinutes + Ohoure * 60 + Ominutes;
    });
    int Ohours = totalMinutes ~/ 60;
    int OremainingMinutes = totalMinutes % 60;
    String OformattedTime =
        '$Ohours.${OremainingMinutes.toString().padLeft(2, '0')}';
    Overtime_hrs = double.parse(OformattedTime.toString());
    setState(() {});
  }
}
