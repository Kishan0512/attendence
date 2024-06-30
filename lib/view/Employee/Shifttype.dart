import 'package:attendy/A_SQL_Trigger/Con_List.dart';
import 'package:attendy/A_SQL_Trigger/Shift_typee_add_api.dart';
import 'package:attendy/utils/Constant/Con_icon.dart';
import 'package:attendy/utils/Constant/LocalCustomWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../A_SQL_Trigger/Con_Usermast.dart';
import '../../A_SQL_Trigger/Shift_Add_api.dart';
import '../../utils/Constant/Colors.dart';
import '../Dashboard/Dashboard.dart';
import 'Add_Shift_Typee.dart';

class Shift_type extends StatefulWidget {
  const  Shift_type({Key? key}) : super(key: key);

  @override
  State<Shift_type> createState() => _Shift_typeState();
}

class _Shift_typeState extends State<Shift_type> {
  TextEditingController Name=TextEditingController();
  TextEditingController Order=TextEditingController();
  bool isActive=false;
  double height=0;
  double width=0;
  int internetConn=0;

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
  getdata()
  async {
    Con_List.shift_typeetSelect=await Shift_typee_api.shift_typeeSelect();
    Con_List.Allshift_Select = await Shift_Add_api.shift_Select();
    setState(() {
    });
  }
  Widget build(BuildContext context) {
    height=MediaQuery.of(context).size.height-kToolbarHeight;
    width=MediaQuery.of(context).size.width;
    Future<bool> onBackPress() {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return Dashboard();
      },));
      return Future.value(false);
    }
    return WillPopScope(
        onWillPop: () => onBackPress(),
    child: Constants_Usermast.IOS==true ? CupertinoPageScaffold(
        navigationBar: CustomWidgets.appbarIOS(title: "Shift Type", action: [
          Con_List.Drawer.where((element) => element['subname']=='Shift Type' && element['insert']==true).isNotEmpty ?
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: Icon(Icons.add, color: Colorr.White),
            onPressed: () {
              Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) {
                return Add_Shift_Typee();
              },));
            },
          ) : Container()
        ], context: context, onTap: () {
          Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) {
            return Dashboard();
          },));
        },),
        child: Container(
            width: double.infinity,
            child: Con_List.shift_typeetSelect.isNotEmpty
                ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                  columns: [
                    DataColumn(
                      label: Text('No'),
                    ),
                    DataColumn(
                      label: Text('Name'),
                    ),  DataColumn(
                      label: Text("Order"),
                    ),
                    DataColumn(
                      label: Text('Active'),
                    ),
                    DataColumn(
                      label: Text('Action'),
                    ),
                  ],
                  rows: Con_List.shift_typeetSelect.asMap().entries.map((entry) {
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
                          Con_List.Drawer.where((element) => element['subname']=='Shift Type' && element['update']==true).isNotEmpty ?
                          GestureDetector(
                              onTap: () {
                                Name.text=e['name'];
                                isActive=e['isActive'];
                                Order.text=e['ord'].toString();
                                showCupertinoDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return StatefulBuilder(builder: (context, setState1) {
                                      return CupertinoAlertDialog(
                                        title: Center(
                                          child: Text(
                                            "Update Shift Type",
                                            style: TextStyle(
                                              color: Colorr.themcolor,
                                              fontSize: 17,
                                            ),
                                          ),
                                        ),
                                        content: Container(
                                          height: height / 3,
                                          child: Column(
                                            children: [
                                              CustomWidgets.height(10),
                                              CustomWidgets.textFieldIOS(
                                                hintText: "Name",
                                                controller: Name,
                                              ),
                                              CustomWidgets.textFieldIOS(
                                                hintText: "Order",
                                                controller: Order,
                                              ),
                                              Row(
                                                children: [
                                                  CupertinoSwitch(
                                                    value: isActive,
                                                    activeColor: Colorr.themcolor,
                                                    onChanged: (value) {
                                                      setState1(() {
                                                        isActive = value;
                                                      });
                                                    },
                                                  ),
                                                  Text(
                                                    "Active",
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colorr.themcolor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Spacer(),
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
                                                  CustomWidgets.width(5),
                                                  CupertinoButton(
                                                    onPressed: () async {
                                                      FocusScope.of(context).unfocus();
                                                      if (await CustomWidgets.CheakConnectionInternetButton()) {
                                                      if (await Shift_typee_api.shift_typeeUpdate(
                                                      e['_id'], Name.text, Order.text, isActive)) {
                                                      getdata();
                                                      Navigator.pop(context);
                                                      CustomWidgets.showToast(
                                                      context, "Shift Type Update Successfully", true);
                                                      } else {
                                                      Navigator.pop(context);
                                                      }
                                                      } else {
                                                      Navigator.pop(context);
                                                      CustomWidgets.showToast(
                                                      context, "No Internet Connection", false);
                                                      }
                                                    },
                                                    child: Text("Update",
                                                        style: TextStyle(
                                                            color: Colorr.Reset)),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                                  },
                                );

                              },
                              child: Icon(
                                Icons.edit,
                                color: Colorr.themcolor,
                                size: 22,
                              )) : Container(),
                          Con_List.Drawer.where((element) => element['subname']=='Shift Type' && element['delate']==true).isNotEmpty ?
                          GestureDetector(
                              onTap: () {
                                if(Con_List.Allshift_Select.where((element) => element['shiftId'].toString()==e['_id'].toString()).isNotEmpty)
                                {
                                  CustomWidgets.showToast(context, "Shift type already used in Shift Master", false);
                                }else if(Con_List.AllEmployee.where((element) => element['ShiftId'].toString()==e['_id'].toString()).isNotEmpty){
                                  CustomWidgets.showToast(context, "Shift type already used in Employee", false);
                                }
                                else{
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
                                                      FocusScope.of(context).unfocus();
                                                      if(await CustomWidgets.CheakConnectionInternetButton())
                                                      {
                                                        if(await Shift_typee_api.shift_typeeDelete(e['_id'])){
                                                          getdata();
                                                          CustomWidgets.showToast(context, "Shift Type Deleted Successfully",true);
                                                          Navigator.pop(context);
                                                        }else{
                                                          Navigator.pop(context);
                                                        }
                                                      }else{
                                                        CustomWidgets.showToast(context, "No Internet Connection", false);
                                                      }
                                                    },
                                                    child: Text("Delete"),
                                                  ),
                                                ],
                                              ),
                                            ],
                                            title: Text(
                                              "Do you want to delete this Shift?",
                                              style: TextStyle(),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  );
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                            title: Center(child: Text("Do you want to delete this entry ?",style: TextStyle(color: Colorr.themcolor),)),
                                            content:Row(
                                              children: [
                                                Expanded(child:CustomWidgets.confirmButton(onTap: () {
                                                  Navigator.pop(context);
                                                },height:  height/20,width:  width/3,text:  "Cancel",Clr: Colors.redAccent)),
                                                CustomWidgets.width(5),
                                                Expanded(child:  CustomWidgets.confirmButton(onTap: () async {
                                                  FocusScope.of(context).unfocus();
                                                  if(await CustomWidgets.CheakConnectionInternetButton())
                                                  {
                                                    if(await Shift_typee_api.shift_typeeDelete(e['_id'])){
                                                      getdata();
                                                      CustomWidgets.showToast(context, "Shift Type Deleted Successfully",true);
                                                      Navigator.pop(context);
                                                    }else{
                                                      Navigator.pop(context);
                                                    }
                                                  }else{
                                                    CustomWidgets.showToast(context, "No Internet Connection", false);
                                                  }


                                                },height: height/20,width: width/3,text:  "Delete")),
                                              ],)
                                        );
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
            )
                : Container())  ) : Scaffold(
        appBar: CustomWidgets.appbar(title: "Shift Type",action:  [
          IconButton(splashRadius: 18,onPressed: () {
            getdata();
          }, icon: Con_icon.Refresh),
          Con_List.Drawer.where((element) => element['subname']=='Shift Type' && element['insert']==true).isNotEmpty ?
          IconButton(splashRadius: 18,onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Add_Shift_Typee();
            },));
          }, icon: Con_icon.AddNew) : Container()
        ],context:  context,onTap: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
            return Dashboard();
          },));
        },),
      body: mainwidget()
    ));
  }
  Widget mainwidget() {
    if (internetConn == 1) {
      return Con_List.shift_typeetSelect.isNotEmpty ?  Container(
          width: double.infinity,
          child: Con_List.shift_typeetSelect.isNotEmpty
              ? SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
                columns: [
                  DataColumn(
                    label: Text('No'),
                  ),
                  DataColumn(
                    label: Text('Name'),
                  ),  DataColumn(
                    label: Text("Order"),
                  ),
                  DataColumn(
                    label: Text('Active'),
                  ),
                  DataColumn(
                    label: Text('Action'),
                  ),
                ],
                rows: Con_List.shift_typeetSelect.asMap().entries.map((entry) {
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
                        Con_List.Drawer.where((element) => element['subname']=='Shift Type' && element['update']==true).isNotEmpty ?
                        InkWell(
                            onTap: () {
                              Name.text=e['name'];
                              isActive=e['isActive'];
                              Order.text=e['ord'].toString();
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return StatefulBuilder(builder: (context, setState1) {
                                      return AlertDialog(
                                          title: Center(child: Text("Update Shift Type",style: TextStyle(color: Colorr.themcolor,fontSize: 17),)),
                                          content:Container(
                                            height: height/3,
                                            child: Column(
                                              children: [
                                                CustomWidgets.height(10),
                                                CustomWidgets.textField(
                                                    hintText: "Name", controller: Name),
                                                CustomWidgets.textField(
                                                    hintText: "Order", controller: Order),
                                                Row(
                                                  children: [
                                                    Checkbox(
                                                      shape: CircleBorder(),
                                                      value: isActive,
                                                      activeColor: Colorr.themcolor,
                                                      onChanged: (value) {
                                                        isActive=value!;
                                                        setState1(() {

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
                                                Row(
                                                  children: [
                                                    Expanded(child:CustomWidgets.confirmButton(onTap: () {
                                                      Navigator.pop(context);
                                                    },height: height/20,width:  width/3,text:  "Cancel",Clr: Colors.redAccent)),
                                                    CustomWidgets.width(5),
                                                    Expanded(child:  CustomWidgets.confirmButton(onTap: () async {
                                                      FocusScope.of(context).unfocus();
                                                      if(await CustomWidgets.CheakConnectionInternetButton())
                                                      {
                                                        if(await Shift_typee_api.shift_typeeUpdate(e['_id'],Name.text,Order.text, isActive)){
                                                          getdata();
                                                          Navigator.pop(context);
                                                          CustomWidgets.showToast(context, "Shift Type Update Successfully",true);
                                                        }else{
                                                         Navigator.pop(context);
                                                        }
                                                      }else{
                                                        Navigator.pop(context);
                                                        CustomWidgets.showToast(context, "No Internet Connection", false);
                                                      }
                                                    },height: height/20,width:  width/3,text:  "Update")),
                                                  ],),
                                              ],
                                            ),
                                          )
                                      );
                                    },);
                                  });
                            },
                            child: Icon(
                              Icons.edit,
                              color: Colorr.themcolor,
                              size: 22,
                            )) : Container(),
                        Con_List.Drawer.where((element) => element['subname']=='Shift Type' && element['delate']==true).isNotEmpty ?
                        InkWell(
                            onTap: () {
                              if(Con_List.Allshift_Select.where((element) => element['shiftId'].toString()==e['_id'].toString()).isNotEmpty)
                              {
                                CustomWidgets.showToast(context, "Shift type already used in Shift Master", false);
                              }else if(Con_List.AllEmployee.where((element) => element['ShiftId'].toString()==e['_id'].toString()).isNotEmpty){
                                CustomWidgets.showToast(context, "Shift type already used in Employee", false);
                              }
                              else{
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                          title: Center(child: Text("Do you want to delete this entry ?",style: TextStyle(color: Colorr.themcolor),)),
                                          content:Row(
                                            children: [
                                              Expanded(child:CustomWidgets.confirmButton(onTap: () {
                                                Navigator.pop(context);
                                              },height:  height/20,width:  width/3,text:  "Cancel",Clr: Colors.redAccent)),
                                              CustomWidgets.width(5),
                                              Expanded(child:  CustomWidgets.confirmButton(onTap: () async {
                                                FocusScope.of(context).unfocus();
                                                if(await CustomWidgets.CheakConnectionInternetButton())
                                                {
                                                  if(await Shift_typee_api.shift_typeeDelete(e['_id'])){
                                                    getdata();
                                                    CustomWidgets.showToast(context, "Shift Type Deleted Successfully",true);
                                                    Navigator.pop(context);
                                                  }else{
                                                    Navigator.pop(context);
                                                  }
                                                }else{
                                                  CustomWidgets.showToast(context, "No Internet Connection", false);
                                                }


                                              },height: height/20,width: width/3,text:  "Delete")),
                                            ],)
                                      );
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
          )
              : Container()) : CustomWidgets.NoDataImage(context);
    } else if (internetConn == 2) {
      return CustomWidgets.NoInternetImage(context);
    } else {
      return CustomWidgets.Circularprogress(context);
    }
  }
}
