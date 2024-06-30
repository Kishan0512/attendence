import 'dart:async';
import 'package:attendy/A_SQL_Trigger/Con_List.dart';
import 'package:attendy/A_SQL_Trigger/Con_Usermast.dart';
import 'package:attendy/A_SQL_Trigger/Employee_Add_api.dart';
import 'package:attendy/A_SQL_Trigger/Overtime_api.dart';
import 'package:attendy/utils/Constant/LocalCustomWidgets.dart';
import 'package:attendy/view/Employee/Overtime.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/Constant/Colors.dart';
import '../../utils/Constant/Con_icon.dart';
import '../../utils/DroupDown/custom_dropdown.dart';

class AddOvertime extends StatefulWidget {
  Map? e;
  AddOvertime({this.e});

  @override
  State<AddOvertime> createState() => _AddOvertimeState();
}

class _AddOvertimeState extends State<AddOvertime> {
  List<String> employeeName=[];
  TextEditingController Intime=TextEditingController();
  TextEditingController outtime=TextEditingController();
  TextEditingController Name=TextEditingController();
  TextEditingController Date=TextEditingController();
  TextEditingController Time=TextEditingController();
  TextEditingController Description=TextEditingController();
  var time1 = TimeOfDay(hour: 0, minute:0);
  var time2 = TimeOfDay(hour: 0, minute:0);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
    Updatecheack();
  }

  Updatecheack() {
    if (widget.e != null) {
      Name.text =      Con_List.AllEmployee.isEmpty ? "" : Con_List.AllEmployee.firstWhere((element) => element['_id'] == widget.e!['employeeId'],
          orElse: () => {'FirstName': ''}
      )['FirstName'].toString();
      Date.text = CustomWidgets.DateFormatchange(widget.e!['overTimeDate'].toString());
      Time.text = widget.e!['overTimeHours'].toString();
      Description.text = widget.e!['description'].toString();
    }
  }
  getdata()
  async {
    Con_List.AllEmployee=await AllEmployee_api.EmployeeSelect();
    Con_List.AllEmployee.forEach((element) {
      if(element['isActive']==true)
      {
        employeeName.add(element['FirstName']);
      }
    });
    setState(() {
    });
  }
  Widget build(BuildContext context) {
    double height =MediaQuery.of(context).size.height-kToolbarHeight;
    double Width = MediaQuery.of(context).size.width;
    Future<bool> onBackPress() {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return Overtime();
      },));
      return Future.value(false);
    }
    return WillPopScope(
        onWillPop: () => onBackPress(),
    child: Constants_Usermast.IOS==true? CupertinoPageScaffold(
      navigationBar:CustomWidgets.appbarIOS(title:widget.e ==null ?  "Add New Overtime" : "Update Overtime", action: [], context: context, onTap: () {
        Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) {
          return Overtime();
        },));
      },),
      child:  Column(children: [

        CustomWidgets.height(10),

        CustomWidgets.textFieldIOS(hintText: "Select Employee",controller: Name,readOnly: true,onTap: () {
          CustomWidgets.SelectDroupDown(context: context,items: employeeName, onSelectedItemChanged: (int) {
            Name.text=employeeName[int];
            setState(() {
            });
          });
        },suffix: CustomWidgets.aarowCupertinobutton(),
        ),
        CustomWidgets.textFieldIOS(hintText: "Overtime Date",readOnly: true,controller: Date,suffix: GestureDetector(onTap: () => CustomWidgets.selectDateIOS(context: context, controller: Date),child: CustomWidgets.DateIconIOS())),
        CustomWidgets.textFieldIOS(hintText: "Over Time Hours",readOnly: true,controller: Time,suffix: GestureDetector(onTap:() async {
          showHourPickerIOS(controller: Time,context: context);
        },child: CustomWidgets.DateIconIOS())),
        CustomWidgets.textFieldIOS(hintText: "Description",controller: Description),
        CustomWidgets.height(25),
     widget.e==null ?   Row(
          children: [
            SizedBox(width: 5),
            Expanded(
              flex: 2,
              child: CupertinoButton(
                color: Colorr.Reset,
                padding: EdgeInsets.zero,
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  ResetButton();
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
                  if(await CustomWidgets.CheakConnectionInternetButton())
                  {
                  SaveButton("save");
                  }else{
                  CustomWidgets.showToast(context, "No Internet Connection", false);
                  }
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
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  if(await CustomWidgets.CheakConnectionInternetButton())
                  {
                  SaveButton("Save&Continue");
                  }else{
                  CustomWidgets.showToast(context, "No Internet Connection", false);
                  }
                },
                child: Text('Save & Continue'),
              ),
            ),
            SizedBox(width: 5),
          ],
        ) :Row(
       mainAxisAlignment: MainAxisAlignment.center,
       children: [
         SizedBox(width: 5),
         Container(width: Width/3,height: height/20,child:   CupertinoButton(
           color: Colorr.Reset,
           padding: EdgeInsets.zero,
           onPressed: () {
             FocusScope.of(context).unfocus();
             ResetButton();
           },
           child: Text('Censal'),
         ) ,),
         SizedBox(width: 5),
         Container(width: Width/3,height: height/20,child:CupertinoButton(
           color: Colorr.themcolor,
           padding: EdgeInsets.zero,
           onPressed: () async {
             FocusScope.of(context).unfocus();
             if(await CustomWidgets.CheakConnectionInternetButton())
             {
               SaveButton("Update");
             }else{
               CustomWidgets.showToast(context, "No Internet Connection", false);
             }
           },
           child: Text('Update'),
         ) ,),
         SizedBox(width: 5),
       ],
     ) ,
      ]
      ),
    ): Scaffold(
      appBar: CustomWidgets.appbar(title: "Add OverTime",action:  [],context:  context,onTap: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return Overtime();
        },));
      },),      body: SingleChildScrollView(
        child: Column(children: [
          CustomWidgets.height(10),
          CustomDropdown.search(listItemStyle: CustomWidgets.style(),
            hintText: 'Select Employee',
            controller: Name,
            items: employeeName,
          ),
          CustomWidgets.textField(hintText: "Overtime Date",readOnly: true,controller: Date,suffixIcon: InkWell(onTap: () =>

              CustomWidgets.selectDate(context: context, controller: Date),child: CustomWidgets.DateIcon())),
          CustomWidgets.textField(hintText: "In Time",readOnly: true,controller: Intime,suffixIcon: InkWell(onTap: () => _selectTime(context,"InTime"),child: CustomWidgets.DateIcon())),
          CustomWidgets.textField(hintText: "Out Time",controller: outtime,readOnly: true,suffixIcon: InkWell(onTap: () => _selectTime(context,"OutTime"),child: CustomWidgets.DateIcon())),
          CustomWidgets.textField(hintText: "Over Time Hours",controller: Time,suffixIcon: InkWell(onTap:() async {
            final selectedTime = await showHourPicker(context);
            if (selectedTime != null) {
              Time.text =  "${selectedTime.hour} : ${selectedTime.minute}";
              setState(() {
              });
            }
          },child: CustomWidgets.DateIcon())),
          CustomWidgets.textField(hintText: "Description",controller: Description),
          CustomWidgets.height(25),
         widget.e==null ?  Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomWidgets.confirmButton(onTap:() {
                  FocusScope.of(context).unfocus();
                  ResetButton();
                }, height: height/20, width:  Width/3.3, text: "Reset",Clr: Colorr.Reset),
                CustomWidgets.confirmButton(onTap:() async {
                  FocusScope.of(context).unfocus();
                  if(await CustomWidgets.CheakConnectionInternetButton())
                  {
                  SaveButton("save");
                  }else{
                  CustomWidgets.showToast(context, "No Internet Connection", false);
                  }

                }, height: height/20, width:  Width/3.3, text: "Save"),
                CustomWidgets.confirmButton(onTap:() async {
                  FocusScope.of(context).unfocus();
                  if(await CustomWidgets.CheakConnectionInternetButton())
                  {
                  SaveButton("Save&Continue");
                  }else{
                  CustomWidgets.showToast(context, "No Internet Connection", false);
                  }

                }, height: height/20, width:  Width/2.7, text: "Save & Continue",),
              ]) : Row(mainAxisAlignment: MainAxisAlignment.center,
             children: [
           CustomWidgets.confirmButton(onTap:() {
             FocusScope.of(context).unfocus();
             ResetButton();
             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
               return Overtime();
             },));
           }, height: height/20, width:  Width/3.3, text: "Cancel",Clr: Colorr.Reset),
               SizedBox(width: 5,),
               CustomWidgets.confirmButton(onTap:() async {
                 FocusScope.of(context).unfocus();
                 if(await CustomWidgets.CheakConnectionInternetButton())
                 {
                   SaveButton("Update");
                 }else{
                   CustomWidgets.showToast(context, "No Internet Connection", false);
                 }

               }, height: height/20, width:  Width/3.3, text: "Save"),
         ]),
        ]),
      ),
    ));
  }
  SaveButton(String Save) async {
    if(Name.text.trim().isEmpty)
      {
        CustomWidgets.showToast(context, "Select Employee Name",false);
      }else if(Date.text.trim().isEmpty){
      CustomWidgets.showToast(context, "Select Date",false);
    }else if(Time.text.trim().isEmpty)
      {
        CustomWidgets.showToast(context, "Select Time",false);
      }else if(Description.text.trim().isEmpty)
        {
          CustomWidgets.showToast(context, "Description is required",false);
        }else{
      Map data = {
        "employeeId" : Con_List.AllEmployee.firstWhere((e) => e['FirstName'] == Name.text)['_id'].toString(),
        if (widget.e != null)
          "id": widget.e!['_id'].toString()
        else
          "companyId": Constants_Usermast.companyId,
        "overTimeDate" : CustomWidgets.DateFormatchangeapi(Date.text),
        "fromTime":Intime.text,
        "toTime":outtime.text,
        "overTimeHours" : Time.text,
        "description" : Description.text
      };
      if(widget.e==null)
   {
          if(await Overtime_api.Overtime_add(data)){

            if(Save=="save")
            {
              CustomWidgets.showToast(context, "Overtime save Succecfully",true);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Overtime();
              },));
            }else{
              CustomWidgets.showToast(context, "Overtime save Succecfully",true);
              ResetButton();
            }
          }
        }else{
        if(await Overtime_api.Overtime_Update(data)){
          if(Save=="Update")
          {
            CustomWidgets.showToast(context, "Overtime Update Succecfully",true);
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Overtime();
            },));
          }else{
            CustomWidgets.showToast(context, "Overtime Not Update Succecfully",true);
            ResetButton();
          }
        }
      }
    }
  }
  Future<void> _selectTime(BuildContext context,String time) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
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
      initialTime: TimeOfDay.now(), // Set the initial time (optional)
    );
    if (pickedTime != null) {
      if(time=="InTime")
      {
        Intime.text="${pickedTime.hour}:${pickedTime.minute} ${pickedTime.period.toString().substring(pickedTime.period.toString().length - 2,pickedTime.period.toString().length )}";
        time1 = TimeOfDay(hour: pickedTime.hour, minute: pickedTime.minute);
        calculateHourDifference(time1, time2);
      }else{
        outtime.text="${pickedTime.hour}:${pickedTime.minute} ${pickedTime.period.toString().substring(pickedTime.period.toString().length - 2,pickedTime.period.toString().length )}";
        time2 = TimeOfDay(hour: pickedTime.hour, minute: pickedTime.minute);
        calculateHourDifference(time1, time2);
      }

      setState(() {
      });
      // Handle the selected time
      // You can access the selected time using pickedTime.hour and pickedTime.minute
    }
  }
  calculateHourDifference(TimeOfDay time1, TimeOfDay time2) {
    final dateTime1 = DateTime(0, 0, 0, time1.hour, time1.minute);
    final dateTime2 = DateTime(0, 0, 0, time2.hour, time2.minute);
    final difference = dateTime2.difference(dateTime1);
    final hoursDifference = difference.inHours;
    final MinitHours = difference.inMinutes % 60;
    Time.text= "${hoursDifference.toString()}: ${MinitHours.toString().padLeft(2,"0")}";
    setState(() {
    });
  }
  Future<TimeOfDay?> showHourPicker(BuildContext context) async {
    final now = TimeOfDay.now();
    return await showTimePicker(
      context: context,
      initialTime: now,
      initialEntryMode: TimePickerEntryMode.input,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      }, // Set a large minute interval to disable minute selection
    );
  }
  Future<String> showHourPickerIOS({
    required BuildContext context,
    required TextEditingController controller,
  }) async {
    DateTime selectedDate = DateTime.now();
    final DateTime? picked = await showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colorr.White,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.time,
            initialDateTime: selectedDate,
            use24hFormat: true,
            onDateTimeChanged: (DateTime newDate) {
              controller.text= DateFormat('hh : mm').format(newDate);
            },
          ),
        );
      },
    );
    return controller.text;
  }

  ResetButton()
  {
    Name.text="";
    Date.text="";
    Time.text="";
    Description.text="";
    setState(() {
    });
  }
}
