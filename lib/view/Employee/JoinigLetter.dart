import 'package:attendy/view/Employee/Department.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:intl/intl.dart';
import '../../A_SQL_Trigger/Deparment_api_page.dart';
import '../../Modal/All_import.dart';
import '../../utils/DroupDown/custom_dropdown.dart';
import '../Dashboard/Dashboard.dart';

class Joiningletter extends StatefulWidget {
  const Joiningletter({super.key});

  @override
  State<Joiningletter> createState() => _JoiningletterState();
}

class _JoiningletterState extends State<Joiningletter> {
  QuillController _controller = QuillController.basic();
  TextEditingController EmployeeName = TextEditingController();
  TextEditingController comapnyname = TextEditingController();
  TextEditingController Designation = TextEditingController();
  TextEditingController Address = TextEditingController();
  TextEditingController StartDate = TextEditingController();
  TextEditingController Branch = TextEditingController();
  TextEditingController StartTime = TextEditingController();
  TextEditingController EndTime = TextEditingController();
  TextEditingController Numberofhour = TextEditingController();
  List<String> Emp = [];
  DateTime? fromDate;
  DateTime? toDate;
  List<String> DeparmentSelected = [];
  List<String> DesigFilter = [];

  void initState() {
    // TODO: implement initState
    super.initState();
   // GetData();
    setState(() {});
  }

  GetData() async {
    Con_List.DeparmenntSelect = await Deparmentapi.DeparmentSelect();
    DeparmentSelected = [];
    Con_List.DeparmenntSelect.forEach((element) {
      if (element['isActive'] == true) {
        DeparmentSelected.add(element['name']);
        print(DeparmentSelected);
      }
    });
    Con_List.AllDesignation = await Designations_api.DesignationsSelect("All");
    print(Con_List.AllDesignation);
    DesigFilter =
        Con_List.AllDesignation.map((e) => e['name'].toString()).toList();
    Con_List.BranchSelect = await Branch_api.BranchSelect();
    Emp = Con_List.BranchSelect.map((e) => e['name'].toString()).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomWidgets.appbar(
        title: "Joining Letter",
        action: [],
        context: context,
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return const Dashboard();
            },
          ));
        },
      ),
      body: SingleChildScrollView(
          child: Column(children: [
            CustomWidgets.textField(
              controller: EmployeeName,
              hintText: "Employee Name",
            ),
            CustomWidgets.textField(
              controller: comapnyname,
              hintText: "Company Name",
            ),
            CustomWidgets.textField(
              controller: Address,
              hintText: "Address",
            ),
            CustomDropdown.search(
              listItemStyle: CustomWidgets.style(),
              hintText: 'Designation',
              controller: Designation,
              items: DesigFilter,
            ),
            CustomWidgets.textField(
                hintText: "To Date",
                readOnly: true,
                controller: StartDate,
                suffixIcon: InkWell(
                    onTap: () => _selectDate1(context, "ToDate"),
                    child: CustomWidgets.DateIcon())),
            CustomDropdown.search(
              listItemStyle: CustomWidgets.style(),
              hintText: 'Designation',
              controller: Branch,
              items: Emp,
            ),
            CustomWidgets.textField(
              controller: StartTime,
              hintText: "Start Time",
            ),
            CustomWidgets.textField(
              controller: EndTime,
              hintText: "End Time",
            ),
            CustomWidgets.textField(
              controller: Numberofhour,
              hintText: "Number of Hours",
            ),





            ElevatedButton(
                onPressed: () {
                  print(_controller.document.toPlainText().replaceFirst("@age", EmployeeName.text));
                  print( _controller.document.toPlainText()
                    .replaceFirst("@EmployeeName",  EmployeeName.text)                 .replaceFirst("@comapnyname", comapnyname.text)
                  .replaceFirst("@Designation", Designation.text)
                  .replaceFirst("@Address",  Address.text)
                  .replaceFirst("@StartDate",  StartDate.text)
                  .replaceFirst("@Branch",  Branch.text)
                  .replaceFirst("@StartTime",  StartTime.text)
                  .replaceFirst("@EndTime",  EndTime.text)
                  .replaceFirst("@Numberofhour",  Numberofhour.text)
                  );
                  final delta = Delta()

                    ..insert(_controller.document.toPlainText()
                      .replaceFirst("@EmployeeName",  EmployeeName.text)
                       .replaceFirst("@comapnyname", comapnyname.text)
                       .replaceFirst("@Designation", Designation.text)
                       .replaceFirst("@Address",  Address.text)
                       .replaceFirst("@StartDate",  StartDate.text)
                       .replaceFirst("@Branch",  Branch.text)
                       .replaceFirst("@StartTime",  StartTime.text)
                       .replaceFirst("@EndTime",  EndTime.text)
                       .replaceFirst("@Numberofhour",  Numberofhour.text)
                    )
                    ..insert("\n");

                  _controller = QuillController(
                    document: Document.fromDelta(delta),
                    selection: TextSelection.collapsed(offset: delta.length),
                  );
                  setState(() {});
                },
                child: Icon(Icons.abc)),
            Container(
              height: 40,
            ),
            QuillToolbar.basic(
                controller: _controller,
                showBoldButton: true,
                showAlignmentButtons: true,
                showFontSize: true,
                iconTheme: QuillIconTheme(
                    disabledIconFillColor: Colorr.themcolor,
                    iconSelectedFillColor: Colorr.themcolor)),
            Container(
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1.5, color: Colorr.themcolor)),
                height: 600,
                width: double.infinity,
                child: QuillEditor.basic(controller: _controller, readOnly: false))
          ])),
    );
  }

  // Future<void> _selectDate(BuildContext context, String date) async {
  //   DateTime selectedDate = DateTime.now();
  //   DateFormat dateFormat = DateFormat('dd-MM-yyyy');
  //   DateTime dateTime = DateTime.now();
  //   if (ExpiryDate.text.isNotEmpty) {
  //     dateTime = dateFormat.parse(ExpiryDate.text);
  //   }
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: ExpiryDate.text.isNotEmpty ? dateTime : selectedDate,
  //     firstDate: DateTime(2015),
  //     lastDate: DateTime(2101),
  //     builder: (context, child) {
  //       return Theme(
  //         data: Theme.of(context).copyWith(
  //           colorScheme: ColorScheme.light(
  //             primary: Colorr.themcolor, // <-- SEE HERE
  //             onPrimary: Colorr.White, // <-- SEE HERE
  //             onSurface: Colorr.themcolor, // <-- SEE HERE
  //           ),
  //           textButtonTheme: TextButtonThemeData(
  //             style: TextButton.styleFrom(
  //               primary: Colorr.themcolor, // button text color
  //             ),
  //           ),
  //         ),
  //         child: child!,
  //       );
  //     },
  //   );
  //   if (picked != null && picked != selectedDate) {
  //     setState(() {
  //       selectedDate = picked;
  //       if (date == "FromDate") {
  //         fromDate = picked;
  //         ExpiryDate.text = DateFormat('dd-MM-yyyy').format(picked);
  //       }
  //     });
  //   }
  // }

  Future<void> _selectDate1(BuildContext context, String date) async {
    DateTime selectedDate = DateTime.now();
    DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    DateTime dateTime = DateTime.now();
    if (StartDate.text.isNotEmpty) {
      dateTime = dateFormat.parse(StartDate.text);
    }
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: StartDate.text.isNotEmpty ? dateTime : selectedDate,
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
        toDate = picked;
        StartDate.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }
}
