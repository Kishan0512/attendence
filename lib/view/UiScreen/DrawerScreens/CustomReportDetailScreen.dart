
import 'package:attendy/utils/Constant/Colors.dart';
import 'package:attendy/utils/Constant/FontWeight.dart';
import 'package:attendy/utils/Constant/LocalCustomWidgets.dart';
import 'package:flutter/material.dart';

import '../../Dashboard/Dashboard.dart';

class CustomReportDetailScreen extends StatefulWidget {
  const CustomReportDetailScreen({Key? key}) : super(key: key);

  @override
  State<CustomReportDetailScreen> createState() =>
      _CustomReportDetailScreenState();
}

class _CustomReportDetailScreenState extends State<CustomReportDetailScreen> {
  TimeOfDay? Workingtime;
  TimeOfDay? WorkingPicked;
  TimeOfDay? Worktime;
  TimeOfDay? WorkPicked;
  DateTime startdate = DateTime.now();
  DateTime enddate = DateTime.now();

  void _StartDate() {
    showDatePicker(
            builder: (context, child) {
              return Theme(
                data: ThemeData.light().copyWith(
                  colorScheme: ColorScheme.light(
                    primary: Colorr.themcolor,
                    onPrimary: Colors.white,
                    onSurface: Colorr.themcolor,
                  ),
                ),
                child: child!,
              );
            },
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2090))
        .then((value) {
      setState(() {
        startdate = value!;
      });
    });
  }

  void _EndDate() {
    showDatePicker(
            builder: (context, child) {
              return Theme(
                data: ThemeData.light().copyWith(
                  colorScheme: ColorScheme.light(
                    primary: Colorr.themcolor,
                    onPrimary: Colors.white,
                    onSurface: Colorr.themcolor,
                  ),
                ),
                child: child!,
              );
            },
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2090))
        .then((value) {
      setState(() {
        enddate = value!;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Workingtime = const TimeOfDay(
      hour: 00,
      minute: 00,
    );
    Worktime = const TimeOfDay(
      hour: 00,
      minute: 00,
    );
  }

  Future<Null> WorkingSelectTime(BuildContext context) async {
    WorkingPicked = await showTimePicker(
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colorr.themcolor,
              onPrimary: Colors.white,
              onSurface: Colorr.themcolor,
            ),
          ),
          child: child!,
        );
      },
      context: context,
      initialTime: Workingtime!,
    );
    if (WorkingPicked != null) {
      setState(() {
        Workingtime = WorkingPicked;
      });
    }
  }

  Future<Null> WorkSelectTime(BuildContext context) async {
    WorkPicked = await showTimePicker(
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colorr.themcolor,
              onPrimary: Colors.white,
              onSurface: Colorr.themcolor,
            ),
          ),
          child: child!,
        );
      },
      context: context,
      initialTime: Worktime!,
    );
    if (WorkPicked != null) {
      setState(() {
        Worktime = WorkPicked;
      });
    }
  }

  var size, height, width;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    Future<bool> onBackPress() {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return Dashboard();
      },));
      return Future.value(false);
    }
    return WillPopScope(
        onWillPop: () => onBackPress(),
    child: Scaffold(
      backgroundColor: Colorr.themcolor50,
      appBar: CustomWidgets.appbar(title: "Custom Report",action:  [
      ],context:  context,onTap: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return Dashboard();
        },));
      },),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Text(
                                "Start Date",
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    color: Colorr.themcolor,
                                    fontSize: 18,
                                    fontWeight: FWeight.fW600),
                              ),
                            ),
                            CustomWidgets.container(
                              child: Center(
                                child: Text(
                                  "${startdate.day}-${startdate.month}-${startdate.year}",
                                  style: TextStyle(
                                      fontFamily: "PoppinsR",
                                      color: Colorr.themcolor300,
                                      fontSize: 18,
                                      fontWeight: FWeight.fW400),
                                ),
                              ),
                              onTap: _StartDate,
                              width: width * 0.4,
                            ),
                            // ElevatedButton(onPressed: _showDate, child: Text("jbh"))
                          ],
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Text(
                                "End Date",
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    color: Colorr.themcolor,
                                    fontSize: 18,
                                    fontWeight: FWeight.fW600),
                              ),
                            ),
                            CustomWidgets.container(
                              child: Center(
                                child: Text(
                                  "${enddate.day}-${enddate.month}-${enddate.year}",
                                  style: TextStyle(
                                      fontFamily: "PoppinsR",
                                      color: Colorr.themcolor300,
                                      fontSize: 18,
                                      fontWeight: FWeight.fW400),
                                ),
                              ),
                              onTap: _EndDate,
                              width: width * 0.4,
                            )
                          ],
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15, top: 30),
                      child: Text(
                        "Summary",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontFamily: "Poppins",
                            color: Colorr.themcolor,
                            fontSize: 22,
                            fontWeight: FWeight.fW600),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Present Day :",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontFamily: "PoppinsR",
                                color: Colorr.themcolor300,
                                fontSize: 18,
                                fontWeight: FWeight.fW400),
                          ),
                          CustomWidgets.container(
                            child: Center(
                              child: Text(
                                "0",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontFamily: "PoppinsM",
                                    color: Colorr.themcolor,
                                    fontSize: 18,
                                    fontWeight: FWeight.fW500),
                              ),
                            ),
                            width: width * 0.4,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Absent Day :",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontFamily: "PoppinsR",
                                color: Colorr.themcolor300,
                                fontSize: 18,
                                fontWeight: FWeight.fW400),
                          ),
                          CustomWidgets.container(
                            child: Center(
                              child: Text(
                                "0",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontFamily: "PoppinsM",
                                    color: Colorr.themcolor,
                                    fontSize: 18,
                                    fontWeight: FWeight.fW500),
                              ),
                            ),
                            width: width * 0.4,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Working Hours :",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontFamily: "PoppinsR",
                                color: Colorr.themcolor300,
                                fontSize: 18,
                                fontWeight: FWeight.fW400),
                          ),
                          CustomWidgets.container(
                            onTap: () {
                              setState(() {
                                WorkingSelectTime(context);
                              });
                            },
                            child: Center(
                              child: Text(
                                "${Workingtime?.hour}:${Workingtime?.minute}",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontFamily: "PoppinsM",
                                    color: Colorr.themcolor,
                                    fontSize: 18,
                                    fontWeight: FWeight.fW500),
                              ),
                            ),
                            width: width * 0.4,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Worked day :",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontFamily: "PoppinsR",
                                color: Colorr.themcolor300,
                                fontSize: 18,
                                fontWeight: FWeight.fW400),
                          ),
                          CustomWidgets.container(
                            child: Center(
                              child: Text(
                                "0",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontFamily: "PoppinsM",
                                    color: Colorr.themcolor,
                                    fontSize: 18,
                                    fontWeight: FWeight.fW500),
                              ),
                            ),
                            width: width * 0.4,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Worked Hours :",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontFamily: "PoppinsR",
                                color: Colorr.themcolor300,
                                fontSize: 18,
                                fontWeight: FWeight.fW400),
                          ),
                          CustomWidgets.container(
                            onTap: () {
                              setState(() {
                                WorkSelectTime(context);
                              });
                            },
                            child: Center(
                              child: Text(
                                "${Worktime?.hour}:${Worktime?.minute}",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontFamily: "PoppinsM",
                                    color: Colorr.themcolor,
                                    fontSize: 18,
                                    fontWeight: FWeight.fW500),
                              ),
                            ),
                            width: width * 0.4,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Column(
            children: [
              CustomWidgets.button(
                  buttonTitle: "Done",
                  onTap: () {},
                  color: Colorr.themcolor,
                  textColor: Colorr.White),
              SizedBox(
                height: 20,
              )
            ],
          )
        ],
      ),
    ));
  }
}
