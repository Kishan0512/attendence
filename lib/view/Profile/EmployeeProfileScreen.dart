import 'dart:convert';
import 'dart:typed_data';
import 'package:attendy/A_SQL_Trigger/Branchapi.dart';
import 'package:attendy/A_SQL_Trigger/Con_List.dart';
import 'package:attendy/A_SQL_Trigger/Con_Usermast.dart';
import 'package:attendy/A_SQL_Trigger/Deparment_api_page.dart';
import 'package:attendy/A_SQL_Trigger/Shift_Add_api.dart';
import 'package:attendy/A_SQL_Trigger/api_page.dart';
import 'package:attendy/utils/Constant/Colors.dart';
import 'package:attendy/utils/Constant/Con_icon.dart';
import 'package:attendy/utils/Constant/FontWeight.dart';
import 'package:attendy/utils/Constant/LocalCustomWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../A_SQL_Trigger/Employee_Add_api.dart';
import '../../A_SQL_Trigger/SharePref.dart';
import '../../utils/DroupDown/custom_dropdown.dart';
import '../Dashboard/Dashboard.dart';
import '../Employee/AddEmployee.dart';

class EmployeeProfileScreen extends StatefulWidget {
  const EmployeeProfileScreen({Key? key}) : super(key: key);

  @override
  State<EmployeeProfileScreen> createState() => _EmployeeProfileScreenState();
}

