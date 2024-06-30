// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:attendy/A_SQL_Trigger/LoginActivity.dart';
import 'package:attendy/utils/Constant/LocalCustomWidgets.dart';
import 'package:attendy/view/Dashboard/Dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:attendy/A_SQL_Trigger/api_page.dart';
import 'package:intl/intl.dart';
import '../../A_SQL_Trigger/Con_List.dart';
import '../../A_SQL_Trigger/Con_Usermast.dart';
import '../../utils/Constant/Colors.dart';
import '../../utils/DroupDown/custom_dropdown.dart';

class Activities extends StatefulWidget {
  const Activities({Key? key}) : super(key: key);

  @override
  State<Activities> createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  List<String> Users = [];
  List<dynamic> Data = [];
  int internetConn = 0;

  TextEditingController Username = TextEditingController();

  @override
  void initState() {
    super.initState();
    getdata();
    CheakInternet();
  }

  CheakInternet() async {
    internetConn = await CustomWidgets.CheakConnectionInternet();
    setState(() {});
  }

  getdata() async {
    Con_List.ActivitiesSelect = await LoginActivity.LoginActivitySelect();
    Data=Con_List.ActivitiesSelect;
    Con_List.Users = await api_page.userSelect();
    for (var element in Con_List.Users) {
      Users.add(element['name']);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> onBackPress() {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return const Dashboard();
        },
      ));
      return Future.value(false);
    }

    return WillPopScope(
        onWillPop: () => onBackPress(),
        child:Constants_Usermast.IOS==true
            ? CupertinoPageScaffold(
                navigationBar: CustomWidgets.appbarIOS(
                  title: "Activity",
                  action: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Icon(CupertinoIcons.refresh, color: Colorr.White),
                      onPressed: () async {
                        Username.text = "";
                        if (await CustomWidgets
                            .CheakConnectionInternetButton()) {
                          getdata();
                        } else {
                          CustomWidgets.showToast(
                              context, "No Internet Connection", false);
                        }
                        setState(() {});
                      },
                    )
                  ],
                  context: context,
                  onTap: () {
                    Navigator.pushReplacement(context, CupertinoPageRoute(
                      builder: (context) {
                        return const Dashboard();
                      },
                    ));
                  },
                ),
                child:  SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(
                              left: 5, right: 5, top: 10, bottom: 10),
                          decoration:
                          BoxDecoration(color: Colorr.White, boxShadow: [
                            BoxShadow(
                              color: Colorr.themcolor100,
                              blurStyle: BlurStyle.outer,
                              blurRadius: 8,
                            ),
                          ]),
                          child: Column(
                            children: [
                              CustomWidgets.textFieldIOS(hintText: "Select user",controller: Username,readOnly: true,onTap: () {
                                CustomWidgets.SelectDroupDown(context: context,items: Users, onSelectedItemChanged: (value) async {
                                  Username.text=Users[value];
                                  Con_List.ActivitiesSelect =
                                      await LoginActivity.LoginActivitySelect();
                                  Data.clear();
                                  Data = Con_List.ActivitiesSelect.where((e) =>
                                  e['name'].toString() ==
                                      Username.text.toString()).toList();
                                  setState(() {});
                                  setState(() {
                                  });
                                });
                              },suffix: CustomWidgets.aarowCupertinobutton(),
                              ),
                              CustomWidgets.height(8)
                            ],
                          ),
                        ),
                        Expanded(child: mainwidget())
                      ],
                    )),
              )
            : Scaffold(
                appBar: CustomWidgets.appbar(
                  title: "Activity",
                  action: [
                    CustomWidgets.navigateBack(
                      iconSize: 30,
                      onPressed: () async {
                        Username.text = "";
                        if (await CustomWidgets
                            .CheakConnectionInternetButton()) {
                          getdata();
                        } else {
                          CustomWidgets.showToast(
                              context, "No Internet Connection", false);
                        }
                        setState(() {});
                      },
                      icon: const Icon(Icons.refresh),
                    ),
                  ],
                  context: context,
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) {
                        return const Dashboard();
                      },
                    ));
                  },
                ),
                body: SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                    child: Column(
                      children: [
                       Constants_Usermast.statuse=="ADMIN" ? Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(
                              left: 5, right: 5, top: 10, bottom: 10),
                          decoration:
                              BoxDecoration(color: Colorr.White, boxShadow: [
                            BoxShadow(
                              color: Colorr.themcolor100,
                              blurStyle: BlurStyle.outer,
                              blurRadius: 8,
                            ),
                          ]),
                          child: Column(
                            children: [
                              CustomDropdown.search(
                                listItemStyle: CustomWidgets.style(),
                                hintText: 'Select User',
                                controller: Username,
                                items: Users,
                                onChanged: (value) async {
                                  Con_List.ActivitiesSelect =
                                      await LoginActivity.LoginActivitySelect();
                                  Data.clear();
                                  Data = Con_List.ActivitiesSelect.where((e) =>
                                      e['name'].toString() ==
                                      value.toString()).toList();
                                  setState(() {});
                                },
                              ),
                              CustomWidgets.height(8)
                            ],
                          ),
                        ) : Container(),
                        Expanded(child: mainwidget())
                      ],
                    )),
              ));
  }

  Widget mainwidget() {
    if (internetConn == 1) {
      return Data.isNotEmpty
          ? Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 5, right: 5),
              margin: Constants_Usermast.statuse=="ADMIN" ?  const EdgeInsets.only(top: 10): const EdgeInsets.only(top: 0),
              decoration: BoxDecoration(color: Colorr.White, boxShadow: [
                BoxShadow(
                  color: Colorr.themcolor100,
                  blurStyle: BlurStyle.outer,
                  blurRadius: 8,
                ),
              ]),
              child: Data.isNotEmpty
                  ? SingleChildScrollView(
                      scrollDirection: Axis.vertical,
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
                                label: Text('Login Date'),
                              ),
                              DataColumn(
                                label: Text('Login Time'),
                              ),
                              DataColumn(
                                label: Text('Ip Address'),
                              ),
                              DataColumn(
                                label: Text('Location'),
                              ),
                              DataColumn(
                                label: Text('System'),
                              ),
                            ],
                            rows: Data.asMap().entries.map((entry) {
                              int index = entry.key + 1;
                              final e = entry.value;
                              String formattedTime = "";
                              if (e['loginTime'] != null) {
                                String timein = e['loginTime'].toString();
                                DateTime t = DateTime.parse(timein).toLocal();
                                String formattedDateTime = DateFormat('yyyy-MM-dd hh:mm:ss a').format(t);
                                DateTime dateTime = DateFormat('yyyy-MM-dd hh:mm:ss a').parse(formattedDateTime);
                                formattedTime =DateFormat('hh:mm:ss a').format(dateTime);
                              }
                              DateTime originalDate =
                                  DateTime.parse(e['loginTime'].toString());
                              String formattedDate =
                                  DateFormat("dd-MM-yyyy").format(originalDate);
                              return DataRow(cells: [
                                DataCell(Text(index.toString())),
                                DataCell(Text(e['name']!)),
                                DataCell(Text(formattedDate)),
                                DataCell(Text(formattedTime.toString())),
                                DataCell(Text(e['ip'])),
                                DataCell(Text(
                                    "${e['city']},${e['state']},${e['contry']}")),
                                DataCell(Text(e['system']!)),
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
