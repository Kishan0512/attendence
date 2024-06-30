import 'package:attendy/A_SQL_Trigger/Con_List.dart';
import 'package:attendy/A_SQL_Trigger/Con_Usermast.dart';
import 'package:attendy/A_SQL_Trigger/Deparment_api_page.dart';
import 'package:attendy/A_SQL_Trigger/Designations_api.dart';
import 'package:attendy/A_SQL_Trigger/Employee_Add_api.dart';
import 'package:attendy/A_SQL_Trigger/Policies_api.dart';
import 'package:attendy/utils/Constant/LocalCustomWidgets.dart';
import 'package:attendy/view/Dashboard/Dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/Constant/Colors.dart';

class Department extends StatefulWidget {
  const Department({Key? key}) : super(key: key);

  @override
  State<Department> createState() => _DepartmentState();
}

class _DepartmentState extends State<Department> {
  FocusNode _textFieldFocusNode = FocusNode();
  double height = 0;
  double width = 0;
  int internetConn=0;
  String UpdateId="";
  bool Update=false;
  TextEditingController Deparment = TextEditingController();
  TextEditingController Orderby = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isActive = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CheakInternet();
    getdata();
  }
  CheakInternet()
  async {
    internetConn = await CustomWidgets.CheakConnectionInternet();
    setState(() {
    });
  }
  getdata() async {
    Con_List.DeparmenntSelect = await Deparmentapi.DeparmentSelect();
    Con_List.AllEmployee = await AllEmployee_api.EmployeeSelect();
    Con_List.DesignationSelect=await Designations_api.DesignationsSelect("All");
    Con_List.Policies = await Policies_api.PoliciesSelect();
    setState(() {});
  }
