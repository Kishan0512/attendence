import 'package:attendy/utils/Constant/Colors.dart';
import 'package:attendy/utils/Constant/FontWeight.dart';
import 'package:attendy/utils/Constant/LocalCustomWidgets.dart';
import 'package:flutter/material.dart';

import '../../Dashboard/Dashboard.dart';

class Help_Center extends StatefulWidget {
  const Help_Center({Key? key}) : super(key: key);

  @override
  State<Help_Center> createState() => _Help_CenterState();
}

class _Help_CenterState extends State<Help_Center> {
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
      appBar: CustomWidgets.appbar(title: "Help Center",action:  [
      ],context:  context,onTap: () {
        Navigator.pop(context);
      },),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Center(
                child: Text(
                  "How can we help you?",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontFamily: "Poppins",
                      color: Colorr.themcolor,
                      fontSize: 24,
                      fontWeight: FWeight.fW600),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15, top: 20),
              child: CustomWidgets.textField(
                  enabledBorderRadius: 50,
                  height: 50,
                  hintText: "Start typing your search...",
                  radius: 50,
                  filled: true,
                  fontColor: Colorr.themcolor300,
                  prefixIcon: Icon(
                    Icons.add_circle_outline,
                    color: Colorr.White,
                    size: 10,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Image.asset(
                        "images/searchfield.webp",
                        width: 3,
                      ),
                    ),
                  ),
                  borderSide: BorderSide.none,
                  enabledBorder: BorderSide.none,
                  fillColor: Colorr.White),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      "Or choose an option occaecat ",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontFamily: "PoppinsR",
                          color: Colorr.themcolor,
                          fontSize: 16,
                          fontWeight: FWeight.fW500),
                    ),
                    Text(
                      "cupidatat non proident.",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontFamily: "PoppinsR",
                          color: Colorr.themcolor,
                          fontSize: 16,
                          fontWeight: FWeight.fW500),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15, right: 15, top: 20),
                      child: CustomWidgets.container(
                          height: 70,
                          width: double.infinity,
                          radius: 15,
                          borderColor: Colorr.themcolor50,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset(
                                  "images/guides.webp",
                                  height: 50,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 30),
                                  child: Text(
                                    "Guides",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        color: Colorr.themcolor,
                                        fontSize: 20,
                                        fontWeight: FWeight.fW500),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15, right: 15, top: 20),
                      child: CustomWidgets.container(
                          height: 70,
                          width: double.infinity,
                          radius: 15,
                          borderColor: Colorr.themcolor50,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset(
                                  "images/faq.webp",
                                  height: 50,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 30),
                                  child: Text(
                                    "FAQ",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        color: Colorr.themcolor,
                                        fontSize: 20,
                                        fontWeight: FWeight.fW500),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15, right: 15, top: 20),
                      child: CustomWidgets.container(
                          height: 70,
                          width: double.infinity,
                          radius: 15,
                          borderColor: Colorr.themcolor50,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset(
                                  "images/community.webp",
                                  height: 50,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 30),
                                  child: Text(
                                    "Community",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        color: Colorr.themcolor,
                                        fontSize: 20,
                                        fontWeight: FWeight.fW500),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              "Getting Started",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: Colorr.themcolor,
                                  fontSize: 24,
                                  fontWeight: FWeight.fW600),
                            ),
                            Text(
                              "Welcome to sales Layer! Get started",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontFamily: "PoppinsR",
                                  color: Colorr.themcolor300,
                                  fontSize: 16,
                                  fontWeight: FWeight.fW400),
                            ),
                            Text(
                              "faster by learning some basics Welcome",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontFamily: "PoppinsR",
                                  color: Colorr.themcolor300,
                                  fontSize: 16,
                                  fontWeight: FWeight.fW400),
                            ),
                            Text(
                              "to sales Layer! Get started",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontFamily: "PoppinsR",
                                  color: Colorr.themcolor300,
                                  fontSize: 16,
                                  fontWeight: FWeight.fW400),
                            ),
                            Text(
                              "faster by learning some basics",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontFamily: "PoppinsR",
                                  color: Colorr.themcolor300,
                                  fontSize: 16,
                                  fontWeight: FWeight.fW400),
                            ),
                          ],
                        ),
                      ),
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
}
