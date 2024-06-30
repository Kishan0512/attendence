import 'package:attendy/utils/Constant/LocalCustomWidgets.dart';
import 'package:attendy/utils/Constant/Colors.dart';
import 'package:attendy/utils/Constant/FontWeight.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class AddYear extends StatefulWidget {
  const AddYear({Key? key}) : super(key: key);

  @override
  State<AddYear> createState() => _AddYearState();
}

class _AddYearState extends State<AddYear> {
  TextEditingController txtYear = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colorr.themcolor50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      contentPadding: const EdgeInsets.all(0.0),
      content: SizedBox(
        height: 250,
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
                        topRight: Radius.circular(20),
                      ),
                      color: Colorr.themcolor),
                  child: Center(
                    child: Text(
                      "Add Year",
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
            Column(
              children: <Widget>[
                Padding(
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, top: 20),
                    child: Column(children: [
                      Container(
                        height: 50,
                        width: 100,
                        padding: const EdgeInsets.only(
                          left: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colorr.themcolor50,
                          boxShadow: [
                            BoxShadow(
                              color: Colorr
                                  .themcolor200, // Change color of the shadow
                              blurRadius: 5,
                              spreadRadius: 0.5,
                              offset: const Offset(3.0, 4.0),
                            )
                          ],
                          borderRadius: BorderRadius.circular(60),
                          border: Border.all(
                            width: 2,
                            color: Colorr.themcolor,
                          ),
                        ),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: txtYear,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(4),
                          ],
                          style: TextStyle(
                              fontFamily: "PoppinsR",
                              color: Colorr.themcolor500,
                              fontSize: 18,
                              fontWeight: FWeight.fW400),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 1, horizontal: 15),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none),
                            hintText: "Add Year",
                            hintStyle: TextStyle(
                                fontFamily: "PoppinsR",
                                color: Colorr.themcolor600,
                                fontSize: 18,
                                fontWeight: FWeight.fW400),
                          ),
                        ),
                      ),
                      /*  Container(
                        height: 50,
                        width: 100.w,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colorr.Transparent, width: 1),
                            color: Colorr.White,
                            borderRadius: BorderRadius.circular(40)),
                        child: TextField(
                          style: TextStyle(color: Colorr.themcolor300),
                          keyboardType: TextInputType.number,
                          controller: txtYear,
                          onChanged: (value) {},
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: BorderSide(
                                color: Colorr.themcolor300,
                                width: 2,
                              ),
                            ),
                            hintText: "Add Year",
                            labelStyle: TextStyle(
                                fontFamily: "PoppinsR",
                                color: Colorr.White,
                                fontSize: 18,
                                fontWeight: FWeight.fW400),
                            hintStyle: TextStyle(
                                fontFamily: "PoppinsR",
                                color: Colorr.themcolor600,
                                fontSize: 18,
                                fontWeight: FWeight.fW400),
                            border: InputBorder.none
                            ),
                          ),
                        ),
                      ),*/
                      /*CustomWidgets.container(
                        child: */
                      /*TextFormField(
                        decoration: InputDecoration(
                            border: InputBorder.none, hintText: "Enter Year",),
                      ) */
                      /*
                            CustomWidgets.textField(
                                // textHeight: 2.7,
                                paddingLeft: 15,
                                hintText: "Enter Year",
                                borderSide: BorderSide.none,
                                enabledBorder: BorderSide.none),
                      ),*/
                      CustomWidgets.button(
                          buttonTitle: "Add Year",
                          height: 50,
                          paddingLeft: 0,
                          paddingRight: 0,
                          paddingTop: 30,
                          onTap: () {},
                          color: Colorr.themcolor,
                          textColor: Colorr.White)
                    ]))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
