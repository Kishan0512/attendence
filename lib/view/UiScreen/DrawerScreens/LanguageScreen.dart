import 'package:attendy/utils/Constant/Colors.dart';
import 'package:attendy/utils/Constant/FontWeight.dart';
import 'package:attendy/utils/Constant/LocalCustomWidgets.dart';
import 'package:flutter/material.dart';

import '../../Dashboard/Dashboard.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

bool english = true;
bool hindi = false;
bool gujarati = false;

class _LanguageScreenState extends State<LanguageScreen> {
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
      appBar: CustomWidgets.appbar(title: "Languages",action:  [
      ],context:  context,onTap: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return Dashboard();
        },));
      },),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Text(
                        "Select Languages",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontFamily: "Poppins",
                            color: Colorr.themcolor,
                            fontSize: 26,
                            fontWeight: FWeight.fW600),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Text(
                        "Please Select Your Prefer Language.",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontFamily: "PoppinsR",
                            color: Colorr.themcolor,
                            fontSize: 16,
                            fontWeight: FWeight.fW400),
                      ),
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              english = !english;
                              hindi = false;
                              gujarati = false;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: Container(
                              height: 50,
                              margin: EdgeInsets.only(top: 50, bottom: 10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colorr.themcolor, width: 1.50),
                                color: english
                                    ? Colorr.themcolor
                                    : Colorr.themcolor50,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Center(
                                child: Text(
                                  "English",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      color: english
                                          ? Colorr.White
                                          : Colorr.themcolor,
                                      fontSize: 18,
                                      fontWeight: FWeight.fW500),
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              english = false;
                              hindi = true;
                              gujarati = false;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: Container(
                              height: 50,
                              margin: EdgeInsets.only(top: 10, bottom: 10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colorr.themcolor, width: 1.50),
                                color: hindi
                                    ? Colorr.themcolor
                                    : Colorr.themcolor50,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Center(
                                child: Text(
                                  "Hindi",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      color: hindi
                                          ? Colorr.White
                                          : Colorr.themcolor,
                                      fontSize: 18,
                                      fontWeight: FWeight.fW500),
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              english = false;
                              hindi = false;
                              gujarati = true;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: Container(
                              height: 50,
                              margin: EdgeInsets.only(top: 10, bottom: 10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colorr.themcolor, width: 1.50),
                                color: gujarati
                                    ? Colorr.themcolor
                                    : Colorr.themcolor50,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Center(
                                child: Text(
                                  "Gujarati",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      color: gujarati
                                          ? Colorr.White
                                          : Colorr.themcolor,
                                      fontSize: 18,
                                      fontWeight: FWeight.fW500),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: CustomWidgets.button(
                  buttonTitle: "Save",
                  onTap: () {},
                  color: Colorr.themcolor400,
                  textColor: Colorr.White))
        ],
      ),
    ));
  }
}
