import 'package:attendy/A_SQL_Trigger/Con_Usermast.dart';
import 'package:attendy/A_SQL_Trigger/Leave_report_api.dart';
import 'package:attendy/view/Report/LeaveReport.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../A_SQL_Trigger/Con_List.dart';
import '../../A_SQL_Trigger/Deparment_api_page.dart';
import '../../A_SQL_Trigger/Employee_Add_api.dart';
import '../../A_SQL_Trigger/Leave_Type_api.dart';
import '../../utils/Constant/Colors.dart';
import '../../utils/Constant/Con_icon.dart';
import '../../utils/Constant/LocalCustomWidgets.dart';
import '../../utils/DroupDown/custom_dropdown.dart';

class Add_Leave_Report extends StatefulWidget {
  Map? e;
  Add_Leave_Report({this.e});

  @override
  State<Add_Leave_Report> createState() => _Add_Leave_ReportState();
}

class _Add_Leave_ReportState extends State<Add_Leave_Report> {

  TextEditingController employeeName = TextEditingController();
  String Month1="";
  String Year1="";
  TextEditingController Year = TextEditingController();
  TextEditingController Month = TextEditingController();
  TextEditingController DateOFBirth = TextEditingController();
  TextEditingController DeparmentNamwe = TextEditingController();
  TextEditingController LeaveTypeName = TextEditingController();
  TextEditingController totalLeaveToken = TextEditingController();
  List<String> AllEmployee = [];
  List<String> Deparment = [];
  List<String> LeaveType = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
    Updatecheack();
  }
  getdata() async {
    Con_List.AllEmployee = await AllEmployee_api.EmployeeSelect();
    Con_List.DeparmenntSelect = await Deparmentapi.DeparmentSelect();
    Con_List.LeaveType = await Leave_Type_api.Leave_TypeSelect();
    Con_List.AllEmployee.forEach((element) {
      if(element['isActive']==true)
      {
        AllEmployee.add(element['FirstName']);
      }
    });
    Con_List.DeparmenntSelect.forEach((element) {
      if(element['isActive']==true) {
        Deparment.add(element['name']);
      }
    });
    Con_List.LeaveType.forEach((element) {
      if(element['isActive']==true) {
        LeaveType.add(element['name']);
      }
    });
    setState(() {});
  }
  Updatecheack() {
    if (widget.e  != null) {
      employeeName.text=Con_List.AllEmployee.isEmpty ? "" : Con_List.AllEmployee.firstWhere((element) => element['_id'] == widget.e!['employeeId'], orElse: () => {'FirstName': ''})['FirstName'].toString();
      DeparmentNamwe.text=Con_List.DeparmenntSelect.isEmpty ? "" : Con_List.DeparmenntSelect.firstWhere((element) => element['_id'] == widget.e!['deparmentId'], orElse: () => {'name': ''})['name'].toString();
      LeaveTypeName.text=Con_List.LeaveType.isEmpty ? "" : Con_List.LeaveType.firstWhere((element) => element['_id'] == widget.e!['leaveTypeId'], orElse: () => {'name': ''})['name'].toString();
      totalLeaveToken.text=widget.e!['totalLeaveToken'].toString();
      Year.text = "${widget.e!['month'].toString()} : ${widget.e!['year'].toString()}";
      Month1="${widget.e!['month'].toString()}";
      Year1  = "${widget.e!['year'].toString()}";
    }
  }

  Widget build(BuildContext context) {
    double Height = MediaQuery.of(context).size.height - kToolbarHeight;
    double Width = MediaQuery.of(context).size.width;
    Future<bool> onBackPress() {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return LeaveReport();
      },));
      return Future.value(false);
    }
    return WillPopScope(
        onWillPop: () => onBackPress(),
    child:Constants_Usermast.IOS==true? CupertinoPageScaffold(
      navigationBar:CustomWidgets.appbarIOS(title:widget.e ==null ?  "Add Leave Report" : "Update Leave Report", action: [], context: context, onTap: () {
        Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) {
          return LeaveReport();
        },));
      },),
      child: SingleChildScrollView(
        child: Column(children: [
          CustomWidgets.height(10),
          CustomWidgets.textFieldIOS(hintText: "Select Employee",controller: employeeName,readOnly: true,onTap: () {
            CustomWidgets.SelectDroupDown(context: context,items: AllEmployee, onSelectedItemChanged: (int) {
              employeeName.text=AllEmployee[int];
              setState(() {
              });
            });
          },suffix: CustomWidgets.aarowCupertinobutton(),
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
                        return  Container(
                          height: Height/3.5,
                          color: Colors.white,
                          child: Column(children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 200,
                                  width: 150,
                                  child: CupertinoPicker(
                                    itemExtent: 40.0,
                                    onSelectedItemChanged: (int index) {
                                      setState(() {
                                      Month1=index.toString();
                                      Year.text = "${Month1} & ${Year1}";
                                      });
                                    },
                                    children: List<Widget>.generate(12, (int index) {
                                      final month = index + 1;
                                      return Center(
                                        child: Text(
                                          '${_getMonthName(month)}',
                                          style: TextStyle(fontSize: 16.0),
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
                                    onSelectedItemChanged: (int index) {
                                      setState(() {
                                        int i= DateTime.now().year - 5 + index;
                                        Year1=i.toString();
                                        Year.text = "${Month1} & ${Year1}";
                                        setState(() {
                                        });
                                        // _selectedYear = DateTime.now().year - 5 + index;
                                      });
                                    },
                                    children: List<Widget>.generate(10, (int index) {
                                      final year = DateTime.now().year - 5 + index;
                                      return Center(
                                        child: Text(
                                          '$year',
                                          style: TextStyle(fontSize: 16.0),
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
          CustomWidgets.textFieldIOS(hintText: "Select Department",controller: DeparmentNamwe,readOnly: true,onTap: () {
            CustomWidgets.SelectDroupDown(context: context,items: Deparment, onSelectedItemChanged: (int) {
              DeparmentNamwe.text = Deparment[int];
              setState(() {
              });
            });
          },suffix: CustomWidgets.aarowCupertinobutton(),
          ),
          CustomWidgets.textFieldIOS(hintText: "Select Leavetype",controller: LeaveTypeName,readOnly: true,onTap: () {
            CustomWidgets.SelectDroupDown(context: context,items: LeaveType, onSelectedItemChanged: (int) {
              LeaveTypeName.text = LeaveType[int];
              setState(() {
              });
            });
          },suffix: CustomWidgets.aarowCupertinobutton(),
          ),
          CustomWidgets.textFieldIOS(hintText: "Total Leave Count",controller: totalLeaveToken,keyboardType: TextInputType.number),
          SizedBox(height: 20,),
         widget.e==null ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(height: Height/20,width: Width/3,child: CupertinoButton(padding: EdgeInsets.zero,color: Colorr.Reset,child: Text("Reset"), onPressed: () {
                ResetButton();
              },),),
              SizedBox(width: 5,),
              Container(height: Height/20,width: Width/3,child: CupertinoButton(padding: EdgeInsets.zero,color: Colorr.themcolor,child: Text("Save"), onPressed: () async {
                FocusScope.of(context).unfocus();
                if(await CustomWidgets.CheakConnectionInternetButton())
                {
                  SaveButton();
                }else{
                  CustomWidgets.showToast(context, "No Internet Connection", false);
                }
              },),)

            ],
          ) :    Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Container(height: Height/20,width: Width/3,child: CupertinoButton(padding: EdgeInsets.zero,color: Colorr.Reset,child: Text("Cancel"), onPressed: () {
               FocusScope.of(context).unfocus();
               ResetButton();
               Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) {
                 return LeaveReport();
               },));
             },),),
             SizedBox(width: 5,),
             Container(height: Height/20,width: Width/3,child: CupertinoButton(padding: EdgeInsets.zero,color: Colorr.themcolor,child: Text("Update"), onPressed: () async {
               FocusScope.of(context).unfocus();
               if(await CustomWidgets.CheakConnectionInternetButton())
               {
                 SaveButton();
               }else{
                 CustomWidgets.showToast(context, "No Internet Connection", false);
               }
             },),)

           ],
         )
        ]),
      ),
    ): Scaffold(
      appBar: CustomWidgets.appbar(title: "Add Leave Report",action:  [
      ],context:  context,onTap: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return LeaveReport();
        },));
      },),
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
          CustomDropdown.search(listItemStyle: CustomWidgets.style(),
            hintText: 'Select Deparment',
            controller: DeparmentNamwe,
            items: Deparment,
          ),
          CustomDropdown.search(  listItemStyle: CustomWidgets.style(),
            hintText: 'Select Leavetype',
            controller: LeaveTypeName,
            items: LeaveType,
          ),
          CustomWidgets.textField(hintText: "Total Leave Count",controller: totalLeaveToken,keyboardType: TextInputType.number),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomWidgets.confirmButton(
                  onTap: () {
                    ResetButton();
                  },
                  height: Height / 20,
                  width: Width / 3,
                  text: "Reset",
                  Clr: Colorr.Reset),
              CustomWidgets.width(5),
              CustomWidgets.confirmButton(
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    if(await CustomWidgets.CheakConnectionInternetButton())
                    {
                    SaveButton();
                    }else{
                    CustomWidgets.showToast(context, "No Internet Connection", false);
                    }
                  },
                  height: Height / 20,
                  width: Width / 3,
                  text: "Save")
            ],
          )
        ]),
      ),
    ));
  }

  ResetButton() {
    employeeName.text = "";
    DeparmentNamwe.text = "";
    LeaveTypeName.text = "";
    Year.text = "";
    setState(() {});
  }

  SaveButton() async {
    if (employeeName.text.trim().isEmpty) {
      CustomWidgets.showToast(context, "Select Employee",false);
    } else if (Con_List.AllEmployee.where((element) => element["FirstName"] == employeeName.text).isEmpty) {
      CustomWidgets.showToast(context, "Select Valid Employee",false);
    } else if (Year.text.trim().isEmpty) {
      CustomWidgets.showToast(context, "Select Year & Month",false);
    } else if (DeparmentNamwe.text.trim().isEmpty) {
      CustomWidgets.showToast(context, "Select Deparment",false);
    }else if (Con_List.DeparmenntSelect.where((element) => element["name"] == DeparmentNamwe.text).isEmpty) {
      CustomWidgets.showToast(context, "Select Valid Deparment",false);
    } else if (LeaveTypeName.text.trim().isEmpty) {
      CustomWidgets.showToast(context, "Select LeaveType",false);
    } else if (Con_List.LeaveType.where((element) => element["name"] == LeaveTypeName.text).isEmpty) {
      CustomWidgets.showToast(context, "Leave Type is required",false);
    } else if (totalLeaveToken.text.trim().isEmpty) {
      CustomWidgets.showToast(context, "Total Count is required",false);
    } else {
      Map data = {
        if (widget.e != null)
          "id": widget.e!['_id'].toString()
        else
          "companyId": Constants_Usermast.companyId,
        "leaveTypeId" : Con_List.LeaveType.firstWhere((element) => element['name']== LeaveTypeName.text)['_id'].toString(),
        "employeeId" : Con_List.AllEmployee.firstWhere((element) => element['FirstName']==employeeName.text)['_id'].toString(),
        "month" : Month1,
        "year" : Year1,
        "deparmentId" : Con_List.DeparmenntSelect.firstWhere((element) => element['name']==DeparmentNamwe.text)['_id'].toString(),
        "totalLeaveToken" : totalLeaveToken.text,
      };
      if(widget.e==null){
        if(await Leave_report_api.Leave_report_add(data))
        {
          CustomWidgets.showToast(context, "Add Leave Report Successfully",true);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
            return LeaveReport();
          },));
        }
      }else{

        if(await Leave_report_api.Leave_report_Update(data)){
          CustomWidgets.showToast(context, "Leave Report Update Successfully",true);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
            return LeaveReport();
          },));
        }
      }

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
}

