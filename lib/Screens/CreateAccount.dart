import 'package:attendy/A_SQL_Trigger/Con_List.dart';
import 'package:attendy/A_SQL_Trigger/Con_Usermast.dart';
import 'package:attendy/Screens/Log_in.dart';
import 'package:attendy/utils/Constant/Colors.dart';
import 'package:attendy/utils/Constant/FontWeight.dart';
import 'package:attendy/view/Users/User.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../A_SQL_Trigger/SharePref.dart';
import '../A_SQL_Trigger/api_page.dart';
import '../utils/Constant/LocalCustomWidgets.dart';
import '../view/PrivacyPolicy/Policy_details.dart';
import 'Join Screen.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount>
    with SingleTickerProviderStateMixin {
  final FocusNode _focusNode = FocusNode();
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();
  TextEditingController txtName = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtcnfPassword = TextEditingController();
  TextEditingController txtMobile = TextEditingController();
  TextEditingController txtemail = TextEditingController();
  var size, height, width;
  bool visivility = true;
  bool visivility1 = true;
  bool _isChecked = false;
  bool v1 = false, v2 = false, v3 = false, v4 = false, v5 = false;
  RegExp lowerCaseLetters = RegExp(r'[a-z]');
  RegExp upperCaseLetters = RegExp(r'[A-Z]');
  RegExp numbers = RegExp(r'[0-9]');
  RegExp specialCharacter = RegExp(r'[!@#$%^&*]');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    Future<bool> onBackPress() {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return Log_in();
        },
      ));
      return Future.value(false);
    }

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
                              height: height * 0.03,
                            ),
                            Center(
                              child: Text(
                                "Let's Get You Started",
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    color: Colorr.themcolor,
                                    fontSize: 22,
                                    fontWeight: FWeight.fW600),
                              ),
                            ),
                            Center(
                              child: Text(
                                "Create an account to Continue",
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    color: Colorr.themcolor400,
                                    fontSize: 14,
                                    fontWeight: FWeight.fW400),
                              ),
                            ),
                            CustomWidgets.textFieldWithBoxShadowIOS(
                                hintText: "Name",
                                controller: txtName,
                                obscureText: false),
                            CustomWidgets.textFieldWithBoxShadowIOS(
                                hintText: "Email",
                                controller: txtemail,
                                obscureText: false),
                            mobileTextFieldIOS(),
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
                                padding: EdgeInsets.zero,
                                child: Icon(
                                  visivility
                                      ? CupertinoIcons.eye_slash
                                      : CupertinoIcons.eye,
                                  color: CupertinoColors.systemGrey,
                                ),
                              ),
                            ),
                            CustomWidgets.textFieldWithBoxShadowIOS(
                              hintText: "Confirm Password",
                              controller: txtcnfPassword,
                              obscureText: visivility1,
                              suffixIcon: CupertinoButton(
                                  onPressed: () {
                                    setState(() {
                                      visivility1 = !visivility1;
                                    });
                                  },
                                  child: Icon(
                                    visivility1
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: CupertinoColors.systemGrey,
                                  )),
                            ),
                            SizedBox(
                              height: height * 0.04,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CupertinoSwitch(
                                  value: _isChecked,
                                  activeColor: Colorr.themcolor,
                                  onChanged: (bool value) {
                                    setState(() {
                                      _isChecked = value;
                                    });
                                  },
                                ),
                                Text(
                                  'I agree to terms & conditions',
                                  style: TextStyle(
                                    color: Colorr.usertitle,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            CustomWidgets.swipeButton(
                                Colorr.White, "Get Started", () {
                              Future.delayed(const Duration(milliseconds: 500),
                                  () {
                                if (txtName.text.trim().isEmpty) {
                                  CustomWidgets.showToast(
                                      context, "Name is required", false);
                                } else if (txtMobile.text.trim().isEmpty) {
                                  CustomWidgets.showToast(context,
                                      "Mobile number is required", false);
                                } else if (txtPassword.text.trim().isEmpty) {
                                  CustomWidgets.showToast(
                                      context, "Password is required", false);
                                } else if (txtcnfPassword.text.trim().isEmpty) {
                                  CustomWidgets.showToast(context,
                                      "Confirm Password is required", false);
                                } else if (txtemail.text.trim().isEmpty) {
                                  CustomWidgets.showToast(
                                      context, "Email is required", false);
                                } else if (_isChecked == false) {
                                  CustomWidgets.showToast(
                                      context,
                                      "Please Accept Terms & Conditions",
                                      false);
                                } else if (txtPassword.text ==
                                    txtcnfPassword.text) {
                                  if (!upperCaseLetters
                                      .hasMatch(txtPassword.text)) {
                                    CustomWidgets.showToast(
                                        context,
                                        "Enter atleast one upperCase letter password..",
                                        false);
                                    // toast.error("Enter atleast one upperCase letter password..")
                                  } else if (!lowerCaseLetters
                                      .hasMatch(txtPassword.text)) {
                                    CustomWidgets.showToast(
                                        context,
                                        "Enter atleast one lowerCase letter in password..",
                                        false);
                                    // toast.error("Enter atleast one lowerCase letter in password..")
                                  } else if (!numbers
                                      .hasMatch(txtPassword.text)) {
                                    CustomWidgets.showToast(
                                        context,
                                        "Enter atleast one number password..",
                                        false);
                                    // toast.error("Enter atleast one number password..")
                                  } else if (txtPassword.text.length < 6) {
                                    CustomWidgets.showToast(
                                        context,
                                        "Enter minimum 6 character in password..",
                                        false);
                                    // toast.error("Enter minimum 6 character in password..")
                                  } else if (!specialCharacter
                                      .hasMatch(txtPassword.text)) {
                                    CustomWidgets.showToast(
                                        context,
                                        "Enter atleast one special character in password..",
                                        false);
                                    // toast.error("Enter atleast one special character in password..")
                                  } else {
                                    validateMobile();
                                  }
                                } else {
                                  CustomWidgets.showToast(
                                      context,
                                      "password and confirm password do not match",
                                      false);
                                }

                                // validateMobile();
                              });
                            }),
                            SizedBox(
                              height: 8,
                            ),
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return Log_in();
                                    },
                                  ));
                                },
                                child: Text(
                                  "Already have an account? Sign In",
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      color: Colorr.themcolor,
                                      fontSize: 14,
                                      fontWeight: FWeight.fW400),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : WillPopScope(
            onWillPop: () => onBackPress(),
            child: Scaffold(
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
                                height: height * 0.03,
                              ),
                              Center(
                                child: Text(
                                  "Let's Get You Started",
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      color: Colorr.themcolor,
                                      fontSize: 22,
                                      fontWeight: FWeight.fW600),
                                ),
                              ),
                              Center(
                                child: Text(
                                  "Create an account to Continue",
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      color: Colorr.themcolor400,
                                      fontSize: 14,
                                      fontWeight: FWeight.fW400),
                                ),
                              ),
                              CustomWidgets.textFieldWithBoxShadow(
                                  context: context,
                                  hintText: "Name",
                                  focusNode: _focusNode,
                                  controller: txtName,
                                  obscureText: false),
                              CustomWidgets.textFieldWithBoxShadow(
                                  context: context,
                                  focusNode: _focusNode1,
                                  hintText: "Email Id",
                                  controller: txtemail,
                                  obscureText: false),
                              mobileTextField(),
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
                                hintText: "Password",
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
                                height: height * 0.02,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                          _isChecked = value ?? false;
                                        });
                                      },
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return Policy_details();
                                        },
                                      ));
                                    },
                                    child: Text(
                                      'I agree to terms & conditions',
                                      style: TextStyle(
                                        color: Colorr.themcolor,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              CustomWidgets.swipeButton(
                                  Colorr.White, "Get Started", () {
                                Unfocus();
                                Unfocus1();
                                Unfocus2();
                                Unfocus3();
                                Unfocus4();
                                Future.delayed(
                                    const Duration(milliseconds: 500), () {
                                  if (txtName.text.trim().isEmpty) {
                                    CustomWidgets.showToast(
                                        context, "Name is required", false);
                                  } else if (txtMobile.text.trim().isEmpty) {
                                    CustomWidgets.showToast(context,
                                        "Mobile number is required", false);
                                  } else if (txtPassword.text.trim().isEmpty) {
                                    CustomWidgets.showToast(
                                        context, "Password is required", false);
                                  } else if (txtcnfPassword.text
                                      .trim()
                                      .isEmpty) {
                                    CustomWidgets.showToast(context,
                                        "Confirm Password is required", false);
                                  } else if (txtemail.text.trim().isEmpty) {
                                    CustomWidgets.showToast(
                                        context, "Email is required", false);
                                  } else if (_isChecked == false) {
                                    CustomWidgets.showToast(
                                        context,
                                        "Please Accept Terms & Conditions",
                                        false);
                                  } else if (txtPassword.text ==
                                      txtcnfPassword.text) {
                                    if (!upperCaseLetters
                                        .hasMatch(txtPassword.text)) {
                                      CustomWidgets.showToast(
                                          context,
                                          "Enter atleast one upperCase letter password..",
                                          false);
                                      // toast.error("Enter atleast one upperCase letter password..")
                                    } else if (!lowerCaseLetters
                                        .hasMatch(txtPassword.text)) {
                                      CustomWidgets.showToast(
                                          context,
                                          "Enter atleast one lowerCase letter in password..",
                                          false);
                                      // toast.error("Enter atleast one lowerCase letter in password..")
                                    } else if (!numbers
                                        .hasMatch(txtPassword.text)) {
                                      CustomWidgets.showToast(
                                          context,
                                          "Enter atleast one number password..",
                                          false);
                                      // toast.error("Enter atleast one number password..")
                                    } else if (txtPassword.text.length < 6) {
                                      CustomWidgets.showToast(
                                          context,
                                          "Enter minimum 6 character in password..",
                                          false);
                                      // toast.error("Enter minimum 6 character in password..")
                                    } else if (!specialCharacter
                                        .hasMatch(txtPassword.text)) {
                                      CustomWidgets.showToast(
                                          context,
                                          "Enter atleast one special character in password..",
                                          false);
                                      // toast.error("Enter atleast one special character in password..")
                                    } else {
                                      validateMobile();
                                    }
                                  } else {
                                    CustomWidgets.showToast(
                                        context,
                                        "password and confirm password do not match",
                                        false);
                                  }

                                  // validateMobile();
                                });
                              }),
                              SizedBox(
                                height: 8,
                              ),
                              Center(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) {
                                        return Log_in();
                                      },
                                    ));
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Already have an account? ",
                                        style: TextStyle(
                                            color: Colorr.themcolor,
                                            fontSize: 14,
                                            fontWeight: FWeight.fW400),
                                      ),
                                      Text(
                                        "Sign In",
                                        style: TextStyle(
                                            color: Colorr.themcolor,
                                            fontSize: 14,
                                            fontWeight: FWeight.fW700),
                                      ),
                                    ],
                                  ),
                                ),
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

  bool isValidEmail(String email) {
    final pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  Future<bool> validateEmail(String email) async {
    if (email != null && isValidEmail(email)) {
      if (await api_page.logincheck(txtName.text, txtPassword.text,
          txtemail.text, txtMobile.text, "Create_account")) {
        try {
          Con_List.CompanySelect = await api_page.CompanySelect();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => JoinScreen()));
          return true; // add this line
        } catch (e) {}
      } else {
        Con_List.CompanySelect = await api_page.CompanySelect();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => JoinScreen()));
        CustomWidgets.showToast(context, "User already exists", false);
      }
    } else {
      CustomWidgets.showToast(context, "Enter Valid Email address", false);
    }
    return false; // add this line
  }

  Widget mobileTextField() {
    return Container(
      height: 50,
      width: width,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
      // padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colorr.White,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          // BoxShadow(
          //     color: Colorr.themcolor200,
          //     blurRadius: 1,
          //     spreadRadius: 0.1,
          //     offset: const Offset(1, 2)
          // )
        ],
      ),
      child: Center(
        child: IntlPhoneField(
          controller: txtMobile,
          focusNode: _focusNode2,
          dropdownIconPosition: IconPosition.trailing,
          style: TextStyle(color: Colorr.themcolor300, fontSize: 19),
          invalidNumberMessage: "",
          flagsButtonMargin: const EdgeInsets.only(left: 15),
          textInputAction: TextInputAction.done,
          disableLengthCheck: true,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          dropdownIcon: Icon(Icons.arrow_drop_down, color: Colorr.themcolor300),
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Mobile No",
              hintStyle: TextStyle(color: Colorr.themcolor300, fontSize: 15)),
          initialCountryCode: 'IN',
          dropdownTextStyle: TextStyle(
            color: Colorr.themcolor300,
            fontSize: 12,
          ),
          onChanged: (phone) {},
        ),
      ),
    );
  }

  Widget mobileTextFieldIOS() {
    return Container(
      height: 50,
      width: width,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      // padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colorr.White,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
              color: Colorr.themcolor200,
              blurRadius: 5,
              spreadRadius: 0.5,
              offset: const Offset(2, 3))
        ],
      ),
      child: Center(
        child: CupertinoTextField(
          controller: txtMobile,
          style: TextStyle(color: Colorr.themcolor200, fontSize: 20),
          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 14),
          keyboardType: TextInputType.number,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          placeholder: "Mobile No",
          placeholderStyle: TextStyle(color: Colorr.themcolor200, fontSize: 16),
          prefix: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              ' +91',
              style: TextStyle(color: Colorr.themcolor200, fontSize: 18),
            ),
          ),
          onChanged: (value) {},
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

  Unfocus2() {
    _focusNode2.unfocus();
    setState(() {});
  }

  Unfocus3() {
    _focusNode3.unfocus();
    setState(() {});
  }

  Unfocus4() {
    _focusNode4.unfocus();
    setState(() {});
  }

  validateMobile() {
    if (txtMobile.text.length != 10) {
      CustomWidgets.showToast(context, "Enter Valid Number", false);
    } else {
      validateEmail(txtemail.text);
    }
  }
}
