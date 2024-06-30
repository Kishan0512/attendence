import 'package:attendy/A_SQL_Trigger/Pagepermission_api.dart';
import 'package:attendy/A_SQL_Trigger/Role_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../A_SQL_Trigger/Con_List.dart';
import '../../A_SQL_Trigger/Con_Usermast.dart';
import '../../utils/Constant/Colors.dart';
import '../../utils/Constant/LocalCustomWidgets.dart';
import '../../utils/DroupDown/custom_dropdown.dart';
import '../Dashboard/Dashboard.dart';

class PagePermission extends StatefulWidget {
  const PagePermission({Key? key}) : super(key: key);

  @override
  State<PagePermission> createState() => _PagePermissionState();
}

class _PagePermissionState extends State<PagePermission> {
  @override
  List<String> Rolename=[];
  TextEditingController Role=TextEditingController();
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }
  getdata()
  async {
    Con_List.RoleSelect=await Role_api.RoleSelect();
    Con_List.RoleSelect.forEach((element) {
      if(element['isActive']==true) {
        Rolename.add(element['name']);
      }
    });

    setState(() {
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height-kToolbarHeight;
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
        navigationBar: CustomWidgets.appbarIOS(title: "Page Permission", action: [], context: context, onTap: () {
          Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) {
            return Dashboard();
          },));
        },),
        child:  Container(
          height: height,
          width: width,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: height / 5,
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
                    CustomWidgets.height(8),
                    CustomWidgets.textFieldIOS(hintText: "Role",controller: Role,readOnly: true,onTap: () {
                      CustomWidgets.SelectDroupDown(context: context,items: Rolename, onSelectedItemChanged: (int) async {
                        Role.text=Rolename[int];
                        if (Con_List.RoleSelect.where((element) => Role.text == element['name']).isNotEmpty) {
                          Con_List.Pagepermission = await Pagepermission_api.PagepermissionSelect(Con_List.RoleSelect.firstWhere((e) => e['name'] == Role.text)['_id'].toString());
                          FocusScope.of(context).unfocus();
                          setState(() {
                          });
                        }
                        setState(() {
                        });
                      });
                    },suffix: CustomWidgets.aarowCupertinobutton(),
                    ),
                    CustomWidgets.height(height/30),
                    Con_List.Drawer.where((element) => element['subname']=='Page Permission' && element['update']==true).isNotEmpty ?
                    Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomWidgets.confirmButton1(onTap: () {
                            FocusScope.of(context).unfocus();
                            setState(() {
                            });
                          }, height: height/20, width: width/3, text: "Reset",Clr: Colorr.Reset, textsize: 12),
                          CustomWidgets.width(5),
                          CustomWidgets.confirmButton1(onTap: () {
                            SaveButton();
                          }, height: height/20, width: width/3, text: "Save", textsize: 12),
                        ]) : Container(),
                  ],
                ),
              ),
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
                    child:Container(
                        width: double.infinity,
                        child: Con_List.Pagepermission.isNotEmpty
                            ? SingleChildScrollView(
                          child: SingleChildScrollView(
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
                                    label: Text('Sub Name'),
                                  ),
                                  DataColumn(
                                    label: Text('Select'),
                                  ),
                                  DataColumn(
                                    label: Text('Insert'),
                                  ),
                                  DataColumn(
                                    label: Text('Update'),
                                  ),
                                  DataColumn(
                                    label: Text('Delete'),
                                  ),
                                ],
                                rows: Con_List.Pagepermission.asMap().entries.map((entry) {
                                  int index = entry.key + 1;
                                  final e = entry.value;
                                  return DataRow(cells: [
                                    DataCell(Text(index.toString())),
                                    DataCell(Text(e['name']!)),
                                    DataCell(Text(e['subname']!)),
                                    DataCell(
                                      Checkbox(
                                        value: e['select'],
                                        shape: CircleBorder(),
                                        activeColor: Colorr.themcolor,
                                        onChanged: (value) {
                                          e['select']=value;
                                          setState(() {

                                          });
                                        },
                                      ),
                                    ),
                                    DataCell(
                                      Checkbox(
                                        value: e['insert'],
                                        shape: CircleBorder(),
                                        activeColor: Colorr.themcolor,
                                        onChanged: (value) {
                                          e['insert']=value;
                                          setState(() {

                                          });
                                        },
                                      ),
                                    ),
                                    DataCell(
                                      Checkbox(
                                        value: e['update'],
                                        shape: CircleBorder(),
                                        activeColor: Colorr.themcolor,
                                        onChanged: (value) {
                                          e['update']=value;
                                          setState(() {
                                          });
                                        },
                                      ),
                                    ),
                                    DataCell(
                                      Checkbox(
                                        value: e['delate'],
                                        shape: CircleBorder(),
                                        activeColor: Colorr.themcolor,
                                        onChanged: (value) {
                                          e['delate']=value;
                                          setState(() {

                                          });
                                        },
                                      ),
                                    )

                                  ]);
                                }).toList()),
                          ),
                        )
                            : Container())),
              ),
            ],
          ),
        )) :
    Scaffold(
      appBar: CustomWidgets.appbar(title: "Page Permission",action:  [
      ],context:  context,onTap: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return Dashboard();
        },));
      },),
        body: Column(children: [
          CustomWidgets.height(10),
          CustomDropdown.search(listItemStyle: CustomWidgets.style(),
            hintText: 'Select Role',
            controller: Role ,
            items: Rolename,
            onChanged: (value) async {
              if (Con_List.RoleSelect.where((element) => Role.text == element['name']).isNotEmpty) {
                Con_List.Pagepermission = await Pagepermission_api.PagepermissionSelect(Con_List.RoleSelect.firstWhere((e) => e['name'] == Role.text)['_id'].toString());
                FocusScope.of(context).unfocus();
                setState(() {
                });
              }
            },
          ),
          Con_List.Drawer.where((element) => element['subname']=='Page Permission' && element['update']==true).isNotEmpty ?
          Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomWidgets.confirmButton(onTap: () {
                  FocusScope.of(context).unfocus();
                  setState(() {
                  });
                }, height: height/20, width: width/3, text: "Reset",Clr: Colorr.Reset),
                CustomWidgets.width(5),
                CustomWidgets.confirmButton(onTap: () {
                  SaveButton();
                }, height: height/20, width: width/3, text: "Save"),
              ]) : Container(),
          CustomWidgets.height(10),
          Expanded(
            child: Container(
                width: double.infinity,
                child: Con_List.Pagepermission.isNotEmpty
                    ? SingleChildScrollView(
                      child: SingleChildScrollView(
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
                            label: Text('Sub Name'),
                          ),
                          DataColumn(
                            label: Text('Select'),
                          ),
                          DataColumn(
                            label: Text('Insert'),
                          ),
                          DataColumn(
                            label: Text('Update'),
                          ),
                          DataColumn(
                            label: Text('Delete'),
                          ),
                        ],
                        rows: Con_List.Pagepermission.asMap().entries.map((entry) {
                          int index = entry.key + 1;
                          final e = entry.value;
                          return DataRow(cells: [
                            DataCell(Text(index.toString())),
                            DataCell(Text(e['name']!)),
                            DataCell(Text(e['subname']!)),
                            DataCell(
                              Checkbox(
                                value: e['select'],
                                shape: CircleBorder(),
                                activeColor: Colorr.themcolor,
                                onChanged: (value) {
                                  e['select']=value;
                                  setState(() {});
                                },
                              ),
                            ),
                            DataCell(
                              Checkbox(
                                value: e['insert'],
                                shape: CircleBorder(),
                                activeColor: Colorr.themcolor,
                                onChanged: (value) {
                                  e['insert']=value;
                                  setState(() {

                                  });
                                },
                              ),
                            ),
                            DataCell(
                              Checkbox(
                                value: e['update'],
                                shape: CircleBorder(),
                                activeColor: Colorr.themcolor,
                                onChanged: (value) {
                                  e['update']=value;
                                  setState(() {
                                  });
                                },
                              ),
                            ),
                            DataCell(
                              Checkbox(
                                value: e['delate'],
                                shape: CircleBorder(),
                                activeColor: Colorr.themcolor,
                                onChanged: (value) {
                                  e['delate']=value;
                                  setState(() {

                                  });
                                },
                              ),
                            )

                          ]);
                        }).toList()),
                ),
                    )
                    : Container()),
          ),
        ]),
    ));
  }
  SaveButton()
  {
     Con_List.Pagepermission.forEach((element) async {
      Map data={
        "id" : element['_id'],
        "select" : element['select'].toString(),
        "insert" : element['insert'].toString(),
        "update" : element['update'].toString(),
        "delate" : element['delate'].toString(),
      };
     if(await Pagepermission_api.PagepermissionUpdate(data)){
       CustomWidgets.showToast(context, "Page Permission Change successfully", true);
       Con_List.Pagepermission.clear();
       Role.text="";
       setState(() {
       });
     }
    });
  }
}
