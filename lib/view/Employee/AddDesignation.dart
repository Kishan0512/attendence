
import 'package:attendy/A_SQL_Trigger/Con_List.dart';
import 'package:attendy/A_SQL_Trigger/Deparment_api_page.dart';
import 'package:attendy/A_SQL_Trigger/Designations_api.dart';
import 'package:attendy/utils/Constant/LocalCustomWidgets.dart';
import 'package:flutter/material.dart';

import '../../A_SQL_Trigger/Con_Usermast.dart';
import '../../utils/Constant/Colors.dart';
import '../../utils/DroupDown/custom_dropdown.dart';
import 'Destination.dart';

class AddDesignation extends StatefulWidget {
  const AddDesignation({Key? key}) : super(key: key);

  @override
  State<AddDesignation> createState() => _AddDesignationState();
}

class _AddDesignationState extends State<AddDesignation> {
  List<String> Deparmentadd = [];
  bool isActive = true;
  TextEditingController DeparmentSelected = TextEditingController();
  TextEditingController DesignationName = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  getdata() async {
    Con_List.DeparmenntSelect = await Deparmentapi.DeparmentSelect();
    Con_List.DeparmenntSelect.forEach((element) {
      if(element['isActive']==true) {
        Deparmentadd.add(element['name']);
      }
    });
  }

  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height-kToolbarHeight;
    double width = MediaQuery.of(context).size.width;
    Future<bool> onBackPress() {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return Designation();
      },));
      return Future.value(false);
    }
    return WillPopScope(
        onWillPop: () => onBackPress(),
    child: Scaffold(
      appBar: CustomWidgets.appbar(title: "Add New Designation",action:  [],context:  context,onTap: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return Designation();
        },));
      },),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomWidgets.height(10),
            CustomDropdown.search(  listItemStyle: CustomWidgets.style(),
              hintText: 'Select Employee',
              controller: DeparmentSelected,
              items: Deparmentadd,
            ),
            CustomWidgets.height(10),
            CustomWidgets.textField(
                hintText: "Designation", controller: DesignationName),
            Row(
              children: [
                Checkbox(
                  shape: CircleBorder(),
                  value: isActive,
                  activeColor: Colorr.themcolor,
                  onChanged: (value) {
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
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomWidgets.confirmButton(onTap: () {
                    DeparmentSelected.text="";
                    DesignationName.text="";
                    FocusScope.of(context).unfocus();
                    setState(() {
                    });
                  }, height: height/20, width: width/3.3, text: "Reset",Clr: Colorr.Reset),
                  CustomWidgets.confirmButton(onTap: () {
                    saveButtton("Save");
                  }, height:  height/20, width: width/3.3, text: "Save"),
                  CustomWidgets.confirmButton(onTap: () {
                    saveButtton("Save&Continue");
                  }, height:  height/20, width: width/2.7, text: "Save & Continue",),
                ]),
          ],
        ),
      ),
    ));
  }

  saveButtton(String Save) async {
    FocusScope.of(context).unfocus();
    if(DeparmentSelected.text.trim().isEmpty)
      {
        CustomWidgets.showToast(context, "Deparment Name is required",false);
      }else if(DesignationName.text.trim().isEmpty)
        {
          CustomWidgets.showToast(context, "Designation Name is required",false);
        }else if(Con_List.DeparmenntSelect.where((e) => e['name'] == DeparmentSelected.text).isEmpty){
      CustomWidgets.showToast(context, "Enter Valid Deparment Name",false);
    }else{
      Map data={
        "companyId" : Constants_Usermast.companyId,
        "name" : DesignationName.text,
        "deparmentId" : Con_List.DeparmenntSelect.firstWhere((e) => e['name'] == DeparmentSelected.text)['_id'].toString(),
        "isActive" : isActive.toString(),
      };
      if (await Designations_api.DesignationsInsert(data)){

        CustomWidgets.showToast(context, "Designation Add Successfully",true);
           if(Save=="Save")
             {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                  return Designation();
                },));
             }else{
                DeparmentSelected.text="";
                DesignationName.text="";
                setState(() {
                });
           }
      }
    }

  }
}
