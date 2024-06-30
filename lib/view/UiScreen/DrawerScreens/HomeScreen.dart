// import 'package:attendy/utils/Constant/LocalCustomWidgets.dart';
// import 'package:attendy/Screens/DrawerOnly/DrawerOnly.dart';
// import 'package:attendy/utils/Constant/Colors.dart';
// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';
//
// import 'NotificationDetailScreen.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         key: _scaffoldKey,
//         drawer: const DrawerOnly(),
//         body: Column(
//           children: [
//             Container(
//               height: 50,
//               width: double.infinity,
//               alignment: Alignment.center,
//               color: Colorr.themcolor,
//               padding: const EdgeInsets.symmetric(horizontal: 9),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   GestureDetector(
//                     onTap: () => _scaffoldKey.currentState?.openDrawer(),
//                     child: Container(
//                       width: 40,
//                       height: 40,
//                       margin: const EdgeInsets.symmetric(horizontal: 8),
//                       child: ClipOval(
//                         child: Image.asset("images/user12.png", fit: BoxFit.cover),
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     splashRadius: 22,
//                     onPressed: () {
//                       Future.delayed(
//                         const Duration(microseconds: 700),
//                         () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => const NotificationDetailScreen()));
//                         },
//                       );
//                     },
//                     icon: const Icon(Icons.notifications_outlined,
//                         color: Colors.white, size: 30),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: ListView(
//                 children: [
//                   Center(
//                     child: Column(
//                       children: const [
//
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
