import 'package:attendy/A_SQL_Trigger/EmployeeSalary_api.dart';
import 'package:attendy/utils/Constant/Con_icon.dart';
import 'package:attendy/utils/Constant/LocalCustomWidgets.dart';
import 'package:attendy/view/Dashboard/Dashboard.dart';
import 'package:attendy/view/Payroll/AddEmployeeSalary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../A_SQL_Trigger/Con_List.dart';
import '../../A_SQL_Trigger/Con_Usermast.dart';
import '../../A_SQL_Trigger/Employee_Add_api.dart';
import '../../A_SQL_Trigger/Role_api.dart';
import '../../utils/Constant/Colors.dart';
import '../../utils/DroupDown/custom_dropdown.dart';

class EmployeeSalary extends StatefulWidget {
  const EmployeeSalary({Key? key}) : super(key: key);

  @override
  State<EmployeeSalary> createState() => _EmployeeSalaryState();
}

class _EmployeeSalaryState extends State<EmployeeSalary> {
  List<String> Employee = [];
  int internetConn = 0;
  List<String> Role = [];
  double Height = 0;
  double Width = 0;
  bool isActive = false;
  TextEditingController employeeName = TextEditingController();
  TextEditingController EmailName = TextEditingController();
  TextEditingController Date = TextEditingController();
  TextEditingController RoleName = TextEditingController();
  TextEditingController Salary = TextEditingController();

  @override
  getdata() async {
    Con_List.EmployeeSalary = await EmployeeSalary_api.EmployeeSalarySelect();
    Con_List.AllEmployee = await AllEmployee_api.EmployeeSelect();
    Con_List.RoleSelect = await Role_api.RoleSelect();
    Con_List.RoleSelect.forEach((element) {
      if(element['isActive']==true) {
        Role.add(element['name']);
      }
    });
    Con_List.AllEmployee.forEach((element) {
      if(element['isActive']==true)
      {
        Employee.add(element['FirstName']);
      }
    });
    setState(() {});
  }

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

