import 'dart:convert';
import 'dart:typed_data';

import 'package:attendy/A_SQL_Trigger/api_page.dart';
import 'package:flutter/material.dart';

import '../../A_SQL_Trigger/Con_List.dart';
import '../../A_SQL_Trigger/Con_Usermast.dart';
import '../../utils/Constant/Colors.dart';
import '../../utils/Constant/Con_icon.dart';
import '../../utils/Constant/FontWeight.dart';
import '../../utils/Constant/LocalCustomWidgets.dart';
import '../Dashboard/Dashboard.dart';
import 'UpdateCompanyInfo.dart';

class CompanyInfo extends StatefulWidget {
  const CompanyInfo({super.key});

  @override
  State<CompanyInfo> createState() => _CompanyInfoState();
}

class _CompanyInfoState extends State<CompanyInfo> {
  double Heigth = 0;
  double Width = 0;
  double appbar = 0;
  Uint8List? Logo;
  Map Company ={};

  @override
  void initState() {
    GetData();
    setState(() {});
    super.initState();
  }

  GetData() async {
    Con_List.CompanySelect = await api_page.CompanySelect();
Company=Con_List.CompanySelect.firstWhere((element) => element['_id'].toString()==Constants_Usermast.companyId.toString());
    String Temp = Company.containsKey('logo')?Company['logo']:"";
    if (Temp != "") {
      if (Temp.contains("data:image")) {
        Logo = base64.decode(Temp.split(',')[1]);
      } else {
        Logo = base64.decode(Temp);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Heigth = MediaQuery.of(context).size.height;
    Width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomWidgets.appbar(
        title: "Company Info",
        action: [
          Constants_Usermast.statuse == "ADMIN" ||Constants_Usermast.statuse != ""
              ? CustomWidgets.navigateBack(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return UpdateCompanyInfo(Company);
                      },
                    ));
                  },
                  icon: Con_icon.Edit,
                )
              : null
        ],
        context: context,
        onTap: () {
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) {
              return Dashboard();
            },
          ));
        },
      ),
      body: Company.isNotEmpty
          ? Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(color: Colorr.themcolor),
                Container(
                  decoration: BoxDecoration(
                      color: Colorr.White,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  height: Heigth - kToolbarHeight - Heigth / 5,
                  width: Width,
                  child: Container(
                    padding: EdgeInsets.only(top: 52),
                    child: ListView(children: [
                      Text_widget(
                          First: true,
                          body: Company.containsKey('name')?Company['name']:"",
                          titel: 'Company Name'),
                      Text_widget(
                          First: false,
                          body: Company.containsKey('_id')?Company['_id']:"",
                          titel: 'Company ID'),
                      Text_widget(
                          First: false,
                          body: Company.containsKey('address')?Company['address']:"",
                          titel: 'Company Address'),
                      Text_widget(
                          First: false,
                          body: Company.containsKey('area')?Company['area']:"",
                          titel: 'Area'),
                      Text_widget(
                          First: false,
                          body: Company.containsKey('city')?Company['city']:"",
                          titel: 'City'),
                      Text_widget(
                          First: false,
                          body: Company.containsKey('state')?Company['state']:"",
                          titel: 'State'),
                      Text_widget(
                          First: false,
                          body: Company.containsKey('country')?Company['country']:"",
                          titel: 'Country'),
                      Text_widget(
                          First: false,
                          body: Company.containsKey('zipCode')?Company['zipCode'].toString():"",
                          titel: 'ZipCode'),
                      Text_widget(
                          First: false,
                          body: Company.containsKey('Prefix')?Company['Prefix'].toString():"",
                          titel: 'Prefix'),
                    ]),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: Heigth / 1.45),
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: Logo != null
                            ? DecorationImage(
                                fit: BoxFit.fill, image: MemoryImage(Logo!))
                            : DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage("images/ps1.webp"))),
                    height: Width / 3.3,
                    width: Width / 3.3,
                  ),
                ),
              ],
            )
          : Container(
              child: Center(
                  child: Image.asset(
                      height: Heigth / 2 - kToolbarHeight,
                      width: Width / 2,
                      "images/NoData.webp")),
            ),
    );
  }

  Text_widget(
      {required bool First, required String titel, required String body}) {
    return Column(
      children: [
        First
            ? Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Container(
                  height: 1,
                  color: Colorr.themcolor,
                ),
              )
            : Container(),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Container(
              padding: EdgeInsets.only(left: 5, right: 5),
              height: 50,
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  CustomWidgets.poppinsText(
                      titel, Colorr.themcolor, 14, FWeight.fW500),
                  Spacer(),
                  CustomWidgets.poppinsText(
                      body, Colorr.themcolor, 14, FWeight.fW500)
                ],
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Container(
            height: 1,
            color: Colorr.themcolor,
          ),
        ),
      ],
    );
  }
}
