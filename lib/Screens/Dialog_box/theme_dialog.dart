import 'package:attendy/utils/Constant/LocalCustomWidgets.dart';
import 'package:flutter/material.dart';
import 'package:attendy/utils/Constant/Colors.dart';
import 'package:attendy/utils/Constant/FontWeight.dart';

class ThemeDialog extends StatefulWidget {
  const ThemeDialog({Key? key}) : super(key: key);

  @override
  State<ThemeDialog> createState() => _ThemeDialogState();
}

enum Theme { Default, Light, Dark }

class _ThemeDialogState extends State<ThemeDialog> {
  Theme? _fruit = Theme.Default;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colorr.themcolor50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      contentPadding: const EdgeInsets.all(0.0),
      content: SizedBox(
        height: 310,
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
                  child: CustomWidgets.poppinsText(
                      "Select Theme", Colors.white, 15, FWeight.fW600),
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
                        value: Theme.Default,
                        groupValue: _fruit,
                        onChanged: (Theme? value) {
                          setState(() {
                            _fruit = value;
                          });
                        },
                      ),
                      Text(
                        "System Default",
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
                        value: Theme.Light,
                        groupValue: _fruit,
                        onChanged: (Theme? value) {
                          setState(() {
                            _fruit = value;
                          });
                        },
                      ),
                      Text(
                        "Light",
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
                        value: Theme.Dark,
                        groupValue: _fruit,
                        onChanged: (Theme? value) {
                          setState(() {
                            _fruit = value;
                          });
                        },
                      ),
                      Text(
                        "Dark",
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
                onTap: () {},
                textColor: Colorr.White,
                color: Colorr.themcolor,
                height: 50)
          ],
        ),
      ),
    );
  }
}
