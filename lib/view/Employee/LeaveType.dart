import 'package:attendy/A_SQL_Trigger/Con_Usermast.dart';
import 'package:attendy/A_SQL_Trigger/Leave_Type_api.dart';
import 'package:attendy/A_SQL_Trigger/Leave_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../A_SQL_Trigger/Con_List.dart';
import '../../utils/Constant/Colors.dart';
import '../../utils/Constant/LocalCustomWidgets.dart';
import '../Dashboard/Dashboard.dart';

class LeaveType extends StatefulWidget {
  const LeaveType({Key? key}) : super(key: key);

  @override
  State<LeaveType> createState() => _LeaveTypeState();
}

class _LeaveTypeState extends State<LeaveType> {
  int internetConn=0;
  double height=0;
  double width=0;
  TextEditingController Leavetype=TextEditingController();
  TextEditingController ord=TextEditingController();
  bool isActive=false;
  bool Update=false;
  String UpdateId="";
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
    Con_List.LeaveType=await Leave_Type_api.Leave_TypeSelect();
    Con_List.Leave =await Leave_api.LeaveSelect();
    setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {
    height= MediaQuery.of(context).size.height-kToolbarHeight;
    width= MediaQuery.of(context).size.width;
    Future<bool> onBackPress() {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return Dashboard();
      },));
      return Future.value(false);
    }
    return WillPopScope(
        onWillPop: () => onBackPress(),
    child: Constants_Usermast.IOS==true ?  CupertinoPageScaffold(
        navigationBar: CustomWidgets.appbarIOS(title: "Leave Type", action: [], context: context, onTap: () {
          Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) {
            return Dashboard();
          },));
        },),
        child: Container(
          height: height,
          width:width,
          child: Column(
            children: [
              Con_List.Drawer.where((element) => element['subname']=='Leave Type' && element['insert']==true).isNotEmpty ?
              Container(
                width: double.infinity,
                height:height/3.5, padding: const EdgeInsets.only(left: 5,right: 5,top: 10,bottom: 10),
                decoration:  BoxDecoration(color: Colorr.White, boxShadow: [
                  BoxShadow(
                    color: Colorr.themcolor100,
                    blurStyle: BlurStyle.outer,
                    blurRadius: 8,
                  ),
                ]),
                child: Column(
                  children: [
                    CustomWidgets.width(30),
                    CustomWidgets.textFieldIOS(hintText: "Add Leave Type",controller: Leavetype),
                    CustomWidgets.textFieldIOS(hintText: "Order",controller: ord,keyboardType: TextInputType.number),
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
                    Row(
                      children: [
                        Expanded(flex: 2,child: SizedBox(width: 5)),
                        Expanded(flex: 2,
                          child: CupertinoButton(
                            color: Colorr.Reset,
                            padding:EdgeInsets.zero,
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              Leavetype.text="";
                              isActive=false;
                              ord.text="";
                              UpdateId="";
                              Update=false;
                              setState(() {
                              });
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
                              if(Leavetype.text.trim().isEmpty)
                              {
                                CustomWidgets.showToast(context, "Leave Type is required",false);
                              }else if(ord.text.trim().isEmpty)
                              {
                                CustomWidgets.showToast(context, "Ord is required",false);
                              }else{
                                if (Update==false)
                                {
                                  if(await Leave_Type_api.Leave_Typeadd(Leavetype.text,ord.text, isActive)){
                                    getdata();
                                    Leavetype.text="";
                                    ord.text="";
                                    setState(() {
                                    });
                                    isActive=false;
                                    CustomWidgets.showToast(context, "Leave Type Add Successfully",true);
                                  }else{
                                    CustomWidgets.showToast(context, "Leave Type Not Add",false);
                                  }
                                }else{
                                  if(await Leave_Type_api.Leave_TypeUpdate(UpdateId,Leavetype.text,ord.text,isActive)){
                                    getdata();
                                    Leavetype.text="";
                                    isActive=false;
                                    ord.text="";
                                    Update=false;
                                    UpdateId="";
                                    CustomWidgets.showToast(context, "LeaveType Update Successfully",true);
                                  }else{
                                    Leavetype.text="";
                                    isActive=false;
                                    Update=false;
                                    UpdateId="";
                                    CustomWidgets.showToast(context, "LeaveType Not Updated",true);
                                  }
                                }

                              }
                              FocusScope.of(context).unfocus();
                            },
                            child: Text( Update ?'Update' : 'Save'),
                          ),
                        ),
                        
                        SizedBox(width: 5),
                      ],
                    ),

                    CustomWidgets.width(20),
                  ],
                ),
              ) : Container(),
              Expanded(
                child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(left: 5,right: 5),
                    margin: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(color: Colorr.White, boxShadow: [
                      BoxShadow(
                        color: Colorr.themcolor100,
                        blurStyle: BlurStyle.outer,
                        blurRadius: 8,
                      ),
                    ]),
                    child: Con_List.LeaveType.isNotEmpty
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
                                label: Text('Leave Type'),
                              ),
                              DataColumn(
                                label: Text('Order'),
                              ),
                              DataColumn(
                                label: Text('Status'),
                              ),

                            ],
                            rows: Con_List.LeaveType.asMap().entries.map((entry) {
                              int index = entry.key + 1;
                              final e = entry.value;
                              return DataRow(cells: [
                                DataCell(Row(
                                  children: [
                                    Con_List.Drawer.where((element) => element['subname']=='Leave Type' && element['update']==true).isNotEmpty ?
                                    InkWell(
                                        onTap: () {
                                          Leavetype.text=e['name'].toString();
                                          isActive =e['isActive'];
                                          ord.text=e['ord'].toString();
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
                                    Con_List.Drawer.where((element) => element['subname']=='Leave Type' && element['delate']==true).isNotEmpty ?
                                    InkWell(
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
                                                              if(await Leave_Type_api.Leave_TypeDelete(e['_id'])){
                                                                getdata();
                                                                Navigator.pop(context);
                                                                CustomWidgets.showToast(context, "Leave type deleted sucessfully",true);
                                                              }else{
                                                                Navigator.pop(context);
                                                                CustomWidgets.showToast(context, "Leavetype Not Deleted",true);
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
                                          color: Colorr.Reset,
                                          size: 22,
                                        )) : Container(),
                                  ],
                                )),
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

                              ]);
                            }).toList()),
                      ),
                    )
                        : Container()),
              ),
            ],
          ),
        )) :
    Scaffold(
      appBar: CustomWidgets.appbar(title: "Leave Type",action:  [
      ],context:  context,onTap: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return Dashboard();
        },));
      },),
      body: Container(
        height: height,
        width:width,
        child: Column(
          children: [
            Con_List.Drawer.where((element) => element['subname']=='Leave Type' && element['insert']==true).isNotEmpty ?
            Container(
              width: double.infinity,
              height:height/3.5, padding: const EdgeInsets.only(left: 5,right: 5,top: 10,bottom: 10),
              decoration:  BoxDecoration(color: Colorr.White, boxShadow: [
                BoxShadow(
                  color: Colorr.themcolor100,
                  blurStyle: BlurStyle.outer,
                  blurRadius: 8,
                ),
              ]),
              child: Column(
                children: [
                  CustomWidgets.width(30),
                  CustomWidgets.textField(hintText: "Add Leave Type",controller: Leavetype),
                  CustomWidgets.textField(hintText: "Order",controller: ord,keyboardType: TextInputType.number),
                  Row(
                    children: [
                      Checkbox(
                        shape: CircleBorder(),
                        value: isActive,
                        activeColor: Colorr.themcolor,
                        onChanged: (value) {
                          isActive=value!;
                          setState(() {
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
                  Row(mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomWidgets.confirmButton(onTap:() {
                          Leavetype.text="";
                          isActive=false;
                          ord.text="";
                          UpdateId="";
                          Update=false;
                          setState(() {
                          });
                          FocusScope.of(context).unfocus();
                        }, height: height/20, width: width/2.7, text: "Reset",Clr: Colorr.Reset),
                        CustomWidgets.width(5),
                        CustomWidgets.confirmButton(onTap:() async {
                          FocusScope.of(context).unfocus();
                          if(await CustomWidgets.CheakConnectionInternetButton())
                          {
                            if(Leavetype.text.trim().isEmpty)
                            {
                              CustomWidgets.showToast(context, "Leave Type is required",false);
                            }else if(ord.text.trim().isEmpty)
                            {
                              CustomWidgets.showToast(context, "Ord is required",false);
                            }else{
                              if (Update==false)
                              {
                                if(await Leave_Type_api.Leave_Typeadd(Leavetype.text,ord.text, isActive)){
                                  getdata();
                                  Leavetype.text="";
                                  ord.text="";
                                  setState(() {
                                  });
                                  isActive=false;
                                  CustomWidgets.showToast(context, "Leave Type Add Successfully",true);
                                }else{
                                  CustomWidgets.showToast(context, "Leave Type Not Add",false);
                                }
                              }else{
                                if(await Leave_Type_api.Leave_TypeUpdate(UpdateId,Leavetype.text,ord.text,isActive)){
                                  getdata();
                                  Leavetype.text="";
                                  isActive=false;
                                  ord.text="";
                                  Update=false;
                                  UpdateId="";
                                  CustomWidgets.showToast(context, "LeaveType Update Successfully",true);
                                }else{
                                  Leavetype.text="";
                                  isActive=false;
                                  Update=false;
                                  UpdateId="";
                                  CustomWidgets.showToast(context, "LeaveType Not Updated",true);
                                }
                              }
                            }
                          }else{
                            CustomWidgets.showToast(context, "No Internet Connection", false);
                          }

                        }, height: height/20, width: width/2.7, text:Update ? "Update": "Save",),
                      ]),
                  CustomWidgets.width(20),
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
      return Con_List.LeaveType.isNotEmpty ?Container(
          width: double.infinity,
          padding: EdgeInsets.only(left: 5,right: 5),
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(color: Colorr.White, boxShadow: [
            BoxShadow(
              color: Colorr.themcolor100,
              blurStyle: BlurStyle.outer,
              blurRadius: 8,
            ),
          ]),
          child: Con_List.LeaveType.isNotEmpty
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
                      label: Text('Leave Type'),
                    ),
                    DataColumn(
                      label: Text("Order"),
                    ),
                    DataColumn(
                      label: Text('Status'),
                    ),

                  ],
                  rows: Con_List.LeaveType.asMap().entries.map((entry) {
                    int index = entry.key + 1;
                    final e = entry.value;
                    return DataRow(cells: [
                      DataCell(Row(
                        children: [
                          Con_List.Drawer.where((element) => element['subname']=='Leave Type' && element['update']==true).isNotEmpty ?
                          InkWell(
                              onTap: () {
                                Leavetype.text=e['name'].toString();
                                isActive =e['isActive'];
                                ord.text=e['ord'].toString();
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
                          Con_List.Drawer.where((element) => element['subname']=='Leave Type' && element['delate']==true).isNotEmpty ?
                          InkWell(
                              onTap: () {
                                if(Con_List.Leave.where((element) => element['leaveId'].toString()==e['_id'].toString()).isNotEmpty){
                                  CustomWidgets.showToast(context,"Leave type use in leave",false);
                                }else{
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                            title: Center(child: Text("Do you want to delete this leave type ? ",style: TextStyle(color: Colorr.themcolor),)),
                                            content:Row(
                                              children: [
                                                Expanded(child:CustomWidgets.confirmButton(onTap: () {
                                                  Navigator.pop(context);
                                                },height:height/20,width:width/3,text:  "Cancel",Clr: Colorr.Reset)),
                                                CustomWidgets.width(5),
                                                Expanded(child:  CustomWidgets.confirmButton(onTap: () async {
                                                  if(await CustomWidgets.CheakConnectionInternetButton())
                                                  {
                                                    if(await Leave_Type_api.Leave_TypeDelete(e['_id'])){
                                                      getdata();
                                                      Navigator.pop(context);
                                                      CustomWidgets.showToast(context, "Leave type deleted sucessfully",true);
                                                    }else{
                                                      Navigator.pop(context);
                                                      CustomWidgets.showToast(context, "Leavetype Not Deleted",true);
                                                    }
                                                  }else{
                                                    Navigator.pop(context);
                                                    CustomWidgets.showToast(context, "No Internet Connection", false);
                                                  }
                                                },height:height/20,width:width/3,text:  "Delete")),
                                              ],)
                                        );
                                      });
                                }
                              },
                              child: Icon(
                                Icons.delete,
                                color: Colorr.Reset,
                                size: 22,
                              )) :Container(),
                        ],
                      )),
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
