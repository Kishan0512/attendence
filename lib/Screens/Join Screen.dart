import 'dart:convert';
import 'dart:developer';

import 'package:attendy/A_SQL_Trigger/Con_Usermast.dart';
import 'package:attendy/Screens/Log_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:attendy/utils/Constant/Colors.dart';
import 'package:attendy/utils/Constant/FontWeight.dart';
import '../A_SQL_Trigger/SharePref.dart';
import '../A_SQL_Trigger/api_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../A_SQL_Trigger/Con_List.dart';
import '../utils/Constant/LocalCustomWidgets.dart';
import '../utils/DroupDown/custom_dropdown.dart';
import 'SetupFace.dart';

class JoinScreen extends StatefulWidget {
  const JoinScreen({Key? key}) : super(key: key);

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  TextEditingController txtName = TextEditingController();
  TextEditingController Companyname = TextEditingController();
  TextEditingController Count = TextEditingController();

  double increase = 0;
  var size, height, width;
  // String? Count;
  ValueNotifier<bool> newcompany = ValueNotifier<bool>(false);
  var buttonWidth;
  List<String> Employcount = [
    "0 to 5",
    "5 to 10",
    "10 to 50",
    "50 to 100",
    "100 to 200",
    "Above 200"
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    buttonWidth = size.width / 2;
    return Constants_Usermast.IOS ==true? CupertinoPageScaffold(child: SafeArea(
      child: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colorr.themcolor,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 150),
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50)),
                color: Colorr.themcolor50,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 23, left: 10, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: height * 0.09,
                      ),
                      Center(
                        child: Text(
                          "Join Now",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              color: Colorr.themcolor,
                              fontSize: 28,
                              fontWeight: FWeight.fW600),
                        ),
                      ),
                      Center(
                        child: Text(
                          "You are almost there",
                          style: TextStyle(
                              fontFamily: "PoppinsR",
                              color: Colorr.themcolor,
                              fontSize: 14,
                              fontWeight: FWeight.fW400),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        padding: const EdgeInsets.only(left: 25),
                        decoration: BoxDecoration(
                          color: Colorr.White,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                                color: Colorr.themcolor200,
                                blurRadius: 5,
                                spreadRadius: 0.5,
                                offset: const Offset(2, 3))
                          ],
                        ),
                        child: CupertinoTypeAheadField(
                          textFieldConfiguration: CupertinoTextFieldConfiguration(
                              controller: Companyname,
                              onChanged: (value) {
                              },
                              style: TextStyle(color: Colorr.themcolor300, fontSize: 18),
                              textInputAction: TextInputAction.done,
                              placeholder:'Enter an organization name',
                              placeholderStyle: TextStyle(color: Colorr.themcolor200, fontSize: 15),
                               decoration: BoxDecoration(border: Border.all(color: Colors.transparent
                               ))
                          ),
                          suggestionsCallback: (pattern) async {
                            // Replace the sample list with your own list of objects
                            final List organizations = Con_List.CompanySelect;
                            // Filter the list based on the user's input
                            final filtered = organizations.where((organization) =>
                                organization["name"].toLowerCase().contains(pattern.toLowerCase())
                            ).toList();
                            if(filtered.isEmpty)
                            {
                              newcompany.value=true;
                            }else{
                              newcompany.value=false;
                            }
                            return filtered.map<String>((organization) => organization["name"]).toList();
                          },
                          itemBuilder: (context, suggestion) {
                            return CupertinoListTile(
                              title: Text(suggestion),
                              leading: Image.asset("images/companyleg.png"),
                            );
                          },
                          onSuggestionSelected: (suggestion) {
                            Companyname.text =suggestion;
                          },
                          hideSuggestionsOnKeyboardHide: false,
                          hideOnEmpty: true,
                        ),

                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ValueListenableBuilder<bool>(
                        valueListenable: newcompany,
                        builder: (BuildContext context, bool value, Widget? child) {
                          return value
                              ?       CustomWidgets.textFieldIOS(hintText: "Employees Count",controller: Count,readOnly: true,onTap: () {
                            CustomWidgets.SelectDroupDown(context: context,items: Employcount, onSelectedItemChanged: (int) {
                              Count.text=Employcount[int];
                              setState(() {
                              });
                            });
                          },suffix: CustomWidgets.aarowCupertinobutton(),)
                              : Container();
                        },
                      ),
                      SizedBox(
                        height: height * 0.04,
                      ),
                      CustomWidgets.swipeButton(Colorr.White, "Continue", () {
                        Future.delayed(const Duration(milliseconds: 500), () async {
                          if(newcompany.value==true)
                          {
                            await api_page.NewCompany(Companyname.text,Count.text.toString());
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>  Log_in()));
                          }
                          else
                          {
                            String Com=Con_List.CompanySelect.where((e) => e['name'] ==Companyname.text).first['_id'].toString();
                            api_page.roleMasterCheak(Com);
                            api_page.EmployeeUpdateComid(Com);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>  Log_in()));
                          }

                        });
                      })
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    )) :Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colorr.themcolor,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 150),
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50)),
                color: Colorr.themcolor50,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 23, left: 10, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: height * 0.09,
                      ),
                      Center(
                        child: Text(
                          "Join Now",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              color: Colorr.themcolor,
                              fontSize: 28,
                              fontWeight: FWeight.fW600),
                        ),
                      ),
                      Center(
                        child: Text(
                          "You are almost there",
                          style: TextStyle(
                              fontFamily: "PoppinsR",
                              color: Colorr.themcolor,
                              fontSize: 14,
                              fontWeight: FWeight.fW400),
                        ),
                      ),
                    Container(
                      height: 50,
                      width: double.infinity,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      padding: const EdgeInsets.only(left: 25),
                      decoration: BoxDecoration(
                        color: Colorr.White,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                              color: Colorr.themcolor200,
                              blurRadius: 5,
                              spreadRadius: 0.5,
                              offset: const Offset(2, 3))
                        ],
                      ),
                      child: TypeAheadField(
                        textFieldConfiguration: TextFieldConfiguration(
                          controller: Companyname,
                           onChanged: (value) {
                           },
                            onTapOutside: (event) {
                              FocusScope.of(context).unfocus();
                            },
                           style: TextStyle(color: Colorr.themcolor300, fontSize: 18),
                            textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colorr.themcolor200, fontSize: 15),
                            hintText: 'Enter an organization name',
                          )
                        ),
                        suggestionsCallback: (pattern) async {
                          final List organizations = Con_List.CompanySelect;
                          final filtered = organizations.where((organization) =>
                              organization["name"].toLowerCase().contains(pattern.toLowerCase())
                          ).toList();
                          if(filtered.isEmpty)
                          {
                            newcompany.value=true;
                          }else{
                            newcompany.value=false;
                          }
                          log(filtered.toString());
                          return filtered.map<Map>((organization) => organization).toList();
                        },
                        itemBuilder: (context, suggestion) {
                          String temp=suggestion['icon'].toString();
                          Uint8List? image;
                          if(temp!="") {
                            if(temp.contains("data:image"))
                            {
                              image =base64.decode(temp.split(',')[1]);
                            }else{
                              image =base64.decode(temp);
                            }
                          }
                          return ListTile(
                            title: Text(suggestion['name']),
                            leading: Container(width: 30,height: 30,decoration: BoxDecoration(shape: BoxShape.circle,image:image!=null? DecorationImage(fit: BoxFit.cover,image: MemoryImage(image)):DecorationImage(image:AssetImage("images/companyleg.png",)))),
                          );
                        },
                        onSuggestionSelected: (suggestion) {
                          Companyname.text =suggestion['name'];
                        },
                        hideOnEmpty: true,
                      ),
                    ),
                      SizedBox(
                        height: 10,
                      ),
                  ValueListenableBuilder<bool>(
                    valueListenable: newcompany,
                    builder: (BuildContext context, bool value, Widget? child) {
                      return value
                          ?  CustomDropdown.search(listItemStyle: CustomWidgets.style(),
                        hintText: 'Employees Count',
                        controller: Count,
                        items: Employcount,
                      )
                          : Container();
                    },
                  ),
                      SizedBox(
                        height: height * 0.04,
                      ),
                      CustomWidgets.swipeButton(Colorr.White, "Continue", () {
                        Future.delayed(const Duration(milliseconds: 500), () async {
                          if(newcompany.value==true)
                            {
                              await api_page.NewCompany(Companyname.text,Count.text.toString());
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>  Log_in()));
                            }
                          else
                            {
                              String Com=Con_List.CompanySelect.where((e) => e['name'] ==Companyname.text).first['_id'].toString();

                               api_page.roleMasterCheak(Com);
                               // api_page.EmployeeUpdateComid(Com);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>  Log_in()));
                          }

                        });
                      })
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget NameField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: CustomWidgets.container(
        height: 60,
        borderColor: Colorr.themcolor50,
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: CustomWidgets.textField(
            enabledBorder: BorderSide.none,
            hintText: "Organization Name",
            borderSide: BorderSide.none,
            fontColor: Colorr.themcolor200,
            textHeight: 0.50,
          ),
        ),
      ),
    );
  }

  // Widget EmployeeNOField() {
  //   return CustomWidgets.dropDownButton(
  //       "Employees Count",
  //       Employcount.map(
  //         (item) => DropdownMenuItem<String>(
  //           value: item,
  //           child: Text(
  //             item,
  //             style: TextStyle(
  //                 fontFamily: "PoppinsR",
  //                 color: Colorr.themcolor200,
  //                 fontSize: 15,
  //                 fontWeight: FWeight.fW400),
  //           ),
  //         ),
  //       ).toList(),
  //       Count, (value) {
  //     setState(() {
  //       Count = value as String?;
  //     });
  //   });
  // }
}