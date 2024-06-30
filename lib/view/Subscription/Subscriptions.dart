import 'package:attendy/utils/Constant/Con_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../A_SQL_Trigger/Con_Usermast.dart';
import '../../A_SQL_Trigger/Employee_Add_api.dart';
import '../../A_SQL_Trigger/subscription_api.dart';
import '../../utils/Constant/Colors.dart';
import '../../utils/Constant/LocalCustomWidgets.dart';
import '../Dashboard/Dashboard.dart';
import 'Payment_mail.dart';

class Subscriptions extends StatefulWidget {
  const Subscriptions({Key? key}) : super(key: key);

  @override
  State<Subscriptions> createState() => _SubscriptionsState();
}

class _SubscriptionsState extends State<Subscriptions> {
  double Height = 0;
  double Width = 0;
  bool Monthly = true;
  var Diffrence;
  final PageController _pageController = PageController(viewportFraction: 0.85);
  List<dynamic> subscriptionData = [];
   String  main ="" ,sub="", amount="";
  getData() async {
    subscriptionData = await Subscription_api.Subscription_select();
    if (subscriptionData.isNotEmpty) {
      String endDate = subscriptionData.last['endDate'];
      DateTime main = DateTime.parse(endDate).toLocal();
      Diffrence = main.difference(DateTime.now().toLocal()).inDays + 1;
    }
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    Height = MediaQuery.of(context).size.height - kToolbarHeight;
    Width = MediaQuery.of(context).size.width;
    List<Widget> page = [
      Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: Height / 14),
            decoration: BoxDecoration(
              color: Colorr.White,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colorr.themcolor,
                width: 3,
              ),
            ),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              CustomWidgets.height(Height / 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomWidgets.width(Width / 10),
                  Con_icon.Check,
                  CustomWidgets.width(Width / 35),
                  Text(
                    "User",
                    style: TextStyle(
                        color: Colorr.themcolor, fontSize: Height / 45),
                  ),
                ],
              ),
              CustomWidgets.height(Width / 45),
              Row(
                children: [
                  CustomWidgets.width(Width / 10),
                  Con_icon.Check,
                  CustomWidgets.width(Width / 35),
                  Text(
                    "Installation",
                    style: TextStyle(
                        color: Colorr.themcolor, fontSize: Height / 45),
                  ),
                ],
              ),
              CustomWidgets.height(Width / 45),
              Row(
                children: [
                  CustomWidgets.width(Width / 10),
                  Con_icon.Check,
                  CustomWidgets.width(Width / 35),
                  Text(
                    "5 GB Storage",
                    style: TextStyle(
                        color: Colorr.themcolor, fontSize: Height / 45),
                  ),
                ],
              ),
              CustomWidgets.height(Width / 45),
              Row(
                children: [
                  CustomWidgets.width(Width / 10),
                  Con_icon.Check,
                  CustomWidgets.width(Width / 35),
                  Text(
                    "Secure Date Storage",
                    style: TextStyle(
                        color: Colorr.themcolor, fontSize: Height / 45),
                  ),
                ],
              ),
              CustomWidgets.height(Width / 45),
              Row(
                children: [
                  CustomWidgets.width(Width / 10),
                  Con_icon.Check,
                  CustomWidgets.width(Width / 35),
                  Text(
                    "5 GB Storage",
                    style: TextStyle(
                        color: Colorr.themcolor, fontSize: Height / 45),
                  ),
                ],
              ),
              CustomWidgets.height(Width / 45),
              Row(
                children: [
                  CustomWidgets.width(Width / 10),
                  Con_icon.Check,
                  CustomWidgets.width(Width / 35),
                  Text(
                    "Secure Date Storage",
                    style: TextStyle(
                        color: Colorr.themcolor, fontSize: Height / 45),
                  ),
                ],
              ),
              CustomWidgets.height(Width / 45),
              Row(
                children: [
                  CustomWidgets.width(Width / 10),
                  Con_icon.Check,
                  CustomWidgets.width(Width / 35),
                  Text(
                    "5 GB Storage",
                    style: TextStyle(
                        color: Colorr.themcolor, fontSize: Height / 45),
                  ),
                ],
              ),
              Spacer(),
              CustomWidgets.confirmButton(
                  onTap: () async {
                    if (await CustomWidgets.CheakConnectionInternetButton()) {
                      Map Data = {
                        "companyId": Constants_Usermast.companyId,
                        "userId": Constants_Usermast.sId,
                        "mainPlan": "Monthly",
                        "startDate": DateTime.now().toLocal().toString(),
                        "endDate": DateTime.now()
                            .add(Duration(days: 7))
                            .toLocal()
                            .toString(),
                        "subPlan": "Free",
                        "paymentId": "0",
                        "totalDays": "7",
                        "planAmount": "0",
                      };
                      await Subscription_api.Subscription_insert(Data);
                      getData();
                      setState(() {});
                      // Razorpay razorpay = Razorpay();
                      // var options = {
                      //   'key': 'rzp_test_QzdHW86OK3S7qs',
                      //   'amount': 50000 * 100,
                      //   'name': "Subscription",
                      //   'description': "Attendy",
                      //   'retry': {'enabled': true, 'max_count': 1},
                      //   'send_sms_hash': true,
                      //   'prefill': {
                      //     'contact': '+918888888888',
                      //     'email': 'akak51546@gmail.com'
                      //   },
                      //   'external': {
                      //     'wallets': ['paytm']
                      //   }
                      // };
                      // razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
                      //     handlePaymentErrorResponse);
                      // razorpay.on(
                      //   Razorpay.EVENT_PAYMENT_SUCCESS,
                      //   handlePaymentSuccessResponse,
                      // );
                      // razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
                      //     handleExternalWalletSelected);
                      // razorpay.open(options);
                    } else {
                      CustomWidgets.showToast(
                          context, "No Internet Connection", false);
                    }
                  },
                  height: Height / 18,
                  width: Width / 2,
                  text: subscriptionData.isEmpty
                      ? "Start 7-Day Free Trial"
                      : subscriptionData.last['subPlan'] == "Free" &&  subscriptionData.last['mainPlan'] == "Monthly"
                          ? "Activated Plan\n Remaining $Diffrence Days"
                          : "Start 7-Day Free Trial"),
              CustomWidgets.height(Width / 45),
            ]),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: Height / 7,
              width: Width / 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colorr.themcolor,
                  width: 3,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colorr.themcolor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colorr.White,
                    width: 3,
                  ),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Free",
                          style: TextStyle(
                              color: Colorr.White, fontSize: Height / 45)),
                      Text("\$0",
                          style: TextStyle(
                              color: Colorr.White, fontSize: Height / 40))
                    ]),
              ),
            ),
          )
        ],
      ),
      Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: Height / 14),
            decoration: BoxDecoration(
              color: Colorr.White,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colorr.themcolor,
                width: 3,
              ),
            ),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              CustomWidgets.height(Height / 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomWidgets.width(Width / 10),
                  Con_icon.Check,
                  CustomWidgets.width(Width / 35),
                  Text(
                    "User",
                    style: TextStyle(
                        color: Colorr.themcolor, fontSize: Height / 45),
                  ),
                ],
              ),
              CustomWidgets.height(Width / 45),
              Row(
                children: [
                  CustomWidgets.width(Width / 10),
                  Con_icon.Check,
                  CustomWidgets.width(Width / 35),
                  Text(
                    "Installation",
                    style: TextStyle(
                        color: Colorr.themcolor, fontSize: Height / 45),
                  ),
                ],
              ),
              CustomWidgets.height(Width / 45),
              Row(
                children: [
                  CustomWidgets.width(Width / 10),
                  Con_icon.Check,
                  CustomWidgets.width(Width / 35),
                  Text(
                    "5 GB Storage",
                    style: TextStyle(
                        color: Colorr.themcolor, fontSize: Height / 45),
                  ),
                ],
              ),
              CustomWidgets.height(Width / 45),
              Row(
                children: [
                  CustomWidgets.width(Width / 10),
                  Con_icon.Check,
                  CustomWidgets.width(Width / 35),
                  Text(
                    "Secure Date Storage",
                    style: TextStyle(
                        color: Colorr.themcolor, fontSize: Height / 45),
                  ),
                ],
              ),
              CustomWidgets.height(Width / 45),
              Row(
                children: [
                  CustomWidgets.width(Width / 10),
                  Con_icon.Check,
                  CustomWidgets.width(Width / 35),
                  Text(
                    "5 GB Storage",
                    style: TextStyle(
                        color: Colorr.themcolor, fontSize: Height / 45),
                  ),
                ],
              ),
              CustomWidgets.height(Width / 45),
              Row(
                children: [
                  CustomWidgets.width(Width / 10),
                  Con_icon.Check,
                  CustomWidgets.width(Width / 35),
                  Text(
                    "Secure Date Storage",
                    style: TextStyle(
                        color: Colorr.themcolor, fontSize: Height / 45),
                  ),
                ],
              ),
              CustomWidgets.height(Width / 45),
              Row(
                children: [
                  CustomWidgets.width(Width / 10),
                  Con_icon.Check,
                  CustomWidgets.width(Width / 35),
                  Text(
                    "5 GB Storage",
                    style: TextStyle(
                        color: Colorr.themcolor, fontSize: Height / 45),
                  ),
                ],
              ),
              Spacer(),
              CustomWidgets.confirmButton(
                  onTap: () async {
                    if (await CustomWidgets.CheakConnectionInternetButton()) {
                      Razorpay razorpay = Razorpay();
                     main ="Monthly" ; sub="Standard"; amount="120";
                      var options = {
                        'key': 'rzp_test_QzdHW86OK3S7qs',
                        'amount': 120 * 100,
                        'name': "Subciption",
                        'description': "Attendy",
                        'retry': {'enabled': true, 'max_count': 1},
                        'send_sms_hash': true,
                        'prefill': {
                          'contact': '8888888888',
                          'email': 'test@razorpay.com'
                        },
                        'external': {
                          'wallets': ['paytm']
                        }
                      };
                      razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
                          handlePaymentErrorResponse);
                      razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
                          handlePaymentSuccessResponse);
                      razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
                          handleExternalWalletSelected);
                      razorpay.open(options);
                    } else {
                      CustomWidgets.showToast(
                          context, "No Internet Connection", false);
                    }
                  },
                  height: Height / 18,
                  width: Width / 2,
                  text: subscriptionData.isEmpty
                      ? "Go Premium"
                      : subscriptionData.last['subPlan'] == "Standard" && subscriptionData.last['mainPlan'] == "Monthly"
                          ? "Activated Plan\n Remaining $Diffrence Days"
                          : "Go Premium"),
              CustomWidgets.height(Width / 45),
            ]),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: Height / 7,
              width: Width / 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colorr.themcolor,
                  width: 3,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colorr.themcolor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colorr.White,
                    width: 3,
                  ),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Standard",
                          style: TextStyle(
                              color: Colorr.White, fontSize: Height / 45)),
                      Text("\$120", style: TextStyle(color: Colorr.White)),
                      Text("Per Month", style: TextStyle(color: Colorr.White)),
                    ]),
              ),
            ),
          )
        ],
      ),
      Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: Height / 14),
            decoration: BoxDecoration(
              color: Colorr.White,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colorr.themcolor,
                width: 3,
              ),
            ),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              CustomWidgets.height(Height / 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomWidgets.width(Width / 10),
                  Con_icon.Check,
                  CustomWidgets.width(Width / 35),
                  Text(
                    "User",
                    style: TextStyle(
                        color: Colorr.themcolor, fontSize: Height / 45),
                  ),
                ],
              ),
              CustomWidgets.height(Width / 45),
              Row(
                children: [
                  CustomWidgets.width(Width / 10),
                  Con_icon.Check,
                  CustomWidgets.width(Width / 35),
                  Text(
                    "Installation",
                    style: TextStyle(
                        color: Colorr.themcolor, fontSize: Height / 45),
                  ),
                ],
              ),
              CustomWidgets.height(Width / 45),
              Row(
                children: [
                  CustomWidgets.width(Width / 10),
                  Con_icon.Check,
                  CustomWidgets.width(Width / 35),
                  Text(
                    "5 GB Storage",
                    style: TextStyle(
                        color: Colorr.themcolor, fontSize: Height / 45),
                  ),
                ],
              ),
              CustomWidgets.height(Width / 45),
              Row(
                children: [
                  CustomWidgets.width(Width / 10),
                  Con_icon.Check,
                  CustomWidgets.width(Width / 35),
                  Text(
                    "Secure Date Storage",
                    style: TextStyle(
                        color: Colorr.themcolor, fontSize: Height / 45),
                  ),
                ],
              ),
              CustomWidgets.height(Width / 45),
              Row(
                children: [
                  CustomWidgets.width(Width / 10),
                  Con_icon.Check,
                  CustomWidgets.width(Width / 35),
                  Text(
                    "5 GB Storage",
                    style: TextStyle(
                        color: Colorr.themcolor, fontSize: Height / 45),
                  ),
                ],
              ),
              CustomWidgets.height(Width / 45),
              Row(
                children: [
                  CustomWidgets.width(Width / 10),
                  Con_icon.Check,
                  CustomWidgets.width(Width / 35),
                  Text(
                    "Secure Date Storage",
                    style: TextStyle(
                        color: Colorr.themcolor, fontSize: Height / 45),
                  ),
                ],
              ),
              CustomWidgets.height(Width / 45),
              Row(
                children: [
                  CustomWidgets.width(Width / 10),
                  Con_icon.Check,
                  CustomWidgets.width(Width / 35),
                  Text(
                    "5 GB Storage",
                    style: TextStyle(
                        color: Colorr.themcolor, fontSize: Height / 45),
                  ),
                ],
              ),
              Spacer(),
              CustomWidgets.confirmButton(
                  onTap: () async {
                    if (await CustomWidgets.CheakConnectionInternetButton()) {
                      Razorpay razorpay = Razorpay();
                      main ="Monthly" ; sub="Professional"; amount="450";
                      var options = {
                        'key': 'rzp_test_QzdHW86OK3S7qs',
                        'amount': 450 * 100,
                        'name': "Subciption",
                        'description': "Attendy",
                        'retry': {'enabled': true, 'max_count': 1},
                        'send_sms_hash': true,
                        'prefill': {
                          'contact': '8888888888',
                          'email': 'test@razorpay.com'
                        },
                        'external': {
                          'wallets': ['paytm']
                        }
                      };
                      razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
                          handlePaymentErrorResponse);
                      razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
                          handlePaymentSuccessResponse);
                      razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
                          handleExternalWalletSelected);
                      razorpay.open(options);
                    } else {
                      CustomWidgets.showToast(
                          context, "No Internet Connection", false);
                    }
                  },
                  height: Height / 18,
                  width: Width / 2,
                  text: subscriptionData.isEmpty
                      ? "Go Premium"
                      : subscriptionData.last['subPlan'] == "Professional" && subscriptionData.last['mainPlan'] == "Monthly"
                          ? "Activated Plan\n Remaining $Diffrence Days"
                          : "Go Premium"),
              CustomWidgets.height(Width / 45),
            ]),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: Height / 7,
              width: Width / 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colorr.themcolor,
                  width: 3,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colorr.themcolor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colorr.White,
                    width: 3,
                  ),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Professional",
                          style: TextStyle(
                              color: Colorr.White, fontSize: Height / 45)),
                      Text("\$450", style: TextStyle(color: Colorr.White)),
                      Text("Per Month", style: TextStyle(color: Colorr.White)),
                    ]),
              ),
            ),
          )
        ],
      )
    ];
    List<Widget> page1 = [
      Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: Height / 14),
            decoration: BoxDecoration(
              color: Colorr.White,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colorr.themcolor,
                width: 3,
              ),
            ),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              CustomWidgets.height(Height / 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomWidgets.width(Width / 10),
                  Con_icon.Check,
                  CustomWidgets.width(Width / 35),
                  Text(
                    "User",
                    style: TextStyle(
                        color: Colorr.themcolor, fontSize: Height / 45),
                  ),
                ],
              ),
              CustomWidgets.height(Width / 45),
              Row(
                children: [
                  CustomWidgets.width(Width / 10),
                  Con_icon.Check,
                  CustomWidgets.width(Width / 35),
                  Text(
                    "Installation",
                    style: TextStyle(
                        color: Colorr.themcolor, fontSize: Height / 45),
                  ),
                ],
              ),
              CustomWidgets.height(Width / 45),
              Row(
                children: [
                  CustomWidgets.width(Width / 10),
                  Con_icon.Check,
                  CustomWidgets.width(Width / 35),
                  Text(
                    "5 GB Storage",
                    style: TextStyle(
                        color: Colorr.themcolor, fontSize: Height / 45),
                  ),
                ],
              ),
              CustomWidgets.height(Width / 45),
              Row(
                children: [
                  CustomWidgets.width(Width / 10),
                  Con_icon.Check,
                  CustomWidgets.width(Width / 35),
                  Text(
                    "Secure Date Storage",
                    style: TextStyle(
                        color: Colorr.themcolor, fontSize: Height / 45),
                  ),
                ],
              ),
              CustomWidgets.height(Width / 45),
              Row(
                children: [
                  CustomWidgets.width(Width / 10),
                  Con_icon.Check,
                  CustomWidgets.width(Width / 35),
                  Text(
                    "5 GB Storage",
                    style: TextStyle(
                        color: Colorr.themcolor, fontSize: Height / 45),
                  ),
                ],
              ),
              CustomWidgets.height(Width / 45),
              Row(
                children: [
                  CustomWidgets.width(Width / 10),
                  Con_icon.Check,
                  CustomWidgets.width(Width / 35),
                  Text(
                    "Secure Date Storage",
                    style: TextStyle(
                        color: Colorr.themcolor, fontSize: Height / 45),
                  ),
                ],
              ),
              CustomWidgets.height(Width / 45),
              Row(
                children: [
                  CustomWidgets.width(Width / 10),
                  Con_icon.Check,
                  CustomWidgets.width(Width / 35),
                  Text(
                    "5 GB Storage",
                    style: TextStyle(
                        color: Colorr.themcolor, fontSize: Height / 45),
                  ),
                ],
              ),
              Spacer(),
              CustomWidgets.confirmButton(
                  onTap: () async {
                    if (await CustomWidgets.CheakConnectionInternetButton()) {
                      Map Data = {
                        "companyId": Constants_Usermast.companyId,
                        "userId": Constants_Usermast.sId,
                        "mainPlan": "Monthly",
                        "startDate": DateTime.now().toLocal().toString(),
                        "endDate": DateTime.now()
                            .add(Duration(days: 7))
                            .toLocal()
                            .toString(),
                        "subPlan": "Free",
                        "paymentId": "0",
                        "totalDays": "7",
                        "planAmount": "0",
                      };
                      await Subscription_api.Subscription_insert(Data);
                      getData();
                      setState(() {});
                      // Razorpay razorpay = Razorpay();
                      // var options = {
                      //   'key': 'rzp_test_QzdHW86OK3S7qs',
                      //   'amount': 50000 * 100,
                      //   'name': "Subscription",
                      //   'description': "Attendy",
                      //   'retry': {'enabled': true, 'max_count': 1},
                      //   'send_sms_hash': true,
                      //   'prefill': {
                      //     'contact': '+918888888888',
                      //     'email': 'akak51546@gmail.com'
                      //   },
                      //   'external': {
                      //     'wallets': ['paytm']
                      //   }
                      // };
                      // razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
                      //     handlePaymentErrorResponse);
                      // razorpay.on(
                      //   Razorpay.EVENT_PAYMENT_SUCCESS,
                      //   handlePaymentSuccessResponse,
                      // );
                      // razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
                      //     handleExternalWalletSelected);
                      // razorpay.open(options);
                    } else {
                      CustomWidgets.showToast(
                          context, "No Internet Connection", false);
                    }
                  },
                  height: Height / 18,
                  width: Width / 2,
                  text: subscriptionData.isEmpty
                      ? "Start 7-Day Free Trial"
                      : subscriptionData.last['subPlan'] == "Free" && subscriptionData.last['mainPlan'] == "Yearly"
                          ? "Activated Plan\n Remaining $Diffrence Days"
                          : "Start 7-Day Free Trial"),
              CustomWidgets.height(Width / 45),
            ]),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: Height / 7,
              width: Width / 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colorr.themcolor,
                  width: 3,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colorr.themcolor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colorr.White,
                    width: 3,
                  ),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Free",
                          style: TextStyle(
                              color: Colorr.White, fontSize: Height / 45)),
                      Text("\$0",
                          style: TextStyle(
                              color: Colorr.White, fontSize: Height / 40))
                    ]),
              ),
            ),
          )
        ],
      ),
      Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: Height / 14),
            decoration: BoxDecoration(
              color: Colorr.White,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colorr.themcolor,
                width: 3,
              ),
            ),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              CustomWidgets.height(Height / 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomWidgets.width(Width / 10),
                  Con_icon.Check,
                  CustomWidgets.width(Width / 35),
                  Text(
                    "User",
                    style: TextStyle(
                        color: Colorr.themcolor, fontSize: Height / 45),
                  ),
                ],
              ),
              CustomWidgets.height(Width / 45),
              Row(
                children: [
                  CustomWidgets.width(Width / 10),
                  Con_icon.Check,
                  CustomWidgets.width(Width / 35),
                  Text(
                    "Installation",
                    style: TextStyle(
                        color: Colorr.themcolor, fontSize: Height / 45),
                  ),
                ],
              ),
              CustomWidgets.height(Width / 45),
              Row(
                children: [
                  CustomWidgets.width(Width / 10),
                  Con_icon.Check,
                  CustomWidgets.width(Width / 35),
                  Text(
                    "5 GB Storage",
                    style: TextStyle(
                        color: Colorr.themcolor, fontSize: Height / 45),
                  ),
                ],
              ),
              CustomWidgets.height(Width / 45),
              Row(
                children: [
                  CustomWidgets.width(Width / 10),
                  Con_icon.Check,
                  CustomWidgets.width(Width / 35),
                  Text(
                    "Secure Date Storage",
                    style: TextStyle(
                        color: Colorr.themcolor, fontSize: Height / 45),
                  ),
                ],
              ),
              CustomWidgets.height(Width / 45),
              Row(
                children: [
                  CustomWidgets.width(Width / 10),
                  Con_icon.Check,
                  CustomWidgets.width(Width / 35),
                  Text(
                    "5 GB Storage",
                    style: TextStyle(
                        color: Colorr.themcolor, fontSize: Height / 45),
                  ),
                ],
              ),
              CustomWidgets.height(Width / 45),
              Row(
                children: [
                  CustomWidgets.width(Width / 10),
                  Con_icon.Check,
                  CustomWidgets.width(Width / 35),
                  Text(
                    "Secure Date Storage",
                    style: TextStyle(
                        color: Colorr.themcolor, fontSize: Height / 45),
                  ),
                ],
              ),
              CustomWidgets.height(Width / 45),
              Row(
                children: [
                  CustomWidgets.width(Width / 10),
                  Con_icon.Check,
                  CustomWidgets.width(Width / 35),
                  Text(
                    "5 GB Storage",
                    style: TextStyle(
                        color: Colorr.themcolor, fontSize: Height / 45),
                  ),
                ],
              ),
              Spacer(),
              CustomWidgets.confirmButton(
                  onTap: () async {
                    if (await CustomWidgets.CheakConnectionInternetButton()) {
                      Razorpay razorpay = Razorpay();
                     main ="Yearly" ; sub="Standard"; amount="1400";
                      var options = {
                        'key': 'rzp_test_QzdHW86OK3S7qs',
                        'amount': 1400 * 100,
                        'name': "Subciption",
                        'description': "Attendy",
                        'retry': {'enabled': true, 'max_count': 1},
                        'send_sms_hash': true,
                        'prefill': {
                          'contact': '8888888888',
                          'email': 'test@razorpay.com'
                        },
                        'external': {
                          'wallets': ['paytm']
                        }
                      };
                      razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
                          handlePaymentErrorResponse);
                      razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
                          handlePaymentSuccessResponse);
                      razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
                          handleExternalWalletSelected);
                      razorpay.open(options);
                    } else {
                      CustomWidgets.showToast(
                          context, "No Internet Connection", false);
                    }
                  },
                  height: Height / 18,
                  width: Width / 2,
                  text: subscriptionData.isEmpty
                      ? "Go Premium"
                      : subscriptionData.last['subPlan'] == "Standard" && subscriptionData.last['mainPlan'] == "Yearly"
                          ? "Activated Plan\n Remaining $Diffrence Days"
                          : "Go Premium"),
              CustomWidgets.height(Width / 45),
            ]),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: Height / 7,
              width: Width / 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colorr.themcolor,
                  width: 3,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colorr.themcolor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colorr.White,
                    width: 3,
                  ),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Standard",
                          style: TextStyle(
                              color: Colorr.White, fontSize: Height / 45)),
                      Text("\$1400", style: TextStyle(color: Colorr.White)),
                      Text("Per Year", style: TextStyle(color: Colorr.White)),
                    ]),
              ),
            ),
          )
        ],
      ),
      Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: Height / 14),
            decoration: BoxDecoration(
              color: Colorr.White,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colorr.themcolor,
                width: 3,
              ),
            ),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              CustomWidgets.height(Height / 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomWidgets.width(Width / 10),
                  Con_icon.Check,
                  CustomWidgets.width(Width / 35),
                  Text(
                    "User",
                    style: TextStyle(
                        color: Colorr.themcolor, fontSize: Height / 45),
                  ),
                ],
              ),
              CustomWidgets.height(Width / 45),
              Row(
                children: [
                  CustomWidgets.width(Width / 10),
                  Con_icon.Check,
                  CustomWidgets.width(Width / 35),
                  Text(
                    "Installation",
                    style: TextStyle(
                        color: Colorr.themcolor, fontSize: Height / 45),
                  ),
                ],
              ),
              CustomWidgets.height(Width / 45),
              Row(
                children: [
                  CustomWidgets.width(Width / 10),
                  Con_icon.Check,
                  CustomWidgets.width(Width / 35),
                  Text(
                    "5 GB Storage",
                    style: TextStyle(
                        color: Colorr.themcolor, fontSize: Height / 45),
                  ),
                ],
              ),
              CustomWidgets.height(Width / 45),
              Row(
                children: [
                  CustomWidgets.width(Width / 10),
                  Con_icon.Check,
                  CustomWidgets.width(Width / 35),
                  Text(
                    "Secure Date Storage",
                    style: TextStyle(
                        color: Colorr.themcolor, fontSize: Height / 45),
                  ),
                ],
              ),
              CustomWidgets.height(Width / 45),
              Row(
                children: [
                  CustomWidgets.width(Width / 10),
                  Con_icon.Check,
                  CustomWidgets.width(Width / 35),
                  Text(
                    "5 GB Storage",
                    style: TextStyle(
                        color: Colorr.themcolor, fontSize: Height / 45),
                  ),
                ],
              ),
              CustomWidgets.height(Width / 45),
              Row(
                children: [
                  CustomWidgets.width(Width / 10),
                  Con_icon.Check,
                  CustomWidgets.width(Width / 35),
                  Text(
                    "Secure Date Storage",
                    style: TextStyle(
                        color: Colorr.themcolor, fontSize: Height / 45),
                  ),
                ],
              ),
              CustomWidgets.height(Width / 45),
              Row(
                children: [
                  CustomWidgets.width(Width / 10),
                  Con_icon.Check,
                  CustomWidgets.width(Width / 35),
                  Text(
                    "5 GB Storage",
                    style: TextStyle(
                        color: Colorr.themcolor, fontSize: Height / 45),
                  ),
                ],
              ),
              Spacer(),
              CustomWidgets.confirmButton(
                  onTap: () async {
                    if (await CustomWidgets.CheakConnectionInternetButton()) {
                      Razorpay razorpay = Razorpay();
                      main ="Yearly" ; sub="Professional"; amount="5000";
                      var options = {
                        'key': 'rzp_test_QzdHW86OK3S7qs',
                        'amount': 5000 * 100,
                        'name': "Subciption",
                        'description': "Attendy",
                        'retry': {'enabled': true, 'max_count': 1},
                        'send_sms_hash': true,
                        'prefill': {
                          'contact': '8888888888',
                          'email': 'test@razorpay.com'
                        },
                        'external': {
                          'wallets': ['paytm']
                        }
                      };
                      razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
                          handlePaymentErrorResponse);
                      razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
                          handlePaymentSuccessResponse);
                      razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
                          handleExternalWalletSelected);
                      razorpay.open(options);
                    } else {
                      CustomWidgets.showToast(
                          context, "No Internet Connection", false);
                    }
                  },
                  height: Height / 18,
                  width: Width / 2,
                  text: subscriptionData.isEmpty
                      ? "Go Premium"
                      : subscriptionData.last['subPlan'] == "Professional" && subscriptionData.last['mainPlan'] == "Yearly"
                          ? "Activated Plan\n Remaining $Diffrence Days"
                          : "Go Premium"),
              CustomWidgets.height(Width / 45),
            ]),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: Height / 7,
              width: Width / 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colorr.themcolor,
                  width: 3,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colorr.themcolor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colorr.White,
                    width: 3,
                  ),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Professional",
                          style: TextStyle(
                              color: Colorr.White, fontSize: Height / 45)),
                      Text("\$5000", style: TextStyle(color: Colorr.White)),
                      Text("Per Yearly", style: TextStyle(color: Colorr.White)),
                    ]),
              ),
            ),
          )
        ],
      )
    ];

    setState(() {});

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
        child: Constants_Usermast.IOS == true
            ? CupertinoPageScaffold(
                navigationBar: CustomWidgets.appbarIOS(
                  title: "Subscription",
                  action: [],
                  context: context,
                  onTap: () {
                    Navigator.pushReplacement(context, CupertinoPageRoute(
                      builder: (context) {
                        return Dashboard();
                      },
                    ));
                  },
                ),
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    color: Colorr.Backgroundd,
                    child: Column(
                      children: [
                        CustomWidgets.height(Height / 15),
                        Container(
                          height: Height / 17,
                          width: Width / 1.5,
                          decoration: BoxDecoration(
                              color: Colorr.White,
                              borderRadius: BorderRadius.circular(5)),
                          padding: EdgeInsets.all(2),
                          child: Row(children: [
                            Expanded(
                                child: CustomWidgets.confirmButton1(
                                    textsize:
                                        MediaQuery.of(context).size.height * 0.02,
                                    onTap: () {
                                      Monthly = true;
                                      setState(() {});
                                    },
                                    height: Height / 20,
                                    text: "Monthly Plan",
                                    width: 5,
                                    Clr:
                                        Monthly ? Colorr.themcolor : Colorr.White,
                                    txtClr: Monthly
                                        ? Colorr.White
                                        : Colorr.themcolor)),
                            Expanded(
                                child: CustomWidgets.confirmButton1(
                                    textsize:
                                        MediaQuery.of(context).size.height * 0.02,
                                    onTap: () {
                                      Monthly = false;
                                      setState(() {});
                                    },
                                    height: Height / 20,
                                    width: 5,
                                    text: "Annual Plan",
                                    Clr:
                                        Monthly ? Colorr.White : Colorr.themcolor,
                                    txtClr: Monthly
                                        ? Colorr.themcolor
                                        : Colorr.White))
                          ]),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                height: Height / 1.4,
                                width: Width,
                                child: PageView.builder(
                                  controller: _pageController,
                                  physics: BouncingScrollPhysics(),
                                  itemCount: Monthly? page.length:page1.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: EdgeInsets.all(10),
                                      child: Monthly?page[index]:page1[index],
                                    );
                                  },
                                )),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )
            : Scaffold(
                appBar: CustomWidgets.appbar(
                  title: "Subscription",
                  action: [],
                  context: context,
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) {
                        return Dashboard();
                      },
                    ));
                  },
                ),
                body: Container(
                  color: Colorr.Backgroundd,
                  child: Column(
                    children: [
                      CustomWidgets.height(Height / 15),
                      Container(
                        height: Height / 17,
                        width: Width / 1.5,
                        decoration: BoxDecoration(
                            color: Colorr.White,
                            borderRadius: BorderRadius.circular(5)),
                        padding: EdgeInsets.all(2),
                        child: Row(children: [
                          Expanded(
                              child: CustomWidgets.confirmButton1(
                                  textsize:
                                      MediaQuery.of(context).size.height * 0.02,
                                  onTap: () {
                                    Monthly = true;
                                    setState(() {});
                                  },
                                  height: Height / 20,
                                  text: "Monthly Plan",
                                  width: 5,
                                  Clr:
                                      Monthly ? Colorr.themcolor : Colorr.White,
                                  txtClr: Monthly
                                      ? Colorr.White
                                      : Colorr.themcolor)),
                          Expanded(
                              child: CustomWidgets.confirmButton1(
                                  textsize:
                                      MediaQuery.of(context).size.height * 0.02,
                                  onTap: () {
                                    Monthly = false;
                                    setState(() {});
                                  },
                                  height: Height / 20,
                                  width: 5,
                                  text: "Annual Plan",
                                  Clr:
                                      Monthly ? Colorr.White : Colorr.themcolor,
                                  txtClr: Monthly
                                      ? Colorr.themcolor
                                      : Colorr.White))
                        ]),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              height: Height / 1.4,
                              width: Width,
                              child: PageView.builder(
                                controller: _pageController,
                                physics: BouncingScrollPhysics(),
                                itemCount: Monthly? page.length:page1.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsets.all(10),
                                    child: Monthly?page[index]:page1[index],
                                  );
                                },
                              )),
                        ],
                      )
                    ],
                  ),
                )));
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    showAlertDialog(context, "Payment Failed",
        "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
  }

  Future<void> handlePaymentSuccessResponse(PaymentSuccessResponse response ) async {
    Map Data = {
      "companyId": Constants_Usermast.companyId,
      "userId": Constants_Usermast.sId,
      "mainPlan": main,
      "startDate": DateTime.now().toLocal().toString(),
      "endDate": DateTime.now()
          .add(Duration(days: main=="Yearly"?sub =="Professional"?365:200 : sub =="Professional"?30:21))
          .toLocal()
          .toString(),
      "subPlan": sub,
      "paymentId": response.paymentId,
      "totalDays": main=="Yearly"?sub =="Professional"?"365":"200" : sub =="Professional"?"30":"21",
      "planAmount": amount,
    };
    await Subscription_api.Subscription_insert(Data);
    getData();
    setState(() {});
    Mail.PaymentMail();
    showAlertDialog(
        context, "Payment Successful", "Payment ID: ${response.paymentId}");
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    showAlertDialog(
        context, "External Wallet Selected", "${response.walletName}");
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    // set up the buttons
    Widget continueButton = CustomWidgets.confirmButton1(
        onTap: () {
          Navigator.pop(context);
        },
        height: 40,
        width: 150,
        text: "Continue",
        textsize: 14);
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
