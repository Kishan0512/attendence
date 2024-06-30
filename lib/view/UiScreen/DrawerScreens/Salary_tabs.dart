import 'package:attendy/utils/Constant/Colors.dart';
import 'package:attendy/utils/Constant/FontWeight.dart';
import 'package:flutter/material.dart';

class Salary_tabs extends StatefulWidget {
  Salary_tabs({Key? key}) : super(key: key);

  @override
  State<Salary_tabs> createState() => _Salary_tabsState();
}

class _Salary_tabsState extends State<Salary_tabs> {
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
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colorr.themcolor, width: 1.50)),
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
                                            "₹ 8520.00",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontFamily: "PoppinsR",
                                                color: Colorr.lightGreen,
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
