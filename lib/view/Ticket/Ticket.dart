import 'package:attendy/A_SQL_Trigger/Ticket_api.dart';
import 'package:attendy/utils/Constant/Con_icon.dart';
import 'package:attendy/utils/Constant/LocalCustomWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../A_SQL_Trigger/Con_List.dart';
import '../../A_SQL_Trigger/Con_Usermast.dart';
import '../../A_SQL_Trigger/Employee_Add_api.dart';
import '../../utils/Constant/Colors.dart';
import '../Dashboard/Dashboard.dart';
import 'AddTicket.dart';

class Ticket extends StatefulWidget {
  const Ticket({Key? key}) : super(key: key);

  @override
  State<Ticket> createState() => _TicketState();
}

class _TicketState extends State<Ticket> {
  bool isActive=false;
  int internetConn=0;
  double height =0;
  double width =0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CheakInternet();
    getdata();
  }
  getdata()
  async {
    Con_List.TiccketSelect=await Ticket_api.TicketSelect();
    Con_List.AllEmployee = await AllEmployee_api.EmployeeSelect();
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
     height =MediaQuery.of(context).size.height-kToolbarHeight;
     width =MediaQuery.of(context).size.width;
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
          title: "Ticket",
          action: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: Icon(CupertinoIcons.refresh, color: Colorr.White),
              onPressed: () {
                getdata();
              },
            ),
            Con_List.Drawer.where((element) => element['name']=='Ticket' && element['insert']==true).isNotEmpty ?
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: Icon(CupertinoIcons.add, color: Colorr.White),
              onPressed: () {
                Navigator.pushReplacement(context, CupertinoPageRoute(
                  builder: (context) {
                    return AddTicket();
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
            child: Con_List.TiccketSelect.isNotEmpty
                ? SingleChildScrollView(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                    columns: [
                      DataColumn(
                        label: Text('No'),
                      ),
                      DataColumn(
                        label: Text('Employee Name'),
                      ),
                      DataColumn(
                        label: Text('Priority'),
                      ),
                      DataColumn(
                        label: Text('Date'),
                      ),
                      DataColumn(
                        label: Text('Ticket'),
                      ),
                      // DataColumn(
                      //   label: Text('Active'),
                      // ),
                    ],
                    rows: Con_List.TiccketSelect.asMap().entries.map((entry) {
                      int index = entry.key + 1;
                      final e = entry.value;
                      return DataRow(cells: [
                        DataCell(Text(index.toString())),
                        DataCell(Text(Con_List.AllEmployee.isEmpty ? "" : Con_List.AllEmployee.firstWhere((element) => element['_id'] == e['employeeId'], orElse: () => {'FirstName': ''})['FirstName'].toString())),
                        DataCell(Text(e['priority']!)),
                        DataCell(Text(CustomWidgets.DateFormatchange(e['fromDate']!.toString()))),
                        DataCell(Text(e['name']!)),
                        // DataCell(
                        //   Checkbox(
                        //     value: e['isActive'],
                        //     shape: CircleBorder(),
                        //     activeColor: Colorr.themcolor,
                        //     onChanged: (value) {},
                        //   ),
                        // ),
                      ]);
                    }).toList()),
              ),
            )
                : Container()),
      )
          : Scaffold(
        appBar: CustomWidgets.appbar(title: "Ticket",action:  [
          CustomWidgets.navigateBack(
            iconSize: 30,
            onPressed: () async {
              Con_List.TiccketSelect=await Ticket_api.TicketSelect();
              Con_List.AllEmployee = await AllEmployee_api.EmployeeSelect();
              setState(() {
              });
            },
            icon: const Icon(Icons.refresh),
          ),
          Con_List.Drawer.where((element) => element['name']=='Tickets' && element['insert']==true).isNotEmpty ?
          IconButton(splashRadius: 18,onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return AddTicket();
            },));
          }, icon: Con_icon.AddNew) : Container()
        ],context:  context,onTap: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
            return Dashboard();
          },));
        },),
        body: mainwidget() ,
      ),
    );
  }
  Widget mainwidget() {
    if (internetConn == 1) {
      return Con_List.TiccketSelect.isNotEmpty ? Container(
          height: double.infinity,
          width: double.infinity,
          child: Con_List.TiccketSelect.isNotEmpty
              ? SingleChildScrollView(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                  columns: [
                    DataColumn(
                      label: Text('No'),
                    ),
                    DataColumn(
                      label: Text('Employee Name'),
                    ),
                    DataColumn(
                      label: Text('Priority'),
                    ),
                    DataColumn(
                      label: Text('Date'),
                    ),
                    DataColumn(
                      label: Text('Ticket'),
                    ),
                    // DataColumn(
                    //   label: Text('Active'),
                    // ),
                  ],
                  rows: Con_List.TiccketSelect.asMap().entries.map((entry) {
                    int index = entry.key + 1;
                    final e = entry.value;
                    return DataRow(cells: [
                      DataCell(Text(index.toString())),
                      DataCell(Text(Con_List.AllEmployee.isEmpty ? "" : Con_List.AllEmployee.firstWhere((element) => element['_id'] == e['employeeId'], orElse: () => {'FirstName': ''})['FirstName'].toString())),
                      DataCell(Text(e['priority']!)),
                      DataCell(Text(CustomWidgets.DateFormatchange(e['fromDate']!.toString()))),
                      DataCell(Text(e['name']!)),
                      // DataCell(
                      //   Checkbox(
                      //     value: e['isActive'],
                      //     shape: CircleBorder(),
                      //     activeColor: Colorr.themcolor,
                      //     onChanged: (value) {},
                      //   ),
                      // ),
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
