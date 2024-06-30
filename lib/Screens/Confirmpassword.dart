import 'package:attendy/Screens/Log_in.dart';
import 'package:flutter/material.dart';

import '../A_SQL_Trigger/api_page.dart';
import '../utils/Constant/Colors.dart';
import '../utils/Constant/FontWeight.dart';
import '../utils/Constant/LocalCustomWidgets.dart';
import 'OtpScreen.dart';

class Confrmpass extends StatefulWidget {
  List<dynamic> Data=[];

  Confrmpass(this.Data);

  @override
  State<Confrmpass> createState() => _ConfrmpassState();
}

class _ConfrmpassState extends State<Confrmpass> {
  var size, height, width;
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();
  bool visivility = true;
  bool visivility1 = true;
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtcnfPassword = TextEditingController();
  bool v1 = false, v2 = false, v3 = false, v4 = false, v5 = false;
  RegExp lowerCaseLetters = RegExp(r'[a-z]');
  RegExp upperCaseLetters = RegExp(r'[A-Z]');
  RegExp numbers = RegExp(r'[0-9]');
  RegExp specialCharacter = RegExp(r'[!@#$%^&*]');

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colorr.themcolor,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 150),
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50)),
                color: Colorr.themcolor50,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 23),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: height * 0.10,
                      ),
                      Center(
                        child: Text(
                          'Enter Your New Password',
                          style: TextStyle(
                              fontFamily: "Poppins",
                              color: Colorr.themcolor400,
                              fontSize: 18,
                              fontWeight: FWeight.fW400),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      CustomWidgets.textFieldWithBoxShadow(
                        Onchanged: (value) {
                          setState(() {
                            if (!upperCaseLetters.hasMatch(value)) {
                              v1 = true;
                              v2 = false;
                              v3 = false;
                              v4 = false;
                              v5 = false;
                            } else if (!lowerCaseLetters
                                .hasMatch(value)) {
                              v2 = true;
                              v1 = false;
                              v3 = false;
                              v4 = false;
                              v5 = false;
                            } else if (!numbers.hasMatch(value)) {
                              v3 = true;
                              v2 = false;
                              v1 = false;
                              v4 = false;
                              v5 = false;
                            } else if (!specialCharacter
                                .hasMatch(value)) {
                              v2 = false;
                              v3 = false;
                              v4 = false;
                              v1 = false;
                              v5 = true;
                            } else if (txtPassword.text.length < 6) {
                              v4 = true;
                              v2 = false;
                              v3 = false;
                              v1 = false;
                              v5 = false;
                            } else {
                              v1 = false;
                              v2 = false;
                              v3 = false;
                              v4 = false;
                              v5 = false;
                            }
                          });
                        },
                        context: context,
                        focusNode: _focusNode3,
                        hintText: "New Password",
                        controller: txtPassword,
                        obscureText: visivility,
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                visivility = !visivility;
                              });
                            },
                            icon: Icon(
                              visivility
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Colorr.themcolor200,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: Row(
                          children: [
                            v1 == false &&
                                v2 == false &&
                                v3 == false &&
                                v4 == false &&
                                v5 == false
                                ? Container()
                                : v1
                                ? const Text(
                              "Enter atleast one upperCase letter",
                              style: TextStyle(
                                  color: Colors.red),
                            )
                                : v2
                                ?const Text(
                                "Enter atleast one lowerCase letter",
                                style: TextStyle(
                                    color: Colors.red))
                                : v3
                                ?const Text(
                                "Enter atleast one number",
                                style: TextStyle(
                                    color: Colors.red))
                                : v4
                                ? const Text(
                                "Enter minimum 6 character",
                                style: TextStyle(
                                    color:
                                    Colors.red))
                                : const Text(
                                "Enter atleast one special character",
                                style: TextStyle(
                                    color: Colors
                                        .red)),
                          ],
                        ),
                      ),

                      CustomWidgets.textFieldWithBoxShadow(
                        context: context,
                        focusNode: _focusNode4,
                        hintText: "Confirm Password",
                        controller: txtcnfPassword,
                        obscureText: visivility1,
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                visivility1 = !visivility1;
                              });
                            },
                            icon: Icon(
                              visivility1
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Colorr.themcolor200,
                            )),
                      ),
                      SizedBox(
                        height: height * 0.04,
                      ),
                      CustomWidgets.swipeButton(Colorr.White, "Confirm Password", () async {
                        Unfocus();
                        if(!v1 && !v2 && !v3 && !v4 && !v5 && txtPassword.text == txtcnfPassword.text)
                          {
                      Map Data =  {
                          // "name" : widget.Data[0]['name'],
                        // "email" : widget.Data[0]['email'],
                        // "company_id" : widget.Data[0]['company_id'],
                        // "phone" :  widget.Data[0]['phone'].toString(),
                        // "isActive" : widget.Data[0]['isActive'].toString(),
                        "password" : txtPassword.text,
                        // "roleId" : widget.Data[0]['roleId'],
                        "id": widget.Data[0]['_id'],
                        // "employeeId" :  widget.Data[0]['employeeId']
                      };
                      if(await api_page.userupdate(Data))
                        {
                          CustomWidgets.showToast(context, "Password Update Successfully",true);
                          Future.delayed(Duration(seconds: 2),() {
                            return Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                              return Log_in();
                            },));
                          },
                          );
                        }else{
                        CustomWidgets.showToast(context, "Password Not Update",false);
                      }
                          }
                      }),
                      SizedBox(
                        height: height * 0.04,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Unfocus()
  {
    _focusNode3.unfocus();
    _focusNode4.unfocus();
    setState(() {
    });
  }
}
