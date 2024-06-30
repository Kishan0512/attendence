import 'package:attendy/A_SQL_Trigger/Con_List.dart';
import 'package:attendy/A_SQL_Trigger/Con_Usermast.dart';
import 'package:attendy/Screens/Log_in.dart';
import 'package:attendy/utils/Constant/Colors.dart';
import 'package:attendy/utils/Constant/FontWeight.dart';
import 'package:attendy/utils/Constant/LocalCustomWidgets.dart';
import 'package:flutter/material.dart';

import '../../A_SQL_Trigger/Notification_api.dart';
import '../../A_SQL_Trigger/SharePref.dart';

class LogoutDialog extends StatefulWidget {
  const LogoutDialog({Key? key}) : super(key: key);

  @override
  State<LogoutDialog> createState() => _LogoutDialogState();
}

class _LogoutDialogState extends State<LogoutDialog> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height - kToolbarHeight;
    double width = MediaQuery.of(context).size.width;
    return AlertDialog(
      backgroundColor: Colorr.themcolor50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding: const EdgeInsets.all(0.0),
      content: SizedBox(
        height: height / 3.9,
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: height/15,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      color: Colorr.themcolor),
                  child: Center(
                    child: Text(
                      "Logout",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          color: Colorr.White,
                          fontSize: width*0.045,
                          fontWeight: FWeight.fW600),
                    ),
                  ),
                ),
                Positioned(
                  top: -10,
                  right: -10,
                  child: IconButton(
                     iconSize: height/35,
                    splashRadius: 18,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.highlight_remove, color: Colorr.White),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 15),
              child: Center(
                child: Text(
                  "Are you sure you want to\n Logout ?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "PoppinsM",
                      color: Colorr.themcolor,
                      fontSize: 18,
                      fontWeight: FWeight.fW500),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomWidgets.confirmButton(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    height: height / 20,
                    width: width / 3.3,
                    text: "No"),
                CustomWidgets.confirmButton(
                    onTap: () {
                      Constants_Usermast.BlankCaller();
                      SrdPrefkey.KeyClear.forEach((e) => SharedPref.remove(e));
                      Notification_Api.NotificationSelect("true");
                      setState(() {});
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Log_in()));
                    },
                    height: height / 20,
                    width: width / 3.3,
                    text: "Yes"),

              ],
            )
          ],
        ),
      ),
    );
  }
}
