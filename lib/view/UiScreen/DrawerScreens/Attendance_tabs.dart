import 'package:attendy/utils/Constant/Colors.dart';
import 'package:attendy/utils/Constant/FontWeight.dart';
import 'package:flutter/material.dart';


class Attendance_tabs extends StatefulWidget {
  Attendance_tabs({Key? key}) : super(key: key);

  @override
  State<Attendance_tabs> createState() => _Attendance_tabsState();
}

class _Attendance_tabsState extends State<Attendance_tabs> {
  bool isshow = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isshow = !isshow;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "01-05-2022",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontFamily: "Poppins",
                              color: Colorr.themcolor,
                              fontSize: 18,
                              fontWeight: FWeight.fW600),
                        ),
                        Icon(
                          isshow
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colorr.themcolor,
                        )
                      ],
                    ),
                  ),
                  Text(
                    "Monday",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontFamily: "PoppinsR",
                        color: Colorr.themcolor,
                        fontSize: 16,
                        fontWeight: FWeight.fW400),
                  ),
                  isshow
                      ? Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Container(
                            height: 110,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      // color: Colorr.Grey,
                                      width: 160,
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.arrow_circle_right,
                                                color: Colorr.lightGreen,
                                                size: 25,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Text(
                                                  "09:05:21 AM",
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      fontFamily: "PoppinsM",
                                                      color: Colorr.themcolor,
                                                      fontSize: 18,
                                                      fontWeight: FWeight.fW500),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5),
                                                child: Text(
                                                  "In",
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      fontFamily: "PoppinsR",
                                                      color: Colorr.themcolor,
                                                      fontSize: 14,
                                                      fontWeight: FWeight.fW400),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Text(
                                                  "india standard Time",
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      fontFamily: "PoppinsR",
                                                      color: Colorr.themcolor,
                                                      fontSize: 12,
                                                      fontWeight: FWeight.fW400),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      // color: Colorr.Grey,
                                      width: 160,
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.arrow_circle_left,
                                                color: Colorr.Red,
                                                size: 25,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Text(
                                                  "06:18:21 PM",
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      fontFamily: "PoppinsM",
                                                      color: Colorr.themcolor,
                                                      fontSize: 18,
                                                      fontWeight: FWeight.fW500),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.only(),
                                                child: Text(
                                                  "Out",
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      fontFamily: "PoppinsR",
                                                      color: Colorr.themcolor,
                                                      fontSize: 14,
                                                      fontWeight: FWeight.fW400),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Text(
                                                  "india standard Time",
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      fontFamily: "PoppinsR",
                                                      color: Colorr.themcolor,
                                                      fontSize: 12,
                                                      fontWeight: FWeight.fW400),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 100,
                                  width: 1,
                                  color: Colorr.themcolor,
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 160,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Working Hours",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontFamily: "PoppinsM",
                                                color: Colorr.themcolor,
                                                fontSize: 18,
                                                fontWeight: FWeight.fW500),
                                          ),
                                          Text(
                                            "08hh 30m",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontFamily: "PoppinsR",
                                                color: Colorr.themcolor,
                                                fontSize: 15,
                                                fontWeight: FWeight.fW400),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 160,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Break Hours",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontFamily: "PoppinsM",
                                                color: Colorr.themcolor,
                                                fontSize: 18,
                                                fontWeight: FWeight.fW500),
                                          ),
                                          Text(
                                            "00hh 30m",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontFamily: "PoppinsR",
                                                color: Colorr.themcolor,
                                                fontSize: 15,
                                                fontWeight: FWeight.fW400),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
