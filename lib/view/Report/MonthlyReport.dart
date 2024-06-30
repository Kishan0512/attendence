import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../A_SQL_Trigger/Attendance_api.dart';
import '../../A_SQL_Trigger/Con_Usermast.dart';
import '../../A_SQL_Trigger/Employee_Add_api.dart';
import '../../utils/Constant/Colors.dart';
import '../../utils/Constant/LocalCustomWidgets.dart';
import '../../utils/Excel.dart';
import '../Dashboard/Dashboard.dart';
import 'Add_Leave_Report.dart';

class MonthlyReport extends StatefulWidget {
  const MonthlyReport({super.key});

  @override
  State<MonthlyReport> createState() => _MonthlyReportState();
}

class _MonthlyReportState extends State<MonthlyReport> {
  int internetConn = 0;
  double height = 0;
  double width = 0;
  TextEditingController date = TextEditingController();
  List<String> AllEmployee = [];
  List<dynamic> Employee = [];
  String Month = DateTime
      .now()
      .month
      .toString()
      .padLeft(2, '0'),
      Year = DateTime
          .now()
          .year
          .toString();
  List<dynamic> GetMonthRe = [];
  int present = 0,
      Absent = 0,
      Leave = 0,
      Late = 0;
  double prece = 0.0;

  @override
  void initState() {
    super.initState();
    getdata();
    cheakInternet();
  }

  getdata() async {
    GetMonthRe =
    await Attendance_api.AttendenceMonthlyReport(Month: Month, Year: Year);
    for (int i = 0; i < GetMonthRe[0]['Data'].length; i++) {
      AllEmployee.add("${GetMonthRe[0]['Data'][i]["FirstName"] + " " +
          GetMonthRe[0]['Data'][i]["LastName"]}");
    }
    setState(() {});
  }

