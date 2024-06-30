import 'package:attendy/A_SQL_Trigger/Con_Usermast.dart';
import 'package:attendy/Screens/SetupFace.dart';
import 'package:attendy/utils/Constant/Colors.dart';
import 'package:attendy/utils/Constant/FontWeight.dart';
import 'package:attendy/Screens/Dialog_box/theme_dialog.dart';
import 'package:attendy/utils/Constant/LocalCustomWidgets.dart';
import 'package:attendy/view/Dashboard/Dashboard.dart';
import 'package:flutter/material.dart';

import '../Profile/EmployeeProfileScreen.dart';
import '../UiScreen/DrawerScreens/LanguageScreen.dart';
import '../UiScreen/DrawerScreens/NotificationSoundScreen.dart';
import '../UiScreen/DrawerScreens/VersionDetailScreen.dart';

class SettingsDetailScreen extends StatefulWidget {
  const SettingsDetailScreen({Key? key}) : super(key: key);

  @override
  State<SettingsDetailScreen> createState() => _SettingsDetailScreenState();
}

class _SettingsDetailScreenState extends State<SettingsDetailScreen> {
  bool isupdate = false;

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
      appBar: CustomWidgets.appbar(title: "Settings",action:  [
      ],context:  context,onTap: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return Dashboard();
        },));
      },),
      backgroundColor: Colorr.White,
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EmployeeProfileScreen()));
            },
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 5),
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colorr.themcolor100,
                  blurStyle: BlurStyle.outer,
                  blurRadius: 8,
                ),
              ]),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CustomWidgets.width(MediaQuery.of(context).size.width/22),
                         Icon(
                          Icons.account_circle,
                          size: 60,
                          color: Colorr.themcolor,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${Constants_Usermast.name}",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontFamily: "PoppinsM",
                                  color: Colorr.themcolor,
                                  fontSize: 18,
                                  fontWeight: FWeight.fW400
                              ),
                            ),
                            Text(
                              "India",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontFamily: "PoppinsM",
                                  color: Colorr.themcolor500,
                                  fontSize: 16,
                                  fontWeight: FWeight.fW400),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 5),
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colorr.themcolor100,
                  blurStyle: BlurStyle.outer,
                  blurRadius: 8,
                ),
              ]),
              child:Column(children: [
                listOptionButton(() {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return SetUpFaceScreen(isupdate);
                  },));
                }, "images/account.webp", "Account"),
                listOptionButton(() {}, "images/employees.webp", "Employees"),
                listOptionButton(() {
                  showDialog(
                    context: context,
                    builder: (context) => const ThemeDialog(),
                  );
                }, "images/themes.webp", "Theme"),
                listOptionButton(() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LanguageScreen()));
                }, "images/languages.webp", "Language"),
                listOptionButton(() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NotificationScreen()));
                }, "images/notifications.webp", "Notification Sound"),
                listOptionButton(() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const VersionDetailScreen()));
                }, "images/version.webp", "Version"),
                listOptionButton(() {}, "images/about.webp", "About"),
              ]),
            ),
          )
        ],
      ),
    ));
  }

  Widget listOptionButton(
    void Function() onTap,
    String image,
    String text,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: Colorr.White,
        padding: EdgeInsets.only(left: 10,top: 5),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(13.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        image, height: 25,color: Colorr.themcolor,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: CustomWidgets.poppinsText(
                            text, Colorr.themcolor500, 16, FWeight.fW500),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colorr.themcolor,
                    size: 20,
                  ),
                ],
              ),
            ),
           Padding(padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/6.5),
             child:  Divider(
               thickness: 1,
               color:Colorr.themcolor,
             ),

           )
          ],
        ),
      ),
    );
  }
}
