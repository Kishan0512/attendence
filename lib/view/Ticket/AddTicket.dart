import 'package:attendy/A_SQL_Trigger/Con_List.dart';
import 'package:attendy/A_SQL_Trigger/Con_Usermast.dart';
import 'package:attendy/A_SQL_Trigger/Employee_Add_api.dart';
import 'package:attendy/A_SQL_Trigger/Ticket_api.dart';
import 'package:attendy/A_SQL_Trigger/api_page.dart';
import 'package:attendy/utils/Constant/LocalCustomWidgets.dart';
import 'package:attendy/view/Ticket/Ticket.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../utils/Constant/Colors.dart';
import '../../utils/DroupDown/custom_dropdown.dart';

class AddTicket extends StatefulWidget {
  const AddTicket({Key? key}) : super(key: key);

  @override
  State<AddTicket> createState() => _AddTicketState();
}

class _AddTicketState extends State<AddTicket> {
  bool isActive=false;
  TextEditingController EmaployeeName=TextEditingController();
  TextEditingController priorityName=TextEditingController();
  TextEditingController Date=TextEditingController();
  TextEditingController TicketName=TextEditingController();
  TextEditingController Order=TextEditingController();
  TextEditingController Username=TextEditingController();
  List<String> Employee=[];
  List<String> Users=[];
  List<String> priority=["High","Medium","Low"];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }
  getdata()
  async {
    Con_List.AllEmployee=await AllEmployee_api.EmployeeSelect();
    Con_List.Users = await api_page.userSelect();
    Username.text=Con_List.Users.firstWhere((element) => element['_id']==Constants_Usermast.sId)['name'].toString();
    Con_List.AllEmployee.forEach((element) {
      if(element['isActive']==true)
      {
        Employee.add(element['FirstName']);
      }
    });
    Con_List.Users.forEach((element) {
      if(element['_id'].toString()==Constants_Usermast.sId.toString())
      {
        Users.add(element['name'].toString());
        EmaployeeName.text = Username.text;
      }
    });
    setState(() {
    });
  }
  Widget build(BuildContext context) {
    double height =MediaQuery.of(context).size.height-kToolbarHeight;
    double width =MediaQuery.of(context).size.width;
    Future<bool> onBackPress() {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return Ticket();
      },));
      return Future.value(false);
    }
    return WillPopScope(
        onWillPop: () => onBackPress(),
    child: Constants_Usermast.IOS==true? CupertinoPageScaffold(
      navigationBar:CustomWidgets.appbarIOS(title:  "Add Employee Salary", action: [], context: context, onTap: () {
        Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) {
          return Ticket();
        },));
      },),
      child:Column(children: [
        CustomWidgets.textFieldIOS(hintText: "Select Employee",controller: EmaployeeName,readOnly: true,onTap: () {
          CustomWidgets.SelectDroupDown(context: context,items: Employee, onSelectedItemChanged: (int) {
            EmaployeeName.text=Employee[int];
            setState(() {
            });
          });},suffix: CustomWidgets.aarowCupertinobutton(),
        ),
        CustomWidgets.textFieldIOS(hintText: "Select Priority",controller: priorityName,readOnly: true,onTap: () {
          CustomWidgets.SelectDroupDown(context: context,items: priority, onSelectedItemChanged: (int) {
            priorityName.text=priority[int];
            setState(() {
            });
          });
        },suffix: CustomWidgets.aarowCupertinobutton(),
        ),
        CustomWidgets.textFieldIOS(hintText: "Date",readOnly: true,controller: Date,suffix: GestureDetector(onTap: () => CustomWidgets.selectDateIOS(context: context, controller: Date),child: CustomWidgets.DateIconIOS())),
        CustomWidgets.textFieldIOS(hintText: "Ticket",controller: TicketName),
        SizedBox(height: 10,),
        Row(
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
                    SaveButton("Save");
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
                    SaveButton("Save & Continue");
                  }else{
                    CustomWidgets.showToast(context, "No Internet Connection", false);
                  }
                },
                child: Text('Save & Continue'),
              ),
            ),
            SizedBox(width: 5),
          ],
        )
      ],)
    ):
    Scaffold(
      appBar: CustomWidgets.appbar(title: "Ticket",action:  [
      ],context:  context,onTap: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return Ticket();
        },));
      },),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomWidgets.height(10),
            Constants_Usermast.statuse == "ADMIN" ?
            CustomDropdown.search(
              listItemStyle: CustomWidgets.style(),
              hintText: 'Select Employee',
              controller: EmaployeeName ,
              items: Employee,
            ) : CustomWidgets.textField(hintText: "User",controller: Username,readOnly: true),
            // CustomDropdown.search(
            //   listItemStyle: CustomWidgets.style(),
            //   hintText: 'User',
            //   controller: Username ,
            //   items: Users,
            // ),
            CustomDropdown.search(  listItemStyle: CustomWidgets.style(),
              hintText: 'Select Priority',
              controller: priorityName ,
              items: priority,
            ),
            CustomWidgets.textField(hintText: "Date",readOnly: true,controller: Date,suffixIcon: InkWell(onTap: () => CustomWidgets.selectDate(context: context, controller: Date),child: CustomWidgets.DateIcon())),
            CustomWidgets.textField(hintText: "Ticket",controller: TicketName),
            CustomWidgets.height(15),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomWidgets.confirmButton(onTap:() {
                    ResetButton();
                    FocusScope.of(context).unfocus();
                  }, height:  height/20, width: width/3.3, text: "Reset",Clr: Colorr.Reset),
                  CustomWidgets.confirmButton(onTap:() async {
                    FocusScope.of(context).unfocus();
                    if(await CustomWidgets.CheakConnectionInternetButton())
                    {
                    SaveButton("Save");
                    }else{
                    CustomWidgets.showToast(context, "No Internet Connection", false);
                    }
                  }, height:  height/20, width:  width/3.3, text: "Save"),
                  CustomWidgets.confirmButton(onTap:() async {
                    if(await CustomWidgets.CheakConnectionInternetButton())
                    {
                    SaveButton("Save&Continue");
                    }else{
                    CustomWidgets.showToast(context, "No Internet Connection", false);
                    }
                    FocusScope.of(context).unfocus();
                  }, height:  height/20, width: width/2.9, text: "Save & Continue",),
                ])
          ],
        ),
      ),
    ));
  }
  SaveButton(String Save)
  async {
    if(Constants_Usermast.statuse == "ADMIN")
      {if(EmaployeeName.text.trim().isEmpty) {

        CustomWidgets.showToast(context, "Select Employee", false);
      }
      }
    if(Constants_Usermast.statuse != "ADMIN")
    {

      if(Username.text.trim().isEmpty) {
        CustomWidgets.showToast(context, "Select Employee", false);
      }
    }
    if(priorityName.text.trim().isEmpty)
    {
      CustomWidgets.showToast(context, "Select Priority",false);
    }
    if(Date.text.trim().isEmpty)
    {
      CustomWidgets.showToast(context, "Select Date",false);
    }
    if(TicketName.text.trim().isEmpty)
    {
      CustomWidgets.showToast(context, "Ticket is required",false);
    }
    else
    {
      Map data={
        "companyId" : Constants_Usermast.companyId,
        "employeeId" : Con_List.AllEmployee.firstWhere((element) => element['FirstName']==EmaployeeName.text)['_id'].toString(),
        "name" : TicketName.text,
        "priority" : priorityName.text,
        "fromDate" : CustomWidgets.DateFormatchangeapi(Date.text),
        "isActive" : isActive.toString()
      };
      if(await Ticket_api.Ticketinsert(data)){
        if(Save=="Save")
          {
            CustomWidgets.showToast(context, "Ticket Add Successfully",true);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
              return Ticket();
            },));
          }else{
          CustomWidgets.showToast(context, "Ticket Add Successfully",true);
          ResetButton();
        }
      }
    }
  }
  ResetButton(){
    EmaployeeName.text="";
    priorityName.text="";
    Date.text ="";
    TicketName.text="";
    Order.text="";
    setState(() {
    });
  }
}
