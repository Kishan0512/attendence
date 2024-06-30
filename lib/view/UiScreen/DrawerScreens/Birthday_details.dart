import 'package:attendy/utils/Constant/Colors.dart';
import 'package:attendy/utils/Constant/FontWeight.dart';
import 'package:attendy/utils/Constant/LocalCustomWidgets.dart';
import 'package:flutter/material.dart';

import '../../Dashboard/Dashboard.dart';

class Birthday_details extends StatefulWidget {
  const Birthday_details({Key? key}) : super(key: key);

  @override
  State<Birthday_details> createState() => _Birthday_detailsState();
}

bool today = true;
bool upcoming = false;
List birthday = ["Today", "Upcoming"];

class _Birthday_detailsState extends State<Birthday_details> {
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
    child: DefaultTabController(
      length: birthday.length,
      child: Scaffold(
        backgroundColor: Colorr.themcolor50,
        appBar: CustomWidgets.appbar(title: "BirthDay",action:  [
        ],context:  context,onTap: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
            return Dashboard();
          },));
        },),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        today = true;
                        upcoming = false;
                      });
                    },
                    child: Container(
                      height: 50,
                      width: 150,
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Colorr.themcolor, width: 1.50),
                        color: today ? Colorr.themcolor : Colorr.themcolor50,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: Text(
                          "Today",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontFamily: "Poppins",
                              color: today ? Colorr.White : Colorr.themcolor,
                              fontSize: 18,
                              fontWeight: FWeight.fW600),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        today = false;
                        upcoming = true;
                      });
                    },
                    child: Container(
                      height: 50,
                      width: 150,
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Colorr.themcolor, width: 1.50),
                        color: upcoming ? Colorr.themcolor : Colorr.themcolor50,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: Text(
                          "Upcoming",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontFamily: "Poppins",
                              color: upcoming ? Colorr.White : Colorr.themcolor,
                              fontSize: 18,
                              fontWeight: FWeight.fW600),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: today
                    ? Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                left: 20, right: 20, top: 7, bottom: 7),
                            decoration: BoxDecoration(
                                color: Colorr.White,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colorr.themcolor200,
                                      blurRadius: 5,
                                      spreadRadius: 0.5,
                                      offset: Offset(2, 3))
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.account_circle,
                                        size: 40,
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                            "Today",
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
                          Container(
                            margin: EdgeInsets.only(
                                left: 20, right: 20, top: 7, bottom: 7),
                            decoration: BoxDecoration(
                                color: Colorr.White,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colorr.themcolor200,
                                      blurRadius: 5,
                                      spreadRadius: 0.5,
                                      offset: Offset(2, 3))
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.account_circle,
                                        size: 40,
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                            "Today",
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
                        ],
                      )
                    : Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                left: 20, right: 20, top: 7, bottom: 7),
                            decoration: BoxDecoration(
                                color: Colorr.White,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colorr.themcolor200,
                                      blurRadius: 5,
                                      spreadRadius: 0.5,
                                      offset: Offset(2, 3))
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.account_circle,
                                        size: 40,
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                            "16-08-2022",
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
                        ],
                      ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
