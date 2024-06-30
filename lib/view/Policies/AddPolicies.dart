import 'package:attendy/A_SQL_Trigger/Con_List.dart';
import 'package:attendy/A_SQL_Trigger/Con_Usermast.dart';
import 'package:attendy/A_SQL_Trigger/Policies_api.dart';
import 'package:attendy/utils/Constant/LocalCustomWidgets.dart';
import 'package:attendy/view/Policies/Policies.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../A_SQL_Trigger/Deparment_api_page.dart';
import '../../utils/Constant/Colors.dart';
import '../../utils/Constant/Con_icon.dart';
import '../../utils/DroupDown/custom_dropdown.dart';

class AddPolicies extends StatefulWidget {
  Map? e;
  AddPolicies({this.e});

  @override
  State<AddPolicies> createState() => _AddPoliciesState();
}

class _AddPoliciesState extends State<AddPolicies> {
  List<String> Deparment=[];
  bool isActive=false;

  TextEditingController PoliciesName=TextEditingController();
  TextEditingController Description=TextEditingController();
  TextEditingController DeparmentName=TextEditingController();
  TextEditingController Date=TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
    Updatecheack();
  }
  Updatecheack(){
    if (widget.e != null) {
      PoliciesName.text = widget.e!['name'].toString();
          Description.text = widget.e!['description'].toString();
          DeparmentName.text=  Con_List.DeparmenntSelect.firstWhere((element) => element['_id']==widget.e!['departmentId'], orElse: () => {'name': ''})['name'].toString();
          Date.text =  CustomWidgets.DateFormatchange(widget.e!['createDate'].toString());
          isActive =  widget.e!['isActive'];

    }
  }
  getdata()
  async {
    Con_List.DeparmenntSelect=await Deparmentapi.DeparmentSelect();
    Con_List.DeparmenntSelect.forEach((element) {
      if(element['isActive']==true) {
        Deparment.add(element['name']);
      }
    });
    setState(() {
    });
  }
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height-kToolbarHeight;
    double width=MediaQuery.of(context).size.width;
    Future<bool> onBackPress() {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return Policies();
      },));
      return Future.value(false);
    }
    return WillPopScope(
        onWillPop: () => onBackPress(),
    child: Constants_Usermast.IOS==true ? CupertinoPageScaffold(
      navigationBar:CustomWidgets.appbarIOS(title:widget.e ==null ?  "Add Policies" : "Update Policies", action: [], context: context, onTap: () {
        Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) {
          return Policies();
        },));
      },),
      child:  Column(children: [
        CustomWidgets.height(10),
        CustomWidgets.textFieldIOS(hintText: "Policies Name",controller: PoliciesName),
        CustomWidgets.textFieldIOS(hintText: "Select Department",controller: DeparmentName,readOnly: true,onTap: () {
          CustomWidgets.SelectDroupDown(context: context,items: Deparment, onSelectedItemChanged: (int) {
            DeparmentName.text=Deparment[int];
            setState(() {
            });
          });
        },suffix: CustomWidgets.aarowCupertinobutton(),
        ),
        CustomWidgets.textFieldIOS(hintText: "Description",controller: Description),
        CustomWidgets.textFieldIOS(hintText: "Date",controller: Date,readOnly: true,suffix: GestureDetector(onTap: () =>
            CustomWidgets.selectDateIOS(context: context, controller: Date),child: CustomWidgets.DateIconIOS())),
        Row(
          children: [
            CupertinoSwitch(
              value: isActive,
              onChanged: (value) {
                setState(() {
                  isActive = value;
                });
              },
              activeColor: Colorr.themcolor,
            ),
            Text("Active"),
          ],
        ),
        CustomWidgets.height(height/20),
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
                  PoliciesName.text="";
                  DeparmentName.text="";
                  Description.text="";
                  Date.text="";
                  isActive=false;
                  setState(() {
                  });
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
            Container(width: width/3,height: height/20,child:   CupertinoButton(
              color: Colorr.Reset,
              padding: EdgeInsets.zero,
              onPressed: () {
                FocusScope.of(context).unfocus();
                PoliciesName.text="";
                DeparmentName.text="";
                Description.text="";
                Date.text="";
                isActive=false;
                setState(() {
                });
                Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) {
                  return Policies();
                },));
              },
              child: Text('Cancel'),
            ) ,),
            SizedBox(width: 5),
            Container(width: width/3,height: height/20,child:CupertinoButton(
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
    ) :
    Scaffold(
      appBar: CustomWidgets.appbar(title: "Add New Policies",action:  [
      ],context:  context,onTap: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return Policies();
        },));
      },),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomWidgets.height(10),
              CustomWidgets.textField(hintText: "Policies Name",controller: PoliciesName),
            CustomDropdown.search(  listItemStyle: CustomWidgets.style(),
              hintText: 'Select Department',
              controller: DeparmentName,
              items: Deparment,
            ),

            CustomWidgets.textField(hintText: "Description",controller: Description),
            CustomWidgets.textField(hintText: "Date",controller: Date,readOnly: true,suffixIcon: InkWell(onTap: () =>
                CustomWidgets.selectDate(context: context, controller: Date),child: CustomWidgets.DateIcon())),
            Row(children : [
              Checkbox(
                shape: CircleBorder(),
                value: isActive,
                activeColor: Colorr.themcolor,
                onChanged: (value) {
                  setState(() {
                    isActive = value!;
                  });
                },
              ),
              Text("Active"),
            ]),
            CustomWidgets.height(25),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomWidgets.confirmButton(onTap:() {
                    FocusScope.of(context).unfocus();
                    PoliciesName.text="";
                    DeparmentName.text="";
                    Description.text="";
                    Date.text="";
                    isActive=false;
                    setState(() {
                    });
                  }, height: height/20, width: width/3.3, text: "Reset",Clr: Colorr.Reset),
                  CustomWidgets.confirmButton(onTap:() async {
                    FocusScope.of(context).unfocus();
                    if(await CustomWidgets.CheakConnectionInternetButton())
                    {
                      SaveButton("Save");
                    }else{
                    CustomWidgets.showToast(context, "No Internet Connection", false);
                    }

                  }, height:  height/20, width: width/3.3, text: "Save"),
                  CustomWidgets.confirmButton(onTap:() async {
                    FocusScope.of(context).unfocus();
                    if(await CustomWidgets.CheakConnectionInternetButton())
                    {
                    SaveButton("Save&Continue");
                    }else{
                    CustomWidgets.showToast(context, "No Internet Connection", false);
                    }

                  }, height:  height/20, width: width/2.7, text: "Save & Continue",),
                ]),
          ],
        ),
      ),
    ));
  }
  SaveButton(String Save)
  async {
    if(PoliciesName.text.trim().isEmpty)
      {
        CustomWidgets.showToast(context, "Policies name required",false);
      }else if(DeparmentName.text.trim().isEmpty)
    {
      CustomWidgets.showToast(context, "Department name required",false);
    }else if(Con_List.DeparmenntSelect.where((element) => element['name']==DeparmentName.text).isEmpty)
    {
      CustomWidgets.showToast(context, "Select Valid Department",false);
    }else if(Description.text.trim().isEmpty)
    {
      CustomWidgets.showToast(context, "Description name required",false);
    }else if(Date.text.trim().isEmpty)
    {
      CustomWidgets.showToast(context, "Date is required",false);
    }else{
      DateFormat inputFormat = DateFormat('dd-MM-yyyy');
      DateFormat outputFormat = DateFormat('yyyy-MM-dd');
      DateTime date = inputFormat.parse(Date.text);
      String formattedDate = outputFormat.format(date);
      Map data={
        if (widget.e != null)
          "id": widget.e!['_id'].toString()
        else
          "companyId": Constants_Usermast.companyId,
        "name" : PoliciesName.text,
        "departmentId" : Con_List.DeparmenntSelect.firstWhere((element) => element['name']==DeparmentName.text)['_id'].toString(),
        "description" : Description.text,
        "createDate" : date.toString(),
        "isActive" : isActive.toString(),
      };
      if(widget.e==null){
        if(await Policies_api.Policiesadd(data)){
          if(Save=="Save"){
            CustomWidgets.showToast(context, "Policies Add Successfully",true);
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Policies();
            },));
          }else{
            PoliciesName.text="";
            DeparmentName.text="";
            Description.text="";
            Date.text="";
            isActive=false;
            setState(() {
            });
            CustomWidgets.showToast(context, "Policies Add Successfully",true);
          }
        }
      }else{
        if(await Policies_api.PoliciesUpdate(data)){

          CustomWidgets.showToast(context, "Policies Add Successfully",true);
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Policies();
          },));
        }
      }

    }
  }

}
