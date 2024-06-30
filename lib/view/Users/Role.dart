import 'package:attendy/A_SQL_Trigger/Con_List.dart';
import 'package:attendy/A_SQL_Trigger/Con_Usermast.dart';
import 'package:attendy/A_SQL_Trigger/Role_api.dart';
import 'package:attendy/utils/Constant/LocalCustomWidgets.dart';
import 'package:attendy/view/Dashboard/Dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/Constant/Colors.dart';

class Role extends StatefulWidget {
  const Role({Key? key}) : super(key: key);

  @override
  State<Role> createState() => _RoleState();
}
class _RoleState extends State<Role> {
  TextEditingController NewRole=TextEditingController();
  TextEditingController RoleUpadate=TextEditingController();
  double height =0;
  double width=0;
  bool Update=false;
  String UpdateID="";
  int internetConn=0;
  bool isActive=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
    CheakInternet();
  }
  CheakInternet()
  async {
    internetConn = await CustomWidgets.CheakConnectionInternet();
    setState(() {
    });
  }
  getdata()
  async {
    Con_List.RoleSelect = await Role_api.RoleSelect();
    setState(() {
    });
  }
  Widget build(BuildContext context) {
    double height =MediaQuery.of(context).size.height-kToolbarHeight;
    double width=MediaQuery.of(context).size.width;
    Future<bool> onBackPress() {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return Dashboard();
      },));
      return Future.value(false);
    }
    return WillPopScope(
        onWillPop: () => onBackPress(),
    child:
    Constants_Usermast.IOS==true ?CupertinoPageScaffold(
        navigationBar: CustomWidgets.appbarIOS(title: "Role", action: [], context: context, onTap: () {
          Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) {
            return Dashboard();
          },));
        },),
        child:  Container(
          height: height,
          width: width,
          child: Column(
            children: [
              Con_List.Drawer.where((element) => element['subname']=='Role' && element['insert']==true).isNotEmpty ?
              Container(
                width: double.infinity,
                height: height / 4.2,
                padding: const EdgeInsets.only(
                    left: 5, right: 5, top: 10, bottom: 10),
                decoration: BoxDecoration(color: Colorr.White, boxShadow: [
                  BoxShadow(
                    color: Colorr.themcolor100,
                    blurStyle: BlurStyle.outer,
                    blurRadius: 8,
                  ),
                ]),
                child: Column(
                  children: [
                    CustomWidgets.height(5),
                    CustomWidgets.textFieldIOS(
                        hintText: "Add New Role", controller: NewRole),
                    Row(
                      children: [
                        CustomWidgets.width(7),
                        Text(
                          "Active",
                          style: TextStyle(fontSize: 13, color: CupertinoColors.black), // Replace with your desired text color
                        ),
                        CustomWidgets.width(7),
                        CupertinoSwitch(
                          value: isActive ,
                          onChanged: (value) {
                            setState(() {
                              isActive = value;
                            });
                          },
                          activeColor: Colorr.themcolor, // Replace with your desired active color
                        ),
                      ],
                    ),
                    CustomWidgets.height(5),
                    Row(
                      children: [
                        Expanded(flex: 2,child: SizedBox(width: 5)),
                        Expanded(flex: 2,
                          child: CupertinoButton(
                            color: Colorr.Reset,
                            padding:EdgeInsets.zero,
                            onPressed: () {
                              NewRole.text="";
                              isActive=false;
                              UpdateID="";
                              Update=false;
                              setState(() {
                              });
                              FocusScope.of(context).unfocus();
                            },
                            child: Text('Reset'),
                          ),
                        ),
                        SizedBox(width: 5),
                        Expanded(flex: 2,
                          child: CupertinoButton(
                            color: Colorr.themcolor,
                            padding:EdgeInsets.zero,
                            onPressed: ()async {
                              FocusScope.of(context).unfocus();
                              if(await CustomWidgets.CheakConnectionInternetButton())
                              {
                                if(Update)
                                  {
                                    if(await Role_api.RoleUpdate(UpdateID,NewRole.text,isActive)){
                                      getdata();
                                      NewRole.text="";
                                      isActive=false;
                                      UpdateID="";
                                      Update=false;
                                      setState(() {
                                      });
                                      CustomWidgets.showToast(context, "Role Update Successfully",true);
                                    }else{
                                      CustomWidgets.showToast(context, "Role Not Updated",false);
                                    }
                                  }else{
                                  if(NewRole.text.trim().isEmpty)
                                  {
                                    CustomWidgets.showToast(context, "Role is required",false);
                                  }else{
                                    Map data={
                                      "companyId" : Constants_Usermast.companyId,
                                      "isActive" : isActive.toString(),
                                      "name" : NewRole.text,
                                      "shortKey" : NewRole.text.toUpperCase().substring(0,1)
                                    };
                                    if(await Role_api.Roleinsert(data)){
                                      getdata();
                                      NewRole.text="";
                                      isActive=false;
                                      UpdateID="";
                                      Update=false;
                                      setState(() {
                                      });
                                      CustomWidgets.showToast(context, "Role Add Successfully",true);
                                    }
                                  }
                                }
                              }else{
                                CustomWidgets.showToast(context, "No Internet Connection", false);
                              };

                            },
                            child: Text(Update ? "Update" : "Save"),
                          ),
                        ),

                        SizedBox(width: 5),
                      ],
                    ),
                    CustomWidgets.height(8)
                  ],
                ),
              ) : Container(),
              Expanded(
                child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(left: 5, right: 5),
                    margin: EdgeInsets.only(top: 10),
                    decoration:
                    BoxDecoration(color: Colorr.White, boxShadow: [
                      BoxShadow(
                        color: Colorr.themcolor100,
                        blurStyle: BlurStyle.outer,
                        blurRadius: 8,
                      ),
                    ]),
                    child:Con_List.RoleSelect.isNotEmpty
                        ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                          columns: [
                            DataColumn(
                              label: Text('No'),
                            ),
                            DataColumn(
                              label: Text('Name'),
                            ),
                            DataColumn(
                              label: Text('Status'),
                            ),
                            DataColumn(
                              label: Text('Action'),
                            ),
                          ],
                          rows: Con_List.RoleSelect.asMap().entries.map((entry) {
                            int index = entry.key + 1;
                            final e = entry.value;
                            return DataRow(cells: [
                              DataCell(Text(index.toString())),
                              DataCell(Text(e['name']!.toString())),
                              DataCell( Row(
                                children: [
                                  Checkbox(
                                    shape: CircleBorder(),
                                    value: e['isActive'],
                                    activeColor: Colorr.themcolor,
                                    onChanged: (value) {
                                    },
                                  ),
                                ],
                              ),),
                              DataCell(Row(
                                children: [
                                  Con_List.Drawer.where((element) => element['subname']=='Role' && element['update']==true).isNotEmpty ?
                                  InkWell(
                                      onTap: () {
                                        NewRole.text=e['name'].toString();
                                        isActive=e['isActive'];
                                        Update=true;
                                        UpdateID=e['_id'].toString();
                                        setState(() {
                                        });
                                      },
                                      child: Icon(
                                        Icons.edit,
                                        color: Colorr.themcolor,
                                        size: 22,
                                      )) : Container(),
                                ],
                              )),
                            ]);
                          }).toList()),
                    )
                        : Container()),
              ),
            ],
          ),
        )) :
    Scaffold(
      appBar: CustomWidgets.appbar(title: "Role",action:  [
      ],context:  context,onTap: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return Dashboard();
        },));
      },),
      body: Container(
        height: height,
        width: width,
        child: Column(
          children: [
            Con_List.Drawer.where((element) => element['subname']=='Role' && element['insert']==true).isNotEmpty ?
            Container(
              width: double.infinity,
              height: height/4.2,
              padding: const EdgeInsets.only(left: 5,right: 5,top: 10,bottom: 10),
              decoration:  BoxDecoration(color: Colorr.White, boxShadow: [
                BoxShadow(
                  color: Colorr.themcolor100,
                  blurStyle: BlurStyle.outer,
                  blurRadius: 8,
                ),
              ]),
              child: Column(
                children: [
                  CustomWidgets.width(30),
                  CustomWidgets.textField(hintText: "Add New Role",controller: NewRole),
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
                  Spacer(),
                  Row(mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomWidgets.confirmButton(onTap:() {
                          NewRole.text="";
                          isActive=false;
                          UpdateID="";
                          Update=false;
                          setState(() {
                          });
                          FocusScope.of(context).unfocus();
                        }, height:height/ 20, width: width/3.3, text: "Reset",Clr: Colorr.Reset),
                        CustomWidgets.width(5),
                       Update ? CustomWidgets.confirmButton(onTap:() async {
                         FocusScope.of(context).unfocus();
                         if(await CustomWidgets.CheakConnectionInternetButton())
                         {
                           if(await Role_api.RoleUpdate(UpdateID,NewRole.text,isActive)){
                             getdata();
                             NewRole.text="";
                             isActive=false;
                             UpdateID="";
                             Update=false;
                             setState(() {
                             });
                             CustomWidgets.showToast(context, "Role Update Successfully",true);
                           }else{
                             CustomWidgets.showToast(context, "Role Not Updated",false);
                           }
                         }else{
                           CustomWidgets.showToast(context, "No Internet Connection", false);
                         }
                         FocusScope.of(context).unfocus();
                       }, height: height/20, width: width/3.3, text: "Update",)
                           : CustomWidgets.confirmButton(onTap:() async {
                          if(await CustomWidgets.CheakConnectionInternetButton())
                          {
                            if(NewRole.text.trim().isEmpty)
                            {
                              CustomWidgets.showToast(context, "Role is required",false);
                            }else{
                              Map data={
                                "companyId" : Constants_Usermast.companyId,
                                "isActive" : isActive.toString(),
                                "name" : NewRole.text,
                                "shortKey" : NewRole.text.toUpperCase().substring(0,1)
                              };
                              if(await Role_api.Roleinsert(data)){
                                getdata();
                                NewRole.text="";
                                isActive=false;
                                UpdateID="";
                                Update=false;
                                setState(() {
                                });
                                CustomWidgets.showToast(context, "Role Add Successfully",true);
                              }
                            }
                          }else{
                            CustomWidgets.showToast(context, "No Internet Connection", false);
                          }

                          FocusScope.of(context).unfocus();
                        }, height: height/20, width: width/3.3, text: "Save",),
                      ]),
                  CustomWidgets.width(20),
                ],
              ),
            ) : Container(),
            Expanded(
              child: mainwidget(),
              ),
          ],
        ),
      ),
    ));
  }
  Widget mainwidget() {
    if (internetConn == 1) {
      return Con_List.RoleSelect.isNotEmpty ? Container(
          width: double.infinity,
          padding: EdgeInsets.only(left: 5,right: 5),
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(color: Colorr.White, boxShadow: [
            BoxShadow(
              color: Colorr.themcolor100,
              blurStyle: BlurStyle.outer,
              blurRadius: 8,
            ),
          ]),
          child: Con_List.RoleSelect.isNotEmpty
              ? SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
                columns: [
                  DataColumn(
                    label: Text('No'),
                  ),
                  DataColumn(
                    label: Text('Name'),
                  ),
                  DataColumn(
                    label: Text('Status'),
                  ),
                  DataColumn(
                    label: Text('Action'),
                  ),
                ],
                rows: Con_List.RoleSelect.asMap().entries.map((entry) {
                  int index = entry.key + 1;
                  final e = entry.value;
                  return DataRow(cells: [
                    DataCell(Text(index.toString())),
                    DataCell(Text(e['name']!.toString())),
                    DataCell( Row(
                      children: [
                        Checkbox(
                          shape: CircleBorder(),
                          value: e['isActive'],
                          activeColor: Colorr.themcolor,
                          onChanged: (value) {
                          },
                        ),
                      ],
                    ),),
                    DataCell(Row(
                      children: [
                        Con_List.Drawer.where((element) => element['subname']=='Role' && element['update']==true).isNotEmpty ?
                        InkWell(
                            onTap: () {
                              NewRole.text=e['name'].toString();
                              isActive=e['isActive'];
                              Update=true;
                              UpdateID=e['_id'].toString();
                              setState(() {
                              });
                            },
                            child: Icon(
                              Icons.edit,
                              color: Colorr.themcolor,
                              size: 22,
                            )) : Container(),
                      ],
                    )),
                  ]);
                }).toList()),
          )
              : Container()) : CustomWidgets.NoDataImage(context);
    } else if (internetConn == 2) {
      return CustomWidgets.NoInternetImage(context);
    } else {
      return CustomWidgets.Circularprogress(context);
    }
  }
}
