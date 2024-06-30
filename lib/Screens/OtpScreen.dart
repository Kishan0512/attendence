import 'package:attendy/A_SQL_Trigger/api_page.dart';
import 'package:attendy/Screens/CreateAccount.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../A_SQL_Trigger/Con_Usermast.dart';
import '../utils/Constant/Colors.dart';
import '../utils/Constant/FontWeight.dart';
import '../utils/Constant/LocalCustomWidgets.dart';
import 'Confirmpassword.dart';

class OTP extends StatefulWidget {
  List<dynamic> Data = [];

  @override
  State<OTP> createState() => _OTPState();

  OTP(this.Data);
}

class _OTPState extends State<OTP> {
  final FocusNode _focusNode = FocusNode();
  var size, height, width;
  String pStrFirstOtp = "",
      pStrSecondOtp = "",
      pStrThirdOtp = "",
      pStrFourthOtp = "",
      pStrFifthhOtp = "",
      pStrSixththOtp = "";
  int ResendInSecond = 30;
  bool resend = false;
  FocusNode f1 = FocusNode(),
      f2 = FocusNode(),
      f3 = FocusNode(),
      f4 = FocusNode(),
      f5 = FocusNode(),
      f6 = FocusNode();

  @override
  void initState() {
    super.initState();
    f1 = FocusNode();
    f2 = FocusNode();
    f3 = FocusNode();
    f4 = FocusNode();
    f5 = FocusNode();
    f6 = FocusNode();
  }
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Constants_Usermast.IOS == true
        ? CupertinoPageScaffold(
            child: Stack(
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
                            height: height * 0.09,
                          ),
                          Center(
                            child: Text(
                              "Forgot Password",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: Colorr.themcolor400,
                                  fontSize: 16,
                                  fontWeight: FWeight.fW400),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.04,
                          ),
                          CustomWidgets.swipeButton(
                              Colorr.White, "Forgot Password", () {
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ))
        : Scaffold(
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
                              height: height * 0.05,
                            ),
                            Center(
                              child: Text(
                                'The OTP has been sent to your\n registered email address.',
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    color: Colorr.themcolor400,
                                    fontSize: 18,
                                    fontWeight: FWeight.fW400),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              height: height * 0.06,
                            ),
                            Center(
                              child: Text(
                                'Please enter the OTP.',
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    color: Colorr.themcolor400,
                                    fontSize: 18,
                                    fontWeight: FWeight.fW400),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    _otpTextField(context, 0, f1),
                                    _otpTextField(context, 1, f2),
                                    _otpTextField(context, 2, f3),
                                    _otpTextField(context, 3, f4),
                                    _otpTextField(context, 4, f5),
                                    _otpTextField(context, 5, f6),
                                  ]),
                            ),
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

  Unfocus() {
    _focusNode.unfocus();
    setState(() {});
  }
  Widget _otpTextField(BuildContext context, int pInt, FocusNode _f) {
    return SizedBox(
      width: 35.0,
      height: 40.0,
      child: TextFormField(
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLines: 1,
        autofocus: true,
        focusNode: _f,
        maxLength: 1,
        decoration: const InputDecoration(
          counter: Offstage(),
        ),
        onChanged: (String val) async {
          if (pInt == 0) {
            pStrFirstOtp = val;
            FocusScope.of(context).requestFocus(f2);
            if (pStrFirstOtp.isEmpty) {
              FocusScope.of(context).requestFocus(f1);
            }
          }
          if (pInt == 1) {
            pStrSecondOtp = val;
            f2.unfocus();
            FocusScope.of(context).requestFocus(f3);
            if (pStrSecondOtp.isEmpty) {
              FocusScope.of(context).requestFocus(f1);
            }
          }
          if (pInt == 2) {
            pStrThirdOtp = val;
            f3.unfocus();
            FocusScope.of(context).requestFocus(f4);
            if (pStrThirdOtp.isEmpty) {
              FocusScope.of(context).requestFocus(f2);
            }
          }
          if (pInt == 3) {
            pStrFourthOtp = val;
            f4.unfocus();
            FocusScope.of(context).requestFocus(f5);
            if (pStrFourthOtp.isEmpty) {
              FocusScope.of(context).requestFocus(f3);
            }
          }
          if (pInt == 4) {
            pStrFifthhOtp = val;
            f5.unfocus();
            FocusScope.of(context).requestFocus(f6);
            if (pStrFifthhOtp.isEmpty) {
              FocusScope.of(context).requestFocus(f4);
            }
          }
          if (pInt == 5) {
            pStrSixththOtp = val;
            f6.unfocus();
            if (pStrSixththOtp.isEmpty) {
              FocusScope.of(context).requestFocus(f5);
            }
          }

          if (pStrFirstOtp == "" ||
              pStrSecondOtp == "" ||
              pStrThirdOtp == "" ||
              pStrFourthOtp == "" ||
              pStrFifthhOtp == "" ||
              pStrSixththOtp == "") {}

          String strOtp = pStrFirstOtp.toString() +
              pStrSecondOtp.toString() +
              pStrThirdOtp.toString() +
              pStrFourthOtp.toString() +
              pStrFifthhOtp.toString() +
              pStrSixththOtp.toString();

          if(strOtp.length==6)
            {
              if(widget.Data[0]['otp'].toString() == strOtp) {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Confrmpass(widget.Data);
                },));
              }else{
                setState(() {


                pStrFirstOtp == "";
                pStrSecondOtp == "";
                pStrThirdOtp == "";
                pStrFourthOtp == "";
                pStrFifthhOtp == "";
                pStrSixththOtp == "";
                CustomWidgets.showToast(context, "Wrong OTP", false);
                });

              }
            }

        },
      ),
    );
  }
}