class _EmployeeProfileScreenState extends State<EmployeeProfileScreen> {
  List<String> AllEmployee = [];
  final picker = ImagePicker();
  List<int> ImageBytecode=[];
  String ImageBase64="";
  int internetConn=0;
  Uint8List? image;
  List<dynamic> Details = [];
  List<dynamic> AdminDetails = [];
  List<dynamic> EmployeeDetails = [];
  TextEditingController employeeName = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
    CheakInternet();
  }
  CheakInternet()
  async {
    internetConn = await CustomWidgets.CheakConnectionInternet();
    setState(() {
    });
  }
  getdata() async {
    String tep=await SharedPref.read_string(SrdPrefkey.Profile.toString()) ??"";
    if(tep!="")
      {
    if(tep.contains("data:image"))
    {
      image =base64.decode(tep.split(',')[1]);
    }else{
      image =base64.decode(tep);
    }}
    Con_List.Users=await api_page.userSelect();
    Con_List.AllEmployee = await AllEmployee_api.EmployeeSelect();
    Con_List.BranchSelect = await Branch_api.BranchSelect();
    Con_List.DeparmenntSelect = await Deparmentapi.DeparmentSelect();
    Con_List.Allshift_Select=await Shift_Add_api.shift_Select();

    Con_List.AllEmployee.forEach((element) {
      if(element['isActive']==true)
      {
        AllEmployee.add(element['FirstName']);
      }
    });
    if (Constants_Usermast.statuse != "ADMIN") {
      EmployeeDetails = Con_List.AllEmployee.where(
          (e) => e['_id'] == Constants_Usermast.employeeId).toList();
    }else{
      EmployeeDetails = Con_List.AllEmployee.where(
              (e) => e['_id'] == Constants_Usermast.employeeId).toList();
      Details.clear();
      Details = Con_List.AllEmployee.where((e) => e['_id'] == Constants_Usermast.employeeId).toList();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height - kToolbarHeight;
    double width = MediaQuery.of(context).size.width;
    Future<bool> onBackPress() {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return Dashboard();
      },));
      return Future.value(false);
    }
    return WillPopScope(
        onWillPop: () => onBackPress(),
    child:Constants_Usermast.IOS==true ?
    CupertinoPageScaffold(
        navigationBar: CustomWidgets.appbarIOS(title: "Employee Profile", action: [
          Constants_Usermast.statuse == "ADMIN"  ? CupertinoButton(
        padding: EdgeInsets.zero,
        child: Icon(Icons.edit, color: Colorr.White),
        onPressed: () {
          Details.isNotEmpty
              ? Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return AddEmployee(e: Details[0],name: "Profile",);
            },
          ))
              : Navigator();
        },
      ):Container(),
          Constants_Usermast.statuse == "ADMIN" ?  CupertinoButton(
            padding: EdgeInsets.zero,
            child: Icon(CupertinoIcons.person, color: Colorr.White),
            onPressed: () {
              showCupertinoDialog(
                context: context,
                builder: (BuildContext
                context) {
                  return StatefulBuilder(
                    builder: (context,
                        setState1) {
                      return CupertinoAlertDialog(
                        actions: [
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment
                                .spaceEvenly,
                            children: [
                              CupertinoButton(
                                onPressed:
                                    () {
                                  Navigator.pop(
                                      context);
                                },
                                child: Text(
                                    "Cancel",
                                    style:
                                    TextStyle(color: Colorr.Reset)),
                              ),
                              CupertinoButton(
                                onPressed:
                                    () {
                                      Details.clear();
                                      Navigator.pop(context);
                                      Details = Con_List.AllEmployee.where((e) => e['FirstName'] == employeeName.text).toList();
                                      setState(() {
                                      });
                                },
                                child: Text(
                                    "Done"),
                              ),
                            ],
                          ),
                        ],
                        content: Column(children: [
                          CustomWidgets.textFieldIOS(hintText: "Select Employee",controller: employeeName,readOnly: true,onTap: () {
                            CustomWidgets.SelectDroupDown(context: context,items: AllEmployee, onSelectedItemChanged: (int) {
                              employeeName.text=AllEmployee[int];
                              setState(() {
                              });
                            });
                          },suffix: CustomWidgets.aarowCupertinobutton()),
                        ]),
                        title: Text(
                          "Select Employee",
                          style:
                          TextStyle(),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ):Container(),

    ], context: context, onTap: () {
      Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) {
        return Dashboard();
      },));
    },),
      child: Container(color: Colorr.themcolor,child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 80),
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colorr.White,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 70),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      User_name(),
                      CustomWidgets.height(8.0),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 2, bottom: 2, left: 13, right: 8),
                        child: User_Status(),
                      ),
                      padding(),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 2, bottom: 2, left: 13, right: 8),
                        child: Shift(),
                      ),
                      padding(),
                      Padding(
                        padding:  EdgeInsets.only(
                            top: 2, bottom: 2, left: 13, right: 8),
                        child: Email_ID(),
                      ),
                      padding(),
                      Padding(
                        padding:  EdgeInsets.only(
                            top: 2, bottom: 2, left: 13, right: 8),
                        child: Mobile_No(),
                      ),
                      padding(),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 2, bottom: 2, left: 13, right: 8),
                        child: Date_of_Birth(),
                      ),
                      padding(),
                      Padding(
                        padding:  EdgeInsets.only(
                            top: 2, bottom: 2, left: 13, right: 8),
                        child: Address(),
                      ),
                      padding(),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 2, bottom: 2, left: 13, right: 8),
                        child: Gender(),
                      ),
                      padding(),
                      Padding(
                        padding:  EdgeInsets.only(
                            top: 2, bottom: 2, left: 13, right: 8),
                        child: Branch(),
                      ),
                      padding(),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 2, bottom: 2, left: 13, right: 8),
                        child: Deparment(),
                      ),
                      // padding(),
                      // Padding(
                      //   padding: const EdgeInsets.only(
                      //       top: 2, bottom: 2, left: 13, right: 8),
                      //   child: City(),
                      // ),
                      // padding(),
                      // Padding(
                      //   padding: const EdgeInsets.only(
                      //       top: 2, bottom: 2, left: 13, right: 8),
                      //   child: State(),
                      // ),
                      // padding(),
                      // Padding(
                      //   padding: const EdgeInsets.only(
                      //       top: 2, bottom: 2, left: 13, right: 8),
                      //   child: Working_Hours(),
                      // ),
                      padding(),
                      Container(
                        height: 7,
                        padding:  EdgeInsets.only(
                            left: 5, right: 5, top: 10, bottom: 10),
                        decoration:
                        BoxDecoration( boxShadow: [
                          BoxShadow(
                            color: Colorr.themcolor100,
                            blurStyle: BlurStyle.inner,
                            blurRadius: 8,
                          ),
                        ]),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding:  EdgeInsets.only(
                                top: 15, bottom: 2, left: 15),
                            child: CustomWidgets.poppinsText("Bank Details  ",
                                Colorr.themcolor, 18, FWeight.fW500),
                          )
                        ],
                      ),
                      Padding(
                        padding:  EdgeInsets.only(
                            top: 15, bottom: 2, left: 13, right: 8),
                        child: Bank_Name(),
                      ),
                      padding(),
                      Padding(
                        padding:  EdgeInsets.only(
                            top: 2, bottom: 2, left: 13, right: 8),
                        child: Bank_Account_No(),
                      ),
                      padding(),
                      Padding(
                        padding:  EdgeInsets.only(
                            top: 2, bottom: 2, left: 13, right: 8),
                        child: IFSC_Code(),
                      ),
                      padding(),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 2, bottom: 2, left: 13, right: 8),
                        child: Pan_No(),
                      ),
                      padding(),
                      Padding(
                        padding:  EdgeInsets.only(
                            top: 2, bottom: 2, left: 13, right: 8),
                        child: BankBranch(),
                      ),
                      padding(),
                      Container(
                        height: 7,
                        padding:  EdgeInsets.only(
                            left: 5, right: 5, top: 10, bottom: 10),
                        decoration:
                        BoxDecoration(boxShadow: [
                          BoxShadow(
                            color: Colorr.themcolor100,
                            blurStyle: BlurStyle.inner,
                            blurRadius: 8,
                          ),
                        ]),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding:  EdgeInsets.only(
                                top: 15, bottom: 2, left: 15),
                            child: CustomWidgets.poppinsText(
                                "Family Details  ",
                                Colorr.themcolor,
                                18,
                                FWeight.fW500),
                          )
                        ],
                      ),
                      Padding(
                        padding:  EdgeInsets.only(
                            top: 15, bottom: 2, left: 13, right: 8),
                        child: Relationship(),
                      ),
                      padding(),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 2, bottom: 2, left: 13, right: 8),
                        child: Name(),
                      ),
                      padding(),
                      Padding(
                        padding:  EdgeInsets.only(
                            top: 2, bottom: 2, left: 13, right: 8),
                        child: Phone_No(),
                      ),
                      padding(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(top: 25, child: Conte3()),
        ],
      )),) :  Scaffold(
      backgroundColor: Colorr.themcolor,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(onPressed: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
            return Dashboard();
          },));
        }, icon: Icon(Icons.arrow_back_ios_new_outlined)),
        centerTitle: true,
        title: Text(
          "Employee Profile",
          textAlign: TextAlign.start,
          style: TextStyle(
              fontFamily: "PoppinsM",
              color: Colorr.White,
              fontSize: 20,
              fontWeight: FWeight.fW600),
        ),
        actions: [
          Padding(
            padding:  EdgeInsets.all(1.0),
            child: Constants_Usermast.statuse == "ADMIN"
                ? CustomWidgets.navigateBack(
                    onPressed: () {
                      Details.isNotEmpty
                          ? Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return AddEmployee(e: Details[0],name: "Profile",);
                              },
                            ))
                          : Navigator();
                    },
                    icon: Con_icon.Edit,
                    // icon: Icon(controller.isEdit ? Icons.done : Icons.edit),
                  )
                : Container(),
          ),
          Padding(
            padding: EdgeInsets.all(1.0),
            child: Constants_Usermast.statuse == "ADMIN"
                ? CustomWidgets.navigateBack(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(
                            builder: (context, setState1) {
                              return Dialog(
                                child: Container(
                                  height: height / 2.5,
                                  child: Column(
                                    children: [
                                    AppBar(
                                    backgroundColor: Colorr.themcolor,
                                    centerTitle: true,
                                    automaticallyImplyLeading: false,
                                    elevation: 0,
                                    title: Text("Select Employee",style: TextStyle(fontSize: 14)),
                                    actions: [
                                      IconButton(splashRadius: 18,onPressed: () {
                                       Navigator.pop(context);
                                      }, icon: Icon(Icons.close))
                                    ],
                                    ),
                                      CustomWidgets.height(10),
                                      CustomDropdown.search(listItemStyle: CustomWidgets.style(),
                                        hintText: 'Select Employee',
                                        controller: employeeName,
                                        items: AllEmployee,
                                      ),
                                      Spacer(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          CustomWidgets.confirmButton(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              height: height / 20,
                                              width: width / 3,
                                              text: "Cancel"),
                                          CustomWidgets.confirmButton(
                                              onTap: () {

                                                Details.clear();
                                                Navigator.pop(context);
                                                Details = Con_List.AllEmployee.where((e) => e['FirstName'] == employeeName.text).toList();
                                                setState(() {
                                                });
                                              },
                                              height: height / 20,
                                              width: width / 3,
                                              text: "Done"),
                                        ],
                                      ),
                                      CustomWidgets.height(height / 50)
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                    icon: Con_icon.Person,
                    // icon: Icon(controller.isEdit ? Icons.done : Icons.edit),
                  )
                : Container(),
          ),
        ],
        backgroundColor: Colorr.themcolor,
      ),
      body: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 120),
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colorr.White,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
              ),

              child: Padding(
                padding:  EdgeInsets.only(top: 70),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CustomWidgets.height(8.0),
                      Padding(
                        padding:  EdgeInsets.only(
                            top: 2, bottom: 2, left: 13, right: 8),
                        child: User_Status(),
                      ),
                      padding(),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 2, bottom: 2, left: 13, right: 8),
                        child: Shift(),
                      ),
                      padding(),
                      Padding(
                        padding:  EdgeInsets.only(
                            top: 2, bottom: 2, left: 13, right: 8),
                        child: Email_ID(),
                      ),
                      padding(),
                      Padding(
                        padding:  EdgeInsets.only(
                            top: 2, bottom: 2, left: 13, right: 8),
                        child: Mobile_No(),
                      ),
                      padding(),
                      Padding(
                        padding:  EdgeInsets.only(
                            top: 2, bottom: 2, left: 13, right: 8),
                        child: Date_of_Birth(),
                      ),
                      padding(),
                      Padding(
                        padding:  EdgeInsets.only(
                            top: 2, bottom: 2, left: 13, right: 8),
                        child: Address(),
                      ),
                      padding(),
                      Padding(
                        padding:  EdgeInsets.only(
                            top: 2, bottom: 2, left: 13, right: 8),
                        child: Gender(),
                      ),
                      padding(),
                      Padding(
                        padding:  EdgeInsets.only(
                            top: 2, bottom: 2, left: 13, right: 8),
                        child: Branch(),
                      ),
                      padding(),
                      Padding(
                        padding:  EdgeInsets.only(
                            top: 2, bottom: 2, left: 13, right: 8),
                        child: Deparment(),
                      ),
                      padding(),
                      Container(
                        height: 5,
                        padding:  const EdgeInsets.only(
                            left: 5, right: 5, top: 10, bottom: 10),
                        decoration:
                        BoxDecoration(gradient: LinearGradient(colors: [Colorr.themcolor50,Colorr.GreenWhite],begin: Alignment.topCenter,end: Alignment.bottomCenter),),
                      ),
                      Container(
                        height: 5,
                        padding:  const EdgeInsets.only(
                            left: 5, right: 5, top: 10, bottom: 10),
                        decoration:
                        BoxDecoration(gradient: LinearGradient(colors: [Colorr.themcolor50,Colorr.GreenWhite],begin: Alignment.bottomCenter,end: Alignment.topCenter), ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding:  const EdgeInsets.only(
                                top: 15, bottom: 2, left: 15),
                            child: CustomWidgets.poppinsText("Bank Details  ",
                                Colorr.themcolor, 18, FWeight.fW500),
                          )
                        ],
                      ),
                      Padding(
                        padding:  const EdgeInsets.only(
                            top: 15, bottom: 2, left: 13, right: 8),
                        child: Bank_Name(),
                      ),
                      padding(),
                      Padding(
                        padding:  const EdgeInsets.only(
                            top: 2, bottom: 2, left: 13, right: 8),
                        child: Bank_Account_No(),
                      ),
                      padding(),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 2, bottom: 2, left: 13, right: 8),
                        child: IFSC_Code(),
                      ),
                      padding(),
                      Padding(
                        padding:  const EdgeInsets.only(
                            top: 2, bottom: 2, left: 13, right: 8),
                        child: Pan_No(),
                      ),
                      padding(),
                      Padding(
                        padding:  const EdgeInsets.only(
                            top: 2, bottom: 2, left: 13, right: 8),
                        child: BankBranch(),
                      ),
                      padding(),
                    Container(
                      height: 5,
                      padding:  const EdgeInsets.only(
                          left: 5, right: 5, top: 10, bottom: 10),
                      decoration:
                      BoxDecoration(gradient: LinearGradient(colors: [Colorr.themcolor50,Colorr.GreenWhite],begin: Alignment.topCenter,end: Alignment.bottomCenter),),
                    ),
                    Container(
                      height: 5,
                      padding:  const EdgeInsets.only(
                          left: 5, right: 5, top: 10, bottom: 10),
                      decoration:
                      BoxDecoration(gradient: LinearGradient(colors: [Colorr.themcolor50,Colorr.GreenWhite],begin: Alignment.bottomCenter,end: Alignment.topCenter), ),
                    ),
                      Row(
                        children: [
                          Padding(
                            padding:  const EdgeInsets.only(
                                top: 15, bottom: 2, left: 15),
                            child: CustomWidgets.poppinsText(
                                "Family Details  ",
                                Colorr.themcolor,
                                18,
                                FWeight.fW500),
                          )
                        ],
                      ),
                      Padding(
                        padding:  const EdgeInsets.only(
                            top: 15, bottom: 2, left: 13, right: 8),
                        child: Relationship(),
                      ),
                      padding(),
                      Padding(
                        padding:  const EdgeInsets.only(
                            top: 2, bottom: 2, left: 13, right: 8),
                        child: Name(),
                      ),
                      padding(),
                      Padding(
                        padding:  const EdgeInsets.only(
                            top: 2, bottom: 2, left: 13, right: 8),
                        child: Phone_No(),
                      ),
                      padding(),
                      Container(
                        height: 7,
                        padding: const EdgeInsets.only(
                            left: 5, right: 5, top: 10, bottom: 10),
                        decoration:
                        BoxDecoration( boxShadow: [
                          BoxShadow(
                            color: Colorr.themcolor100,
                            blurStyle: BlurStyle.inner,
                            blurRadius: 8,
                          ),
                        ]),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 15, bottom: 2, left: 15),
                            child: CustomWidgets.poppinsText("Govt. Details  ",
                                Colorr.themcolor, 18, FWeight.fW500),
                          )
                        ],
                      ),
                      padding(),
                      Padding(
                        padding:  const EdgeInsets.only(
                            top: 2, bottom: 2, left: 13, right: 8),
                        child: pan(),
                      ),
                      padding(),
                      Padding(
                        padding:  const EdgeInsets.only(
                            top: 2, bottom: 2, left: 13, right: 8),
                        child: pf(),
                      ),
                      padding(),
                      Padding(
                        padding:  const EdgeInsets.only(
                            top: 2, bottom: 2, left: 13, right: 8),
                        child: esis(),
                      ),
                      padding(),
                      Padding(
                        padding:  const EdgeInsets.only(
                            top: 2, bottom: 2, left: 13, right: 8),
                        child: un(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(top: 25, child: Conte3()),
          Positioned(top: 150,child:  User_name(),)
        ],
      ),
    ));
  }
  Widget mainwidget() {
    if (internetConn == 1) {
      return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 80),
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colorr.White,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 70),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      User_name(),
                      CustomWidgets.height(8.0),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 2, bottom: 2, left: 13, right: 8),
                        child: User_Status(),
                      ),
                      padding(),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 2, bottom: 2, left: 13, right: 8),
                        child: Shift(),
                      ),
                      padding(),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 2, bottom: 2, left: 13, right: 8),
                        child: Email_ID(),
                      ),
                      padding(),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 2, bottom: 2, left: 13, right: 8),
                        child: Mobile_No(),
                      ),
                      padding(),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 2, bottom: 2, left: 13, right: 8),
                        child: Date_of_Birth(),
                      ),
                      padding(),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 2, bottom: 2, left: 13, right: 8),
                        child: Address(),
                      ),
                      padding(),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 2, bottom: 2, left: 13, right: 8),
                        child: Gender(),
                      ),
                      padding(),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 2, bottom: 2, left: 13, right: 8),
                        child: Branch(),
                      ),
                      padding(),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 2, bottom: 2, left: 13, right: 8),
                        child: Deparment(),
                      ),
                      padding(),
                      Container(
                        height: 7,
                        padding: const EdgeInsets.only(
                            left: 5, right: 5, top: 10, bottom: 10),
                        decoration:
                        BoxDecoration( boxShadow: [
                          BoxShadow(
                            color: Colorr.themcolor100,
                            blurStyle: BlurStyle.inner,
                            blurRadius: 8,
                          ),
                        ]),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 15, bottom: 2, left: 15),
                            child: CustomWidgets.poppinsText("Bank Details  ",
                                Colorr.themcolor, 18, FWeight.fW500),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 15, bottom: 2, left: 13, right: 8),
                        child: Bank_Name(),
                      ),
                      padding(),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 2, bottom: 2, left: 13, right: 8),
                        child: Bank_Account_No(),
                      ),
                      padding(),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 2, bottom: 2, left: 13, right: 8),
                        child: IFSC_Code(),
                      ),
                      padding(),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 2, bottom: 2, left: 13, right: 8),
                        child: Pan_No(),
                      ),
                      padding(),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 2, bottom: 2, left: 13, right: 8),
                        child: BankBranch(),
                      ),
                      padding(),
                      Container(
                        height: 7,
                        padding: const EdgeInsets.only(
                            left: 5, right: 5, top: 10, bottom: 10),
                        decoration:
                        BoxDecoration(boxShadow: [
                          BoxShadow(
                            color: Colorr.themcolor100,
                            blurStyle: BlurStyle.inner,
                            blurRadius: 8,
                          ),
                        ]),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 15, bottom: 2, left: 15),
                            child: CustomWidgets.poppinsText(
                                "Family Details  ",
                                Colorr.themcolor,
                                18,
                                FWeight.fW500),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 15, bottom: 2, left: 13, right: 8),
                        child: Relationship(),
                      ),
                      padding(),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 2, bottom: 2, left: 13, right: 8),
                        child: Name(),
                      ),
                      padding(),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 2, bottom: 2, left: 13, right: 8),
                        child: Phone_No(),
                      ),
                      padding(),
                      Container(
                        height: 7,
                        padding: const EdgeInsets.only(
                            left: 5, right: 5, top: 10, bottom: 10),
                        decoration:
                        BoxDecoration( boxShadow: [
                          BoxShadow(
                            color: Colorr.themcolor100,
                            blurStyle: BlurStyle.inner,
                            blurRadius: 8,
                          ),
                        ]),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 15, bottom: 2, left: 15),
                            child: CustomWidgets.poppinsText("Bank Details  ",
                                Colorr.themcolor, 18, FWeight.fW500),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(top: 25, child: Conte3()),
        ],
      );
    } else if (internetConn == 2) {
      return CustomWidgets.NoInternetImage(context);
    } else {
      return CustomWidgets.Circularprogress(context);
    }
  }
  _showDrawer_documents() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              child: Container(
            decoration: const BoxDecoration(
              borderRadius:  BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  child: Center(
                    child: Container(
                        width: 30,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colorr.IconColor,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        )),
                  ),
                ),
                ListTile(
                  leading: IconButton(color: Colorr.IconColor,onPressed: () {

                  }, icon: Con_icon.Delete),
                  title: Text('Remove Profile Picture'),
                  onTap: () async {

                     await UpDate("");
                     CustomWidgets.showToast(context,
                         "Profile Remove Successfully", true);
                     Navigator.pop(context);



                  },
                ),
                ListTile(
                  leading: IconButton(color: Colorr.IconColor,onPressed: () {

                  }, icon: Con_icon.Camera),
                  title: const Text('Select Profile Picture'),
                  onTap: () async {
                    await getImage();
                    CustomWidgets.showToast(context,
                        "Profile Update Successfully", true);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ));
        });
  }
  Future getImage() async {
    XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    ImageBytecode = (await pickedFile?.readAsBytes()) as List<int>;
     ImageBase64 =  base64Encode(ImageBytecode);
     UpDate(ImageBase64);

  }
 Future UpDate(String code) async {
    Map data={
      "company_id":Constants_Usermast.companyId.toString(),
      "id":Constants_Usermast.sId.toString(),
      "image":code,
      "password":  Con_List.Users.where((element) =>element["employeeId"] ==null?false: element["employeeId"]['_id'].toString()==Constants_Usermast.employeeId.toString()).first["password"].toString(),
    };

    var res =  await api_page.userupdate(data);

    SharedPref.save_string(
        SrdPrefkey.Profile.toString(), code);
    String tep=await SharedPref.read_string(SrdPrefkey.Profile.toString());
    if(tep!=""){
    if(tep.contains("data:image"))
    {
      image =base64.decode(tep.split(',')[1]);
    }else{
      image =base64.decode(tep);
    }}else{
      image=null;
    }
    setState(() {});
  }


  Widget Conte3() => AnimatedContainer(duration: Duration(milliseconds: 100),
        height: 120,
        width: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: const Color(0XFF477A72),
          border: Border.all(width: 3, color: Colors.white),
        ),
        child: Stack(children: [
          if (image != null && image != []) // Show selected image if available
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.memory(
                  image!,
                  fit: BoxFit.cover, // Fit the image within the container
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            )
          else
            Center(
              child:CircleAvatar(maxRadius: 40,backgroundColor: Colorr.themcolor,foregroundColor: Colorr.themcolor,child:Image.asset("images/user12.png"),),
            ),
          Positioned(
              top: 73,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(3),
                    height: 40,
                    width: 40,
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: FloatingActionButton(
                        heroTag: '1',
                        backgroundColor: const Color(0XFF477A72),
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                          Radius.circular(30.0),
                        )),
                        onPressed: () {
                          _showDrawer_documents();
                        },
                        child: const Icon(
                          Icons.camera_alt,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ))
        ]),
      );

  Widget User_name() => Column(
        children: [
          CustomWidgets.poppinsText(
              "${Details.isEmpty ? EmployeeDetails.isEmpty ? Constants_Usermast.name : "${EmployeeDetails[0]['FirstName']} ${EmployeeDetails[0]['MiddelName']} ${EmployeeDetails[0]['LastName']}" : "${Details[0]['FirstName']} ${Details[0]['MiddelName']} ${Details[0]['LastName']}"}",
              Colorr.themcolor,
              17,
              FWeight.fW600),
        ],
      );
  User_Status() => Row(
        children: [
          CustomWidgets.poppinsText(
              "${Details.isEmpty ? EmployeeDetails.isEmpty ? Constants_Usermast.name : "${EmployeeDetails[0]['FirstName']} ${EmployeeDetails[0]['MiddelName']} ${EmployeeDetails[0]['LastName']}" : "${Details[0]['FirstName']} ${Details[0]['MiddelName']} ${Details[0]['LastName']}"}",
              Colorr.themcolor,
              15,
              FWeight.fW500),
          Spacer(),
          CustomWidgets.poppinsText(
              "${Constants_Usermast.statuse == "ADMIN" ? Details.isEmpty ? "Admin" : "Employee" : "Employee"}",
              Colorr.themcolor,
              14,
              FWeight.fW500),
        ],
      );

  Shift() => Row(
        children: [
          CustomWidgets.poppinsText(
              "Shift", Colorr.themcolor, 15, FWeight.fW500),
          Spacer(),
          CustomWidgets.poppinsText(
              "${Details.isEmpty ? EmployeeDetails.isEmpty ? "" : EmployeeDetails[0]['ShiftId']['name'] : Details[0]['ShiftId']['name']}", Colorr.themcolor, 14, FWeight.fW500),
        ],
      );

  Email_ID() => Row(
        children: [
          CustomWidgets.poppinsText(
              "Email ID", Colorr.themcolor, 15, FWeight.fW500),
          Spacer(),
          CustomWidgets.poppinsText(
              "${Details.isEmpty ? EmployeeDetails.isEmpty ? "" : "${EmployeeDetails[0]['Email'].toString()}" : "${Details[0]['Email'].toString()}"}",
              Colorr.themcolor,
              14,
              FWeight.fW500),
        ],
      );

  Mobile_No() => Row(
        children: [
          CustomWidgets.poppinsText(
              "Mobile No.", Colorr.themcolor, 15, FWeight.fW500),
          Spacer(),
          CustomWidgets.poppinsText(
              "${Details.isEmpty ? EmployeeDetails.isEmpty ? "" : "${EmployeeDetails[0]['Number'].toString()}" : "${Details[0]['Number'].toString()}"}",
              Colorr.themcolor,
              14,
              FWeight.fW500),
        ],
      );

  Date_of_Birth() => Row(
        children: [
          CustomWidgets.poppinsText(
              "Date of Birth", Colorr.themcolor, 15, FWeight.fW500),
          Spacer(),
          CustomWidgets.poppinsText(
              "${Details.isEmpty ? EmployeeDetails.isEmpty ? "" : "${CustomWidgets.DateFormatchange(EmployeeDetails[0]['Dob'].toString())}" : "${CustomWidgets.DateFormatchange(Details[0]['Dob'].toString())}"}",
              Colorr.themcolor,
              14,
              FWeight.fW500),
        ],
      );

  Address() => Container(
    width: MediaQuery.of(context).size.width,
    child: Row(
          children: [
            CustomWidgets.poppinsText(
                "Address", Colorr.themcolor, 15, FWeight.fW500),
            Spacer(),
            Container(width: MediaQuery.of(context).size.width/1.5,child:
            Text(
                "${Details.isEmpty ? EmployeeDetails.isEmpty ? "" : "${EmployeeDetails[0]['Address'].toString()}" : "${Details[0]['Address'].toString()}"}",
              textAlign: TextAlign.center,
              overflow: TextOverflow.clip,
              style: TextStyle(
                color: Colorr.themcolor,
                fontSize: 14,
                fontWeight:  FWeight.fW500,
                fontFamily: 'Poppins',
              ),),alignment: Alignment.centerRight,)
            ,
          ],
        ),
  );

  Gender() => Row(
        children: [
          CustomWidgets.poppinsText(
              "Gender", Colorr.themcolor, 15, FWeight.fW500),
          Spacer(),
          CustomWidgets.poppinsText(
              "${Details.isEmpty ? EmployeeDetails.isEmpty ? "" : "${EmployeeDetails[0]['Gender'].toString()}" : "${Details[0]['Gender'].toString()}"}",
              Colorr.themcolor,
              14,
              FWeight.fW500),
        ],
      );

  Branch() => Row(
        children: [
          CustomWidgets.poppinsText(
              "Branch", Colorr.themcolor, 15, FWeight.fW500),
          Spacer(),
          CustomWidgets.poppinsText(
              "${Details.isEmpty ?EmployeeDetails.isEmpty?"":EmployeeDetails[0]['branchId']['name']:Details[0]['branchId']['name']}",
              Colorr.themcolor,
              14,
              FWeight.fW500),
        ],
      );

  Deparment() => Row(
        children: [
          CustomWidgets.poppinsText(
              "Department", Colorr.themcolor, 15, FWeight.fW500),
          Spacer(),
          CustomWidgets.poppinsText(
              "${Details.isEmpty ? EmployeeDetails.isEmpty ? "" : EmployeeDetails[0]['departmentId']['name']:Details[0]['departmentId']['name']}",
              Colorr.themcolor,
              14,
              FWeight.fW500),
        ],
      );

  City() => Row(
        children: [
          CustomWidgets.poppinsText(
              "City", Colorr.themcolor, 15, FWeight.fW500),
          Spacer(),
          CustomWidgets.poppinsText("", Colorr.themcolor, 14, FWeight.fW500),
        ],
      );

  State() => Row(
        children: [
          CustomWidgets.poppinsText(
              "State", Colorr.themcolor, 15, FWeight.fW500),
          Spacer(),
          CustomWidgets.poppinsText("", Colorr.themcolor, 14, FWeight.fW500),
        ],
      );

  Working_Hours() => Row(
        children: [
          CustomWidgets.poppinsText(
              "Working Hours", Colorr.themcolor, 15, FWeight.fW500),
          Spacer(),
          CustomWidgets.poppinsText("", Colorr.themcolor, 14, FWeight.fW500),
        ],
      );

  Bank_Name() => Row(
        children: [
          CustomWidgets.poppinsText(
              "Bank Name", Colorr.themcolor, 15, FWeight.fW500),
          Spacer(),
          CustomWidgets.poppinsText(
              "${Details.isEmpty ? EmployeeDetails.isEmpty ? "" : "${EmployeeDetails[0]['BankName'].toString()}" : "${Details[0]['BankName'].toString()}"}",
              Colorr.themcolor,
              14,
              FWeight.fW500),
        ],
      );

  Bank_Account_No() => Row(
        children: [
          CustomWidgets.poppinsText(
              "Bank Account No.", Colorr.themcolor, 15, FWeight.fW500),
          Spacer(),
          CustomWidgets.poppinsText(
              "${Details.isEmpty ? EmployeeDetails.isEmpty ? "" : "${EmployeeDetails[0]['BankAccountNo'].toString()}" : "${Details[0]['BankAccountNo'].toString()}"}",
              Colorr.themcolor,
              14,
              FWeight.fW500),
        ],
      );

  IFSC_Code() => Row(
        children: [
          CustomWidgets.poppinsText(
              "IFSC Code", Colorr.themcolor, 15, FWeight.fW500),
          Spacer(),
          CustomWidgets.poppinsText(
              "${Details.isEmpty ? EmployeeDetails.isEmpty ? "" : "${EmployeeDetails[0]['IFSCcode'].toString()}" : "${Details[0]['IFSCcode'].toString()}"}",
              Colorr.themcolor,
              14,
              FWeight.fW500),
        ],
      );

  Pan_No() => Row(
        children: [
          CustomWidgets.poppinsText(
              "Pan No.", Colorr.themcolor, 15, FWeight.fW500),
          Spacer(),
          CustomWidgets.poppinsText(
              "${Details.isEmpty ? EmployeeDetails.isEmpty ? "" : "${EmployeeDetails[0]['PANno'].toString()}" : "${Details[0]['PANno'].toString()}"}",
              Colorr.themcolor,
              14,
              FWeight.fW500),
        ],
      );

  BankBranch() => Row(
        children: [
          CustomWidgets.poppinsText(
              "Branch", Colorr.themcolor, 15, FWeight.fW500),
          Spacer(),
          CustomWidgets.poppinsText(
              "${Details.isEmpty ? EmployeeDetails.isEmpty ? "" : "${EmployeeDetails[0]['BankBranch'].toString()}" : "${Details[0]['BankBranch'].toString()}"}",
              Colorr.themcolor,
              14,
              FWeight.fW500),
        ],
      );

  Relationship() => Row(
        children: [
          CustomWidgets.poppinsText(
              "Relationship", Colorr.themcolor, 15, FWeight.fW500),
          Spacer(),
          CustomWidgets.poppinsText(
              "${Details.isEmpty ? EmployeeDetails.isEmpty ? "" : "${EmployeeDetails[0]['Relationship'].toString()}" : "${Details[0]['Relationship'].toString()}"}",
              Colorr.themcolor,
              14,
              FWeight.fW500),
        ],
      );

  Name() => Row(
        children: [
          CustomWidgets.poppinsText(
              "Name", Colorr.themcolor, 15, FWeight.fW500),
          Spacer(),
          CustomWidgets.poppinsText(
              "${Details.isEmpty ? EmployeeDetails.isEmpty ? "" : "${EmployeeDetails[0]['FamilyName'].toString()}" : "${Details[0]['FamilyName'].toString()}"}",
              Colorr.themcolor,
              14,
              FWeight.fW500),
        ],
      );

  Phone_No() => Row(
        children: [
          CustomWidgets.poppinsText(
              "Phone No", Colorr.themcolor, 15, FWeight.fW500),
          Spacer(),
          CustomWidgets.poppinsText(
              "${Details.isEmpty ? EmployeeDetails.isEmpty ? "" : "${EmployeeDetails[0]['FamilyPhone'].toString()}" : "${Details[0]['FamilyPhone'].toString()}"}",
              Colorr.themcolor,
              14,
              FWeight.fW500),
        ],
      );
  pan() => Row(
    children: [
      CustomWidgets.poppinsText(
          "PAN No", Colorr.themcolor, 15, FWeight.fW500),
      Spacer(),
      CustomWidgets.poppinsText(
          "${Details.isEmpty ? EmployeeDetails.isEmpty ? "" : "${EmployeeDetails[0]['PANno'].toString()}" : "${Details[0]['PANno'].toString()}"}",
          Colorr.themcolor,
          14,
          FWeight.fW500),
    ],
  );
  pf() => Row(
    children: [
      CustomWidgets.poppinsText(
          "PF No", Colorr.themcolor, 15, FWeight.fW500),
      Spacer(),
      CustomWidgets.poppinsText(
          "${Details.isEmpty ? EmployeeDetails.isEmpty ? "" : "${EmployeeDetails[0]['PFno'].toString()}" : "${Details[0]['PFno'].toString()}"}",
          Colorr.themcolor,
          14,
          FWeight.fW500),
    ],
  );
  esis() => Row(
    children: [
      CustomWidgets.poppinsText(
          "ESIS No", Colorr.themcolor, 15, FWeight.fW500),
      Spacer(),
      CustomWidgets.poppinsText(
          "${Details.isEmpty ? EmployeeDetails.isEmpty ? "" : "${EmployeeDetails[0]['ESICno'].toString()}" : "${Details[0]['ESICno'].toString()}"}",
          Colorr.themcolor,
          14,
          FWeight.fW500),
    ],
  );
  un() => Row(
    children: [
      CustomWidgets.poppinsText(
          "UN No", Colorr.themcolor, 15, FWeight.fW500),
      Spacer(),
      CustomWidgets.poppinsText(
          "${Details.isEmpty ? EmployeeDetails.isEmpty ? "" : "${EmployeeDetails[0]['UNno'].toString()}" : "${Details[0]['UNno'].toString()}"}",
          Colorr.themcolor,
          14,
          FWeight.fW500),
    ],
  );

  padding() => Padding(
        padding: const EdgeInsets.only(top: 2, bottom: 2, left: 7, right: 7),
        child: Divider(
          color: Colorr.themcolor,
          thickness: 1,
        ),
      );
}