  cheakInternet() async {
    internetConn = await CustomWidgets.CheakConnectionInternet();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery
        .of(context)
        .size
        .height - kToolbarHeight;
    width = MediaQuery
        .of(context)
        .size
        .width;
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
      child: Scaffold(
        appBar: CustomWidgets.appbar(
          title: "Monthly Report",
          action: [
            Constants_Usermast.statuse == "ADMIN"
                ? PopupMenuButton(
              shadowColor: Colorr.themcolor,
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    child: Text("Export as PDF"),
                    onTap: () {
                      AttendencePDF();
                    },
                  ),
                  PopupMenuItem(
                    child: Text("Export as Excel"),
                    onTap: () async {
                      var GetMonthRe =
                      await Attendance_api.AttendenceMonthlyReport(
                          Month: Month, Year: Year);
                      List<dynamic> Temp =
                      await AllEmployee_api.EmployeeSelect();
                      List<dynamic> EmployeeData = [];
                      EmployeeData = Temp.map((e) =>
                      {
                        "EmpID": "${e['_id']}",
                        "Name":
                        "${e["FirstName"] + " " + e["MiddelName"]}"
                      }).toList();
                      ExcelSheet.MonthlyReport(
                          context: context,
                          Month_Data: GetMonthRe,
                          Employee_Data: EmployeeData,
                          Months: Month,
                          Year: Year);
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
                return const Dashboard();
              },
            ));
          },
        ),
        body: mainwidget(),
      ),
    );
  }

  Widget mainwidget() {
    if (internetConn == 1) {
      return GetMonthRe.isNotEmpty
          ? SizedBox(
        height: height,
        width: width,
        child: Column(children: [
          CustomWidgets.height(10),
          CustomWidgets.textField(
              hintText: "Select Month",
              readOnly: true,
              controller: date,
              suffixIcon: InkWell(
                  onTap: () =>
                      showDialog(
                        context: context,
                        builder: (context) {
                          return MonthYearPickerDialog(
                            onMonthYearSelected:
                                (int selectedMonth, int selectedYear) {
                              date.text =
                              "${selectedMonth.toString().padLeft(
                                  2, "0")}-$selectedYear";
                              Month = selectedMonth
                                  .toString()
                                  .padLeft(2, "0");
                              Year = selectedYear.toString();
                              setState(() {});
                            },
                          );
                        },
                      ),
                  child: CustomWidgets.DateIcon())),
          CustomWidgets.height(5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomWidgets.confirmButton(
                  onTap: () {
                    date.text = "";
                    getdata();
                    setState(() {});
                  },
                  height: height / 20,
                  width: width / 3,
                  text: "Reset",
                  Clr: Colorr.Reset),
              CustomWidgets.width(5),
              CustomWidgets.confirmButton(
                  onTap: () async {
                    AllEmployee.clear();
                    getdata();
                    setState(() {});
                  },
                  height: height / 20,
                  width: width / 3,
                  text: "Search")
            ],
          ),
          Expanded(
            child: Container(
                child: GetMonthRe.isNotEmpty
                    ? SingleChildScrollView(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                        columnSpacing: 20,
                        columns: [
                          const DataColumn(
                              label: Center(child: Text("No"))),
                          const DataColumn(
                              label: Center(
                                  child: Text("Employee Name"))),
                          for (int i = 1; i <= GetMonthRe.length; i++)
                            DataColumn(label: Center(
                                child: Text(i.toString()))),
                          const DataColumn(label: Center(child: Text("Present"),)),
                          const DataColumn(label: Center(child: Text("Late"),)),
                          const DataColumn(label: Center(child: Text("Absent"),)),
                          const DataColumn(label: Center(child: Text("Leave"),)),
                          const DataColumn(label: Center(child: Text("Percentage"),)),
                        ],
                        rows: AllEmployee
                            .asMap()
                            .entries
                            .map((entry) {
                          present = 0;
                          Absent = 0;
                          Leave = 0;
                          Late = 0;
                          prece = 0;
                          int index = entry.key + 1;
                          final e = entry.value;
                          List<DataCell> cells = [
                            DataCell(Center(child: Text(index.toString()))),
                            DataCell(Center(child: Text(e))),
                          ];
                          for (int i = 1; i <= GetMonthRe.length; i++) {
                            cells.add(
                                DataCell(
                                  Center(
                                    child: Text(
                                      GetMonthRe[i - 1]['Data'][entry
                                          .key]['Status'],
                                      style: TextStyle(
                                        color: GetMonthRe[i - 1]['Data'][entry
                                            .key]['Status'] == "A"
                                            ? Colors.red
                                            : GetMonthRe[i - 1]['Data'][entry
                                            .key]['Status'] == "P"
                                            ? Colors.green
                                            : GetMonthRe[i - 1]['Data'][entry
                                            .key]['Status'] == "LA"
                                            ? Colors.brown
                                            : GetMonthRe[i - 1]['Data'][entry
                                            .key]['Status'] == "L"
                                            ? Colors.blue
                                            : Colors.purple,
                                      ),
                                    ),
                                  ),
                                ));
                            GetMonthRe[i - 1]['Data'][entry.key]['Status'] ==
                                "A"
                                ? Absent++
                                : GetMonthRe[i - 1]['Data'][entry
                                .key]['Status'] == "P"
                                ? present++
                                : GetMonthRe[i - 1]['Data'][entry
                                .key]['Status'] == "LA"
                                ? Late++
                                : GetMonthRe[i - 1]['Data'][entry
                                .key]['Status'] == "L"
                                ? Leave++
                                : null;

                            if (i == GetMonthRe.length) {
                              prece = present / GetMonthRe.length * 100;
                            }
                          }
                          cells.addAll([
                            DataCell(Center(child: Text(present.toString()))),
                            DataCell(Center(child: Text(Late.toString()))),
                            DataCell(Center(child: Text(Absent.toString()))),
                            DataCell(Center(child: Text(Leave.toString()))),
                            DataCell(Center(child: Text(
                              "${prece.toStringAsFixed(2)}%",
                              style: const TextStyle(fontWeight: FontWeight.bold),))),
                          ]);
                          return DataRow(cells: cells);
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

  AttendencePDF() async {
    final pdf = pw.Document();
    final image = await imageFromAssetBundle('images/Attendy Logo.webp');
    pdf.addPage(
      pw.Page(margin: const pw.EdgeInsets.all(10),
        orientation: pw.PageOrientation.landscape,
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Center(child: pw.Container(
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
                          '374 B, Surya Mill Compound,Behind Rajhans Point',
                          style: const pw.TextStyle()),
                      pw.SizedBox(height: 10),
                      pw.Text(
                        'Monthly Attendance For ${DateFormat('MMM-yyyy').format(
                            DateTime.parse(DateFormat('MM-yyyy')
                                .parse("$Month-$Year")
                                .toString()))}',
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
                  pw.Table(children: [
                    pw.TableRow(children: [
                      pw.Container(child: pw.Text("Employee Name", style: const pw.TextStyle(
                          fontSize: 10)),
                          height: 15,
                          width: 100,
                          alignment: pw.Alignment.center,
                          decoration: pw.BoxDecoration(border: pw.Border.all(
                              width: 0.5))),
                      for(int i = 1; i <= GetMonthRe.length; i++)
                        pw.Container(child: pw.Text(i.toString(), style: const pw
                            .TextStyle(fontSize: 10)),
                            height: 15,
                            width: 15,
                            alignment: pw.Alignment.center,
                            decoration: const pw.BoxDecoration(border: pw.Border(
                                right: pw.BorderSide(width: 0.5),
                                top: pw.BorderSide(width: 0.5),
                                bottom: pw.BorderSide(width: 0.5)))),
                      pw.Container(child: pw.Text("P", style: const pw.TextStyle(
                          fontSize: 10)),
                          height: 15,
                          width: 20,
                          alignment: pw.Alignment.center,
                          decoration: const pw.BoxDecoration(border: pw.Border(
                              right: pw.BorderSide(width: 0.5),
                              bottom: pw.BorderSide(width: 0.5),
                              top: pw.BorderSide(width: 0.5)))),
                      pw.Container(child: pw.Text("A", style: const pw.TextStyle(
                          fontSize: 10)),
                          height: 15,
                          width: 20,
                          alignment: pw.Alignment.center,
                          decoration: const pw.BoxDecoration(border: pw.Border(
                              right: pw.BorderSide(width: 0.5),
                              bottom: pw.BorderSide(width: 0.5),
                              top: pw.BorderSide(width: 0.5)))),
                      pw.Container(child: pw.Text("LA", style: const pw.TextStyle(
                          fontSize: 10)),
                          height: 15,
                          width: 20,
                          alignment: pw.Alignment.center,
                          decoration: const pw.BoxDecoration(border: pw.Border(
                              right: pw.BorderSide(width: 0.5),
                              bottom: pw.BorderSide(width: 0.5),
                              top: pw.BorderSide(width: 0.5)))),
                      pw.Container(child: pw.Text("L", style: const pw.TextStyle(
                          fontSize: 10)),
                          height: 15,
                          width: 20,
                          alignment: pw.Alignment.center,
                          decoration: const pw.BoxDecoration(border: pw.Border(
                              right: pw.BorderSide(width: 0.5),
                              bottom: pw.BorderSide(width: 0.5),
                              top: pw.BorderSide(width: 0.5)))),
                      pw.Container(child: pw.Text("%", style: const pw.TextStyle(
                          fontSize: 10)),
                          height: 15,
                          width: 30,
                          alignment: pw.Alignment.center,
                          decoration: const pw.BoxDecoration(border: pw.Border(
                              right: pw.BorderSide(width: 0.5),
                              bottom: pw.BorderSide(width: 0.5),
                              top: pw.BorderSide(width: 0.5)))),
                    ])
                  ]),
                  pw.Table(children: AllEmployee
                      .asMap()
                      .entries
                      .map((emplo) {
                    int P = 0;
                    int L = 0;
                    int LA = 0;
                    int A = 0;
                    double Per = 0;
                    int index = emplo.key;
                    String item = emplo.value;
                    for (int i = 0; i < GetMonthRe.length; i++) {
                      GetMonthRe[i]['Data'][index]['Status'] == "A" ? A++ :
                      GetMonthRe[i]['Data'][index]['Status'] == "P" ? P++ :
                      GetMonthRe[i]['Data'][index]['Status'] == "L" ? L++ :
                      GetMonthRe[i]['Data'][index]['Status'] == "LA"
                          ? LA++:null;
                      if (i == GetMonthRe.length - 1) {
                        Per = P / GetMonthRe.length * 100;
                      }
                    }
                    return pw.TableRow(children: [
                      pw.Container(child: pw.Text(
                          item, style: const pw.TextStyle(fontSize: 10)),
                          height: 15,
                          width: 100,
                          alignment: pw.Alignment.center,
                          decoration: const pw.BoxDecoration(border: pw.Border(
                              bottom: pw.BorderSide(width: 0.5),
                              right: pw.BorderSide(width: 0.5),
                              left: pw.BorderSide(width: 0.5)))),
                      for(int i = 0; i < GetMonthRe.length; i++)
                        pw.Container(child: pw.Text(
                            GetMonthRe[i]['Data'][index]['Status'],
                            style: pw.TextStyle(
                              fontSize: 10,
                              color: GetMonthRe[i]['Data'][index]['Status'] ==
                                  "A" ? PdfColors.red :
                              GetMonthRe[i]['Data'][index]['Status'] == "P"
                                  ? PdfColors.green
                                  :
                              GetMonthRe[i]['Data'][index]['Status'] == "L"
                                  ? PdfColors.blue
                                  :
                              GetMonthRe[i]['Data'][index]['Status'] == "LA"
                                  ? PdfColors.brown
                                  : PdfColors.purple,
                            )),
                            height: 15,
                            width: 15,
                            alignment: pw.Alignment.center,
                            decoration: const pw.BoxDecoration(border: pw.Border(
                                right: pw.BorderSide(width: 0.5),
                                top: pw.BorderSide(width: 0.5),
                                bottom: pw.BorderSide(width: 0.5)))),
                      pw.Container(child: pw.Text(
                          P.toString(), style: const pw.TextStyle(fontSize: 10)),
                          height: 15,
                          width: 20,
                          alignment: pw.Alignment.center,
                          decoration: const pw.BoxDecoration(border: pw.Border(
                              right: pw.BorderSide(width: 0.5),
                              bottom: pw.BorderSide(width: 0.5),
                              top: pw.BorderSide(width: 0.5)))),
                      pw.Container(child: pw.Text(
                          A.toString(), style: const pw.TextStyle(fontSize: 10)),
                          height: 15,
                          width: 20,
                          alignment: pw.Alignment.center,
                          decoration: const pw.BoxDecoration(border: pw.Border(
                              right: pw.BorderSide(width: 0.5),
                              bottom: pw.BorderSide(width: 0.5),
                              top: pw.BorderSide(width: 0.5)))),
                      pw.Container(child: pw.Text(
                          LA.toString(), style: const pw.TextStyle(fontSize: 10)),
                          height: 15,
                          width: 20,
                          alignment: pw.Alignment.center,
                          decoration: const pw.BoxDecoration(border: pw.Border(
                              right: pw.BorderSide(width: 0.5),
                              bottom: pw.BorderSide(width: 0.5),
                              top: pw.BorderSide(width: 0.5)))),
                      pw.Container(child: pw.Text(
                          L.toString(), style: const pw.TextStyle(fontSize: 10)),
                          height: 15,
                          width: 20,
                          alignment: pw.Alignment.center,
                          decoration: const pw.BoxDecoration(border: pw.Border(
                              right: pw.BorderSide(width: 0.5),
                              bottom: pw.BorderSide(width: 0.5),
                              top: pw.BorderSide(width: 0.5)))),
                      pw.Container(child: pw.Text("${Per.toStringAsFixed(1)}%",
                          style: const pw.TextStyle(fontSize: 10)),
                          height: 15,
                          width: 30,
                          alignment: pw.Alignment.center,
                          decoration: const pw.BoxDecoration(border: pw.Border(
                              right: pw.BorderSide(width: 0.5),
                              bottom: pw.BorderSide(width: 0.5),
                              top: pw.BorderSide(width: 0.5)))),
                    ]);
                  }).toList(),),
                ]),
          ));
        },
      ),
    );
    savePdfAndShow(pdf);
  }

  Future<void> savePdfAndShow(pw.Document pdf,) async {
    final dir = await getExternalStorageDirectory();
    final path = '${dir!.path}/Monthly_report${DateTime.now()}.pdf';

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
