import 'package:attendy/A_SQL_Trigger/Announcement_api.dart';
import 'package:attendy/view/Announcement/Announcement.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../Modal/All_import.dart';
import '../Dashboard/Dashboard.dart';

class Add_Announcement extends StatefulWidget {
  Map? e;
  Add_Announcement({this.e});

  @override
  State<Add_Announcement> createState() => _Add_AnnouncementState();
}

class _Add_AnnouncementState extends State<Add_Announcement> {
  TextEditingController Title = TextEditingController();
  TextEditingController Desc = TextEditingController();
  TextEditingController Fromdate = TextEditingController();
  TextEditingController ToDate = TextEditingController();
  DateTime? fromDate;
  DateTime? toDate;
  double height =0;
  double width= 0;
  @override
  void initState() {
    if(widget.e!=null)
      {
        Title.text= widget.e!['Title'];
        Desc.text=widget.e!['Desc'];
        Fromdate.text=DateFormat("dd-MM-yyyy").format(DateTime.parse(widget.e!['fromDate']).toLocal());
        ToDate.text=DateFormat("dd-MM-yyyy").format(DateTime.parse(widget.e!['toDate']).toLocal());
      }
    setState(() {});
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height - kToolbarHeight;
    double width = MediaQuery.of(context).size.width;
    Future<bool> onBackPress() {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return Dashboard();
        },
      ));
      return Future.value(false);
    }
    return WillPopScope(
      onWillPop: () => onBackPress(),
      child: Scaffold(
        appBar: CustomWidgets.appbar(
          title:widget.e!=null?"Update Announcement":"Add Announcement",
          action: [],
          context: context,
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return Announcement();
              },
            ));
          },
        ),body: Container(child: Column(children: [
            CustomWidgets.textField(
              controller: Title,
              hintText: "Title",
            ),
            CustomWidgets.textField(
                hintText: "From Date",
                readOnly: true,
                controller: Fromdate,
                suffixIcon: InkWell(
                    onTap: () => _selectDate(context, "FromDate"),
                    child: CustomWidgets.DateIcon())),
            CustomWidgets.textField(
                hintText: "To Date",
                readOnly: true,
                controller: ToDate,
                suffixIcon: InkWell(
                    onTap: () => _selectDate1(context, "ToDate"),
                    child: CustomWidgets.DateIcon())),
            CustomWidgets.textField(
              Alignment1: Alignment.topCenter,
              textAlignVertical: TextAlignVertical.top,
              textAlign: TextAlign.start,
              maxLines: 5,
              height: MediaQuery.of(context).size.height / 7,
              controller: Desc,
              hintText: "Description",
            ),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomWidgets.confirmButton(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    Title.text = "";
                    Fromdate.text = "";
                    ToDate.text = "";
                    Desc.text = "";
                    setState(() {});
                  },
                  height: height / 20,
                  width: width / 3.3,
                  text: "Reset",
                  Clr: Colorr.Reset),
              CustomWidgets.width(10),
              CustomWidgets.confirmButton(
                  onTap: () async {
                    if(widget.e!=null)
                      {
                        Map Data={
                          "id":widget.e!['_id'],
                          "companyId": Constants_Usermast.companyId,
                          "fromDate":CustomWidgets.DateFormatchangeapi(Fromdate.text.toString()),
                          "toDate":CustomWidgets.DateFormatchangeapi(ToDate.text.toString()),
                          "Desc":Desc.text,
                          "Title":Title.text
                        };
                     await Announcement_Api.AnnouncementUpdate(Data);
                        CustomWidgets.showToast(context,
                            "Announcement Update Successfully", true);
                      }
                    else {
                      Map Data = {
                        "companyId": Constants_Usermast.companyId,
                        "fromDate": CustomWidgets.DateFormatchangeapi(Fromdate.text.toString()),
                        "toDate": CustomWidgets.DateFormatchangeapi(ToDate.text.toString()),
                        "Desc": Desc.text,
                        "Title": Title.text
                      };
                      await Announcement_Api.AnnouncementInser(Data);
                      CustomWidgets.showToast(context,
                          "Announcement Insert Successfully", true);


                    }
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                      return Announcement();
                    },));
                    FocusScope.of(context).unfocus();
                    if (await CustomWidgets
                        .CheakConnectionInternetButton()) {


                    } else {
                      CustomWidgets.showToast(context,
                          "No Internet Connection", false);
                    }
                  },
                  height: height / 20,
                  width: width / 3.3,
                  text: widget.e!=null?"Update":"Save")
            ]),

          ]),)),
    );
  }
  Future<void> _selectDate(BuildContext context, String date) async {
    DateTime selectedDate = DateTime.now();
    DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    DateTime dateTime = DateTime.now();
    if (Fromdate.text.isNotEmpty) {
      dateTime = dateFormat.parse(Fromdate.text);
    }
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: Fromdate.text.isNotEmpty ? dateTime : selectedDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colorr.themcolor, // <-- SEE HERE
              onPrimary: Colorr.White, // <-- SEE HERE
              onSurface: Colorr.themcolor, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Colorr.themcolor, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        if (date == "FromDate") {
          fromDate = picked;
          Fromdate.text = DateFormat('dd-MM-yyyy').format(picked);
        }
      });
    }
  }

  Future<void> _selectDate1(BuildContext context, String date) async {
    DateTime selectedDate = DateTime.now();
    DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    DateTime dateTime = DateTime.now();
    if (ToDate.text.isNotEmpty) {
      dateTime = dateFormat.parse(ToDate.text);
    }
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: ToDate.text.isNotEmpty ? dateTime : selectedDate,
      firstDate: fromDate ?? DateTime(2015),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colorr.themcolor, // <-- SEE HERE
              onPrimary: Colorr.White, // <-- SEE HERE
              onSurface: Colorr.themcolor, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Colorr.themcolor, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        toDate = picked;
        ToDate.text = DateFormat('dd-MM-yyyy').format(picked);

      });
    }
  }
}
