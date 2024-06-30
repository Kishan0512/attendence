import 'package:attendy/A_SQL_Trigger/Notification_api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../Modal/All_import.dart';

class Add_holiday extends StatefulWidget {
  Map? e;

  Add_holiday({this.e});

  @override
  State<Add_holiday> createState() => _Add_holidayState();
}

class _Add_holidayState extends State<Add_holiday> {
  TextEditingController FromDate = TextEditingController();
  TextEditingController ToDate = TextEditingController();
  TextEditingController HolidayName = TextEditingController();
  TextEditingController HolidayDays = TextEditingController();
  DateTime? fromDate;
  DateTime? toDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Updatecheack();
  }

  Updatecheack() {
    if (widget.e != null) {
      HolidayName.text = widget.e!['name'].toString();
      FromDate.text =
          CustomWidgets.DateFormatchange(widget.e!['fromDate'].toString());
      ToDate.text =
          CustomWidgets.DateFormatchange(widget.e!['toDate'].toString());
      HolidayDays.text = widget.e!['day'].toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height - kToolbarHeight;
    double width = MediaQuery.of(context).size.width;
    Future<bool> onBackPress() {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return Holiday_details();
        },
      ));
      return Future.value(false);
    }

    return WillPopScope(
        onWillPop: () => onBackPress(),
        child: Constants_Usermast.IOS == true
            ? CupertinoPageScaffold(
                navigationBar: CustomWidgets.appbarIOS(
                  title:
                      widget.e == null ? "Add New Holiday" : "Update Holiday",
                  action: [],
                  context: context,
                  onTap: () {
                    Navigator.pushReplacement(context, CupertinoPageRoute(
                      builder: (context) {
                        return Holiday_details();
                      },
                    ));
                  },
                ),
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: CupertinoColors.white,
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Column(
                    children: [
                      CustomWidgets.textFieldIOS(
                          hintText: "Holiday Name", controller: HolidayName),
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
                          hintText: "Days",
                          controller: HolidayDays,
                          keyboardType: TextInputType.number),
                      SizedBox(height: 25),
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
                                      HolidayName.text = "";
                                      FromDate.text = "";
                                      ToDate.text = "";
                                      HolidayDays.text = "";
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
                                      SaveButton("Save");
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: width / 3,
                                  height: height / 20,
                                  child: CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    color: Colorr.Reset,
                                    child: Text("Reset"),
                                    onPressed: () {
                                      FocusScope.of(context).unfocus();
                                      HolidayName.text = "";
                                      FromDate.text = "";
                                      ToDate.text = "";
                                      HolidayDays.text = "";
                                      setState(() {});
                                    },
                                  ),
                                ),
                                CustomWidgets.width(10),
                                Container(
                                  width: width / 3,
                                  height: height / 20,
                                  child: CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    color: Colorr.themcolor,
                                    child: Text("Update"),
                                    onPressed: () async {
                                      FocusScope.of(context).unfocus();
                                      if (await CustomWidgets
                                          .CheakConnectionInternetButton()) {
                                        SaveButton("Update");
                                      } else {
                                        CustomWidgets.showToast(context,
                                            "No Internet Connection", false);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            )
                    ],
                  ),
                ))
            : Scaffold(
                backgroundColor: Colorr.themcolor50,
                appBar: CustomWidgets.appbar(
                  title:
                      widget.e == null ? "Add New Holiday" : "Update Holiday",
                  action: [],
                  context: context,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return Holiday_details();
                      },
                    ));
                  },
                ),
                body: Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colorr.White,
                  child: Column(
                    children: [
                      CustomWidgets.height(10),
                      CustomWidgets.textField(
                          hintText: "Holiday Name", controller: HolidayName),
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
                              onTap: () => _selectDate1(context, "ToDate"),
                              child: CustomWidgets.DateIcon())),
                      CustomWidgets.textField(
                          hintText: "Days",
                          controller: HolidayDays,
                          readOnly: true,
                          keyboardType: TextInputType.number),
                      CustomWidgets.height(25),
                      widget.e == null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                  CustomWidgets.width(5),
                                  Expanded(
                                    flex: 4,
                                    child: CustomWidgets.confirmButton(
                                        onTap: () {
                                          FocusScope.of(context).unfocus();
                                          HolidayName.text = "";
                                          FromDate.text = "";
                                          ToDate.text = "";
                                          HolidayDays.text = "";
                                          setState(() {});
                                        },
                                        height: height / 20,
                                        width: width / 3.3,
                                        text: "Reset",
                                        Clr: Colorr.Reset),
                                  ),
                                  CustomWidgets.width(5),
                                  Expanded(
                                    flex: 4,
                                    child: CustomWidgets.confirmButton(
                                        onTap: () async {
                                          FocusScope.of(context).unfocus();
                                          if (await CustomWidgets
                                              .CheakConnectionInternetButton()) {
                                            SaveButton("Save");
                                          } else {
                                            CustomWidgets.showToast(
                                                context,
                                                "No Internet Connection",
                                                false);
                                          }
                                        },
                                        height: height / 20,
                                        width: width / 3.3,
                                        text: "Save"),
                                  ),
                                  CustomWidgets.width(5),
                                  Expanded(
                                    flex: 5,
                                    child: CustomWidgets.confirmButton(
                                      onTap: () async {
                                        FocusScope.of(context).unfocus();
                                        if (await CustomWidgets
                                            .CheakConnectionInternetButton()) {
                                          SaveButton("Save&Continue");
                                        } else {
                                          CustomWidgets.showToast(context,
                                              "No Internet Connection", false);
                                        }
                                      },
                                      height: height / 20,
                                      width: width / 3,
                                      text: "Save & Continue",
                                    ),
                                  ),
                                  CustomWidgets.width(5),
                                ])
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                  CustomWidgets.confirmButton(
                                      onTap: () {
                                        FocusScope.of(context).unfocus();
                                        HolidayName.text = "";
                                        FromDate.text = "";
                                        ToDate.text = "";
                                        HolidayDays.text = "";
                                        setState(() {});
                                      },
                                      height: height / 20,
                                      width: width / 3.3,
                                      text: "Reset",
                                      Clr: Colorr.Reset),
                                  CustomWidgets.width(10),
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
                                      width: width / 3.3,
                                      text: "Update")
                                ]),
                    ],
                  ),
                )));
  }

  SaveButton(String Save) async {
    if (HolidayName.text.trim().isEmpty) {
      CustomWidgets.showToast(context, "Holiday Name is required", false);
    } else if (FromDate.text.trim().isEmpty) {
      CustomWidgets.showToast(context, "From Date is required", false);
    } else if (ToDate.text.trim().isEmpty) {
      CustomWidgets.showToast(context, "To Date is required", false);
    } else if (HolidayDays.text.trim().isEmpty) {
      CustomWidgets.showToast(context, "Holiday Days is required", false);
    } else {
      Map data = {
        if (widget.e != null)
          "id": widget.e!['_id'].toString()
        else
          "companyId": Constants_Usermast.companyId,
        "name": HolidayName.text,
        "fromDate": CustomWidgets.DateFormatchangeapi(FromDate.text.toString()),
        "toDate": CustomWidgets.DateFormatchangeapi(ToDate.text.toString()),
        "day": HolidayDays.text,
        //"updatedTime": DateTime.now().toString()
      };
      if (widget.e == null) {
        if (await Holiday_api.Hodidayadd(data)) {
          Map Notifi_insert = {
            "companyId": Constants_Usermast.companyId,
            "Type": "HOLIDAY",
            "fromDate": CustomWidgets.DateFormatchangeapi(FromDate.text.toString()),
            "toDate": CustomWidgets.DateFormatchangeapi(ToDate.text.toString()),
            "reason": HolidayName.text,
            "username": Constants_Usermast.name,
          };
          if( await Notification_Api.NotificationInsert(Notifi_insert))
            {
          if (Save == "Save") {
            CustomWidgets.showToast(context, "Holiday Add Successfully", true);
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) {
                return Holiday_details();
              },
            ));
          } else {
            CustomWidgets.showToast(context, "Holiday Add Successfully", true);
            HolidayName.text = "";
            FromDate.text = "";
            ToDate.text = "";
            HolidayDays.text = "";
            setState(() {});
          }}
        }
      } else {
        if (await Holiday_api.HolidayUpdate(data)) {
          CustomWidgets.showToast(context, "Holiday Update Successfully", true);
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) {
              return Holiday_details();
            },
          ));
        } else {
          CustomWidgets.showToast(context, "Holiday Not Update", true);
        }
        ;
      }
    }
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
            HolidayDays.text = difference.inDays.toString();
          }
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
        toDate = picked;
        ToDate.text = DateFormat('dd-MM-yyyy').format(picked);
        if (FromDate.text.isNotEmpty) {
          DateFormat format = DateFormat('dd-MM-yyyy');
          DateTime date1 = format.parse(FromDate.text);
          DateTime date2 = format.parse(ToDate.text);
          Duration difference = date2.difference(date1);
          HolidayDays.text = difference.inDays.toString();
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
                  HolidayDays.text = difference.inDays.toString();
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
            initialDateTime: ToDate.text.isNotEmpty ? dateTime : dateTime,
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
                  HolidayDays.text = difference.inDays.toString();
                }
              });
            },
          ),
        );
      },
    );
  }
}
