import 'package:attendy/A_SQL_Trigger/Con_Usermast.dart';
import 'package:attendy/A_SQL_Trigger/Holiday_api.dart';
import 'package:attendy/utils/Constant/Colors.dart';
import 'package:attendy/utils/Constant/Con_icon.dart';
import 'package:attendy/utils/Constant/LocalCustomWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../A_SQL_Trigger/Con_List.dart';
import '../Dashboard/Dashboard.dart';
import 'Add_Holiday.dart';

class Holiday_details extends StatefulWidget {
  const Holiday_details({Key? key}) : super(key: key);

  @override
  State<Holiday_details> createState() => _Holiday_detailsState();
}

class _Holiday_detailsState extends State<Holiday_details> {
  late DateTime selectedDate;
  int internetConn = 0;
  TextEditingController HolidayName = TextEditingController();
  TextEditingController HolidayDays = TextEditingController();
  TextEditingController HolidayDate = TextEditingController();

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
    Con_List.HolidaysSelect = await Holiday_api.HolidaySelect();
    setState(() {});
  }
@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Con_List.HolidaysSelect.clear();
  }
  @override
  Widget build(BuildContext context) {
    Future<bool> onBackPress() {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return Dashboard();
        },
      ));
      return Future.value(false);
    }

    return Constants_Usermast.IOS==true
        ? WillPopScope(
        onWillPop: () => onBackPress(),
        child:CupertinoPageScaffold(
            navigationBar: CustomWidgets.appbarIOS(title: "Holiday", action: [
              Con_List.Drawer.where((element) => element['subname']=='Holidays' && element['insert']==true).isNotEmpty ?
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: Icon(Icons.add, color: Colorr.White),
                onPressed: () {
                  Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) {
                    return Add_holiday();
                  },));
                },
              ) : Container()
            ], context: context, onTap: () {
              Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) {
                return Dashboard();
              },));
            },),
            child: Container(
              child: Con_List.HolidaysSelect.isNotEmpty ?
              SingleChildScrollView(
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
                      label: Text('Holiday Name'),
                    ),
                    DataColumn(
                      label: Text('From Date'),
                    ),
                    DataColumn(
                      label: Text('To Date'),
                    ),
                    DataColumn(
                      label: Text('Days'),
                    ),
                  ],
                  rows: Con_List.HolidaysSelect.asMap().entries.map((entry) {
                    int index = entry.key + 1;
                    final e = entry.value;
                    return DataRow(cells: [
                      DataCell(Row(
                        children: [
                          Con_List.Drawer.where((element) => element['subname']=='Holidays' && element['update']==true).isNotEmpty ?
                          GestureDetector(onTap: () {
                            Navigator.push(context, CupertinoPageRoute(builder: (context) {
                              return Add_holiday(e: e,);
                            },));
                          },
                            child: Icon(
                              Icons.edit,
                              color: Colorr.themcolor,
                              size: 22,
                            ),
                          ) : Container(),
                          Con_List.Drawer.where((element) => element['subname']=='Holidays' && element['delate']==true).isNotEmpty ?
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
                                                  if (await Holiday_api.HolidayDelete(e['_id'])) {
                                                    Con_List.HolidaysSelect = await Holiday_api.HolidaySelect();
                                                    setState(() {});
                                                    CustomWidgets.showToast(context, "Holiday Deleted Successfully", true);
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
                      DataCell(Text(e['name']!)),
                      DataCell(Text(CustomWidgets.DateFormatchange(e['fromDate']!))),
                      DataCell(Text(CustomWidgets.DateFormatchange(e['toDate']!))),
                      DataCell(Text(e['day'].toString())),
                    ]);
                  }).toList(),
                ),
              ) :Container(),
            )))
        : WillPopScope(
            onWillPop: () => onBackPress(),
            child: Scaffold(
              backgroundColor: Colorr.themcolor50,
              appBar: CustomWidgets.appbar(
                title: "Holidays",
                action: [
                  Con_List.Drawer.where((element) => element['subname']=='Holidays' && element['insert']==true).isNotEmpty ?
                  IconButton(
                      splashRadius: 18,
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return Add_holiday();
                          },
                        ));
                      },
                      icon: Con_icon.AddNew) : Container()
                ],
                context: context,
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) {
                      return Dashboard();
                    },
                  ));
                },
              ),
              body: mainwidget(),
            ));
  }
  Widget mainwidget() {
    if (internetConn == 1) {
      return Con_List.HolidaysSelect.isNotEmpty ? Container(
          height: double.infinity,
          width: double.infinity,
          color: Colorr.White,
          child: Con_List.HolidaysSelect.isNotEmpty
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
                        label: Text('Holiday Name'),
                      ),
                      DataColumn(
                        label: Text('From Date'),
                      ),
                      DataColumn(
                        label: Text('To Date'),
                      ),
                      DataColumn(
                        label: Text('Days'),
                      ),
                    ],
                    rows: Con_List.HolidaysSelect.asMap().entries.map((entry) {
                      int index = entry.key + 1;
                      final e = entry.value;
                      return DataRow(cells: [
                        DataCell(Row(
                          children: [
                            Con_List.Drawer.where((element) => element['subname']=='Holidays' && element['update']==true).isNotEmpty ?
                            InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                    return Add_holiday(e: e,);
                                  },));
                                },
                                child: Icon(
                                  Icons.edit,
                                  color: Colorr.themcolor,
                                  size: 22,
                                )) : Container(),
                            Con_List.Drawer.where((element) => element['subname']=='Holidays' && element['delate']==true).isNotEmpty ?
                            InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                            title: Center(
                                                child: Text(
                                                  "Do you want to delete this Holiday?",
                                                  style: TextStyle(
                                                      color: Colorr
                                                          .themcolor),
                                                )),
                                            content: Row(
                                              children: [
                                                Expanded(
                                                    child: CustomWidgets.confirmButton(onTap: () {Navigator.pop(context);},
                                                        height: 40,
                                                        width: 170,
                                                        text: "Cancel", Clr: Colors.redAccent)),
                                                CustomWidgets.width(5),
                                                Expanded(
                                                    child: CustomWidgets
                                                        .confirmButton(
                                                        onTap:
                                                            () async {
                                                              if(await CustomWidgets.CheakConnectionInternetButton())
                                                              {
                                                                if (await Holiday_api.HolidayDelete(e['_id'])) {
                                                                  Con_List.HolidaysSelect = await Holiday_api.HolidaySelect();
                                                                  setState(() {});
                                                                  CustomWidgets.showToast(context, "Holiday Deleted Successfully", true);
                                                                  Navigator.pop(context);
                                                                } else {
                                                                  Navigator.pop(context);
                                                                }
                                                              }else{
                                                                Navigator.pop(context);
                                                                CustomWidgets.showToast(context, "No Internet Connection", false);
                                                              }

                                                        },
                                                        height:
                                                        40,
                                                        width:
                                                        170,
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
                        DataCell(Text(e['name']!)),
                        DataCell(Text(CustomWidgets.DateFormatchange(e['fromDate'].toString()))),
                        DataCell(Text(CustomWidgets.DateFormatchange(e['toDate'].toString()))),
                        DataCell(Text(e['day']!.toString())),
                      ]);
                    }).toList()),
              ),
            ),
          )
              : Container()) :  CustomWidgets.NoDataImage(context);
    } else if (internetConn == 2) {
      return CustomWidgets.NoInternetImage(context);
    } else {
      return CustomWidgets.Circularprogress(context);
    }
  }
}
