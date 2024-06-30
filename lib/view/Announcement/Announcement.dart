import 'package:attendy/A_SQL_Trigger/Announcement_api.dart';
import 'package:attendy/view/Dashboard/Dashboard.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../Modal/All_import.dart';
import 'Add_Announcement.dart';

class Announcement extends StatefulWidget {
  const Announcement({super.key});

  @override
  State<Announcement> createState() => _AnnouncementState();
}

class _AnnouncementState extends State<Announcement> {
  @override
  void initState() {
    get();
    // TODO: implement initState
    super.initState();
  }

  List<dynamic> Announce = [];

  get() async {
    Announce = await Announcement_Api.AnnouncementSelect();

    setState(() {});
  }

  @override
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
      child: Scaffold(
          appBar: CustomWidgets.appbar(
            title: "Announcement",
            action: [
              IconButton(
                  splashRadius: 18,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return Add_Announcement();
                      },
                    ));
                  },
                  icon: Icon(Icons.add_circle_outline))
            ],
            context: context,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return Dashboard();
                },
              ));
            },
          ),
          body: Announce.isNotEmpty
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                          columns: const [
                            DataColumn(label: Text("Action")),
                            DataColumn(label: Text("No")),
                            DataColumn(label: Text("Title")),
                            DataColumn(label: Text("FromDate")),
                            DataColumn(label: Text("ToDate")),
                            DataColumn(label: Text("Description")),
                          ],
                          rows: Announce.asMap().entries.map((e) {
                            int index = e.key;
                            final value = e.value;
                            return DataRow(cells: [
                              DataCell(Row(
                                children: [
                                  Con_List.Drawer.where((element) =>
                                          element['subname'] == 'Holidays' &&
                                          element['update'] == true).isNotEmpty
                                      ? GestureDetector(
                                          onTap: () {
                                            Navigator.push(context,
                                                CupertinoPageRoute(
                                              builder: (context) {
                                                return Add_Announcement(
                                                  e: value,
                                                );
                                              },
                                            ));
                                          },
                                          child: Icon(
                                            Icons.edit,
                                            color: Colorr.themcolor,
                                            size: 22,
                                          ),
                                        )
                                      : Container(),
                                  Con_List.Drawer.where((element) =>
                                          element['subname'] == 'Holidays' &&
                                          element['delate'] == true).isNotEmpty
                                      ? InkWell(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                      title: Center(
                                                          child: Text(
                                                        "Do you want to delete this Announcement?",
                                                        style: TextStyle(
                                                            color: Colorr
                                                                .themcolor),
                                                      )),
                                                      content: Row(
                                                        children: [
                                                          Expanded(
                                                              child: CustomWidgets
                                                                  .confirmButton(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      height:
                                                                          40,
                                                                      width:
                                                                          170,
                                                                      text:
                                                                          "Cancel",
                                                                      Clr: Colors
                                                                          .redAccent)),
                                                          CustomWidgets.width(
                                                              5),
                                                          Expanded(
                                                              child: CustomWidgets
                                                                  .confirmButton(
                                                                      onTap:
                                                                          () async {
                                                                        if (await Announcement_Api
                                                                            .AnnouncementDelete({
                                                                          "id":
                                                                              value['_id']
                                                                        })) {
                                                                          CustomWidgets.showToast(
                                                                              context,
                                                                              "Announcement Deleted Successfully",
                                                                              true);
                                                                          get();
                                                                          Navigator.pop(
                                                                              context);
                                                                        } else {
                                                                          Navigator.pop(
                                                                              context);
                                                                        }
                                                                      },
                                                                      height:
                                                                          40,
                                                                      width:
                                                                          170,
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
                                          ))
                                      : Container(),
                                ],
                              )),
                              DataCell(Text((index + 1).toString())),
                              DataCell(Text(value['Title'].toString())),
                              DataCell(Text(DateFormat("dd-MM-yyyy").format(
                                  DateTime.parse(
                                      value['fromDate'].toString())))),
                              DataCell(Text(DateFormat("dd-MM-yyyy").format(
                                  DateTime.parse(value['toDate'].toString())))),
                              DataCell(Text(value['Desc'].toString())),
                            ]);
                          }).toList())),
                )
              : CustomWidgets.NoDataImage(context)),
    );
  }
}
