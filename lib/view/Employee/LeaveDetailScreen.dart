import 'package:attendy/A_SQL_Trigger/Con_Usermast.dart';
import 'package:attendy/A_SQL_Trigger/Leave_Type_api.dart';
import 'package:attendy/A_SQL_Trigger/Leave_api.dart';
import 'package:attendy/utils/Constant/Colors.dart';
import 'package:attendy/utils/Constant/LocalCustomWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../A_SQL_Trigger/Con_List.dart';
import '../../A_SQL_Trigger/Employee_Add_api.dart';
import '../Dashboard/Dashboard.dart';
import 'Add_Leave.dart';

class LeaveDetailScreen extends StatefulWidget {
  const LeaveDetailScreen({Key? key}) : super(key: key);

  @override
  State<LeaveDetailScreen> createState() => _LeaveDetailScreenState();
}

class _LeaveDetailScreenState extends State<LeaveDetailScreen> {
  bool isActive = false;
  int internetConn = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
    CheakInternet();
  }

  CheakInternet() async {
    internetConn = await CustomWidgets.CheakConnectionInternet();
    setState(() {});
  }

  getdata() async {
    Con_List.AllEmployee = await AllEmployee_api.EmployeeSelect();
    Con_List.Leave = await Leave_api.LeaveSelect();

    Con_List.LeaveType = await Leave_Type_api.Leave_TypeSelect();
    setState(() {});
  }

  Widget build(BuildContext context) {
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
        child: Constants_Usermast.IOS == true
            ? CupertinoPageScaffold(
                navigationBar: CustomWidgets.appbarIOS(
                  title: "Leave",
                  action: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Icon(
                        CupertinoIcons.refresh,
                        color: Colorr.White,
                        size: 20,
                      ),
                      onPressed: () {},
                    ),
                    Con_List.Drawer.where((element) =>
                            element['subname'] == 'Leaves' &&
                            element['insert'] == true).isNotEmpty
                        ? CupertinoButton(
                            padding: EdgeInsets.zero,
                            child: Icon(Icons.add, color: Colorr.White),
                            onPressed: () {
                              Navigator.pushReplacement(context,
                                  CupertinoPageRoute(
                                builder: (context) {
                                  return AddLeaveScreen();
                                },
                              ));
                            },
                          )
                        : Container(),
                  ],
                  context: context,
                  onTap: () {
                    Navigator.pushReplacement(context, CupertinoPageRoute(
                      builder: (context) {
                        return Dashboard();
                      },
                    ));
                  },
                ),
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colorr.White,
                  child: Con_List.Leave.isNotEmpty
                      ? SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: DataTable(
                                columns: const [
                                  DataColumn(
                                    label: Text('Action'),
                                  ),
                                  DataColumn(
                                    label: Text('No'),
                                  ),
                                  DataColumn(
                                    label: Text('Name'),
                                  ),
                                  DataColumn(
                                    label: Text('Leave Type'),
                                  ),
                                  DataColumn(
                                    label: Text('From Date'),
                                  ),
                                  DataColumn(
                                    label: Text('To Date'),
                                  ),
                                  DataColumn(
                                    label: Text('No Of Day'),
                                  ),
                                  DataColumn(
                                    label: Text('Reason'),
                                  ),
                                  DataColumn(
                                    label: Text('Status'),
                                  ),
                                ],
                                rows:
                                    Con_List.Leave.asMap().entries.map((entry) {
                                  int index = entry.key + 1;
                                  final e = entry.value;
                                  isActive = e['isActive'] ?? false;
                                  return DataRow(cells: [
                                    DataCell(Row(
                                      children: [
                                        Con_List.Drawer.where((element) =>
                                                    element['subname'] ==
                                                        'Leaves' &&
                                                    element['update'] == true)
                                                .isNotEmpty
                                            ? GestureDetector(
                                                onTap: () {
                                                  Navigator.push(context,
                                                      CupertinoPageRoute(
                                                    builder: (context) {
                                                      return AddLeaveScreen(
                                                        e: e,
                                                      );
                                                    },
                                                  ));
                                                },
                                                child: Icon(
                                                  Icons.edit,
                                                  color: Colorr.themcolor,
                                                  size: 22,
                                                ))
                                            : Container(),
                                        Con_List.Drawer.where((element) =>
                                                    element['subname'] ==
                                                        'Leaves' &&
                                                    element['delate'] == true)
                                                .isNotEmpty
                                            ? GestureDetector(
                                                onTap: () {
                                                  showCupertinoDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return StatefulBuilder(
                                                        builder: (context,
                                                            setState1) {
                                                          return CupertinoAlertDialog(
                                                            actions: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  CupertinoButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: Text(
                                                                        "Cancel",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colorr.Reset)),
                                                                  ),
                                                                  CupertinoButton(
                                                                    onPressed:
                                                                        () async {
                                                                      if (await Leave_api
                                                                          .LeaveDelete(
                                                                              e['_id'])) {
                                                                        getdata();
                                                                        Navigator.pop(
                                                                            context);
                                                                        CustomWidgets.showToast(
                                                                            context,
                                                                            "Leave Deleted Successfully",
                                                                            true);
                                                                      } else {
                                                                        Navigator.pop(
                                                                            context);
                                                                        CustomWidgets.showToast(
                                                                            context,
                                                                            "Leave Not Deleted",
                                                                            false);
                                                                      }
                                                                    },
                                                                    child: Text(
                                                                        "Delete"),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                            title: Text(
                                                              "Do you want to delete this Leave ?",
                                                              style:
                                                                  TextStyle(),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Icon(
                                                  Icons.delete,
                                                  color: Colorr.Reset,
                                                  size: 22,
                                                ))
                                            : Container(),
                                      ],
                                    )),
                                    DataCell(Text(index.toString())),
                                    DataCell(Text(Con_List.AllEmployee.isEmpty
                                        ? ""
                                        : Con_List.AllEmployee.firstWhere(
                                                (element) =>
                                                    element['_id'] ==
                                                    e['EmployeeId'],
                                                orElse: () => {
                                                      'FirstName': ''
                                                    })['FirstName']
                                            .toString())),
                                    DataCell(Text(Con_List.LeaveType.isEmpty
                                        ? ""
                                        : Con_List.LeaveType.firstWhere(
                                                (element) =>
                                                    element['_id'] ==
                                                    e['leaveId'],
                                                orElse: () =>
                                                    {'name': ''})['name']
                                            .toString())),
                                    DataCell(Text(
                                        CustomWidgets.DateFormatchange(
                                            e['fromDate'].toString()))),
                                    DataCell(Text(
                                        CustomWidgets.DateFormatchange(
                                            e['toDate'].toString()))),
                                    DataCell(Text(e['day']!.toString())),
                                    DataCell(Text(e['reason']!)),
                                    DataCell(Text(
                                      e['status']!,
                                      style: TextStyle(
                                          color: e['status'] == "Rejected"
                                              ? Colors.red
                                              : e['status'] == "Approved"
                                                  ? Colors.green
                                                  : Colors.blue),
                                    )),
                                  ]);
                                }).toList()),
                          ),
                        )
                      : Container(),
                ))
            : Scaffold(
                backgroundColor: Colorr.themcolor50,
                appBar: CustomWidgets.appbar(
                  title: "Leave",
                  action: [
                    CustomWidgets.navigateBack(
                      iconSize: 30,
                      onPressed: () async {
                        Con_List.AllEmployee =
                            await AllEmployee_api.EmployeeSelect();
                        Con_List.Leave = await Leave_api.LeaveSelect();
                        Con_List.LeaveType =
                            await Leave_Type_api.Leave_TypeSelect();
                        setState(() {});
                      },
                      icon: const Icon(Icons.refresh),
                    ),
                    Con_List.Drawer.where((element) =>
                            element['subname'] == 'Leaves' &&
                            element['insert'] == true).isNotEmpty
                        ? CustomWidgets.navigateBack(
                            iconSize: 30,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddLeaveScreen()));
                            },
                            icon: const Icon(Icons.add_circle_outline),
                          )
                        : Container(),
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
                body: mainwidget()));
  }

  Widget mainwidget() {
    if (internetConn == 1) {
      return Con_List.Leave.isNotEmpty
          ? Container(
              height: double.infinity,
              width: double.infinity,
              color: Colorr.White,
              child: Con_List.Leave.isNotEmpty
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: DataTable(
                            columns: const [
                              DataColumn(
                                label: Text('Action'),
                              ),
                              DataColumn(
                                label: Text('No.'),
                              ),
                              DataColumn(
                                label: Text('Name'),
                              ),
                              DataColumn(
                                label: Text('Leave Type'),
                              ),
                              DataColumn(
                                label: Text('From Date'),
                              ),
                              DataColumn(
                                label: Text('To Date'),
                              ),
                              DataColumn(
                                label: Text('No Of Day'),
                              ),
                              DataColumn(
                                label: Text('Reason'),
                              ),
                              DataColumn(
                                label: Text('Status'),
                              ),
                            ],
                            rows: Con_List.Leave.asMap().entries.map((entry) {
                              int index = entry.key + 1;
                              final e = entry.value;
                              return DataRow(cells: [
                                DataCell(Row(
                                  children: [
                                    Con_List.Drawer.where((element) =>
                                            element['subname'] == 'Leaves' &&
                                            element['update'] ==
                                                true).isNotEmpty
                                        ? InkWell(
                                            onTap: () {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                builder: (context) {
                                                  return AddLeaveScreen(
                                                    e: e,
                                                  );
                                                },
                                              ));
                                            },
                                            child: Icon(
                                              Icons.edit,
                                              color: Colorr.themcolor,
                                              size: 22,
                                            ))
                                        : Container(),
                                    Con_List.Drawer.where((element) =>
                                            element['subname'] == 'Leaves' &&
                                            element['delate'] ==
                                                true).isNotEmpty
                                        ? InkWell(
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                        title: Center(
                                                            child: Text(
                                                          "Do you want to delete this Leave ?",
                                                          style: TextStyle(
                                                              color: Colorr
                                                                  .themcolor),
                                                        )),
                                                        content: Row(
                                                          children: [
                                                            Expanded(
                                                                child: CustomWidgets
                                                                    .confirmButton(
                                                                        onTap:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        height:
                                                                            40,
                                                                        width:
                                                                            170,
                                                                        text:
                                                                            "Cancel",
                                                                        Clr: Colorr
                                                                            .Reset)),
                                                            CustomWidgets.width(
                                                                5),
                                                            Expanded(
                                                                child: CustomWidgets
                                                                    .confirmButton(
                                                                        onTap:
                                                                            () async {
                                                                          if (await CustomWidgets
                                                                              .CheakConnectionInternetButton()) {
                                                                            if (await Leave_api.LeaveDelete(e['_id'])) {
                                                                              getdata();
                                                                              Navigator.pop(context);
                                                                              CustomWidgets.showToast(context, "Leave Deleted Successfully", true);
                                                                            } else {
                                                                              Navigator.pop(context);
                                                                              CustomWidgets.showToast(context, "Leave Not Deleted", false);
                                                                            }
                                                                          } else {
                                                                            Navigator.pop(context);
                                                                            CustomWidgets.showToast(
                                                                                context,
                                                                                "No Internet Connection",
                                                                                false);
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
                                              color: Colorr.Reset,
                                              size: 22,
                                            ))
                                        : Container(),
                                  ],
                                )),
                                DataCell(Text(index.toString())),
                                DataCell(Text(e['EmployeeId'] == null
                                    ? ""
                                    : e['EmployeeId']['FirstName'])),
                                DataCell(Text(e['leaveId'] == null
                                    ? ""
                                    : e['leaveId']['name'])),
                                DataCell(Text(CustomWidgets.DateFormatchange(
                                    e['fromDate'].toString()))),
                                DataCell(Text(CustomWidgets.DateFormatchange(
                                    e['toDate'].toString()))),
                                DataCell(Text(e['day']!.toString())),
                                DataCell(Text(e['reason']!)),
                                DataCell(Text(e['status']!,
                                    style: TextStyle(
                                        color: e['status'] == "Rejected"
                                            ? Colors.red.shade600
                                            : e['status'] == "Approved"
                                                ? Colors.green.shade600
                                                : Colors.blue.shade600))),
                              ]);
                            }).toList()),
                      ),
                    )
                  : Container(),
            )
          : CustomWidgets.NoDataImage(context);
    } else if (internetConn == 2) {
      return CustomWidgets.NoInternetImage(context);
    } else {
      return CustomWidgets.Circularprogress(context);
    }
  }
}