@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _textFieldFocusNode.dispose();
  }
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height - kToolbarHeight;
    width = MediaQuery.of(context).size.width;
    Future<bool> onBackPress() {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return Dashboard();
        },
      ));
      return Future.value(false);
    }

    return WillPopScope(
        onWillPop: () => onBackPress(),
        child: Constants_Usermast.IOS==true ?CupertinoPageScaffold(
            navigationBar: CustomWidgets.appbarIOS(title: "Department", action: [], context: context, onTap: () {
              Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) {
                return Dashboard();
              },));
            },),
            child:  Container(
              height: height,
              width: width,
              child: Column(
                children: [
                  Con_List.Drawer.where((element) => element['subname']=='Department' && element['insert']==true).isNotEmpty ?
                  Container(
                    width: double.infinity,
                    height: height / 3.2,
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
                            hintText: "Department", controller: Deparment),
                        CustomWidgets.textFieldIOS(
                            hintText: "Order",
                            controller: Orderby,
                            keyboardType: TextInputType.number),
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
                                  Deparment.text = "";
                                  Orderby.text = "";
                                  isActive = false;
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
                                  if (Deparment.text.trim().isEmpty) {
                                    CustomWidgets.showToast(
                                        context, "Deparment is required", false);
                                  } else if (Orderby.text.trim().isEmpty) {
                                    CustomWidgets.showToast(
                                        context, "Ord is required", false);
                                  } else if(Update==false){
                                    if (await Deparmentapi.Deparmentinsert(Deparment.text, Orderby.text, isActive)) {
                                      getdata();
                                      Deparment.text = "";
                                      Orderby.text = "";
                                      isActive = false;
                                      CustomWidgets.showToast(context,
                                          "Deparment Add Successfully", true);
                                    }
                                  }else if(Update==true){
                                    if (await Deparmentapi.DeparmentUpdate(UpdateId, Deparment.text,Orderby.text, isActive)) {
                                      getdata();
                                      setState(() {});
                                      Deparment.text = "";
                                      UpdateId="";
                                      Update=false;
                                      Orderby.text = "";
                                      isActive = false;
                                      CustomWidgets.showToast(context, "Deparment Update Successfully", true);
                                    }
                                  }
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
                        child: Con_List.DeparmenntSelect.isNotEmpty
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
                                    label: Text('Ord'),
                                  ),
                                  DataColumn(
                                    label: Text('Active'),
                                  ),
                                  DataColumn(
                                    label: Text('Action'),
                                  ),
                                ],
                                rows: Con_List.DeparmenntSelect.asMap().entries.map((entry) {
                                  int index = entry.key + 1;
                                  final e = entry.value;
                                  return DataRow(cells: [

                                    DataCell(Text(index.toString())),
                                    DataCell(Text(e['name'])),
                                    DataCell(Text(e['ord'].toString())),
                                    DataCell(
                                      Checkbox(
                                        value: e['isActive'],
                                        shape: CircleBorder(),
                                        activeColor: Colorr.themcolor,
                                        onChanged: (value) {},
                                      ),
                                    ),
                                    DataCell(Row(
                                      children: [
                                        Con_List.Drawer.where((element) => element['subname']=='Departments' && element['update']==true).isNotEmpty ?
                                        GestureDetector(
                                            onTap: () {
                                              Deparment.text = e['name'];
                                              Orderby.text=e['ord'].toString();
                                              isActive = e['isActive'];
                                              Update=true;
                                              UpdateId=e['_id'].toString();
                                              setState(() {
                                              });
                                            },
                                            child: Icon(
                                              Icons.edit,
                                              color: Colorr.themcolor,
                                              size: 22,
                                            )) : Container(),
                                        Con_List.Drawer.where((element) => element['subname']=='Departments' && element['delate']==true).isNotEmpty ?
                                        GestureDetector(
                                            onTap: () {
                                              showCupertinoDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return StatefulBuilder(
                                                    builder: (context, setState1) {
                                                      return CupertinoAlertDialog(
                                                        actions: [
                                                          Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment.spaceEvenly,
                                                            children: [
                                                              CupertinoButton(
                                                                onPressed: () {
                                                                  Navigator.pop(context);
                                                                },
                                                                child: Text("Cancel",
                                                                    style: TextStyle(
                                                                        color: Colorr.Reset)),
                                                              ),
                                                              CupertinoButton(
                                                                onPressed: () async {
                                                                  if (await Deparmentapi.DeparmentDelete(
                                                                      e['_id'])) {
                                                                    Con_List.DeparmenntSelect =
                                                                    await Deparmentapi.DeparmentSelect();
                                                                    setState(() {});
                                                                    CustomWidgets.showToast(
                                                                        context,
                                                                        "Deparment Deleted Successfully",
                                                                        true);

                                                                    Navigator.pop(context);
                                                                  } else {
                                                                    Navigator.pop(context);
                                                                  }
                                                                },
                                                                child: Text("Delete"),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                        title: Text(
                                                          "Do you want to delete this Holiday?",
                                                          style: TextStyle(),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                              );
                                            },
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.redAccent,
                                              size: 22,
                                            )) : Container(),
                                      ],
                                    )),
                                  ]);
                                }).toList()),
                          ),
                        )
                            : Container()),
                  ),
                ],
              ),
            )) :Scaffold(
          key: _scaffoldKey,
          appBar: CustomWidgets.appbar(
            title: "Department",
            action: [],
            context: context,
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) {
                  return Dashboard();
                },
              ));
            },
          ),
          body: Container(
            height: height,
            width: width,
            child: Column(
              children: [
                Con_List.Drawer.where((element) => element['subname']=='Departments' && element['insert']==true).isNotEmpty ?
                Container(
                  width: double.infinity,
                  height: height / 3.2,
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
                      CustomWidgets.textField(
                        focus: _textFieldFocusNode,
                          hintText: "Department", controller: Deparment),
                      CustomWidgets.textField(
                          hintText: "Order",
                          controller: Orderby,
                          keyboardType: TextInputType.number),
                      Row(
                        children: [
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
                          Text(
                            "Active",
                            style: TextStyle(
                                fontSize: 13, color: Colorr.themcolor),
                          ),
                        ],
                      ),
                      CustomWidgets.height(5),
                      Row(
                        children: [
                          Spacer(),
                          CustomWidgets.confirmButton(
                              onTap: () {
                                Deparment.text = "";
                                Orderby.text = "";
                                isActive = false;
                                Update=false;
                                FocusScope.of(context).unfocus();
                                FocusScope.of(context).requestFocus(_textFieldFocusNode);
                                setState(() {
                                });
                              },
                              height: height / 20,
                              width: width / 3,
                              text: "Reset",
                              Clr: Colorr.Reset),
                          CustomWidgets.width(5),
                          CustomWidgets.confirmButton(
                              onTap: () async {
                                FocusScope.of(context).unfocus();
                                if(await CustomWidgets.CheakConnectionInternetButton())
                                {
                                  if (Deparment.text.trim().isEmpty) {
                                    CustomWidgets.showToast(
                                        context, "Deparment is required", false);
                                  } else if (Orderby.text.trim().isEmpty) {
                                    CustomWidgets.showToast(
                                        context, "Ord is required", false);
                                  } else if(Update==false){
                                    if (await Deparmentapi.Deparmentinsert(Deparment.text, Orderby.text, isActive)) {
                                      getdata();
                                      Deparment.text = "";
                                      Orderby.text = "";
                                      isActive = false;
                                      CustomWidgets.showToast(context,
                                          "Deparment Add Successfully", true);
                                    }
                                  }else if(Update==true){
                                    if (await Deparmentapi.DeparmentUpdate(UpdateId, Deparment.text,Orderby.text, isActive)) {
                                      getdata();
                                      setState(() {});
                                      Deparment.text = "";
                                      UpdateId="";
                                      Update=false;
                                      Orderby.text = "";
                                      isActive = false;
                                      CustomWidgets.showToast(context, "Deparment Update Successfully", true);
                                    }
                                  }
                                }else{
                                  CustomWidgets.showToast(context, "No Internet Connection", false);
                                }
                              },
                              height: height / 20,
                              width: width / 3,
                              text: Update ? "Update" : "Save"),
                          CustomWidgets.width(5)
                        ],
                      ),
                      CustomWidgets.height(8)
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
      return Con_List.DeparmenntSelect.isNotEmpty ? Container(
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
          child: Con_List.DeparmenntSelect.isNotEmpty
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
                      label: Text("Order"),
                    ),
                    DataColumn(
                      label: Text('Active'),
                    ),
                    DataColumn(
                      label: Text('Action'),
                    ),
                  ],
                  rows: Con_List.DeparmenntSelect.asMap().entries.map((entry) {
                    int index = entry.key + 1;
                    final e = entry.value;
                    return DataRow(cells: [

                      DataCell(Text(index.toString())),
                      DataCell(Text(e['name'])),
                      DataCell(Text(e['ord'].toString())),
                      DataCell(
                        Checkbox(
                          value: e['isActive'],
                          shape: CircleBorder(),
                          activeColor: Colorr.themcolor,
                          onChanged: (value) {},
                        ),
                      ),
                      DataCell(Row(
                        children: [
                          Con_List.Drawer.where((element) => element['subname']=='Departments' && element['update']==true).isNotEmpty ?
                          InkWell(
                              onTap: () {
                                Deparment.text = e['name'];
                                Orderby.text=e['ord'].toString();
                                isActive = e['isActive'];
                                Update=true;
                                UpdateId=e['_id'].toString();
                                setState(() {
                                });
                              },
                              child: Icon(
                                Icons.edit,
                                color: Colorr.themcolor,
                                size: 22,
                              )) :Container(),
                          Con_List.Drawer.where((element) => element['subname']=='Departments' && element['delate']==true).isNotEmpty ?
                          InkWell(
                              onTap: () {
                                if(Con_List.AllEmployee.where((element) => element['departmentId'].toString()==e['_id'].toString()).isNotEmpty)
                                {
                                  CustomWidgets.showToast(context, "Department use in Employee", false);
                                }else if(Con_List.DesignationSelect.where((element) => element['deparmentId'].toString()==e['_id'].toString()).isNotEmpty){
                                  CustomWidgets.showToast(context, "Department use in Designation", false);
                                }else if(Con_List.Policies.where((element) => element['departmentId'].toString()==e['_id'].toString()).isNotEmpty){
                                  CustomWidgets.showToast(context, "Department use in Policies", false);
                                }else{
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext
                                      context) {
                                        return AlertDialog(
                                            title: Center(
                                                child: Text(
                                                  "Do you want to delete this entry ?",
                                                  style: TextStyle(
                                                      color: Colorr
                                                          .themcolor),
                                                )),
                                            content: Row(
                                              children: [
                                                Expanded(
                                                    child: CustomWidgets.confirmButton(
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        height: height / 20,
                                                        width: width / 3,
                                                        text: "Cancel",
                                                        Clr: Colors.redAccent)),
                                                CustomWidgets
                                                    .width(5),
                                                Expanded(
                                                    child: CustomWidgets.confirmButton(
                                                        onTap: () async {
                                                          if(await CustomWidgets.CheakConnectionInternetButton())
                                                          {
                                                            if (await Deparmentapi.DeparmentDelete(
                                                                e['_id'])) {
                                                              Con_List.DeparmenntSelect =
                                                              await Deparmentapi.DeparmentSelect();
                                                              setState(() {});
                                                              CustomWidgets.showToast(
                                                                  context,
                                                                  "Deparment Deleted Successfully",
                                                                  true);
                                                              Navigator.pop(context);
                                                            } else {
                                                              Navigator.pop(context);
                                                            }
                                                          }else{
                                                            Navigator.pop(context);
                                                            CustomWidgets.showToast(context, "No Internet Connection", false);
                                                          }
                                                        },
                                                        height: height / 20,
                                                        width: width / 3,
                                                        text: "Delete")),
                                              ],
                                            ));
                                      });
                                }
                              },
                              child: Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                                size: 22,
                              )) : Container(),
                        ],
                      )),
                    ]);
                  }).toList()),
            ),
          )
              : Container()): CustomWidgets.NoDataImage(context);
    } else if (internetConn == 2) {
      return CustomWidgets.NoInternetImage(context);
    } else {
      return CustomWidgets.Circularprogress(context);
    }
  }
}
