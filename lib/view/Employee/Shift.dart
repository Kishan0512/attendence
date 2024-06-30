import 'package:attendy/A_SQL_Trigger/Con_Usermast.dart';
import 'package:attendy/A_SQL_Trigger/Shift_Add_api.dart';
import 'package:attendy/utils/Constant/Con_icon.dart';
import 'package:attendy/utils/Constant/LocalCustomWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../A_SQL_Trigger/Con_List.dart';
import '../../A_SQL_Trigger/Shift_typee_add_api.dart';
import '../../utils/Constant/Colors.dart';
import '../../utils/DroupDown/custom_dropdown.dart';
import '../Dashboard/Dashboard.dart';
import 'AddShift.dart';

class Shift extends StatefulWidget {
  const Shift({Key? key}) : super(key: key);

  @override
  State<Shift> createState() => _ShiftState();
}

class _ShiftState extends State<Shift> {
  TextEditingController SelectShifttypee=TextEditingController();
  int internetConn=0;
  double height=0;
  double width=0;
  List<String> ShiftTypee=[];
  List<dynamic> Temp_Shift=[];
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
    Con_List.shift_typeetSelect.forEach((element) {
      if(element['isActive']==true)
        {
          ShiftTypee.add(element['name']);
        }

    });
    Con_List.Allshift_Select = await Shift_Add_api.shift_Select();
    Temp_Shift = Con_List.Allshift_Select;
    setState(() {
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
        navigationBar: CustomWidgets.appbarIOS(title: "Shift", action: [
          Con_List.Drawer.where((element) => element['subname']=='Shift' && element['insert']==true).isNotEmpty ?
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: Icon(Icons.add, color: Colorr.White),
            onPressed: () {
              Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) {
                return AddShift();
              },));
            },
          ) : Container()
        ], context: context, onTap: () {
          Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) {
            return Dashboard();
          },));
        },),
        child: Column(
          children: [
            CustomWidgets.height(10),
            CustomWidgets.textFieldIOS(hintText: "Select Shift Type",controller: SelectShifttypee,readOnly: true,onTap: () {
              CustomWidgets.SelectDroupDown(context: context,items: ShiftTypee, onSelectedItemChanged: (int ) async {
                SelectShifttypee.text=ShiftTypee[int];
                if (Con_List.shift_typeetSelect.where((element) => SelectShifttypee.text == element['name']).isNotEmpty) {
                  Con_List.Allshift_Select = await Shift_Add_api.shift_Select();
                  FocusScope.of(context).unfocus();
                  setState(() {
                  });
                }
                setState(() {
                });
              });
            },suffix: CustomWidgets.aarowCupertinobutton(),
            ),
            Expanded(
              child: Container(
                width:double.infinity,
                child: Con_List.Allshift_Select.isNotEmpty
                    ?  SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                        columns: [
                          DataColumn(
                            label: Text('No'),
                          ),
                          DataColumn(
                            label: Text('Shift Type'),
                          ),  DataColumn(
                            label: Text('Date'),
                          ),
                          DataColumn(
                            label: Text('In Time'),
                          ),
                          DataColumn(
                            label: Text('Out Time'),
                          ),
                          DataColumn(
                            label: Text('Full Day Working Hours'),
                          ),
                          DataColumn(
                            label: Text('Half Day Working Hours'),
                          ),
                          DataColumn(
                            label: Text('Break Time'),
                          ),
                          DataColumn(
                            label: Text('Active'),
                          ),
                          DataColumn(
                            label: Text('Action'),
                          ),
                        ],
                        rows: Con_List.Allshift_Select.asMap().entries.map((entry) {
                          int index = entry.key + 1;
                          final e = entry.value;
                          return DataRow(cells: [
                            DataCell(Text(index.toString())),
                            DataCell(Text((Con_List.shift_typeetSelect.firstWhere(
                                  (element) => element['_id'] == e['shiftId'],
                              orElse: () => null,
                            )?['name']?.toString() ?? ''))),
                            DataCell(Text(CustomWidgets.DateFormatchange(e['date']))),
                            DataCell(Text(e['inTime'].toString())),
                            DataCell(Text(e['outTime'].toString())),
                            DataCell(Text(e['fullHours'].toString())),
                            DataCell(Text(e['halfHours'].toString())),
                            DataCell(Text(e['breakTime'].toString())),
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
                                Con_List.Drawer.where((element) => element['subname']=='Shift' && element['update']==true).isNotEmpty ?
                                GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, CupertinoPageRoute(builder: (context) {
                                        return AddShift(e: e);
                                      },));
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      color: Colorr.themcolor,
                                      size: 22,
                                    )) :  Container(),
                                Con_List.Drawer.where((element) => element['subname']=='Shift' && element['delate']==true).isNotEmpty ?
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
                                                          if(await Shift_Add_api.shift_Delete(e['_id'])){
                                                            Con_List.Allshift_Select = await Shift_Add_api.shift_Select();
                                                            CustomWidgets.showToast(context, "Shift Type Deleted Successfully",true);
                                                            setState(() {
                                                            });
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
                                                  "Do you want to delete this Shift?",
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
                  ),
                ) :Container(),
              ),
            )
          ],
        )):Scaffold(
      appBar: CustomWidgets.appbar(title: "Shift",action:  [

        IconButton(splashRadius: 18,onPressed:() {
          getdata();
          SelectShifttypee.text="";
        },icon: Con_icon.Refresh,) ,
        Con_List.Drawer.where((element) => element['subname']=='Shift' && element['insert']==true).isNotEmpty ?
        IconButton(splashRadius: 18,onPressed:() {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddShift();
          },));
        },icon: Con_icon.AddNew,) : Container()
      ],context:  context,onTap: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return Dashboard();
        },));
      },),
      body: Column(
        children: [
          CustomWidgets.height(10),
          CustomDropdown.search(listItemStyle: CustomWidgets.style(),
            hintText: 'Select Shift Type',
            controller: SelectShifttypee,
            items: Con_List.shift_typeetSelect.where((element) => element['isActive']==true).map((e) => e['name'].toString()).toList(),
            onChanged: (value) async {
              Con_List.Allshift_Select = Temp_Shift.where((element) => element['shiftId']['name'].toString()==value.toString()).toList();
              FocusScope.of(context).unfocus();
              setState(() {});
            },
          ),
          Expanded(
            child: mainwidget(),
          )
        ],
      ),
    ));
  }
  Widget mainwidget() {
    if (internetConn == 1) {
      return Con_List.Allshift_Select.isNotEmpty ?Container(
        width:double.infinity,
        child: Con_List.Allshift_Select.isNotEmpty
            ?  SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
                columns: [
                  DataColumn(
                    label: Text('No'),
                  ),
                  DataColumn(
                    label: Text('Shift Name'),
                  ),
                  DataColumn(
                    label: Text('Shift Type'),
                  ),  DataColumn(
                    label: Text('Date'),
                  ),
                  DataColumn(
                    label: Text('In Time'),
                  ),
                  DataColumn(
                    label: Text('Out Time'),
                  ),
                  DataColumn(
                    label: Text('Full Day Working'),
                  ),
                  DataColumn(
                    label: Text('Half Day Working'),
                  ),
                  DataColumn(
                    label: Text('Break Time(Min.)'),
                  ),
                  DataColumn(
                    label: Text('Active'),
                  ),
                  DataColumn(
                    label: Text('Action'),
                  ),
                ],
                rows: Con_List.Allshift_Select.asMap().entries.map((entry) {
                  int index = entry.key + 1;
                  final e = entry.value;
                  DateTime inTime=DateTime.parse(e['inTime']).toLocal();
                  var In=DateFormat("hh:mm a").format(inTime) ;
                  DateTime outTime=DateTime.parse(e['outTime']).toLocal();
                  var Out=DateFormat("hh:mm a").format(outTime);
                  return DataRow(cells: [
                    DataCell(Text(index.toString())),
                    DataCell(Text(e['name'])),
                    DataCell(Text(e['shiftId']['name'])),
                    DataCell(Text(CustomWidgets.DateFormatchange(e['date'].toString()))),
                    DataCell(Text(In)),
                    DataCell(Text(Out)),
                    DataCell(Text(e['fullHours'].toString())),
                    DataCell(Text(e['halfHours'].toString())),
                    DataCell(Text(e['breakTime'].toString())),
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
                        Con_List.Drawer.where((element) => element['subname']=='Shift' && element['update']==true).isNotEmpty ?
                        InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return AddShift(e: e);
                              },));
                            },
                            child: Icon(
                              Icons.edit,
                              color: Colorr.themcolor,
                              size: 22,
                            )) : Container(),
                        Con_List.Drawer.where((element) => element['subname']=='Shift' && element['delate']==true).isNotEmpty ?
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
                                            },height:  height/20,width:  width/3,text:  "Cancel",Clr: Colors.redAccent)),
                                            CustomWidgets.width(5),
                                            Expanded(child:  CustomWidgets.confirmButton(onTap: () async {
                                              if(await CustomWidgets.CheakConnectionInternetButton())
                                              {
                                                if(await Shift_Add_api.shift_Delete(e['_id'])){
                                                  // Con_List.Allshift_Select = await Shift_Add_api.shift_Select(Con_List.shift_typeetSelect.firstWhere((e) => e['name'] == SelectShifttypee.text)['_id'].toString());
                                                  CustomWidgets.showToast(context, "Shift Type Deleted Successfully",true);
                                                  getdata();
                                                  setState(() {
                                                  });
                                                  Navigator.pop(context);
                                                }else{
                                                  Navigator.pop(context);
                                                }
                                              }else{
                                                Navigator.pop(context);
                                                CustomWidgets.showToast(context, "No Internet Connection", false);
                                              }
                                            },height: height/20,width: width/3,text:  "Delete")),
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
                  ]);
                }).toList()),
          ),
        ) :Container(),
      ) : CustomWidgets.NoDataImage(context);
    } else if (internetConn == 2) {
      return CustomWidgets.NoInternetImage(context);
    } else {
      return CustomWidgets.Circularprogress(context);
    }
  }
}
