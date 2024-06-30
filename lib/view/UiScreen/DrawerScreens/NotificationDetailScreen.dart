
import 'package:attendy/A_SQL_Trigger/Con_Usermast.dart';
import 'package:attendy/A_SQL_Trigger/Notification_api.dart';
import 'package:attendy/utils/Constant/LocalCustomWidgets.dart';
import 'package:attendy/view/Dashboard/Dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../A_SQL_Trigger/Con_List.dart';
import '../../../utils/Constant/Colors.dart';

class NotificationDetailScreen extends StatefulWidget {
  const NotificationDetailScreen({Key? key}) : super(key: key);

  @override
  State<NotificationDetailScreen> createState() =>
      _NotificationDetailScreenState();
}

class _NotificationDetailScreenState extends State<NotificationDetailScreen> {
  int internetConn=0;
  double width = 0;
  double height = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CheakInternet();
  Get();
  }
  Get() async {
   Con_List.Notification= await Notification_Api.NotificationSelect1();
   setState(() {});
  }
  CheakInternet()
  async {
    internetConn = await CustomWidgets.CheakConnectionInternet();
    setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {
     width = MediaQuery.of(context).size.width;
     height = MediaQuery.of(context).size.height;
    Future<bool> onBackPress() {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return Dashboard();
      },));
      return Future.value(false);
    }
    return Constants_Usermast.IOS ==true ?
    WillPopScope(
        onWillPop: () => onBackPress(),
        child: SafeArea(
      child: CupertinoPageScaffold(
          navigationBar: CustomWidgets.appbarIOS(title: "Notifications", action: [], context: context, onTap: () {
            Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) {
              return Dashboard();
            },));
          },),
          child: Column(children: [

      ],)),
        )):WillPopScope(
        onWillPop: () => onBackPress(),
    child: Scaffold(
        appBar:AppBar(
          backgroundColor: Colorr.themcolor,
          centerTitle: true,
          leading: IconButton(
            splashRadius: 18,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Dashboard();
              },));
            },
            icon: const Icon(Icons.arrow_back_ios_new_outlined),
          ),
          elevation: 0,
          title: const Text("Notifications"),
        ),
      body: mainwidget() ,
    )
    );
  }
  Widget mainwidget() {
    if (internetConn == 1) {
      return Con_List.Notification.isNotEmpty ? Container(
        child: ListView.builder(itemBuilder: (context, index) {
          return Con_List.Notification[index]['Type'] == "LEAVE"?Container(margin: const EdgeInsets.only(top: 2.5,bottom: 2.5,left: 5,right: 5),height: 150,width: double.infinity,decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),border: Border.all(width: 2,color: Colorr.themcolor)),child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
              Text("Leave add by "+Con_List.Notification[index]['username'],style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w500)),
              Text("From :- ${DateFormat("dd-MM-yyyy").format(DateTime.parse(Con_List.Notification[index]['fromDate']))}    To :- ${DateFormat("dd-MM-yyyy").format(DateTime.parse(Con_List.Notification[index]['toDate']))}"),
              Text("Status :- "+Con_List.Notification[index]['status']),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
                CustomWidgets.confirmButton(
                    onTap: () async {
                      CustomWidgets.showToast(context, "Api pending", false);
                    },
                    height: height / 20,
                    width: width / 3,
                    text: "Accept"),
                CustomWidgets.confirmButton(
                    onTap: () async {
                      CustomWidgets.showToast(context, "Api pending", false);
                    },
                    height: height / 20,Clr: Colorr.Reset,
                    width: width / 3,
                    text: "Reject")
              ],)
            ]),):Container(margin: const EdgeInsets.only(top: 2.5,bottom: 2.5,left: 5,right: 5),height: 150,width: double.infinity,decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),border: Border.all(width: 2,color: Colorr.themcolor)),child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children:  [
              Text( "${Con_List.Notification[index]['reason']} Holiday",style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w500)),
              Text("From :- ${DateFormat("dd-MM-yyyy").format(DateTime.parse(Con_List.Notification[index]['fromDate']))}    To :- ${DateFormat("dd-MM-yyyy").format(DateTime.parse(Con_List.Notification[index]['toDate']))}"),
            ]),);
        },itemCount: Con_List.Notification.length),
      ) : CustomWidgets.NoDataImage(context);
    } else if (internetConn == 2) {
      return CustomWidgets.NoInternetImage(context);
    } else {
      return CustomWidgets.Circularprogress(context);
    }
  }
}
