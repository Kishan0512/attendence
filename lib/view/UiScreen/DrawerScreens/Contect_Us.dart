import 'package:attendy/utils/Constant/Colors.dart';
import 'package:attendy/utils/Constant/FontWeight.dart';
import 'package:attendy/utils/Constant/LocalCustomWidgets.dart';
import 'package:flutter/material.dart';

import '../../Dashboard/Dashboard.dart';

class Contect_Us extends StatefulWidget {
  const Contect_Us({Key? key}) : super(key: key);

  @override
  State<Contect_Us> createState() => _Contect_UsState();
}

class _Contect_UsState extends State<Contect_Us> {
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
      appBar: CustomWidgets.appbar(title: "Contact Us",action:  [
      ],context:  context,onTap: () {
        Navigator.pop(context);
      },),
      body: Column(
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    color: Colorr.White,
                    child: CustomWidgets.textField(
                        height: 50,
                        maxLines: 8,
                        borderSide: BorderSide.none,
                        hintText: "Tell us how we can help",
                        enabledBorder: BorderSide.none),
                  ),
                  Container(
                    height: 3,
                    color: Colorr.themcolor,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      "We will respond to you within\n 24 hours .",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontFamily: "PoppinsR",
                          color: Colorr.themcolor,
                          fontSize: 18,
                          fontWeight: FWeight.fW400),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: CustomWidgets.button(
                buttonTitle: "Next",
                onTap: () {},
                color: Colorr.themcolor,
                textColor: Colorr.White),
          )
        ],
      ),
    ));
  }
}
