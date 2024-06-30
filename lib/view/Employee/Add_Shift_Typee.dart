import 'package:attendy/A_SQL_Trigger/Con_Usermast.dart';
import 'package:attendy/utils/Constant/LocalCustomWidgets.dart';
import 'package:attendy/view/Employee/Shift.dart';
import 'package:attendy/view/Employee/Shifttype.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../A_SQL_Trigger/Shift_typee_add_api.dart';
import '../../utils/Constant/Colors.dart';
import '../Dashboard/Dashboard.dart';

class Add_Shift_Typee extends StatefulWidget {
  const Add_Shift_Typee({Key? key}) : super(key: key);

  @override
  State<Add_Shift_Typee> createState() => _Add_Shift_TypeeState();
}

class _Add_Shift_TypeeState extends State<Add_Shift_Typee> {
  TextEditingController Name=TextEditingController();
  TextEditingController Order=TextEditingController();
  bool isActive=false;
  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height-kToolbarHeight;
    double width=MediaQuery.of(context).size.width;
    Future<bool> onBackPress() {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return Shift_type();
      },));
      return Future.value(false);
    }
    return WillPopScope(
        onWillPop: () => onBackPress(),
    child:  Constants_Usermast.IOS==true ? CupertinoPageScaffold(
        navigationBar: CustomWidgets.appbarIOS(title: "Shift Type", action: [
        ], context: context, onTap: () {
          Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) {
            return Shift_type();
          },));
        },),
        child: Column(children: [
          CustomWidgets.height(10),
          CustomWidgets.textFieldIOS(hintText: "Name",controller: Name ),
          CustomWidgets.textFieldIOS(hintText: "Order",controller: Order,keyboardType: TextInputType.number),
          CustomWidgets.height(10),
          Row(
            children: [
              CupertinoSwitch(
                value: isActive,
                activeColor: Colorr.themcolor,
                onChanged: (value) {
                  setState(() {
                    isActive = value;
                  });
                },
              ),
              Text(
                "Active",
                style: TextStyle(fontSize: 13, color: Colorr.themcolor),
              ),
            ],
          ),
          CustomWidgets.height(15),
          Row(
            children: [
              SizedBox(width: 5),
              Expanded(flex: 2,
                child: CupertinoButton(
                  color: Colorr.Reset,
                  padding:EdgeInsets.zero,
                  onPressed: ()  {
                    Name.text="";
                    Order.text="";
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
                  onPressed:() async {
                    if(await CustomWidgets.CheakConnectionInternetButton())
                    {
                    saveButtton("Save");
                    }else{
                    CustomWidgets.showToast(context, "No Internet Connection", false);
                    }
                  },
                  child: Text("Save"),
                ),
              ),
              SizedBox(width: 5),
              Expanded(flex: 3,
                child: CupertinoButton(
                  color: Colorr.themcolor,
                  padding:EdgeInsets.zero,
                  onPressed: () async {
                    if(await CustomWidgets.CheakConnectionInternetButton())
                    {
                    saveButtton("Save&Continue");
                    }else{
                    CustomWidgets.showToast(context, "No Internet Connection", false);
                    }

                  },
                  child: Text("Save & Continue"),
                ),
              ),
              SizedBox(width: 5),
            ],
          ),
        ],)) :Scaffold(
      appBar: CustomWidgets.appbar(title: "Add New Shift Type" ,action:  [],context:  context,onTap: () {
        Navigator.pop(context);
      },),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(children: [
          CustomWidgets.height(10),
          CustomWidgets.textField(hintText: "Name",controller: Name ),
          CustomWidgets.textField(hintText: "Order",controller: Order,keyboardType: TextInputType.number),
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
          CustomWidgets.height(height/15),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomWidgets.confirmButton(onTap: () {
                  FocusScope.of(context).unfocus();
                  Name.text="";
                  Order.text="";
                  isActive=false;
                  setState(() {
                  });
                }, height: height/20, width: width/3.3, text: "Reset",Clr: Colorr.Reset),
                CustomWidgets.confirmButton(onTap: () async {
                  if(await CustomWidgets.CheakConnectionInternetButton())
                  {
                  saveButtton("Save");
                  }else{
                  CustomWidgets.showToast(context, "No Internet Connection", false);
                  }

                }, height: height/20, width: width/3.3, text: "Save"),
                CustomWidgets.confirmButton(onTap: () async {
                  if(await CustomWidgets.CheakConnectionInternetButton())
                  {
                  saveButtton("Save&Continue");
                  }else{
                  CustomWidgets.showToast(context, "No Internet Connection", false);
                  }

                }, height: height/20, width:width/2.9, text: "Save & Continue",),
              ]),
          CustomWidgets.height(5),
        ]),
      ),
    ));
  }
  saveButtton(String save) async {
    if(Name.text.trim().isEmpty)
      {
        CustomWidgets.showToast(context, "Name is required",false);
      }else if(Order.text.trim().isEmpty)
    {
      CustomWidgets.showToast(context, "Order is required",false);
    }else {
      Map data={
        "companyId" : Constants_Usermast.companyId,
        "name" : Name.text,
        "isActive" : isActive.toString(),
        "ord" : Order.text
      };
      if(await Shift_typee_api.shift_typeeinsert(data)){
        if(save=="Save"){
          CustomWidgets.showToast(context, "Shift Type Add Successfully",true);
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Shift_type();
          },));
        }else{
          CustomWidgets.showToast(context, "Shift Type Add Successfully",true);
          Name.text="";
          Order.text="";
          isActive=false;
          setState(() {
          });
        }
      }
    }

  }
}
