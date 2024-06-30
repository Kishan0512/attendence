import 'package:attendy/view/Dashboard/Dashboard.dart';
import 'package:flutter/material.dart';

import 'package:attendy/utils/Constant/Colors.dart';
import 'package:attendy/utils/Constant/FontWeight.dart';
import '../utils/Constant/LocalCustomWidgets.dart';
import '../view/UiScreen/MainScreen.dart';

class FaceScanScreen extends StatefulWidget {
  const FaceScanScreen({Key? key}) : super(key: key);

  @override
  State<FaceScanScreen> createState() => _FaceScanScreenState();
}

class _FaceScanScreenState extends State<FaceScanScreen>
    with SingleTickerProviderStateMixin {
  var size, height, width;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      backgroundColor: Colorr.themcolor,
      appBar: CustomWidgets.appbar(title: "Face Scanning",action:  [],context:  context,onTap: () {
        Navigator.pop(context);
      },),
      body: Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(50), topRight: Radius.circular(50)),
            color: Colorr.themcolor50,
          ),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: height * 0.08,
                  ),
                  Image.asset(
                    "images/facescandone.webp",
                    height: height * 0.380,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      "Scan Completed",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: "Poppins",
                          color: Colorr.themcolor,
                          fontSize: 23,
                          fontWeight: FWeight.fW600),
                    ),
                  ),
                  Text(
                    "Thanks for your effort",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "PoppinsR",
                        color: Colorr.themcolor,
                        fontSize: 15,
                        fontWeight: FWeight.fW400),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: CustomWidgets.button(
                  buttonTitle: "Next",
                  onTap: () {
                    Future.delayed(const Duration(milliseconds: 500), () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Dashboard()));
                    });
                  },
                  color: Colorr.themcolor,
                  textColor: Colorr.White,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
