import 'package:attendy/utils/Constant/LocalCustomWidgets.dart';
import 'package:attendy/utils/Constant/Colors.dart';
import 'package:attendy/utils/Constant/FontWeight.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../Dashboard/Dashboard.dart';
import '../../Employee/Attendance.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
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
      backgroundColor: Colorr.themcolor50,
      appBar: CustomWidgets.appbar(title: "Report",action:  [
        IconButton(
          splashRadius: 18,
          onPressed: () {
            setState(() {
              show = !show;
            });
          },
          icon: Icon(show ? Icons.close : Icons.search,
              color: Colors.white, size: 27),
        ),
      ],context:  context,onTap: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return Dashboard();
        },));
      },),
      body: Column(
        children: [
          show ? CustomWidgets.searchBar(controller: searchBar) : Container(),
          Container(
            child: Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Attendance()));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(
                          left: 20, right: 20, top: 7, bottom: 7),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(color: Colorr.themcolor, width: 1.50)),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  margin: const EdgeInsets.only(right: 10),
                                  child: ClipOval(
                                    child: Image.asset("images/user12.png",
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Nirav Lukhi(Admin)",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontFamily: "PoppinsM",
                                          color: Colorr.themcolor,
                                          fontSize: 18,
                                          fontWeight: FWeight.fW500),
                                    ),
                                    Text(
                                      "Punch",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontFamily: "PoppinsR",
                                          color: Colorr.themcolor300,
                                          fontSize: 16,
                                          fontWeight: FWeight.fW400),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colorr.themcolor,
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
