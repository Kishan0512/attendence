import 'dart:developer';

import 'package:attendy/A_SQL_Trigger/Con_Usermast.dart';
import 'package:attendy/A_SQL_Trigger/Employee_Add_api.dart';
import 'package:attendy/utils/Constant/LocalCustomWidgets.dart';
import 'package:attendy/view/Dashboard/Dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../A_SQL_Trigger/Branchapi.dart';
import '../../A_SQL_Trigger/Con_List.dart';
import '../../A_SQL_Trigger/Deparment_api_page.dart';
import '../../A_SQL_Trigger/Role_api.dart';
import '../../A_SQL_Trigger/Ticket_api.dart';
import '../../utils/Constant/Colors.dart';
import 'AddEmployee.dart';

class AllEmployees extends StatefulWidget {
  const AllEmployees({Key? key}) : super(key: key);

  @override
  State<AllEmployees> createState() => _AllEmployeesState();
}

class _AllEmployeesState extends State<AllEmployees> {
  List AllEmployee = [];
  int internetConn = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CheakInternet();
    getdata();
  }

  CheakInternet() async {
    internetConn = await CustomWidgets.CheakConnectionInternet();
    setState(() {});
  }

  getdata() async {
    Con_List.AllEmployee = await AllEmployee_api.EmployeeSelect();
    log(Con_List.AllEmployee.toString());
    Con_List.TiccketSelect = await Ticket_api.TicketSelect();
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
                  title: "All Employees",
                  action: [
                    Con_List.Drawer.where((element) =>
                            element['subname'] == 'All Employee' &&
                            element['insert'] == true).isNotEmpty
                        ? CupertinoButton(
                            padding: EdgeInsets.zero,
                            child: Icon(Icons.add, color: Colorr.White),
                            onPressed: () {
                              Navigator.pushReplacement(context,
                                  CupertinoPageRoute(
                                builder: (context) {
                                  return AddEmployee();
                                },
                              ));
                            },
                          )
                        : Container()
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
                    child: Container(
                        height:
                            MediaQuery.of(context).size.height - kToolbarHeight,
                        width: MediaQuery.of(context).size.width,
                        child: Con_List.AllEmployee.isNotEmpty
                            ? SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                    columns:const [
                                      DataColumn(
                                        label: Text('Action'),
                                      ),
                                      DataColumn(
                                        label: Text('Employee Code'),
                                      ),
                                      DataColumn(
                                        label: Text('First Name'),
                                      ),
                                      DataColumn(
                                        label: Text('Middle Name'),
                                      ),
                                      DataColumn(
                                        label: Text('Last Name'),
                                      ),
                                      DataColumn(
                                        label: Text('Branch'),
                                      ),
                                      DataColumn(
                                        label: Text('Department Name'),
                                      ),
                                      DataColumn(
                                        label: Text('Designation Name'),
                                      ),
                                      DataColumn(
                                        label: Text('Role'),
                                      ),
                                      DataColumn(
                                        label: Text('Gender'),
                                      ),
                                      DataColumn(
                                        label: Text('Shift'),
                                      ),
                                      DataColumn(
                                        label: Text('Email'),
                                      ),
                                      DataColumn(
                                        label: Text('Phone No.'),
                                      ),
                                      DataColumn(
                                        label: Text('Joining Date'),
                                      ),
                                      DataColumn(
                                        label: Text('Date of Birth'),
                                      ),
                                      DataColumn(
                                        label: Text('Closed Date'),
                                      ),
                                      DataColumn(
                                        label: Text('Address'),
                                      ),
                                      DataColumn(
                                        label: Text('Bank Name'),
                                      ),
                                      DataColumn(
                                        label: Text('Branch Name'),
                                      ),
                                      DataColumn(
                                        label: Text('Bank Account No'),
                                      ),
                                      DataColumn(
                                        label: Text('IFSC Code'),
                                      ),
                                      DataColumn(
                                        label: Text('Pan No'),
                                      ),
                                      DataColumn(
                                        label: Text('Family Name'),
                                      ),
                                      DataColumn(
                                        label: Text('Relationship'),
                                      ),
                                      DataColumn(
                                        label: Text('Family Phone'),
                                      ),
                                      DataColumn(
                                        label: Text('Active'),
                                      ),
                                    ],
                                    rows: Con_List.AllEmployee.map((e) {
                                      return DataRow(cells: [
                                        DataCell(Row(
                                          children: [
                                            Con_List.Drawer.where((element) =>
                                            element['subname'] ==
                                                'All Employees' &&
                                                element['update'] == true)
                                                .isNotEmpty
                                                ? InkWell(
                                                onTap: () {
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                        builder: (context) {
                                                          return AddEmployee(
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
                                                'All Employees' &&
                                                element['delate'] == true)
                                                .isNotEmpty
                                                ? InkWell(
                                                onTap: () {
                                                  if (Con_List.TiccketSelect
                                                      .where((element) =>
                                                  element[
                                                  'employeeId'] ==
                                                      e['_id']).isEmpty) {
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
                                                                            Navigator.pop(context);
                                                                          },
                                                                          height: 40,
                                                                          width: 170,
                                                                          text: "Cancel",
                                                                          Clr: Colors.redAccent)),
                                                                  CustomWidgets
                                                                      .width(5),
                                                                  Expanded(
                                                                      child: CustomWidgets.confirmButton(
                                                                          onTap: () async {
                                                                            if (await CustomWidgets.CheakConnectionInternetButton()) {
                                                                              if (await AllEmployee_api.EmployeeDelete(e['_id'].toString())) {
                                                                                getdata();
                                                                                setState(() {});
                                                                                CustomWidgets.showToast(context, "Employee Deleted Successfully", true);
                                                                                Navigator.pop(context);
                                                                              } else {
                                                                                Navigator.pop(context);
                                                                              }
                                                                            } else {
                                                                              Navigator.pop(context);
                                                                              CustomWidgets.showToast(context, "No Internet Connection", false);
                                                                            }
                                                                          },
                                                                          height: 40,
                                                                          width: 170,
                                                                          text: "Delete")),
                                                                ],
                                                              ));
                                                        });
                                                  } else {
                                                    CustomWidgets.showToast(
                                                        context,
                                                        "Employee already used in Ticket",
                                                        false);
                                                  }
                                                },
                                                child: Icon(
                                                  Icons.delete,
                                                  color: Colors.redAccent,
                                                  size: 22,
                                                ))
                                                : Container(),
                                          ],
                                        )),
                                        DataCell(Text(e['EmpCode'])),
                                        DataCell(Text(e['FirstName'] ?? '')),
                                        DataCell(Text(e['MiddelName'])),
                                        DataCell(Text(e['LastName'])),
                                        DataCell(Text(e['branchId']['name'])),
                                        DataCell(Text(e['departmentId']['name'])),
                                        DataCell(Text(e['designationId']['name'])),
                                        DataCell(Text(e['roleId']['name'])),
                                        DataCell(Text(e['Gender'])),
                                        DataCell(Text(e['ShiftId']['name'])),
                                        DataCell(Text(e['Email'])),
                                        DataCell(Text(e['Number'].toString())),
                                        DataCell(Text(
                                            CustomWidgets.DateFormatchange(
                                                e['JoiningDate'].toString()))),
                                        DataCell(Text(
                                            CustomWidgets.DateFormatchange(
                                                e['Dob'].toString()))),
                                        DataCell(Text(e['ClosedDate'] != null
                                            ? CustomWidgets.DateFormatchange(
                                            e['ClosedDate'].toString())
                                            : "")),
                                        DataCell(Text(e['Address'])),
                                        DataCell(Text(e['BankName'].toString())),
                                        DataCell(Text(e['BankBranch'].toString())),
                                        DataCell(
                                            Text(e['BankAccountNo'].toString())),
                                        DataCell(Text(e['IFSCcode'].toString())),
                                        DataCell(Text(e['PANno'].toString())),
                                        DataCell(Text(e['FamilyName'])),
                                        DataCell(Text(e['Relationship'])),
                                        DataCell(Text(e['FamilyPhone'].toString())),
                                        DataCell(
                                          Checkbox(
                                            value: e['isActive'],
                                            shape: CircleBorder(),
                                            activeColor: Colorr.themcolor,
                                            onChanged: (value) {},
                                          ),
                                        ),
                                      ]);
                                    }).toList()),
                              )
                            : Container())))
            : Scaffold(
                appBar: CustomWidgets.appbar(
                  title: "All Employee",
                  action: [
                    Con_List.Drawer.where((element) =>
                            element['subname'] == 'All Employees' &&
                            element['insert'] == true).isNotEmpty
                        ? IconButton(
                            splashRadius: 18,
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return AddEmployee(count: Con_List.AllEmployee.length,);
                                },
                              ));
                            },
                            icon: Icon(Icons.add_circle_outline))
                        : Container()
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
      return Con_List.AllEmployee.isNotEmpty
          ? Container(
              height: double.infinity,
              width: double.infinity,
              color: Colorr.White,
              child: Container(
                  height: MediaQuery.of(context).size.height - kToolbarHeight,
                  width: MediaQuery.of(context).size.width,
                  child: Con_List.AllEmployee.isNotEmpty
                      ? SingleChildScrollView(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                                columns:const [
                                  DataColumn(
                                    label: Text('Action'),
                                  ),
                                  DataColumn(
                                    label: Text('Employee Code'),
                                  ),
                                  DataColumn(
                                    label: Text('First Name'),
                                  ),
                                  DataColumn(
                                    label: Text('Middle Name'),
                                  ),
                                  DataColumn(
                                    label: Text('Last Name'),
                                  ),
                                  DataColumn(
                                    label: Text('Branch'),
                                  ),
                                  DataColumn(
                                    label: Text('Department Name'),
                                  ),
                                  DataColumn(
                                    label: Text('Designation Name'),
                                  ),
                                  DataColumn(
                                    label: Text('Role'),
                                  ),
                                  DataColumn(
                                    label: Text('Gender'),
                                  ),
                                  DataColumn(
                                    label: Text('Shift'),
                                  ),
                                  DataColumn(
                                    label: Text('Email'),
                                  ),
                                  DataColumn(
                                    label: Text('Phone No.'),
                                  ),
                                  DataColumn(
                                    label: Text('Joining Date'),
                                  ),
                                  DataColumn(
                                    label: Text('Date of Birth'),
                                  ),
                                  DataColumn(
                                    label: Text('Closed Date'),
                                  ),
                                  DataColumn(
                                    label: Text('Address'),
                                  ),
                                  DataColumn(
                                    label: Text('Bank Name'),
                                  ),
                                  DataColumn(
                                    label: Text('Branch Name'),
                                  ),
                                  DataColumn(
                                    label: Text('Bank Account No'),
                                  ),
                                  DataColumn(
                                    label: Text('IFSC Code'),
                                  ),
                                  DataColumn(
                                    label: Text('Pan No'),
                                  ),
                                  DataColumn(
                                    label: Text('Family Name'),
                                  ),
                                  DataColumn(
                                    label: Text('Relationship'),
                                  ),
                                  DataColumn(
                                    label: Text('Family Phone'),
                                  ),
                                  DataColumn(
                                    label: Text('Active'),
                                  ),
                                ],
                                rows: Con_List.AllEmployee.map((e) {
                                  return DataRow(cells: [
                                    DataCell(Row(
                                      children: [
                                        Con_List.Drawer.where((element) =>
                                                    element['subname'] ==
                                                        'All Employees' &&
                                                    element['update'] == true)
                                                .isNotEmpty
                                            ? InkWell(
                                                onTap: () {
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                    builder: (context) {
                                                      return AddEmployee(
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
                                                        'All Employees' &&
                                                    element['delate'] == true)
                                                .isNotEmpty
                                            ? InkWell(
                                                onTap: () {
                                                  if (Con_List.TiccketSelect
                                                      .where((element) =>
                                                          element[
                                                              'employeeId'] ==
                                                          e['_id']).isEmpty) {
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
                                                                            Navigator.pop(context);
                                                                          },
                                                                          height: 40,
                                                                          width: 170,
                                                                          text: "Cancel",
                                                                          Clr: Colors.redAccent)),
                                                                  CustomWidgets
                                                                      .width(5),
                                                                  Expanded(
                                                                      child: CustomWidgets.confirmButton(
                                                                          onTap: () async {
                                                                            if (await CustomWidgets.CheakConnectionInternetButton()) {
                                                                              if (await AllEmployee_api.EmployeeDelete(e['_id'].toString())) {
                                                                                getdata();
                                                                                setState(() {});
                                                                                CustomWidgets.showToast(context, "Employee Deleted Successfully", true);
                                                                                Navigator.pop(context);
                                                                              } else {
                                                                                Navigator.pop(context);
                                                                              }
                                                                            } else {
                                                                              Navigator.pop(context);
                                                                              CustomWidgets.showToast(context, "No Internet Connection", false);
                                                                            }
                                                                          },
                                                                          height: 40,
                                                                          width: 170,
                                                                          text: "Delete")),
                                                                ],
                                                              ));
                                                        });
                                                  } else {
                                                    CustomWidgets.showToast(
                                                        context,
                                                        "Employee already used in Ticket",
                                                        false);
                                                  }
                                                },
                                                child: Icon(
                                                  Icons.delete,
                                                  color: Colors.redAccent,
                                                  size: 22,
                                                ))
                                            : Container(),
                                      ],
                                    )),
                                    DataCell(Text(e['EmpCode'])),
                                    DataCell(Text(e['FirstName'] ?? '')),
                                    DataCell(Text(e['MiddelName'])),
                                    DataCell(Text(e['LastName'])),
                                    DataCell(Text(e['branchId']['name'])),
                                    DataCell(Text(e['departmentId']['name'])),
                                    DataCell(Text(e['designationId']['name'])),
                                    DataCell(Text(e['roleId']['name'])),
                                    DataCell(Text(e['Gender'])),
                                    DataCell(Text(e['ShiftId']['name'])),
                                    DataCell(Text(e['Email'])),
                                    DataCell(Text(e['Number'].toString())),
                                    DataCell(Text(
                                        CustomWidgets.DateFormatchange(
                                            e['JoiningDate'].toString()))),
                                    DataCell(Text(
                                        CustomWidgets.DateFormatchange(
                                            e['Dob'].toString()))),
                                    DataCell(Text(e['ClosedDate'] != null
                                        ? CustomWidgets.DateFormatchange(
                                            e['ClosedDate'].toString())
                                        : "")),
                                    DataCell(Text(e['Address'])),
                                    DataCell(Text(e['BankName'].toString())),
                                    DataCell(Text(e['BankBranch'].toString())),
                                    DataCell(
                                        Text(e['BankAccountNo'].toString())),
                                    DataCell(Text(e['IFSCcode'].toString())),
                                    DataCell(Text(e['PANno'].toString())),
                                    DataCell(Text(e['FamilyName'])),
                                    DataCell(Text(e['Relationship'])),
                                    DataCell(Text(e['FamilyPhone'].toString())),
                                    DataCell(
                                      Checkbox(
                                        value: e['isActive'],
                                        shape: CircleBorder(),
                                        activeColor: Colorr.themcolor,
                                        onChanged: (value) {},
                                      ),
                                    ),
                                  ]);
                                }).toList()),
                          ),
                        )
                      : Container())
              // else
              )
          : CustomWidgets.NoDataImage(context);
    } else if (internetConn == 2) {
      return CustomWidgets.NoInternetImage(context);
    } else {
      return CustomWidgets.Circularprogress(context);
    }
  }
}
