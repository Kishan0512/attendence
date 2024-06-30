import 'dart:convert';
import 'dart:developer';

import 'package:attendy/A_SQL_Trigger/api_page.dart';
import 'package:attendy/view/Employee/OfferLetter.dart';
import 'package:attendy/view/Setting/FaceUpdate.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:attendy/A_SQL_Trigger/Con_List.dart';
import 'package:attendy/utils/Constant/LocalCustomWidgets.dart';
import 'package:attendy/view/Logout/LogoutDialog.dart';
import 'package:attendy/view/Employee/Attendance.dart';
import 'package:attendy/view/Dashboard/Dashboard.dart';
import 'package:attendy/view/Employee/Destination.dart';
import 'package:attendy/view/Profile/EmployeeProfileScreen.dart';
import 'package:attendy/view/Employee/Holiday.dart';
import 'package:attendy/view/Employee/LeaveDetailScreen.dart';
import 'package:attendy/view/Users/Page%20permission.dart';
import 'package:attendy/view/UiScreen/DrawerScreens/ReportScreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:attendy/utils/Constant/Colors.dart';
import 'package:attendy/utils/Constant/FontWeight.dart';
import '../../A_SQL_Trigger/Con_Usermast.dart';
import '../../A_SQL_Trigger/Notification_api.dart';
import '../../A_SQL_Trigger/SharePref.dart';
import '../../view/Announcement/Announcement.dart';
import '../../view/Employee/LeaveType.dart';
import '../../view/Employee/Resignation.dart';
import '../../view/Employee/Shifttype.dart';
import '../../view/Activitie/Activities.dart';
import '../../view/Dashboard/AdminDashboard.dart';
import '../../view/Employee/AllEmployees.dart';
import '../../view/Payroll/EmployeeSalary.dart';
import '../../view/Policies/Policies.dart';
import '../../view/Report/AttendanceReport.dart';
import '../../view/Employee/Branch.dart';
import '../../view/Report/DailyReport.dart';
import '../../view/Employee/Department.dart';
import '../../view/Dashboard/Employee.dart';
import '../../view/Report/LeaveReport.dart';
import '../../view/Employee/Overtime.dart';
import '../../view/Payroll/Payroll.dart';
import '../../view/Payroll/Payrollitems.dart';
import '../../view/Payroll/Payslip.dart';
import '../../view/Report/MonthlyReport.dart';
import '../../view/Report/PayslipReport.dart';
import '../../view/Setting/CompanyInfo.dart';
import '../../view/Users/Role.dart';
import '../../view/Setting/SettingsDetailScreen.dart';
import '../../view/Employee/Shift.dart';
import '../../view/Subscription/Subscriptions.dart';
import '../../view/Ticket/Ticket.dart';
import '../../view/Users/User.dart';
import '../Log_in.dart';

class DrawerOnly extends StatefulWidget {
  const DrawerOnly({Key? key}) : super(key: key);

  @override
  State<DrawerOnly> createState() => _DrawerOnlyState();
}

