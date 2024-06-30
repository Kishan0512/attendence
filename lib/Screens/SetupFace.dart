import 'package:attendy/A_SQL_Trigger/Con_Usermast.dart';
import 'package:flutter/material.dart';
import 'package:attendy/utils/Constant/Colors.dart';
import 'package:attendy/utils/Constant/FontWeight.dart';
import '../utils/Constant/LocalCustomWidgets.dart';
import '../view/Dashboard/Dashboard.dart';
import '../view/UiScreen/MainScreen.dart';
import 'DrawerOnly/Scan_Face.dart';

class SetUpFaceScreen extends StatefulWidget {
  bool? isupdate;

  SetUpFaceScreen([this.isupdate]);

  @override
  State<SetUpFaceScreen> createState() => _SetUpFaceScreenState();
}

class _SetUpFaceScreenState extends State<SetUpFaceScreen>
    with SingleTickerProviderStateMixin {
  var size, height, width;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      backgroundColor: Colorr.themcolor,
      appBar: CustomWidgets.appbar(
        title: (widget.isupdate != null)
            ? "Update face attendance"
            : "Set up face attendance",
        action: [],
        context: context,
        onTap: () {
          Navigator.pop(context);
        },
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50)),
                color: Colorr.themcolor50,
              ),
              child: Column(

                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: height * 0.08,
                      ),
                      Image.asset(
                        "images/facescane.webp",
                        height: height * 0.380,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          "Scan your face for Attendance",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: "PoppinsR",
                              color: Colorr.themcolor,
                              fontSize: 18,
                              fontWeight: FWeight.fW400),
                        ),
                      ),
                    ],
                  ),
                  // SizedBox(
                  //   height: height * 0.2,
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: CustomWidgets.button(
                      buttonTitle: "Get Started",
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return Scan_Face();
                          },
                        ));
                      },
                      color: Colorr.themcolor,
                      textColor: Colorr.White,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
