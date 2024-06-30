import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:attendy/A_SQL_Trigger/Con_Usermast.dart';
import 'package:attendy/A_SQL_Trigger/Deparment_api_page.dart';
import 'package:attendy/A_SQL_Trigger/Designations_api.dart';
import 'package:attendy/A_SQL_Trigger/Employee_Add_api.dart';
import 'package:attendy/utils/Constant/LocalCustomWidgets.dart';
import 'package:attendy/view/Dashboard/Dashboard.dart';
import 'package:attendy/view/Employee/AllEmployees.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import '../../A_SQL_Trigger/Attendance_api.dart';
import '../../A_SQL_Trigger/Con_List.dart';
import '../../utils/Constant/Colors.dart';
import '../../utils/DroupDown/custom_dropdown.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
    with TickerProviderStateMixin {
  List SelectDay = ["Today", "Yesterday", "Custom Date"];
  double height = 0;
  int internetConn = 0;
  bool DateRange = true;
  TextEditingController employeeName = TextEditingController();
  int _selectedIndex = 0;
  ScrollController _Controller = ScrollController();
  int _selectedIndex1 = 0;
  DateTime? fromDate;
  DateTime? toDate;
  Map<String, double> dataMap = {
    "0 Present": 0.0,
    "0 Late": 0.0,
    "0 Early Out": 0.0,
    "0 Absent": 0.0
  };
  TextEditingController Startdate = TextEditingController();
  TextEditingController Enddate = TextEditingController();
  TextEditingController Singleday = TextEditingController();
  TextEditingController Startdate1 = TextEditingController();
  TextEditingController Enddate1 = TextEditingController();
  TextEditingController Singleday1 = TextEditingController();
  TextEditingController dropdownValue1 = TextEditingController();
  TextEditingController dropdownValue = TextEditingController();
  double width = -0;
  List<dynamic> EmployeeStatusData = [];
  List<dynamic> EmployeeAttendance = [];
  List<dynamic> EmployeeBirthday = [];
  List<dynamic> EmployeeAnni = [];
  TextEditingController Search = TextEditingController();
  List<String> Employee = [];
  List<String> FilterList = ["Today", "Yesterday", "Custom Date"];
  late TabController _tabController;
  late TabController _tabController1;

  TextEditingController Day = TextEditingController();
  int touchedIndex = -1;
  int totalEm = 0;
  bool SelectedDay = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
    _tabController1 = TabController(length: 4, vsync: this);
    CheakInternet();
    getdata();
  }

  CheakInternet() async {
    internetConn = await CustomWidgets.CheakConnectionInternet();
    setState(() {});
  }

  getdata() async {
    Con_List.AllEmployee = await AllEmployee_api.EmployeeSelect();
    Con_List.AllAttandance = await Attendance_api.AttendanceSelect();
    DateTime currentDate1 = DateTime.now();
    String formattedDate1 =
    DateFormat('yyyy-MM-dd')
        .format(currentDate1);
    EmployeeAttendance = await Attendance_api
        .FilterApiSingalDate(formattedDate1);

    Con_List.DesignationSelect =
        await Designations_api.DesignationsSelect("All");
    Con_List.DeparmenntSelect = await Deparmentapi.DeparmentAttendanceSelect();
    Con_List.AllEmployee.forEach((element) {
      if (element['isActive'] == true) {
        Employee.add(element['FirstName']);
      }
    });
    DateTime currentDate = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);
    EmployeeBirthday =
        await Attendance_api.FilterApiSingalDateBirth(formattedDate);
    EmployeeAnni = await Attendance_api.FilterApiSingalDateAnny(formattedDate);
    dataMap = {
      "${Con_List.PresentAttandance.length} Present":
          Con_List.PresentAttandance.length.toDouble(),
      "${Con_List.LatAttandance.length} Late":
          Con_List.LatAttandance.length.toDouble(),
      "${Con_List.EarlyOutAttandance.length} Early Out":
          Con_List.EarlyOutAttandance.length.toDouble(),
      "${Con_List.AbsentAttandance.length} Absent":
          Con_List.AbsentAttandance.length.toDouble()
    };
    totalEm = Con_List.AllEmployee.length;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    _tabController1.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height - kToolbarHeight;
    width = MediaQuery.of(context).size.width;
    setState(() {});
    Future<bool> onBackPress() {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return Dashboard();
        },
      ));
      return Future.value(false);
    }

    List<Widget> tabs = [
      Container(
        child: SingleChildScrollView(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: DataTable(
                  dividerThickness: 0,
                  dataRowHeight: 30,
                  columnSpacing: 30,
                  columns: [
                    DataColumn(
                      label: Text('No',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              overflow: TextOverflow.ellipsis,
                              fontSize: width * 0.035,
                              color: Colorr.themcolor)),
                    ),
                    DataColumn(
                      label: Text('Name',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              overflow: TextOverflow.ellipsis,
                              fontSize: width * 0.035,
                              color: Colorr.themcolor)),
                    ),
                    // DataColumn(
                    //   label: Text('Date',
                    //       style: TextStyle(
                    //           fontFamily: 'Poppins',
                    //           overflow: TextOverflow.ellipsis,
                    //           fontSize: width * 0.035,
                    //           color: Colorr.themcolor)),
                    // ),
                    DataColumn(
                      label: Text('Day',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              overflow: TextOverflow.ellipsis,
                              fontSize: width * 0.035,
                              color: Colorr.themcolor)),
                    ),
                    DataColumn(
                      label: Text('Time In',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              overflow: TextOverflow.ellipsis,
                              fontSize: width * 0.035,
                              color: Colorr.themcolor)),
                    ),
                    DataColumn(
                      label: Text('Time Out',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              overflow: TextOverflow.ellipsis,
                              fontSize: width * 0.035,
                              color: Colorr.themcolor)),
                    ),
                  ],
                  rows: EmployeeAttendance.asMap().entries.map((entry) {
                    int index = entry.key + 1;
                    final e = entry.value;
                    String formattedTime = "";
                    String formattedTime1 = "";
                    String dayName = "";
                    if (e['timeIn'] != null) {
                      String timeim = e['timeIn'].toString();
                      DateTime t = DateTime.parse(timeim).toLocal();
                      String formattedDateTime =
                          DateFormat('yyyy-MM-dd hh:mm:ss a').format(t);
                      DateTime dateTime = DateFormat('yyyy-MM-dd hh:mm:ss a')
                          .parse(formattedDateTime);
                      formattedTime = DateFormat('hh:mm a').format(dateTime);
                      DateTime date = DateTime.parse(timeim.substring(0, 10));
                      dayName = getDayName(date);
                    }
                    if (e['timeOut'] != null) {
                      String timeout = e['timeOut'].toString();
                      DateTime t = DateTime.parse(timeout).toLocal();
                      String formattedDateTime =
                          DateFormat('yyyy-MM-dd hh:mm:ss a').format(t);
                      DateTime dateTime = DateFormat('yyyy-MM-dd hh:mm:ss a')
                          .parse(formattedDateTime);
                      formattedTime1 = DateFormat('hh:mm a').format(dateTime);
                    }

                    return DataRow(cells: [
                      DataCell(Text(
                        index.toString(),
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            overflow: TextOverflow.ellipsis,
                            fontSize: width * 0.03,
                            color: Colorr.themcolor300),
                      )),
                      DataCell(Text(
                        e.containsKey('FirstName')
                            ? e['FirstName']
                            :e.containsKey('employeeId')?e['employeeId']['FirstName']:e['employeeData'][0]['FirstName'].toString(),
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            overflow: TextOverflow.ellipsis,
                            fontSize: width * 0.03,
                            color: Colorr.themcolor300),
                      )),
                      // DataCell(
                      //     Text(CustomWidgets.DateFormatchange(e['createdAt']??""),
                      //         style: TextStyle(
                      //           fontFamily: 'Poppins',
                      //           color: Colorr.themcolor300,
                      //           overflow: TextOverflow.ellipsis,
                      //           fontSize: width * 0.03,
                      //         ))),
                      DataCell(Text(dayName,
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              overflow: TextOverflow.ellipsis,
                              fontSize: width * 0.03,
                              color: Colorr.themcolor300))),
                      DataCell(Text(formattedTime,
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              overflow: TextOverflow.ellipsis,
                              fontSize: width * 0.03,
                              color: Colorr.themcolor300))),
                      DataCell(Text(formattedTime1,
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: width * 0.03,
                              fontFamily: 'Poppins',
                              color: Colorr.themcolor300))),
                    ]);
                  }).toList()),
            ),
          ),
        ),
      ),
      Container(
        child: SingleChildScrollView(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: DataTable(
                  dividerThickness: 0,
                  dataRowHeight: 30,
                  columnSpacing: 30,
                  columns: [
                    DataColumn(
                      label: Text('No',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              overflow: TextOverflow.ellipsis,
                              fontSize: width * 0.035,
                              color: Colorr.themcolor)),
                    ),
                    DataColumn(
                      label: Text('Name',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              overflow: TextOverflow.ellipsis,
                              fontSize: width * 0.035,
                              color: Colorr.themcolor)),
                    ),
                    DataColumn(
                      label: Text('Birthday',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              overflow: TextOverflow.ellipsis,
                              fontSize: width * 0.035,
                              color: Colorr.themcolor)),
                    ),
                  ],
                  rows: EmployeeBirthday.asMap().entries.map((entry) {
                    int index = entry.key + 1;
                    final e = entry.value;
                    return DataRow(cells: [
                      DataCell(Text(
                        index.toString(),
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            overflow: TextOverflow.ellipsis,
                            fontSize: width * 0.03,
                            color: Colorr.themcolor300),
                      )),
                      DataCell(Text(
                        e['FirstName'].toString(),
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            overflow: TextOverflow.ellipsis,
                            fontSize: width * 0.03,
                            color: Colorr.themcolor300),
                      )),
                      DataCell(Text(CustomWidgets.DateFormatchange(e['Dob']),
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colorr.themcolor300,
                            overflow: TextOverflow.ellipsis,
                            fontSize: width * 0.03,
                          ))),
                    ]);
                  }).toList()),
            ),
          ),
        ),
      ),
      Container(
        child: SingleChildScrollView(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: DataTable(
                  dividerThickness: 0,
                  dataRowHeight: 30,
                  columnSpacing: 30,
                  columns: [
                    DataColumn(
                      label: Text('No',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              overflow: TextOverflow.ellipsis,
                              fontSize: width * 0.035,
                              color: Colorr.themcolor)),
                    ),
                    DataColumn(
                      label: Text('Name',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              overflow: TextOverflow.ellipsis,
                              fontSize: width * 0.035,
                              color: Colorr.themcolor)),
                    ),
                    DataColumn(
                      label: Text('Anniversary',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              overflow: TextOverflow.ellipsis,
                              fontSize: width * 0.035,
                              color: Colorr.themcolor)),
                    ),
                  ],
                  rows: EmployeeAnni.asMap().entries.map((entry) {
                    int index = entry.key + 1;
                    final e = entry.value;
                    return DataRow(cells: [
                      DataCell(Text(
                        index.toString(),
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            overflow: TextOverflow.ellipsis,
                            fontSize: width * 0.03,
                            color: Colorr.themcolor300),
                      )),
                      DataCell(Text(
                        e['FirstName'].toString(),
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            overflow: TextOverflow.ellipsis,
                            fontSize: width * 0.03,
                            color: Colorr.themcolor300),
                      )),
                      DataCell(Text(
                          e['AnniversaryDate'] != null
                              ? CustomWidgets.DateFormatchange(
                                  e['AnniversaryDate'])
                              : "",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colorr.themcolor300,
                            overflow: TextOverflow.ellipsis,
                            fontSize: width * 0.03,
                          ))),
                    ]);
                  }).toList()),
            ),
          ),
        ),
      ),
    ];
    List<Widget> tabs1 = [
      Container(
        child: ListView.builder(
          itemCount: Con_List.PresentAttandance.length,
          itemBuilder: (context, index) {
            String formattedTime = "";
            if (Con_List.PresentAttandance[index]['timeIn'] != null) {
              String timeim =
                  Con_List.PresentAttandance[index]['timeIn'].toString();
              DateTime t = DateTime.parse(timeim).toLocal();
              String formattedDateTime =
                  DateFormat('yyyy-MM-dd hh:mm:ss a').format(t);
              DateTime dateTime =
                  DateFormat('yyyy-MM-dd hh:mm:ss a').parse(formattedDateTime);
              formattedTime = DateFormat('hh:mm a').format(dateTime);
            }
            return CupertinoListTile(
              leading: CircleAvatar(
                backgroundColor: Colorr.themcolor,
              ),
              title: Text(
                Con_List.PresentAttandance[index]['employeeId']['FirstName']
                    .toString(),
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontSize: width * 0.04,
                ),
              ),
              subtitle: Text(
                "In Time $formattedTime",
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontSize: width * 0.03,
                ),
              ),
            );
          },
        ),
      ),
      Container(
        child: ListView.builder(
          itemCount: Con_List.LatAttandance.length,
          itemBuilder: (context, index) {
            String formattedTime = "";
            if (Con_List.LatAttandance[index]['timeIn'] != null) {
              String timeim =
                  Con_List.LatAttandance[index]['timeIn'].toString();
              DateTime t = DateTime.parse(timeim).toLocal();
              String formattedDateTime =
                  DateFormat('yyyy-MM-dd hh:mm:ss a').format(t);
              DateTime dateTime =
                  DateFormat('yyyy-MM-dd hh:mm:ss a').parse(formattedDateTime);
              formattedTime = DateFormat('hh:mm a').format(dateTime);
            }
            return CupertinoListTile(
              leading: CircleAvatar(
                backgroundColor: Colorr.themcolor,
              ),
              title: Text(
                Con_List.LatAttandance[index]['employeeId']['FirstName']
                    .toString(),
              ),
              subtitle: Text("In Time $formattedTime"),
            );
          },
        ),
      ),
      Container(
        child: ListView.builder(
          itemCount: Con_List.EarlyOutAttandance.length,
          itemBuilder: (context, index) {
            String formattedTime = "";
            if (Con_List.EarlyOutAttandance[index]['timeOut'] != null) {
              String timeim =
                  Con_List.EarlyOutAttandance[index]['timeOut'].toString();
              DateTime t = DateTime.parse(timeim).toLocal();
              String formattedDateTime =
                  DateFormat('yyyy-MM-dd hh:mm:ss a').format(t);
              DateTime dateTime =
                  DateFormat('yyyy-MM-dd hh:mm:ss a').parse(formattedDateTime);
              formattedTime = DateFormat('hh:mm a').format(dateTime);
            }
            return CupertinoListTile(
              leading: CircleAvatar(
                backgroundColor: Colorr.themcolor,
              ),
              title: Text(
                Con_List.EarlyOutAttandance[index]['employeeId']['FirstName']
                    .toString(),
              ),
              subtitle: Text("In Time $formattedTime"),
            );
          },
        ),
      ),
      Container(
        child: ListView.builder(
          itemCount: Con_List.AbsentAttandance.length,
          itemBuilder: (context, index) {
            String Designation = "";
            if (Con_List.AbsentAttandance[index]['designationId'] != null) {
              Designation = Con_List.DesignationSelect.firstWhere(
                      (element) =>
                          element['_id'] ==
                          Con_List.AbsentAttandance[index]['designationId']
                              .toString(),
                      orElse: () => {'name': ''})['name']
                  .toString();
            }
            return CupertinoListTile(
              leading: CircleAvatar(
                backgroundColor: Colorr.themcolor,
              ),
              title: Text(
                Con_List.AbsentAttandance[index]['FirstName'].toString(),
              ),
              subtitle: Text(Designation),
            );
          },
        ),
      ),
    ];

    return Constants_Usermast.IOS == true
        ? WillPopScope(
            onWillPop: () => onBackPress(),
            child: CupertinoPageScaffold(
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
                      "Admin",
                      style: TextStyle(color: Colorr.White),
                    )),
                child: Container(
                  height: height,
                  width: width,
                  padding: EdgeInsets.all(10),
                  color: Colorr.Backgroundd,
                  child: SingleChildScrollView(
                    child: Column(children: [
                      Row(
                        children: [
                          CustomWidgets.confirmButton1(
                            textsize: height * 0.02,
                            onTap: () {
                              Navigator.push(context, CupertinoPageRoute(
                                builder: (context) {
                                  return AllEmployees();
                                },
                              ));
                            },
                            height: height / 20,
                            width: width / 2.7,
                            text: "${Con_List.AllEmployee.length} Employee",
                          ),
                          CustomWidgets.width(width / 35),
                          CustomWidgets.confirmButton1(
                            textsize: height * 0.02,
                            onTap: () {
                              getdata();
                              getdata();
                              employeeName.text = "";
                              dropdownValue.text = "";
                              dropdownValue1.text = "";
                              Search.text = "";
                              _selectedIndex = 0;
                              _selectedIndex1 = 0;
                              dataMap = {
                                "${Con_List.PresentAttandance.length} Present":
                                    Con_List.PresentAttandance.length
                                        .toDouble(),
                                "${Con_List.LatAttandance.length} Late":
                                    Con_List.LatAttandance.length.toDouble(),
                                "${Con_List.EarlyOutAttandance.length} Early Out":
                                    Con_List.EarlyOutAttandance.length
                                        .toDouble(),
                                "${Con_List.AbsentAttandance.length} Absent":
                                    Con_List.AbsentAttandance.length.toDouble()
                              };
                              totalEm = Con_List.AllEmployee.length;
                              setState(() {});
                            },
                            height: height / 20,
                            width: width / 3.0,
                            text: "Refresh",
                          ),
                        ],
                      ),
                      CustomWidgets.height(height / 35),
                      Container(
                        height: height / 2.5,
                        width: width,
                        decoration: BoxDecoration(
                          color: CupertinoColors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomWidgets.textFieldIOS(
                              hintText: "Select Employee",
                              controller: employeeName,
                              readOnly: true,
                              onTap: () {
                                CustomWidgets.SelectDroupDown(
                                    context: context,
                                    items: Employee,
                                    onSelectedItemChanged: (int) {
                                      employeeName.text = Employee[int];
                                      setState(() {});
                                    });
                              },
                              suffix: CustomWidgets.aarowCupertinobutton(),
                            ),
                            Row(
                              children: [
                                CustomWidgets.width(width / 25),
                                Image.asset(
                                  "images/checking-attendance.webp",
                                  height: height / 22,
                                  width: width / 17,
                                ),
                                CustomWidgets.width(width / 45),
                                Text(
                                  "Employees Status",
                                  style: TextStyle(
                                    color: Colorr.themcolor,
                                    fontSize: width * 0.045,
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  width: width / 3,
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
                                              EmployeeStatusData =
                                                  await Attendance_api
                                                      .AttendanceSelect();
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
                                                        title: const Text(
                                                          "Select Custom Date",
                                                          style: TextStyle(
                                                              fontSize: 14),
                                                        ),
                                                        content: Container(
                                                          height: height / 2.5,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              CustomWidgets
                                                                  .height(10),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  CustomWidgets
                                                                      .confirmButton1(
                                                                          onTap:
                                                                              () {
                                                                            setState1(() {
                                                                              Startdate.text = "";
                                                                              Enddate.text = "";
                                                                              Singleday.text = "";
                                                                              DateRange = true;
                                                                            });
                                                                          },
                                                                          height: height /
                                                                              20,
                                                                          Clr: DateRange
                                                                              ? Colorr
                                                                                  .themcolor
                                                                              : Colorr
                                                                                  .Grey400,
                                                                          width: width /
                                                                              3.6,
                                                                          text:
                                                                              "Date Range",
                                                                          textsize:
                                                                              13),
                                                                  CustomWidgets
                                                                      .width(
                                                                          10),
                                                                  CustomWidgets
                                                                      .confirmButton1(
                                                                          onTap:
                                                                              () {
                                                                            setState1(() {
                                                                              Startdate.text = "";
                                                                              Enddate.text = "";
                                                                              Singleday.text = "";
                                                                              DateRange = false;
                                                                            });
                                                                          },
                                                                          height: height /
                                                                              20,
                                                                          width: width /
                                                                              3.6,
                                                                          Clr: DateRange
                                                                              ? Colorr
                                                                                  .Grey400
                                                                              : Colorr
                                                                                  .themcolor,
                                                                          text:
                                                                              "Single Day",
                                                                          textsize:
                                                                              13),
                                                                ],
                                                              ),
                                                              CustomWidgets
                                                                  .height(10),
                                                              if (DateRange ==
                                                                  true)
                                                                CustomWidgets.textFieldIOS(
                                                                    hintText:
                                                                        "Start Date",
                                                                    readOnly:
                                                                        true,
                                                                    controller:
                                                                        Startdate,
                                                                    suffix: GestureDetector(
                                                                        onTap: () => _selectDateIOS(
                                                                            context,
                                                                            Startdate),
                                                                        child: CustomWidgets
                                                                            .DateIconIOS())),
                                                              if (DateRange ==
                                                                  true)
                                                                CustomWidgets.textFieldIOS(
                                                                    hintText:
                                                                        "End Date",
                                                                    readOnly:
                                                                        true,
                                                                    controller:
                                                                        Enddate,
                                                                    suffix: GestureDetector(
                                                                        onTap: () => _selectDateIOS1(
                                                                            context,
                                                                            Enddate),
                                                                        child: CustomWidgets
                                                                            .DateIconIOS())),
                                                              if (DateRange ==
                                                                  false)
                                                                CustomWidgets.textFieldIOS(
                                                                    hintText:
                                                                        "Select Date",
                                                                    readOnly:
                                                                        true,
                                                                    controller:
                                                                        Singleday,
                                                                    suffix: GestureDetector(
                                                                        onTap: () => CustomWidgets.selectDateIOS(
                                                                            Future:
                                                                                true,
                                                                            context:
                                                                                context,
                                                                            controller:
                                                                                Singleday),
                                                                        child: CustomWidgets
                                                                            .DateIconIOS())),
                                                              Spacer(),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  CustomWidgets
                                                                      .confirmButton(
                                                                          onTap:
                                                                              () {
                                                                            Startdate.text =
                                                                                "";
                                                                            Enddate.text =
                                                                                "";
                                                                            Singleday.text =
                                                                                "";
                                                                            Navigator.pop(context);
                                                                            setState1(() {});
                                                                          },
                                                                          height: height /
                                                                              20,
                                                                          width: width /
                                                                              3.5,
                                                                          text:
                                                                              "Cancel"),
                                                                  CustomWidgets
                                                                      .confirmButton(
                                                                          onTap:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                            setState1(() {});
                                                                          },
                                                                          height: height /
                                                                              20,
                                                                          width: width /
                                                                              3.5,
                                                                          text:
                                                                              "Done"),
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
                                        CustomWidgets.aarowCupertinobutton(),
                                  ),
                                ),
                                CustomWidgets.width(0.04),
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
                                        fontSize: 15, color: Colorr.themcolor),
                                    animationDuration:
                                        Duration(milliseconds: 800),
                                    chartLegendSpacing: 32,
                                    chartRadius:
                                        MediaQuery.of(context).size.width / 1.5,
                                    colorList: [
                                      Colors.green,
                                      Colors.blue,
                                      Colors.yellow,
                                      Colors.red
                                    ],
                                    initialAngleInDegree: 0,
                                    chartType: ChartType.ring,
                                    ringStrokeWidth: 15,
                                    legendOptions: LegendOptions(
                                      showLegendsInRow: false,
                                      legendPosition: LegendPosition.right,
                                      showLegends: true,
                                      legendShape: BoxShape.circle,
                                      legendTextStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
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
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: height / 2.8,
                        width: width,
                        margin: EdgeInsets.only(top: 10, bottom: 10),
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: CupertinoColors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: height * 0.01),
                            Row(
                              children: [
                                SizedBox(width: width / 25),
                                Image.asset(
                                  "images/networking-1.webp",
                                  height: height / 22,
                                  width: width / 17,
                                ),
                                SizedBox(width: width / 45),
                                Text(
                                  "All Department",
                                  style: TextStyle(
                                    color: Colorr.themcolor,
                                    fontSize: width * 0.045,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: height * 0.02),
                            Expanded(
                                child: Padding(
                              padding: EdgeInsets.only(left: 5, right: 5),
                              child: GridView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: Con_List.DeparmenntSelect.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisSpacing: 5,
                                        mainAxisSpacing: 5,
                                        crossAxisCount: 2,
                                        childAspectRatio: (1.0 / 1.7)),
                                itemBuilder: (context, index) {
                                  return Deparment(index);
                                },
                              ),
                            )),
                            CustomWidgets.height(10)
                          ],
                        ),
                      ),
                      Container(
                        height: height / 2.5,
                        width: width,
                        margin: EdgeInsets.only(top: 10, bottom: 10),
                        decoration: BoxDecoration(
                            color: Colorr.White,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: width / 3,
                                child: CustomWidgets.textFieldIOS(
                                  hintText: FilterList.first,
                                  controller: dropdownValue,
                                  readOnly: true,
                                  onTap: () {
                                    CustomWidgets.SelectDroupDown(
                                        context: context,
                                        items: FilterList,
                                        onSelectedItemChanged: (int) async {
                                          dropdownValue.text = FilterList[int];
                                          if (dropdownValue.text == "Today") {
                                            DateTime currentDate =
                                                DateTime.now();
                                            String formattedDate =
                                                DateFormat('yyyy-MM-dd')
                                                    .format(currentDate);
                                            EmployeeAttendance =
                                                await Attendance_api
                                                    .FilterApiSingalDate(
                                                        formattedDate);

                                            EmployeeBirthday =
                                                await Attendance_api
                                                    .FilterApiSingalDateBirth(
                                                        formattedDate);
                                            EmployeeAnni = await Attendance_api
                                                .FilterApiSingalDateAnny(
                                                    formattedDate);
                                            setState(() {});
                                          } else if (dropdownValue.text ==
                                              "Yesterday") {
                                            DateTime currentDate =
                                                DateTime.now();
                                            // Subtract one day from the current date
                                            DateTime yesterdayDate = currentDate
                                                .subtract(Duration(days: 1));
                                            // Format the date using the desired format
                                            String formattedDate =
                                                DateFormat('yyyy-MM-dd')
                                                    .format(yesterdayDate);
                                            EmployeeAttendance =
                                                await Attendance_api
                                                    .FilterApiSingalDate(
                                                        formattedDate);
                                            EmployeeBirthday =
                                                await Attendance_api
                                                    .FilterApiSingalDateBirth(
                                                        formattedDate);
                                            EmployeeAnni = await Attendance_api
                                                .FilterApiSingalDateAnny(
                                                    formattedDate);

                                            setState(() {});
                                          } else if (dropdownValue.text ==
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
                                                        height: height / 2.5,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            CustomWidgets
                                                                .height(10),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                CustomWidgets
                                                                    .confirmButton1(
                                                                        onTap:
                                                                            () {
                                                                          setState1(
                                                                              () {
                                                                            Startdate1.text =
                                                                                "";
                                                                            Enddate1.text =
                                                                                "";
                                                                            Singleday1.text =
                                                                                "";
                                                                            DateRange =
                                                                                true;
                                                                          });
                                                                        },
                                                                        height:
                                                                            height /
                                                                                20,
                                                                        Clr: DateRange
                                                                            ? Colorr
                                                                                .themcolor
                                                                            : Colorr
                                                                                .Grey400,
                                                                        width: width /
                                                                            3.6,
                                                                        text:
                                                                            "Date Range",
                                                                        textsize:
                                                                            13),
                                                                CustomWidgets
                                                                    .width(10),
                                                                CustomWidgets
                                                                    .confirmButton1(
                                                                        onTap:
                                                                            () {
                                                                          setState1(
                                                                              () {
                                                                            Startdate1.text =
                                                                                "";
                                                                            Enddate1.text =
                                                                                "";
                                                                            Singleday1.text =
                                                                                "";
                                                                            DateRange =
                                                                                false;
                                                                          });
                                                                        },
                                                                        height:
                                                                            height /
                                                                                20,
                                                                        width: width /
                                                                            3.6,
                                                                        Clr: DateRange
                                                                            ? Colorr
                                                                                .Grey400
                                                                            : Colorr
                                                                                .themcolor,
                                                                        text:
                                                                            "Single Day",
                                                                        textsize:
                                                                            13),
                                                              ],
                                                            ),
                                                            CustomWidgets
                                                                .height(10),
                                                            if (DateRange ==
                                                                true)
                                                              CustomWidgets.textFieldIOS(
                                                                  hintText:
                                                                      "Start Date",
                                                                  readOnly:
                                                                      true,
                                                                  controller:
                                                                      Startdate1,
                                                                  suffix: GestureDetector(
                                                                      onTap: () => _selectDateIOS(
                                                                          context,
                                                                          Startdate1),
                                                                      child: CustomWidgets
                                                                          .DateIconIOS())),
                                                            if (DateRange ==
                                                                true)
                                                              CustomWidgets.textFieldIOS(
                                                                  hintText:
                                                                      "End Date",
                                                                  readOnly:
                                                                      true,
                                                                  controller:
                                                                      Enddate1,
                                                                  suffix: GestureDetector(
                                                                      onTap: () => _selectDateIOS1(
                                                                          context,
                                                                          Enddate1),
                                                                      child: CustomWidgets
                                                                          .DateIconIOS())),
                                                            if (DateRange == false)
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
                                                                CustomWidgets
                                                                    .confirmButton(
                                                                        onTap:
                                                                            () {
                                                                          Startdate.text =
                                                                              "";
                                                                          Enddate.text =
                                                                              "";
                                                                          Singleday.text =
                                                                              "";
                                                                          Navigator.pop(
                                                                              context);
                                                                          setState1(
                                                                              () {});
                                                                        },
                                                                        height:
                                                                            height /
                                                                                20,
                                                                        width: width /
                                                                            3.5,
                                                                        text:
                                                                            "Cancel"),
                                                                CustomWidgets
                                                                    .confirmButton(
                                                                        onTap:
                                                                            () async {
                                                                          if (DateRange) {
                                                                            EmployeeAttendance =
                                                                                await Attendance_api.FilterApiToDate(CustomWidgets.DateFormatchangeapi(Startdate1.text), CustomWidgets.DateFormatchangeapi(Enddate1.text));
                                                                            EmployeeBirthday =
                                                                                await Attendance_api.FilterApiToDateBirth(CustomWidgets.DateFormatchangeapi(Startdate1.text), CustomWidgets.DateFormatchangeapi(Enddate1.text));
                                                                            EmployeeAnni =
                                                                                await Attendance_api.FilterApiToDateAnny(CustomWidgets.DateFormatchangeapi(Startdate1.text), CustomWidgets.DateFormatchangeapi(Enddate1.text));
                                                                            setState(() {});
                                                                          } else {
                                                                            EmployeeAttendance =
                                                                                await Attendance_api.FilterApiSingalDate(CustomWidgets.DateFormatchangeapi(Singleday1.text));
                                                                            EmployeeBirthday =
                                                                                await Attendance_api.FilterApiSingalDateBirth(CustomWidgets.DateFormatchangeapi(Singleday1.text));
                                                                            EmployeeAnni =
                                                                                await Attendance_api.FilterApiSingalDateAnny(CustomWidgets.DateFormatchangeapi(Singleday1.text));
                                                                            setState(() {});
                                                                          }
                                                                          DateRange =
                                                                              true;
                                                                          setState1(
                                                                              () {});
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        height:
                                                                            height /
                                                                                20,
                                                                        width: width /
                                                                            3.5,
                                                                        text:
                                                                            "Done"),
                                                              ],
                                                            ),
                                                            CustomWidgets
                                                                .height(
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
                                          setState(() {});
                                        });
                                  },
                                  suffix: CustomWidgets.aarowCupertinobutton(),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 50,
                            child: CupertinoTabScaffold(
                              tabBar: CupertinoTabBar(
                                backgroundColor: CupertinoColors.systemGrey6,
                                activeColor: Colorr.IconColor,
                                items: [
                                  BottomNavigationBarItem(
                                    icon: Image.asset(
                                      "images/calendar.webp",
                                      height: height / 31,
                                      width: width / 23,
                                    ),
                                    label: "Attendance",
                                  ),
                                  BottomNavigationBarItem(
                                    icon: Image.asset(
                                      "images/Cake.webp",
                                      height: height / 31,
                                      width: width / 23,
                                    ),
                                    label: "Birthday",
                                  ),
                                  BottomNavigationBarItem(
                                    icon: Image.asset(
                                      "images/celebration.webp",
                                      height: height / 31,
                                      width: width / 23,
                                    ),
                                    label: "Anniversary",
                                  ),
                                ],
                                currentIndex: _selectedIndex,
                                onTap: (index) {
                                  setState(() {
                                    _selectedIndex = index;
                                  });
                                },
                              ),
                              tabBuilder: (BuildContext context, int index) {
                                return Container();
                              },
                            ),
                          ),
                          Expanded(child: tabs[_selectedIndex])
                        ]),
                      ),
                      Container(
                        height: height / 2.5,
                        width: width,
                        margin: EdgeInsets.only(top: 10, bottom: 10),
                        decoration: BoxDecoration(
                            color: Colorr.White,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: height / 15,
                                width: width / 3,
                                margin: EdgeInsets.only(top: 5),
                                child: CustomWidgets.textFieldIOS(
                                    suffix: GestureDetector(
                                      child: Icon(
                                        CupertinoIcons.search,
                                        color: Colorr.themcolor,
                                      ),
                                    ),
                                    hintText: "Search",
                                    controller: Search),
                              ),
                            ],
                          ),
                          Container(
                            height: 30,
                            child: CupertinoTabScaffold(
                              tabBar: CupertinoTabBar(
                                backgroundColor: CupertinoColors.systemGrey6,
                                activeColor: Colorr.IconColor,
                                items: [
                                  BottomNavigationBarItem(
                                    label: "Present",
                                    icon: Container(),
                                  ),
                                  BottomNavigationBarItem(
                                    icon: Container(),
                                    label: "Late In",
                                  ),
                                  BottomNavigationBarItem(
                                    icon: Container(),
                                    label: "Early Out",
                                  ),
                                  BottomNavigationBarItem(
                                    icon: Container(),
                                    label: "Absent",
                                  ),
                                ],
                                currentIndex: _selectedIndex1,
                                onTap: (index) {
                                  setState(() {
                                    _selectedIndex1 = index;
                                  });
                                },
                              ),
                              tabBuilder: (BuildContext context, int index) {
                                return Container();
                              },
                            ),
                          ),
                          Expanded(child: tabs1[_selectedIndex1])
                        ]),
                      )
                    ]),
                  ),
                )))
        : WillPopScope(
            onWillPop: () => onBackPress(),
            child: Scaffold(
                appBar: CustomWidgets.appbar(
                  title: "Admin Dashboard",
                  action: [],
                  context: context,
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) {
                        return Dashboard();
                      },
                    ));
                  },
                ),
                body: mainwidget()));
  }

  Widget mainwidget() {
    if (internetConn == 1) {
      return Container(
          height: height,
          width: width,
          padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
          color: Colorr.Backgroundd,
          child: Theme(
              data: ThemeData(
                highlightColor: Colorr.themcolor, //Does not work
              ),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  Row(
                    children: [
                      CustomWidgets.confirmButton1(
                          textsize: height * 0.02,
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return AllEmployees();
                              },
                            ));
                          },
                          height: height / 20,
                          width: width / 2.7,
                          text: "${Con_List.AllEmployee.length}  Employee"),
                      CustomWidgets.width(width / 35),
                      CustomWidgets.confirmButton1(
                          textsize: height * 0.02,
                          onTap: () async {
                            getdata();
                            employeeName.text = "";
                            dropdownValue.text = "";
                            dropdownValue1.text = "";
                            Search.text = "";
                            _tabController.index = 0;
                            _tabController1.index = 0;
                            dataMap = {
                              "${Con_List.PresentAttandance.length} Present":
                                  Con_List.PresentAttandance.length.toDouble(),
                              "${Con_List.LatAttandance.length} Late":
                                  Con_List.LatAttandance.length.toDouble(),
                              "${Con_List.EarlyOutAttandance.length} Early Out":
                                  Con_List.EarlyOutAttandance.length.toDouble(),
                              "${Con_List.AbsentAttandance.length} Absent":
                                  Con_List.AbsentAttandance.length.toDouble()
                            };
                            setState(() {});
                          },
                          height: height / 20,
                          width: width / 3.0,
                          text: "Refresh"),
                    ],
                  ),
                  CustomWidgets.height(height / 55),
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Container(
                      height: height / 2.49,
                      width: width,
                      decoration: BoxDecoration(
                          color: Colorr.White,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomDropdown.search(
                              // borderRadius: BorderRadius.circular(30),
                              excludeSelected: false,
                              onChanged: (p0) {
                                setState(() {
                                  List<dynamic> temp_present =
                                      Con_List.PresentAttandance.where((e) =>
                                          e['employeeData'][0]['FirstName']
                                              .toString() ==
                                          p0.toString()).toList();
                                  List<dynamic> temp_Late =
                                      Con_List.LatAttandance.where((e) =>
                                          e['employeeData'][0]['FirstName']
                                              .toString() ==
                                          p0.toString()).toList();
                                  List<dynamic> temp_EarlyOut =
                                      Con_List.EarlyOutAttandance.where((e) =>
                                          e['employeeData'][0]['FirstName']
                                              .toString() ==
                                          p0.toString()).toList();
                                  List<dynamic> temp_Absent =
                                      Con_List.AbsentAttandance.where((e) =>
                                          e['FirstName'].toString() ==
                                          p0.toString()).toList();
                                  dataMap = {
                                    "${temp_present.length} Present":
                                        temp_present.length.toDouble(),
                                    "${temp_Late.length} Late":
                                        temp_Late.length.toDouble(),
                                    "${temp_EarlyOut.length} Early Out":
                                        temp_EarlyOut.length.toDouble(),
                                    "${temp_Absent.length} Absent":
                                        temp_Absent.length.toDouble()
                                  };
                                });
                              },
                              listItemStyle: CustomWidgets.style(),
                              hintText: 'Select Employee',
                              controller: employeeName,
                              items: Employee,
                            ),
                            Row(
                              children: [
                                CustomWidgets.width(width / 25),
                                Image.asset(
                                  "images/checking-attendance.webp",
                                  height: height / 25,
                                  width: width / 20,
                                ),
                                CustomWidgets.width(width / 45),
                                Text("Employees Status",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontFamily: 'Poppins',
                                        color: Colorr.FontColor,
                                        fontSize: width * 0.042)),
                                Spacer(),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height / 20,
                                  width: MediaQuery.of(context).size.width / 3,
                                  margin: EdgeInsets.only(
                                    right: MediaQuery.of(context).size.width *
                                        0.01,
                                    top: MediaQuery.of(context).size.width *
                                        0.02,
                                    bottom: MediaQuery.of(context).size.width *
                                        0.02,
                                  ),
                                  child: CustomDropdown(
                                    excludeSelected: false,
                                    hintStyle: TextStyle(fontSize: 12),
                                    selectedStyle: TextStyle(
                                        fontSize: 12, color: Colorr.themcolor),
                                    listItemStyle: TextStyle(fontSize: 12),
                                    hintText: FilterList.first,
                                    controller: dropdownValue1,
                                    items: FilterList,
                                    onChanged: (value) async {
                                      if (value == "Today") {
                                        List<dynamic> jsonData =
                                            await Attendance_api
                                                .FilterApiSingalDate1(
                                                    DateTime.now()
                                                        .toString()
                                                        .substring(0, 10));

                                        List<dynamic> temp_present = [];
                                        List<dynamic> temp_Late = [];
                                        List<dynamic> temp_EarlyOut = [];
                                        List<dynamic> temp_Absent = [];
                                        for (var item in jsonData) {
                                          if (item.containsKey('timeIn')) {
                                            temp_present.add(item);
                                          } else {
                                            temp_Absent.add(item);
                                          }
                                        }
                                        if (employeeName.text != "") {
                                          temp_present = temp_present
                                              .where((element) =>
                                                  element['employeeId']
                                                          ['FirstName']
                                                      .toString() ==
                                                  employeeName.text)
                                              .toList();
                                          temp_Absent = temp_Absent
                                              .where((element) =>
                                                  element['FirstName']
                                                      .toString() ==
                                                  employeeName.text)
                                              .toList();
                                        }

                                        dataMap = {
                                          "${temp_present.length} Present":
                                              temp_present.length.toDouble(),
                                          "${temp_Late.length} Late":
                                              temp_Late.length.toDouble(),
                                          "${temp_EarlyOut.length} Early Out":
                                              temp_EarlyOut.length.toDouble(),
                                          "${temp_Absent.length} Absent":
                                              temp_Absent.length.toDouble()
                                        };
                                        setState(() {});
                                      } else if (value == "Yesterday") {
                                        var Yester = DateTime.now()
                                            .subtract(Duration(days: 1))
                                            .toString()
                                            .substring(0, 10);
                                        List<dynamic> jsonData =
                                            await Attendance_api
                                                .FilterApiSingalDate1(Yester);

                                        List<dynamic> temp_present = [];
                                        List<dynamic> temp_Late = [];
                                        List<dynamic> temp_EarlyOut = [];
                                        List<dynamic> temp_Absent = [];
                                        for (var item in jsonData) {
                                          if (item.containsKey('timeIn')) {
                                            temp_present.add(item);
                                          } else {
                                            temp_Absent.add(item);
                                          }
                                        }
                                        if (employeeName.text != "") {
                                          temp_present = temp_present
                                              .where((element) =>
                                                  element['employeeId']
                                                          ['FirstName']
                                                      .toString() ==
                                                  employeeName.text)
                                              .toList();
                                          temp_Absent = temp_Absent
                                              .where((element) =>
                                                  element['FirstName']
                                                      .toString() ==
                                                  employeeName.text)
                                              .toList();
                                        }

                                        dataMap = {
                                          "${temp_present.length} Present":
                                              temp_present.length.toDouble(),
                                          "${temp_Late.length} Late":
                                              temp_Late.length.toDouble(),
                                          "${temp_EarlyOut.length} Early Out":
                                              temp_EarlyOut.length.toDouble(),
                                          "${temp_Absent.length} Absent":
                                              temp_Absent.length.toDouble()
                                        };
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
                                                          title: const Text(
                                                              "Select Custom Date",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      14)),
                                                          actions: [
                                                            IconButton(
                                                                splashRadius:
                                                                    18,
                                                                onPressed: () {
                                                                  DateRange =
                                                                      true;
                                                                  Startdate
                                                                      .text = "";
                                                                  Enddate.text =
                                                                      "";
                                                                  Singleday
                                                                      .text = "";
                                                                  Navigator.pop(
                                                                      context);
                                                                  setState1(
                                                                      () {});
                                                                },
                                                                icon: const Icon(
                                                                    Icons
                                                                        .close))
                                                          ],
                                                        ),
                                                        CustomWidgets.height(
                                                            10),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            CustomWidgets
                                                                .confirmButton1(
                                                                    onTap: () {
                                                                      setState1(
                                                                          () {
                                                                        Startdate.text =
                                                                            "";
                                                                        Enddate.text =
                                                                            "";
                                                                        Singleday.text =
                                                                            "";
                                                                        DateRange =
                                                                            true;
                                                                      });
                                                                    },
                                                                    height:
                                                                        height /
                                                                            20,
                                                                    Clr: DateRange
                                                                        ? Colorr
                                                                            .themcolor
                                                                        : Colorr
                                                                            .Grey400,
                                                                    width:
                                                                        width /
                                                                            3,
                                                                    text:
                                                                        "Date Range",
                                                                    textsize:
                                                                        13),
                                                            CustomWidgets.width(
                                                                10),
                                                            CustomWidgets
                                                                .confirmButton1(
                                                                    onTap: () {
                                                                      setState1(
                                                                          () {
                                                                        Startdate.text =
                                                                            "";
                                                                        Enddate.text =
                                                                            "";
                                                                        Singleday.text =
                                                                            "";
                                                                        DateRange =
                                                                            false;
                                                                      });
                                                                    },
                                                                    height:
                                                                        height /
                                                                            20,
                                                                    width:
                                                                        width /
                                                                            3,
                                                                    Clr: DateRange
                                                                        ? Colorr
                                                                            .Grey400
                                                                        : Colorr
                                                                            .themcolor,
                                                                    text:
                                                                        "Single Day",
                                                                    textsize:
                                                                        13),
                                                          ],
                                                        ),
                                                        CustomWidgets.height(
                                                            10),
                                                        if (DateRange == true)
                                                          CustomWidgets.textField(
                                                              hintText:
                                                                  "Start Date",
                                                              readOnly: true,
                                                              controller:
                                                                  Startdate,
                                                              suffixIcon: InkWell(
                                                                  onTap: () =>
                                                                      _selectDate(
                                                                          context,
                                                                          Startdate),
                                                                  child: CustomWidgets
                                                                      .DateIcon())),
                                                        if (DateRange == true)
                                                          CustomWidgets.textField(
                                                              hintText:
                                                                  "End Date",
                                                              readOnly: true,
                                                              controller:
                                                                  Enddate,
                                                              suffixIcon: InkWell(
                                                                  onTap: () =>
                                                                      _selectDate1(
                                                                          context,
                                                                          Enddate),
                                                                  child: CustomWidgets
                                                                      .DateIcon())),
                                                        if (DateRange == false)
                                                          CustomWidgets.textField(
                                                              hintText:
                                                                  "Select Date",
                                                              readOnly: true,
                                                              controller:
                                                                  Singleday,
                                                              suffixIcon: InkWell(
                                                                  onTap: () => CustomWidgets.selectDate(
                                                                      Future:
                                                                          true,
                                                                      context:
                                                                          context,
                                                                      controller:
                                                                          Singleday),
                                                                  child: CustomWidgets
                                                                      .DateIcon())),
                                                        Spacer(),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            CustomWidgets
                                                                .confirmButton(
                                                                    onTap: () {
                                                                      Startdate
                                                                          .text = "";
                                                                      Enddate.text =
                                                                          "";
                                                                      Singleday
                                                                          .text = "";
                                                                      Navigator.pop(
                                                                          context);
                                                                      setState1(
                                                                          () {});
                                                                    },
                                                                    height:
                                                                        height /
                                                                            20,
                                                                    width:
                                                                        width /
                                                                            3,
                                                                    text:
                                                                        "Cancel"),
                                                            CustomWidgets
                                                                .confirmButton(
                                                                    onTap:
                                                                        () async {
                                                                      if (DateRange) {
                                                                        List<dynamic>
                                                                            jsonData =
                                                                            await Attendance_api.FilterApiToDate(CustomWidgets.DateFormatchangeapi(Startdate.text),
                                                                                CustomWidgets.DateFormatchangeapi(Enddate.text));
                                                                        List<dynamic>
                                                                            temp_present =
                                                                            [];
                                                                        List<dynamic>
                                                                            temp_Late =
                                                                            [];
                                                                        List<dynamic>
                                                                            temp_EarlyOut =
                                                                            [];
                                                                        List<dynamic>
                                                                            temp_Absent =
                                                                            [];
                                                                        for (var item
                                                                            in jsonData) {
                                                                          if (item
                                                                              .containsKey('timeIn')) {
                                                                            temp_present.add(item);
                                                                          } else {
                                                                            temp_Absent.add(item);
                                                                          }
                                                                        }
                                                                        if (employeeName.text !=
                                                                            "") {
                                                                          temp_present = temp_present
                                                                              .where((element) => element['employeeId']['FirstName'].toString() == employeeName.text)
                                                                              .toList();
                                                                          temp_Absent = temp_Absent
                                                                              .where((element) => element['FirstName'].toString() == employeeName.text)
                                                                              .toList();
                                                                        }

                                                                        dataMap =
                                                                            {
                                                                          "${temp_present.length} Present": temp_present
                                                                              .length
                                                                              .toDouble(),
                                                                          "${temp_Late.length} Late": temp_Late
                                                                              .length
                                                                              .toDouble(),
                                                                          "${temp_EarlyOut.length} Early Out": temp_EarlyOut
                                                                              .length
                                                                              .toDouble(),
                                                                          "${temp_Absent.length} Absent": temp_Absent
                                                                              .length
                                                                              .toDouble()
                                                                        };
                                                                        setState(
                                                                            () {});
                                                                        Navigator.pop(
                                                                            context);
                                                                      } else {
                                                                        var
                                                                            jsonData =
                                                                            await Attendance_api.FilterApiSingalDate1(Singleday.text);

                                                                        List<dynamic>
                                                                            temp_present =
                                                                            [];
                                                                        List<dynamic>
                                                                            temp_Late =
                                                                            [];
                                                                        List<dynamic>
                                                                            temp_EarlyOut =
                                                                            [];
                                                                        List<dynamic>
                                                                            temp_Absent =
                                                                            [];
                                                                        for (var item
                                                                            in jsonData) {
                                                                          if (item
                                                                              .containsKey('timeIn')) {
                                                                            temp_present.add(item);
                                                                          } else {
                                                                            temp_Absent.add(item);
                                                                          }
                                                                        }
                                                                        if (employeeName.text !=
                                                                            "") {
                                                                          temp_present = temp_present
                                                                              .where((element) => element['employeeId']['FirstName'].toString() == employeeName.text)
                                                                              .toList();
                                                                          temp_Absent = temp_Absent
                                                                              .where((element) => element['FirstName'].toString() == employeeName.text)
                                                                              .toList();
                                                                        }

                                                                        dataMap =
                                                                            {
                                                                          "${temp_present.length} Present": temp_present
                                                                              .length
                                                                              .toDouble(),
                                                                          "${temp_Late.length} Late": temp_Late
                                                                              .length
                                                                              .toDouble(),
                                                                          "${temp_EarlyOut.length} Early Out": temp_EarlyOut
                                                                              .length
                                                                              .toDouble(),
                                                                          "${temp_Absent.length} Absent": temp_Absent
                                                                              .length
                                                                              .toDouble()
                                                                        };
                                                                        setState(
                                                                            () {});
                                                                        Navigator.pop(
                                                                            context);
                                                                      }
                                                                    },
                                                                    height:
                                                                        height /
                                                                            20,
                                                                    width:
                                                                        width /
                                                                            3,
                                                                    text:
                                                                        "Done"),
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
                                ),
                                CustomWidgets.width(0.04)
                              ],
                            ),
                            AspectRatio(
                              aspectRatio: 2,
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Stack(children: [
                                    PieChart(
                                      dataMap: dataMap,
                                      animationDuration:
                                          Duration(milliseconds: 800),
                                      chartLegendSpacing: height * 0.10,
                                      chartRadius:
                                          MediaQuery.of(context).size.width /
                                              1.5,
                                      colorList: [
                                        Colors.green,
                                        Colors.blue,
                                        Colors.yellow,
                                        Colors.red
                                      ],
                                      initialAngleInDegree: 0,
                                      chartType: ChartType.ring,
                                      ringStrokeWidth: 15,
                                      legendOptions: LegendOptions(
                                        legendLabels: {"Total": "12"},
                                        showLegendsInRow: false,
                                        legendPosition: LegendPosition.right,
                                        showLegends: true,
                                        legendShape: BoxShape.circle,
                                        legendTextStyle: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.normal,
                                            fontSize: width * 0.03),
                                      ),
                                      chartValuesOptions:
                                          const ChartValuesOptions(
                                        showChartValueBackground: true,
                                        showChartValues: false,
                                        showChartValuesInPercentage: false,
                                        showChartValuesOutside: false,
                                        decimalPlaces: 1,
                                      ),
                                      // gradientList: ---To add gradient colors---
                                      // emptyColorGradient: ---Empty Color gradient---
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2),
                                      child: Text(
                                          "Total Employees :    ${Con_List.AllEmployee.length}",
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500)),
                                    )
                                  ]),
                                ),
                              ),
                            )
                          ]),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Container(
                      height: height / 2.8,
                      width: width,
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          color: Colorr.White,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomWidgets.height(height * 0.01),
                            Row(
                              children: [
                                CustomWidgets.width(width / 25),
                                Image.asset(
                                  "images/networking-1.webp",
                                  height: height / 22,
                                  width: width / 18,
                                ),
                                CustomWidgets.width(width / 38),
                                Text("All Department",
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: Colorr.FontColor,
                                        fontSize: width * 0.042)),
                              ],
                            ),
                            CustomWidgets.height(height * 0.02),
                            Expanded(
                                child: Padding(
                              padding: EdgeInsets.only(left: 5, right: 5),
                              child: GridView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: Con_List.DeparmenntSelect.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisSpacing: 5,
                                        mainAxisSpacing: 5,
                                        crossAxisCount: 2,
                                        childAspectRatio: (1.0 / 1.7)),
                                itemBuilder: (context, index) {
                                  return Deparment(index);
                                },
                              ),
                            )),
                            CustomWidgets.height(10)
                          ]),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Container(
                      height: height / 2.5,
                      width: width,
                      margin: EdgeInsets.only(top: 2, bottom: 10),
                      decoration: BoxDecoration(
                          color: Colorr.White,
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: width * 0.04),
                              child: Container(
                                height: MediaQuery.of(context).size.height / 20,
                                width: MediaQuery.of(context).size.width / 2.5,
                                margin: EdgeInsets.only(
                                  right:
                                      MediaQuery.of(context).size.width * 0.01,
                                  top: MediaQuery.of(context).size.width * 0.02,
                                  bottom:
                                      MediaQuery.of(context).size.width * 0.02,
                                ),
                                child: CustomDropdown(
                                  listItemStyle: TextStyle(fontSize: 12),
                                  hintStyle: TextStyle(fontSize: 12),
                                  selectedStyle: TextStyle(
                                      fontSize: 12, color: Colorr.themcolor),
                                  hintText: FilterList.first,
                                  controller: dropdownValue,
                                  excludeSelected: false,
                                  items: FilterList,
                                  onChanged: (value) async {
                                    if (value == "Today") {
                                      DateTime currentDate = DateTime.now();
                                      String formattedDate =
                                          DateFormat('yyyy-MM-dd')
                                              .format(currentDate);
                                      EmployeeAttendance = await Attendance_api
                                          .FilterApiSingalDate(formattedDate);
                                      EmployeeBirthday = await Attendance_api
                                          .FilterApiSingalDateBirth(
                                              formattedDate);
                                      EmployeeAnni = await Attendance_api
                                          .FilterApiSingalDateAnny(
                                              formattedDate);
                                      setState(() {});
                                    } else if (value == "Yesterday") {
                                      DateTime currentDate = DateTime.now();
                                      // Subtract one day from the current date
                                      DateTime yesterdayDate = currentDate
                                          .subtract(Duration(days: 1));
                                      // Format the date using the desired format
                                      String formattedDate =
                                          DateFormat('yyyy-MM-dd')
                                              .format(yesterdayDate);
                                      EmployeeAttendance = await Attendance_api
                                          .FilterApiSingalDate(formattedDate);
                                      EmployeeBirthday = await Attendance_api
                                          .FilterApiSingalDateBirth(
                                              formattedDate);
                                      EmployeeAnni = await Attendance_api
                                          .FilterApiSingalDateAnny(
                                              formattedDate);

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
                                                                DateRange =
                                                                    true;
                                                                Startdate1
                                                                    .text = "";
                                                                Enddate1.text =
                                                                    "";
                                                                Singleday1
                                                                    .text = "";
                                                                setState1(
                                                                    () {});
                                                                Navigator.pop(
                                                                    context);
                                                                setState1(
                                                                    () {});
                                                              },
                                                              icon: Icon(
                                                                  Icons.close))
                                                        ],
                                                      ),
                                                      CustomWidgets.height(10),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          CustomWidgets
                                                              .confirmButton1(
                                                                  onTap: () {
                                                                    setState1(
                                                                        () {
                                                                      Startdate1
                                                                          .text = "";
                                                                      Enddate1.text =
                                                                          "";
                                                                      Singleday1
                                                                          .text = "";
                                                                      DateRange =
                                                                          true;
                                                                    });
                                                                  },
                                                                  height:
                                                                      height /
                                                                          20,
                                                                  Clr: DateRange
                                                                      ? Colorr
                                                                          .themcolor
                                                                      : Colorr
                                                                          .Grey400,
                                                                  width:
                                                                      width / 3,
                                                                  text:
                                                                      "Date Range",
                                                                  textsize: 13),
                                                          CustomWidgets.width(
                                                              10),
                                                          CustomWidgets
                                                              .confirmButton1(
                                                                  onTap: () {
                                                                    setState1(
                                                                        () {
                                                                      Startdate1
                                                                          .text = "";
                                                                      Enddate1.text =
                                                                          "";
                                                                      Singleday1
                                                                          .text = "";
                                                                      DateRange =
                                                                          false;
                                                                    });
                                                                  },
                                                                  height:
                                                                      height /
                                                                          20,
                                                                  width:
                                                                      width / 3,
                                                                  Clr: DateRange
                                                                      ? Colorr
                                                                          .Grey400
                                                                      : Colorr
                                                                          .themcolor,
                                                                  text:
                                                                      "Single Day",
                                                                  textsize: 13),
                                                        ],
                                                      ),
                                                      CustomWidgets.height(10),
                                                      if (DateRange == true)
                                                        CustomWidgets.textField(
                                                            hintText:
                                                                "Start Date",
                                                            readOnly: true,
                                                            controller:
                                                                Startdate1,
                                                            suffixIcon: InkWell(
                                                                onTap: () =>
                                                                    _selectDate(
                                                                        context,
                                                                        Startdate1),
                                                                child: CustomWidgets
                                                                    .DateIcon())),
                                                      if (DateRange == true)
                                                        CustomWidgets.textField(
                                                            hintText:
                                                                "End Date",
                                                            readOnly: true,
                                                            controller:
                                                                Enddate1,
                                                            suffixIcon: InkWell(
                                                                onTap: () =>
                                                                    _selectDate1(
                                                                        context,
                                                                        Enddate1),
                                                                child: CustomWidgets
                                                                    .DateIcon())),
                                                      if (DateRange == false)
                                                        CustomWidgets.textField(
                                                            hintText:
                                                                "Select Date",
                                                            readOnly: true,
                                                            controller:
                                                                Singleday1,
                                                            suffixIcon: InkWell(
                                                                onTap: () => CustomWidgets.selectDate(
                                                                    context:
                                                                        context,
                                                                    Future:
                                                                        true,
                                                                    controller:
                                                                        Singleday1),
                                                                child: CustomWidgets
                                                                    .DateIcon())),
                                                      Spacer(),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          CustomWidgets
                                                              .confirmButton(
                                                                  onTap: () {
                                                                    DateRange =
                                                                        true;
                                                                    Startdate1
                                                                        .text = "";
                                                                    Enddate1.text =
                                                                        "";
                                                                    Singleday1
                                                                        .text = "";
                                                                    setState1(
                                                                        () {});
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  height:
                                                                      height /
                                                                          20,
                                                                  width:
                                                                      width / 3,
                                                                  text:
                                                                      "Cancel"),
                                                          CustomWidgets
                                                              .confirmButton(
                                                                  onTap:
                                                                      () async {
                                                                    if (DateRange) {
                                                                      EmployeeAttendance = await Attendance_api.FilterApiToDate(
                                                                          CustomWidgets.DateFormatchangeapi(Startdate1
                                                                              .text),
                                                                          CustomWidgets.DateFormatchangeapi(
                                                                              Enddate1.text));
                                                                      EmployeeBirthday = await Attendance_api.FilterApiToDateBirth(
                                                                          CustomWidgets.DateFormatchangeapi(Startdate1
                                                                              .text),
                                                                          CustomWidgets.DateFormatchangeapi(
                                                                              Enddate1.text));
                                                                      EmployeeAnni = await Attendance_api.FilterApiToDateAnny(
                                                                          CustomWidgets.DateFormatchangeapi(Startdate1
                                                                              .text),
                                                                          CustomWidgets.DateFormatchangeapi(
                                                                              Enddate1.text));
                                                                      setState(
                                                                          () {});
                                                                    } else {
                                                                      EmployeeAttendance =
                                                                          await Attendance_api.FilterApiSingalDate(
                                                                              CustomWidgets.DateFormatchangeapi(Singleday1.text));
                                                                      EmployeeBirthday =
                                                                          await Attendance_api.FilterApiSingalDateBirth(
                                                                              CustomWidgets.DateFormatchangeapi(Singleday1.text));
                                                                      EmployeeAnni =
                                                                          await Attendance_api.FilterApiSingalDateAnny(
                                                                              CustomWidgets.DateFormatchangeapi(Singleday1.text));
                                                                      setState(
                                                                          () {});
                                                                    }
                                                                    DateRange =
                                                                        true;
                                                                    setState1(
                                                                        () {});
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  height:
                                                                      height /
                                                                          20,
                                                                  width:
                                                                      width / 3,
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
                              ),
                            )
                          ],
                        ),
                        TabBar(
                          indicatorColor: Colorr.IconColor,
                          controller: _tabController,
                          labelColor: Colorr.themcolor,
                          unselectedLabelColor: Colorr.IconColor,
                          indicatorPadding: EdgeInsets.only(
                              left: width * 0.03, right: width * 0.03),
                          tabs: [
                            Container(
                              width: width / 3,
                              child: Tab(
                                child: Row(
                                  children: [
                                    Image.asset(
                                      "images/calendar.webp",
                                      height: height / 31,
                                      width: width / 23,
                                    ),
                                    CustomWidgets.width(width * 0.01),
                                    Expanded(
                                      child: Text("Attendance",
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              overflow: TextOverflow.ellipsis,
                                              fontSize: width * 0.031)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: width / 3,
                              child: Tab(
                                child: Row(
                                  children: [
                                    Image.asset(
                                      "images/Cake.webp",
                                      height: height / 31,
                                      width: width / 23,
                                    ),
                                    CustomWidgets.width(width * 0.01),
                                    Expanded(
                                      child: Text("Birthday",
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              overflow: TextOverflow.ellipsis,
                                              fontSize: width * 0.031)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: width / 3,
                              child: Tab(
                                child: Row(
                                  children: [
                                    Image.asset(
                                      "images/celebration.webp",
                                      height: height / 31,
                                      width: width / 23,
                                    ),
                                    CustomWidgets.width(width * 0.01),
                                    Expanded(
                                      child: Text("Anniversary",
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              overflow: TextOverflow.ellipsis,
                                              fontSize: width * 0.031)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                            flex: 4,
                            child: TabBarView(
                                controller: _tabController,
                                children: [
                                  Container(
                                    child: SingleChildScrollView(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Theme(
                                          data: Theme.of(context).copyWith(
                                              dividerColor: Colors.transparent),
                                          child: DataTable(
                                              dividerThickness: 0,
                                              dataRowHeight: 30,
                                              columnSpacing: 30,
                                              columns: [
                                                DataColumn(
                                                  label: Text('No',
                                                      style: TextStyle(
                                                          fontFamily: 'Poppins',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          fontSize:
                                                              width * 0.035,
                                                          color: Colorr
                                                              .themcolor)),
                                                ),
                                                DataColumn(
                                                  label: Text('Name',
                                                      style: TextStyle(
                                                          fontFamily: 'Poppins',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          fontSize:
                                                              width * 0.035,
                                                          color: Colorr
                                                              .themcolor)),
                                                ),
                                                // DataColumn(
                                                //   label: Text('Date',
                                                //       style: TextStyle(
                                                //           fontFamily: 'Poppins',
                                                //           overflow: TextOverflow
                                                //               .ellipsis,
                                                //           fontSize:
                                                //               width * 0.035,
                                                //           color: Colorr
                                                //               .themcolor)),
                                                // ),
                                                DataColumn(
                                                  label: Text('Day',
                                                      style: TextStyle(
                                                          fontFamily: 'Poppins',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          fontSize:
                                                              width * 0.035,
                                                          color: Colorr
                                                              .themcolor)),
                                                ),
                                                DataColumn(
                                                  label: Text('Time In',
                                                      style: TextStyle(
                                                          fontFamily: 'Poppins',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          fontSize:
                                                              width * 0.035,
                                                          color: Colorr
                                                              .themcolor)),
                                                ),
                                                DataColumn(
                                                  label: Text('Time Out',
                                                      style: TextStyle(
                                                          fontFamily: 'Poppins',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          fontSize:
                                                              width * 0.035,
                                                          color: Colorr
                                                              .themcolor)),
                                                ),
                                              ],
                                              rows: EmployeeAttendance.asMap()
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
                                                  DateTime date =
                                                      DateTime.parse(timeim
                                                          .substring(0, 10));
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
                                                        fontFamily: 'Poppins',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        fontSize: width * 0.03,
                                                        color: Colorr
                                                            .themcolor300),
                                                  )),
                                                  DataCell(Text(
                                                    e.containsKey('FirstName')
                                                        ? e['FirstName']
                                                        :e.containsKey('employeeId')?e['employeeId']['FirstName']:e['employeeData'][0]['FirstName'].toString(),
                                                    style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        fontSize: width * 0.03,
                                                        color: Colorr
                                                            .themcolor300),
                                                  )),
                                                  // DataCell(Text(
                                                  //     CustomWidgets
                                                  //         .DateFormatchange(
                                                  //             e['createdAt']),
                                                  //     style: TextStyle(
                                                  //       fontFamily: 'Poppins',
                                                  //       color:
                                                  //           Colorr.themcolor300,
                                                  //       overflow: TextOverflow
                                                  //           .ellipsis,
                                                  //       fontSize: width * 0.03,
                                                  //     ))),
                                                  DataCell(Text(dayName,
                                                      style: TextStyle(
                                                          fontFamily: 'Poppins',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          fontSize:
                                                              width * 0.03,
                                                          color: Colorr
                                                              .themcolor300))),
                                                  DataCell(Text(formattedTime,
                                                      style: TextStyle(
                                                          fontFamily: 'Poppins',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          fontSize:
                                                              width * 0.03,
                                                          color: Colorr
                                                              .themcolor300))),
                                                  DataCell(Text(formattedTime1,
                                                      style: TextStyle(
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          fontSize:
                                                              width * 0.03,
                                                          fontFamily: 'Poppins',
                                                          color: Colorr
                                                              .themcolor300))),
                                                ]);
                                              }).toList()),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: SingleChildScrollView(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Theme(
                                          data: Theme.of(context).copyWith(
                                              dividerColor: Colors.transparent),
                                          child: DataTable(
                                              dividerThickness: 0,
                                              dataRowHeight: 30,
                                              columnSpacing: 30,
                                              columns: [
                                                DataColumn(
                                                  label: Text('No',
                                                      style: TextStyle(
                                                          fontFamily: 'Poppins',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          fontSize:
                                                              width * 0.035,
                                                          color: Colorr
                                                              .themcolor)),
                                                ),
                                                DataColumn(
                                                  label: Text('Name',
                                                      style: TextStyle(
                                                          fontFamily: 'Poppins',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          fontSize:
                                                              width * 0.035,
                                                          color: Colorr
                                                              .themcolor)),
                                                ),
                                                DataColumn(
                                                  label: Text('Birthday',
                                                      style: TextStyle(
                                                          fontFamily: 'Poppins',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          fontSize:
                                                              width * 0.035,
                                                          color: Colorr
                                                              .themcolor)),
                                                ),
                                              ],
                                              rows: EmployeeBirthday.asMap()
                                                  .entries
                                                  .map((entry) {
                                                int index = entry.key + 1;
                                                final e = entry.value;
                                                return DataRow(cells: [
                                                  DataCell(Text(
                                                    index.toString(),
                                                    style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        fontSize: width * 0.03,
                                                        color: Colorr
                                                            .themcolor300),
                                                  )),
                                                  DataCell(Text(
                                                    e['FirstName'].toString(),
                                                    style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        fontSize: width * 0.03,
                                                        color: Colorr
                                                            .themcolor300),
                                                  )),
                                                  DataCell(Text(
                                                      CustomWidgets
                                                          .DateFormatchange(
                                                              e['Dob']),
                                                      style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        color:
                                                            Colorr.themcolor300,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        fontSize: width * 0.03,
                                                      ))),
                                                ]);
                                              }).toList()),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: SingleChildScrollView(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Theme(
                                          data: Theme.of(context).copyWith(
                                              dividerColor: Colors.transparent),
                                          child: DataTable(
                                              dividerThickness: 0,
                                              dataRowHeight: 30,
                                              columnSpacing: 30,
                                              columns: [
                                                DataColumn(
                                                  label: Text('No',
                                                      style: TextStyle(
                                                          fontFamily: 'Poppins',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          fontSize:
                                                              width * 0.035,
                                                          color: Colorr
                                                              .themcolor)),
                                                ),
                                                DataColumn(
                                                  label: Text('Name',
                                                      style: TextStyle(
                                                          fontFamily: 'Poppins',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          fontSize:
                                                              width * 0.035,
                                                          color: Colorr
                                                              .themcolor)),
                                                ),
                                                DataColumn(
                                                  label: Text('Anniversary',
                                                      style: TextStyle(
                                                          fontFamily: 'Poppins',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          fontSize:
                                                              width * 0.035,
                                                          color: Colorr
                                                              .themcolor)),
                                                ),
                                              ],
                                              rows: EmployeeAnni.asMap()
                                                  .entries
                                                  .map((entry) {
                                                int index = entry.key + 1;
                                                final e = entry.value;
                                                return DataRow(cells: [
                                                  DataCell(Text(
                                                    index.toString(),
                                                    style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        fontSize: width * 0.03,
                                                        color: Colorr
                                                            .themcolor300),
                                                  )),
                                                  DataCell(Text(
                                                    e['FirstName'].toString(),
                                                    style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        fontSize: width * 0.03,
                                                        color: Colorr
                                                            .themcolor300),
                                                  )),
                                                  DataCell(Text(
                                                      e['AnniversaryDate'] !=
                                                              null
                                                          ? CustomWidgets
                                                              .DateFormatchange(
                                                                  e['AnniversaryDate'])
                                                          : "",
                                                      style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        color:
                                                            Colorr.themcolor300,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        fontSize: width * 0.03,
                                                      ))),
                                                ]);
                                              }).toList()),
                                        ),
                                      ),
                                    ),
                                  ),
                                ]))
                      ]),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Container(
                      height: height / 2.5,
                      width: width,
                      margin: EdgeInsets.only(top: 2, bottom: 10),
                      decoration: BoxDecoration(
                          color: Colorr.White,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(children: [
                        Row(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height / 30,
                              width: MediaQuery.of(context).size.width / 2.9,
                              margin: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.07,
                                top: MediaQuery.of(context).size.width * 0.03,
                                bottom:
                                    MediaQuery.of(context).size.width * 0.02,
                              ),
                              child: TextField(
                                style: TextStyle(fontSize: width * 0.03),
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(
                                        color: Colorr.themcolor,
                                      )),
                                  // errorText: "Enter Valid Email",
                                  contentPadding: EdgeInsets.only(
                                      top: width * 0.03,
                                      left: width * 0.02,
                                      right: width * 0.02),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(
                                        color: Colorr.themcolor300,
                                        width: 2,
                                      )),
                                  hintText: "Search",
                                  hintStyle: TextStyle(fontSize: width * 0.03),
                                  suffixIcon:
                                      Icon(Icons.search, size: width * 0.04),
                                  suffixIconColor: Colorr.themcolor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        TabBar(
                          indicatorColor: Colorr.themcolor500,
                          indicatorPadding: EdgeInsets.only(
                              left: width * 0.05, right: width * 0.09),
                          controller: _tabController1,
                          onTap: (value) {
                            setState(() {});
                          },
                          tabs: [
                            Container(
                              width: width / 4,
                              child: Tab(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text("Present",
                                          style: TextStyle(
                                            fontSize: width * 0.035,
                                            fontFamily: 'Poppins',
                                            overflow: TextOverflow.ellipsis,
                                            color: _tabController1.index == 0
                                                ? Colorr
                                                    .themcolor // Selected color
                                                : Colorr
                                                    .IconColor, // Default color)),
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: width / 4,
                              child: Tab(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text("Late In",
                                          style: TextStyle(
                                            fontSize: width * 0.035,
                                            fontFamily: 'Poppins',
                                            overflow: TextOverflow.ellipsis,
                                            color: _tabController1.index == 1
                                                ? Colorr
                                                    .themcolor // Selected color
                                                : Colorr
                                                    .IconColor, // Default color)),
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: width / 4,
                              child: Tab(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text("Early Out",
                                          style: TextStyle(
                                            fontSize: width * 0.035,
                                            fontFamily: 'Poppins',
                                            overflow: TextOverflow.ellipsis,
                                            color: _tabController1.index == 2
                                                ? Colorr
                                                    .themcolor // Selected color
                                                : Colorr
                                                    .IconColor, // Default color)),
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: width / 4,
                              child: Tab(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text("Absent",
                                          style: TextStyle(
                                            fontSize: width * 0.035,
                                            fontFamily: 'Poppins',
                                            overflow: TextOverflow.ellipsis,
                                            color: _tabController1.index == 3
                                                ? Colorr
                                                    .themcolor // Selected color
                                                : Colorr
                                                    .IconColor, // Default color)),
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                            flex: 4,
                            child: TabBarView(
                                controller: _tabController1,
                                children: [
                                  Container(
                                    child: ListView.builder(
                                      itemCount:
                                          Con_List.PresentAttandance.length,
                                      itemBuilder: (context, index) {
                                        String formattedTime = "";
                                        if (Con_List.PresentAttandance[index]
                                                ['timeIn'] !=
                                            null) {
                                          String timeim = Con_List
                                              .PresentAttandance[index]
                                                  ['timeIn']
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
                                        String temp = Con_List.PresentAttandance[index]['userData'].toString()=="[]"||!Con_List.PresentAttandance[index]['userData'][0].containsKey('image')?"":Con_List.PresentAttandance[index]['userData'][0]['image'];
                                        Uint8List? image;
                                        if (temp != "") {
                                          if (temp.contains("data:image")) {
                                            image = base64
                                                .decode(temp.split(',')[1]);
                                          } else {
                                            image = base64.decode(temp);
                                          }
                                        }
                                        return ListTile(
                                          leading: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                color: Color(0xff4a978b),
                                                shape: BoxShape.circle,
                                                image: image != null
                                                    ? DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image:
                                                            MemoryImage(image))
                                                    : DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: AssetImage(
                                                          "images/user12.png",
                                                        ))),
                                          ),
                                          title: Text("${Con_List.PresentAttandance[index]
                                          ['employeeData'][0]['FirstName']} ${Con_List.PresentAttandance[index]
                                          ['employeeData'][0]['LastName']}",
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.04,
                                              )),
                                          subtitle:
                                              Text("In Time $formattedTime",
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.026,
                                                  )),
                                        );
                                      },
                                    ),
                                  ),
                                  Container(
                                    child: ListView.builder(
                                      itemCount: Con_List.LatAttandance.length,
                                      itemBuilder: (context, index) {
                                        String formattedTime = "";
                                        if (Con_List.LatAttandance[index]
                                                ['timeIn'] !=
                                            null) {
                                          String timeim = Con_List
                                              .LatAttandance[index]['timeIn']
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
                                        String temp = Con_List.LatAttandance[index]['userData'].toString()=="[]"||!Con_List.LatAttandance[index]['userData'][0].containsKey('image')?"":Con_List.LatAttandance[index]['userData'][0]['image'];
                                        Uint8List? image;
                                        if (temp != "") {
                                          if (temp.contains("data:image")) {
                                            image = base64
                                                .decode(temp.split(',')[1]);
                                          } else {
                                            image = base64.decode(temp);
                                          }
                                        }

                                        return ListTile(
                                          leading: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                color: Color(0xff4a978b),
                                                shape: BoxShape.circle,
                                                image: image != null
                                                    ? DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image:
                                                            MemoryImage(image))
                                                    : DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: AssetImage(
                                                          "images/user12.png",
                                                        ))),
                                          ),
                                          title: Text(
                                              "${Con_List.LatAttandance[index]['employeeData'][0]['FirstName']} ${Con_List.LatAttandance[index]['employeeData'][0]['LastName']}",
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.04,
                                              )),
                                          subtitle:
                                              Text("In Time $formattedTime",
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.026,
                                                  )),
                                        );
                                      },
                                    ),
                                  ),
                                  Container(
                                    child: ListView.builder(
                                      itemCount:
                                          Con_List.EarlyOutAttandance.length,
                                      itemBuilder: (context, index) {
                                        String formattedTime = "";
                                        if (Con_List.EarlyOutAttandance[index]
                                                ['timeOut'] !=
                                            null) {
                                          String timeim = Con_List
                                              .EarlyOutAttandance[index]
                                                  ['timeOut']
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
                                        String temp = Con_List.EarlyOutAttandance[index]['userData'].toString()=="[]"||!Con_List.EarlyOutAttandance[index]['userData'][0].containsKey('image')?"":Con_List.EarlyOutAttandance[index]['userData'][0]['image'];
                                        Uint8List? image;
                                        if (temp != "") {
                                          if (temp.contains("data:image")) {
                                            image = base64
                                                .decode(temp.split(',')[1]);
                                          } else {
                                            image = base64.decode(temp);
                                          }
                                        }
                                        return ListTile(
                                          leading: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                color: Color(0xff4a978b),
                                                shape: BoxShape.circle,
                                                image: image != null
                                                    ? DecorationImage(
                                                        fit: BoxFit.fill,
                                                        image:
                                                            MemoryImage(image))
                                                    : DecorationImage(
                                                        fit: BoxFit.fill,
                                                        image: AssetImage(
                                                          "images/user12.png",
                                                        ))),
                                          ),
                                          title: Text(
                                              "${Con_List.EarlyOutAttandance[index]
                                                      ['employeeData'][0]
                                                      ['FirstName']} ${Con_List.EarlyOutAttandance[index]
                                              ['employeeData'][0]
                                              ['LastName']}",
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.04,
                                              )),
                                          subtitle:
                                              Text("Out Time $formattedTime",
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.026,
                                                  )),
                                        );
                                      },
                                    ),
                                  ),
                                  Container(
                                    child: ListView.builder(
                                      itemCount:
                                          Con_List.AbsentAttandance.length,
                                      itemBuilder: (context, index) {
                                        String Designation = "";
                                        if (Con_List.AbsentAttandance[index]
                                                ['designationId'] !=
                                            null) {
                                          Designation = Con_List
                                                      .DesignationSelect
                                                  .firstWhere(
                                                      (element) =>
                                                          element['_id'] ==
                                                          Con_List
                                                              .AbsentAttandance[
                                                                  index][
                                                                  'designationId']
                                                              .toString(),
                                                      orElse: () =>
                                                          {'name': ''})['name']
                                              .toString();
                                        }
                                        String temp = Con_List.AbsentAttandance[index]['userData'].toString()=="[]"||!Con_List.AbsentAttandance[index]['userData'][0].containsKey('image')?"":Con_List.AbsentAttandance[index]['userData'][0]['image'];
                                        Uint8List? image;
                                        if (temp != "") {
                                          if (temp.contains("data:image")) {
                                            image = base64
                                                .decode(temp.split(',')[1]);
                                          } else {
                                            image = base64.decode(temp);
                                          }
                                        }
                                        return ListTile(
                                          leading: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                color: Color(0xff4a978b),
                                                shape: BoxShape.circle,
                                                image: image != null
                                                    ? DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image:
                                                            MemoryImage(image))
                                                    : DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: AssetImage(
                                                          "images/user12.png",
                                                        ))),
                                          ),
                                          title: Text(
                                              "${Con_List.AbsentAttandance[index]['FirstName']} ${Con_List.AbsentAttandance[index]['LastName']}",
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.04,
                                              )),
                                          subtitle: Text(Designation,
                                              style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.026)),
                                        );
                                      },
                                    ),
                                  ),
                                ]))
                      ]),
                    ),
                  ),
                ],
              )));
    } else if (internetConn == 2) {
      return CustomWidgets.NoInternetImage(context);
    } else {
      return CustomWidgets.Circularprogress(context);
    }
  }

  Widget Deparment(int index) {
    // return Container(height: 100,width: 300,color: Colorr.themcolor,);
    return Container(
      // Normal padding
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height / 8.4,
        maxWidth: MediaQuery.of(context).size.width / 2.3,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(width: 1, color: Colorr.themcolor500),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.04),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Total",
                        style: TextStyle(
                          color: Colorr.themcolor500,
                          fontFamily: 'Poppins',
                          fontSize: MediaQuery.of(context).size.width *
                              0.030, // Responsive font size
                        ),
                      ),
                      Text(
                        Con_List.DeparmenntSelect[index]['total'].toString(),
                        style: TextStyle(
                          color: Colorr.themcolor500,
                          fontFamily: 'Poppins',
                          fontSize: MediaQuery.of(context).size.width *
                              0.035, // Responsive font size
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.06, top: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "In Time",
                            style: TextStyle(
                              color: Colorr.themcolor500,
                              fontFamily: 'Poppins',
                              fontSize: MediaQuery.of(context).size.width *
                                  0.026, // Responsive font size
                            ),
                          ),
                          // Spacer(),
                          // Padding(
                          //   padding: EdgeInsets.only(
                          //       right:
                          //           MediaQuery.of(context).size.width * 0.05),
                          //   child: Text(
                          //     Con_List.DeparmenntSelect[index]['inTime']
                          //         .toString(),
                          //     style: TextStyle(
                          //       color: Colorr.themcolor500,
                          //       fontFamily: 'Poppins',
                          //       fontSize: MediaQuery.of(context).size.width *
                          //           0.026, // Responsive font size
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                      CustomWidgets.height(
                          MediaQuery.of(context).size.width * 0.01),
                      Row(
                        children: [
                          Text(
                            "Late",
                            style: TextStyle(
                              color: Colorr.themcolor500,
                              fontFamily: 'Poppins',
                              fontSize: MediaQuery.of(context).size.width *
                                  0.026, // Responsive font size
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: EdgeInsets.only(
                                right:
                                    MediaQuery.of(context).size.width * 0.05),
                            child: Text(
                              Con_List.DeparmenntSelect[index]['lateIn']
                                  .toString(),
                              style: TextStyle(
                                color: Colorr.themcolor500,
                                fontFamily: 'Poppins',
                                fontSize: MediaQuery.of(context).size.width *
                                    0.026, // Responsive font size
                              ),
                            ),
                          ),
                        ],
                      ),
                      CustomWidgets.height(
                          MediaQuery.of(context).size.width * 0.01),
                      Row(
                        children: [
                          Text(
                            "Leave",
                            style: TextStyle(
                              color: Colorr.themcolor500,
                              fontFamily: 'Poppins',
                              fontSize: MediaQuery.of(context).size.width *
                                  0.026, // Responsive font size
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: EdgeInsets.only(
                                right:
                                    MediaQuery.of(context).size.width * 0.05),
                            child: Text(
                              Con_List.DeparmenntSelect[index]['absent']
                                  .toString(),
                              style: TextStyle(
                                color: Colorr.themcolor500,
                                fontFamily: 'Poppins',
                                fontSize: MediaQuery.of(context).size.width *
                                    0.026, // Responsive font size
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Divider(
            thickness: 1,
            color: Colorr.themcolor500,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              Con_List.DeparmenntSelect[index]['name'],
              style: TextStyle(
                color: Colorr.themcolor500,
                fontFamily: 'Poppins',
                fontSize: MediaQuery.of(context).size.width *
                    0.026, // Responsive font size
              ),
            )
          ]),
          Spacer()
        ],
      ),
    );
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

  Future<String> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime selectedDate = DateTime.now();
    DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    DateTime dateTime = DateTime.now();
    if (controller.text.isNotEmpty) {
      dateTime = dateFormat.parse(controller.text);
    }
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.text.isNotEmpty ? dateTime : selectedDate,
      firstDate: DateTime(2015),
      lastDate: selectedDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colorr.themcolor, // <-- SEE HERE
              onPrimary: Colorr.White, // <-- SEE HERE
              onSurface: Colorr.themcolor, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Colorr.themcolor, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        fromDate = picked;
        controller.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
    return controller.text;
  }

  Future<String> _selectDate1(
      BuildContext context, TextEditingController controller) async {
    DateTime selectedDate = DateTime.now();
    DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    DateTime dateTime = DateTime.now();
    if (controller.text.isNotEmpty) {
      dateTime = dateFormat.parse(controller.text);
    }
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: Startdate.text.isNotEmpty ? dateTime : selectedDate,
      firstDate: fromDate ?? DateTime(2015),
      lastDate: selectedDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colorr.themcolor, // <-- SEE HERE
              onPrimary: Colorr.White, // <-- SEE HERE
              onSurface: Colorr.themcolor, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Colorr.themcolor, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        toDate = picked;
        controller.text = DateFormat('dd-MM-yyyy').format(picked);
        // Format and update text field with selected date
      });
    }
    return controller.text;
  }

  Future<String> _selectDateIOS(
      BuildContext context, TextEditingController controller) async {
    DateTime selectedDate = DateTime.now();
    DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    DateTime dateTime = DateTime.now();
    if (controller.text.isNotEmpty) {
      dateTime = dateFormat.parse(controller.text);
    }
    final DateTime? picked = await showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          color: Colorr.White,
          height: 200.0,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime:
                controller.text.isNotEmpty ? dateTime : selectedDate,
            minimumDate: DateTime(2015),
            maximumDate: DateTime(2101),
            onDateTimeChanged: (DateTime newDate) {
              selectedDate = newDate;
              setState(() {
                fromDate = newDate;
                controller.text = DateFormat('dd-MM-yyyy').format(newDate);
              });
            },
          ),
        );
      },
    );
    return controller.text;
  }

  Future<String> _selectDateIOS1(
      BuildContext context, TextEditingController controller) async {
    DateTime selectedDate = DateTime.now();
    DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    DateTime dateTime = DateTime.now();
    if (controller.text.isNotEmpty) {
      dateTime = dateFormat.parse(controller.text);
    }
    final DateTime? picked = await showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          color: Colorr.White,
          height: 200.0,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime:
                Startdate.text.isNotEmpty ? dateTime : selectedDate,
            maximumDate: DateTime(2101),
            onDateTimeChanged: (DateTime newDate) {
              selectedDate = newDate;
              setState(() {
                selectedDate = newDate;
                toDate = newDate;
                controller.text = DateFormat('dd-MM-yyyy').format(newDate);
              });
            },
          ),
        );
      },
    );
    return controller.text;
  }
}
