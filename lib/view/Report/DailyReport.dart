import 'dart:io';
import 'package:attendy/A_SQL_Trigger/Attendance_api.dart';
import 'package:attendy/A_SQL_Trigger/Con_List.dart';
import 'package:attendy/A_SQL_Trigger/Deparment_api_page.dart';
import 'package:attendy/A_SQL_Trigger/Employee_Add_api.dart';
import 'package:attendy/utils/Constant/LocalCustomWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../A_SQL_Trigger/Con_Usermast.dart';
import '../../utils/Constant/Colors.dart';
import '../../utils/DroupDown/custom_dropdown.dart';
import '../../utils/Excel.dart';
import '../Dashboard/Dashboard.dart';
import '../../A_SQL_Trigger/Shift_Add_api.dart';

class DailyReport extends StatefulWidget {
  const DailyReport({Key? key}) : super(key: key);

  @override
  State<DailyReport> createState() => _DailyReportState();
}

class _DailyReportState extends State<DailyReport> {
  TextEditingController employeeName = TextEditingController();
  TextEditingController DateOFBirth = TextEditingController();
  TextEditingController DeparmentNamwe = TextEditingController();
  List<String> AllEmployee = [];
  List<DailyReports> Status = [];
  List<DailyReports> temp = [];
  List<dynamic> Attendence = [];
  List<dynamic> Attendence1 = [];
  List<String> Deparment = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  getdata() async {
    Attendence = await Attendance_api.FilterApiSingalDate(
        DateTime.now().toString().substring(0, 10));

    Con_List.AllEmployee = await AllEmployee_api.EmployeeSelect();
    Con_List.Allshift_Select = await Shift_Add_api.shift_Select();
    Con_List.DeparmenntSelect = await Deparmentapi.DeparmentSelect();
    AllEmployee.clear();
    Con_List.AllEmployee.forEach((element) {
      if (element['isActive'] == true) {
        AllEmployee.add(element['FirstName']);
      }
    });
    Deparment.clear();
    Con_List.DeparmenntSelect.forEach((element) {
      if (element['isActive'] == true) {
        Deparment.add(element['name']);
      }
    });
    Status.clear();
    Con_List.AllEmployee.forEach((element) {
      Map match = Attendence.firstWhere(
          (e) => e['employeeId']['_id'] == element['_id'].toString(),
          orElse: () => {});
      if (match.isNotEmpty) {
        Map seletedshift = Con_List.Allshift_Select.firstWhere(
          (e) => e['_id'].toString() == element['ShiftId']['_id'].toString(),
          orElse: () => {},
        );
        if (seletedshift.isNotEmpty) {
          DateTime ShiftIn = DateTime.parse(seletedshift['inTime']!);
          DateTime AttendenceIn = DateTime.parse(match['timeIn']!);
          bool isAfter = (AttendenceIn.hour > ShiftIn.hour) ||
              (AttendenceIn.hour == ShiftIn.hour &&
                  AttendenceIn.minute > ShiftIn.minute);
          if (isAfter) {
            Status.add(DailyReports(
                Employee: element['FirstName'],
                Date: DateFormat("dd-MM-yyyy").format(DateTime.now()),
                Department: element['departmentId']['name'],
                Status: "Late"));
          } else {
            Status.add(DailyReports(
                Employee: element['FirstName'],
                Date: DateFormat("dd-MM-yyyy").format(DateTime.now()),
                Department: element['departmentId']['name'],
                Status: "Present"));
          }
          if (match['timeOut'] != null) {
            Status.removeAt(Status.length - 1);
            DateTime ShiftOut = DateTime.parse(seletedshift['outTime']!);
            DateTime AttendenceOut = DateTime.parse(match['timeOut']!);
            bool isAfter = (AttendenceOut.hour > ShiftOut.hour) ||
                (AttendenceOut.hour == ShiftOut.hour &&
                    AttendenceOut.minute > ShiftOut.minute);
            if (!isAfter) {
              Status.add(DailyReports(
                  Employee: element['FirstName'],
                  Date: DateFormat("dd-MM-yyyy").format(DateTime.now()),
                  Department: element['departmentId']['name'],
                  Status: "EarlyOut"));
            }
          }
        }
      } else {
        Status.add(DailyReports(
            Employee: element['FirstName'],
            Date: DateFormat("dd-MM-yyyy").format(DateTime.now()),
            Department: element['departmentId']['name'],
            Status: "Absent"));
      }
    });
    temp = Status;

    setState(() {});
  }

