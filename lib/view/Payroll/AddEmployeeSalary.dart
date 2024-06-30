
import 'package:attendy/A_SQL_Trigger/Con_List.dart';
import 'package:attendy/A_SQL_Trigger/Con_Usermast.dart';
import 'package:attendy/A_SQL_Trigger/Deparment_api_page.dart';
import 'package:attendy/A_SQL_Trigger/Designations_api.dart';
import 'package:attendy/A_SQL_Trigger/Employee_Add_api.dart';
import 'package:attendy/A_SQL_Trigger/Role_api.dart';
import 'package:attendy/utils/Constant/LocalCustomWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../A_SQL_Trigger/EmployeeSalary_api.dart';
import '../../utils/Constant/Colors.dart';
import '../../utils/DroupDown/custom_dropdown.dart';
import 'EmployeeSalary.dart';

class AddEmployeeSalary extends StatefulWidget {
  Map? e;
  AddEmployeeSalary({this.e});
  @override
  State<AddEmployeeSalary> createState() => _AddEmployeeSalaryState();
}

class _AddEmployeeSalaryState extends State<AddEmployeeSalary> {
  List<String> Employee=[];
  bool erore=true;
  List<String> Role=[];
  bool isActive=true;
  TextEditingController employeeName=TextEditingController();
  TextEditingController Date=TextEditingController();
  TextEditingController Salary=TextEditingController();
  TextEditingController Department=TextEditingController();
  TextEditingController Designation=TextEditingController();
  TextEditingController preview=TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
    Updatecheack();
  }
  Updatecheack() {
    if (widget.e != null) {
      employeeName.text=Con_List.AllEmployee.isEmpty ? "" : Con_List.AllEmployee.firstWhere((element) =>
          element['_id'] == widget.e!['employeeId'],
          orElse: () => {'FirstName': ''})['FirstName'].toString();
          Date.text=CustomWidgets.DateFormatchange(widget.e!['fromDate'].toString());
          Salary.text=widget.e!['salary'].toString();
      Department.text  = Con_List.AllEmployee.firstWhere((element) => element['FirstName'] == employeeName.text.toString(), orElse: () => {'departmentId': {'name':""}})['departmentId']['name'].toString();
      Designation.text = Con_List.AllEmployee.firstWhere((element) => element['FirstName']==employeeName.text,orElse: () => {'designationId': {'name':""}})['designationId']['name'];
    }
  }
  getdata()
  async {
    Con_List.EmployeeSalary = await EmployeeSalary_api.EmployeeSalarySelect();
    Con_List.AllEmployee=await AllEmployee_api.EmployeeSelect();
    Con_List.RoleSelect = await Role_api.RoleSelect();
    Con_List.DeparmenntSelect= await Deparmentapi.DeparmentSelect();
    Con_List.DesignationSelect= await Designations_api.DesignationsSelect("All");
    Con_List.RoleSelect.forEach((element) {
      if(element['isActive']==true) {
        Role.add(element['name']);
      }
    });
    Con_List.AllEmployee.forEach((element) {
      if(element['isActive']==true)
      {
        Employee.add(element['FirstName']);
      }
    });
    setState(() {
    });
  }
  Widget build(BuildContext context) {
    double Height = MediaQuery.of(context).size.height-kToolbarHeight;
    double Width = MediaQuery.of(context).size.width;
    Future<bool> onBackPress() {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return EmployeeSalary();
      },));
      return Future.value(false);
    }
    return WillPopScope(
        onWillPop: () => onBackPress(),
    child:  Constants_Usermast.IOS==true? CupertinoPageScaffold(
      navigationBar:CustomWidgets.appbarIOS(title:widget.e ==null ?  "Add Employee Salary" : "Update Employee Salary", action: [], context: context, onTap: () {
        Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) {
          return EmployeeSalary();
        },));
      },),
      child:  Column(children: [
        CustomWidgets.height(10),
        CustomWidgets.textFieldIOS(hintText: "Select Employee",controller: employeeName,readOnly: true,onTap: () {
          CustomWidgets.SelectDroupDown(context: context,items: Employee, onSelectedItemChanged: (int) {
            employeeName.text=Employee[int];
            setState(() {
            });
          });
        },suffix: CustomWidgets.aarowCupertinobutton(),
        ),
        CustomWidgets.textFieldIOS(hintText: "Date ",readOnly: true,controller: Date,suffix: GestureDetector(onTap: () =>
            CustomWidgets.selectDateIOS(context: context, controller: Date),child: CustomWidgets.DateIconIOS())),
        CustomWidgets.textFieldIOS(hintText: "Department ",controller: Department,keyboardType: TextInputType.number),
        CustomWidgets.textFieldIOS(hintText: "Designation ",controller: Designation,keyboardType: TextInputType.number),
        CustomWidgets.textFieldIOS(hintText: "preview Salary ",controller: preview,keyboardType: TextInputType.number),
        CustomWidgets.textFieldIOS(hintText: "Salary ",controller: Salary,keyboardType: TextInputType.number),
        CustomWidgets.height(Height/20),
        widget.e==null ?   Row(
          children: [
            SizedBox(width: 5),
            Expanded(
              flex: 2,
              child: CupertinoButton(
                color: Colorr.Reset,
                padding: EdgeInsets.zero,
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  ResetButton();
                },
                child: Text('Reset'),
              ),
            ),
            SizedBox(width: 5),
            Expanded(
              flex: 2,
              child: CupertinoButton(
                color: Colorr.themcolor,
                padding: EdgeInsets.zero,
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  if(await CustomWidgets.CheakConnectionInternetButton())
                  {
                    savebutton("Save");
                  }else{
                    CustomWidgets.showToast(context, "No Internet Connection", false);
                  }
                },
                child: Text('Save'),
              ),
            ),
            SizedBox(width: 5),
            Expanded(
              flex: 3,
              child: CupertinoButton(
                color: Colorr.themcolor,
                padding: EdgeInsets.zero,
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  if(await CustomWidgets.CheakConnectionInternetButton())
                  {
                    savebutton("Save & Continue");
                  }else{
                    CustomWidgets.showToast(context, "No Internet Connection", false);
                  }
                },
                child: Text('Save & Continue'),
              ),
            ),
            SizedBox(width: 5),
          ],
        ) :Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 5),
            Container(width: Width/3,height: Height/20,child:   CupertinoButton(
              color: Colorr.Reset,
              padding: EdgeInsets.zero,
              onPressed: () {
                FocusScope.of(context).unfocus();
                ResetButton();
                Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) {
                  return EmployeeSalary();
                },));
              },
              child: Text('Cancel'),
            ) ,),
            SizedBox(width: 5),
            Container(width: Width/3,height: Height/20,child:CupertinoButton(
              color: Colorr.themcolor,
              padding: EdgeInsets.zero,
              onPressed: () async {
                FocusScope.of(context).unfocus();
                if(await CustomWidgets.CheakConnectionInternetButton())
                {
                savebutton("Update");
                }else{
                  CustomWidgets.showToast(context, "No Internet Connection", false);
                }
              },
              child: Text('Update'),
            ) ,),
            SizedBox(width: 5),
          ],
        ) ,
      ]
      ),
    ):

    Scaffold(
      appBar: CustomWidgets.appbar(title: "Add Employee Salary",action:  [
      ],context:  context,onTap: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return EmployeeSalary();
        },));
      },),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomWidgets.height(10),
            CustomDropdown.search(listItemStyle: CustomWidgets.style(),
              hintText: 'Select Employee',
              controller: employeeName,
              items: Employee,
              onChanged: (value) {
              Department.text  = Con_List.AllEmployee.firstWhere((element) => element['FirstName'] == employeeName.text.toString(), orElse: () => {'departmentId': {'name':""}})['departmentId']['name'].toString();
              Designation.text = Con_List.AllEmployee.firstWhere((element) => element['FirstName']==employeeName.text,orElse: () => {'designationId': {'name':""}})['designationId']['name'];
             // Department.text = Con_List.DeparmenntSelect.firstWhere((element) => element['_id']==DepartmentaID,orElse: () => {'name': ''})['name'];
             // Designation.text = Con_List.DesignationSelect.firstWhere((element) => element['_id']==DesignationID,orElse: () => {'name': ''})['name'];
             String EmployeeId = Con_List.AllEmployee.firstWhere((element) => element['FirstName'] == employeeName.text.toString(), orElse: () => {'_id': ''})['_id'].toString();
             List employee=Con_List.EmployeeSalary.where((element) => element['employeeId']==EmployeeId).toList();
             DateTime? latestJoiningDate;
             int latestSalary = 0;

             for (var employee in employee) {
               String joiningDateStr = employee['fromDate'];
               DateTime joiningDate = DateTime.parse(joiningDateStr);
               int salary = employee['salary'];
               if (joiningDate.isAfter(latestJoiningDate ?? DateTime(1900)) && salary > latestSalary) {
                 latestJoiningDate = joiningDate;
                 latestSalary = salary;
               }
             }

             if (latestJoiningDate != null) {
               String formattedJoiningDate = latestJoiningDate.toString().split(' ')[0];
               String result = 'Latest Joining Date: $formattedJoiningDate, Salary: $latestSalary';
               preview.text = "${latestSalary}";
             } else {
               preview.text = "";
             }
           setState(() {
           });
              },
            ),
             CustomWidgets.textField(hintText: "Date ",readOnly: true,controller: Date,suffixIcon: InkWell(onTap: () =>
                 CustomWidgets.selectDate(context: context, controller: Date,Future: true),child: CustomWidgets.DateIcon())),
            CustomWidgets.textField(hintText: "Department",readOnly: true,controller: Department),
            CustomWidgets.textField(hintText: "Designation",readOnly: true,controller: Designation),
            CustomWidgets.textField(hintText: "preview Salary",readOnly: true,controller: preview),
            CustomWidgets.textField(hintText: "New Salary ",controller: Salary,keyboardType: TextInputType.number),
            CustomWidgets.height(Height/20),
           widget.e==null ? Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              CustomWidgets.confirmButton(onTap: () {
                ResetButton();
              }, height: Height/20, width: Width/3.3, text: "Reset",Clr: Colorr.Reset),
              CustomWidgets.confirmButton(onTap: () async {
                if(await CustomWidgets.CheakConnectionInternetButton())
                {
                savebutton("Save");
                }else{
                CustomWidgets.showToast(context, "No Internet Connection", false);
                }
              }, height: Height/20, width: Width/3.3, text: "Save"),
              CustomWidgets.confirmButton(onTap: () async {
                if(await CustomWidgets.CheakConnectionInternetButton())
                {
                savebutton("Save & Continue");
                }else{
                CustomWidgets.showToast(context, "No Internet Connection", false);
                }

              }, height: Height/20, width: Width/2.7, text: "Save & Continue")
            ],) : Row(mainAxisAlignment: MainAxisAlignment.center,
               children: [
             CustomWidgets.confirmButton(onTap: () {
               ResetButton();
               Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) {
                 return EmployeeSalary();
               },));
             }, height: Height/20, width: Width/3.3, text: "Cancel",Clr: Colorr.Reset),
             CustomWidgets.confirmButton(onTap: () async {
               if(await CustomWidgets.CheakConnectionInternetButton())
               {
                 savebutton("Update");
               }else{
                 CustomWidgets.showToast(context, "No Internet Connection", false);
               }
             }, height: Height/20, width: Width/3.3, text: "Update"),
           ]),
          ],
        ),
      ),
    ));
  }
  savebutton(String Save)
  async {
    if(employeeName.text.trim().isEmpty){
      CustomWidgets.showToast(context, "Employee Name is required",false);
    }else if(Con_List.AllEmployee.where((element) => element['FirstName']==employeeName.text).isEmpty){
      CustomWidgets.showToast(context, "Enter Valid Employee Name",false);
    }else if(Date.text.trim().isEmpty){
        CustomWidgets.showToast(context, "Select Date",false);
      }else if(Salary.text.trim().isEmpty){
        CustomWidgets.showToast(context, "Salary is required",false);
      }else{
        Map data={
          if (widget.e != null)
            "id": widget.e!['_id'].toString()
          else
            "companyId": Constants_Usermast.companyId,
          "employeeId" : Con_List.AllEmployee.firstWhere((element) => element['FirstName']==employeeName.text)['_id'].toString(),
          "fromDate" : CustomWidgets.DateFormatchangeapi(Date.text),
          "toDate" : CustomWidgets.DateFormatchangeapi(Date.text),
          "salary" : Salary.text,
          "isActive" : isActive.toString()
        };
        if(widget.e==null){
          if(await EmployeeSalary_api.EmployeeSalaryadd(data))
          {
            if(Save=="Save")
            {
              CustomWidgets.showToast(context, "Employee Salary Add Successfully",true);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return EmployeeSalary();
              },));
            }else{
              CustomWidgets.showToast(context, "Employee Salary Add Successfully",true);
              ResetButton();
            }
          }
        }else{
          if(await EmployeeSalary_api.EmployeeSalaryUpdate(data))
          {
              CustomWidgets.showToast(context, "Employee Salary Update Successfully",true);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return EmployeeSalary();
              },));
          }
        }
    }
  }
  ResetButton()
  {
    employeeName.text="";
    Date.text="";
    Salary.text="";
    Department.text="";
    Designation.text="";
    preview.text="";
    setState(() {
    });
  }
}
