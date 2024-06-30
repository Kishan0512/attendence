import 'package:attendy/A_SQL_Trigger/Con_List.dart';
import 'package:attendy/A_SQL_Trigger/Con_Usermast.dart';
import 'package:attendy/Screens/Log_in.dart';
import 'package:attendy/utils/Constant/Colors.dart';
import 'package:attendy/utils/Constant/FontWeight.dart';
import 'package:attendy/utils/Constant/swipe_button.dart';
import 'package:attendy/view/Dashboard/Dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../A_SQL_Trigger/SharePref.dart';
import '../A_SQL_Trigger/api_page.dart';
import '../A_SQL_Trigger/subscription_api.dart';
import '../view/Subscription/Subscriptions.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  var size, height, width;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SharedPref.SyncUserData();
    Navigat();
  }

  Navigat() async {
    Constants_Usermast.Login =
        await SharedPref.read_bool(SrdPrefkey.login.toString()) ?? false;
    if (Constants_Usermast.Login) {
      Future.delayed(Duration(seconds: 2)).then(
        (value) async {
          List temp= await Subscription_api.Subscription_select();
          if(temp.isEmpty)
          {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Subscriptions()));
          }else{
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Dashboard()));
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Constants_Usermast.IOS == true
        ? CupertinoPageScaffold(
            child: Container(
            height: height,
            width: width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    "images/background.webp",
                  ),
                  fit: BoxFit.cover),
            ),
            child: Column(
              children: [
                Container(
                  child: Column(
                    children: [
                      Constants_Usermast.name.isNotEmpty
                          ? SizedBox(
                              height: height / 6,
                            )
                          : SizedBox(
                              height: height / 10,
                            ),
                      Container(
                        height: height / 3,
                        child: Image.asset(
                          "images/first-page-webp.webp",
                        ),
                      ),
                      Constants_Usermast.name.isNotEmpty
                          ? SizedBox(
                              height: height / 13,
                            )
                          : SizedBox(height: height / 17),
                      Container(
                        height: height / 3,
                        child: Column(
                          children: [
                            Text(
                              "Track Your Attendance",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: Colorr.White,
                                  fontSize: width * 0.07,
                                  fontWeight: FWeight.fW600),
                            ),
                            Text(
                              "Application",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: Colorr.White,
                                  fontSize: width * 0.07,
                                  fontWeight: FWeight.fW600),
                            ),
                            SizedBox(
                              height: height * 0.02,
                            ),
                            Text(
                              "Attendy allow you to track exact Student and",
                              style: TextStyle(
                                  fontFamily: "PoppinsR",
                                  color: Colorr.White,
                                  fontSize: 14,
                                  fontWeight: FWeight.fW400),
                            ),
                            Text(
                              "Distributed workforce work hours and time off ",
                              style: TextStyle(
                                  fontFamily: "PoppinsR",
                                  color: Colorr.White,
                                  fontSize: 14,
                                  fontWeight: FWeight.fW400),
                            ),
                            Text(
                              "easily with the help of face recognition",
                              style: TextStyle(
                                  fontFamily: "PoppinsR",
                                  color: Colorr.White,
                                  fontSize: 14,
                                  fontWeight: FWeight.fW400),
                            ),
                            Text(
                              "attendance system so that you can confidently",
                              style: TextStyle(
                                  fontFamily: "PoppinsR",
                                  color: Colorr.White,
                                  fontSize: 14,
                                  fontWeight: FWeight.fW400),
                            ),
                            Text(
                              "pay your staff accurately.",
                              style: TextStyle(
                                  fontFamily: "PoppinsR",
                                  color: Colorr.White,
                                  fontSize: 14,
                                  fontWeight: FWeight.fW400),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Constants_Usermast.Login
                    ? Container()
                    : SizedBox(
                        height: height / 10,
                      ),
                Constants_Usermast.Login
                    ? Container()
                    : Padding(
                        padding: EdgeInsets.only(
                            left: 15, right: 15, top: 7, bottom: 10),
                        child: SwipeButton.expand(
                          height: height / 20,
                          trackPadding: const EdgeInsets.only(
                              left: 1, right: 1, top: 1, bottom: 1),
                          thumb: Center(
                            child: Text(
                              "Get Started",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: Colorr.White,
                                  fontSize: 16,
                                  fontWeight: FWeight.fW600),
                            ),
                          ),
                          activeThumbColor: Colorr.themcolor,
                          activeTrackColor: Colorr.themcolor50,
                          onSwipeEnd: () {
                            Future.delayed(
                              Duration(milliseconds: 500),
                              () async {
                                if (Constants_Usermast.sId.isEmpty) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Log_in()));
                                } else {
                                  Con_List.Drawer =
                                      await api_page.PagepermissionApi();
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Dashboard()));
                                }
                              },
                            );
                          },
                          child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    ">",
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        color: Colorr.themcolor100,
                                        fontSize: 27,
                                        fontWeight: FWeight.fW200),
                                  ),
                                  Text(
                                    ">",
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        color: Colorr.themcolor200,
                                        fontSize: 27,
                                        fontWeight: FWeight.fW400),
                                  ),
                                  Text(
                                    ">",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      color: Colorr.themcolor300,
                                      fontSize: 27,
                                    ),
                                  ),
                                  Text(
                                    ">",
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        color: Colorr.themcolor,
                                        fontSize: 27,
                                        fontWeight: FWeight.fW800),
                                  ),
                                ],
                              )),
                        ),
                      ),
              ],
            ),
          ))
        : Scaffold(
            body: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      "images/background.webp",
                    ),
                    fit: BoxFit.cover),
              ),
              child: Column(
                children: [
                  Constants_Usermast.name.isNotEmpty
                      ? SizedBox(
                          height: height / 6,
                        )
                      : SizedBox(
                          height: height / 10,
                        ),
                  Container(
                    height: height / 3,
                    child: Image.asset(
                      "images/first-page-webp.webp",
                    ),
                  ),
                  Constants_Usermast.name.isNotEmpty
                      ? SizedBox(
                          height: height / 17,
                        )
                      : SizedBox(height: height / 17),
                  Container(
                    height: height / 3,
                    child: Column(
                      children: [
                        Text(
                          "Track Your Attendance",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              color: Colorr.White,
                              fontSize: width * 0.07,
                              fontWeight: FWeight.fW600),
                        ),
                        Text(
                          "Application",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              color: Colorr.White,
                              fontSize: width * 0.07,
                              fontWeight: FWeight.fW600),
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Text(
                          "Attendy allow you to track exact Student and",
                          style: TextStyle(
                              fontFamily: "PoppinsR",
                              color: Colorr.White,
                              fontSize: 14,
                              fontWeight: FWeight.fW400),
                        ),
                        Text(
                          "Distributed workforce work hours and time off ",
                          style: TextStyle(
                              fontFamily: "PoppinsR",
                              color: Colorr.White,
                              fontSize: 14,
                              fontWeight: FWeight.fW400),
                        ),
                        Text(
                          "easily with the help of face recognition",
                          style: TextStyle(
                              fontFamily: "PoppinsR",
                              color: Colorr.White,
                              fontSize: 14,
                              fontWeight: FWeight.fW400),
                        ),
                        Text(
                          "attendance system so that you can confidently",
                          style: TextStyle(
                              fontFamily: "PoppinsR",
                              color: Colorr.White,
                              fontSize: 14,
                              fontWeight: FWeight.fW400),
                        ),
                        Text(
                          "pay your staff accurately.",
                          style: TextStyle(
                              fontFamily: "PoppinsR",
                              color: Colorr.White,
                              fontSize: 14,
                              fontWeight: FWeight.fW400),
                        ),
                      ],
                    ),
                  ),
                  Constants_Usermast.Login ? Container() : Spacer(),
                  if (Constants_Usermast.Login)
                    Container(
                      height: 0,
                    )
                  else
                    Padding(
                      padding: EdgeInsets.only(
                          left: 15, right: 15, top: 7, bottom: 10),
                      child: SwipeButton.expand(
                        height: height / 20,
                        trackPadding: const EdgeInsets.only(
                            left: 1, right: 1, top: 1, bottom: 1),
                        thumb: Center(
                          child: Text(
                            "Get Started",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                color: Colorr.White,
                                fontSize: 16,
                                fontWeight: FWeight.fW600),
                          ),
                        ),
                        activeThumbColor: Colorr.themcolor,
                        activeTrackColor: Colorr.themcolor50,
                        onSwipeEnd: () {
                          Future.delayed(
                            Duration(milliseconds: 500),
                            () async {
                              if (Constants_Usermast.sId.isEmpty) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Log_in()));
                              } else {
                                Con_List.Drawer =
                                    await api_page.PagepermissionApi();
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Dashboard()));
                              }
                            },
                          );
                        },
                        child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  ">",
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      color: Colorr.themcolor100,
                                      fontSize: 27,
                                      fontWeight: FWeight.fW200),
                                ),
                                Text(
                                  ">",
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      color: Colorr.themcolor200,
                                      fontSize: 27,
                                      fontWeight: FWeight.fW400),
                                ),
                                Text(
                                  ">",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    color: Colorr.themcolor300,
                                    fontSize: 27,
                                  ),
                                ),
                                Text(
                                  ">",
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      color: Colorr.themcolor,
                                      fontSize: 27,
                                      fontWeight: FWeight.fW800),
                                ),
                              ],
                            )),
                      ),
                    ),
                  Container(
                    height: height / 40,
                  )
                ],
              ),
            ),
          );
  }
}
