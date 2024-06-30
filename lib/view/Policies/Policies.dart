import 'package:attendy/A_SQL_Trigger/Policies_api.dart';
import 'package:attendy/utils/Constant/Con_icon.dart';
import 'package:attendy/utils/Constant/LocalCustomWidgets.dart';
import 'package:attendy/view/Dashboard/Dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../A_SQL_Trigger/Con_List.dart';
import '../../A_SQL_Trigger/Con_Usermast.dart';
import '../../A_SQL_Trigger/Deparment_api_page.dart';
import '../../utils/Constant/Colors.dart';
import '../../utils/DroupDown/custom_dropdown.dart';
import 'AddPolicies.dart';

class Policies extends StatefulWidget {
  const Policies({Key? key}) : super(key: key);

  @override
  State<Policies> createState() => _PoliciesState();
}

class _PoliciesState extends State<Policies> {
  bool isActive=false;
  List<String> Deparment=[];
  double Height =0;
  double width=0;
  int internetConn=0;

  TextEditingController PoliciesName=TextEditingController();
  TextEditingController Description=TextEditingController();
  TextEditingController DeparmentName=TextEditingController();
  TextEditingController Date=TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
    CheakInternet();
  }
  getdata()
  async {
    Con_List.Policies=await Policies_api.PoliciesSelect();
    Con_List.DeparmenntSelect=await Deparmentapi.DeparmentSelect();
    Con_List.DeparmenntSelect.forEach((element) {
      if(element['isActive']==true) {
        Deparment.add(element['name']);
      }
    });
    setState(() {
    });
  }
  CheakInternet()
  async {
    internetConn = await CustomWidgets.CheakConnectionInternet();
    setState(() {
    });
  }
  Widget build(BuildContext context) {
    Height =MediaQuery.of(context).size.height;
    width=MediaQuery.of(context).size.width;
    Future<bool> onBackPress() {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return Dashboard();
      },));
      return Future.value(false);
    }
    return WillPopScope(
        onWillPop: () => onBackPress(),
    child: Constants_Usermast.IOS==true
        ? CupertinoPageScaffold(
      navigationBar: CustomWidgets.appbarIOS(
        title: "Policies",
        action: [
          Con_List.Drawer.where((element) => element['name']=='Policies' && element['insert']==true).isNotEmpty ?
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: Icon(Icons.add, color: Colorr.White),
            onPressed: () {
              Navigator.pushReplacement(context, CupertinoPageRoute(
                builder: (context) {
                  return AddPolicies();
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
          child: Con_List.Policies.isNotEmpty
              ? SingleChildScrollView(
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
                      label: Text('Name'),
                    ),
                    DataColumn(
                      label: Text('Department'),
                    ),
                    DataColumn(
                      label: Text('Description'),
                    ),
                    DataColumn(
                      label: Text('Date'),
                    ),
                    DataColumn(
                      label: Text('Active'),
                    ),

                  ],
                  rows: Con_List.Policies.asMap().entries.map((entry) {
                    int index = entry.key + 1;
                    final e = entry.value;
                    return DataRow(cells: [
                      DataCell(Row(
                        children: [
                          Con_List.Drawer.where((element) => element['name']=='Policies' && element['update']==true).isNotEmpty ?
                          GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) {
                                  return AddPolicies(e:e);
                                },));
                              },
                              child: Icon(
                                Icons.edit,
                                color: Colorr.themcolor,
                                size: 22,
                              )) : Container(),
                          Con_List.Drawer.where((element) => element['name']=='Policies' && element['delate']==true).isNotEmpty ?
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
                                                    if(await CustomWidgets.CheakConnectionInternetButton())
                                                    {
                                                      if(await Policies_api.PoliciesDelete(e['_id'])){
                                                        getdata();
                                                        setState(() {
                                                        });
                                                        CustomWidgets.showToast(context, "Policies Deleted Successfully",true);
                                                        Navigator.pop(context);
                                                      }else{
                                                        Navigator.pop(context);
                                                      }
                                                    }else{
                                                      Navigator.pop(context);
                                                      CustomWidgets.showToast(context, "No Internet Connection", false);
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
                      DataCell(Text(e['name'])),
                      DataCell(Text(
                        Con_List.DeparmenntSelect.firstWhere((element) => element['_id']==e['departmentId'], orElse: () => {'name': ''})['name'].toString(),)),
                      DataCell(Text(e['description'].toString())),
                      DataCell(Text(CustomWidgets.DateFormatchange(e['createDate'].toString()))),
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
    ) :Scaffold(
      appBar: CustomWidgets.appbar(title: "Policies",action:  [
        IconButton(padding: EdgeInsets.zero,splashRadius: 18,onPressed: () {
          Con_List.Drawer.where((element) => element['name']=='Policies' && element['insert']==true).isNotEmpty ?
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddPolicies();
          },)) : Container();
        }, icon: Con_icon.AddNew),
        IconButton(padding: EdgeInsets.zero,splashRadius: 18,onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
              return Policies();
            },));
        }, icon: Con_icon.Refresh)
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
      return Con_List.Policies.isNotEmpty ? Container(
          height: double.infinity,
          width: double.infinity,
          color: Colorr.White,
          child: Con_List.Policies.isNotEmpty
              ? SingleChildScrollView(
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
                      label: Text('Name'),
                    ),
                    DataColumn(
                      label: Text('Department'),
                    ),
                    DataColumn(
                      label: Text('Description'),
                    ),
                    DataColumn(
                      label: Text('Date'),
                    ),
                    DataColumn(
                      label: Text('Active'),
                    ),

                  ],
                  rows: Con_List.Policies.asMap().entries.map((entry) {
                    int index = entry.key + 1;
                    final e = entry.value;
                    return DataRow(cells: [
                      DataCell(Row(
                        children: [
                          Con_List.Drawer.where((element) => element['name']=='Policies' && element['update']==true).isNotEmpty ?
                          InkWell(
                              onTap: () {
                                PoliciesName.text=e['name'];
                                DeparmentName.text = Con_List.DeparmenntSelect
                                    .firstWhere((element) => element['_id'] == e['departmentId'], orElse: () => {'name': ''})['name'].toString();
                                Description.text=e['description'].toString();
                                Date.text=CustomWidgets.DateFormatchange(e['createDate']);
                                isActive=e['isActive'];
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(builder: (context, setState1) {
                                        return AlertDialog(
                                            title: Center(child: Text("Update Policies",style: TextStyle(color: Colorr.themcolor,fontSize: 17),)),
                                            content:Container(
                                              height: Height/2.5,
                                              child: Column(
                                                children: [
                                                  CustomWidgets.textField(hintText: "Policies Name",controller: PoliciesName),
                                                  CustomDropdown.search(  listItemStyle: CustomWidgets.style(),
                                                    hintText: 'Select Deparment',
                                                    controller: DeparmentName,
                                                    items: Deparment,
                                                  ),
                                                  CustomWidgets.textField(hintText: "Description",controller: Description),
                                                  CustomWidgets.textField(hintText: "From Date",controller: Date,readOnly: true,suffixIcon: InkWell(onTap: () => CustomWidgets.selectDate(context: context, controller: Date),child: CustomWidgets.DateIcon())),
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
                                                      Expanded(child:CustomWidgets.confirmButton(onTap: () {
                                                        Navigator.pop(context);
                                                      },height:  40,width:  170,text:  "Cancel",Clr: Colors.redAccent)),
                                                      CustomWidgets.width(5),
                                                      Expanded(child:  CustomWidgets.confirmButton(onTap: () async {
                                                        Map data={
                                                          "id" : e['_id'],
                                                          "name" : PoliciesName.text,
                                                          "departmentId" : Con_List.DeparmenntSelect.firstWhere((element) => element['name']==DeparmentName.text)['_id'].toString(),
                                                          "description" : Description.text,
                                                          "createDate" : Date.text,
                                                          "isActive" : isActive.toString(),
                                                        };
                                                        if(await CustomWidgets.CheakConnectionInternetButton())
                                                        {
                                                          if(await Policies_api.PoliciesUpdate(data)){
                                                            getdata();
                                                            setState(() {
                                                            });
                                                            CustomWidgets.showToast(context, "Deparment Update Successfully",true);
                                                            Navigator.pop(context);
                                                          }else{
                                                            Navigator.pop(context);
                                                          }
                                                        }else{
                                                          Navigator.pop(context);
                                                          CustomWidgets.showToast(context, "No Internet Connection", false);
                                                        }

                                                      },height: 40,width:  170,text:  "Update")),
                                                    ],)
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
                              )) :Container(),
                          Con_List.Drawer.where((element) => element['name']=='Policies' && element['delate']==true).isNotEmpty ?
                          InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                          title: Center(child: Text("Do you want to delete this entry ?",style: TextStyle(color: Colorr.themcolor),)),
                                          content:Row(
                                            children: [
                                              Expanded(child:CustomWidgets.confirmButton(onTap: () {
                                                Navigator.pop(context);
                                              },height: 40,width: 170,text:  "Cancel",Clr: Colors.redAccent)),
                                              CustomWidgets.width(5),
                                              Expanded(child:  CustomWidgets.confirmButton(onTap: () async {
                                                if(await CustomWidgets.CheakConnectionInternetButton())
                                                {
                                                  if(await Policies_api.PoliciesDelete(e['_id'])){
                                                    getdata();
                                                    setState(() {
                                                    });
                                                    CustomWidgets.showToast(context, "Deparment Deleted Successfully",true);
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
                              },
                              child: Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                                size: 22,
                              )) : Container(),
                        ],
                      )),
                      DataCell(Text(index.toString())),
                      DataCell(Text(e['name'])),
                      DataCell(Text(e['departmentId']['name'])),
                      DataCell(Container(width: 100,child: Text(e['description'].toString()))),
                      DataCell(Text(CustomWidgets.DateFormatchange(e['createDate'].toString()))),
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
              : Container()): CustomWidgets.NoDataImage(context);
    } else if (internetConn == 2) {
      return CustomWidgets.NoInternetImage(context);
    } else {
      return CustomWidgets.Circularprogress(context);
    }
  }
}
