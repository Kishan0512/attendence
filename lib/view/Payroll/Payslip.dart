
import 'package:attendy/utils/Constant/Con_icon.dart';
import 'package:attendy/utils/Constant/LocalCustomWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:printing/printing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:attendy/utils/Constant/Colors.dart';

import '../../A_SQL_Trigger/Con_Usermast.dart';
import '../Dashboard/Dashboard.dart';
class Payslip extends StatefulWidget {
  const Payslip({Key? key}) : super(key: key);

  @override
  State<Payslip> createState() => _PayslipState();
}

class _PayslipState extends State<Payslip> {
  final pdf = pw.Document();
  double Height =0;
  late final image;
  double Width =0;
  late final Uint8List imageBytes;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   getdata();
  }
  getdata()
  async {
     image = await imageFromAssetBundle('images/Attendy Logo.webp');
  }
  Widget build(BuildContext context) {
    Height =MediaQuery.of(context).size.height-kToolbarHeight;
    Width =MediaQuery.of(context).size.width;
    Future<bool> onBackPress() {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return Dashboard();
      },));
      return Future.value(false);
    }
    return WillPopScope(
        onWillPop: () => onBackPress(),
    child: Constants_Usermast.IOS==true ? CupertinoPageScaffold(
        navigationBar: CustomWidgets.appbarIOS(title: "PaySlip", action: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: Con_icon.Print,
            onPressed: () {
              _generatePdf();
            },
          )
        ], context: context, onTap: () {
          Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) {
            return Dashboard();
          },));
        },),
        child:Container(
            height: double.infinity,
            width: double.infinity,
            color: Colorr.White,
            child:  Container(
              padding: EdgeInsets.all(5),
              color: Colorr.White,
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomWidgets.height(Height/40),
                      Row(mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomWidgets.width(Width/30),
                          Container(height: Height/25,width: Width/8,child: Image(image: AssetImage("images/Attendy Logo.webp")),),
                          CustomWidgets.width(Width/10),
                          Text("Payslip For The Month Of April 2023",style: TextStyle(color: Colorr.themcolor500),)
                        ],),
                      CustomWidgets.height(Height/40),
                      Row(mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomWidgets.width(Width/30),
                          Text("3864 Quiet Valley Lane,\nSherman Oaks, CA, 91403",style: TextStyle(color: Colorr.Black),),
                        ],),
                      CustomWidgets.height(Height/40),
                      Container(height: Height/2.6,width: Width,decoration: BoxDecoration(border: Border.all(width: 2,color: Colorr.Black54)),child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomWidgets.height(Height/50),
                            Text("  Employee Name : John Joe",style: TextStyle(color: Colorr.Black54),),
                            CustomWidgets.height(Height/50),
                            Text("  Department : Android Developer",style: TextStyle(color: Colorr.Black54),),
                            CustomWidgets.height(Height/50),
                            Text("  Designation : Application Devlopement",style: TextStyle(color: Colorr.Black54),),
                            CustomWidgets.height(Height/50),
                            Text("  Joining Date : 1 January 2023",style: TextStyle(color: Colorr.Black54),),
                            CustomWidgets.height(Height/50),
                            Text("  Employee ID : rgb-714",style: TextStyle(color: Colorr.Black54),),
                            CustomWidgets.height(Height/50),
                            Text("  Bank Name : Sbi Bank",style: TextStyle(color: Colorr.Black54),),
                            CustomWidgets.height(Height/50),
                            Text("  Bank Account Number : 714714714714",style: TextStyle(color: Colorr.Black54),),
                            CustomWidgets.height(Height/50),
                            Text("  Pan Number : HDIFH249K",style: TextStyle(color: Colorr.Black54),),
                          ]),),
                      CustomWidgets.height(Height/40),
                      Row(children: [
                        CustomWidgets.width(Width/30),
                        Text("Earnings",style: TextStyle(color: Colorr.Black,fontSize: 18),)
                      ],),
                      CustomWidgets.height(Height/40),
                      Container(height: Height/3.6,width: Width,decoration: BoxDecoration(border: Border.all(width: 2,color: Colorr.Black54)),child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomWidgets.height(Height/80),
                            Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text("Basic Salary",style: TextStyle(color: Colorr.Black54),),
                                Text("₹ 15000",style: TextStyle(color: Colorr.Black54),),
                              ],),
                            CustomWidgets.height(Height/80),
                            Divider(height: 2,color: Colorr.Black54,),
                            CustomWidgets.height(Height/80),
                            Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text("Special Allowances",style: TextStyle(color: Colorr.Black54),),
                                Text("₹ 15000",style: TextStyle(color: Colorr.Black54),),
                              ],),
                            CustomWidgets.height(Height/80),
                            Divider(height: 2,color: Colorr.Black54,),
                            CustomWidgets.height(Height/80),
                            Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text("Gross Salary",style: TextStyle(color: Colorr.Black54),),
                                Text("₹ 15000",style: TextStyle(color: Colorr.Black54),),
                              ],),
                            CustomWidgets.height(Height/80),
                            Divider(height: 2,color: Colorr.Black54,),
                            CustomWidgets.height(Height/80),
                            Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text("Medical Allowances",style: TextStyle(color: Colorr.Black54),),
                                Text("₹ 15000",style: TextStyle(color: Colorr.Black54),),
                              ],),
                            CustomWidgets.height(Height/80),
                            Divider(height: 4,thickness: 1,color: Colorr.Black,),
                            CustomWidgets.height(Height/80),
                            Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text("Total Earnings",style: TextStyle(color: Colorr.Black54),),
                                Text("₹ 30000",style: TextStyle(color: Colorr.Black54),),
                              ],),
                          ]),),
                      CustomWidgets.height(Height/40),
                      Row(children: [
                        CustomWidgets.width(Width/30),
                        Text("Deductions",style: TextStyle(color: Colorr.Black,fontSize: 18),)
                      ],),
                      CustomWidgets.height(Height/40),
                      Container(height: Height/3.6,width: Width,decoration: BoxDecoration(border: Border.all(width: 2,color: Colorr.Black54)),child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomWidgets.height(Height/80),
                            Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text("Provident Fund",style: TextStyle(color: Colorr.Black54),),
                                Text("₹ 15000",style: TextStyle(color: Colorr.Black54),),
                              ],),
                            CustomWidgets.height(Height/80),
                            Divider(height: 2,color: Colorr.Black54,),
                            CustomWidgets.height(Height/80),
                            Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text("ESI",style: TextStyle(color: Colorr.Black54),),
                                Text("₹ 15000",style: TextStyle(color: Colorr.Black54),),
                              ],),
                            CustomWidgets.height(Height/80),
                            Divider(height: 2,color: Colorr.Black54,),
                            CustomWidgets.height(Height/80),
                            Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text("Income Tax",style: TextStyle(color: Colorr.Black54),),
                                Text("₹ 15000",style: TextStyle(color: Colorr.Black54),),
                              ],),
                            CustomWidgets.height(Height/80),
                            Divider(height: 2,color: Colorr.Black54,),
                            CustomWidgets.height(Height/80),
                            Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text("Professional Tax",style: TextStyle(color: Colorr.Black54),),
                                Text("₹ 15000",style: TextStyle(color: Colorr.Black54),),
                              ],),
                            CustomWidgets.height(Height/80),
                            Divider(height: 4,thickness: 1,color: Colorr.Black,),
                            CustomWidgets.height(Height/80),
                            Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text("Total Earnings",style: TextStyle(color: Colorr.Black54),),
                                Text("₹ 30000",style: TextStyle(color: Colorr.Black54),),
                              ],),
                          ]),),
                      CustomWidgets.height(Height/40),
                      Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Net Pay : ₹ 1,20,000 (One Hundred and Twenty Thousand)",style: TextStyle(fontSize: 12),)
                        ],),
                      CustomWidgets.height(Height/20),
                      Row(mainAxisAlignment: MainAxisAlignment.end,children: [
                        Container(
                          width: Width/3,
                          decoration: BoxDecoration(
                              border: Border(top: BorderSide(color: Colorr.Black))
                          ),
                        ),
                        CustomWidgets.width(Width/50),
                      ],),
                      CustomWidgets.height(Height/100),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: Width/3,
                            child: Center(child: Text("Employee Signature",style: TextStyle(fontSize: 12),)) ,
                          ),
                          CustomWidgets.width(Height/80),
                        ],),
                    ]),
              ),
            ))) : Scaffold(
      appBar: CustomWidgets.appbar(title: "Payslip",action:  [
        IconButton(splashRadius: 18,onPressed: () async {
          _generatePdf();
        }, icon: Con_icon.Print)
      ],context:  context,onTap: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return Dashboard();
        },));
      },),
      body: Container(
        padding: EdgeInsets.all(10),
        color: Colorr.themcolor50,
        height: Height,
        width: Width,
        child: Container(
          padding: EdgeInsets.all(5),
          color: Colorr.White,
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              CustomWidgets.height(Height/40),
              Row(mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomWidgets.width(Width/30),
                  Container(height: Height/25,width: Width/8,child: Image(image: AssetImage("images/Attendy Logo.webp")),),
                  CustomWidgets.width(Width/10),
               Text("Payslip For The Month Of April 2023",style: TextStyle(color: Colorr.themcolor500),)
              ],),
              CustomWidgets.height(Height/40),
              Row(mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomWidgets.width(Width/30),
               Text("3864 Quiet Valley Lane,\nSherman Oaks, CA, 91403",style: TextStyle(color: Colorr.Black),),
              ],),
              CustomWidgets.height(Height/40),
              Container(height: Height/2.6,width: Width,decoration: BoxDecoration(border: Border.all(width: 2,color: Colorr.Black54)),child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                CustomWidgets.height(Height/50),
                Text("  Employee Name : John Joe",style: TextStyle(color: Colorr.Black54),),
                    CustomWidgets.height(Height/50),
                Text("  Department : Android Developer",style: TextStyle(color: Colorr.Black54),),
                    CustomWidgets.height(Height/50),
                Text("  Designation : Application Devlopement",style: TextStyle(color: Colorr.Black54),),
                    CustomWidgets.height(Height/50),
                Text("  Joining Date : 1 January 2023",style: TextStyle(color: Colorr.Black54),),
                    CustomWidgets.height(Height/50),
                Text("  Employee ID : rgb-714",style: TextStyle(color: Colorr.Black54),),
                    CustomWidgets.height(Height/50),
                Text("  Bank Name : Sbi Bank",style: TextStyle(color: Colorr.Black54),),
                    CustomWidgets.height(Height/50),
                Text("  Bank Account Number : 714714714714",style: TextStyle(color: Colorr.Black54),),
                    CustomWidgets.height(Height/50),
                Text("  Pan Number : HDIFH249K",style: TextStyle(color: Colorr.Black54),),
              ]),),
              CustomWidgets.height(Height/40),
             Row(children: [
               CustomWidgets.width(Width/30),
               Text("Earnings",style: TextStyle(color: Colorr.Black,fontSize: 18),)
             ],),
                  CustomWidgets.height(Height/40),
                  Container(height: Height/3.6,width: Width,decoration: BoxDecoration(border: Border.all(width: 2,color: Colorr.Black54)),child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomWidgets.height(Height/80),
                        Row(mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomWidgets.width(Width/8),
                          Text("Basic Salary",style: TextStyle(color: Colorr.Black54),),
                          Spacer(),
                          Text("₹ 15000",style: TextStyle(color: Colorr.Black54),),
                            CustomWidgets.width(Width/8),
                        ],),
                        CustomWidgets.height(Height/80),
                        Divider(height: 2,color: Colorr.Black54,),
                        CustomWidgets.height(Height/80),
                        Row(mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomWidgets.width(Width/8),
                            Text("Special Allowances",style: TextStyle(color: Colorr.Black54),),
                            Spacer(),
                            Text("₹ 15000",style: TextStyle(color: Colorr.Black54),),
                            CustomWidgets.width(Width/8),
                          ],),
                        CustomWidgets.height(Height/80),
                        Divider(height: 2,color: Colorr.Black54,),
                        CustomWidgets.height(Height/80),
                        Row(mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomWidgets.width(Width/8),
                            Text("Gross Salary",style: TextStyle(color: Colorr.Black54),),
                            Spacer(),
                            Text("₹ 15000",style: TextStyle(color: Colorr.Black54),),
                            CustomWidgets.width(Width/8),
                          ],),
                        CustomWidgets.height(Height/80),
                        Divider(height: 2,color: Colorr.Black54,),
                        CustomWidgets.height(Height/80),
                        Row(mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomWidgets.width(Width/8),
                            Text("Medical Allowances",style: TextStyle(color: Colorr.Black54),),
                            Spacer(),
                            Text("₹ 15000",style: TextStyle(color: Colorr.Black54),),
                            CustomWidgets.width(Width/8),
                          ],),
                        CustomWidgets.height(Height/80),
                        Divider(height: 4,thickness: 1,color: Colorr.Black,),
                        CustomWidgets.height(Height/80),
                        Row(mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomWidgets.width(Width/8),
                            Text("Total Earnings",style: TextStyle(color: Colorr.Black54),),
                            Spacer(),
                            Text("₹ 30000",style: TextStyle(color: Colorr.Black54),),
                            CustomWidgets.width(Width/8),
                          ],),
                      ]),),
                  CustomWidgets.height(Height/40),
                  Row(children: [
                    CustomWidgets.width(Width/30),
                    Text("Deductions",style: TextStyle(color: Colorr.Black,fontSize: 18),)
                  ],),
                  CustomWidgets.height(Height/40),
                  Container(height: Height/3.6,width: Width,decoration: BoxDecoration(border: Border.all(width: 2,color: Colorr.Black54)),child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomWidgets.height(Height/80),
                        Row(mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomWidgets.width(Width/8),
                            Text("Provident Fund",style: TextStyle(color: Colorr.Black54),),
                            Spacer(),
                            Text("₹ 15000",style: TextStyle(color: Colorr.Black54),),
                            CustomWidgets.width(Width/8),
                          ],),
                        CustomWidgets.height(Height/80),
                        Divider(height: 2,color: Colorr.Black54,),
                        CustomWidgets.height(Height/80),
                        Row(mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomWidgets.width(Width/8),
                            Text("ESI",style: TextStyle(color: Colorr.Black54),),
                            Spacer(),
                            Text("₹ 15000",style: TextStyle(color: Colorr.Black54),),
                            CustomWidgets.width(Width/8),
                          ],),
                        CustomWidgets.height(Height/80),
                        Divider(height: 2,color: Colorr.Black54,),
                        CustomWidgets.height(Height/80),
                        Row(mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomWidgets.width(Width/8),
                            Text("Income Tax",style: TextStyle(color: Colorr.Black54),),
                            Spacer(),
                            Text("₹ 15000",style: TextStyle(color: Colorr.Black54),),
                            CustomWidgets.width(Width/8),
                          ],),
                        CustomWidgets.height(Height/80),
                        Divider(height: 2,color: Colorr.Black54,),
                        CustomWidgets.height(Height/80),
                        Row(mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomWidgets.width(Width/8),
                            Text("Professional Tax",style: TextStyle(color: Colorr.Black54),),
                            Spacer(),
                            Text("₹ 15000",style: TextStyle(color: Colorr.Black54),),
                            CustomWidgets.width(Width/8),
                          ],),
                        CustomWidgets.height(Height/80),
                        Divider(height: 4,thickness: 1,color: Colorr.Black,),
                        CustomWidgets.height(Height/80),
                        Row(mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomWidgets.width(Width/8),
                            Text("Total Earnings",style: TextStyle(color: Colorr.Black54),),
                            Spacer(),
                            Text("₹ 30000",style: TextStyle(color: Colorr.Black54),),
                            CustomWidgets.width(Width/8),
                          ],),
                      ]),),
                  CustomWidgets.height(Height/40),
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Text("Net Pay : ₹ 1,20,000 (One Hundred and Twenty Thousand)",style: TextStyle(fontSize: 12),)
                  ],),
                  CustomWidgets.height(Height/20),
                  Row(mainAxisAlignment: MainAxisAlignment.end,children: [
                    Container(
                      width: Width/3,
                      decoration: BoxDecoration(
                        border: Border(top: BorderSide(color: Colorr.Black))
                      ),
                    ),
                    CustomWidgets.width(Width/50),
                  ],),
                  CustomWidgets.height(Height/100),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: Width/3,
                        child: Center(child: Text("Employee Signature",style: TextStyle(fontSize: 12),)) ,
                      ),
                      CustomWidgets.width(Height/80),
                    ],),
            ]),
          ),
        ),
      ),
    ));
  }
  Future<void> savePdfAndShow(pw.Document pdf) async {
    final dir = await getExternalStorageDirectory();
    final path = '${dir!.path}/EmployeeSalary_${DateTime.now()}.pdf';
    final file = File(path);
    await file.writeAsBytes(await pdf.save());

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    setState(() {

    });
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }
  _generatePdf()
  {
    pdf.addPage(
      pw.Page(
        build: (context) {
           return pw.Container(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  padding: pw.EdgeInsets.all(10),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Image(
                        image,
                        height: 40,
                        width: 40,
                      ),
                      pw.Text(
                        'Payslip For The Month Of April ${DateTime.now().year}',
                        style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text(
                            '3864 Quiet Valley Lane,',
                            style: pw.TextStyle(fontSize: 10),
                          ),
                          pw.Text(
                            'Sherman Oaks, CA, 91403',
                            style: pw.TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 30),
                pw.Container(height: 80,width: double.infinity,decoration:  pw.BoxDecoration(border:  pw.Border.all(width: 1)),child:  pw.Column(
                    crossAxisAlignment:  pw.CrossAxisAlignment.start,
                    children: [
                      pw.SizedBox(height: 5),
                    pw.Row(
                      children: [
                        pw.SizedBox(width: 5),
                        pw.Text("  Employee Name : John Joe"),
                        pw.Spacer(),
                        pw.Text("  Employee ID : rgb-714"),
                        pw.SizedBox(width: 5),
                      ]
                    ),
                      pw.SizedBox(height: 5),
                      pw.Row(
                          children: [
                            pw.SizedBox(width: 5),
                            pw.Text("  Department : Android Developer"),
                            pw.Spacer(),
                            pw.Text("  Bank Name : Sbi Bank"),
                            pw.SizedBox(width: 5),
                          ]
                      ),
                      pw.SizedBox(height: 5),
                      pw.Row(
                          children: [
                            pw.SizedBox(width: 5),
                            pw.Text("  Designation : Application Devlopement",),
                            pw.Spacer(),
                            pw.Text("  Bank Account Number : 714714714714"),
                            pw.SizedBox(width: 5),
                          ]
                      ),
                      pw.SizedBox(height: 5),
                      pw.Row(
                          children: [
                            pw.SizedBox(width: 5),
                            pw.Text("  Joining Date : 1 January 2023"),
                            pw.Spacer(),
                            pw.Text("  Pan Number : HDIFH249K"),
                            pw.SizedBox(width: 5),
                          ]
                      ),
                    ]),),
                pw.SizedBox(height: 30),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                  children: [
                    pw.Text(
                      'Earnings',
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      'Deductions',
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                  children: [
                pw.Container(
                    width: 220,
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(width: 1),
                    ),
                    padding: pw.EdgeInsets.only(top: 2,bottom: 2),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                          children: [
                            pw.Text('Basic Salary'),
                            pw.Text(':'),
                            pw.Text('Rs 30,000'),
                          ],
                        ),
                        pw.Divider(height: 1,thickness: 1),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                          children: [
                            pw.Text('Special Allowances'),
                            pw.Text(':'),
                            pw.Text('Rs 9,000'),
                          ],
                        ),
                        pw.Divider(height: 1,thickness: 1),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                          children: [
                            pw.Text('Gross Salary'),
                            pw.Text(':'),
                            pw.Text('Rs 16,000'),
                          ],
                        ),
                        pw.Divider(height: 1,thickness: 1),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                          children: [
                            pw.Text('Medical Allowances'),
                            pw.Text(':'),
                            pw.Text('Rs 5,000'),
                          ],
                        ),
                        pw.Divider(height: 1,thickness: 1),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                          children: [
                            pw.Text('Total Earnings'),
                            pw.Text(':'),
                            pw.Text('Rs 60,000'),
                          ],
                        ),
                      ],
                    )
                ),
                    pw.SizedBox(width: 20),
                    pw.Container(
                        width: 220,
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(width: 1),
                        ),
                        padding: pw.EdgeInsets.only(top: 2,bottom: 2),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                              children: [
                                pw.Text('Provident Fund'),
                                pw.Text(':'),
                                pw.Text('Rs 30,000'),
                              ],
                            ),
                            pw.Divider(height: 1,thickness: 1),
                            pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                              children: [
                                pw.Text('ESI'),
                                pw.Text(':'),
                                pw.Text('Rs 9,000'),
                              ],
                            ),
                            pw.Divider(height: 1,thickness: 1),
                            pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                              children: [
                                pw.Text('Income Tax'),
                                pw.Text(':'),
                                pw.Text('Rs 16,000'),
                              ],
                            ),
                            pw.Divider(height: 1,thickness: 1),
                            pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                              children: [
                                pw.Text('Professional Tax'),
                                pw.Text(':'),
                                pw.Text('Rs 5,000'),
                              ],
                            ),
                            pw.Divider(height: 1,thickness: 1),
                            pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                              children: [
                                pw.Text('Total Deductions'),
                                pw.Text(':'),
                                pw.Text('Rs 60,000'),
                              ],
                            ),
                          ],
                        )
                    ),
                  ],
                ),
                pw.SizedBox(height: 30),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Net Pay : Rs 1,20,000 (One Hundred and Twenty Thousand)',
                      style: pw.TextStyle(
                        fontSize: 10,
                      ),
                    ),
                    pw.Column(
                      children: [
                        pw.Container(
                          width: 200,
                          height: 1,
                          color: PdfColors.black,
                        ),
                        pw.Text(
                          'Employee Signature',
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
    savePdfAndShow(pdf);
  }
}
