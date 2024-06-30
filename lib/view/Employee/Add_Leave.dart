

import 'package:attendy/view/Employee/LeaveDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../A_SQL_Trigger/Notification_api.dart';
import '../../Modal/All_import.dart';
import '../../utils/DroupDown/custom_dropdown.dart';

class AddLeaveScreen extends StatefulWidget {
  Map? e;

  AddLeaveScreen({this.e});

  @override
  State<AddLeaveScreen> createState() => _AddLeaveScreenState();
}

class _AddLeaveScreenState extends State<AddLeaveScreen> {
  TextEditingController employeeName = TextEditingController();
  TextEditingController LeavetypeName = TextEditingController();
  TextEditingController FromDate = TextEditingController();
  TextEditingController ToDate = TextEditingController();
  TextEditingController NoofDay = TextEditingController();
  TextEditingController Reason = TextEditingController();
  var size, height, width;
  List<String> Employee = [];
  List<String> Leavetype = [];
  DateTime? fromDate;
  DateTime? toDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
    UpdateData();
  }

  getdata() async {
    Con_List.AllEmployee = await AllEmployee_api.EmployeeSelect();
    Con_List.LeaveType = await Leave_Type_api.Leave_TypeSelect();
    Con_List.AllEmployee.forEach((element) {
      if (element['isActive'] == true) {
        Employee.add(element['FirstName']);
      }
    });
    Con_List.LeaveType.forEach((element) {
      if (element['isActive'] == true) {
        Leavetype.add(element['name']);
      }
    });

    setState(() {});
  }

  UpdateData() {
    if (widget.e != null) {
      employeeName.text = Con_List.AllEmployee.isEmpty
          ? ""
          : Con_List.AllEmployee.firstWhere(
                  (element) => element['_id'] == widget.e!['EmployeeId'],
                  orElse: () => {'FirstName': ''})['FirstName']
              .toString();
      LeavetypeName.text = Con_List.LeaveType.isEmpty
          ? ""
          : Con_List.LeaveType.firstWhere(
                  (element) => element['_id'] == widget.e!['leaveId'],
                  orElse: () => {'name': ''})['name']
              .toString();
      FromDate.text =
          CustomWidgets.DateFormatchange(widget.e!['fromDate'].toString());
      ToDate.text =
          CustomWidgets.DateFormatchange(widget.e!['toDate'].toString());
      NoofDay.text = widget.e!['day']!.toString();
      Reason.text = widget.e!['reason'].toString();
      setState(() {});
    }
  }

  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    Future<bool> onBackPress() {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return LeaveDetailScreen();
        },
      ));
      return Future.value(false);
    }

    return WillPopScope(
        onWillPop: () => onBackPress(),
        child: Constants_Usermast.IOS == true
            ? CupertinoPageScaffold(
                navigationBar: CustomWidgets.appbarIOS(
                  title: widget.e == null ? "Add New Leave" : "Update Leave",
                  action: [],
                  context: context,
                  onTap: () {
                    Navigator.pushReplacement(context, CupertinoPageRoute(
                      builder: (context) {
                        return LeaveDetailScreen();
                      },
                    ));
                  },
                ),
                child: Container(
                  child: Column(children: [
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
                    CustomWidgets.textFieldIOS(
                      hintText: "Select Leave Type",
                      controller: LeavetypeName,
                      readOnly: true,
                      onTap: () {
                        CustomWidgets.SelectDroupDown(
                            context: context,
                            items: Leavetype,
                            onSelectedItemChanged: (int) {
                              LeavetypeName.text = Leavetype[int];
                              setState(() {});
                            });
                      },
                      suffix: CustomWidgets.aarowCupertinobutton(),
                    ),
                    CustomWidgets.textFieldIOS(
                        hintText: "From Date",
                        readOnly: true,
                        controller: FromDate,
                        suffix: GestureDetector(
                            onTap: () => _selectDateIOS(context, "FromDate"),
                            child: CustomWidgets.DateIconIOS())),
                    CustomWidgets.textFieldIOS(
                        hintText: "To Date",
                        readOnly: true,
                        controller: ToDate,
                        suffix: GestureDetector(
                            onTap: () => _selectDateIOS1(context, "ToDate"),
                            child: CustomWidgets.DateIconIOS())),
                    CustomWidgets.textFieldIOS(
                        hintText: "No Of Day",
                        controller: NoofDay,
                        keyboardType: TextInputType.number,
                        readOnly: true),
                    CustomWidgets.textFieldIOS(
                        hintText: "Enter Reason", controller: Reason),
                    CustomWidgets.height(10),
                    widget.e == null
                        ? Row(
                            children: [
                              SizedBox(width: 5),
                              Expanded(
                                flex: 2,
                                child: CupertinoButton(
                                  color: Colorr.Reset,
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    FromDate.text = "";
                                    ToDate.text = "";
                                    NoofDay.text = "";
                                    Reason.text = "";
                                    employeeName.text = "";
                                    LeavetypeName.text = "";
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
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    SaveButton("save");
                                  },
                                  child: Text('Save'),
                                ),
                              ),
                              SizedBox(width: 5),
                              Expanded(
                                flex: 3,
                                child: CupertinoButton(
                                  color: Colorr.themcolor,
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    SaveButton("Save&Continue");
                                  },
                                  child: Text('Save & Continue'),
                                ),
                              ),
                              SizedBox(width: 5),
                            ],
                          )
                        : Row(
                            children: [
                              SizedBox(width: 5),
                              Expanded(
                                flex: 2,
                                child: CupertinoButton(
                                  color: Colorr.Reset,
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    FromDate.text = "";
                                    ToDate.text = "";
                                    NoofDay.text = "";
                                    Reason.text = "";
                                    employeeName.text = "";
                                    LeavetypeName.text = "";
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
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    SaveButton("Update");
                                  },
                                  child: Text('Update'),
                                ),
                              ),
                              SizedBox(width: 5),
                            ],
                          ),
                  ]),
                ))
            : Scaffold(
                backgroundColor: Colorr.White,
                appBar: CustomWidgets.appbar(
                  title: "Add New Leave",
                  action: [],
                  context: context,
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) {
                        return LeaveDetailScreen();
                      },
                    ));
                  },
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      CustomWidgets.height(10),
                      CustomDropdown.search(
                        listItemStyle: CustomWidgets.style(),
                        hintText: 'Select Employee',
                        controller: employeeName,
                        items: Employee,
                      ),
                      CustomDropdown.search(
                        listItemStyle: CustomWidgets.style(),
                        hintText: 'Select LeaveType',
                        controller: LeavetypeName,
                        items: Leavetype,
                      ),
                      CustomWidgets.textField(
                          hintText: "From Date",
                          readOnly: true,
                          controller: FromDate,
                          suffixIcon: InkWell(
                              onTap: () => _selectDate(context, "FromDate"),
                              child: CustomWidgets.DateIcon())),
                      CustomWidgets.textField(
                          hintText: "To Date",
                          readOnly: true,
                          controller: ToDate,
                          suffixIcon: InkWell(
                              onTap: () => _selectDate(context, "ToDate"),
                              child: CustomWidgets.DateIcon())),
                      CustomWidgets.textField(
                          hintText: "No Of Day",
                          controller: NoofDay,
                          keyboardType: TextInputType.number,
                          readOnly: true),
                      CustomWidgets.textField(
                          hintText: "Enter Reason", controller: Reason),
                      CustomWidgets.height(height / 15),
                      widget.e == null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                  CustomWidgets.confirmButton(
                                      onTap: () {
                                        Reset();
                                      },
                                      height: height / 20,
                                      width: width / 3.3,
                                      text: "Reset",
                                      Clr: Colorr.Reset),
                                  CustomWidgets.confirmButton(
                                      onTap: () async {
                                        FocusScope.of(context).unfocus();
                                        if (await CustomWidgets
                                            .CheakConnectionInternetButton()) {
                                          SaveButton("save");
                                        } else {
                                          CustomWidgets.showToast(context,
                                              "No Internet Connection", false);
                                        }
                                      },
                                      height: height / 20,
                                      width: width / 3.3,
                                      text: "Save"),
                                  CustomWidgets.confirmButton(
                                      onTap: () async {
                                        FocusScope.of(context).unfocus();
                                        if (await CustomWidgets
                                            .CheakConnectionInternetButton()) {
                                          SaveButton("save&Continue");
                                        } else {
                                          CustomWidgets.showToast(context,
                                              "No Internet Connection", false);
                                        }
                                      },
                                      height: height / 20,
                                      width: width / 2.7,
                                      text: "Save & Continue"),
                                ])
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                  CustomWidgets.confirmButton(
                                      onTap: () {
                                        FocusScope.of(context).unfocus();
                                        Reset();
                                      },
                                      height: height / 20,
                                      width: width / 3,
                                      text: "Reset",
                                      Clr: Colorr.Reset),
                                  CustomWidgets.width(5),
                                  CustomWidgets.confirmButton(
                                      onTap: () async {
                                        FocusScope.of(context).unfocus();
                                        if (await CustomWidgets
                                            .CheakConnectionInternetButton()) {
                                          SaveButton("Update");
                                        } else {
                                          CustomWidgets.showToast(context,
                                              "No Internet Connection", false);
                                        }
                                      },
                                      height: height / 20,
                                      width: width / 3,
                                      text: "Update")
                                ]),
                    ],
                  ),
                ),
              ));
  }

  SaveButton(String Save) async {
    if (employeeName.text.trim().isEmpty) {
      CustomWidgets.showToast(context, "Employee Name is required", false);
    } else if (LeavetypeName.text.trim().isEmpty) {
      CustomWidgets.showToast(context, "Leave type is required", false);
    } else if (NoofDay.text.trim().isEmpty) {
      CustomWidgets.showToast(context, "No of Day is required", false);
    } else if (FromDate.text.trim().isEmpty) {
      CustomWidgets.showToast(context, "From Date is required", false);
    } else if (ToDate.text.trim().isEmpty) {
      CustomWidgets.showToast(context, "To Date is required", false);
    } else if (Reason.text.trim().isEmpty) {
      CustomWidgets.showToast(context, "Reason is required", false);
    } else {
      Map data = {
        if (widget.e == null)
          "companyId": Constants_Usermast.companyId
        else
          "id": widget.e!['_id'],
        "leaveId": Con_List.LeaveType.where(
                (element) => element['name'] == LeavetypeName.text)
            .first['_id']
            .toString(),
        "EmployeeId": Con_List.AllEmployee.where(
                (element) => element['FirstName'] == employeeName.text)
            .first['_id']
            .toString(),
        "day": NoofDay.text,
        "fromDate": CustomWidgets.DateFormatchangeapi(FromDate.text),
        "toDate": CustomWidgets.DateFormatchangeapi(ToDate.text),
        "reason": Reason.text,
        "Time":DateTime.now().toUtc().toString(),
        "read":"unread",
        "status": "Pending"
      };
      if (widget.e == null) {
        if (await Leave_api.Leaveadd(data)) {
          Map Notifi_insert = {
            "companyId": Constants_Usermast.companyId,
            "Type": "LEAVE",
            "fromDate": CustomWidgets.DateFormatchangeapi(FromDate.text.toString()),
            "toDate": CustomWidgets.DateFormatchangeapi(ToDate.text.toString()),
            "reason": Reason.text,
            "status": "Pending",
            "username": Constants_Usermast.name,
          };
          if( await Notification_Api.NotificationInsert(Notifi_insert))
            {
          if (Save == "save") {
            CustomWidgets.showToast(context, "Leave Add Successfully", true);
            Navigator.pushReplacement(context, CupertinoPageRoute(
              builder: (context) {
                return LeaveDetailScreen();
              },
            ));
          } else {
            CustomWidgets.showToast(context, "Leave Add Successfully", true);
            Reset();
          }}
        } else {
          CustomWidgets.showToast(context, "Something Want Wrong", true);
        }
      } else {
        if (await Leave_api.LeaveUpdate(data)) {
          if (Save == "Update") {
            CustomWidgets.showToast(context, "Leave Update Successfully", true);
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) {
                return LeaveDetailScreen();
              },
            ));
          }
        }
      }
    }
  }

  Reset() {
    LeavetypeName.text = "";
    employeeName.text = "";
    LeavetypeName.text = "";
    NoofDay.text = "";
    FromDate.text = "";
    ToDate.text = "";
    Reason.text = "";
    setState(() {});
  }

  Future<void> _selectDate(BuildContext context, String date) async {
    DateTime selectedDate = DateTime.now();
    DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    DateTime dateTime = DateTime.now();
    if (FromDate.text.isNotEmpty) {
      dateTime = dateFormat.parse(FromDate.text);
    }
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: FromDate.text.isNotEmpty ? dateTime : selectedDate,
      firstDate: DateTime(2015),
      lastDate: toDate ?? DateTime(2101),
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
          FromDate.text = DateFormat('dd-MM-yyyy').format(picked);
          if (ToDate.text.isNotEmpty) {
            DateFormat format = DateFormat('dd-MM-yyyy');
            DateTime date1 = format.parse(FromDate.text);
            DateTime date2 = format.parse(ToDate.text);
            Duration difference = date2.difference(date1);
            NoofDay.text = difference.inDays.toString();
          }
        } else if (date == "ToDate") {
          toDate = picked;
          ToDate.text = DateFormat('dd-MM-yyyy').format(picked);
          if (FromDate.text.isNotEmpty) {
            DateFormat format = DateFormat('dd-MM-yyyy');
            DateTime date1 = format.parse(FromDate.text);
            DateTime date2 = format.parse(ToDate.text);
            Duration difference = date2.difference(date1);
            NoofDay.text = difference.inDays.toString();
          }
          // Format and update text field with selected date
        }
      });
    }
  }

  Future<void> _selectDate1(BuildContext context, String date) async {
    DateTime selectedDate = DateTime.now();
    DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    DateTime dateTime = DateTime.now();
    if (ToDate.text.isNotEmpty) {
      dateTime = dateFormat.parse(ToDate.text);
    }
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: ToDate.text.isNotEmpty ? dateTime : selectedDate,
      firstDate: fromDate ?? DateTime(2015),
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
          FromDate.text = DateFormat('dd-MM-yyyy').format(picked);
          if (ToDate.text.isNotEmpty) {
            DateFormat format = DateFormat('dd-MM-yyyy');
            DateTime date1 = format.parse(FromDate.text);
            DateTime date2 = format.parse(ToDate.text);
            Duration difference = date2.difference(date1);
            NoofDay.text = difference.inDays.toString();
          }
        } else if (date == "ToDate") {
          toDate = picked;
          ToDate.text = DateFormat('dd-MM-yyyy').format(picked);
          if (FromDate.text.isNotEmpty) {
            DateFormat format = DateFormat('dd-MM-yyyy');
            DateTime date1 = format.parse(FromDate.text);
            DateTime date2 = format.parse(ToDate.text);
            Duration difference = date2.difference(date1);
            NoofDay.text = difference.inDays.toString();
          }
          // Format and update text field with selected date
        }
      });
    }
  }

  Future<void> _selectDateIOS(BuildContext context, String date) async {
    DateTime selectedDate = DateTime.now();
    DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    DateTime dateTime = DateTime.now();
    if (FromDate.text.isNotEmpty) {
      dateTime = dateFormat.parse(FromDate.text);
    }
    final DateTime? picked = await showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          color: Colorr.White,
          height: 200.0,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: FromDate.text.isNotEmpty ? dateTime : dateTime,
            minimumDate: DateTime(2015),
            maximumDate: DateTime(2101),
            onDateTimeChanged: (DateTime newDate) {
              selectedDate = newDate;
              setState(() {
                fromDate = newDate;
                FromDate.text = DateFormat('dd-MM-yyyy').format(newDate);
                if (ToDate.text.isNotEmpty) {
                  DateFormat format = DateFormat('dd-MM-yyyy');
                  DateTime date1 = format.parse(FromDate.text);
                  DateTime date2 = format.parse(ToDate.text);
                  Duration difference = date2.difference(date1);
                  NoofDay.text = difference.inDays.toString();
                }
              });
            },
          ),
        );
      },
    );
  }

  Future<void> _selectDateIOS1(BuildContext context, String date) async {
    DateTime selectedDate = DateTime.now();
    DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    DateTime dateTime = DateTime.now();
    if (ToDate.text.isNotEmpty) {
      dateTime = dateFormat.parse(FromDate.text);
    }
    DateTime From = DateTime.now();
    if (FromDate.text.isNotEmpty) {
      From = dateFormat.parse(FromDate.text);
    }
    final DateTime? picked = await showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          color: Colorr.White,
          height: 200.0,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: FromDate.text.isNotEmpty ? From : dateTime,
            minimumDate: From,
            maximumDate: DateTime(2101),
            onDateTimeChanged: (DateTime newDate) {
              selectedDate = newDate;
              setState(() {
                selectedDate = newDate;
                toDate = newDate;
                ToDate.text = DateFormat('dd-MM-yyyy').format(newDate);
                if (FromDate.text.isNotEmpty) {
                  DateFormat format = DateFormat('dd-MM-yyyy');
                  DateTime date1 = format.parse(FromDate.text);
                  DateTime date2 = format.parse(ToDate.text);
                  Duration difference = date2.difference(date1);
                  NoofDay.text = difference.inDays.toString();
                }
              });
            },
          ),
        );
      },
    );
  }
}