  Widget build(BuildContext context) {
    double Height = MediaQuery.of(context).size.height - kToolbarHeight;
    double Width = MediaQuery.of(context).size.width;
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
                navigationBar: CustomWidgets.appbarIOS(
                  title: "Daily Report",
                  action: [
                    Constants_Usermast.statuse == "ADMIN"
                        ? PopupMenuButton(
                            shadowColor: Colorr.themcolor,
                            itemBuilder: (context) {
                              return [
                                PopupMenuItem(
                                  child: Text("Export as PDF"),
                                  onTap: () {

                                    AttendencePDF(Status);
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
                        : Container()
                  ],
                  context: context,
                  onTap: () {
                    Navigator.pushReplacement(context, CupertinoPageRoute(
                      builder: (context) {
                        return Dashboard();
                      },
                    ));
                  },
                ),
                child: Column(children: [
                  CustomWidgets.textFieldIOS(
                    hintText: "Select Employee",
                    controller: employeeName,
                    readOnly: true,
                    onTap: () {
                      CustomWidgets.SelectDroupDown(
                          context: context,
                          items: AllEmployee,
                          onSelectedItemChanged: (int) {
                            employeeName.text = AllEmployee[int];
                            setState(() {});
                          });
                    },
                    suffix: CustomWidgets.aarowCupertinobutton(),
                  ),
                  CustomWidgets.textFieldIOS(
                      controller: DateOFBirth,
                      hintText: "Date of Birth",
                      suffix: GestureDetector(
                          onTap: () => CustomWidgets.selectDateIOS(
                              context: context, controller: DateOFBirth),
                          child: CustomWidgets.DateIconIOS()),
                      readOnly: true),
                  CustomWidgets.textFieldIOS(
                    hintText: "Select Deparment",
                    controller: DeparmentNamwe,
                    readOnly: true,
                    onTap: () {
                      CustomWidgets.SelectDroupDown(
                          context: context,
                          items: Deparment,
                          onSelectedItemChanged: (int) {
                            DeparmentNamwe.text = Deparment[int];
                            setState(() {});
                          });
                    },
                    suffix: CustomWidgets.aarowCupertinobutton(),
                  ),
                  CustomWidgets.height(15),
                  Row(
                    children: [
                      Expanded(flex: 2, child: SizedBox(width: 5)),
                      Expanded(
                        flex: 2,
                        child: CupertinoButton(
                          color: Colorr.Reset,
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            employeeName.text = "";
                            DeparmentNamwe.text = "";
                            DateOFBirth.text = "";
                          },
                          child: Text('Reset'),
                        ),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        flex: 2,
                        child: CupertinoButton(
                          color: Colorr.themcolor,
                          padding: EdgeInsets.zero,
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                          },
                          child: Text("Save"),
                        ),
                      ),
                      SizedBox(width: 5),
                    ],
                  ),
                ]),
              )
            : Scaffold(
                appBar: CustomWidgets.appbar(
                  title: "Daily Report",
                  action: [
                    Constants_Usermast.statuse == "ADMIN"
                        ? PopupMenuButton(
                            shadowColor: Colorr.themcolor,
                            itemBuilder: (context) {
                              return [
                                PopupMenuItem(
                                  child: Text("Export as PDF"),
                                  onTap: () {

                                    AttendencePDF(Status);
                                  },
                                ),
                                PopupMenuItem(
                                  child: Text("Export as Excel"),
                                  onTap: () {
                                    List<dynamic> temp1 = Status.map(
                                        (e) => DailyReports.toJson(e)).toList();
                                    ExcelSheet.generateExcelFromJson(
                                        context, temp1, "DailyReport");
                                  },
                                )
                              ];
                            },
                          )
                        : Container()
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
                body: SingleChildScrollView(
                  child: Column(children: [
                    CustomWidgets.height(10),
                    CustomDropdown.search(
                      listItemStyle: CustomWidgets.style(),
                      hintText: 'Select Employee',
                      controller: employeeName,
                      items: AllEmployee,
                    ),
                    CustomWidgets.textField(
                        controller: DateOFBirth,
                        hintText: "Date",
                        suffixIcon: InkWell(
                            onTap: () => CustomWidgets.selectDate(
                                context: context, controller: DateOFBirth),
                            child: CustomWidgets.DateIcon()),
                        readOnly: true),
                    CustomDropdown.search(
                      listItemStyle: CustomWidgets.style(),
                      hintText: 'Select Deparment',
                      controller: DeparmentNamwe,
                      items: Deparment,
                    ),
                    CustomWidgets.height(15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomWidgets.confirmButton(
                            onTap: () {
                              employeeName.text = "";
                              DeparmentNamwe.text = "";
                              DateOFBirth.text = "";
                              getdata();
                              setState(() {});
                            },
                            height: Height / 20,
                            width: Width / 3,
                            text: "Reset",
                            Clr: Colorr.Reset),
                        CustomWidgets.width(5),
                        CustomWidgets.confirmButton(
                            onTap: () async {
                              if (DateOFBirth.text.isNotEmpty) {
                                Attendence =
                                    await Attendance_api.FilterApiSingalDate(
                                  CustomWidgets.DateFormatchangeapi(
                                      DateOFBirth.text),
                                );
                                Status.clear();
                                Con_List.AllEmployee.forEach((element) {
                                  Map match = Attendence.firstWhere(
                                      (e) =>
                                          e['employeeId']['_id'] ==
                                          element['_id'].toString(),
                                      orElse: () => {});
                                  if (match.isNotEmpty) {
                                    Map seletedshift =
                                        Con_List.Allshift_Select.firstWhere(
                                      (e) =>
                                          e['_id'].toString() ==
                                          element['ShiftId']['_id'].toString(),
                                      orElse: () => {},
                                    );
                                    if (seletedshift.isNotEmpty) {
                                      DateTime ShiftIn = DateTime.parse(
                                          seletedshift['inTime']!);
                                      DateTime AttendenceIn =
                                          DateTime.parse(match['timeIn']!);
                                      bool isAfter = (AttendenceIn.hour >
                                              ShiftIn.hour) ||
                                          (AttendenceIn.hour == ShiftIn.hour &&
                                              AttendenceIn.minute >
                                                  ShiftIn.minute);
                                      if (isAfter) {
                                        Status.add(DailyReports(
                                            Employee: element['FirstName'],
                                            Date: DateFormat("dd-MM-yyyy")
                                                .format(DateTime.parse(
                                                    CustomWidgets
                                                        .DateFormatchangeapi(
                                                            DateOFBirth.text))),
                                            Department: element['departmentId']
                                                ['name'],
                                            Status: "Late"));
                                      } else {
                                        Status.add(DailyReports(
                                            Employee: element['FirstName'],
                                            Date: DateFormat("dd-MM-yyyy")
                                                .format(DateTime.parse(
                                                    CustomWidgets
                                                        .DateFormatchangeapi(
                                                            DateOFBirth.text))),
                                            Department: element['departmentId']
                                                ['name'],
                                            Status: "Present"));
                                      }
                                      if (match['timeOut'] != null) {
                                        Status.removeAt(Status.length - 1);
                                        DateTime ShiftOut = DateTime.parse(
                                            seletedshift['outTime']!);
                                        DateTime AttendenceOut =
                                            DateTime.parse(match['timeOut']!);
                                        bool isAfter = (AttendenceOut.hour >
                                                ShiftOut.hour) ||
                                            (AttendenceOut.hour ==
                                                    ShiftOut.hour &&
                                                AttendenceOut.minute >
                                                    ShiftOut.minute);
                                        if (!isAfter) {
                                          Status.add(DailyReports(
                                              Employee: element['FirstName'],
                                              Date: DateFormat("dd-MM-yyyy")
                                                  .format(DateTime.parse(
                                                      CustomWidgets
                                                          .DateFormatchangeapi(
                                                              DateOFBirth
                                                                  .text))),
                                              Department:
                                                  element['departmentId']
                                                      ['name'],
                                              Status: "EarlyOut"));
                                        }
                                      }
                                    }
                                  } else {
                                    Status.add(DailyReports(
                                        Employee: element['FirstName'],
                                        Date: DateFormat("dd-MM-yyyy").format(
                                            DateTime.parse(CustomWidgets
                                                .DateFormatchangeapi(
                                                    DateOFBirth.text))),
                                        Department: element['departmentId']
                                            ['name'],
                                        Status: "Absent"));
                                  }
                                });
                                temp = Status;
                              }
                              if (DeparmentNamwe.text.isNotEmpty) {
                                Status = temp
                                    .where((element) =>
                                        element.Department ==
                                        DeparmentNamwe.text)
                                    .toList();
                              }
                              if (employeeName.text.isNotEmpty) {
                                Status = temp
                                    .where((element) =>
                                        element.Employee.toString() ==
                                        employeeName.text)
                                    .toList();
                              }
                              setState(() {});
                            },
                            height: Height / 20,
                            width: Width / 3,
                            text: "Save")
                      ],
                    ),
                    CustomWidgets.height(20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: DataTable(
                            columns: [
                              DataColumn(label: Text("No")),
                              DataColumn(label: Text("Employee Name")),
                              DataColumn(label: Text("Date")),
                              DataColumn(label: Text("Department")),
                              DataColumn(label: Text("Status")),
                            ],
                            rows: Status.map((entry) {
                              int index = Status.indexOf(entry) + 1;
                              return DataRow(cells: [
                                DataCell(Text(index.toString())),
                                DataCell(Text(entry.Employee)),
                                DataCell(Text(entry.Date)),
                                DataCell(Text(entry.Department)),
                                DataCell(Text(entry.Status,
                                    style: TextStyle(
                                        color: entry.Status == "Present"
                                            ? Colors.green
                                            : entry.Status == "Absent"
                                                ? Colors.red
                                                : entry.Status == "Late"
                                                    ? Colors.orange
                                                    : entry.Status == "EarlyOut"
                                                        ? Colors.blue
                                                        : null))),
                              ]);
                            }).toList()),
                      ),
                    )
                  ]),
                ),
              ));
  }

  AttendencePDF(List<DailyReports> e) async {
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
                        'Daily Report For ${DateFormat("dd MMMM yyyy").format(DateOFBirth.text.isEmpty ? DateTime.now() : DateTime.parse(DateFormat("dd-MM-yyyy").parse(DateOFBirth.text).toString()))}',
                        style: const pw.TextStyle(),
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
                  pw.Row(children: [
                    pw.Expanded(
                        child: pw.DecoratedBox(
                            decoration: pw.BoxDecoration(
                                border: pw.Border.all(width: 1)),
                            child: pw.Padding(
                                padding: pw.EdgeInsets.all(3),
                                child: pw.Text("No.",
                                    textAlign: pw.TextAlign.center)))),
                    pw.Expanded(
                        flex: 5,
                        child: pw.DecoratedBox(
                            decoration: pw.BoxDecoration(
                                border: pw.Border.all(width: 1)),
                            child: pw.Padding(
                                padding: pw.EdgeInsets.all(3),
                                child: pw.Text("Employee Name",
                                    textAlign: pw.TextAlign.center)))),
                    pw.Expanded(
                        flex: 2,
                        child: pw.DecoratedBox(
                            decoration: pw.BoxDecoration(
                                border: pw.Border.all(width: 1)),
                            child: pw.Padding(
                                padding: pw.EdgeInsets.all(3),
                                child: pw.Text("Date",
                                    textAlign: pw.TextAlign.center)))),
                    pw.Expanded(
                        flex: 5,
                        child: pw.DecoratedBox(
                            decoration: pw.BoxDecoration(
                                border: pw.Border.all(width: 1)),
                            child: pw.Padding(
                                padding: pw.EdgeInsets.all(3),
                                child: pw.Text("Department",
                                    textAlign: pw.TextAlign.center)))),
                    pw.Expanded(
                        flex: 2,
                        child: pw.DecoratedBox(
                            decoration: pw.BoxDecoration(
                                border: pw.Border.all(width: 1)),
                            child: pw.Padding(
                                padding: pw.EdgeInsets.all(3),
                                child: pw.Text("Status",
                                    textAlign: pw.TextAlign.center))))
                  ]),
                  pw.ListView.builder(
                      itemBuilder: (context, index) {
                        return pw.Row(children: [
                          pw.Expanded(
                              child: pw.DecoratedBox(
                                  decoration: pw.BoxDecoration(
                                      border: pw.Border.all(width: 1)),
                                  child: pw.Padding(
                                      padding: pw.EdgeInsets.all(3),
                                      child: pw.Text((index + 1).toString(),
                                          textAlign: pw.TextAlign.center)))),
                          pw.Expanded(
                              flex: 5,
                              child: pw.DecoratedBox(
                                  decoration: pw.BoxDecoration(
                                      border: pw.Border.all(width: 1)),
                                  child: pw.Padding(
                                      padding: pw.EdgeInsets.all(3),
                                      child: pw.Text(e[index].Employee,
                                          textAlign: pw.TextAlign.center)))),
                          pw.Expanded(
                              flex: 2,
                              child: pw.DecoratedBox(
                                  decoration: pw.BoxDecoration(
                                      border: pw.Border.all(width: 1)),
                                  child: pw.Padding(
                                      padding: pw.EdgeInsets.all(3),
                                      child: pw.Text(e[index].Date,
                                          textAlign: pw.TextAlign.center)))),
                          pw.Expanded(
                              flex: 5,
                              child: pw.DecoratedBox(
                                  decoration: pw.BoxDecoration(
                                      border: pw.Border.all(width: 1)),
                                  child: pw.Padding(
                                      padding: pw.EdgeInsets.all(3),
                                      child: pw.Text(e[index].Department,
                                          textAlign: pw.TextAlign.center)))),
                          pw.Expanded(
                              flex: 2,
                              child: pw.DecoratedBox(
                                  decoration: pw.BoxDecoration(
                                      border: pw.Border.all(width: 1)),
                                  child: pw.Padding(
                                      padding: pw.EdgeInsets.all(3),
                                      child: pw.Text(e[index].Status,
                                          style: pw.TextStyle(
                                              color: e[index].Status ==
                                                      "Present"
                                                  ? PdfColors.green
                                                  : e[index].Status == "Absent"
                                                      ? PdfColors.red
                                                      : e[index].Status ==
                                                              "Late"
                                                          ? PdfColors.orange
                                                          : e[index].Status ==
                                                                  "EarlyOut"
                                                              ? PdfColors.blue
                                                              : null),
                                          textAlign: pw.TextAlign.center))))
                        ]);
                      },
                      itemCount: e.length),
                  pw.SizedBox(height: 10),
                  pw.Container(
                      width: double.infinity,
                      decoration: pw.BoxDecoration(
                          border: pw.Border.all(
                              color: PdfColors.black, width: 1.5)),
                      padding: pw.EdgeInsets.all(5),
                      child: pw.Text(
                          "Note :- In case of attendance related query please contact HR Department")),
                  pw.SizedBox(height: 10),
                  pw.Text("  Approved Person Signature :-")
                ]),
          );
        },
      ),
    );
    savePdfAndShow(pdf);
  }

  Future<void> savePdfAndShow(pw.Document pdf) async {
    Directory dir = Directory("storage/emulated/0/Download");
    final path = '${dir.path}/Daily_report.pdf';

    final file = File(path);
    await file.writeAsBytes(await pdf.save());

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }
}

class DailyReports {
  String Employee = "EmployeeName";
  String Date = "Date";
  String Department = "Department";
  String Status = "Status";

  DailyReports({
    required this.Employee,
    required this.Date,
    required this.Department,
    required this.Status,
  });

  static Map<String, dynamic> toJson(DailyReports h) {
    return {
      "EmployeeName": h.Employee,
      "Date": h.Date,
      "Department": h.Department,
      "Status": h.Status
    };
  }
}
