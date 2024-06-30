import 'dart:developer';

import 'package:attendy/A_SQL_Trigger/Con_List.dart';
import 'package:attendy/A_SQL_Trigger/Role_api.dart';
import 'package:attendy/A_SQL_Trigger/api_page.dart';
import 'package:attendy/utils/Constant/LocalCustomWidgets.dart';
import 'package:attendy/view/Users/AddUser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../A_SQL_Trigger/Con_Usermast.dart';
import '../../A_SQL_Trigger/Employee_Add_api.dart';
import '../../A_SQL_Trigger/SharePref.dart';
import '../../utils/Constant/Colors.dart';
import '../../utils/Constant/Con_icon.dart';
import '../../utils/DroupDown/custom_dropdown.dart';
import '../Dashboard/Dashboard.dart';

class User extends StatefulWidget {
  const User({Key? key}) : super(key: key);

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  TextEditingController Name =TextEditingController();
  TextEditingController Email =TextEditingController();
  TextEditingController Role=TextEditingController();
  TextEditingController Employee=TextEditingController();
  TextEditingController phone=TextEditingController();
  bool AddActive=false;
  double height=0;
  List<String> RoleName=[],AllEmployee=[];
  int internetConn=0;
  double width=0;

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
    Con_List.Users = await api_page.userSelect();
    Con_List.RoleSelect= await Role_api.RoleSelect();
    Con_List.CompanySelect= await api_page.CompanySelect();
    Con_List.AllEmployee=await AllEmployee_api.EmployeeSelect();
    Con_List.RoleSelect.forEach((element) {
      if(element['isActive']==true) {
        RoleName.add(element['name']);
      }
    });
    Con_List.AllEmployee.forEach((element) {
      if(element['isActive']==true)
      {
        AllEmployee.add(element['FirstName']);
      }
    });
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
    child:Constants_Usermast.IOS==true
        ? CupertinoPageScaffold(
      navigationBar: CustomWidgets.appbarIOS(
        title: "User",
        action: [
          Con_List.Drawer.where((element) => element['subname']=='Users' && element['insert']==true).isNotEmpty ?
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: Icon(Icons.add, color: Colorr.White),
            onPressed: () {
              Navigator.pushReplacement(context, CupertinoPageRoute(
                builder: (context) {
                  return AddUser();
                },
              ));
            },
          ) : Container()
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
          child: Con_List.Users.isNotEmpty
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
                      label: Text('Employee Name'),
                    ),
                    DataColumn(
                      label: Text('Email'),
                    ),
                    DataColumn(
                      label: Text('Company Name'),
                    ),
                    DataColumn(
                      label: Text('Role'),
                    ),
                    DataColumn(
                      label: Text('Active'),
                    ),
                    DataColumn(
                      label: Text('Action'),
                    ),
                  ],
                  rows: Con_List.Users.asMap().entries.map((entry) {
                    int index = entry.key + 1;
                    final e = entry.value;
                    return DataRow(cells: [
                      DataCell(Text(index.toString())),
                      DataCell(Text(e['name']!)),
                      DataCell(Text(Con_List.AllEmployee.firstWhere((element) => element['_id'].toString() == e['employeeId'].toString(), orElse: () => {'FirstName': ''})['FirstName'].toString())),

                      DataCell(Text(e['email']!)),
                      DataCell(Text(Con_List.CompanySelect.isEmpty
                          ? ""
                          : Con_List.CompanySelect.firstWhere(
                              (element) => element['_id'].toString() == e['company_id'].toString(),
                          orElse: () => {'name': ''}
                      )['name'].toString())),
                      DataCell(Text(Con_List.RoleSelect.isEmpty
                          ? ""
                          : Con_List.RoleSelect.firstWhere(
                              (element) => element['_id'].toString() == e['roleId'].toString(),
                          orElse: () => {'name': ''}
                      )['name'].toString())),
                      DataCell(
                        Checkbox(
                          value: e['isActive'],
                          shape: CircleBorder(),
                          activeColor: Colorr.themcolor,
                          onChanged: (value) {},
                        ),
                      ),
                      DataCell(
                          Con_List.Drawer.where((element) => element['subname']=='Users' && element['update']==true).isNotEmpty ?
                          GestureDetector(
                          onTap: () {
                            Name.text=e['name'];
                            Email.text=e['email'];
                            phone.text=e['phone'].toString();
                            Role.text=Con_List.RoleSelect.firstWhere((element) => element['_id'].toString() == e['roleId'].toString(), orElse: () => {'name': ''})['name'].toString();
                            AddActive=e['isActive'];
                            showCupertinoDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(builder: (context, setState1) {
                                  return CupertinoAlertDialog(
                                    title: Center(
                                      child: Text(
                                        "Update User",
                                        style: TextStyle(
                                          color: Colorr.themcolor,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                    content: Container(
                                      height: height / 2,
                                      child: Column(
                                        children: [
                                          CustomWidgets.textFieldIOS(hintText: "Name", controller: Name),
                                          CustomWidgets.textFieldIOS(hintText: "Email Id", controller: Email),
                                          CustomWidgets.textFieldIOS(
                                            hintText: "Phone",
                                            controller: phone,
                                            keyboardType: TextInputType.phone,
                                            MaxFont: 13,
                                            height: 65,
                                          ),
                                          CustomWidgets.textFieldIOS(hintText: "Select Role",controller: Role,readOnly: true,onTap: () {
                                            CustomWidgets.SelectDroupDown(context: context,items: RoleName, onSelectedItemChanged: (int) {
                                              Role.text=RoleName[int];
                                              setState(() {
                                              });
                                            });
                                          },suffix: CustomWidgets.aarowCupertinobutton(),
                                          ),
                                          CustomWidgets.textFieldIOS(hintText: "Select Employee",controller: Employee,readOnly: true,onTap: () {
                                            CustomWidgets.SelectDroupDown(context: context,items: AllEmployee, onSelectedItemChanged: (int) {
                                              Employee.text=AllEmployee[int];
                                              setState(() {
                                              });
                                            });
                                          },suffix: CustomWidgets.aarowCupertinobutton(),
                                          ),
                                          Row(
                                            children: [
                                              CupertinoSwitch(
                                                value: AddActive,
                                                activeColor: Colorr.themcolor,
                                                onChanged: (value) {
                                                  setState1(() {
                                                    AddActive = value;
                                                  });
                                                },
                                              ),
                                              Text("Active"),
                                            ],
                                          ),
                                          Spacer(),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: CustomWidgets.confirmButton1(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  height: height / 20,
                                                  width: 140,
                                                  text: "Cancel",
                                                  Clr: Colors.redAccent, textsize: 12,
                                                ),
                                              ),
                                              CustomWidgets.width(5),
                                              Expanded(
                                                child: CustomWidgets.confirmButton1(
                                                  onTap: () async {
                                                    if (await CustomWidgets.CheakConnectionInternetButton()) {
                                                      Map data = {
                                                        "id": e['_id'],
                                                        "name": Name.text,
                                                        "email": Email.text,
                                                        "phone": phone.text,
                                                        "password": e['password'],
                                                        "isActive": AddActive.toString(),
                                                        "roleId": Con_List.RoleSelect.firstWhere((element) => element['name'].toString() == Role.text, orElse: () => {'_id': ''})['_id'].toString(),
                                                        "employeeId": Con_List.AllEmployee.firstWhere((element) => element['FirstName'].toString() == Employee.text, orElse: () => {'_id': ''})['_id'].toString(),
                                                      };

                                                      if (await api_page.userupdate(data)) {
                                                        getdata();
                                                        Navigator.pop(context);
                                                        CustomWidgets.showToast(context, "User Update Successfully", true);
                                                      } else {
                                                        CustomWidgets.showToast(context, "User Not Update", false);
                                                      }
                                                    } else {
                                                      CustomWidgets.showToast(context, "No Internet Connection", false);
                                                    }
                                                  },
                                                  height: height / 20,
                                                  width: 140,
                                                  text: "Update", textsize: 12,
                                                ),
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
                          )) : Container()),
                    ]);
                  }).toList()),
            ),
          )
              : Container()) ,
    )
        : Scaffold(
      appBar: CustomWidgets.appbar(title: "User",action:  [
        IconButton(splashRadius: 18,onPressed: () async {
          Con_List.Users = await api_page.userSelect();
          Con_List.RoleSelect= await Role_api.RoleSelect();
          Con_List.CompanySelect= await api_page.CompanySelect();
          Con_List.AllEmployee=await AllEmployee_api.EmployeeSelect();
          Con_List.RoleSelect.forEach((element) {
            if(element['isActive']==true) {
              RoleName.add(element['name']);
            }
          });
          Con_List.AllEmployee.forEach((element) {
            if(element['isActive']==true)
            {
              AllEmployee.add(element['FirstName']);
            }
          });
          setState(() {
          });
        }, icon: Con_icon.Refresh),
        Con_List.Drawer.where((element) => element['subname']=='Users' && element['insert']==true).isNotEmpty ?
        IconButton(splashRadius: 18,onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddUser();
          },));
        }, icon: Con_icon.AddNew) : Container()
      ],context:  context,onTap: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return Dashboard();
        },));
      },),
      body:mainwidget(),
    ));
  }
  Widget mainwidget() {
    if (internetConn == 1) {
      return Con_List.Users.isNotEmpty ? Container(
          height: double.infinity,
          width: double.infinity,
          color: Colorr.White,
          child: Con_List.Users.isNotEmpty
              ? SingleChildScrollView(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                  columns: const [
                    DataColumn(
                      label: Text('No'),
                    ),
                    DataColumn(
                      label: Text('Name'),
                    ),
                    DataColumn(
                      label: Text('Employee Name'),
                    ),
                    DataColumn(
                      label: Text('Email'),
                    ),
                    DataColumn(
                      label: Text('Phone number'),
                    ),
                    DataColumn(
                      label: Text('Company Name'),
                    ),
                    DataColumn(
                      label: Text('Role'),
                    ),
                    DataColumn(
                      label: Text('Active'),
                    ),
                    DataColumn(
                      label: Text('Action'),
                    ),
                  ],
                  rows: Con_List.Users.asMap().entries.map((entry) {
                    int index = entry.key + 1;
                    final e = entry.value;
                    return DataRow(cells: [
                      DataCell(Text(index.toString())),
                      DataCell(Text(e['name']!)),
                      DataCell(Text(e['employeeId']!=null?e['employeeId']['FirstName']:"")),
                      DataCell(Text(e['email']!)),
                      DataCell(Text(e['phone'].toString())),
                      DataCell(Text(e['company_id']['name'])),
                      DataCell(Text(e['roleId']!=null?e['roleId']['name']:"")),
                      DataCell(
                        Checkbox(
                          value: e['isActive'],
                          shape: CircleBorder(),
                          activeColor: Colorr.themcolor,
                          onChanged: (value) {},
                        ),
                      ),
                      DataCell(
                          Con_List.Drawer.where((element) => element['subname']=='Users' && element['update']==true).isNotEmpty ?
                          InkWell(
                          onTap: () {
                            Name.text=e['name'];
                            Email.text=e['email'];
                            phone.text=e['phone'].toString();
                            Role.text=Con_List.RoleSelect.firstWhere((element) => element['_id'].toString() == e['roleId'].toString(), orElse: () => {'name': ''})['name'].toString();
                            AddActive= e['isActive'];
                            Employee.text = Con_List.AllEmployee.firstWhere((element) => element['_id'].toString() == e['employeeId'].toString(), orElse: () => {'FirstName': ''})['FirstName'].toString();
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(builder: (context, setState1) {
                                    return AlertDialog(
                                        title: Center(child: Text("Update User",style: TextStyle(color: Colorr.themcolor,fontSize: 17),)),
                                        content:Container(
                                          height: height/2,
                                          child: Column(
                                            children: [
                                              CustomWidgets.textField(hintText:"Name",controller: Name),
                                              CustomWidgets.textField(hintText:"Email Id",controller: Email),
                                              CustomWidgets.textField(hintText: "Phone",controller: phone,keyboardType: TextInputType.phone,MaxFont: 13,height:65),
                                              CustomDropdown.search(listItemStyle: CustomWidgets.style(),
                                                hintText: 'Select Role',
                                                controller: Role,
                                                items: RoleName,
                                              ),
                                              CustomDropdown.search(listItemStyle: CustomWidgets.style(),
                                                hintText: 'Select Employee',
                                                controller: Employee,
                                                items: AllEmployee,
                                              ),
                                              Row(children: [
                                                Checkbox(
                                                  value: AddActive,
                                                  shape: CircleBorder(),
                                                  activeColor: Colorr.themcolor,
                                                  onChanged: (value) {
                                                    AddActive=value!;
                                                    setState1(() {
                                                    });
                                                  },
                                                ),
                                                Text("Active")
                                              ],),
                                              Spacer(),
                                              Row(
                                                children: [
                                                  Expanded(child:CustomWidgets.confirmButton(onTap: () {
                                                    Navigator.pop(context);
                                                  },height:height/20,width:140,text:  "Cancel",Clr: Colors.redAccent)),
                                                  CustomWidgets.width(5),
                                                  Expanded(child: CustomWidgets.confirmButton(onTap: () async {
                                                    if(await CustomWidgets.CheakConnectionInternetButton())
                                                    {
                                                      Map data= {
                                                        "id": e['_id'],
                                                        "name" : Name.text,
                                                        "email" : Email.text,
                                                        "phone"  :   phone.text,
                                                        "isActive" : AddActive.toString(),
                                                        "password": e["password"].toString(),
                                                        // "faceId":"",
                                                        "roleId" : Con_List.RoleSelect.firstWhere((element) => element['name'].toString() == Role.text, orElse: () => {'_id': ''})['_id'].toString(),
                                                        "employeeId" :  Con_List.AllEmployee.firstWhere((element) => element['FirstName'].toString() == Employee.text,orElse: () => {'_id': ''})['_id'].toString()
                                                      };
                                                      if(await api_page.userupdate(data)){
                                                        getdata();
                                                        SharedPref.save_string(
                                                            SrdPrefkey.roleId.toString(), Con_List.RoleSelect.firstWhere((element) => element['name'].toString() == Role.text, orElse: () => {'_id': ''})['_id'].toString().toString());
                                                        SharedPref.save_string(
                                                            SrdPrefkey.employeeId.toString(), Con_List.AllEmployee.firstWhere((element) => element['FirstName'].toString() == Employee.text,orElse: () => {'_id': ''})['_id'].toString().toString());
                                                        Navigator.pop(context);
                                                        CustomWidgets.showToast(context, "User Update Successfully",true);
                                                      }else{
                                                        CustomWidgets.showToast(context, "User Not Update",false);
                                                      }
                                                    }else{
                                                      CustomWidgets.showToast(context, "No Internet Connection", false);
                                                    }
                                                  },height: height/20,width:  140,text:  "Update")),
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
                          )) : Container()),
                    ]);
                  }).toList()),
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
