import 'package:attendy/utils/Constant/Colors.dart';
import 'package:attendy/utils/Constant/FontWeight.dart';
import 'package:attendy/utils/Constant/LocalCustomWidgets.dart';
import 'package:flutter/material.dart';

import '../../Dashboard/Dashboard.dart';
import 'App_info.dart';
import 'Contect_Us.dart';
import 'Help_center.dart';
import '../../PrivacyPolicy/Policy_details.dart';

class HelpDetailScreen extends StatefulWidget {
  const HelpDetailScreen({Key? key}) : super(key: key);

  @override
  State<HelpDetailScreen> createState() => _HelpDetailScreenState();
}

class _HelpDetailScreenState extends State<HelpDetailScreen> {
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
      appBar: CustomWidgets.appbar(title: "Get Help",action:  [
      ],context:  context,onTap: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return Dashboard();
        },));
      },),

      backgroundColor: Colorr.themcolor50,
      body: ListView(
        children: [
          setti_Account(),
          setti_Employees(),
          setti_theme(),
          setti_Language(),
        ],
      ),
    ));
  }

  Widget setti_Account() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Help_Center()));
      },
      child: Container(
        color: Colorr.themcolor50,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 15, top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        "images/account.webp",
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Text(
                          "Help Center",
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
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colorr.themcolor,
                    size: 20,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
              child: Container(
                height: 1.50,
                color: Colorr.themcolor,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget setti_Employees() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Contect_Us()));
      },
      child: Container(
        color: Colorr.themcolor50,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 15, top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        "images/employees.webp",
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Text(
                          "Contact Us",
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
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colorr.themcolor,
                    size: 20,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
              child: Container(
                height: 1.50,
                color: Colorr.themcolor,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget setti_theme() {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => Policy_details(),
        );
      },
      child: Container(
        color: Colorr.themcolor50,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 15, top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        "images/themes.webp",
                        height: 20,
                      ),
                      // Icon(
                      //   Icons.groups,
                      //   size: 30,
                      //   color: Colorr.themcolor,
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Text(
                          "Terms And Privacy Policy",
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
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colorr.themcolor,
                    size: 20,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
              child: Container(
                height: 1.50,
                color: Colorr.themcolor,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget setti_Language() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => App_info()));
      },
      child: Container(
        color: Colorr.themcolor50,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 15, top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        "images/languages.webp",
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Text(
                          "App Info",
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
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colorr.themcolor,
                    size: 20,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
              child: Container(
                height: 1.50,
                color: Colorr.themcolor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
