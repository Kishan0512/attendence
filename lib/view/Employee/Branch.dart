
import 'package:attendy/A_SQL_Trigger/Con_Usermast.dart';
import 'package:attendy/utils/Constant/LocalCustomWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../A_SQL_Trigger/Branchapi.dart';
import '../../A_SQL_Trigger/Con_List.dart';
import '../../A_SQL_Trigger/Employee_Add_api.dart';
import '../../utils/Constant/Colors.dart';
import '../Dashboard/Dashboard.dart';
import 'AddBranch.dart';

class Branch extends StatefulWidget {
  const Branch({Key? key}) : super(key: key);

  @override
  State<Branch> createState() => _BranchState();
}

class _BranchState extends State<Branch> {
  bool isActive=false;
  int internetConn=0;
  double height=0;
  double width=0;
  TextEditingController Branch=TextEditingController();
  TextEditingController ContactNumber=TextEditingController();
  TextEditingController Address=TextEditingController();
  TextEditingController Order =TextEditingController();
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
    Con_List.BranchSelect = await Branch_api.BranchSelect();
    Con_List.AllEmployee = await AllEmployee_api.EmployeeSelect();
    setState(() {
    });
  }
  Widget build(BuildContext context) {
     height=MediaQuery.of(context).size.height-kToolbarHeight;
     width = MediaQuery.of(context).size.width;
    Future<bool> onBackPress() {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return Dashboard();
      },));
      return Future.value(false);
    }
    return WillPopScope(
        onWillPop: () => onBackPress(),
    child: Constants_Usermast.IOS==true ? CupertinoPageScaffold(
        navigationBar: CustomWidgets.appbarIOS(title: "Branch", action: [
          Con_List.Drawer.where((element) => element['subname']=='Branch' && element['insert']==true).isNotEmpty ?
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: Icon(Icons.add, color: Colorr.White),
            onPressed: () {
              Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) {
                return AddBranch();
              },));
            },
          ) : Container()
        ], context: context, onTap: () {
          Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) {
            return Dashboard();
          },));
        },),
        child: Container(
            height: double.infinity,
            width: double.infinity,
            color: Colorr.Backgroundd,
            child: Con_List.BranchSelect.isNotEmpty
                ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                  columns: [

                    DataColumn(
                      label: Text('No'),
                    ),
                    DataColumn(
                      label: Text('Branch Name'),
                    ),
                    DataColumn(
                      label: Text('Number'),
                    ),
                    DataColumn(
                      label: Text('Address'),
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
                  rows: Con_List.BranchSelect.asMap().entries.map((entry) {
                    int index = entry.key + 1;
                    final e = entry.value;
                    return DataRow(cells: [

                      DataCell(Text(index.toString())),
                      DataCell(Text(e['name']!)),
                      DataCell(Text(e['number'].toString())),
                      DataCell(Text(e['address']!)),
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
                          Con_List.Drawer.where((element) => element['subname']=='Branch' && element['update']==true).isNotEmpty ?
                          GestureDetector(
                              onTap: () {
                                showCupertinoDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    Branch.text=e['name'];
                                    ContactNumber.text=e['number'].toString();
                                    Address.text=e['address'];
                                    isActive=e['isActive'];
                                    Order.text=e['ord'].toString();
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
                                                    if(await Branch_api.BranchUpdate(e['_id'],Branch.text, isActive,Address.text,ContactNumber.text,Order.text)){
                                                      getdata();
                                                      setState(() {
                                                      });
                                                      Navigator.pop(context);
                                                      CustomWidgets.showToast(context, "Branch Update Successfully",true);
                                                    }
                                                  },
                                                  child: Text("Update"),
                                                ),
                                              ],
                                            ),
                                          ],
                                          title: Column(children: [
                                            CustomWidgets.height(5),
                                            Text("Update Branch"),
                                            CustomWidgets.height(5),
                                            CustomWidgets.textFieldIOS(hintText: "Branch",controller: Branch),
                                            CustomWidgets.textFieldIOS(hintText: "Contact Number",controller: ContactNumber),
                                            CustomWidgets.textFieldIOS(hintText: "Address",controller: Address),
                                            CustomWidgets.textFieldIOS(hintText: "Order",controller: Order),
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
                                                    setState1(() {
                                                      isActive = value;
                                                    });
                                                  },
                                                  activeColor: Colorr.themcolor, // Replace with your desired active color
                                                ),
                                              ],
                                            ),
                                          ]),
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                              child: Icon(
                                Icons.edit,
                                color: Colorr.themcolor,
                                size: 22,
                              )) : Container(),
                          Con_List.Drawer.where((element) => element['subname']=='Branch' && element['delate']==true).isNotEmpty ?
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
                                                    if(await Branch_api.BranchDelete(e['_id'])){
                                                      Con_List.BranchSelect=await Branch_api.BranchSelect();
                                                      setState(() {
                                                      });
                                                      CustomWidgets.showToast(context, "Branch Deleted Successfully",true);
                                                      Navigator.pop(context);
                                                    }else{
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
                              )) :Container(),
                        ],
                      )),
                    ]);
                  }).toList()),
            )
                : Container())) : Scaffold(
      appBar: CustomWidgets.appbar(title: "Branch" ,action:  [
        Con_List.Drawer.where((element) => element['subname']=='Branch' && element['insert']==true).isNotEmpty ?
        IconButton(splashRadius: 18,onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddBranch();
          },));
        }, icon: Icon(Icons.add_circle_outline)):Container()
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
      return Con_List.BranchSelect.isNotEmpty ? Container(
          height: double.infinity,
          width: double.infinity,
          color: Colorr.Backgroundd,
          child: Con_List.BranchSelect.isNotEmpty
              ? SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
                columns: [
                  DataColumn(
                    label: Text('No'),
                  ),
                  DataColumn(
                    label: Text('Branch Name'),
                  ),
                  DataColumn(
                    label: Text('Number'),
                  ),
                  DataColumn(
                    label: Text('Address'),
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
                rows: Con_List.BranchSelect.asMap().entries.map((entry) {
                  int index = entry.key + 1;
                  final e = entry.value;
                  return DataRow(cells: [

                    DataCell(Text(index.toString())),
                    DataCell(Text(e['name']!)),
                    DataCell(Text(e['number'].toString())),
                    DataCell(Text(e['address']!)),
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
                        Con_List.Drawer.where((element) => element['subname']=='Branch' && element['update']==true).isNotEmpty ?
                        InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    Branch.text=e['name'];
                                    ContactNumber.text=e['number'].toString();
                                    Address.text=e['address'];
                                    isActive=e['isActive'];
                                    Order.text=e['ord'].toString();
                                    return StatefulBuilder(builder: (context, setState1) {
                                      return AlertDialog(
                                          title: Center(child: Text("Update Branch",style: TextStyle(color: Colorr.themcolor,fontSize: 17),)),
                                          content:Container(
                                            height: height/2.5,
                                            child: Column(
                                              children: [
                                                CustomWidgets.height(5),
                                                CustomWidgets.textField(hintText: "Branch",controller: Branch),
                                                CustomWidgets.textField(hintText: "Contact Number",controller: ContactNumber),
                                                CustomWidgets.textField(hintText: "Address",controller: Address),
                                                CustomWidgets.textField(hintText: "Order",controller: Order),
                                                Row(children : [
                                                  Checkbox(
                                                    shape: CircleBorder(),
                                                    value: isActive,
                                                    activeColor: Colorr.themcolor,
                                                    onChanged: (value) {
                                                      setState1(() {
                                                        isActive = value!;
                                                      });
                                                    },
                                                  ),
                                                  Text("Active"),
                                                ]),
                                                Row(
                                                  children: [
                                                    CustomWidgets.confirmButton(onTap: () {
                                                      Navigator.pop(context);
                                                    },height: height/20,width: width/3.5,text:  "Cancel",Clr: Colors.redAccent),
                                                    CustomWidgets.width(5),
                                                    CustomWidgets.confirmButton(onTap: () async {
                                                      FocusScope.of(context).unfocus();
                                                      if(await CustomWidgets.CheakConnectionInternetButton())
                                                      {
                                                        if(await Branch_api.BranchUpdate(e['_id'],Branch.text, isActive,Address.text,ContactNumber.text,Order.text)){
                                                          getdata();
                                                          setState(() {
                                                          });
                                                          Navigator.pop(context);
                                                          CustomWidgets.showToast(context, "Branch Update Successfully",true);
                                                        }
                                                      }else{
                                                        Navigator.pop(context);
                                                        CustomWidgets.showToast(context, "No Internet Connection", false);
                                                      }

                                                    },height: height/20,width:  width/3.5,text:  "Update"),
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
                        Con_List.Drawer.where((element) => element['subname']=='Branch' && element['delate']==true).isNotEmpty ?
                        InkWell(
                            onTap: () {
                              if(Con_List.AllEmployee.where((element) => element['branchId'].toString()==e['_id'].toString()).isNotEmpty){
                                CustomWidgets.showToast(context, "Branch use in employee", false);
                              }else{
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                          title: Center(child: Text("Do you want to delete this entry ?",style: TextStyle(color: Colorr.themcolor),)),
                                          content:Row(
                                            children: [
                                              Expanded(child:CustomWidgets.confirmButton(onTap: () {
                                                Navigator.pop(context);
                                              },height:  40,width:  170,text:  "Cancel",Clr: Colors.redAccent)),
                                              CustomWidgets.width(5),
                                              Expanded(child:  CustomWidgets.confirmButton(onTap: () async {
                                                FocusScope.of(context).unfocus();
                                                if(await CustomWidgets.CheakConnectionInternetButton())
                                                {
                                                  if(await Branch_api.BranchDelete(e['_id'])){
                                                    Con_List.BranchSelect=await Branch_api.BranchSelect();
                                                    setState(() {
                                                    });
                                                    CustomWidgets.showToast(context, "Branch Deleted Successfully",true);
                                                    Navigator.pop(context);
                                                  }else{
                                                    Navigator.pop(context);
                                                  }
                                                }else{
                                                  Navigator.pop(context);
                                                  CustomWidgets.showToast(context, "No Internet Connection", false);
                                                }
                                              },height: 40,width:  170,text:  "Delete")),
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
              : Container()): CustomWidgets.NoDataImage(context);
    } else if (internetConn == 2) {
      return CustomWidgets.NoInternetImage(context);
    } else {
      return CustomWidgets.Circularprogress(context);
    }
  }
}
