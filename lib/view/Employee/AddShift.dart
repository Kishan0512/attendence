import 'package:attendy/A_SQL_Trigger/Con_List.dart';
import 'package:attendy/A_SQL_Trigger/Con_Usermast.dart';
import 'package:attendy/A_SQL_Trigger/Shift_Add_api.dart';
import 'package:attendy/A_SQL_Trigger/Shift_typee_add_api.dart';
import 'package:attendy/utils/Constant/LocalCustomWidgets.dart';
import 'package:attendy/view/Employee/Shift.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../utils/Constant/Colors.dart';
import '../../utils/DroupDown/custom_dropdown.dart';

class AddShift extends StatefulWidget {
  Map? e;
  AddShift({this.e});

  @override
  State<AddShift> createState() => _AddShiftState();
}

class _AddShiftState extends State<AddShift> {
  bool isActive=false;
  TextEditingController Date=TextEditingController();
  var time1 = TimeOfDay(hour: 0, minute:0);
  var time2 = TimeOfDay(hour: 0, minute:0);
  TextEditingController ShiftName=TextEditingController();
  TextEditingController Name=TextEditingController();
  TextEditingController Intime=TextEditingController();
  TextEditingController outtime=TextEditingController();
  TextEditingController FullDayHours=TextEditingController();
  TextEditingController HalfDayHours=TextEditingController();
  TextEditingController Breaktime=TextEditingController();
  List<String> ShiftTypee=[];
  String IN="";
  String OUT="";
  @override
void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
    Updateshift();
  }
  Updateshift(){
    if(widget.e !=null)
      {
        Date.text=widget.e!['date'].toString().substring(0,10);
        ShiftName.text = Con_List.shift_typeetSelect
            .firstWhere((element) => element['_id'] == widget.e!['shiftId'].toString(),
            orElse: () => {'name': ''})['name'].toString();
        Name.text=widget.e!['name'].toString();
        Intime.text=widget.e!['inTime'].toString();
        outtime.text=widget.e!['outTime'].toString();
        FullDayHours.text=widget.e!['fullHours'].toString();
        HalfDayHours.text=widget.e!['halfHours'].toString();
        Breaktime.text=widget.e!['breakTime'].toString();
        isActive=widget.e!['isActive'];
      }
  }
  getdata()
  async {
    Con_List.shift_typeetSelect=await Shift_typee_api.shift_typeeSelect();
    Con_List.shift_typeetSelect.forEach((element) {
      if(element['isActive']==true)
      {
        ShiftTypee.add(element['name']);
      }
    });
    setState(() {
    });
  }
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height-kToolbarHeight;
    double width = MediaQuery.of(context).size.width;
    Future<bool> onBackPress() {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return Shift();
      },));
      return Future.value(false);
    }
    return WillPopScope(
        onWillPop: () => onBackPress(),
    child: Constants_Usermast.IOS==true? CupertinoPageScaffold(
        navigationBar:CustomWidgets.appbarIOS(title: widget.e ==null ? "Add New Shift" : "Update Shift", action: [], context: context, onTap: () {
          Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) {
            return Shift();
          },));
        },),
        child:  Container(
          height: height,
          width: width,
          child: SingleChildScrollView(
            child: Column(children: [
              CustomWidgets.height(10),
              CustomWidgets.textFieldIOS(hintText: "Select Shift Type",controller: ShiftName,readOnly: true,onTap: () {
                CustomWidgets.SelectDroupDown(context: context,items: ShiftTypee, onSelectedItemChanged: (int) {
                  ShiftName.text=ShiftTypee[int];
                  setState(() {
                  });
                });
              },suffix: CustomWidgets.aarowCupertinobutton(),),
              CustomWidgets.textFieldIOS(hintText: "Name",controller: Name),
              CustomWidgets.textFieldIOS(hintText: "Date",readOnly: true,controller: Date,suffix: GestureDetector(onTap: () =>
                  CustomWidgets.selectDateIOS(context: context, controller: Date),child: CustomWidgets.DateIconIOS())),
              CustomWidgets.textFieldIOS(hintText: "In Time",readOnly: true,controller: Intime,suffix: GestureDetector(onTap: () => _selectDateIOS(context,"InTime"),child: CustomWidgets.DateIconIOS())),
              CustomWidgets.textFieldIOS(hintText: "Out Time",controller: outtime,readOnly: true,suffix: GestureDetector(onTap: () => _selectDateIOS(context,"outtime"),child: CustomWidgets.DateIconIOS())),
              CustomWidgets.textFieldIOS(hintText: "Full day Working Hours(Minutes)",controller: FullDayHours,keyboardType: TextInputType.number),
              CustomWidgets.textFieldIOS(hintText: "Half Day Working Hours(Minutes)",controller: HalfDayHours,keyboardType: TextInputType.number),
              CustomWidgets.textFieldIOS(hintText: "Break Time(Minutes)",controller: Breaktime,keyboardType: TextInputType.number),
              Row(
                children: [
                  CustomWidgets.width(10),
                  Text(
                    "Active",
                    style: TextStyle(fontSize: 13, color: CupertinoColors.black), // Replace with your desired text color
                  ),
                  CustomWidgets.width(7),
                  CupertinoSwitch(
                    value: isActive,
                    onChanged: (value) {
                      setState(() {
                        isActive = value;
                      });
                    },
                    activeColor: Colorr.themcolor, // Replace with your desired active color
                  ),

                ],
              ),
              CustomWidgets.height(25),
              Row(
                children: [
                  Expanded(child: SizedBox(width: 5)),
                  Expanded(flex: 2,
                    child: CupertinoButton(
                      color: Colorr.Reset,
                      padding:EdgeInsets.zero,
                      onPressed: ()  {
                        ShiftName.text="";
                        Name.text="";
                        Date.text="";
                        Intime.text="";
                        outtime.text="";
                        FullDayHours.text="";
                        HalfDayHours.text="";
                        Breaktime.text="";
                        isActive=false;
                        setState(() {
                        });
                      },
                      child: Text('Reset'),
                    ),
                  ),
                  SizedBox(width: 5),
                  Expanded(flex: 2,
                    child: CupertinoButton(
                      color: Colorr.themcolor,
                      padding:EdgeInsets.zero,
                      onPressed:() {
                        saveButtton();
                      },
                      child: Text(widget.e==null ? "Save" : "Update"),
                    ),
                  ),
                  Expanded(child: SizedBox(width: 5)),
                ],
              ),
            ]
            ),
          ),
        ),
    ):Scaffold(
      appBar: CustomWidgets.appbar(title: widget.e ==null ? "Add New Shift" : "Update Shift",action:  [],context:  context,onTap: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return Shift();
        },));
      },),
      body: Container(
        height: height,
        width: width,
        child: SingleChildScrollView(
          child: Column(children: [
            CustomWidgets.height(10),
            CustomDropdown.search(  listItemStyle: CustomWidgets.style(),
              hintText: 'Select Shift Type',
              controller: ShiftName,
              items: ShiftTypee,
            ),
            CustomWidgets.textField(hintText: "Name",controller: Name),
            CustomWidgets.textField(hintText: "Date",readOnly: true,controller: Date,suffixIcon: InkWell(onTap: () => CustomWidgets.selectDate(context: context, controller: Date),child: CustomWidgets.DateIcon())),
            CustomWidgets.textField(hintText: "In Time",readOnly: true,controller: Intime,suffixIcon: InkWell(onTap: () => _selectTime(context,"InTime"),child: CustomWidgets.DateIcon())),
            CustomWidgets.textField(hintText: "Out Time",controller: outtime,readOnly: true,suffixIcon: InkWell(onTap: () => _selectTime(context,"OutTime"),child: CustomWidgets.DateIcon())),
            CustomWidgets.textField(hintText: "Full day Working Hours(Minutes)",readOnly: true,controller: FullDayHours,keyboardType: TextInputType.number),
            CustomWidgets.textField(hintText: "Half Day Working Hours(Minutes)",readOnly: true,controller: HalfDayHours,keyboardType: TextInputType.number),
            CustomWidgets.textField(hintText: "Break Time(Minutes)",controller: Breaktime,keyboardType: TextInputType.number),
            Row(
              children: [
                Checkbox(
                  shape: CircleBorder(),
                  value: isActive,
                  activeColor: Colorr.themcolor,
                  onChanged: (value) {
                    isActive=value!;
                    setState(() {
                    });
                  },
                ),
                Text(
                  "Active",
                  style:
                  TextStyle(fontSize: 13, color: Colorr.themcolor),
                ),
              ],
            ),
           CustomWidgets.height(25),
            Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomWidgets.confirmButton(onTap: () {
                    FocusScope.of(context).unfocus();
                    ShiftName.text="";
                    Name.text="";
                    Date.text="";
                    Intime.text="";
                    outtime.text="";
                    FullDayHours.text="";
                    HalfDayHours.text="";
                    Breaktime.text="";
                    isActive=false;
                    setState(() {
                    });
                  }, height: height/20, width: width/3, text: "Reset",Clr: Colorr.Reset),
                  CustomWidgets.width(5),
                  CustomWidgets.confirmButton(onTap: () async {
                    if(await CustomWidgets.CheakConnectionInternetButton())
                    {
                    saveButtton();
                    }else{
                    CustomWidgets.showToast(context, "No Internet Connection", false);
                    }

                  }, height: height/20, width: width/3, text: widget.e==null ? "Save" : "Update") ,
                ]),
          ]
          ),
        ),
      ),
    ));
  }

  saveButtton() async {
     if(ShiftName.text.trim().isEmpty)
       {
         CustomWidgets.showToast(context, "Shift type is required",false);
       }else if(Con_List.shift_typeetSelect.where((e) => e['name'].toString() == ShiftName.text.toString()).isEmpty)
         {
           CustomWidgets.showToast(context, "Select Valid Shift Type",false);
         }else if(Name.text.trim().isEmpty)
           {
             CustomWidgets.showToast(context, "Name is required",false);
           }else if(Date.text.trim().isEmpty)
           {
             CustomWidgets.showToast(context, "Date is required",false);
           }else if(Intime.text.trim().isEmpty)
           {
             CustomWidgets.showToast(context, "In time is required",false);
           }else if(outtime.text.trim().isEmpty)
           {
             CustomWidgets.showToast(context, "Out time is required",false);
           }else if(FullDayHours.text.trim().isEmpty)
           {
             CustomWidgets.showToast(context, "Working hours is required",false);
           }else if(HalfDayHours.text.trim().isEmpty)
           {
             CustomWidgets.showToast(context, "half working hours is required",false);
           }else if(Breaktime.text.trim().isEmpty)
           {
             CustomWidgets.showToast(context, "Break time is required",false);
           }else{
       Map data = widget.e==null ? {
         "companyId" : Constants_Usermast.companyId,
         "shiftId" : Con_List.shift_typeetSelect.firstWhere((e) => e['name'] == ShiftName.text)['_id'].toString(),
         "name" : Name.text,
         "date" : CustomWidgets.DateFormatchangeapi(Date.text),
         "inTime" : IN,
         "outTime" : OUT,
         "fullHours" : FullDayHours.text,
         "halfHours" : HalfDayHours.text,
         "breakTime" : Breaktime.text,
         "isActive" : isActive.toString(),
       } :
       {
         "id" : widget.e!['_id'],
         "name" : Name.text,
         "shiftId" : Con_List.shift_typeetSelect.firstWhere((e) => e['name'] == ShiftName.text)['_id'].toString(),
         "date" :  CustomWidgets.DateFormatchangeapi(Date.text),
         "inTime" : IN,
         "outTime" : OUT,
         "fullHours" : FullDayHours.text,
         "halfHours" : HalfDayHours.text,
         "breakTime" : Breaktime.text,
         "isActive" : isActive.toString(),
       };

       if(widget.e==null)
         {
           if(await Shift_Add_api.shift_insert(data)){
             CustomWidgets.showToast(context, "Shif added Successfully",true);
             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
               return Shift();
             },));
           }else{
             CustomWidgets.showToast(context, "Shift Not Add",false);
           }
         }else
           {
             if(await Shift_Add_api.shift_Update(data) ){
               CustomWidgets.showToast(context, "Shif Update Successfully",true);
               Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                 return Shift();
               },));
             }else{
               CustomWidgets.showToast(context, "Shif Not Update",false);
             }
           }
     }
  }
  Future<void> _selectDateIOS(BuildContext context, String date) async {
    DateTime dateTime=DateTime.now();

    final DateTime? picked = await showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          color: Colorr.White,
          height: 200.0,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.time,
            initialDateTime: dateTime,
            onDateTimeChanged: (DateTime newDate) {
              if(date=="InTime")
                {
                    Intime.text="${newDate.hour} : ${newDate.minute}";
                    time1 = TimeOfDay(hour: newDate.hour, minute: newDate.minute);
                    setState(() {
                    });
                }else{
                outtime.text="${newDate.hour} : ${newDate.minute}";
                time2 = TimeOfDay(hour: newDate.hour, minute: newDate.minute);
                setState(() {
                });
              }
              calculateHourDifference(time1, time2);
              setState(() {
              });
            },
          ),
        );
      },
    );
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
          DateTime now = DateTime.now();
          DateTime dateTime = DateTime(
            now.year, // Use the current year
            now.month, // Use the current month
            now.day, // Use the current day
            pickedTime.hour,
            pickedTime.minute,
          );
          IN = dateTime.toUtc().toIso8601String();
          Intime.text="${pickedTime.hour}:${pickedTime.minute} ${pickedTime.period.toString().substring(pickedTime.period.toString().length - 2,pickedTime.period.toString().length )}";
        time1 = TimeOfDay(hour: pickedTime.hour, minute: pickedTime.minute);
        calculateHourDifference(time1, time2);
        }else{
        DateTime now = DateTime.now();
        DateTime dateTime = DateTime(
          now.year, // Use the current year
          now.month, // Use the current month
          now.day, // Use the current day
          pickedTime.hour,
          pickedTime.minute,
        );

        // Format the DateTime as desired
         OUT = dateTime.toUtc().toIso8601String();
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
    FullDayHours.text= "${hoursDifference.toString()}: ${MinitHours.toString()}";
    final time = TimeOfDay(hour: hoursDifference, minute: MinitHours);
    final dividedTime = divideTime(time);
    HalfDayHours.text ='${dividedTime.hour}:${dividedTime.minute.toString().padLeft(2, '0')}';
    setState(() {
    });
  }

  TimeOfDay divideTime(TimeOfDay time) {
    final totalMinutes = time.hour * 60 + time.minute;
    final dividedMinutes = totalMinutes ~/ 2;
    final dividedHour = dividedMinutes ~/ 60;
    final dividedMinute = dividedMinutes % 60;
    return TimeOfDay(hour: dividedHour, minute: dividedMinute);
  }

}
