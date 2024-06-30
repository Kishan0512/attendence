// ignore_for_file: use_build_context_synchronously

import 'package:attendy/A_SQL_Trigger/Resigantion_api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../Modal/All_import.dart';
import '../../utils/DroupDown/custom_dropdown.dart';
import '../Announcement/Add_Announcement.dart';
import '../Dashboard/Dashboard.dart';

class Resignation extends StatefulWidget {
  const Resignation({super.key});

  @override
  State<Resignation> createState() => _ResignationState();
}

class _ResignationState extends State<Resignation> {
  TextEditingController Employee = TextEditingController();
  TextEditingController ResigDate = TextEditingController();
  TextEditingController LastDate = TextEditingController();
  TextEditingController LastDateAdmin = TextEditingController();
  TextEditingController Reason = TextEditingController();
  List<String> Emp = [];
  String id ="";
  bool update = false;
  DateTime? fromDate;
  DateTime? toDate;
  DateTime? toDateAd;
  double height = 0;
  double width = 0;
  String group = "Accept";
List<dynamic> Resignation = [];
  get() async {
    Resignation = await Resignation_Api.ResiganationSelect();
    Con_List.AllEmployee = await AllEmployee_api.EmployeeSelect();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    get();
    if (Constants_Usermast.statuse == "ADMIN") {
      Emp = Con_List.AllEmployee.map((e) => e['FirstName'].toString()).toList();
    } else {
      Employee.text = Con_List.AllEmployee.where((element) =>
              element['_id'].toString() ==
              Constants_Usermast.employeeId.toString())
          .first
          .e['FirstName']
          .toString();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height - kToolbarHeight;
    double width = MediaQuery.of(context).size.width;
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
      child: Scaffold(
        appBar: CustomWidgets.appbar(
          title: "Resignation",
          action: [],
          context: context,
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return Dashboard();
              },
            ));
          },
        ),
        body: Column(children: [
          Constants_Usermast.statuse != "ADMIN"
              ? CustomWidgets.textField(
                  controller: Employee,
                  hintText: "Employee",
                )
              : CustomDropdown.search(
                  listItemStyle: CustomWidgets.style(),
                  hintText: 'Select Employee',
                  controller: Employee,
                  items: Emp,
                ),
          CustomWidgets.textField(
              hintText: "Resignation Date",
              readOnly: true,
              controller: ResigDate,
              suffixIcon: InkWell(
                  onTap: () => _selectDate(context, "FromDate"),
                  child: CustomWidgets.DateIcon())),
          CustomWidgets.textField(
              hintText: "Last Working Date",
              readOnly: true,
              controller: LastDate,
              suffixIcon: InkWell(
                  onTap: () => _selectDate1(context, "ToDate"),
                  child: CustomWidgets.DateIcon())),
          CustomWidgets.textField(
            Alignment1: Alignment.topCenter,
            maxLines: 5,
            textAlignVertical: TextAlignVertical.top,
            textAlign: TextAlign.start,
            height: height / 7,
            controller: Reason,
            hintText: "Reason",
          ),
          Constants_Usermast.statuse == "ADMIN"
              ? CustomWidgets.textField(
                  hintText: "Last Working Date By Administration",
                  readOnly: true,
                  controller: LastDateAdmin,
                  suffixIcon: InkWell(
                      onTap: () => _selectDate2(context, "ToDate"),
                      child: CustomWidgets.DateIcon()))
              : Container(),
          Constants_Usermast.statuse == "ADMIN"
              ? Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Row(
                    children: [
                      Radio(
                          activeColor: Colors.green,
                          value: "Accept",
                          groupValue: group,
                          onChanged: (value) {
                            setState(() {
                              group = value!;
                            });
                          }),
                      const Text("Accept",
                          style: TextStyle(color: Colors.green)),
                      Radio(
                          activeColor: Colors.red,
                          value: "Reject",
                          groupValue: group,
                          onChanged: (value) {
                            setState(() {
                              group = value!;
                            });
                          }),
                      const Text("Reject", style: TextStyle(color: Colors.red))
                    ],
                  ),
                )
              : Container(),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            CustomWidgets.confirmButton(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  Reason.text = "";
                  LastDate.text = "";
                  ResigDate.text = "";
                  Employee.text = "";
                  LastDateAdmin.text = "";
                  setState(() {});
                },
                height: height / 20,
                width: width / 3.3,
                text: "Reset",
                Clr: Colorr.Reset),
            CustomWidgets.width(10),
            CustomWidgets.confirmButton(
                onTap: () async {
                  if(update)
                  {
                    update=false;
                    Map Data={
                      "id":id,
                      "companyId": Constants_Usermast.companyId,
                      "EmployeeId": Con_List.AllEmployee.firstWhere((element) =>
                      element['FirstName'].toString() ==
                          Employee.text)['_id'],
                      "ResignationDate": CustomWidgets.DateFormatchangeapi(
                          ResigDate.text.toString()),
                      "lastdate": CustomWidgets.DateFormatchangeapi(
                          LastDate.text.toString()),
                      "reason": Reason.text
                    };
                    if(
                    await Resignation_Api.ResignationUpdate(Data)
                    ){CustomWidgets.showToast(context,
                        "Announcement Update Successfully", true);
                  }else{
                      CustomWidgets.showToast(context,
                          "Something Went Wrong", false);
                    }}
                  else {
                  Map Data = {
                    "companyId": Constants_Usermast.companyId,
                    "EmployeeId": Con_List.AllEmployee.firstWhere((element) =>
                        element['FirstName'].toString() ==
                        Employee.text)['_id'],
                    "ResignationDate": CustomWidgets.DateFormatchangeapi(
                        ResigDate.text.toString()),
                    "lastdate": CustomWidgets.DateFormatchangeapi(
                        LastDate.text.toString()),
                    "reason": Reason.text
                  };
                  if (await Resignation_Api.ResignationInser(Data)) {
                    CustomWidgets.showToast(
                        context, "Resignation Insert Successfully", true);
                  } else {
                    CustomWidgets.showToast(
                        context, "Something Went Wrong", false);
                  }}
                  get();
                  FocusScope.of(context).unfocus();
                  Reason.text = "";
                  LastDate.text = "";
                  ResigDate.text = "";
                  Employee.text = "";
                  LastDateAdmin.text = "";
                  setState(() {});
                },
                height: height / 20,
                width: width / 3.3,
                text: update ? "Update":"Save")
          ]),
          Resignation.isNotEmpty?
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text("Action")),
                    DataColumn(label: Text("No")),
                    DataColumn(label: Text("Employee Name")),
                    DataColumn(label: Text("Resignation Date")),
                    DataColumn(label: Text("Last Date")),
                    DataColumn(label: Text("Reason")),
                    DataColumn(label: Text("Last Date By Admin")),
                  ],
                  rows: Resignation.asMap().entries.map((e){
                    int index = e.key;
                    final element = e.value;
                    return DataRow(cells: [
                      DataCell(Row(
                        children: [
                          Con_List.Drawer.where((element) =>
                          element['subname'] == 'Resignation' &&
                              element['update'] == true).isNotEmpty
                              ? GestureDetector(
                            onTap: () {

                              Reason.text = element['reason'];
                              LastDate.text = DateFormat("dd-MM-yyyy").format(
                                  DateTime.parse(
                                      element['lastdate'].toString()));
                              ResigDate.text = DateFormat("dd-MM-yyyy").format(
                                  DateTime.parse(
                                      element['ResignationDate'].toString()));
                              Employee.text = element['EmployeeId']['FirstName'];
                              LastDateAdmin.text = element['confirmDate'].toString() == "null"?"":DateFormat("dd-MM-yyyy").format(
                                  DateTime.parse(
                                      element['confirmDate'].toString()));
                              id = element['_id'];
                              update = true;
                              setState(() {});
                            },
                            child: Icon(
                              Icons.edit,
                              color: Colorr.themcolor,
                              size: 22,
                            ),
                          )
                              : Container(),
                         InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder:
                                        (BuildContext context) {
                                      return AlertDialog(
                                          title: Center(
                                              child: Text(
                                                "Do you want to delete this Resignation?",
                                                style: TextStyle(
                                                    color: Colorr
                                                        .themcolor),
                                              )),
                                          content: Row(
                                            children: [
                                              Expanded(
                                                  child: CustomWidgets
                                                      .confirmButton(
                                                      onTap:
                                                          () {
                                                        Navigator.pop(
                                                            context);
                                                      },
                                                      height:
                                                      40,
                                                      width:
                                                      170,
                                                      text:
                                                      "Cancel",
                                                      Clr: Colors
                                                          .redAccent)),
                                              CustomWidgets.width(
                                                  5),
                                              Expanded(
                                                  child: CustomWidgets
                                                      .confirmButton(
                                                      onTap:
                                                          () async {
                                                        if (await Resignation_Api
                                                            .ResignationDelete({
                                                          "id":
                                                          element['_id']
                                                        })) {
                                                          CustomWidgets.showToast(
                                                              context,
                                                              "Resignation Deleted Successfully",
                                                              true);
                                                          get();
                                                          Navigator.pop(
                                                              context);
                                                        } else {
                                                          Navigator.pop(
                                                              context);
                                                        }
                                                      },
                                                      height:
                                                      40,
                                                      width:
                                                      170,
                                                      text:
                                                      "Delete")),
                                            ],
                                          ));
                                    });
                              },
                              child: Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                                size: 22,
                              ))
                        ],
                      )),
                      DataCell(Text((index+1).toString())),
                      DataCell(Text(element['EmployeeId']['FirstName'])),
                      DataCell(Text(DateFormat("dd-MM-yyyy").format(
                          DateTime.parse(
                              element['ResignationDate'].toString())))),
                      DataCell(Text(DateFormat("dd-MM-yyyy").format(
                          DateTime.parse(
                              element['lastdate'].toString())))),
                      DataCell(Text(element['reason'])),
                      DataCell(Text(element['confirmDate'].toString()=="null" ?"":DateFormat("dd-MM-yyyy").format(
                          DateTime.parse(
                              element['confirmDate'].toString())))),
                    ]);
                  }).toList()
                )),
          ):Container(child: CustomWidgets.NoDataImage(context))
        ]),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, String date) async {
    DateTime selectedDate = DateTime.now();
    DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    DateTime dateTime = DateTime.now();
    if (ResigDate.text.isNotEmpty) {
      dateTime = dateFormat.parse(ResigDate.text);
    }
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: ResigDate.text.isNotEmpty ? dateTime : selectedDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2101),
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
        if (date == "FromDate") {
          fromDate = picked;
          ResigDate.text = DateFormat('dd-MM-yyyy').format(picked);
        }
      });
    }
  }

  Future<void> _selectDate1(BuildContext context, String date) async {
    DateTime selectedDate = DateTime.now();
    DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    DateTime dateTime = DateTime.now();
    if (LastDate.text.isNotEmpty) {
      dateTime = dateFormat.parse(LastDate.text);
    }
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: LastDate.text.isNotEmpty ? dateTime : selectedDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2101),
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
        LastDate.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  Future<void> _selectDate2(BuildContext context, String date) async {
    DateTime selectedDate = DateTime.now();
    DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    DateTime dateTime = DateTime.now();
    if (LastDateAdmin.text.isNotEmpty) {
      dateTime = dateFormat.parse(LastDateAdmin.text);
    }
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: LastDateAdmin.text.isNotEmpty ? dateTime : selectedDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2101),
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
        toDateAd = picked;
        LastDateAdmin.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }
}
