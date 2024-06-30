import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:attendy/A_SQL_Trigger/api_page.dart';
import 'package:attendy/utils/Constant/LocalCustomWidgets.dart';
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
import '../../A_SQL_Trigger/EmployeeSalary_api.dart';
import '../../A_SQL_Trigger/Employee_Add_api.dart';
import '../../utils/Constant/Colors.dart';
import '../../utils/DroupDown/custom_dropdown.dart';
import '../Dashboard/Dashboard.dart';
import 'Add_Leave_Report.dart';

class PayslipReport extends StatefulWidget {
  const PayslipReport({Key? key}) : super(key: key);

  @override
  State<PayslipReport> createState() => _PayslipReportState();
}

class _PayslipReportState extends State<PayslipReport> {
  String Month1 = "";
  int _selectedMonth = 0;
  int _selectedYear = 0;
  String Year1 = "";
  Uint8List? Logo;
  final pdf = pw.Document();
  TextEditingController employeeName = TextEditingController();
  TextEditingController Year = TextEditingController();
  List<String> AllEmployee = [];
  List<dynamic> Company = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  getdata() async {
    Con_List.AllEmployee = await AllEmployee_api.EmployeeSelect();
    Con_List.EmployeeSalary = await EmployeeSalary_api.EmployeeSalarySelect();
    Con_List.CompanySelect = await api_page.CompanySelect();
    Company = Con_List.CompanySelect.where((element) => element['_id'].toString()==Constants_Usermast.companyId.toString()).toList();
    Con_List.AllEmployee.forEach((element) {
      if (element['isActive'] == true) {
        AllEmployee.add(element['FirstName']);
      }
    });
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
                  title: "Payslip Report",
                  action: [],
                  context: context,
                  onTap: () {
                    Navigator.pushReplacement(context, CupertinoPageRoute(
                      builder: (context) {
                        return Dashboard();
                      },
                    ));
                  },
                ),
                child: Container(
                  child: Column(children: [
                    Container(
                      width: double.infinity,
                      height: Height / 4,
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
                            controller: Year,
                            hintText: "Month & Year",
                            suffix: GestureDetector(
                                onTap: () {
                                  showCupertinoModalPopup(
                                    context: context,
                                    builder: (BuildContext context) {
                                      int selectedMonth = DateTime.now().month;
                                      int selectedYear = DateTime.now().year;
                                      return Container(
                                        height: Height / 3.5,
                                        color: Colors.white,
                                        child: Column(children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: 200,
                                                width: 150,
                                                child: CupertinoPicker(
                                                  itemExtent: 40.0,
                                                  onSelectedItemChanged:
                                                      (int index) {
                                                    setState(() {
                                                      Month1 = index.toString();
                                                      Year.text =
                                                          "${Month1} & ${Year1}";
                                                    });
                                                  },
                                                  children:
                                                      List<Widget>.generate(12,
                                                          (int index) {
                                                    final month = index + 1;
                                                    return Center(
                                                      child: Text(
                                                        '${_getMonthName(month)}',
                                                        style: TextStyle(
                                                            fontSize: 16.0),
                                                      ),
                                                    );
                                                  }),
                                                ),
                                              ),
                                              Container(
                                                height: 200,
                                                width: 100,
                                                child: CupertinoPicker(
                                                  itemExtent: 40.0,
                                                  onSelectedItemChanged:
                                                      (int index) {
                                                    setState(() {
                                                      int i =
                                                          DateTime.now().year -
                                                              5 +
                                                              index;
                                                      Year1 = i.toString();
                                                      Year.text =
                                                          "${Month1} & ${Year1}";
                                                      setState(() {});
                                                      ;
                                                    });
                                                  },
                                                  children:
                                                      List<Widget>.generate(10,
                                                          (int index) {
                                                    final year =
                                                        DateTime.now().year -
                                                            5 +
                                                            index;
                                                    return Center(
                                                      child: Text(
                                                        '$year',
                                                        style: TextStyle(
                                                            fontSize: 16.0),
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
                        CustomWidgets.height(5),
                        Row(
                          children: [
                            Expanded(flex: 2, child: SizedBox(width: 5)),
                            Expanded(
                              flex: 2,
                              child: CupertinoButton(
                                color: Colorr.Reset,
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  Year.text = "";
                                  employeeName.text = "";
                                  setState(() {});
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
                        CustomWidgets.height(8)
                      ]),
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(left: 5, right: 5),
                        margin: EdgeInsets.only(top: 10),
                        decoration:
                            BoxDecoration(color: Colorr.White, boxShadow: [
                          BoxShadow(
                            color: Colorr.themcolor100,
                            blurStyle: BlurStyle.outer,
                            blurRadius: 8,
                          ),
                        ]),
                      ),
                    ),
                  ]),
                ))
            : Scaffold(
                appBar: CustomWidgets.appbar(
                  title: "Payslip Report",
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
                body: Column(children: [
                  CustomWidgets.height(10),
                  CustomDropdown.search(
                    listItemStyle: CustomWidgets.style(),
                    hintText: 'Select Employee',
                    controller: employeeName,
                    items: AllEmployee,onChanged: (p0) {
                    Con_List.AllEmployee = Con_List.AllEmployee.firstWhere((element) => element['FirstName']==employeeName);
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
                                      (int selectedMonth, int selectedYear) {
                                    String Monthname =
                                        _getMonthName(selectedMonth);
                                    Year.text = "$Monthname,$selectedYear";
                                    Month1 = Monthname.toString();
                                    Year1 = selectedYear.toString();
                                    setState(() {});
                                  },
                                );
                              },
                            );
                          },
                          child: CustomWidgets.DateIcon()),
                      readOnly: true),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomWidgets.confirmButton(
                          onTap: () {
                            Year.text = "";
                            employeeName.text = "";
                            getdata();
                            setState(() {});
                          },
                          height: Height / 20,
                          width: Width / 3,
                          text: "Reset",
                          Clr: Colorr.Reset),
                      CustomWidgets.width(5),
                      CustomWidgets.confirmButton(
                          onTap: () {},
                          height: Height / 20,
                          width: Width / 3,
                          text: "Search")
                    ],
                  ),
                  CustomWidgets.height(20),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                          columns: const [
                            DataColumn(label: Text("No")),
                            DataColumn(label: Text("Employee Name")),
                            DataColumn(label: Text("Employee ID")),
                            DataColumn(label: Text("Email")),
                            DataColumn(label: Text("Joining Date")),
                            DataColumn(label: Text("Role")),
                            DataColumn(label: Text("Salary")),
                            DataColumn(label: Text("PDF")),
                          ],
                          rows:
                              Con_List.AllEmployee.asMap().entries.map((entry) {
                            int index = entry.key + 1;
                            final e = entry.value;
                            String formattedDate = DateFormat('dd-MM-yyyy')
                                .format(
                                    DateTime.parse(e['JoiningDate'].toString())
                                        .toLocal());
                            String Salary = Con_List.EmployeeSalary.firstWhere(
                              (element) => element['employeeId'] == e['_id'],
                              orElse: () => {"salary": ""},
                            )['salary']
                                .toString();
                            return DataRow(cells: [
                              DataCell(Text(index.toString())),
                              DataCell(Text(e['FirstName'])),
                              DataCell(Text(e['_id'])),
                              DataCell(Text(e['Email'])),
                              DataCell(Text(formattedDate)),
                              DataCell(Text(e['roleId']['name'])),
                              DataCell(Text(Salary)),
                              DataCell(InkWell(
                                  radius: 30,
                                  enableFeedback: true,
                                  onTap: () {
                                    PayslipPDF(e);
                                  },
                                  child: Image.asset(
                                      height: Width / 15,
                                      width: Width / 15,
                                      fit: BoxFit.fill,
                                      "images/pdf.png")))
                            ]);
                          }).toList()),
                    ),
                  )
                ]),
              ));
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

  PayslipPDF(dynamic e) async {
    final pdf = pw.Document();
    final image = await imageFromAssetBundle('images/Attendy Logo.webp');
    // String Temp = Company[0]['logo'];
    // if (Temp != "") {
    //   if (Temp.contains("data:image")) {
    //     Logo = base64.decode(Temp.split(',')[1]);
    //   } else {
    //     Logo = base64.decode(Temp);
    //   }
    // }
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
                        Logo!=null?pw.MemoryImage(Logo!):
                        image,
                        height: 60,
                        width: 60,
                      ),
                    ]),
                    pw.Spacer(),
                    pw.Column(children: [
                      pw.Text(Company[0]['name'],
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
                        Logo!=null?pw.MemoryImage(Logo!):
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
                                        "PF No.     : ${e['PFno']==null?"":e['PFno']}",
                                      ),
                                      pw.SizedBox(height: 5),
                                      pw.Text(
                                        "ESIC No. : ${e['ESICno']==null?"":e['ESICno']}",
                                      ),
                                      pw.SizedBox(height: 5),
                                      pw.Text(
                                        "UIN No    : ${e['UNno']==null?"":e['UNno']}",
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
                                    child: pw.Text("Earnings",style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                              ),
                              pw.Expanded(
                                flex: 1,
                                child: pw.Container(
                                    padding: pw.EdgeInsets.all(5),
                                    decoration: pw.BoxDecoration(
                                        border: pw.Border.all(
                                            color: PdfColors.black, width: 2)),
                                    child: pw.Text("Amount",style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                              ),
                              pw.Expanded(
                                flex: 2,
                                child: pw.Container(
                                    padding: pw.EdgeInsets.all(5),
                                    decoration: pw.BoxDecoration(
                                        border: pw.Border.all(
                                            color: PdfColors.black, width: 2)),
                                    child: pw.Text("Deductions",style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                              ),
                              pw.Expanded(
                                flex: 1,
                                child: pw.Container(
                                    padding: pw.EdgeInsets.all(5),
                                    decoration: pw.BoxDecoration(
                                        border: pw.Border.all(
                                            color: PdfColors.black, width: 2)),
                                    child: pw.Text("Amount",style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
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
