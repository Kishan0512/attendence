import 'package:attendy/utils/Constant/Colors.dart';
import 'package:attendy/utils/Constant/LocalCustomWidgets.dart';
import 'package:flutter/material.dart';

import '../../Screens/CreateAccount.dart';
import '../../utils/Constant/Con_icon.dart';
import '../../utils/Constant/FontWeight.dart';
import '../Dashboard/Dashboard.dart';

class Policy_details extends StatefulWidget {
  const Policy_details({Key? key}) : super(key: key);

  @override
  State<Policy_details> createState() => _Policy_detailsState();
}

class _Policy_detailsState extends State<Policy_details> {
  bool isChecked = false;
  bool isChecked2 = false;
  bool decline = false;
  bool accept = true;

  @override
  Widget build(BuildContext context) {
    Future<bool> onBackPress() {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return CreateAccount();
      },));
      return Future.value(false);
    }
    return WillPopScope(
        onWillPop: () => onBackPress(),
    child: Scaffold(
      backgroundColor: Colorr.themcolor50,
      appBar: CustomWidgets.appbar(title: "Terms And Privacy Policy",action:  [
      ],context:  context,onTap: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return CreateAccount();
        },));
      },),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Center(
                  child: Image.asset(
                "images/policyLogo.webp",
                height: 120,
              )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 15, bottom: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "1.Terms and Conditions",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontFamily: "Poppins",
                        color: Colorr.themcolor,
                        fontSize: 18,
                        fontWeight: FWeight.fW600),
                  ),
                  Text(
                    "Don't misuse our Services. You may use\nour Services only as permitted by law,\nincluding applicable export and re-\nexport control laws and regulations.\nWe may suspend or stop providing\nour Services to you if you do not comply\nwith our terms or policies or if we are\ninvestigating suspected misconduct.",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontFamily: "PoppinsR",
                        color: Colorr.themcolor,
                        fontSize: 15,
                        fontWeight: FWeight.fW400),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 15, bottom: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "2. Privacy Policy",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontFamily: "Poppins",
                        color: Colorr.themcolor,
                        fontSize: 18,
                        fontWeight: FWeight.fW600),
                  ),
                  Text(
                    "Don't misuse our Services. You may use\nour Services only as permitted by law,\nincluding applicable export and re-\nexport control laws and regulations.\nexport control laws and regulations.",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontFamily: "PoppinsR",
                        color: Colorr.themcolor,
                        fontSize: 15,
                        fontWeight: FWeight.fW400),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text.rich(
                            TextSpan(
                                text: "I agree with the ",
                                style: TextStyle(
                                    fontFamily: "PoppinsR",
                                    color: Colorr.themcolor,
                                    fontSize: 14,
                                    fontWeight: FWeight.fW400),
                                children: [
                                  TextSpan(
                                    text: "Terms and conditions",
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        color: Colorr.themcolor,
                                        fontSize: 14,
                                        fontWeight: FWeight.fW400),
                                  )
                                ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text.rich(
                            TextSpan(
                                text: "I agree with the ",
                                style: TextStyle(
                                    fontFamily: "PoppinsR",
                                    color: Colorr.themcolor,
                                    fontSize: 14,
                                    fontWeight: FWeight.fW400),
                                children: [
                                  TextSpan(
                                    text: "Privacy Policy",
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        color: Colorr.themcolor,
                                        fontSize: 14,
                                        fontWeight: FWeight.fW400),
                                  )
                                ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            (isChecked || isChecked2)
                ? Padding(
                    padding: const EdgeInsets.only(
                        left: 15, right: 15, top: 20, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              decline = true;
                              accept = false;
                            });
                            isChecked2 = false;
                            isChecked = false;
                          },
                          child: Container(
                            height: 40,
                            width: 150,
                            decoration: BoxDecoration(
                                color: decline
                                    ? Colorr.themcolor
                                    : Colorr.themcolor50,
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                    color: Colorr.themcolor, width: 1.50)),
                            child: Center(
                              child: Text(
                                "Decline",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontFamily: "PoppinsM",
                                    color: decline
                                        ? Colorr.White
                                        : Colorr.themcolor,
                                    fontSize: 16,
                                    fontWeight: FWeight.fW500),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              decline = false;
                              accept = true;
                            });
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 40,
                            width: 150,
                            decoration: BoxDecoration(
                                color: accept
                                    ? Colorr.themcolor
                                    : Colorr.themcolor50,
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                    color: Colorr.themcolor, width: 1.50)),
                            child: Center(
                              child: Text(
                                "Accept",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontFamily: "PoppinsM",
                                    color: accept
                                        ? Colorr.White
                                        : Colorr.themcolor,
                                    fontSize: 16,
                                    fontWeight: FWeight.fW500),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    ));
  }
}
