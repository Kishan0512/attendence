import 'package:attendy/utils/Constant/LocalCustomWidgets.dart';
import 'package:attendy/utils/Constant/Colors.dart';
import 'package:attendy/utils/Constant/FontWeight.dart';
import 'package:flutter/material.dart';

import '../../Dashboard/Dashboard.dart';

class EmployeeDetailScreen extends StatefulWidget {
  const EmployeeDetailScreen({Key? key}) : super(key: key);

  @override
  State<EmployeeDetailScreen> createState() => _EmployeeDetailScreenState();
}

class _EmployeeDetailScreenState extends State<EmployeeDetailScreen> {
  TextEditingController searchBar = TextEditingController();
  bool show = false;

  @override
  Widget build(BuildContext context) {
    Future<bool> onBackPress() {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return Dashboard();
      },));
      return Future.value(false);
    }
    return WillPopScope(
        onWillPop: () => onBackPress(),
    child: Scaffold(
      appBar: CustomWidgets.appbar(title: "Employee Details",action:  [
        IconButton(
          splashRadius: 18,
          onPressed: () {
            setState(() {
              show = !show;
            });
          },
          icon: Icon(show ? Icons.close : Icons.search,
              color: Colors.white, size: 26),
        ),
      ],context:  context,onTap: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return Dashboard();
        },));
      },),
      body: Column(
        children: [
          show ? CustomWidgets.searchBar(controller: searchBar) : Container(),
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 15, right: 15),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(0.75),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(2),
                3: FlexColumnWidth(1.5),
              },
              children: [
                TableRow(children: [
                  Text(
                    "No.",
                    style: TextStyle(
                        fontFamily: "PoppinsM",
                        color: Colorr.themcolor,
                        fontSize: 14,
                        fontWeight: FWeight.fW500),
                  ),
                  Text(
                    "Name",
                    style: TextStyle(
                        fontFamily: "PoppinsM",
                        color: Colorr.themcolor,
                        fontSize: 14,
                        fontWeight: FWeight.fW500),
                  ),
                  Text(
                    "Working Time",
                    style: TextStyle(
                        fontFamily: "PoppinsM",
                        color: Colorr.themcolor,
                        fontSize: 14,
                        fontWeight: FWeight.fW500),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Action",
                        style: TextStyle(
                            fontFamily: "PoppinsM",
                            color: Colorr.themcolor,
                            fontSize: 14,
                            fontWeight: FWeight.fW500),
                      ),
                    ],
                  ),
                ]),
              ],
            ),
          ),
          CustomWidgets.height(20),
          Expanded(
            child: ListView.builder(
              itemCount: 20,
              itemExtent: 60,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Column(
                    children: [
                      Table(
                        columnWidths: const {
                          0: FlexColumnWidth(0.75),
                          1: FlexColumnWidth(2),
                          2: FlexColumnWidth(2),
                          3: FlexColumnWidth(1.5),
                        },
                        children: [
                          TableRow(children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "01",
                                  style: TextStyle(
                                      fontFamily: "PoppinsM",
                                      color: Colorr.themcolor300,
                                      fontSize: 14,
                                      fontWeight: FWeight.fW500),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Nirav",
                                  style: TextStyle(
                                      fontFamily: "PoppinsM",
                                       color: Colorr.themcolor300,
                                      fontSize: 14,
                                      fontWeight: FWeight.fW500),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "09:15 to 06:00",
                                  style: TextStyle(
                                      fontFamily: "PoppinsM",
                                      color: Colorr.themcolor300,
                                      fontSize: 14,
                                      fontWeight: FWeight.fW500),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {},
                                      child: Icon(Icons.delete_outlined,
                                          color: Colorr.themcolor300),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Icon(Icons.visibility_outlined,
                                          color: Colorr.themcolor300),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ]),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: Container(
                          height: 1,
                          width: double.infinity,
                          color: Colorr.themcolor,
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    ));
  }
}
