import 'package:attendy/utils/Constant/Colors.dart';
import 'package:attendy/utils/Constant/FontWeight.dart';
import 'package:attendy/utils/Constant/LocalCustomWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../A_SQL_Trigger/Con_List.dart';
import '../../A_SQL_Trigger/Con_Usermast.dart';
import '../../A_SQL_Trigger/Deparment_api_page.dart';
import '../../A_SQL_Trigger/Designations_api.dart';
import '../../A_SQL_Trigger/Employee_Add_api.dart';
import '../../utils/DroupDown/custom_dropdown.dart';
import '../Dashboard/Dashboard.dart';
import 'AddDesignation.dart';

class Designation extends StatefulWidget {
  const Designation({Key? key}) : super(key: key);

  @override
  State<Designation> createState() => _DesignationState();
}

class _DesignationState extends State<Designation> {
  List<String> DeparmentSelected = [];
  List<dynamic> DesigFilter=[];
  int internetConn=0;
  bool isActive = false;
  bool Update = false;
  FocusNode _textFieldFocusNode = FocusNode();
  String UpdateId = "";
  TextEditingController Select = TextEditingController();
  TextEditingController DesignationName = TextEditingController();
  TextEditingController DeparmentSelect = TextEditingController();
  TextEditingController Designation = TextEditingController();
  TextEditingController Orderby = TextEditingController();
  double height = 0;
  double width = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetDeparment();
    CheakInternet();
  }
  CheakInternet()
  async {
    internetConn = await CustomWidgets.CheakConnectionInternet();
    setState(() {
    });
  }
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _textFieldFocusNode.dispose();
  }

  GetDeparment() async {
    Con_List.DeparmenntSelect = await Deparmentapi.DeparmentSelect();
    DeparmentSelected=[];
    Con_List.DeparmenntSelect.forEach((element) {
      if(element['isActive']==true) {
        DeparmentSelected.add(element['name']);
      }
    });
    Con_List.AllDesignation = await Designations_api.DesignationsSelect("All");
    DesigFilter = Con_List.AllDesignation;
    Con_List.AllEmployee=await AllEmployee_api.EmployeeSelect();
    setState(() {});
  }

  GetData(String DeparmentId) async {
    Con_List.DesignationSelect =
    await Designations_api.DesignationsSelect(DeparmentId);
    setState(() {});
  }

  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height - kToolbarHeight;
    width = MediaQuery.of(context).size.width;
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
        child: Constants_Usermast.IOS==true ? CupertinoPageScaffold(
            navigationBar: CustomWidgets.appbarIOS(title: "Designation", action: [], context: context, onTap: () {
              Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) {
                return Dashboard();
              },));
            },),
            child: Container(
              height: height,
              width: width,
              child: Column(
                children: [
                  Con_List.Drawer.where((element) => element['subname']=='Designation' && element['insert']==true).isNotEmpty ?
                  Container(
                    width: double.infinity,
                    height: height / 2.6,
                    padding: const EdgeInsets.only(
                        left: 5, right: 5, top: 10, bottom: 10),
                    decoration: BoxDecoration(color: Colorr.White, boxShadow: [
                      BoxShadow(
                        color: Colorr.themcolor100,
                        blurStyle: BlurStyle.outer,
                        blurRadius: 8,
                      ),
                    ]),
                    child: Column(
                      children: [
                        CustomWidgets.height(10),
                        CustomWidgets.textFieldIOS(hintText: "Select Department",controller: DeparmentSelect,readOnly: true,onTap: () {
                          CustomWidgets.SelectDroupDown(context: context,items: DeparmentSelected, onSelectedItemChanged: (int ) async {
                            DeparmentSelect.text=DeparmentSelected[int];
                            setState(() {
                            });
                          });
                        },suffix: CustomWidgets.aarowCupertinobutton(),
                        ),
                        CustomWidgets.textFieldIOS(
                            hintText: "Designation", controller: Designation),
                        CustomWidgets.textFieldIOS(
                            hintText: "Order",
                            controller: Orderby,
                            keyboardType: TextInputType.number),
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
                        CustomWidgets.height(10),
                        Row(
                          children: [
                            Expanded(flex: 2,child: SizedBox(width: 5)),
                            Expanded(flex: 2,
                              child: CupertinoButton(
                                color: Colorr.Reset,
                                padding:EdgeInsets.zero,
                                onPressed: ()  {
                                  GetDeparment();
                                  Select.text="";
                                  DeparmentSelect.text = "";
                                  Designation.text = "";
                                  Orderby.text = "";
                                  isActive = false;
                                  Update = false;
                                  UpdateId = "";
                                  FocusScope.of(context).unfocus();
                                  setState(() {});
                                },
                                child: Text('Reset'),
                              ),
                            ),
                            SizedBox(width: 5),
                            Expanded(flex: 2,
                              child: CupertinoButton(
                                color: Colorr.themcolor,
                                padding:EdgeInsets.zero,
                                onPressed: () async {
                                  FocusScope.of(context).unfocus();
                                  if (Update == false) {
                                    if(await CustomWidgets.CheakConnectionInternetButton())
                                    {
                                      saveButtton("Save");
                                    }else{
                                      CustomWidgets.showToast(context, "No Internet Connection", false);
                                    }
                                  } else if (Update == true) {
                                    if(await CustomWidgets.CheakConnectionInternetButton())
                                    {
                                      String Deparment = Con_List.DeparmenntSelect.firstWhere(
                                              (e) => e['name'] == DeparmentSelect.text)['_id']
                                          .toString();
                                      if (DeparmentSelect.text.trim().isEmpty) {
                                        CustomWidgets.showToast(context,
                                            "Department name is required", false);
                                      } else if (Designation.text.trim().isEmpty) {
                                        CustomWidgets.showToast(context,
                                            "Designation name is required", false);
                                      } else if (Con_List.DeparmenntSelect.where(
                                              (e) =>
                                          e['name'] == DeparmentSelect.text)
                                          .isEmpty) {
                                        CustomWidgets.showToast(context,
                                            "Enter Valid Department Name", false);
                                      } else if (Orderby.text.trim().isEmpty) {
                                        CustomWidgets.showToast(
                                            context, "Ord is required", false);
                                      } else if (await Designations_api
                                          .DesignationsUpdate(
                                          Deparment,
                                          UpdateId,
                                          Designation.text,
                                          Orderby.text,
                                          isActive)) {
                                        if (Select.text.isEmpty) {
                                          GetDeparment();
                                        } else if (Select.text.isNotEmpty) {
                                          Con_List.AllDesignation =
                                          await Designations_api
                                              .DesignationsSelect(
                                              Con_List.DeparmenntSelect
                                                  .firstWhere((e) =>
                                              e['name'] ==
                                                  Select.text)['_id']
                                                  .toString());
                                        }
                                        DeparmentSelect.text = "";
                                        Designation.text = "";
                                        Orderby.text = "";
                                        isActive = false;
                                        Update = false;
                                        UpdateId = "";
                                        setState(() {});
                                        CustomWidgets.showToast(context,
                                            "Department Update Successfully", true);
                                      }
                                    }else{
                                      CustomWidgets.showToast(context, "No Internet Connection", false);
                                    }

                                  }
                                },
                                child: Text(Update ? "Update" : "Save"),
                              ),
                            ),

                            SizedBox(width: 5),
                          ],
                        ),
                      ],
                    ),
                  ) : Container(),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(left: 5, right: 5),
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(color: Colorr.White, boxShadow: [
                        BoxShadow(
                          color: Colorr.themcolor100,
                          blurStyle: BlurStyle.outer,
                          blurRadius: 8,
                        ),
                      ]),
                      child: Column(
                        children: [
                          CustomWidgets.height(10),
                          CustomWidgets.textFieldIOS(hintText: "Select Department",controller: Select,readOnly: true,onTap: () {
                            CustomWidgets.SelectDroupDown(context: context,items: DeparmentSelected, onSelectedItemChanged: (int ) async {
                              Select.text=DeparmentSelected[int];
                              if (Con_List.DeparmenntSelect.where(
                                      (element) => Select.text == element['name'])
                                  .isNotEmpty) {
                                Con_List.AllDesignation =
                                await Designations_api.DesignationsSelect(
                                    Con_List.DeparmenntSelect.firstWhere(
                                            (e) =>
                                        e['name'] ==
                                            Select.text)['_id']
                                        .toString());
                                FocusScope.of(context).unfocus();
                                setState(() {});
                              }
                              setState(() {
                              });
                            });
                          },suffix: CustomWidgets.aarowCupertinobutton(),
                          ),
                          Expanded(
                            child: Container(
                                width: double.infinity,
                                child: Con_List.AllDesignation.isNotEmpty
                                    ? SingleChildScrollView(
                                      child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                        columns: [
                                          DataColumn(
                                            label: Text('No.'),
                                          ), DataColumn(
                                            label: Text('Designation'),
                                          ),DataColumn(
                                            label: Text('Department'),
                                          ),
                                          DataColumn(
                                            label: Text('Active'),
                                          ),
                                          DataColumn(
                                            label: Text('Action'),
                                          ),
                                        ],
                                        rows:
                                        Con_List.AllDesignation.asMap().entries.map((entry) {
                                          int index = entry.key + 1;
                                          final e = entry.value;
                                          return DataRow(cells: [
                                            DataCell(Text(index.toString())),
                                            DataCell(Text(e['name']!)),
                                            DataCell(Text(Con_List.DeparmenntSelect
                                                .firstWhere((element) => element['_id'] == e['deparmentId'], orElse: () => {'name': ''})['name'].toString())),
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
                                                Con_List.Drawer.where((element) => element['subname']=='Designations' && element['update']==true).isNotEmpty ?
                                                InkWell(
                                                    onTap: () {
                                                      Designation.text =
                                                      e['name'];
                                                      isActive = e['isActive'];
                                                      Orderby.text =
                                                          e['ord'].toString();
                                                      DeparmentSelect.text = Con_List.DeparmenntSelect.isEmpty
                                                          ? ""
                                                          : Con_List.LeaveType.firstWhere(
                                                              (element) => element['_id'] == e['deparmentId'],
                                                          orElse: () => {'name': ''}
                                                      )['name'].toString();
                                                      Update = true;
                                                      UpdateId =
                                                          e['_id'].toString();
                                                      setState(() {

                                                      });
                                                    },
                                                    child: Icon(
                                                      Icons.edit,
                                                      color: Colorr.themcolor,
                                                      size: 22,
                                                    )) : Container(),
                                                Con_List.Drawer.where((element) => element['subname']=='Designations' && element['delate']==true).isNotEmpty ?
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
                                                                          if(await CustomWidgets.CheakConnectionInternetButton())
                                                                          {
                                                                            if (await Designations_api.DesignationsDelete(e['_id'])) {
                                                                              if (Select.text.isEmpty) {
                                                                                GetDeparment();
                                                                              } else if (Select.text.isNotEmpty) {
                                                                                Con_List.AllDesignation = await Designations_api.DesignationsSelect(Con_List.DeparmenntSelect.firstWhere((e) => e['name'] == Select.text)['_id'].toString());
                                                                              }
                                                                              setState(() {});
                                                                              CustomWidgets.showToast(context, "Designation Deleted Successfully", true);
                                                                              Navigator.pop(context);
                                                                            } else {
                                                                              Navigator.pop(context);
                                                                            }
                                                                          }else{
                                                                            CustomWidgets.showToast(context, "No Internet Connection", false);
                                                                          }
                                                                        },
                                                                        child: Text("Delete"),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                                title: Text(
                                                                  "Do you want to delete this Designation ?",
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
                                          ]);
                                        }).toList()),
                                ),
                                    )
                                    : Container()),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ):Scaffold(
          appBar: CustomWidgets.appbar(
            title: "Designation",
            action: [],
            context: context,
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) {
                  return Dashboard();
                },
              ));
            },
          ),
          body: Container(
            height: height,
            width: width,
            child: Column(
              children: [
                Con_List.Drawer.where((element) => element['subname']=='Designations' && element['insert']==true).isNotEmpty ?
                Container(
                  width: double.infinity,
                  height: height / 2.6,
                  padding: const EdgeInsets.only(
                      left: 5, right: 5, top: 10, bottom: 10),
                  decoration: BoxDecoration(color: Colorr.White, boxShadow: [
                    BoxShadow(
                      color: Colorr.themcolor100,
                      blurStyle: BlurStyle.outer,
                      blurRadius: 8,
                    ),
                  ]),
                  child: Column(
                    children: [
                      CustomWidgets.height(10),
                      CustomDropdown.search(
                        listItemStyle: CustomWidgets.style(),
                        hintText: 'Select Department',
                        controller: DeparmentSelect,
                        items: DeparmentSelected,
                      ),
                      CustomWidgets.textField(
                          focus: _textFieldFocusNode,
                          hintText: "Designation", controller: Designation),

                      CustomWidgets.textField(
                          hintText: "Order",
                          controller: Orderby,
                          keyboardType: TextInputType.number),
                      Row(
                        children: [
                          Checkbox(
                            shape: CircleBorder(),
                            value: isActive,
                            activeColor: Colorr.themcolor,
                            onChanged: (value) {
                              isActive = value!;
                              setState(() {});
                            },
                          ),
                          Text(
                            "Active",
                            style: TextStyle(
                                fontSize: 13, color: Colorr.themcolor),
                          ),
                        ],
                      ),
                      CustomWidgets.height(10),
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        CustomWidgets.confirmButton(
                            onTap: () {
                              GetDeparment();
                              DeparmentSelect.text = "";
                              Designation.text = "";
                              Orderby.text = "";
                              Select.text ="";
                              isActive = false;
                              Update = false;
                              UpdateId = "";
                              FocusScope.of(context).unfocus();
                              FocusScope.of(context).requestFocus(_textFieldFocusNode);
                              setState(() {});
                            },
                            height: height / 20,
                            width: width / 3,
                            text: "Reset",
                            Clr: Colorr.Reset),
                        CustomWidgets.width(5),
                        CustomWidgets.confirmButton(onTap: () async {
                              FocusScope.of(context).unfocus();
                              if (Update == false) {
                                if(await CustomWidgets.CheakConnectionInternetButton())
                                {
                                  saveButtton("Save");
                                }else{
                                  CustomWidgets.showToast(context, "No Internet Connection", false);
                                }
                              } else if (Update == true) {
                                if(await CustomWidgets.CheakConnectionInternetButton())
                                {
                                  String Deparment = Con_List.DeparmenntSelect.firstWhere(
                              (e) => e['name'] == DeparmentSelect.text)['_id']
                                  .toString();
                                  if (DeparmentSelect.text.trim().isEmpty) {
                                    CustomWidgets.showToast(context,
                                        "Department name is required", false);
                                  } else if (Designation.text.trim().isEmpty) {
                                    CustomWidgets.showToast(context,
                                        "Designation name is required", false);
                                  } else if (Con_List.DeparmenntSelect.where(
                                          (e) =>
                                      e['name'] == DeparmentSelect.text)
                                      .isEmpty) {
                                    CustomWidgets.showToast(context,
                                        "Enter Valid Department Name", false);
                                  } else if (Orderby.text.trim().isEmpty) {
                                    CustomWidgets.showToast(context, "Ord is required", false);
                                  } else if (await Designations_api.DesignationsUpdate(Deparment, UpdateId, Designation.text, Orderby.text,isActive)) {
                                    GetDeparment();
                                    if (Select.text.isEmpty) {
                                      GetDeparment();
                                    } else if (Select.text.isNotEmpty) {
                                      Con_List.AllDesignation = await Designations_api.DesignationsSelect(Con_List.DeparmenntSelect.firstWhere((e) => e['name'] == Select.text)['_id'].toString());
                                    }
                                    DeparmentSelect.text = "";
                                    Designation.text = "";
                                    Orderby.text = "";
                                    isActive = false;
                                    Update = false;
                                    UpdateId = "";
                                    setState(() {});
                                    CustomWidgets.showToast(context,
                                        "Designation Update Successfully", true);
                                  }
                                }else{
                                  CustomWidgets.showToast(context, "No Internet Connection", false);
                                }
                              }
                            },
                            height: height / 20,
                            width: width / 3,
                            text: Update ? "Update" : "Save"),
                        CustomWidgets.width(5)
                      ]),
                    ],
                  ),
                ) : Container(),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(left: 5, right: 5),
                    margin: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(color: Colorr.White, boxShadow: [
                      BoxShadow(
                        color: Colorr.themcolor100,
                        blurStyle: BlurStyle.outer,
                        blurRadius: 8,
                      ),
                    ]),
                    child: Column(
                      children: [
                        CustomWidgets.height(10),
                        CustomDropdown.search(
                          listItemStyle: CustomWidgets.style(),
                          hintText: 'Select Department',
                          controller: Select,
                          items: DeparmentSelected.toSet().toList(),
                          onChanged: (value) async {
                              Con_List.AllDesignation =DesigFilter.where((element) => element['deparmentId']['name'].toString()==value).map((e) => e).toList();
                              FocusScope.of(context).unfocus();
                              setState(() {});
                            
                          },
                        ),
                        Expanded(
                          child: mainwidget(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  saveButtton(String Save) async {
    FocusScope.of(context).unfocus();
    if (DeparmentSelect.text.trim().isEmpty) {
      CustomWidgets.showToast(context, "Department name is required", false);
    } else if (Designation.text.trim().isEmpty) {
      CustomWidgets.showToast(context, "Designation name is required", false);
    } else if (Con_List.DeparmenntSelect.where(
        (e) => e['name'] == DeparmentSelect.text).isEmpty) {
      CustomWidgets.showToast(context, "Enter Valid Department Name", false);
    } else if (Orderby.text.trim().isEmpty) {
      CustomWidgets.showToast(context, "Ord is required", false);
    } else {
      Map data = {
        "companyId": Constants_Usermast.companyId,
        "name": Designation.text,
        "ord": Orderby.text,
        "deparmentId": Con_List.DeparmenntSelect.firstWhere(
                (e) => e['name'] == DeparmentSelect.text)['_id']
            .toString(),
        "isActive": isActive.toString(),
      };
      if (await Designations_api.DesignationsInsert(data)) {
        if (Select.text.isEmpty) {
          GetDeparment();
        } else if (Select.text.isNotEmpty) {
          Con_List.AllDesignation = await Designations_api.DesignationsSelect(Con_List.DeparmenntSelect.firstWhere((e) => e['name'] == Select.text)['_id'].toString());
        }
        CustomWidgets.showToast(
            context, "Designation Added Successfully", true);
        if (Save == "Save") {
          DeparmentSelect.text = "";
          Designation.text = "";
          Orderby.text = "";
          isActive = false;
          setState(() {});
        }
      }
    }
  }
  Widget mainwidget() {
    if (internetConn == 1) {
      return Con_List.DesignationSelect.isNotEmpty ?Container(
          width: double.infinity,
          child: Con_List.AllDesignation.isNotEmpty
              ? SingleChildScrollView(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                  columns: [
                    DataColumn(
                      label: Text('No.'),
                    ),
                    DataColumn(
                      label: Text('Department'),
                    ),DataColumn(
                      label: Text('Designation'),
                    ),DataColumn(
                      label: Text("Order"),
                    ),
                    DataColumn(
                      label: Text('Active'),
                    ),
                    DataColumn(
                      label: Text('Action'),
                    ),
                  ],
                  rows:
                  Con_List.AllDesignation.asMap().entries.map((entry) {
                    int index = entry.key + 1;
                    final e = entry.value;
                    return DataRow(cells: [
                      DataCell(Text(index.toString())),
                      DataCell(Text(e['deparmentId']!=null?e['deparmentId']['name']:"")),
                      DataCell(Text(e['name']!)),
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
                          Con_List.Drawer.where((element) => element['subname']=='Designations' && element['update']==true).isNotEmpty ?
                          InkWell(
                              onTap: () {
                                Designation.text = e['name'];
                                isActive = e['isActive'];
                                Orderby.text = e['ord'].toString();
                                DeparmentSelect.text =   Con_List.DeparmenntSelect
                                    .firstWhere((element) => element['_id'] == e['deparmentId'].toString(),
                                    orElse: () => {'name': ''})
                                ['name'].toString();
                                Update = true;
                                UpdateId = e['_id'].toString();
                                setState(() {});
                              },
                              child: Icon(
                                Icons.edit,
                                color: Colorr.themcolor,
                                size: 22,
                              )) :Container(),
                          Con_List.Drawer.where((element) => element['subname']=='Designations' && element['delate']==true).isNotEmpty ?
                          InkWell(
                              onTap: () {
                                if(Con_List.AllEmployee.where((element) => element['designationId'].toString()==e['_id'].toString()).isNotEmpty){
                                        CustomWidgets.showToast(context, "Designation use in Employee", false);
                                }else{
                                  showDialog(context: context, builder: (BuildContextcontext) {
                                    return AlertDialog(
                                        title: Center(
                                            child:
                                            Text(
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
                                                    height: height / 20,
                                                    width: width / 3,
                                                    text: "Cancel",
                                                    Clr: Colors.redAccent)),
                                            CustomWidgets
                                                .width(
                                                5),
                                            Expanded(
                                                child: CustomWidgets.confirmButton(
                                                    onTap: () async {
                                                      FocusScope.of(context).unfocus();
                                                      if(await CustomWidgets.CheakConnectionInternetButton())
                                                      {
                                                        if (await Designations_api.DesignationsDelete(e['_id'])) {
                                                          if (Select.text.isEmpty) {
                                                            GetDeparment();
                                                          } else if (Select.text.isNotEmpty) {
                                                            Con_List.AllDesignation = await Designations_api.DesignationsSelect(Con_List.DeparmenntSelect.firstWhere((e) => e['name'] == Select.text)['_id'].toString());
                                                          }
                                                          setState(() {});
                                                          CustomWidgets.showToast(context, "Designation Deleted Successfully", true);
                                                          Navigator.pop(context);
                                                        } else {
                                                          Navigator.pop(context);
                                                        }
                                                      }else{
                                                        Navigator.pop(context);
                                                        CustomWidgets.showToast(context, "No Internet Connection", false);
                                                      }

                                                    },
                                                    height: height / 20,
                                                    width: width / 3,
                                                    text: "Delete")),
                                          ],
                                        ));
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
