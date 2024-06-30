import 'dart:developer';
import 'dart:io';
import 'package:attendy/A_SQL_Trigger/Con_Usermast.dart';
import 'package:attendy/utils/Constant/LocalCustomWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../A_SQL_Trigger/Attendance_api.dart';
import '../../A_SQL_Trigger/Con_List.dart';
import '../../A_SQL_Trigger/Employee_Add_api.dart';
import '../../utils/Constant/Colors.dart';
import '../../utils/DroupDown/custom_dropdown.dart';
import '../../utils/Excel.dart';
import '../Dashboard/Dashboard.dart';
import 'Add_Leave_Report.dart';

class AttendanceReport extends StatefulWidget {
  const AttendanceReport({Key? key}) : super(key: key);

  @override
  State<AttendanceReport> createState() => _AttendanceReportState();
}

class _AttendanceReportState extends State<AttendanceReport> {
  int internetConn = 0;
  double height = 0;
  double width = 0;
  bool ONClick = false;
  String Filter = "Daily";
  TextEditingController employeeName = TextEditingController();
  TextEditingController date = TextEditingController();
  List<String> AllEmployee = [];
  List<dynamic> Employee = [];
  String Month="",Year="";
  bool isloading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
    cheakInternet();
  }

  cheakInternet() async {
    internetConn = await CustomWidgets.CheakConnectionInternet();
    setState(() {});
  }

  getdata() async {
    Con_List.AllEmployee = await AllEmployee_api.EmployeeSelect();

    for (var element in Con_List.AllEmployee) {
      if (element['isActive'] == true) {
        AllEmployee.add(element['FirstName']);
      }
    }
    Con_List.AllAttandance = await Attendance_api.AttendanceReport(
        DateFormat('yyyy-MM-dd').format(DateTime.now()));
    Employee = Con_List.AllAttandance;
    if (Constants_Usermast.statuse != "ADMIN") {
      Con_List.AllAttandance = Con_List.AllAttandance.where((element) =>
          element['employeeId']['_id'].toString() ==
          Constants_Usermast.employeeId.toString()).toList();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height - kToolbarHeight;
    width = MediaQuery.of(context).size.width;
    Future<bool> onBackPress() {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return const Dashboard();
        },
      ));
      return Future.value(false);
    }

    return WillPopScope(
        onWillPop: () => onBackPress(),
        child: Constants_Usermast.IOS == true
            ? CupertinoPageScaffold(
                navigationBar: CustomWidgets.appbarIOS(
                  title: "Attendance Report",
                  action: [],
                  context: context,
                  onTap: () {
                    Navigator.pushReplacement(context, CupertinoPageRoute(
                      builder: (context) {
                        return const Dashboard();
                      },
                    ));
                  },
                ),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: height / 4,
                      padding: const EdgeInsets.only(
                          left: 5, right: 5, top: 10, bottom: 10),
                      decoration:
                          BoxDecoration(color: Colorr.White, boxShadow: [
                        BoxShadow(
                          color: Colorr.themcolor100,
                          blurStyle: BlurStyle.outer,
                          blurRadius: 8,
                        ),
                      ]),
                      child: Column(
                        children: [
                          CustomWidgets.height(5),
                          CustomWidgets.textFieldIOS(
                            hintText: "Select Employee",
                            controller: employeeName,
                            readOnly: true,
                            onTap: () {
                              CustomWidgets.SelectDroupDown(
                                  context: context,
                                  items: AllEmployee,
                                  onSelectedItemChanged: (index) {
                                    employeeName.text = AllEmployee[index];
                                    setState(() {});
                                  });
                            },
                            suffix: CustomWidgets.aarowCupertinobutton(),
                          ),
                          CustomWidgets.textFieldIOS(
                              hintText: "Select Date",
                              readOnly: true,
                              controller: date,
                              suffix: GestureDetector(
                                  onTap: () => CustomWidgets.selectDateIOS(
                                      context: context, controller: date),
                                  child: CustomWidgets.DateIconIOS())),
                          CustomWidgets.height(5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: height / 20,
                                width: width / 3,
                                child: CupertinoButton(
                                  color: Colorr.themcolor,
                                  padding: EdgeInsets.zero,
                                  child: const Text("Search"),
                                  onPressed: () {},
                                ),
                              )
                            ],
                          ),
                          CustomWidgets.height(8)
                        ],
                      ),
                    ),
                    Expanded(
                        child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      margin: const EdgeInsets.only(top: 10),
                      decoration:
                          BoxDecoration(color: Colorr.White, boxShadow: [
                        BoxShadow(
                          color: Colorr.themcolor100,
                          blurStyle: BlurStyle.outer,
                          blurRadius: 8,
                        ),
                      ]),
                      child: Con_List.AllAttandance.isNotEmpty
                          ? SingleChildScrollView(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                    columns: const [
                                      DataColumn(label: Text("No")),
                                      DataColumn(label: Text("Employee Name")),
                                      DataColumn(label: Text("Date")),
                                      DataColumn(label: Text("Punch In")),
                                      DataColumn(label: Text("Punch Out")),
                                      DataColumn(label: Text("Working Time")),
                                    ],
                                    rows: Con_List.AllAttandance.asMap()
                                        .entries
                                        .map((entry) {
                                      int index = entry.key + 1;
                                      final e = entry.value;
                                      String formattedTime = "";
                                      String formattedTime1 = "";
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
                                        formattedTime = DateFormat('hh:mm a')
                                            .format(dateTime);
                                      }
                                      if (e['timeOut'] != null) {
                                        String timeout =
                                            e['timeOut'].toString();
                                        DateTime t =
                                            DateTime.parse(timeout).toLocal();
                                        String formattedDateTime =
                                            DateFormat('yyyy-MM-dd hh:mm:ss a')
                                                .format(t);
                                        DateTime dateTime =
                                            DateFormat('yyyy-MM-dd hh:mm:ss a')
                                                .parse(formattedDateTime);
                                        formattedTime1 = DateFormat('hh:mm a')
                                            .format(dateTime);
                                      }
                                      return DataRow(cells: [
                                        DataCell(Text(index.toString())),
                                        DataCell(Text(e['employeeId']
                                                ['FirstName']
                                            .toString())),
                                        DataCell(Text(
                                            CustomWidgets.DateFormatchange(
                                                e['createdAt']))),
                                        DataCell(Text(formattedTime)),
                                        DataCell(Text(formattedTime1)),
                                        const DataCell(Text("")),
                                      ]);
                                    }).toList()),
                              ),
                            )
                          : Container(),
                    ))
                  ],
                ))
            : Scaffold(
                appBar: CustomWidgets.appbar(
                  title: "Attendance Report",
                  action: [
                         PopupMenuButton(
                            shadowColor: Colorr.themcolor,
                            itemBuilder: (context) {
                              return [
                                PopupMenuItem(
                                  child: Text("Export as PDF"),
                                  onTap: () {
                                    AttendencePDF(Con_List.AllEmployee);
                                  },
                                ),
                                PopupMenuItem(
                                  child: Text("Export as Excel"),
                                  onTap: () {
                                    ExcelSheet.generateExcelFromJson(
                                        context,
                                        Con_List.AllAttandance,
                                        "AttendanceReport");
                                  },
                                )
                              ];
                            },
                          )
                  ],
                  context: context,
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) {
                        return const Dashboard();
                      },
                    ));
                  },
                ),
                body: mainwidget(),
              ));
  }

  Widget mainwidget() {
    if (internetConn == 1) {
      return Con_List.AllEmployee.isNotEmpty
          ? Constants_Usermast.statuse == "ADMIN"
              ? Stack(
                children: [
                  SizedBox(
                      height: height,
                      width: width,
                      child: Column(children: [
                        CustomWidgets.height(10),
                            CustomDropdown.search(
                                listItemStyle: CustomWidgets.style(),
                                hintText: 'Select Employee',
                                controller: employeeName,
                                items: AllEmployee,
                              ),
                        CustomWidgets.textField(
                                hintText: "Select Date",
                                readOnly: true,
                                controller: date,
                                suffixIcon: InkWell(
                                    onTap: () => CustomWidgets.selectDate(
                                        Future: true,
                                        context: context,
                                        controller: date),
                                    child: CustomWidgets.DateIcon())),
                        CustomWidgets.height(5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomWidgets.confirmButton(
                                onTap: () {
                                  employeeName.text = "";
                                  date.text = "";
                                  setState(() {});
                                },
                                height: height / 20,
                                width: width / 3,
                                text: "Reset",
                                Clr: Colorr.Reset),
                            CustomWidgets.width(5),
                            CustomWidgets.confirmButton(
                                onTap: () async {

                                    if (date.text.isNotEmpty) {
                                      String formattedDate =
                                          DateFormat('yyyy-MM-dd').format(
                                              DateFormat('dd-MM-yyyy')
                                                  .parse(date.text));
                                      Con_List.AllAttandance =
                                          await Attendance_api.AttendanceReport(
                                              formattedDate);
                                    }
                                    if (employeeName.text.isNotEmpty) {
                                      Con_List.AllAttandance = Con_List.AllAttandance.where(
                                          (element) =>
                                              element['employeeId']['FirstName']
                                                  .toString() ==
                                              employeeName.text).toList();
                                    }
                                    if(employeeName.text.isNotEmpty && date.text.isNotEmpty)
                                      {

                                        String formattedDate =
                                        DateFormat('yyyy-MM-dd').format(
                                            DateFormat('dd-MM-yyyy')
                                                .parse(date.text));
                                        Con_List.AllAttandance =
                                        await Attendance_api.AttendanceReport(
                                            formattedDate);
                                        Con_List.AllAttandance = Con_List.AllAttandance.where(
                                                (element) =>
                                            element['employeeId']['FirstName']
                                                .toString() ==
                                                employeeName.text).toList();

                                      }

                                  setState(() {});
                                },
                                height: height / 20,
                                width: width / 3,
                                text: "Search")
                          ],
                        ),
                        ONClick
                            ? Container()
                            : Expanded(
                                child: Container(
                                    child: Con_List.AllAttandance.isNotEmpty
                                        ? SingleChildScrollView(
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: DataTable(
                                                  columns: const [
                                                    DataColumn(label: Text("No")),
                                                    DataColumn(
                                                        label:
                                                            Text("Employee Name")),
                                                    DataColumn(label: Text("Date")),
                                                    DataColumn(label: Text("Day")),
                                                    DataColumn(
                                                        label: Text("Punch In")),
                                                    DataColumn(
                                                        label: Text("Punch Out")),
                                                    DataColumn(
                                                        label:
                                                            Text("Working Time")),
                                                  ],
                                                  rows:
                                                      Con_List.AllAttandance.asMap()
                                                          .entries
                                                          .map((entry) {
                                                    int index = entry.key + 1;
                                                    final e = entry.value;
                                                    String formattedTime = "N/A";
                                                    String formattedTime1 = "N/A";
                                                    String working = "";
                                                    if (e['fromTime'] != null) {
                                                      String timeim =
                                                          e['fromTime'].toString();
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
                                                    }
                                                    if (e['toTime'] != null) {
                                                      String timeout =
                                                          e['toTime'].toString();
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
                                                      DataCell(
                                                          Text(index.toString())),
                                                      DataCell(Text(e['employeeId']
                                                          ['FirstName'])),
                                                      DataCell(Text(e['date'])),
                                                      DataCell(Text(e['day'])),
                                                      DataCell(Text(formattedTime)),
                                                      DataCell(
                                                          Text(formattedTime1)),
                                                      DataCell(
                                                          Text(e['workingHours'])),
                                                    ]);
                                                  }).toList()),
                                            ),
                                          )
                                        : Container()),
                              )
                      ]),
                    ),
                  isloading ?Container(width: double.infinity,height: double.infinity,color: Colors.black.withOpacity(0.5),child: Center(child: CircularProgressIndicator(color: Colorr.themcolor300,))):Container()
                ],
              )
              : SizedBox(
                  height: height,
                  width: width,
                  child: Column(children: [
                    CustomWidgets.textField(
                        hintText: "Select Date",
                        readOnly: true,
                        controller: date,
                        suffixIcon: InkWell(
                            onTap: () => CustomWidgets.selectDate(
                                context: context, controller: date),
                            child: CustomWidgets.DateIcon())),
                    CustomWidgets.height(5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomWidgets.confirmButton(
                            onTap: () async {
                              String formattedDate = DateFormat('yyyy-MM-dd')
                                  .format(DateFormat('dd-MM-yyyy')
                                      .parse(date.text));
                              Con_List.AllAttandance =
                                  await Attendance_api.AttendanceReport(
                                      formattedDate);
                              Con_List.AllAttandance =
                                  Con_List.AllAttandance.where((element) =>
                                      element['employeeId']['_id'].toString() ==
                                      Constants_Usermast.employeeId
                                          .toString()).toList();
                              setState(() {});
                            },
                            height: height / 20,
                            width: width / 3,
                            text: "Search")
                      ],
                    ),
                    Expanded(
                      child: Container(
                          child: Con_List.AllAttandance.isNotEmpty
                              ? SingleChildScrollView(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                        columns: const [
                                          DataColumn(label: Text("No")),
                                          DataColumn(
                                              label: Text("Employee Name")),
                                          DataColumn(label: Text("Date")),
                                          DataColumn(label: Text("Day")),
                                          DataColumn(label: Text("Punch In")),
                                          DataColumn(label: Text("Punch Out")),
                                          DataColumn(
                                              label: Text("Working Time")),
                                        ],
                                        rows: Con_List.AllAttandance.asMap()
                                            .entries
                                            .map((entry) {
                                          int index = entry.key + 1;
                                          final e = entry.value;
                                          String formattedTime = "";
                                          String formattedTime1 = "";
                                          String working = "";
                                          if (e['fromTime'] != null) {
                                            String timeim =
                                                e['fromTime'].toString();
                                            DateTime t = DateTime.parse(timeim)
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
                                          }
                                          if (e['toTime'] != null) {
                                            String timeout =
                                                e['toTime'].toString();
                                            DateTime t = DateTime.parse(timeout)
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
                                            DataCell(Text(index.toString())),
                                            DataCell(Text(
                                                e['employeeId']['FirstName'])),
                                            DataCell(Text(e['date'])),
                                            DataCell(Text(e['day'])),
                                            DataCell(Text(formattedTime)),
                                            DataCell(Text(formattedTime1)),
                                            DataCell(Text(e['workingHours'])),
                                          ]);
                                        }).toList()),
                                  ),
                                )
                              : Container()),
                    )
                  ]),
                )
          : CustomWidgets.NoDataImage(context);
    } else if (internetConn == 2) {
      return CustomWidgets.NoInternetImage(context);
    } else {
      return CustomWidgets.Circularprogress(context);
    }
  }

  Duration calculateTimeDifference(
      String formattedTime1, String formattedTime2) {
    final dateFormat = DateFormat('hh:mm a');
    final dateTime1 = dateFormat.parse(formattedTime1);
    final dateTime2 = dateFormat.parse(formattedTime2);

    final difference = dateTime2.difference(dateTime1);

    return difference;
  }

  AttendencePDF(dynamic e) async {
    final pdf = pw.Document();
    final image = await imageFromAssetBundle('images/Attendy Logo.webp');
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a3,
        build: (context) {
          return pw.Container(
            child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(children: [
                    pw.Column(children: [
                      pw.Image(
                        image,
                        height: 60,
                        width: 60,
                      ),
                    ]),
                    pw.Spacer(),
                    pw.Column(children: [
                      pw.Text(
                        "Attendy",
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                          '374 B, Surya Mill Compound,Behind Rajhans Point,Near Mahesana Urban Bank,Varachha Road,Surat-395006.',
                          style: pw.TextStyle()),
                      pw.SizedBox(height: 10),
                      pw.Text(
                        'PaySlip For Apr-${DateTime.now().year}',
                        style: pw.TextStyle(),
                      ),
                    ]),
                    pw.Spacer(),
                    pw.Column(children: [
                      pw.Image(
                        image,
                        height: 60,
                        width: 60,
                      ),
                    ]),
                  ]),
                  pw.SizedBox(height: 10),
                  pw.Container(
                      decoration: pw.BoxDecoration(
                          border:
                          pw.Border.all(color: PdfColors.black, width: 2)),
                      child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Row(children: [
                              pw.Expanded(
                                child: pw.Column(
                                    crossAxisAlignment:
                                    pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.SizedBox(height: 5),
                                      pw.Text(
                                        "  Name of Employee : ${e['FirstName']}",
                                      ),
                                      pw.SizedBox(height: 5),
                                      pw.Text(
                                        "  Employee Code      : ${e['EmpCode']}",
                                      ),
                                      pw.SizedBox(height: 5),
                                      pw.Text(
                                        "  Designation             : ${e['designationId']['name']}",
                                      ),
                                      pw.SizedBox(height: 5),
                                      pw.Text(
                                        "  Date of Joining        : ${DateFormat('d MMMM yyyy').format(DateTime.parse(e['JoiningDate'].toString()).toLocal()).toString()}",
                                      ),
                                      pw.SizedBox(height: 5),
                                    ]),
                              ),
                              pw.Expanded(
                                child: pw.Column(
                                    crossAxisAlignment:
                                    pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.SizedBox(height: 5),
                                      pw.Text(
                                        "PAN No   : ${e['PANno']}",
                                      ),
                                      pw.SizedBox(height: 5),
                                      pw.Text(
                                        "PF No.     : ${e['PFno'] == null ? "" : e['PFno']}",
                                      ),
                                      pw.SizedBox(height: 5),
                                      pw.Text(
                                        "ESIC No. : ${e['ESICno'] == null ? "" : e['ESICno']}",
                                      ),
                                      pw.SizedBox(height: 5),
                                      pw.Text(
                                        "UIN No    : ${e['UNno'] == null ? "" : e['UNno']}",
                                      ),
                                      pw.SizedBox(height: 5),
                                    ]),
                              ),
                            ]),
                            pw.Text(
                              "  Address                   : ${e['Address']}",
                            ),
                            pw.SizedBox(height: 5),
                            pw.Container(height: 1, color: PdfColors.black),
                            pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.start,
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Expanded(
                                    child: pw.Column(
                                        crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        pw.MainAxisAlignment.start,
                                        children: [
                                          pw.SizedBox(height: 5),
                                          pw.Text(
                                            "  Basic Salary : 10000",
                                          ),
                                          pw.SizedBox(height: 5),
                                          pw.Text(
                                            "  BASIC          : 10000",
                                          ),
                                          pw.SizedBox(height: 5),
                                          pw.Text(
                                            "  DA                : 2000",
                                          ),
                                          pw.SizedBox(height: 5),
                                          pw.Text(
                                            "  HRA             : 2000",
                                          ),
                                          pw.SizedBox(height: 5),
                                          pw.Text(
                                            "  BONUS        : 3000",
                                          ),
                                          pw.SizedBox(height: 5),
                                        ]),
                                  ),
                                  pw.Expanded(
                                    child: pw.Column(
                                        crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        pw.MainAxisAlignment.start,
                                        children: [
                                          pw.SizedBox(height: 5),
                                          pw.Text(
                                            "Total Days Month : 30",
                                          ),
                                          pw.SizedBox(height: 5),
                                          pw.Text(
                                            "Working Days       : 25",
                                          ),
                                          pw.SizedBox(height: 5),
                                          pw.Text(
                                            "Weekoff Days       : 5",
                                          ),
                                          pw.SizedBox(height: 5),
                                          pw.Text(
                                            "Present Days        : 23",
                                          ),
                                          pw.SizedBox(height: 5),
                                          pw.Text(
                                            "Payable days        : 24",
                                          ),
                                          pw.SizedBox(height: 5),
                                        ]),
                                  ),
                                  pw.Expanded(
                                    child: pw.Column(
                                        crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        pw.MainAxisAlignment.start,
                                        children: [
                                          pw.SizedBox(height: 5),
                                          pw.Text(
                                            "Name Of Bank  : ${e['BankName']}",
                                          ),
                                          pw.SizedBox(height: 5),
                                          pw.Text(
                                            "Bank A/C No.    : ${e['BankAccountNo']}",
                                          ),
                                          pw.SizedBox(height: 5),
                                          pw.Text(
                                            "Bank IFSC        : ${e['IFSCcode']}",
                                          ),
                                          pw.SizedBox(height: 5),
                                          pw.Text(
                                            "Payment Mode : Cash",
                                          ),
                                          pw.SizedBox(height: 5),
                                        ]),
                                  ),
                                ]),
                            pw.Row(children: [
                              pw.Expanded(
                                flex: 2,
                                child: pw.Container(
                                    padding: pw.EdgeInsets.all(5),
                                    decoration: pw.BoxDecoration(
                                        border: pw.Border.all(
                                            color: PdfColors.black, width: 2)),
                                    child: pw.Text("Earnings",
                                        style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold))),
                              ),
                              pw.Expanded(
                                flex: 1,
                                child: pw.Container(
                                    padding: pw.EdgeInsets.all(5),
                                    decoration: pw.BoxDecoration(
                                        border: pw.Border.all(
                                            color: PdfColors.black, width: 2)),
                                    child: pw.Text("Amount",
                                        style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold))),
                              ),
                              pw.Expanded(
                                flex: 2,
                                child: pw.Container(
                                    padding: pw.EdgeInsets.all(5),
                                    decoration: pw.BoxDecoration(
                                        border: pw.Border.all(
                                            color: PdfColors.black, width: 2)),
                                    child: pw.Text("Deductions",
                                        style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold))),
                              ),
                              pw.Expanded(
                                flex: 1,
                                child: pw.Container(
                                    padding: pw.EdgeInsets.all(5),
                                    decoration: pw.BoxDecoration(
                                        border: pw.Border.all(
                                            color: PdfColors.black, width: 2)),
                                    child: pw.Text("Amount",
                                        style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold))),
                              ),
                            ]),
                            pw.Row(children: [
                              pw.Expanded(
                                flex: 2,
                                child: pw.Container(
                                    padding: pw.EdgeInsets.all(5),
                                    decoration: pw.BoxDecoration(
                                        border: pw.Border.all(
                                            color: PdfColors.black, width: 2)),
                                    child: pw.Text("Total Month Day")),
                              ),
                              pw.Expanded(
                                flex: 1,
                                child: pw.Container(
                                    padding: pw.EdgeInsets.all(5),
                                    decoration: pw.BoxDecoration(
                                        border: pw.Border.all(
                                            color: PdfColors.black, width: 2)),
                                    child: pw.Text("25")),
                              ),
                              pw.Expanded(
                                flex: 2,
                                child: pw.Container(
                                    padding: pw.EdgeInsets.all(5),
                                    decoration: pw.BoxDecoration(
                                        border: pw.Border.all(
                                            color: PdfColors.black, width: 2)),
                                    child:
                                    pw.Text("Total Month Day Deductions")),
                              ),
                              pw.Expanded(
                                flex: 1,
                                child: pw.Container(
                                    padding: pw.EdgeInsets.all(5),
                                    decoration: pw.BoxDecoration(
                                        border: pw.Border.all(
                                            color: PdfColors.black, width: 2)),
                                    child: pw.Text("25")),
                              ),
                            ]),
                            pw.Row(children: [
                              pw.Expanded(
                                flex: 2,
                                child: pw.Container(
                                    padding: pw.EdgeInsets.all(5),
                                    decoration: pw.BoxDecoration(
                                        border: pw.Border.all(
                                            color: PdfColors.black, width: 2)),
                                    child: pw.Text("BASIC")),
                              ),
                              pw.Expanded(
                                flex: 1,
                                child: pw.Container(
                                    padding: pw.EdgeInsets.all(5),
                                    decoration: pw.BoxDecoration(
                                        border: pw.Border.all(
                                            color: PdfColors.black, width: 2)),
                                    child: pw.Text("10000")),
                              ),
                              pw.Expanded(
                                flex: 2,
                                child: pw.Container(
                                    padding: pw.EdgeInsets.all(5),
                                    decoration: pw.BoxDecoration(
                                        border: pw.Border.all(
                                            color: PdfColors.black, width: 2)),
                                    child: pw.Text("ESIC")),
                              ),
                              pw.Expanded(
                                flex: 1,
                                child: pw.Container(
                                    padding: pw.EdgeInsets.all(5),
                                    decoration: pw.BoxDecoration(
                                        border: pw.Border.all(
                                            color: PdfColors.black, width: 2)),
                                    child: pw.Text("280")),
                              ),
                            ]),
                            pw.Row(children: [
                              pw.Expanded(
                                flex: 2,
                                child: pw.Container(
                                    padding: pw.EdgeInsets.all(5),
                                    decoration: pw.BoxDecoration(
                                        border: pw.Border.all(
                                            color: PdfColors.black, width: 2)),
                                    child: pw.Text("DA")),
                              ),
                              pw.Expanded(
                                flex: 1,
                                child: pw.Container(
                                    padding: pw.EdgeInsets.all(5),
                                    decoration: pw.BoxDecoration(
                                        border: pw.Border.all(
                                            color: PdfColors.black, width: 2)),
                                    child: pw.Text("1000")),
                              ),
                              pw.Expanded(
                                flex: 2,
                                child: pw.Container(
                                    padding: pw.EdgeInsets.all(5),
                                    decoration: pw.BoxDecoration(
                                        border: pw.Border.all(
                                            color: PdfColors.black, width: 2)),
                                    child: pw.Text("Provident Fund")),
                              ),
                              pw.Expanded(
                                flex: 1,
                                child: pw.Container(
                                    padding: pw.EdgeInsets.all(5),
                                    decoration: pw.BoxDecoration(
                                        border: pw.Border.all(
                                            color: PdfColors.black, width: 2)),
                                    child: pw.Text("1000")),
                              ),
                            ]),
                            pw.Row(children: [
                              pw.Expanded(
                                flex: 2,
                                child: pw.Container(
                                    padding: pw.EdgeInsets.all(5),
                                    decoration: pw.BoxDecoration(
                                        border: pw.Border.all(
                                            color: PdfColors.black, width: 2)),
                                    child: pw.Text("HRA")),
                              ),
                              pw.Expanded(
                                flex: 1,
                                child: pw.Container(
                                    padding: pw.EdgeInsets.all(5),
                                    decoration: pw.BoxDecoration(
                                        border: pw.Border.all(
                                            color: PdfColors.black, width: 2)),
                                    child: pw.Text("305")),
                              ),
                              pw.Expanded(
                                flex: 2,
                                child: pw.Container(
                                    padding: pw.EdgeInsets.all(5),
                                    decoration: pw.BoxDecoration(
                                        border: pw.Border.all(
                                            color: PdfColors.black, width: 2)),
                                    child: pw.Text("Total Deductions")),
                              ),
                              pw.Expanded(
                                flex: 1,
                                child: pw.Container(
                                    padding: pw.EdgeInsets.all(5),
                                    decoration: pw.BoxDecoration(
                                        border: pw.Border.all(
                                            color: PdfColors.black, width: 2)),
                                    child: pw.Text("1305")),
                              ),
                            ]),
                            pw.Row(children: [
                              pw.Expanded(
                                flex: 2,
                                child: pw.Container(
                                    padding: pw.EdgeInsets.all(5),
                                    decoration: pw.BoxDecoration(
                                        border: pw.Border.all(
                                            color: PdfColors.black, width: 2)),
                                    child: pw.Text("Gross Salary")),
                              ),
                              pw.Expanded(
                                flex: 1,
                                child: pw.Container(
                                    padding: pw.EdgeInsets.all(5),
                                    decoration: pw.BoxDecoration(
                                        border: pw.Border.all(
                                            color: PdfColors.black, width: 2)),
                                    child: pw.Text("11305")),
                              ),
                              pw.Expanded(
                                flex: 2,
                                child: pw.Container(
                                    padding: pw.EdgeInsets.all(5),
                                    decoration: pw.BoxDecoration(
                                        border: pw.Border.all(
                                            color: PdfColors.black, width: 2)),
                                    child: pw.Text("Take Home")),
                              ),
                              pw.Expanded(
                                flex: 1,
                                child: pw.Container(
                                    padding: pw.EdgeInsets.all(5),
                                    decoration: pw.BoxDecoration(
                                        border: pw.Border.all(
                                            color: PdfColors.black, width: 2)),
                                    child: pw.Text("10000")),
                              ),
                            ]),
                          ])),
                  pw.SizedBox(height: 10),
                  pw.Container(
                      width: double.infinity,
                      decoration: pw.BoxDecoration(
                          border:
                          pw.Border.all(color: PdfColors.black, width: 2)),
                      padding: pw.EdgeInsets.all(5),
                      child: pw.Text(
                          "In case of attendance related query please contact HR Department")),
                  pw.SizedBox(height: 10),
                  pw.Text("  Approved Person Signature :-")
                ]),
          );
        },
      ),
    );
    savePdfAndShow(pdf, e);
  }

  Future<void> savePdfAndShow(pw.Document pdf, dynamic e) async {
    final dir = await getExternalStorageDirectory();
    final path = '${dir!.path}/Payslip_Report_${DateTime.now()}.pdf';

    final file = File(path);
    await file.writeAsBytes(await pdf.save());

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    setState(() {});
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }
}
