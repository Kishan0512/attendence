
import 'dart:developer';

import 'package:attendy/A_SQL_Trigger/Con_List.dart';
import 'package:attendy/A_SQL_Trigger/Overtime_api.dart';
import 'package:attendy/main.dart';
import 'package:attendy/utils/Constant/Con_icon.dart';
import 'package:attendy/utils/Constant/LocalCustomWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../A_SQL_Trigger/Con_Usermast.dart';
import '../../A_SQL_Trigger/Employee_Add_api.dart';
import '../../utils/Constant/Colors.dart';
import '../Dashboard/Dashboard.dart';
import 'AddOvertime.dart';

class Overtime extends StatefulWidget {
  const Overtime({Key? key}) : super(key: key);

  @override
  State<Overtime> createState() => _OvertimeState();
}

class _OvertimeState extends State<Overtime> {
  double Height =0;
  double Width =0;
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
    Con_List.AllOvertime = await Overtime_api.Overtime_Select();
    Con_List.AllEmployee=await AllEmployee_api.EmployeeSelect();
    if (mounted) {
    setState(() {
    });}
  }
  Widget build(BuildContext context) {
     Height = MediaQuery.of(context).size.height-kToolbarHeight;
     Width = MediaQuery.of(context).size.width;
    Future<bool> onBackPress() {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return Dashboard();
      },));
      return Future.value(false);
    }
    return WillPopScope(
        onWillPop: () => onBackPress(),
    child:  Constants_Usermast.IOS==true ? CupertinoPageScaffold(
        navigationBar: CustomWidgets.appbarIOS(title: "Overtime", action: [
          Con_List.Drawer.where((element) => element['subname']=='Overtime' && element['insert']==true).isNotEmpty ?
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: Icon(Icons.add, color: Colorr.White),
            onPressed: () {
              Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) {
                return AddOvertime();
              },));
            },
          ) : Container()
        ], context: context, onTap: () {
          Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) {
            return Dashboard();
          },));
        },),
        child:Container(
            height: double.infinity,
            width: double.infinity,
            color: Colorr.White,
            child: Con_List.AllOvertime.isNotEmpty
                ? SingleChildScrollView(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                      columns: [
                        DataColumn(
                          label: Text('Action'),
                        ),
                        DataColumn(
                          label: Text('No'),
                        ),
                        DataColumn(
                          label: Text('Employee Name'),
                        ),
                        DataColumn(
                          label: Text('Overtime Date'),
                        ),
                        DataColumn(
                          label: Text('Overtime Time'),
                        ),
                        DataColumn(
                          label: Text('Description'),
                        ),
                      ],
                      rows: Con_List.AllOvertime.asMap().entries.map((entry) {
                        int index = entry.key + 1;
                        final e = entry.value;
                        return DataRow(cells: [
                          DataCell(Row(
                            children: [
                              Con_List.Drawer.where((element) => element['subname']=='Overtime' && element['update']==true).isNotEmpty ?
                              GestureDetector(
                                onTap: () {
                                    Navigator.push(context, CupertinoPageRoute(builder: (context) {
                                      return AddOvertime(e : e);
                                    },));
                                },
                                child: Icon(
                                  Icons.edit,
                                  color: Colorr.themcolor,
                                  size: 22,
                                ),
                              ) : Container(),
                              Con_List.Drawer.where((element) => element['subname']=='Overtime' && element['delate']==true).isNotEmpty ?
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
                                                      if (await Overtime_api.Overtime_Delete(e['_id'])) {
                                                        getdata();
                                                        setState(() {});
                                                        CustomWidgets.showToast(context, "Overtime Deleted Successfully", true);
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
                                  color: CupertinoColors.destructiveRed,
                                  size: 22,
                                ),
                              ) : Container(),
                            ],
                          )),
                          DataCell(Text(index.toString())),
                          DataCell(Text(
                              Con_List.AllEmployee.isEmpty ? "" : Con_List.AllEmployee.firstWhere(
                                  (element) => element['_id'] == e['employeeId'],
                              orElse: () => {'FirstName': ''}
                          )['FirstName'].toString()
                          )),
                          DataCell(Text(CustomWidgets.DateFormatchange(e['overTimeDate']!.toString()))),
                          DataCell(Text(e['overTimeHours']!)),
                          DataCell(Text(e['description']!)),
                        ]);
                      }).toList()),
                ),
              ),
            )
                : Container())) :Scaffold(
      appBar: CustomWidgets.appbar(title: "Overtime",action:  [
        Con_List.Drawer.where((element) => element['subname']=='Overtime' && element['insert']==true).isNotEmpty ?
        IconButton(splashRadius: 18,onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder:  (context) {
            return AddOvertime();
          },));
        }, icon: Con_icon.AddNew) : Container(
        )
      ],context:  context,onTap: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return Dashboard();
        },));
      },),
      body: mainwidget(),
    ));
  }
  Widget mainwidget() {
    if (internetConn == 1) {
      return Con_List.AllOvertime.isNotEmpty ? Container(
          height: double.infinity,
          width: double.infinity,
          color: Colorr.White,
          child: Con_List.AllOvertime.isNotEmpty
              ? SingleChildScrollView(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                    columns: [
                      DataColumn(
                        label: Text('Action'),
                      ),DataColumn(
                        label: Text('No'),
                      ),
                      DataColumn(
                        label: Text('Employee Name'),
                      ),
                      DataColumn(
                        label: Text('Overtime Date'),
                      ),
                      DataColumn(
                        label: Text('From Time'),
                      ),
                      DataColumn(
                        label: Text('To Time'),
                      ),
                      DataColumn(
                        label: Text('Overtime Time'),
                      ),
                      DataColumn(
                        label: Text('Description'),
                      ),
                    ],
                    rows: Con_List.AllOvertime.asMap().entries.map((entry) {
                      var In;
                      var Out;
                      int index = entry.key + 1;
                      final e = entry.value;
                      if(e['fromTime'].toString().contains("am") || e['fromTime'].toString().contains("pm")) {
                      In=e['fromTime'].toString();
                      Out=e['toTime'].toString();
                      }else{
                        DateTime inTime=DateTime.parse(e['fromTime']).toLocal();
                        In=DateFormat("hh:mm a").format(inTime) ;
                        DateTime outTime=DateTime.parse(e['toTime']).toLocal();
                        Out=DateFormat("hh:mm a").format(outTime);
                      }
                      return DataRow(cells: [
                        DataCell(Row(
                          children: [
                            Con_List.Drawer.where((element) => element['subname']=='Overtime' && element['update']==true).isNotEmpty ?
                            InkWell(
                                onTap: () {
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                                    return  AddOvertime(e: e);
                                  },));
                                },
                                child: Icon(
                                  Icons.edit,
                                  color: Colorr.themcolor,
                                  size: 22,
                                )) : Container(),
                            Con_List.Drawer.where((element) => element['subname']=='Overtime' && element['delate']==true).isNotEmpty ?
                            InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                            title: Center(
                                                child: Text(
                                                  "Do you want to delete this entry ?",
                                                  style: TextStyle(
                                                      color:
                                                      Colorr.themcolor),
                                                )),
                                            content: Row(
                                              children: [
                                                Expanded(
                                                    child: CustomWidgets
                                                        .confirmButton(
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        height:
                                                        Height/
                                                            20,
                                                        width:
                                                        Width /
                                                            3.3,
                                                        text:
                                                        "Cancel",
                                                        Clr: Colors
                                                            .redAccent)),
                                                CustomWidgets.width(5),
                                                Expanded(
                                                    child: CustomWidgets
                                                        .confirmButton(
                                                        onTap:
                                                            () async {
                                                          if (await CustomWidgets
                                                              .CheakConnectionInternetButton()) {
                                                            if (await Overtime_api.Overtime_Delete(e['_id'])) {
                                                              getdata();
                                                              setState(() {});
                                                              CustomWidgets.showToast(context, "Overtime Deleted Successfully", true);
                                                              Navigator.pop(
                                                                  context);
                                                            } else {
                                                              Navigator.pop(
                                                                  context);
                                                            }
                                                          } else {
                                                            CustomWidgets.showToast(
                                                                context,
                                                                "No Internet Connection",
                                                                false);
                                                          }
                                                        },
                                                        height:
                                                        Height /
                                                            20,
                                                        width:
                                                        Width /
                                                            3.3,
                                                        text:
                                                        "Delete")),
                                              ],
                                            ));
                                      });
                                },
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.redAccent,
                                  size: 22,
                                )) : Container(),
                          ],
                        )),
                        DataCell(Text(index.toString())),
                        DataCell(Text(Con_List.AllEmployee.isEmpty
                            ? ""
                            : Con_List.AllEmployee.firstWhere(
                                (element) => element['_id'].toString() == e['employeeId'].toString(), orElse: () => {'FirstName': ''})['FirstName'].toString()
                        )),
                        DataCell(Text(CustomWidgets.DateFormatchange(e['overTimeDate']!.toString()))),
                        DataCell(Text(In)),
                        DataCell(Text(Out)),
                        DataCell(Text(e['overTimeHours']!)),
                        DataCell(Text(e['description']!)),
                      ]);
                    }).toList()),
              ),
            ),
          )
              : Container()) : CustomWidgets.NoDataImage(context);
    } else if (internetConn == 2) {
      return CustomWidgets.NoInternetImage(context);
    } else {
      return CustomWidgets.Circularprogress(context);
    }
  }
}
