// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:attendy/A_SQL_Trigger/Con_List.dart';
import 'package:attendy/A_SQL_Trigger/Con_Usermast.dart';
import 'package:attendy/A_SQL_Trigger/LoginActivity.dart';
import 'package:attendy/Screens/CreateAccount.dart';
import 'package:attendy/Screens/SetupFace.dart';
import 'package:attendy/view/Dashboard/Dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../A_SQL_Trigger/SharePref.dart';
import '../A_SQL_Trigger/api_page.dart';
import '../A_SQL_Trigger/subscription_api.dart';
import '../utils/Constant/Colors.dart';
import '../utils/Constant/FontWeight.dart';
import '../utils/Constant/LocalCustomWidgets.dart';
import '../view/Subscription/Subscriptions.dart';
import 'Forgotpassword.dart';

class Log_in extends StatefulWidget {
  const Log_in({Key? key}) : super(key: key);

  @override
  State<Log_in> createState() => _Log_inState();
}

class _Log_inState extends State<Log_in> {
  final FocusNode _focusNode = FocusNode();
  final FocusNode _focusNode1 = FocusNode();
  TextEditingController txtname = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  var size, height, width;
  bool visivility = true;
  String System = "";
  bool _isChecked = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    prograse();
    prograseIOS();
  }

  getdata() async {
    String User = "";
    String pass = "";
    User = await SharedPref.read_string(SrdPrefkey.Username);
    pass = await SharedPref.read_string(SrdPrefkey.LoginPassword);
    setState(() {});
    if (User.isNotEmpty && pass.isNotEmpty) {
      txtname.text = User;
      txtPassword.text = pass;
      setState(() {});
    }
  }

  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    Future<bool> onBackPress() {
      SystemChannels.platform.invokeListMethod('SystemNavigator.pop');
      return Future.value(false);
    }

    return Constants_Usermast.IOS == true
        ? CupertinoPageScaffold(
            child: SafeArea(
            child: Stack(
              children: [
                Container(
                  height: height,
                  width: width,
                  color: Colorr.themcolor,
                ),
                Padding(
                  padding: EdgeInsets.only(top: height / 7),
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
                              height: height * 0.07,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Welcome",
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      color: Colorr.themcolor,
                                      fontSize: 30,
                                      fontWeight: FWeight.fW600),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: height * 0.02,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Please Sign in to continue.",
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      color: Colorr.themcolor,
                                      fontSize: 17,
                                      fontWeight: FWeight.fW600),
                                ),
                              ],
                            ),
                            CustomWidgets.textFieldWithBoxShadowIOS(
                                hintText: "Email",
                                controller: txtname,
                                obscureText: false),
                            CustomWidgets.textFieldWithBoxShadowIOS(
                              hintText: "Password",
                              controller: txtPassword,
                              obscureText: visivility,
                              suffixIcon: CupertinoButton(
                                onPressed: () {
                                  setState(() {
                                    visivility = !visivility;
                                  });
                                },
                                child: Icon(
                                  visivility
                                      ? CupertinoIcons.eye_slash
                                      : CupertinoIcons.eye,
                                  color: Colorr.themcolor200,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 30),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return Forgotpassword();
                                    },
                                  ));
                                },
                                child: Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                      fontFamily: "PoppinsM",
                                      color: Colorr.themcolor,
                                      fontSize: 14,
                                      fontWeight: FWeight.fW500),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height * 0.04,
                            ),
                            CustomWidgets.swipeButton(Colorr.White, "Log In",
                                () {
                              Future.delayed(const Duration(milliseconds: 500),
                                  () async {
                                if (txtname.text.trim().isEmpty) {
                                  CustomWidgets.showToast(
                                      context, "Username is required", false);
                                } else if (txtPassword.text.trim().isEmpty) {
                                  CustomWidgets.showToast(
                                      context, "Password is required", false);
                                } else {
                                  if (await api_page.logincheck(txtname.text,
                                      txtPassword.text, "", "", "log_in")) {
                                    if (_isChecked == true) {
                                      SharedPref.save_string(
                                          SrdPrefkey.Username.toString(),
                                          txtname.text);
                                      SharedPref.save_string(
                                          SrdPrefkey.LoginPassword.toString(),
                                          txtPassword.text);
                                    }
                                    try {
                                      LoginActivity.getIPGeolocation();
                                      SharedPref.SyncUserData();
                                      prograseIOS();
                                      await Future.delayed(Duration(seconds: 3))
                                          .then((value) {
                                        DateTime now = DateTime.now();
                                        if (Constants_Usermast.FaceID.isEmpty) {
                                          getSystemInfo(now.toString());
                                          Navigator.pushReplacement(
                                              context,
                                              CupertinoPageRoute(
                                                  builder: (context) =>
                                                      SetUpFaceScreen()));
                                        } else {
                                          getSystemInfo(now.toString());
                                          Navigator.pushReplacement(
                                              context,
                                              CupertinoPageRoute(
                                                  builder: (context) =>
                                                      Dashboard()));
                                        }
                                      });

                                      return true; // add this line
                                    } catch (e) {
                                      // handle error
                                    }
                                  } else {
                                    CustomWidgets.showToast(
                                        context, "User not found", false);
                                  }
                                }
                              });
                            }),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, CupertinoPageRoute(
                                      builder: (context) {
                                        return CreateAccount();
                                      },
                                    ));
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Don’t have an account? Sign Up",
                                        style: TextStyle(
                                            color: Colorr.themcolor,
                                            fontSize: 12,
                                            fontWeight: FWeight.fW100),
                                      ),
                                      Text(
                                        "Sign Up",
                                        style: TextStyle(
                                            fontFamily: "Poppins",
                                            color: Colorr.themcolor,
                                            fontSize: 12,
                                            fontWeight: FWeight.fW700),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ))
        : WillPopScope(
            onWillPop: onBackPress,
            child: Scaffold(
              body: Stack(
                children: [
                  Container(
                    height: height,
                    width: width,
                    color: Colorr.themcolor,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: height / 7),
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
                                height: height * 0.07,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Welcome",
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        color: Colorr.themcolor,
                                        fontSize: 30,
                                        fontWeight: FWeight.fW600),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: height * 0.02,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Please Sign in to continue.",
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        color: Colorr.themcolor,
                                        fontSize: 17,
                                        fontWeight: FWeight.fW600),
                                  ),
                                ],
                              ),
                              CustomWidgets.textFieldWithBoxShadow(
                                  context: context,
                                  focusNode: _focusNode,
                                  hintText: "Username",
                                  controller: txtname,
                                  obscureText: false),
                              CustomWidgets.textFieldWithBoxShadow(
                                context: context,
                                hintText: "Password",
                                focusNode: _focusNode1,
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Row(
                                      children: [
                                        Theme(
                                          data: ThemeData(
                                              unselectedWidgetColor:
                                                  Colorr.themcolor),
                                          child: Checkbox(
                                            value: _isChecked,
                                            shape: CircleBorder(),
                                            activeColor: Colorr.themcolor,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                _isChecked = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Text(
                                          "Remember Me",
                                          style: TextStyle(
                                              fontFamily: "PoppinsM",
                                              color: Colorr.themcolor,
                                              fontSize: 14,
                                              fontWeight: FWeight.fW500),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 30),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                          builder: (context) {
                                            return Forgotpassword();
                                          },
                                        ));
                                      },
                                      child: Text(
                                        "Forgot Password?",
                                        style: TextStyle(
                                            fontFamily: "PoppinsM",
                                            color: Colorr.themcolor,
                                            fontSize: 14,
                                            fontWeight: FWeight.fW500),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: height * 0.04,
                              ),
                              CustomWidgets.swipeButton(Colorr.White, "Log In",
                                  () {
                                Unfocus();
                                Unfocus1();
                                Future.delayed(
                                    const Duration(milliseconds: 500),
                                    () async {
                                  if (txtname.text.trim().isEmpty) {
                                    CustomWidgets.showToast(
                                        context, "Username is required", false);
                                  } else if (txtPassword.text.trim().isEmpty) {
                                    CustomWidgets.showToast(
                                        context, "Password is required", false);
                                  } else {
                                    prograse();
                                    if (await api_page.logincheck(txtname.text,
                                        txtPassword.text, "", "", "log_in")) {
                                      if (_isChecked == true) {
                                        SharedPref.save_string(
                                            SrdPrefkey.Username.toString(),
                                            txtname.text);
                                        SharedPref.save_string(
                                            SrdPrefkey.LoginPassword.toString(),
                                            txtPassword.text);
                                      }
                                      try {
                                        LoginActivity.getIPGeolocation();
                                        SharedPref.SyncUserData();
                                        setState(() {});
                                        await Future.delayed(
                                                Duration(seconds: 3))
                                            .then((value) async {
                                          DateTime now = DateTime.now();
                                          if (Constants_Usermast
                                              .FaceID.isEmpty) {
                                            getSystemInfo(now.toString());
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SetUpFaceScreen()));
                                          } else {
                                            getSystemInfo(now.toString());
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
                                          }}
                                        });

                                        return true; // add this line
                                      } catch (e) {
                                        // handle error
                                      }
                                    } else {
                                      if (Con_List.Active.value) {
                                         Navigator.pop(context);
                                        CustomWidgets.showToast(context,
                                            "User is not Active", false);
                                      }else if(Con_List.Pass.value){
                                        Navigator.pop(context);
                                        CustomWidgets.showToast(
                                            context, "Wrong password. Try again.", false);
                                      }else if(Con_List.Server.value){
                                        Navigator.pop(context);
                                        CustomWidgets.showToast(
                                            context, "Server is under maintenance Try sometime later", false);
                                      } else {
                                        Navigator.pop(context);
                                        CustomWidgets.showToast(
                                            context, "User not found", false);
                                      }
                                    }
                                  }
                                });
                              }),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return CreateAccount();
                                        },
                                      ));
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Don’t have an account? ",
                                          style: TextStyle(
                                              color: Colorr.themcolor,
                                              fontSize: 12,
                                              fontWeight: FWeight.fW400),
                                        ),
                                        Text(
                                          "Sign Up",
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              color: Colorr.themcolor,
                                              fontSize: 12,
                                              fontWeight: FWeight.fW700),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Unfocus() {
    _focusNode.unfocus();
    setState(() {});
  }

  Unfocus1() {
    _focusNode1.unfocus();
    setState(() {});
  }

  Future prograse() {
    return showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(
            color: Colorr.themcolor,
          ),
        );
      },
    );
  }

  Future<void> prograseIOS() {
    return showCupertinoDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CupertinoActivityIndicator(
            radius: 15,
          ),
        );
      },
    );
  }

  void getSystemInfo(String Time) {
    if (Platform.isAndroid) {
      System = "Android";
    } else if (Platform.isIOS) {
      System = "iOS";
    } else if (Platform.isWindows) {
      System = "Windows";
    } else if (Platform.isMacOS) {
      System = "macOS";
    } else if (Platform.isLinux) {
      System = "Linux";
    } else {
      System = "Unknown";
    }
    LoginActivity.LoginActivityInsert(Time, System);
    setState(() {});
  }
}
