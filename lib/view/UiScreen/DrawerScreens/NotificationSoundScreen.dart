import 'package:attendy/utils/Constant/Colors.dart';
import 'package:attendy/utils/Constant/FontWeight.dart';
import 'package:attendy/Screens/Dialog_box/Vibrate_dialog.dart';
import 'package:attendy/utils/Constant/LocalCustomWidgets.dart';
import 'package:flutter/material.dart';

import '../../Dashboard/Dashboard.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isOK = false;
  @override
  Widget build(BuildContext context) {
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

      // appBar: CustomWidgets.appbar("Notification Sound", [],context),
      // body: Padding(
      //   padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       /*  Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         children: [
      //           Text(
      //             "Conversation tones",
      //             textAlign: TextAlign.start,
      //             style: TextStyle(
      //                 fontFamily: "PoppinsM",
      //                 color: Colorr.themcolor,
      //                 fontSize: 18,
      //                 fontWeight: FWeight.fW500),
      //           ),
      //           Switch(
      //               value: isOK,
      //               activeColor: Colorr.themcolor,
      //               onChanged: (value) {
      //                 setState(() {
      //                   isOK = value;
      //                 });
      //               })
      //         ],
      //       ),
      //       Padding(
      //         padding: const EdgeInsets.only(top: 10),
      //         child: Container(
      //           height: 1.50,
      //           color: Colorr.themcolor,
      //         ),
      //       ),
      //       Padding(
      //         padding: const EdgeInsets.only(top: 10),
      //         child: Text(
      //           "Messages",
      //           textAlign: TextAlign.start,
      //           style: TextStyle(
      //               fontFamily: "PoppinsM",
      //               color: Colorr.themcolor300,
      //               fontSize: 14,
      //               fontWeight: FWeight.fW600),
      //         ),
      //       ),*/
      //       GestureDetector(
      //         onTap: () {},
      //         child: Container(
      //           width: double.infinity,
      //           color: Colorr.themcolor50,
      //           child: Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               Padding(
      //                 padding: const EdgeInsets.only(top: 10),
      //                 child: Text(
      //                   "Notification tone",
      //                   textAlign: TextAlign.start,
      //                   style: TextStyle(
      //                       fontFamily: "PoppinsM",
      //                       color: Colorr.themcolor,
      //                       fontSize: 18,
      //                       fontWeight: FWeight.fW500),
      //                 ),
      //               ),
      //               Text(
      //                 "Default (apple notification)",
      //                 textAlign: TextAlign.start,
      //                 style: TextStyle(
      //                     fontFamily: "PoppinsR",
      //                     color: Colorr.themcolor300,
      //                     fontSize: 12,
      //                     fontWeight: FWeight.fW400),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //       GestureDetector(
      //         onTap: () {
      //           showDialog(
      //             context: context,
      //             builder: (context) => Vibrate_dialog(),
      //           );
      //         },
      //         child: Container(
      //           width: double.infinity,
      //           color: Colorr.themcolor50,
      //           child: Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               Padding(
      //                 padding: const EdgeInsets.only(top: 20),
      //                 child: Text(
      //                   "Vibrate",
      //                   textAlign: TextAlign.start,
      //                   style: TextStyle(
      //                       fontFamily: "PoppinsM",
      //                       color: Colorr.themcolor,
      //                       fontSize: 18,
      //                       fontWeight: FWeight.fW500),
      //                 ),
      //               ),
      //               Text(
      //                 "Default",
      //                 textAlign: TextAlign.start,
      //                 style: TextStyle(
      //                     fontFamily: "PoppinsR",
      //                     color: Colorr.themcolor300,
      //                     fontSize: 12,
      //                     fontWeight: FWeight.fW400),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    ));
  }
}
