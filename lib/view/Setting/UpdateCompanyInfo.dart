import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:attendy/A_SQL_Trigger/Con_List.dart';
import 'package:attendy/A_SQL_Trigger/api_page.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../A_SQL_Trigger/Con_Usermast.dart';
import '../../utils/Constant/Colors.dart';
import '../../utils/Constant/Con_icon.dart';
import '../../utils/Constant/FontWeight.dart';
import '../../utils/Constant/LocalCustomWidgets.dart';
import 'CompanyInfo.dart';

class UpdateCompanyInfo extends StatefulWidget {
  Map Company;
  UpdateCompanyInfo(this.Company);

  @override
  State<UpdateCompanyInfo> createState() => _UpdateCompanyInfoState();
}

class _UpdateCompanyInfoState extends State<UpdateCompanyInfo> {
  final picker = ImagePicker();
  var Name = TextEditingController();
  var Address = TextEditingController();
  var Area = TextEditingController();
  var City = TextEditingController();
  var State = TextEditingController();
  var Counry = TextEditingController();
  var Zip = TextEditingController();
  var Prefix = TextEditingController();
  Uint8List? icon;
  Uint8List? logo;
  List<int> ImageBytecode = [];
  String iconBase64 = "";
  List<int> ImageBytecode1 = [];
  String logoBase64 = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.Company.isNotEmpty) {
      Name.text = widget.Company['name'];
      Address.text = widget.Company.containsKey("address")? widget.Company['address']:"";
      Area.text = widget.Company.containsKey("area")? widget.Company['area']:"";
      City.text = widget.Company.containsKey("city")? widget.Company['city']:"";
      State.text = widget.Company.containsKey("state")? widget.Company['state']:"";
      Counry.text = widget.Company.containsKey("country")? widget.Company['country']:"";
      Zip.text = widget.Company.containsKey("zipCode")? widget.Company['zipCode'].toString():"";
      Prefix.text = widget.Company.containsKey("Prefix")? widget.Company['Prefix'].toString():"";
    }
    getData();
    setState(() {});
  }

  getData() {
    iconBase64 = widget.Company.containsKey("icon")?widget.Company['icon']:"";
    if (iconBase64 != "") {
      if (iconBase64.contains("data:image")) {
        icon = base64.decode(iconBase64.split(',')[1]);
      } else {
        icon = base64.decode(iconBase64);
      }
    }
    logoBase64 = widget.Company.containsKey("logo")?widget.Company['logo']:"";
    if (logoBase64 != "") {
      if (logoBase64.contains("data:image")) {
        logo = base64.decode(logoBase64.split(',')[1]);
      } else {
        logo = base64.decode(logoBase64);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomWidgets.appbar(
        title: "Company Info",
        action: [],
        context: context,
        onTap: () {
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) {
              return CompanyInfo();
            },
          ));
        },
      ),
      body: Container(
          child: ListView(
        children: [
          SizedBox(
            height: 20,
          ),
          CustomWidgets.textField(hintText: "Company Name", controller: Name),
          CustomWidgets.textField1(
            hintText: "Address",
            controller: Address,
            keyboardType: TextInputType.streetAddress,
            maxLines: 3,
            height: MediaQuery.of(context).size.height / 10,
            textAlignVertical: TextAlignVertical.top,
            textAlign: TextAlign.start,
          ),
          CustomWidgets.textField(hintText: "Area", controller: Area),
          CustomWidgets.textField(hintText: "City Name", controller: City),
          CustomWidgets.textField(hintText: "State Name", controller: State),
          CustomWidgets.textField(hintText: "Country Name", controller: Counry),
          CustomWidgets.textField(
              hintText: "ZipCode Name",
              controller: Zip,
              keyboardType: TextInputType.number),
          CustomWidgets.textField(
              hintText: "Prefix",
              controller: Prefix),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: CustomWidgets.poppinsText(
                "Logo", Colorr.themcolor, 14, FWeight.fW500),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                  height: MediaQuery.of(context).size.height / 8,
                  width: MediaQuery.of(context).size.height / 8,
                  decoration: BoxDecoration(
                      color: Colorr.themcolor,
                      shape: BoxShape.circle,
                      image: logo == null
                          ? DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage("images/user12.png"))
                          : DecorationImage(
                              fit: BoxFit.fill, image: MemoryImage(logo!)))),
              TextButton(
                  onPressed: () {
                    _showDrawer_documents();
                  },
                  child: Text("Update Logo")),
            ]),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: CustomWidgets.poppinsText(
                "Icon", Colorr.themcolor, 14, FWeight.fW500),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                  height: MediaQuery.of(context).size.height / 8,
                  width: MediaQuery.of(context).size.height / 8,
                  decoration: BoxDecoration(
                      color: Colorr.themcolor,
                      shape: BoxShape.circle,
                      image: icon == null
                          ? DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage("images/user12.png"))
                          : DecorationImage(
                              fit: BoxFit.fill, image: MemoryImage(icon!)))),
              TextButton(
                  onPressed: () {
                    _showDrawer_document1();
                  },
                  child: Text("Update Icon"))
            ]),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomWidgets.confirmButton(
                  onTap: () async {
                    Map Data = {
                      "id": Constants_Usermast.companyId,
                      "logo": logoBase64.toString(),
                      "country": Counry.text,
                      "area": Area.text,
                      "city": City.text,
                      "state": State.text,
                      "zipCode": Zip.text,
                      "address": Address.text,
                      "icon": iconBase64.toString(),
                      "Prefix": Prefix.text,
                    };

                    await api_page.CompanyUpdate(Data);
                    CustomWidgets.showToast(
                        context, "Company Details Update Successfully", true);
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) {
                        return CompanyInfo();
                      },
                    ));
                  },
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.3,
                  text: "Update")
            ],
          ),
          SizedBox(
            height: 10,
          ),
        ],
      )),
    );
  }

  _showDrawer_documents() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
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
                  leading: IconButton(
                      color: Colorr.IconColor,
                      onPressed: () {},
                      icon: Con_icon.Camera),
                  title: Text('Take Logo '),
                  onTap: () async {
                    getlogo1();
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: IconButton(
                      color: Colorr.IconColor,
                      onPressed: () {},
                      icon: Icon(Icons.image)),
                  title: const Text('Select Logo'),
                  onTap: () async {
                    getlogo();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ));
        });
  }

  _showDrawer_document1() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
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
                  leading: IconButton(
                      color: Colorr.IconColor,
                      onPressed: () {},
                      icon: Con_icon.Camera),
                  title: Text('Take Icon '),
                  onTap: () async {
                    getIcon1();
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: IconButton(
                      color: Colorr.IconColor,
                      onPressed: () {},
                      icon: Icon(Icons.image)),
                  title: const Text('Select Icon'),
                  onTap: () async {
                    getIcon();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ));
        });
  }

  Future getIcon() async {
    XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    ImageBytecode = await pickedFile!.readAsBytes();
    iconBase64 = base64.encode(ImageBytecode);
    icon = base64.decode(iconBase64);
    setState(() {});
  }

  Future getIcon1() async {
    XFile? pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 50);

    ImageBytecode = await pickedFile!.readAsBytes();
    iconBase64 = base64.encode(ImageBytecode);
    icon = base64.decode(iconBase64);
    setState(() {});
  }

  Future getlogo() async {
    XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    ImageBytecode1 = await pickedFile!.readAsBytes();
    logoBase64 = base64.encode(ImageBytecode1);
    logo = base64.decode(logoBase64);

    setState(() {});
  }

  Future getlogo1() async {
    XFile? pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    ImageBytecode1 = await pickedFile!.readAsBytes();
    logoBase64 = base64.encode(ImageBytecode1);
    logo = base64.decode(logoBase64);

    setState(() {});
  }
}