  Widget build(BuildContext context) {
    Height = MediaQuery.of(context).size.height - kToolbarHeight;
    Width = MediaQuery.of(context).size.width;
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
        child:Constants_Usermast.IOS==true
            ? CupertinoPageScaffold(
                navigationBar: CustomWidgets.appbarIOS(
                  title: "Employee Salary",
                  action: [
                    Con_List.Drawer.where((element) => element['subname']=='Employee Salary' && element['insert']==true).isNotEmpty ?
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Icon(Icons.add, color: Colorr.White),
                      onPressed: () {
                        Navigator.pushReplacement(context, CupertinoPageRoute(
                          builder: (context) {
                            return AddEmployeeSalary();
                          },
                        ));
                      },
                    ) :Container()
                  ],
                  context: context,
                  onTap: () {
                    Navigator.pushReplacement(context, CupertinoPageRoute(
                      builder: (context) {
                        return Dashboard();
                      },
                    ));
                  },
                ), child: Container(
            height: double.infinity,
            width: double.infinity,
            child: Con_List.EmployeeSalary.isNotEmpty
                ? SingleChildScrollView(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                    columns: const [
                      DataColumn(
                        label: Center(child: Text('Action')),
                      ),
                      DataColumn(
                        label: Center(child: Text('No')),
                      ),
                      DataColumn(
                        label: Center(child: Text('Name')),
                      ),
                      DataColumn(
                        label: Center(child: Text('Department Name')),
                      ),
                      DataColumn(
                        label: Center(child: Text('Designation Name')),
                      ),
                      DataColumn(
                        label: Center(child: Text('Date')),
                      ),
                      DataColumn(
                        label: Center(child: Text('Salary')),
                      ),
                      DataColumn(
                        label: Center(child: Text('Active')),
                      ),
                    ],
                    rows: Con_List.EmployeeSalary.asMap()
                        .entries
                        .map((entry) {
                      int index = entry.key + 1;
                      final e = entry.value;
                      String name = Con_List.AllEmployee.isEmpty
                          ? ""
                          : Con_List.AllEmployee.firstWhere((element) => element['_id'] == e['employeeId'], orElse: () => {'FirstName': ''})['FirstName'].toString();
                      String deparmentId = Con_List.AllEmployee.firstWhere((element) => element['_id'] == e['employeeId'], orElse: () => {'departmentId': ''})['departmentId'].toString();
                      String designationId = Con_List.AllEmployee.firstWhere((element) => element['_id'] == e['employeeId'], orElse: () => {'designationId': ''})['designationId'].toString();
                      String Deparment = Con_List.DeparmenntSelect.firstWhere((element) => element['_id'] == deparmentId, orElse: () => {'name': ''})['name'].toString();
                      String Designation = Con_List.DesignationSelect.firstWhere((element) => element['_id'] == designationId, orElse: () => {'name': ''})['name'].toString();
                      return DataRow(cells: [
                        DataCell(Row(
                          children: [
                            Con_List.Drawer.where((element) => element['subname']=='Employee Salary' && element['update']==true).isNotEmpty ?
                            GestureDetector(
                                onTap: () {
                                  Navigator.push(context, CupertinoPageRoute(builder: (context) {
                                    return AddEmployeeSalary(e : e);
                                  },));
                                },
                                child: Icon(
                                  Icons.edit,
                                  color: Colorr.themcolor,
                                  size: 22,
                                )) : Container(),
                            Con_List.Drawer.where((element) => element['subname']=='Employee Salary' && element['delate']==true).isNotEmpty ?
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
                                                      if (await CustomWidgets
                                                          .CheakConnectionInternetButton()) {
                                                        if (await EmployeeSalary_api.EmployeeSalaryDelete(
                                                            e['_id'])) {
                                                          Con_List.EmployeeSalary = await EmployeeSalary_api.EmployeeSalarySelect();
                                                          setState(() {});
                                                          CustomWidgets.showToast(
                                                              context, "Employee Salary Deleted Successfully",
                                                              true);
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
                                                    child: Text("Delete"),
                                                  ),
                                                ],
                                              ),
                                            ],
                                            title: Text(
                                              "Do you want to delete this entry ?",
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
                        DataCell(Text(index.toString())),
                        DataCell(Text(Con_List.AllEmployee.isEmpty
                            ? ""
                            : Con_List.AllEmployee.firstWhere(
                                (element) =>
                            element['_id'] ==
                                e['employeeId'],
                            orElse: () => {
                              'FirstName': ''
                            })['FirstName']
                            .toString())),
                        DataCell(Text(Deparment)),
                        DataCell(Text(Designation)),
                        DataCell(Text(CustomWidgets.DateFormatchange(e['date'].toString()))),
                        DataCell(Text(e['salary'].toString())),
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
                : Container()),
              )
            : Scaffold(
                appBar: CustomWidgets.appbar(
                  title: "Employee Salary",
                  action: [
                    Con_List.Drawer.where((element) => element['subname']=='Employee Salary' && element['insert']==true).isNotEmpty ?
                    IconButton(
                        splashRadius: 18,
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return AddEmployeeSalary();
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
      return Con_List.EmployeeSalary.isNotEmpty
          ? Container(
              height: double.infinity,
              width: double.infinity,
              child: Con_List.EmployeeSalary.isNotEmpty
                  ? SingleChildScrollView(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                            columns: const [
                              DataColumn(
                                label: Center(
                                    child: Text('Action')),
                              ),
                              DataColumn(
                                label: Center(child: Text('No')),
                              ),
                              DataColumn(
                                label: Center(child: Text('Name')),
                              ),
                              DataColumn(
                                label: Center(child: Text('Department Name')),
                              ),
                              DataColumn(
                                label: Center(child: Text('Designation Name')),
                              ),
                              DataColumn(
                                label: Center(child: Text('From Date')),
                              ),
                              DataColumn(
                                label: Center(child: Text('To Date')),
                              ),
                              DataColumn(
                                label: Center(child: Text('Salary')),
                              ),
                              DataColumn(
                                label: Center(child: Text('Active')),
                              ),
                            ],
                            rows: Con_List.EmployeeSalary.asMap()
                                .entries
                                .map((entry) {
                              int index = entry.key + 1;
                              final e = entry.value;
                              String Deparment = Con_List.AllEmployee.firstWhere((element) => element['_id'] == e['employeeId'], orElse: () => {'departmentId': {"_id": "", "name": ""}})['departmentId']['name'].toString();
                              String Designation = Con_List.AllEmployee.firstWhere((element) => element['_id'] == e['employeeId'], orElse: () => {'designationId': {"_id": "", "name": ""}})['designationId']['name'].toString();
                              return DataRow(cells: [
                                DataCell(Row(
                                  children: [
                                    Con_List.Drawer.where((element) => element['subname']=='Employee Salary' && element['update']==true).isNotEmpty ?
                                    InkWell(
                                        onTap: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                                            return AddEmployeeSalary(e: e,);
                                          },));
                                        },
                                        child: Icon(
                                          Icons.edit,
                                          color: Colorr.themcolor,
                                          size: 22,
                                        )) : Container(),
                                    Con_List.Drawer.where((element) => element['subname']=='Employee Salary' && element['delate']==true).isNotEmpty ?
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
                                                                        Height /
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
                                                                        if (await EmployeeSalary_api.EmployeeSalaryDelete(
                                                                            e['_id'])) {
                                                                          Con_List.EmployeeSalary =
                                                                              await EmployeeSalary_api.EmployeeSalarySelect();
                                                                          setState(
                                                                              () {});
                                                                          CustomWidgets.showToast(
                                                                              context,
                                                                              "Employee Salary Deleted Successfully",
                                                                              true);
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
                                            (element) =>
                                                element['_id'] ==
                                                e['employeeId'],
                                            orElse: () => {
                                                  'FirstName': ''
                                                })['FirstName']
                                        .toString())),
                                DataCell(Text(Deparment)),
                                DataCell(Text(Designation)),
                                DataCell(Text(CustomWidgets.DateFormatchange(e['fromDate'].toString()))),
                                DataCell(Text(CustomWidgets.DateFormatchange(e['toDate'].toString()))),
                                DataCell(Text(e['salary'].toString())),
                                DataCell(Checkbox(value: e['isActive'],
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
          : CustomWidgets.NoDataImage(context);
    } else if (internetConn == 2) {
      return CustomWidgets.NoInternetImage(context);
    } else {
      return CustomWidgets.Circularprogress(context);
    }
  }
}
