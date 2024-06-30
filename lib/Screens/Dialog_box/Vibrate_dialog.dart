import 'package:attendy/utils/Constant/LocalCustomWidgets.dart';
import 'package:flutter/material.dart';
import 'package:attendy/utils/Constant/Colors.dart';
import 'package:attendy/utils/Constant/FontWeight.dart';

class Vibrate_dialog extends StatefulWidget {
  const Vibrate_dialog({Key? key}) : super(key: key);

  @override
  State<Vibrate_dialog> createState() => _Vibrate_dialogState();
}

enum Theme { Off, Default, Short, Long }

class _Vibrate_dialogState extends State<Vibrate_dialog> {
  Theme? Vibrate = Theme.Short;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colorr.themcolor50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      contentPadding: const EdgeInsets.all(0.0),
      content: SizedBox(
        height: 360,
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 70,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      color: Colorr.themcolor),
                  child: Center(
                    child: Text(
                      "Vibrate",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          color: Colorr.White,
                          fontSize: 20,
                          fontWeight: FWeight.fW600),
                    ),
                  ),
                ),
                Positioned(
                  top: -3,
                  right: -3,
                  child: IconButton(
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
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      Radio<Theme>(
                        activeColor: Colorr.themcolor,
                        toggleable: true,
                        value: Theme.Off,
                        groupValue: Vibrate,
                        onChanged: (Theme? value) {
                          setState(() {
                            Vibrate = value;
                          });
                        },
                      ),
                      Text(
                        "Off",
                        style: TextStyle(
                            fontFamily: "PoppinsM",
                            color: Colorr.themcolor,
                            fontSize: 18,
                            fontWeight: FWeight.fW500),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Radio<Theme>(
                        activeColor: Colorr.themcolor,
                        value: Theme.Default,
                        groupValue: Vibrate,
                        onChanged: (Theme? value) {
                          setState(() {
                            Vibrate = value;
                          });
                        },
                      ),
                      Text(
                        "Default",
                        style: TextStyle(
                            fontFamily: "PoppinsM",
                            color: Colorr.themcolor,
                            fontSize: 18,
                            fontWeight: FWeight.fW500),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Radio<Theme>(
                        activeColor: Colorr.themcolor,
                        value: Theme.Short,
                        groupValue: Vibrate,
                        onChanged: (Theme? value) {
                          setState(() {
                            Vibrate = value;
                          });
                        },
                      ),
                      Text(
                        "Short",
                        style: TextStyle(
                            fontFamily: "PoppinsM",
                            color: Colorr.themcolor,
                            fontSize: 18,
                            fontWeight: FWeight.fW500),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Radio<Theme>(
                        activeColor: Colorr.themcolor,
                        value: Theme.Long,
                        groupValue: Vibrate,
                        onChanged: (Theme? value) {
                          setState(() {
                            Vibrate = value;
                          });
                        },
                      ),
                      Text(
                        "Long",
                        style: TextStyle(
                            fontFamily: "PoppinsM",
                            color: Colorr.themcolor,
                            fontSize: 18,
                            fontWeight: FWeight.fW500),
                      )
                    ],
                  ),
                ],
              ),
            ),
            CustomWidgets.button(
                buttonTitle: "Save",
                onTap: () {
                  if (Theme.Long == Vibrate) {}
                },
                textColor: Colorr.White,
                color: Colorr.themcolor,
                height: 50)
          ],
        ),
      ),
    );
  }
}