class _DrawerOnlyState extends State<DrawerOnly> {
  bool EmployeesDetails = false;
  bool Dashboaritems = false;
  List<String> Submenu = [];
  Uint8List? image;
  bool Report = false;
  List<dynamic> Draweritem = [];
  List<bool> submenubutton = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getList();
    setState(() {});
  }

  getList() async {
    String tep =
        await SharedPref.read_string(SrdPrefkey.Profile.toString()) ?? "";
    if (tep != "") {
      if (tep.contains("data:image")) {
        image = base64.decode(tep.split(',')[1]);
      } else {
        image = base64.decode(tep);
      }
    }
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile &&
        connectivityResult == ConnectivityResult.wifi) {
      Con_List.Drawer = await api_page.PagepermissionApi();
    } else {
      Con_List.Drawer = await SharedPref.readlistDrawer("DrawerList");
    }

    Draweritem = Con_List.Drawer.where((e) => e['pageId'].toString() != "null"
        ? (e['pageId']['isMain'] == true &&
            e['pageId']['subMenu'].toString() == "" &&
            e['select'] == true)
        : false).toList();
    submenubutton = List.filled(Draweritem.length, false);
    setState(() {});
  }

  Widget build(BuildContext context) {
    return Constants_Usermast.IOS == true
        ? CupertinoPageScaffold(
            child: Container(
              height: double.infinity,
              width: MediaQuery.of(context).size.width / 1.57,
              child: CupertinoPageScaffold(
                child: Container(
                  color: Colorr.themcolor400,
                  child: CupertinoScrollbar(
                    child: Column(
                      children: [
                        pro_titel_Drawer(),
                        Expanded(
                          child: ListView.builder(
                            itemCount: Draweritem.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  CupertinoListTile(
                                    onTap: () {
                                      if (submenubutton[index] == false) {
                                        submenubutton = List.filled(
                                            Draweritem.length, false);
                                        Submenu = Con_List.Drawer.where((e) =>
                                                e['name'] ==
                                                    Draweritem[index]['name'] &&
                                                e['select'] == true &&
                                                e['subname'].isNotEmpty)
                                            .map((e) => e['subname'].toString())
                                            .toList();
                                        if (Submenu.isEmpty) {
                                          IsMainNavigate(
                                              Draweritem[index]['name'],
                                              context);
                                        }
                                        submenubutton[index] = true;
                                      } else {
                                        submenubutton[index] = false;
                                      }
                                      setState(() {});
                                    },
                                    trailing: Draweritem[index]['isSub'] == true
                                        ? Icon(Icons.arrow_drop_down,
                                            color: Colorr.themcolor50)
                                        : null,
                                    leading:
                                        Selectimage(Draweritem[index]['name']),
                                    title: Text("${Draweritem[index]['name']}",
                                        style: TextStyle(
                                            color: Colorr.themcolor50)),
                                  ),
                                  submenubutton[index] == true
                                      ? Container(
                                          height: Submenu.length * 44,
                                          // Set a fixed height for the container
                                          child: ListView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: Submenu.length,
                                            itemBuilder: (context, index) {
                                              return CupertinoListTile(
                                                onTap: () {
                                                  SubmenuNavigate(
                                                      Submenu[index]);
                                                },
                                                title: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    CustomWidgets.width(55),
                                                    Text("${Submenu[index]}",
                                                        style: TextStyle(
                                                            color: Colorr
                                                                .themcolor50))
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                      : Container(),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        : SafeArea(
            child: Drawer(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(50),
                  ),
                ),
                backgroundColor: Colorr.themcolor,
                width: 240,
                child: Container(
                    child: Column(
                  children: [
                    pro_titel_Drawer(),
                    Draweritem.isEmpty ? ListTile(
                      onTap: () =>showDialog(
                          context: context,
                          builder: (context) => LogoutDialog()
                      ),
                      leading: Selectimage("Sign Out"),
                      title: Text("Sign Out",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              color: Colorr.themcolor50,
                              fontSize: 13)),
                    ):Container(),
                    Expanded(
                        child: ListView.builder(
                      itemCount: Draweritem.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ListTile(
                              onTap: () {

                                if (submenubutton[index] == false) {

                                  submenubutton =
                                      List.filled(Draweritem.length, false);
                                  Submenu = Con_List.Drawer.where((e) => e['pageId'].toString()!="null"? (
                                          e['pageId']['mainsubMenu'] ==
                                              Draweritem[index]['pageId']
                                                  ['mainsubMenu'] &&
                                          e['select'] == true &&
                                          e['pageId']['subMenu'].isNotEmpty &&
                                          e['pageId']['subMenu']
                                                  .toString()
                                                  .toLowerCase() !=
                                              "menu"):false)
                                      .map((e) =>
                                          e['pageId']['subMenu'].toString())
                                      .toList();
                                  if (Submenu.isEmpty) {
                                    IsMainNavigate(
                                        Draweritem[index]['pageId']
                                            ['mainsubMenu'],
                                        context);
                                  }
                                  submenubutton[index] = true;
                                } else {
                                  submenubutton[index] = false;
                                }
                                setState(() {});
                              },
                              trailing:
                                  Draweritem[index]['pageId']['isSub'] == true
                                      ? submenubutton[index] == true
                                          ? Icon(
                                              Icons.arrow_drop_up,
                                              color: Colorr.themcolor50,
                                            )
                                          : Icon(
                                              Icons.arrow_drop_down,
                                              color: Colorr.themcolor50,
                                            )
                                      : null,
                              leading: Selectimage(
                                  Draweritem[index]['pageId']['mainsubMenu']),
                              title: Text(
                                  "${Draweritem[index]['pageId']['mainsubMenu']}",
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      color: Colorr.themcolor50,
                                      fontSize: 13)),
                            ),
                            submenubutton[index] == true
                                ? Container(
                                    height: Submenu.length * 55,
                                    // Set a fixed height for the container
                                    child: ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: Submenu.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          onTap: () {
                                            SubmenuNavigate(Submenu[index]);
                                          },
                                          title: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                CustomWidgets.width(55),
                                                Text("${Submenu[index]}",
                                                    style: TextStyle(
                                                        color:
                                                            Colorr.themcolor50,
                                                        fontFamily: "Poppins",
                                                        fontSize: 13))
                                              ]),
                                        );
                                      },
                                    ),
                                  )
                                : Container(),
                          ],
                        );
                      },
                    ))
                  ],
                )
                    // ListView(
                    //   children: [
                    //     pro_titel_Drawer(),
                    //
                    //     Dashboard_Drawer(),
                    //
                    //     Dashboaritems ? Dashboard_item():Container(),
                    //     Notifi_Drawer(),
                    //     Employee_Drawer(),
                    //     EmployeesDetails ?Employee_drawer2():Container(),
                    //     Holiday_Drawer(),
                    //     Report_Drawer(),
                    //     Report ? Report_drawer2() : Container(),
                    //     designationDrawer(),
                    //     Birthday_Drawer(),
                    //     Lenguages_Drawer(),
                    //     Setting_Drawer(),
                    //     Gethelp_Drawer(),
                    //     Logout_Drawer(),
                    //   ],
                    // )),
                    )));
  }

  IsMainNavigate(String name, BuildContext context) {
    switch (name) {
      case "Dashboard":
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return Dashboard();
          },
        ));
        break;
      case "Announcement":
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return Announcement();
          },
        ));
        break;
      case "Employees":
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return Employee();
          },
        ));
        break;
      case "Payroll":
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return Payroll();
          },
        ));
        break;
      case "Policies":
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return Policies();
          },
        ));
        break;
      case "Reports":
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return ReportScreen();
          },
        ));
        break;
      case "Activities":
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return Activities();
          },
        ));
        break;
      case "Setting":
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return SettingsDetailScreen();
          },
        ));
        break;
      case "Subscription":
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return Subscriptions();
          },
        ));
        break;
      // case "Privacy Policy":
      //   Navigator.push(context, MaterialPageRoute(
      //     builder: (context) {
      //       return Policy_details();
      //     },
      //   ));
      //   break;
      case "Profile":
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return EmployeeProfileScreen();
          },
        ));
        break;
      case "Users":
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return User();
          },
        ));
        break;
      case "Tickets":
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return Ticket();
          },
        ));
        break;
      case "Sign Out":
        Constants_Usermast.IOS == true
            ? showCupertinoDialog(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder: (context, setState1) {
                      return CupertinoAlertDialog(
                        title: Text('Logout'),
                        content: Text('Are you sure you want to\n Logout ?'),
                        actions: [
                          CupertinoDialogAction(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                            },
                          ),
                          CupertinoDialogAction(
                            child: Text('Logout'),
                            onPressed: () {
                              Constants_Usermast.BlankCaller();
                              SrdPrefkey.KeyClear.forEach(
                                  (e) => SharedPref.remove(e));
                              Notification_Api.NotificationSelect("true");
                              setState(() {
                                setState1(() {});
                              });
                              Navigator.pushReplacement(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => Log_in()));
                              // Perform logout logic hereClose the dialog
                              // Add your logout code here
                            },
                            isDestructiveAction:
                                true, // Highlights the action in red
                          ),
                        ],
                      );
                    },
                  );
                },
              )
            : showDialog(
                context: context,
                builder: (context) => LogoutDialog(),
              );
        break;
    }
  }

  SubmenuNavigate(String name) {
    switch (name) {
      case "Admin":
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return AdminDashboard();
          },
        ));
        break;
      case "Employee":
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return Employee();
          },
        ));
        break;
      case "All Employees":
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return AllEmployees();
          },
        ));
        break;
      case "Holidays":
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return Holiday_details();
          },
        ));
        break;
      case "Leaves":
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return LeaveDetailScreen();
          },
        ));
        break;
      case "Leave Type":
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return LeaveType();
          },
        ));
        break;
      case "Resignation":
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return Resignation();
          },
        ));
        break;
      case "Attendance":
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return Attendance();
          },
        ));
        break;
      case "Month Wise Report":
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return const MonthlyReport();
          },
        ));
        break;
      case "Departments":
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return Department();
          },
        ));
        break;
      case "Designations":
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return Designation();
          },
        ));
        break;
      case "Branch":
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return Branch();
          },
        ));
        break;
      case "Shift":
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return Shift();
          },
        ));
        break;
      case "Shift Type":
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return Shift_type();
          },
        ));
        break;
      case "Overtime":
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return Overtime();
          },
        ));
        break;
      case "Payslip":
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return Payslip();
          },
        ));
        break;
      case "Employee Salary":
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return EmployeeSalary();
          },
        ));
        break;
      case "Payroll items":
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return Payrollitems();
          },
        ));
        break;
      case "Payslip Report":
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return PayslipReport();
          },
        ));
        break;
      case "Attendance Report":
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return AttendanceReport();
          },
        ));
        break;
      case "Leave Report":
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return LeaveReport();
          },
        ));
        break;
      case "Offer Letter":
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return Offerletter();
          },
        ));
        break;
      case "Daily Report":
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return DailyReport();
          },
        ));
        break;
      case "Users":
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return User();
          },
        ));
        break;
      case "Role":
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return Role();
          },
        ));
        break;
      case "Page Permission":
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return PagePermission();
          },
        ));
        break;
      case "Face":
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return Face_update();
          },
        ));
        break;
      case "Company Info":
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return CompanyInfo();
          },
        ));
        break;
    }
  }

  Selectimage(String title) {
    switch (title) {
      case "Dashboard":
        return const Image(height: 20, image: AssetImage("images/dashboard.png"));

      case "Employees":
        return const Image(height: 20, image: AssetImage("images/Employee.webp"));

      case "Payroll":
        return const Image(height: 20, image: AssetImage("images/Payroll.webp"));

      case "Policies":
        return const Image(height: 20, image: AssetImage("images/Policies.webp"));

      case "Reports":
        return const Image(height: 20, image: AssetImage("images/report.webp"));

      case "Activities":
        return const Image(height: 20, image: AssetImage("images/Activity.webp"));

      case "Settings":
        return const Image(height: 20, image: AssetImage("images/settings.webp"));

      case "Subscription":
        return const Image(height: 20, image: AssetImage("images/subcription.webp"));

      case "Privacy Policy":
        return const Image(height: 20, image: AssetImage("images/privacypolicy.png"));

      case "Profile":
        return const Image(height: 20, image: AssetImage("images/profile.webp"));

      case "Users":
        return const Image(height: 20, image: AssetImage("images/Users.webp"));

      case "Tickets":
        return const Image(height: 20, image: AssetImage("images/Ticket.webp"));

      case "Sign Out":
        return const Image(height: 20, image: AssetImage("images/logout (3) 2.webp"));

      case "Announcement":
        return const Image(
          height: 20,
          image: AssetImage("images/announcement-icon.png"),
          color: Colors.white,
        );
        break;
    }
  }

  Widget pro_titel_Drawer() {
    return GestureDetector(
        onTap: () {
          if (Constants_Usermast.IOS == true) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const EmployeeProfileScreen()));
          } else {}
        },
        child: Container(
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xff4a978b),
          ),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const EmployeeProfileScreen()));
                  },
                  child: image == null
                      ? Image.asset(
                          "images/user12.png",
                          height: 50,
                        )
                      : Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: MemoryImage(image!),
                                  fit: BoxFit.cover))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "${Constants_Usermast.name}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "Poppins",
                      color: Colorr.White,
                      fontSize: 18,
                      fontWeight: FWeight.fW600),
                ),
              ),
            ],
          ),
        ));
  }
}