class MonthYearPickerDialog extends StatefulWidget {
  final void Function(int, int) onMonthYearSelected;

  MonthYearPickerDialog({required this.onMonthYearSelected});

  @override
  _MonthYearPickerDialogState createState() => _MonthYearPickerDialogState();
}

class _MonthYearPickerDialogState extends State<MonthYearPickerDialog> {
  late int _selectedMonth;
  late int _selectedYear;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = now.month;
    _selectedYear = now.year;

  }

  void _onMonthYearSelected() {
    widget.onMonthYearSelected(_selectedMonth, _selectedYear);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.only(bottom: 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          AppBar(
            automaticallyImplyLeading: false,
          backgroundColor: Colorr.themcolor,
          centerTitle: true,
          elevation: 0,
          title:Text("Select Month & Year"),
        ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 200,
                  width: 150,
                  child: CupertinoPicker(
                    itemExtent: 40.0,
                    onSelectedItemChanged: (int index) {
                      setState(() {
                        _selectedMonth = index + 1;
                      });
                    },
                    children: List<Widget>.generate(12, (int index) {
                      final month = index + 1;
                      return Center(
                        child: Text(
                          '${_getMonthName(month)}',
                          style: TextStyle(fontSize: 16.0),
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
                    onSelectedItemChanged: (int index) {
                      setState(() {
                        _selectedYear = DateTime.now().year - 5 + index;
                      });
                    },
                    children: List<Widget>.generate(10, (int index) {
                      final year = DateTime.now().year - 5 + index;
                      return Center(
                        child: Text(
                          '$year',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomWidgets.confirmButton(
                    onTap:() {
                      Navigator.pop(context);
                    },
                    height: 40,
                    Clr: Colorr.Reset,
                    width: 120,
                    text: "Cencel"),
                SizedBox(
                  width: 5,
                ),
                CustomWidgets.confirmButton(
                    onTap: _onMonthYearSelected,
                    height: 40,
                    width: 120,
                    text: "Done"),

              ],
            )
          ],
        ),
      ),
    );
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
