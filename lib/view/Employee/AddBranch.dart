import 'package:attendy/A_SQL_Trigger/Branchapi.dart';
import 'package:attendy/utils/Constant/LocalCustomWidgets.dart';
import 'package:attendy/view/Employee/Branch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../A_SQL_Trigger/Con_Usermast.dart';
import '../../utils/Constant/Colors.dart';

class AddBranch extends StatefulWidget {
  const AddBranch({Key? key}) : super(key: key);

  @override
  State<AddBranch> createState() => _AddBranchState();
}

class _AddBranchState extends State<AddBranch> {
  bool AddActive=false;
  bool perphone=true;
  TextEditingController BranchName=TextEditingController();
  TextEditingController ContactNumber=TextEditingController();
  TextEditingController Address=TextEditingController();
  TextEditingController Order =TextEditingController();
  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height-kToolbarHeight;
    double width =MediaQuery.of(context).size.width;
    Future<bool> onBackPress() {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return Branch();
      },));
      return Future.value(false);
    }
    return WillPopScope(
        onWillPop: () => onBackPress(),
    child: Constants_Usermast.IOS==true ? CupertinoPageScaffold(
      navigationBar: CustomWidgets.appbarIOS(title: "Add New Branch", action: [], context: context, onTap: () {
        Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) {
          return Branch();
        },));
      },),
        child:Column(children: [
          CustomWidgets.height(5),
          CustomWidgets.textFieldIOS(hintText: "Branch Name",controller: BranchName),
          CustomWidgets.textFieldIOS(hintText: "Contact Number",controller: ContactNumber,keyboardType: TextInputType.phone,MaxFont: 13),
          CustomWidgets.textFieldIOS(hintText: "Address",controller: Address),
          CustomWidgets.textFieldIOS(hintText: "Order",controller: Order,keyboardType: TextInputType.number),
          Row(
            children: [
              CustomWidgets.width(10),
              Text(
                "Active",
                style: TextStyle(fontSize: 13, color: CupertinoColors.black), // Replace with your desired text color
              ),
              CustomWidgets.width(7),
              CupertinoSwitch(
                value: AddActive,
                onChanged: (value) {
                  setState(() {
                    AddActive = value;

                  });
                },
                activeColor: Colorr.themcolor, // Replace with your desired active color
              ),

            ],
          ),
          CustomWidgets.height(10),
          Row(
            children: [
              SizedBox(width: 5),
              Expanded(flex: 2,
                child: CupertinoButton(
                  color: Colorr.Reset,
                  padding:EdgeInsets.zero,
                  onPressed: ()  {
                    BranchName.text="";
                    ContactNumber.text="";
                    Address.text="";
                    Order.text="";
                    AddActive=false;
                    Focus.of(context).unfocus();
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
                    SaveButton("Save");
                  },
                  child: Text("Save"),
                ),
              ),
              SizedBox(width: 5),
              Expanded(flex: 3,
                child: CupertinoButton(
                  color: Colorr.themcolor,
                  padding:EdgeInsets.zero,
                  onPressed: (){
                    SaveButton("Svae&Continue");
                  },
                  child: Text("Save & Continue"),
                ),
              ),
              SizedBox(width: 5),
            ],
          ),
        ])):Scaffold(
        appBar: CustomWidgets.appbar(title: "Add New Branch",action:  [],context:  context,onTap: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
            return Branch();
          },));
        },),
      body: Column(children: [
        CustomWidgets.height(5),
        CustomWidgets.textField(hintText: "Branch Name",controller: BranchName),
        CustomWidgets.textField(hintText: "Contact Number",controller: ContactNumber,keyboardType: TextInputType.phone,MaxFont: 13,height:65 ,onChanged: (value) {
          if(value.toString().length > 9)
          {
            perphone=true;
          }else{
            perphone=false;
          }
          setState(() {
          });
        },
            erroreText: perphone == false ? "Enter Phone number" : null,
            eorror   :  perphone == false ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.red,)
            ) : null
        ),
        CustomWidgets.textField(hintText: "Address",controller: Address),
        CustomWidgets.textField(hintText: "Order",controller: Order,keyboardType: TextInputType.number),
        Row(children : [
          Checkbox(
            shape: CircleBorder(),
            value: AddActive,
            activeColor: Colorr.themcolor,
            onChanged: (value) {
              setState(() {
                AddActive = value!;
              });
            },
          ),
          Text("Active"),
      ]),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomWidgets.confirmButton(onTap:() {
                BranchName.text="";
                ContactNumber.text="";
                Address.text="";
                Order.text="";
                AddActive=false;
                setState(() {
                });
              }, height: height/20, width: width/3.3, text: "Reset",Clr: Colorr.Reset),
              CustomWidgets.confirmButton(onTap:() async {
                FocusScope.of(context).unfocus();
                if(await CustomWidgets.CheakConnectionInternetButton())
                {
                SaveButton("Save");;
                }else{
                CustomWidgets.showToast(context, "No Internet Connection", false);
                }

              }, height: height/20, width: width/3.3, text: "Save"),
              CustomWidgets.confirmButton(onTap:() async {
                FocusScope.of(context).unfocus();
                if(await CustomWidgets.CheakConnectionInternetButton())
                {
                SaveButton("Svae&Continue");
                }else{
                CustomWidgets.showToast(context, "No Internet Connection", false);
                }

              }, height: height/20, width: width/2.7, text: "Save & Continue",),
            ]),
      ])
    ));
  }
  SaveButton(String Save) async {

    if(BranchName.text.trim().isEmpty)
    {
      CustomWidgets.showToast(context, "Branch name is required",false);
    }else if(Address.text.trim().isEmpty)
    {
      CustomWidgets.showToast(context, "Address is required",false);
    }else if(ContactNumber.text.length < 10)
    {
      CustomWidgets.showToast(context, "Enter Valid Contact Number",false);
    }else if(Order.text.trim().isEmpty)
    {
      CustomWidgets.showToast(context, "Ord is required",false);
    }else{
      Map data = {
        "companyId": Constants_Usermast.companyId,
        "name" : BranchName.text,
        "address" : Address.text,
        "ord"  : Order.text,
        "number" : ContactNumber.text,
        "isActive" : AddActive.toString()
      };
      if(await Branch_api.BranchInsert(data))
        {
          CustomWidgets.showToast(context, "Branch added Successfully",true);
          if(Save=="Save") {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
              return Branch();
            },));
          }else{
            BranchName.text="";
            ContactNumber.text="";
            Address.text="";
            Order.text="";
            AddActive=false;
            setState(() {
            });
          }
        }

    }
  }
}
