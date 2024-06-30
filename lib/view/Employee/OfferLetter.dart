import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:intl/intl.dart';
import '../../A_SQL_Trigger/Deparment_api_page.dart';
import '../../Modal/All_import.dart';
import '../../utils/DroupDown/custom_dropdown.dart';
import '../Dashboard/Dashboard.dart';

class Offerletter extends StatefulWidget {
  const Offerletter({super.key});

  @override
  State<Offerletter> createState() => _OfferletterState();
}

class _OfferletterState extends State<Offerletter> {
  QuillController _controller = QuillController.basic();
  TextEditingController EmployeeName = TextEditingController();
  TextEditingController Designation = TextEditingController();
  TextEditingController Department = TextEditingController();
  TextEditingController Proposedate = TextEditingController();
  TextEditingController Branch = TextEditingController();
  TextEditingController Dayofweek = TextEditingController();
  TextEditingController Salary = TextEditingController();
  TextEditingController Salarytype = TextEditingController();
  TextEditingController ExpiryDate = TextEditingController();
  List<String> Emp = [];
  DateTime? fromDate;
  DateTime? toDate;
  List<String> DeparmentSelected = [];
  List<String> DesigFilter = [];

  void initState() {
    // TODO: implement initState
    super.initState();
    GetData();
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
        title: "Offer Letter",
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
        CustomDropdown.search(
          listItemStyle: CustomWidgets.style(),
          hintText: 'Designation',
          controller: Designation,
          items: DesigFilter,
        ),
        CustomDropdown.search(
          listItemStyle: CustomWidgets.style(),
          hintText: 'Department',
          controller: Department,
          items: DeparmentSelected,
        ),
        CustomWidgets.textField(
            hintText: "To Date",
            readOnly: true,
            controller: Proposedate,
            suffixIcon: InkWell(
                onTap: () => _selectDate1(context, "ToDate"),
                child: CustomWidgets.DateIcon())),
        CustomDropdown.search(
          listItemStyle: CustomWidgets.style(),
          hintText: 'Branch',
          controller: Branch,
          items: Emp,
        ),
        CustomWidgets.textField(
          controller: Branch,
          hintText: "Days Of Week",
        ),
        CustomWidgets.textField(
          controller: Dayofweek,
          hintText: "Salary",
        ),
        CustomDropdown.search(
          listItemStyle: CustomWidgets.style(),
          hintText: 'Salary Type',
          controller: Salarytype,
          items: Emp,
        ),
        CustomWidgets.textField(
            hintText: "From Date",
            readOnly: true,
            controller: ExpiryDate,
            suffixIcon: InkWell(
                onTap: () => _selectDate(context, "FromDate"),
                child: CustomWidgets.DateIcon())),
        ElevatedButton(onPressed: () {
          print(_controller.document.toPlainText().replaceFirst("@age", EmployeeName.text));
          final delta = Delta()..insert(_controller.document.toPlainText().replaceFirst("@age", EmployeeName.text)..replaceFirst("@Salary", Salary.text))..insert("\n");


          _controller =QuillController(document: Document.fromDelta(delta), selection: TextSelection.collapsed(offset: delta.length),);
          setState(() {});
        }, child: Icon(Icons.abc)),
            ElevatedButton(
                onPressed: () {
                  print(_controller.document.toPlainText().replaceFirst("@Name", EmployeeName.text));
                  final delta = Delta()
                    ..insert(_controller.document.toPlainText()
                      .replaceFirst("@Name", EmployeeName.text)
                      .replaceFirst("@Designation", Designation.text)
                      .replaceFirst("@Department", Department.text)
                      .replaceFirst("@Proposedate", Proposedate.text)
                      .replaceFirst("@Branch", Branch.text)
                      .replaceFirst("@Dayofweek", Dayofweek.text)
                      .replaceFirst("@Salary", Salary.text)
                      .replaceFirst("@Salarytype", Salarytype.text)
                      .replaceFirst("@ExpiryDate", ExpiryDate.text))
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

  Future<void> _selectDate(BuildContext context, String date) async {
    DateTime selectedDate = DateTime.now();
    DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    DateTime dateTime = DateTime.now();
    if (ExpiryDate.text.isNotEmpty) {
      dateTime = dateFormat.parse(ExpiryDate.text);
    }
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: ExpiryDate.text.isNotEmpty ? dateTime : selectedDate,
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
          ExpiryDate.text = DateFormat('dd-MM-yyyy').format(picked);
        }
      });
    }
  }

  Future<void> _selectDate1(BuildContext context, String date) async {
    DateTime selectedDate = DateTime.now();
    DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    DateTime dateTime = DateTime.now();
    if (Proposedate.text.isNotEmpty) {
      dateTime = dateFormat.parse(Proposedate.text);
    }
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: Proposedate.text.isNotEmpty ? dateTime : selectedDate,
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
        Proposedate.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }
}
