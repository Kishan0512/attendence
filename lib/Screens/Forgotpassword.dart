import 'package:attendy/A_SQL_Trigger/api_page.dart';
import 'package:attendy/Screens/CreateAccount.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../A_SQL_Trigger/Con_Usermast.dart';
import '../utils/Constant/Colors.dart';
import '../utils/Constant/FontWeight.dart';
import '../utils/Constant/LocalCustomWidgets.dart';
import 'OtpScreen.dart';

class Forgotpassword extends StatefulWidget {
  const Forgotpassword({Key? key}) : super(key: key);

  @override
  State<Forgotpassword> createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<Forgotpassword> {
  final FocusNode _focusNode = FocusNode();
  TextEditingController txtCurrectpass=TextEditingController();
  TextEditingController txtnewpass=TextEditingController();
  TextEditingController EmailName=TextEditingController();
  bool Currectvisivility = true;
  bool newvisivility = true;
  var size, height, width;
  bool emailValid = false;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Constants_Usermast.IOS==true ?CupertinoPageScaffold(child: Stack(
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
                    CustomWidgets.textFieldWithBoxShadowIOS(
                      hintText: "Currect password",
                      controller: txtCurrectpass,
                      obscureText: Currectvisivility,
                      suffixIcon:CupertinoButton(
                        onPressed: () {
                          setState(() {
                            Currectvisivility = !Currectvisivility;
                          });
                        },
                        child: Icon(
                          Currectvisivility
                              ? CupertinoIcons.eye_slash
                              : CupertinoIcons.eye,
                          color: Colorr.themcolor200,
                        ),
                      )
                    ),
                    CustomWidgets.textFieldWithBoxShadowIOS(
                      hintText: "New password",
                      controller: txtnewpass,
                      obscureText: newvisivility,
                      suffixIcon:CupertinoButton(
                        onPressed: () {
                          setState(() {
                            newvisivility = !newvisivility;
                          });
                        },
                        child: Icon(
                          newvisivility
                              ? CupertinoIcons.eye_slash
                              : CupertinoIcons.eye,
                          color: Colorr.themcolor200,
                        ),
                      )
                      ,
                    ),
                    SizedBox(
                      height: height * 0.04,
                    ),
                    CustomWidgets.swipeButton(Colorr.White, "Forgot Password", () {
                      Future.delayed(const Duration(milliseconds: 500),
                              () async {
                            if (txtCurrectpass.text.trim().isEmpty) {
                              CustomWidgets.showToast(context, "Currect password is required",false);
                            } else if (txtnewpass.text.trim().isEmpty) {
                              CustomWidgets.showToast(
                                  context, "new nassword is required",false);
                            }else{
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                                return CreateAccount();
                              },));
                            }

                            // validateMobile();
                          });
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    )) :
    Scaffold(
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
                          "Forgot Password ? ",
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
                        Onchanged: (email) {
                          setState(() {
                            emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
                          });
                        },
                        context: context,
                        hintText: "Enter Email",
                        focusNode: _focusNode,
                        controller: EmailName,
                        obscureText: false,
                      ),
                      Row(
                        children: [
                          emailValid ? Container():Padding(
                            padding: const EdgeInsets.only(left: 40.0),
                            child: Text("Enter Valid Email.",style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.04,
                      ),
                      CustomWidgets.swipeButton(Colorr.White, "Reset Password", () async {
                        Unfocus();
                       List<dynamic> Forgot = await api_page.ForgotPassword(Email: EmailName.text);
                       if(Forgot[0]!='email does not exist')
                         {
                        CustomWidgets.showToast(context, "OTP send to your email", true);
                       Future.delayed(Duration(seconds: 2),() {
                         return Navigator.push(context, MaterialPageRoute(builder: (context) {
                           return OTP(Forgot);
                         },));
                       },);
                         }else{
                         CustomWidgets.showToast(context, "'email does not exist'", false);
                       }
                      }),
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
    _focusNode.unfocus();
    setState(() {
    });
  }
}
