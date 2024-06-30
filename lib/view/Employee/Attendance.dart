import 'package:attendy/A_SQL_Trigger/Attendance_api.dart';
import 'package:attendy/A_SQL_Trigger/Con_Usermast.dart';
import 'package:attendy/utils/Constant/Colors.dart';
import 'package:attendy/utils/Constant/FontWeight.dart';
import 'package:attendy/utils/Constant/LocalCustomWidgets.dart';
import 'package:attendy/view/Report/Add_Leave_Report.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart';
import 'package:intl/intl.dart';

import '../../A_SQL_Trigger/Con_List.dart';
import '../../A_SQL_Trigger/Employee_Add_api.dart';
import '../../utils/Constant/Con_icon.dart';
import '../../utils/DroupDown/custom_dropdown.dart';
import '../Dashboard/Dashboard.dart';
import '../UiScreen/DrawerScreens/Attendance_tabs.dart';
import '../UiScreen/DrawerScreens/Salary_tabs.dart';

class Attendance extends StatefulWidget {
  const Attendance({Key? key}) : super(key: key);

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  String Month1="";
  String Year1="";
  TextEditingController Year = TextEditingController();
  TextEditingController employeeName = TextEditingController();
  TextEditingController Date = TextEditingController();
  var size, height, width;
  List<String> AllEmployee= [];
  DateTime now = DateTime.now();
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }
  getdata()
  async {
    Con_List.AllEmployee = await AllEmployee_api.EmployeeSelect();
    Con_List.AllEmployee.forEach((element) {
      if(element['isActive']==true)
      {
        AllEmployee.add(element['FirstName']);
      }
    });
    Con_List.AllAttandance = await Attendance_api.AttendanceSelect();
    setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {
    int day = now.day;
    List dataList = List.generate(day, (index) => index + 1);
    dataList.insert(0, "No");
    dataList.insert(1, "Employee Name");
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    Future<bool> onBackPress() {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return Dashboard();
      },));
      return Future.value(false);
    }
    return WillPopScope(
        onWillPop: () => onBackPress(),
    child:Constants_Usermast.IOS==true? CupertinoPageScaffold(navigationBar: CustomWidgets.appbarIOS(title: "Attendance", action: [], context: context, onTap: () {
      Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) {
        return Dashboard();
      },));
    },),
    child: Container(
      height: height,
      width:width,
      child: Column(children: [
        CustomWidgets.height(10),
        CustomWidgets.textFieldIOS(hintText: "Select Employee",controller: employeeName,readOnly: true,onTap: () {
          CustomWidgets.SelectDroupDown(context: context,items: AllEmployee, onSelectedItemChanged: (int) {
            employeeName.text=AllEmployee[int];
            setState(() {
            });
          });
        },suffix: CustomWidgets.aarowCupertinobutton(),),
        CustomWidgets.textFieldIOS(
            hintText: "Select Date",
            readOnly: true,
            controller: Date,
            suffix: GestureDetector(
                onTap: () => CustomWidgets.selectDateIOS(context: context,controller: Date),
                child: CustomWidgets.DateIconIOS())),
        CustomWidgets.textFieldIOS(
            hintText: "Month & Year",
            readOnly: true,
            controller: Year,
            suffix: GestureDetector(
                onTap: () {
                  showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      int selectedMonth = DateTime.now().month;
                      int selectedYear = DateTime.now().year;
                      return CupertinoAlertDialog(
                        title: Text(
                          'Select Month and Year',
                          style: TextStyle(color: CupertinoColors.systemBlue),
                        ),
                        content: Container(
                          height: 250,
                          child: CupertinoDatePicker(
                            mode: CupertinoDatePickerMode.date,
                            initialDateTime: DateTime.now(),
                            minimumYear: 2010,
                            maximumYear: 2100,
                            onDateTimeChanged: (DateTime dateTime) {
                              selectedMonth = dateTime.month;
                              selectedYear = dateTime.year;
                            },
                          ),
                        ),
                        actions: [
                          CupertinoDialogAction(
                            child: Text('OK'),
                            onPressed: () {
                              Year.text = '$selectedMonth, $selectedYear';
                              Month1 = selectedMonth.toString();
                              Year1 = selectedYear.toString();
                              setState(() {});
                              Navigator.of(context).pop();
                            },
                          ),
                          CupertinoDialogAction(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );

                },
                child: CustomWidgets.DateIconIOS())),
        CustomWidgets.height(10),
        Row(mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Container(
            alignment: Alignment.center,
            height: height*0.06,
            width: width/3,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),color: Colorr.themcolor,),
            padding:EdgeInsets.zero,
            child: Text("Search",style: TextStyle(color: Colorr.White)),)
        ],),
        Expanded(child: Container(
            child:  Con_List.AllAttandance.isNotEmpty
                ? SingleChildScrollView(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                    columns:dataList.map((item) => DataColumn(label: Text(item.toString()))).toList(),
                    rows: Con_List.AllAttandance.map((e) {
                      String name = e['employeeId']['FirstName'].toString();
                      return DataRow(cells: dataList.map((element) {
                        String cellValue = '';
                        if (element == "No") {
                          cellValue = "0";
                        } else if (element == "Employee Name") {
                          cellValue = name;
                        } else {
                          // Handle additional columns if needed
                          // cellValue = ...
                        }
                        return DataCell(Text(cellValue));
                      }, ).toList());
                    }).toList()),
              ),
            )
                : Container()),
        )
      ]),
    )): Scaffold(
      appBar: CustomWidgets.appbar(title: "Attendance" ,action: [
      ],context:  context,onTap: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return Dashboard();
        },));
      },

      ),
      body: Constants_Usermast.statuse=="ADMIN" ?
      Container(
        height: height,
        width:width,
        child: Column(
            children: [
          CustomWidgets.height(10),
          CustomDropdown.search(  listItemStyle: CustomWidgets.style(),
            hintText: 'Select Employee',
            controller: employeeName,
            items: AllEmployee,
          ),
          CustomWidgets.textField(hintText: "Select Date",readOnly: true,controller: Date,suffixIcon: InkWell(onTap: () => CustomWidgets.selectDate(context: context, controller: Date),child: CustomWidgets.DateIcon())),
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
                            Year.text = "$selectedMonth,$selectedYear";
                            Month1 = selectedMonth.toString();
                            Year1=selectedYear.toString();
                            setState(() {});
                          },
                        );
                      },
                    );
                  },
                  child: CustomWidgets.DateIcon()),
              readOnly: true),
          CustomWidgets.height(5),
          Row(mainAxisAlignment:MainAxisAlignment.center,
            children: [
              CustomWidgets.confirmButton(onTap: () {
                employeeName.text="";
                Year.text="";
                Date.text="";
                setState(() {

                });
              }, height: height/23, width: width/3.6, text: "Reset",Clr: Colorr.Reset),
            CustomWidgets.width(5),
            CustomWidgets.confirmButton(onTap: () {

            }, height: height/23, width: width/3.6, text: "Search")
          ],),
          CustomWidgets.height(width*0.03),
          Expanded(child: Container(
            child:  Con_List.AllAttandance.isNotEmpty
                ? SingleChildScrollView(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                    columns:dataList.map((item) => DataColumn(label: Text(item.toString()))).toList(),
                    rows: Con_List.AllAttandance.asMap().entries.map((entry) {
                      int index = entry.key + 1;
                      final e = entry.value;
                      String name =  e.containsKey('FirstName') ? e['FirstName']: e['employeeData'][0]['FirstName'];
                      return DataRow(cells: dataList.map((element) {
                        String cellValue = '';
                        if (element == "No") {
                          cellValue = index.toString();
                        } else if (element == "Employee Name") {
                          cellValue = name;
                        } else {
                          // Handle additional columns if needed
                          // cellValue = ...-

                        }
                        return DataCell(Text(cellValue));
                      }, ).toList());
                    }).toList()),
              ),
            )
                : Container()),
          )
        ]),
      ) :
      Container(
        height: height,
        width:width,
        child: Column(children: [
          CustomWidgets.textField(hintText: "Select Date",readOnly: true,controller: Date,suffixIcon: InkWell(onTap: () => CustomWidgets.selectDate(context: context, controller: Date),child: CustomWidgets.DateIcon())),
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
                                String Monthname =_getMonthName(selectedMonth);
                            Year.text = "$selectedMonth,$selectedYear";
                            Month1 = selectedMonth.toString();
                            Year1=selectedYear.toString();
                            setState(() {});
                          },
                        );
                      },
                    );
                  },
                  child: CustomWidgets.DateIcon()),
              readOnly: true),
          CustomWidgets.height(5),
          Row(mainAxisAlignment:MainAxisAlignment.center,
            children: [
              CustomWidgets.confirmButton(onTap: () {

              }, height: height/20, width: width/3, text: "Search")
            ],),
          Expanded(child: Container(
              child:  Con_List.AllAttandance.isNotEmpty
                  ? SingleChildScrollView(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                      columns:[
                        DataColumn(label: Text("No")),
                        DataColumn(label: Text("Date")),
                        DataColumn(label: Text("Punch In")),
                        DataColumn(label: Text("Punch Out")),
                        DataColumn(label: Text("Production")),
                      ],
                      rows: Con_List.AllAttandance.asMap().entries.map((entry) {
                        int index = entry.key + 1;
                        final e = entry.value;
                        String formattedTime="";
                        String formattedTime1="";
                        if (e['timeIn'] != null) {
                          String timeim = e['timeIn'].toString();
                          DateTime t = DateTime.parse(timeim).toLocal();
                          String formattedDateTime = DateFormat('yyyy-MM-dd hh:mm:ss a').format(t);
                          DateTime dateTime = DateFormat('yyyy-MM-dd hh:mm:ss a').parse(formattedDateTime);
                          formattedTime =  DateFormat('hh:mm a').format(dateTime);
                        }
                        if (e['timeOut'] != null) {
                          String timeout = e['timeOut'].toString();
                          DateTime t = DateTime.parse(timeout).toLocal();
                          String formattedDateTime = DateFormat('yyyy-MM-dd hh:mm:ss a').format(t);
                          DateTime dateTime = DateFormat('yyyy-MM-dd hh:mm:ss a').parse(formattedDateTime);
                          formattedTime1 =  DateFormat('hh:mm a').format(dateTime);
                        }
                        return DataRow(cells: [
                          DataCell(Text(index.toString())),
                          DataCell(Text(e['createdAt'].toString().substring(0,10))),
                          DataCell(Text(formattedTime)),
                          DataCell(Text(formattedTime1)),
                          DataCell(Text("")),
                        ]);
                      }).toList()),
                ),
              )
                  : Container()),
          )
        ]),
      ) ,
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
}
