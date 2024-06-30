import 'dart:async';
import 'dart:convert';

import 'package:attendy/A_SQL_Trigger/Con_List.dart';
import 'package:attendy/A_SQL_Trigger/Con_Usermast.dart';
import 'package:attendy/A_SQL_Trigger/Employee_Add_api.dart';
import 'package:attendy/A_SQL_Trigger/Notification_api.dart';
import 'package:attendy/A_SQL_Trigger/Role_api.dart';
import 'package:attendy/A_SQL_Trigger/Shift_typee_add_api.dart';
import 'package:attendy/utils/Constant/Colors.dart';
import 'package:attendy/utils/Constant/FontWeight.dart';
import 'package:attendy/Screens/DrawerOnly/DrawerOnly.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../A_SQL_Trigger/Notification.dart';
import '../../A_SQL_Trigger/SharePref.dart';
import '../../A_SQL_Trigger/Shift_Add_api.dart';
import 'Manual_Screen_tabs.dart';
import 'package:attendy/A_SQL_Trigger/api_page.dart';
import '../UiScreen/DrawerScreens/NotificationDetailScreen.dart';
import 'Scanner_Screen_tabs.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  var size, height, width;
  late TabController _tabController;
  int _currentIndex = 0;
  bool data = false;
  bool isDrawerOpen = true;
  late AnimationController _animationController;
  late Animation<double> _animation;
  List listforbord = ["Manual", "Scanner"];
  final SearchBar = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int Selected = 0;
  Uint8List? image;

  @override
  void initState() {
    // TODO: implement initState
    get();
    super.initState();
    print('Constants_Usermast.companyId'+Constants_Usermast.companyId);
    getdata();

    _tabController = TabController(length: 2, vsync: this);
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0, end: 0).animate(_animationController);
  }

  void toggleDrawer() {
    setState(() {

      isDrawerOpen = !isDrawerOpen;
      if (isDrawerOpen) {
        _animationController.forward();
        setState(() {});
      } else {
        _animationController.reverse();
        setState(() {});
      }
    });
  }
  get(){
    Timer.periodic(Duration(seconds: 10), (timer) {
        GetLeaveAlert();
        if(mounted){
        setState(() {
          Counting;
        });}
    });
  }
  getdata() async {

    String tep=await SharedPref.read_string(SrdPrefkey.Profile.toString()) ??"";
    String name=await SharedPref.read_string(SrdPrefkey.name.toString()) ??"";
    String pass=await SharedPref.read_string(SrdPrefkey.LoginPassword.toString()) ??"";
    if(tep!="") {
      if(tep.contains("data:image"))
      {
        image =base64.decode(tep.split(',')[1]);
      }else{
        image =base64.decode(tep);
      }
    }
    await api_page.logincheck(name , pass, "", "", "log_in");
    Con_List.Users = await api_page.userSelect();
    Con_List.Drawer = await api_page.PagepermissionApi();
    if (Con_List.Drawer.isNotEmpty) {
      data = true;
      SharedPref.savelist("DrawerList", Con_List.Drawer);
    }
    Con_List.RoleSelect = await Role_api.RoleSelect();
    // Con_List.AllEmployee= await AllEmployee_api.EmployeeSelect();
    Con_List.Allshift_Select = await Shift_Add_api.shift_Select();
    Constants_Usermast.statuse = Con_List.RoleSelect.firstWhere(
            (element) => element['_id'] == Constants_Usermast.roleid)['name']
        .toString();
    if (mounted) {
      setState(() {});
    }
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    Future<bool> onBackPress() {
      if (_tabController.index == 1) {
        // Tab 2 is open, switch to Tab 1
        _tabController.animateTo(0);
        // return false; // Prevent default back button behavior
      } else if (_tabController.index == 0) {
        SystemNavigator.pop();
      }
      // return true; // Allow default back button behavior
      return Future.value(false);
    }

    List<Widget> tabs = [
      // Widgets for each tab
      // Example:
      Column(
        children: [
          Expanded(
            child: Container(
              height: 50,
              width: double.infinity,
              alignment: Alignment.bottomCenter,
              color: Colorr.themcolor,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => toggleDrawer(),
                    child: Container(
                      width: 45,
                      height: 45,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: ClipOval(
                        child:
                            Image.asset("images/user12.png", fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  CupertinoButton(
                    minSize: 0,
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Future.delayed(
                        const Duration(microseconds: 700),
                        () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => NotificationDetailScreen(),
                            ),
                          );
                        },
                      );
                    },
                    child: Icon(
                      CupertinoIcons.bell,
                      color: CupertinoColors.white,
                      size: 25,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 12,
            child: Padding(
              padding: EdgeInsets.only(top: 8),
              child: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                  color: Colorr.themcolor50,
                ),
                child: ManualTabs(),
              ),
            ),
          ),
        ],
      ),
      Column(
        children: [
          Expanded(
            child: Container(
              height: 50,
              width: double.infinity,
              alignment: Alignment.bottomCenter,
              color: Colorr.themcolor,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => toggleDrawer(),
                    child: Container(
                      width: 45,
                      height: 45,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: ClipOval(
                        child:
                            Image.asset("images/user12.png", fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  CupertinoButton(
                    minSize: 0,
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Future.delayed(
                        const Duration(microseconds: 700),
                        () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => NotificationDetailScreen(),
                            ),
                          );
                        },
                      );
                    },
                    child: Icon(
                      CupertinoIcons.bell,
                      color: CupertinoColors.white,
                      size: 25,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 12,
            child: Padding(
              padding: EdgeInsets.only(top: 8),
              child: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                  color: Colorr.themcolor50,
                ),
                child: Scanner_Screen(),
              ),
            ),
          ),
        ],
      ),
    ];
    return Constants_Usermast.IOS == true
        ? CupertinoPageScaffold(
            child: SafeArea(
              child: CupertinoTabScaffold(
                tabBar: CupertinoTabBar(
                  activeColor: Colorr.themcolor,
                  inactiveColor: Colorr.Grey,
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Manual',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.face),
                      label: 'Scanner',
                    ),
                  ],
                  onTap: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
                tabBuilder: (BuildContext context, int index) {
                  return CupertinoPageScaffold(
                    backgroundColor: Colorr.themcolor,
                    child: Stack(
                      children: [
                        isDrawerOpen
                            ? tabs[_currentIndex]
                            : GestureDetector(
                                onTap: () {
                                  toggleDrawer();
                                },
                                child: tabs[_currentIndex]),
                        AnimatedContainer(
                          transformAlignment: Alignment.center,
                          duration: Duration(milliseconds: 300),
                          transform: Matrix4.translationValues(
                              isDrawerOpen ? -400 : 0, 0, 0),
                          child: data ? DrawerOnly() : Container(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          )
        : WillPopScope(
            onWillPop: onBackPress,
            child: DefaultTabController(
              length: listforbord.length,
              child: SafeArea(
                  child: Scaffold(
                backgroundColor: Colorr.themcolor,
                key: _scaffoldKey,
                drawer: const DrawerOnly(),
                body: Column(
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.bottomCenter,
                        padding: EdgeInsets.only(top: 5, left: 7, right: 7),
                        color: Colorr.themcolor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () =>
                                  _scaffoldKey.currentState?.openDrawer(),
                              child: Container(
                                width: 40,
                                height: 40,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: ClipOval(
                                  child: image!=null ?Image.memory(image!,fit: BoxFit.cover):Image.asset("images/user12.png",
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ),
                            InkWell(
                              radius: 18,
                              onTap:  () {
                                Future.delayed(
                                  const Duration(microseconds: 700),
                                  () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                NotificationDetailScreen()));
                                  },
                                );
                              },
                              child:Stack(alignment: Alignment.center,
                                children:  [
                                  const Icon(Icons.notifications_outlined,
                                      color: Colors.white, size: 25),
                                  Counting != 0 ? Padding(
                                    padding: const EdgeInsets.only(bottom: 20,left: 15),
                                    child: CircleAvatar(backgroundColor: Colors.red,radius: 10,child:Text(Counting.toString()),)):Container(),

                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 13,
                      child: Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Container(
                              height: double.infinity,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(50),
                                  topRight: Radius.circular(50),
                                ),
                                color: Colorr.themcolor50,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(top: 25, left: 10, right: 10),
                            child: SizedBox(
                              height: double.infinity,
                              child: Padding(
                                padding: EdgeInsets.only(top: 0),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(50),
                                          topRight: Radius.circular(50),
                                        ),
                                      ),
                                      height: 60,
                                      child: Material(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(30),
                                          topRight: Radius.circular(30),
                                        ),
                                        color: Colorr.themcolor50,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15, right: 15),
                                          child: TabBar(
                                            controller: _tabController,
                                            indicatorSize:
                                                TabBarIndicatorSize.label,
                                            indicatorWeight: 2,
                                            indicatorColor: Colorr.themcolor,
                                            indicatorPadding:
                                                EdgeInsets.only(bottom: 10),
                                            labelStyle: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FWeight.fW600,
                                              fontFamily: "Poppins",
                                            ),
                                            labelColor: Colorr.themcolor,
                                            unselectedLabelColor:
                                                Colorr.themcolor300,
                                            unselectedLabelStyle: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FWeight.fW500,
                                              fontFamily: "PoppinsM",
                                            ),
                                            tabs: List<Widget>.generate(
                                                listforbord.length, (index) {
                                              return Tab(
                                                text: listforbord[index],
                                              );
                                            }),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        child: TabBarView(
                                      controller: _tabController,
                                      children: [
                                        ManualTabs(),
                                        Scanner_Screen(),
                                      ],
                                    ))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
            ),
          );
  }
}
