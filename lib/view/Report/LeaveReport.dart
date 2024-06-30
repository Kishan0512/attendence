// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:attendy/utils/Constant/LocalCustomWidgets.dart';
import 'package:attendy/view/Report/Add_Leave_Report.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../A_SQL_Trigger/Con_List.dart';
import '../../A_SQL_Trigger/Con_Usermast.dart';
import '../../A_SQL_Trigger/Deparment_api_page.dart';
import '../../A_SQL_Trigger/Employee_Add_api.dart';
import '../../A_SQL_Trigger/Leave_Type_api.dart';
import '../../A_SQL_Trigger/Leave_api.dart';
import '../../utils/Constant/Colors.dart';
import '../../utils/DroupDown/custom_dropdown.dart';
import '../../utils/Excel.dart';
import '../Dashboard/Dashboard.dart';

class LeaveReport extends StatefulWidget {
  const LeaveReport({Key? key}) : super(key: key);

  @override
  State<LeaveReport> createState() => _LeaveReportState();
}

class _LeaveReportState extends State<LeaveReport> {
  TextEditingController employeeName = TextEditingController();
  String Month1 = "";
  int internetConn = 0;
  double Height = 0;
  double Width = 0;
  bool search = false;
  String Year1 = "";
  TextEditingController Year = TextEditingController();
  TextEditingController Month = TextEditingController();
  TextEditingController DateOFBirth = TextEditingController();
  TextEditingController DeparmentNamwe = TextEditingController();
  TextEditingController LeaveTypeName = TextEditingController();
  TextEditingController totalLeaveToken = TextEditingController();
  List<String> AllEmployee = [];
  List<String> Deparment = [];
  List<String> LeaveType = [];
  List<dynamic> filterdata = [];
  bool isActive = false;
  bool isTap = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
    CheakInternet();
  }

  getdata() async {
    Con_List.AllEmployee = await AllEmployee_api.EmployeeSelect();
    Con_List.Leave = await Leave_api.LeaveSelect();
    Con_List.LeaveType = await Leave_Type_api.Leave_TypeSelect();
    Con_List.DeparmenntSelect = await Deparmentapi.DeparmentSelect();
    for (var element in Con_List.AllEmployee) {
      AllEmployee.add(element['FirstName']);
    }
    for (var element in Con_List.LeaveType) {
      LeaveType.add(element['name']);
    }
    filterdata = Con_List.Leave;
    setState(() {});
  }

  CheakInternet() async {
    internetConn = await CustomWidgets.CheakConnectionInternet();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Height = MediaQuery.of(context).size.height - kToolbarHeight;
    Width = MediaQuery.of(context).size.width;
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
                  title: "Leave Report",
                  action: [
                    Con_List.Drawer.where((element) =>
                            element['subname'] == 'Leave Report' &&
                            element['insert'] == true).isNotEmpty
                        ? CupertinoButton(
                            padding: EdgeInsets.zero,
                            child:
                                Icon(Icons.search_rounded, color: Colorr.White),
                            onPressed: () {
                              search = true;
                              setState(() {});
                            },
                          )
                        : Container()
                  ],
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
                    search
                        ? Container(
                            width: double.infinity,
                            height: Height / 2.6,
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
                                CustomWidgets.textFieldIOS(
                                  hintText: "Select Employee",
                                  controller: employeeName,
                                  readOnly: true,
                                  onTap: () {
                                    CustomWidgets.SelectDroupDown(
                                        context: context,
                                        items: AllEmployee,
                                        onSelectedItemChanged: (value) {
                                          employeeName.text = AllEmployee[value];
                                          setState(() {});
                                        });
                                  },
                                  suffix: CustomWidgets.aarowCupertinobutton(),
                                ),
                                CustomWidgets.textFieldIOS(
                                    controller: Year,
                                    hintText: "Month & Year",
                                    suffix: GestureDetector(
                                        onTap: () {
                                          showCupertinoModalPopup(
                                            context: context,
                                            builder: (BuildContext context) {

                                              return Container(
                                                height: Height / 3.5,
                                                color: Colors.white,
                                                child: Column(children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        height: 200,
                                                        width: 150,
                                                        child: CupertinoPicker(
                                                          itemExtent: 40.0,
                                                          onSelectedItemChanged:
                                                              (int index) {
                                                            setState(() {
                                                              Month1 = index
                                                                  .toString();
                                                              Year.text =
                                                                  "$Month1 & $Year1";
                                                            });
                                                          },
                                                          children: List<
                                                                  Widget>.generate(
                                                              12, (int index) {
                                                            final month =
                                                                index + 1;
                                                            return Center(
                                                              child: Text(
                                                                _getMonthName(month),
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        16.0),
                                                              ),
                                                            );
                                                          }),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 200,
                                                        width: 100,
                                                        child: CupertinoPicker(
                                                          itemExtent: 40.0,
                                                          onSelectedItemChanged:
                                                              (int index) {
                                                            setState(() {
                                                              int i = DateTime
                                                                          .now()
                                                                      .year -
                                                                  5 +
                                                                  index;
                                                              Year1 =
                                                                  i.toString();
                                                              Year.text =
                                                                  "$Month1 & $Year1";
                                                              setState(() {});
                                                              // _selectedYear = DateTime.now().year - 5 + index;
                                                            });
                                                          },
                                                          children: List<
                                                                  Widget>.generate(
                                                              10, (int index) {
                                                            final year =
                                                                DateTime.now()
                                                                        .year -
                                                                    5 +
                                                                    index;
                                                            return Center(
                                                              child: Text(
                                                                '$year',
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        16.0),
                                                              ),
                                                            );
                                                          }),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ]),
                                              );
                                            },
                                          );
                                        },
                                        child: CustomWidgets.DateIconIOS()),
                                    readOnly: true),
                                CustomWidgets.textFieldIOS(
                                  hintText: "Select Department",
                                  controller: DeparmentNamwe,
                                  readOnly: true,
                                  onTap: () {
                                    CustomWidgets.SelectDroupDown(
                                        context: context,
                                        items: Deparment,
                                        onSelectedItemChanged: (value) {
                                          DeparmentNamwe.text = Deparment[value];
                                          setState(() {});
                                        });
                                  },
                                  suffix: CustomWidgets.aarowCupertinobutton(),
                                ),
                                CustomWidgets.textFieldIOS(
                                  hintText: "Select Leavetype",
                                  controller: LeaveTypeName,
                                  readOnly: true,
                                  onTap: () {
                                    CustomWidgets.SelectDroupDown(
                                        context: context,
                                        items: LeaveType,
                                        onSelectedItemChanged: (value) {
                                          LeaveTypeName.text = LeaveType[value];
                                          setState(() {});
                                        });
                                  },
                                  suffix: CustomWidgets.aarowCupertinobutton(),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: Height / 20,
                                      width: Width / 3,
                                      child: CupertinoButton(
                                        padding: EdgeInsets.zero,
                                        color: Colorr.Reset,
                                        child: const Text("Reset"),
                                        onPressed: () {
                                          employeeName.text = "";
                                          DeparmentNamwe.text = "";
                                          LeaveTypeName.text = "";
                                          Year.text = "";
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    SizedBox(
                                      height: Height / 20,
                                      width: Width / 3,
                                      child: CupertinoButton(
                                        padding: EdgeInsets.zero,
                                        color: Colorr.themcolor,
                                        child: const Text("Search"),
                                        onPressed: () async {
                                          FocusScope.of(context).unfocus();
                                        },
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          )
                        : Container(),
                    Expanded(
                      child: Con_List.All_Leave_report.isNotEmpty
                          ? Container(
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              margin: search
                                  ? const EdgeInsets.only(top: 10)
                                  : const EdgeInsets.all(0),
                              decoration: BoxDecoration(
                                  color: Colorr.White,
                                  boxShadow: [
                                    search
                                        ? BoxShadow(
                                            color: Colorr.themcolor100,
                                            blurStyle: BlurStyle.outer,
                                            blurRadius: 8,
                                          )
                                        : const BoxShadow(),
                                  ]),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: DataTable(
                                      columns: const [
                                        DataColumn(
                                          label: Text('No.'),
                                        ),
                                        DataColumn(
                                          label: Text('Name'),
                                        ),
                                        DataColumn(
                                          label: Text('Leave Type'),
                                        ),
                                        DataColumn(
                                          label: Text('From Date'),
                                        ),
                                        DataColumn(
                                          label: Text('To Date'),
                                        ),
                                        DataColumn(
                                          label: Text('No Of Day'),
                                        ),
                                        DataColumn(
                                          label: Text('Reason'),
                                        ),
                                      ],
                                      rows: Con_List.Leave.asMap()
                                          .entries
                                          .map((entry) {
                                        int index = entry.key + 1;
                                        final e = entry.value;
                                        return DataRow(cells: [
                                          DataCell(Text(index.toString())),
                                          DataCell(Text(Con_List
                                                  .AllEmployee.isEmpty
                                              ? ""
                                              : Con_List.AllEmployee.firstWhere(
                                                      (element) =>
                                                          element['_id'] ==
                                                          e['EmployeeId'],
                                                      orElse: () => {
                                                            'FirstName': ''
                                                          })['FirstName']
                                                  .toString())),
                                          DataCell(Text(Con_List
                                                  .LeaveType.isEmpty
                                              ? ""
                                              : Con_List.LeaveType.firstWhere(
                                                      (element) =>
                                                          element['_id'] ==
                                                          e['leaveId'],
                                                      orElse: () =>
                                                          {'name': ''})['name']
                                                  .toString())),
                                          DataCell(Text(
                                              CustomWidgets.DateFormatchange(
                                                  e['fromDate'].toString()))),
                                          DataCell(Text(
                                              CustomWidgets.DateFormatchange(
                                                  e['toDate'].toString()))),
                                          DataCell(Text(e['day']!.toString())),
                                          DataCell(Text(e['reason']!)),
                                        ]);
                                      }).toList()),
                                ),
                              ),
                            )
                          : Container(),
                    )
                  ],
                ))
            : Scaffold(
                appBar: CustomWidgets.appbar(
                  title: "Leave Report",
                  action: [
                    Con_List.Drawer.where((element) =>
                            element['subname'] == 'Leave Report' &&
                            element['insert'] == true).isNotEmpty
                        ? IconButton(
                            padding: EdgeInsets.zero,
                            splashRadius: 18,
                            onPressed: () {
                              search = !search;
                              setState(() {});
                            },
                            icon: const Icon(Icons.search_rounded))
                        : Container(),
                    IconButton(
                        padding: EdgeInsets.zero,
                        splashRadius: 18,
                        onPressed: () {
                          setState(() {
                            getdata();
                          });
                        },
                        icon: const Icon(Icons.refresh))
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
                body: Stack(
                  children: [
                    Column(
                      children: [
                        search
                            ? Container(
                                width: double.infinity,
                                height: Height / 2.75,
                                padding: const EdgeInsets.only(
                                    left: 5, right: 5, top: 10, bottom: 10),
                                decoration: BoxDecoration(
                                    color: Colorr.White,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colorr.themcolor100,
                                        blurStyle: BlurStyle.outer,
                                        blurRadius: 8,
                                      ),
                                    ]),
                                child: Column(
                                  children: [
                                    CustomDropdown.search(
                                      listItemStyle: CustomWidgets.style(),
                                      hintText: 'Select Employee',
                                      controller: employeeName,
                                      items: AllEmployee,
                                      onChanged: (value) {
                                        String DepartmentaID =
                                            Con_List.AllEmployee.firstWhere(
                                                        (element) =>
                                                            element[
                                                                'FirstName'] ==
                                                            value,
                                                        orElse: () => {
                                                              'departmentId': {
                                                                '_id': ''
                                                              }
                                                            })['departmentId']
                                                    ['_id']
                                                .toString();
                                        DeparmentNamwe.text =
                                            Con_List.DeparmenntSelect
                                                .firstWhere(
                                                    (element) =>
                                                        element['_id'] ==
                                                        DepartmentaID,
                                                    orElse: () =>
                                                        {'name': ''})['name'];
                                        setState(() {});
                                      },
                                    ),
                                    CustomWidgets.textField(
                                        controller: Year,
                                        hintText: "Month & Year",
                                        suffixIcon: InkWell(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return MonthYearPickerDialog(
                                                    onMonthYearSelected:
                                                        (int selectedMonth,
                                                            int selectedYear) {
                                                      if (selectedMonth < 10) {
                                                        Year.text =
                                                            "$selectedYear-0$selectedMonth";
                                                      } else {
                                                        Year.text =
                                                            "$selectedYear-$selectedMonth";
                                                      }

                                                      Month1 = selectedMonth
                                                          .toString();
                                                      Year1 = selectedYear
                                                          .toString();
                                                      setState(() {});
                                                    },
                                                  );
                                                },
                                              );
                                            },
                                            child: CustomWidgets.DateIcon()),
                                        readOnly: true),
                                    CustomWidgets.textField(
                                      controller: DeparmentNamwe,
                                      hintText: "Department",
                                      readOnly: true,
                                    ),
                                    CustomDropdown.search(
                                      listItemStyle: CustomWidgets.style(),
                                      hintText: 'Select Leavetype',
                                      controller: LeaveTypeName,
                                      items: LeaveType,
                                    ),
                                    CustomWidgets.height(10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CustomWidgets.confirmButton(
                                            onTap: () {
                                              employeeName.text = "";
                                              LeaveTypeName.text = "";
                                              Year.text = "";
                                              DeparmentNamwe.text = "";
                                              setState(() {
                                                getdata();
                                              });
                                            },
                                            height: Height / 20,
                                            width: Width / 3,
                                            text: "Reset",
                                            Clr: Colorr.Reset),
                                        CustomWidgets.width(5),
                                        CustomWidgets.confirmButton(
                                            onTap: () {
                                              setState(() {
                                                filterdata = Con_List.Leave.where((element) =>
                                                    (employeeName
                                                            .text.isNotEmpty
                                                        ? element['EmployeeId']
                                                                ['FirstName'] ==
                                                            employeeName.text
                                                        : true) &&
                                                    (LeaveTypeName
                                                            .text.isNotEmpty
                                                        ? element['leaveId']
                                                                ['name'] ==
                                                            LeaveTypeName.text
                                                        : true) &&
                                                    (Year.text.isNotEmpty
                                                        ? element['fromDate']
                                                                .toString()
                                                                .substring(
                                                                    0, 7) ==
                                                            Year.text
                                                        : true)).toList();
                                              });
                                            },
                                            height: Height / 20,
                                            width: Width / 3,
                                            text: "Filter")
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                        Expanded(child: mainwidget())
                      ],
                    ),
                    AnimatedPositioned(
                        top: !isTap
                            ? MediaQuery.of(context).size.height / 1.24
                            : MediaQuery.of(context).size.height / 1.56,
                        left: MediaQuery.of(context).size.width / 1.22,
                        duration: const Duration(milliseconds: 300),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              CreatePDF();
                              isTap = false;
                            });
                          },
                          child: CircleAvatar(
                              backgroundColor: Colors.black26,
                              radius: 30,
                              child: Image.asset("images/pdf.png",
                                  width: 40, height: 40)),
                        )),
                    AnimatedPositioned(
                        top: !isTap
                            ? MediaQuery.of(context).size.height / 1.24
                            : MediaQuery.of(context).size.height / 1.38,
                        left: MediaQuery.of(context).size.width / 1.22,
                        duration: const Duration(milliseconds: 300),
                        child: GestureDetector(
                            onTap: () {
                              setState(() {
                                ExcelSheet.generateExcelFromJson(
                                    context, filterdata, "LeaveReport");
                                isTap = false;
                              });
                            },
                            child: CircleAvatar(
                                backgroundColor: Colors.black26,
                                radius: 30,
                                child: Image.asset("images/Excel.png",
                                    width: 50, height: 50)))),
                    AnimatedPositioned(
                        top: MediaQuery.of(context).size.height / 1.24,
                        left: MediaQuery.of(context).size.width / 1.22,
                        duration: const Duration(milliseconds: 0),
                        child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isTap = !isTap;
                              });
                            },
                            child: CircleAvatar(
                                backgroundColor: Colorr.themcolor,
                                radius: 30,
                                child: Icon(
                                    !isTap ? Icons.download : Icons.close,
                                    color: Colors.white)))),
                  ],
                )));
  }

  Widget mainwidget() {
    if (internetConn == 1) {
      return filterdata.isNotEmpty
          ? filterdata.isNotEmpty
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  margin: search ? const EdgeInsets.only(top: 10) : const EdgeInsets.all(0),
                  decoration: BoxDecoration(color: Colorr.White, boxShadow: [
                    search
                        ? BoxShadow(
                            color: Colorr.themcolor100,
                            blurStyle: BlurStyle.outer,
                            blurRadius: 8,
                          )
                        : const BoxShadow(),
                  ]),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                          columns: const [
                            DataColumn(
                              label: Text('No.'),
                            ),
                            DataColumn(
                              label: Text('Name'),
                            ),
                            DataColumn(
                              label: Text('Leave Type'),
                            ),
                            DataColumn(
                              label: Text('From Date'),
                            ),
                            DataColumn(
                              label: Text('To Date'),
                            ),
                            DataColumn(
                              label: Text('No Of Day'),
                            ),
                            DataColumn(
                              label: Text('Reason'),
                            ),
                          ],
                          rows: filterdata.asMap().entries.map((entry) {
                            int index = entry.key + 1;
                            final e = entry.value;
                            return DataRow(cells: [
                              DataCell(Text(index.toString())),
                              DataCell(Text(e['EmployeeId']['FirstName'])),
                              DataCell(Text(e['leaveId']['name'])),
                              DataCell(Text(CustomWidgets.DateFormatchange(
                                  e['fromDate'].toString()))),
                              DataCell(Text(CustomWidgets.DateFormatchange(
                                  e['toDate'].toString()))),
                              DataCell(Text(e['day']!.toString())),
                              DataCell(Text(e['reason']!)),
                            ]);
                          }).toList()),
                    ),
                  ))
              : Container()
          : CustomWidgets.NoDataImage(context);
    } else if (internetConn == 2) {
      return CustomWidgets.NoInternetImage(context);
    } else {
      return CustomWidgets.Circularprogress(context);
    }
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }

  CreatePDF() async {
    List Temp = await Leave_api.LeaveSelect();
    final pdf = pw.Document();
    pdf.addPage(pw.Page(
      margin: const pw.EdgeInsets.all(10),
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        return pw.Container(
          child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  "Company",
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Wrap(
                    crossAxisAlignment: pw.WrapCrossAlignment.center,
                    children: [
                      pw.Text('Address', style: const pw.TextStyle()),
                    ]),
                pw.SizedBox(height: 10),
                pw.Text(
                  'LeaveReport For Apr-${DateTime.now().year}',
                  style: const pw.TextStyle(),
                ),
                pw.SizedBox(height: 10),
                pw.Row(children: [
                  pw.Expanded(
                    child: pw.Container(
                        decoration: const pw.BoxDecoration(
                            border: pw.Border(
                                top: pw.BorderSide(width: 1),
                                bottom: pw.BorderSide(width: 1),
                                left: pw.BorderSide(width: 1))),
                        child: pw.Text("Name",
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        alignment: pw.Alignment.center),
                  ),
                  pw.Expanded(
                    child: pw.Container(
                        decoration: const pw.BoxDecoration(
                            border: pw.Border(
                                top: pw.BorderSide(width: 1),
                                bottom: pw.BorderSide(width: 1),
                                left: pw.BorderSide(width: 1))),
                        child: pw.Text("Leave Type",
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        alignment: pw.Alignment.center),
                  ),
                  pw.Expanded(
                    child: pw.Container(
                        decoration: const pw.BoxDecoration(
                            border: pw.Border(
                                top: pw.BorderSide(width: 1),
                                bottom: pw.BorderSide(width: 1),
                                left: pw.BorderSide(width: 1))),
                        child: pw.Text("From Date",
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        alignment: pw.Alignment.center),
                  ),
                  pw.Expanded(
                    child: pw.Container(
                        decoration: const pw.BoxDecoration(
                            border: pw.Border(
                                top: pw.BorderSide(width: 1),
                                bottom: pw.BorderSide(width: 1),
                                left: pw.BorderSide(width: 1))),
                        child: pw.Text("To Date",
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        alignment: pw.Alignment.center),
                  ),
                  pw.Expanded(
                    child: pw.Container(
                        decoration: const pw.BoxDecoration(
                            border: pw.Border(
                                top: pw.BorderSide(width: 1),
                                bottom: pw.BorderSide(width: 1),
                                left: pw.BorderSide(width: 1))),
                        child: pw.Text("Reason",
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        alignment: pw.Alignment.center),
                  ),
                  pw.Expanded(
                    child: pw.Container(
                        decoration: const pw.BoxDecoration(
                            border: pw.Border(
                                top: pw.BorderSide(width: 1),
                                bottom: pw.BorderSide(width: 1),
                                right: pw.BorderSide(width: 1),
                                left: pw.BorderSide(width: 1))),
                        child: pw.Text("No of Days",
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        alignment: pw.Alignment.center),
                  ),
                ]),
                pw.ListView.builder(
                    itemBuilder: (context, index) {
                      return pw.Container(
                          child: pw.Row(children: [
                        pw.Expanded(
                          child: pw.Container(
                              decoration: const pw.BoxDecoration(
                                  border: pw.Border(
                                      top: pw.BorderSide(width: 1),
                                      bottom: pw.BorderSide(width: 1),
                                      left: pw.BorderSide(width: 1))),
                              child: pw.Text(
                                  Temp[index]["EmployeeId"]["FirstName"]),
                              alignment: pw.Alignment.center),
                        ),
                        pw.Expanded(
                          child: pw.Container(
                              decoration: const pw.BoxDecoration(
                                  border: pw.Border(
                                      top: pw.BorderSide(width: 1),
                                      bottom: pw.BorderSide(width: 1),
                                      left: pw.BorderSide(width: 1))),
                              child: pw.Text(Temp[index]["leaveId"]["name"]),
                              alignment: pw.Alignment.center),
                        ),
                        pw.Expanded(
                          child: pw.Container(
                              decoration: const pw.BoxDecoration(
                                  border: pw.Border(
                                      top: pw.BorderSide(width: 1),
                                      bottom: pw.BorderSide(width: 1),
                                      left: pw.BorderSide(width: 1))),
                              child: pw.Text(DateFormat("dd-MM-yyyy").format(
                                  DateTime.parse(Temp[index]["fromDate"]))),
                              alignment: pw.Alignment.center),
                        ),
                        pw.Expanded(
                          child: pw.Container(
                              decoration: const pw.BoxDecoration(
                                  border: pw.Border(
                                      top: pw.BorderSide(width: 1),
                                      bottom: pw.BorderSide(width: 1),
                                      left: pw.BorderSide(width: 1))),
                              child: pw.Text(DateFormat("dd-MM-yyyy").format(
                                  DateTime.parse(Temp[index]["toDate"]))),
                              alignment: pw.Alignment.center),
                        ),
                        pw.Expanded(
                          child: pw.Container(
                              decoration: const pw.BoxDecoration(
                                  border: pw.Border(
                                      top: pw.BorderSide(width: 1),
                                      bottom: pw.BorderSide(width: 1),
                                      left: pw.BorderSide(width: 1))),
                              child: pw.Text(Temp[index]["reason"]),
                              alignment: pw.Alignment.center),
                        ),
                        pw.Expanded(
                          child: pw.Container(
                              decoration: const pw.BoxDecoration(
                                  border: pw.Border(
                                      top: pw.BorderSide(width: 1),
                                      bottom: pw.BorderSide(width: 1),
                                      right: pw.BorderSide(width: 1),
                                      left: pw.BorderSide(width: 1))),
                              child: pw.Text(Temp[index]["day"].toString()),
                              alignment: pw.Alignment.center),
                        ),
                      ]));
                    },
                    itemCount: Temp.length)
              ]),
        );
      },
    ));
    savePdfAndShow(pdf, Temp);
  }

  Future<void> savePdfAndShow(pw.Document pdf, dynamic e) async {
    final dir = await getExternalStorageDirectory();
    final path = '${dir!.path}/Payslip_Report_${DateTime.now()}.xlsx';

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
