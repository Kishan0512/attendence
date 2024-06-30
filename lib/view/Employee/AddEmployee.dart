// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, unrelated_type_equality_checks, must_be_immutable

import '../../Modal/All_import.dart';
import 'package:attendy/A_SQL_Trigger/Deparment_api_page.dart';
import 'package:attendy/view/Employee/AllEmployees.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../utils/Constant/FontWeight.dart';
import '../../utils/DroupDown/custom_dropdown.dart';
import '../Profile/EmployeeProfileScreen.dart';

class AddEmployee extends StatefulWidget {
 Map? e;
 String? name;
 int? count;
 AddEmployee({super.key, this.e,this.name,this.count});

  @override
  State<AddEmployee> createState() => _AddEmployeeState();
}
class _AddEmployeeState extends State<AddEmployee> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool addAll=true;
  int _currentIndex=0;
  bool isActive=false;
  List<String> DesignationNameList=[];
  String selectedGender="";
  TextEditingController FristName = TextEditingController();
  TextEditingController MiddleName = TextEditingController();
  TextEditingController LastName = TextEditingController();
  TextEditingController BranchName = TextEditingController();
  TextEditingController DeparmentName = TextEditingController();
  TextEditingController DesignationName = TextEditingController();
  TextEditingController RoleName = TextEditingController();
  TextEditingController ShiftName = TextEditingController();
  TextEditingController GenderName = TextEditingController();
  TextEditingController PhoneNo = TextEditingController();
  TextEditingController PhoneNoFamily = TextEditingController();
  TextEditingController EmailName = TextEditingController();
  TextEditingController JoiningDate = TextEditingController();
  TextEditingController DateofBirth = TextEditingController();
  TextEditingController AnniversaryDate = TextEditingController();
  TextEditingController ClosedDate = TextEditingController();
  TextEditingController BankName = TextEditingController();
  TextEditingController BankBranch = TextEditingController();
  TextEditingController BankAccountNo = TextEditingController();
  TextEditingController IfSCCode = TextEditingController();
  TextEditingController PanNo = TextEditingController();
  TextEditingController State = TextEditingController();
  TextEditingController District = TextEditingController();
  TextEditingController Name = TextEditingController();
  TextEditingController ReletionWithEmployee = TextEditingController();
  TextEditingController Address = TextEditingController();
  TextEditingController AddressFamily = TextEditingController();
  TextEditingController PfNo = TextEditingController();
  TextEditingController EsisNo = TextEditingController();
  TextEditingController UnNo = TextEditingController();
  TextEditingController EMPCode = TextEditingController();
  List<String> Branchadd=[];
  DateTime? joinDate;
  DateTime? CloseDate;
  bool erore=true;
  bool perphone=true;
  bool Familyphone=true;
  List<String> DeparmentAdd=[];
  List<String> RoleSelect=[];
  List<String> AllShift=[];
  List<dynamic> ALLBank=[];
  List<dynamic> StatebyBank=[];
  List<dynamic> DistbyBank=[];
  List<dynamic> BranchBank=[];
  List<dynamic> BankIFSC=[];
  Map Company ={};
  double height=0;
  double width=0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    getdata();


    UpdateData();
  }
  getdata()
  async {
    Con_List.CompanySelect = await api_page.CompanySelect();
    Company=Con_List.CompanySelect.firstWhere((element) => element['_id'].toString()==Constants_Usermast.companyId.toString());
    EMPCode.text = Company.containsKey('Prefix')?Company['Prefix'].toString()+(widget.count!+1).toString().padLeft(3,"0"):"${(widget.count!+1).toString().padLeft(3,"0")}";
    Con_List.BranchSelect = await Branch_api.BranchSelect();
    Con_List.DeparmenntSelect=await Deparmentapi.DeparmentSelect();
    Con_List.RoleSelect = await Role_api.RoleSelect();
    Con_List.Allshift_Select =await Shift_Add_api.shift_Select();
    ALLBank= await Shift_Add_api.Get_bank();
    Con_List.DesignationSelect = await Designations_api.DesignationsSelect("");
    for (var element in Con_List.DesignationSelect) {
      if(element['isActive']==true) {
        DesignationNameList.add(element['name']);
      }
    }
    for (var element in Con_List.BranchSelect) {
      if(element['isActive']==true) {
        Branchadd.add(element['name']);
      }
    }
    for (var element in Con_List.Allshift_Select) {
      if(element['isActive']==true) {
        AllShift.add(element['name']);
      }
    }
    for (var element in Con_List.DeparmenntSelect) {
      if(element['isActive']==true) {
        DeparmentAdd.add(element['name']);
      }
    }
    for (var element in Con_List.RoleSelect) {
      if(element['isActive']==true) {
        RoleSelect.add(element['name']);
      }
    }
    setState(() {
    });
  }
  UpdateData(){
    if(widget.e!=null)
      {

        FristName.text = widget.e!['FirstName'].toString();
        MiddleName.text = widget.e!['MiddelName'].toString();
        LastName.text = widget.e!['LastName'].toString();
        PhoneNoFamily.text = widget.e!['FamilyPhone'].toString();
        EmailName.text = widget.e!['Email'].toString();
        JoiningDate.text = widget.e!['JoiningDate'].toString().substring(0,10);
        DateofBirth.text = widget.e!['Dob'].toString().substring(0,10);
        ClosedDate.text = widget.e!['ClosedDate'].toString()=="null"?"":widget.e!['ClosedDate'].toString();
        BankName.text = widget.e!['BankName'].toString();
        BankBranch.text = widget.e!['BankBranch'].toString();
        BankAccountNo.text = widget.e!['BankAccountNo'].toString()=="null"?"":widget.e!['BankAccountNo'].toString();
        IfSCCode.text = widget.e!['IFSCcode'].toString();
        PanNo.text = widget.e!['PANno'].toString();
        State.text=widget.e!['StateName'].toString();
        District.text=widget.e!['DistrictName'].toString();
        Name.text = widget.e!['FamilyName'].toString();
        ReletionWithEmployee.text = widget.e!['Relationship'].toString();
        PhoneNo.text = widget.e!['Number'].toString();
        EMPCode.text = widget.e!['EmpCode'].toString();
        Address.text = widget.e!['Address'].toString();
        AddressFamily.text = widget.e!['Address'].toString();
        isActive=widget.e!['isActive'];
        selectedGender=widget.e!['Gender'].toString().toLowerCase();
        BranchName.text = widget.e!['branchId']['name'].toString();
        DeparmentName.text = widget.e!['departmentId']['name'].toString();
        DesignationName.text = widget.e!['designationId']['name'].toString();
        RoleName.text = widget.e!['roleId']['name'].toString();
        ShiftName.text = widget.e!['ShiftId']['name'].toString();
        setState(() {

        });
      }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
  }
  void goToNextTab() {
    if (_tabController.index < _tabController.length - 1) {
      _tabController.animateTo(_tabController.index + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
     height =MediaQuery.of(context).size.height-kToolbarHeight;
     width =MediaQuery.of(context).size.width;
     Future<bool> onBackPress() {
       if(widget.name==null)
       {
         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
           return const AllEmployees();
         },));
       }else{
         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
           return const EmployeeProfileScreen();
         },));
       }
       return Future.value(false);
     }
     List<Widget> TabView=[
       personalIOS(),
       BankIOS(),
       FamilyIOS()
     ];
    return WillPopScope(
         onWillPop: () => onBackPress(),
    child: Constants_Usermast.IOS==true  ?  CupertinoPageScaffold(
        navigationBar: CustomWidgets.appbarIOS(title: "Add New Employee", action: [], context: context, onTap: () {
          if(widget.name==null)
          {
            Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) {
              return const AllEmployees();
            },));
          }else{
            Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) {
              return const EmployeeProfileScreen();
            },));
          }
        },),
        child: CupertinoTabScaffold(tabBar: CupertinoTabBar(
          activeColor: Colorr.themcolor,
          inactiveColor: Colorr.Grey,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.person_pin),
              label: 'Personal',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.food_bank_outlined),
              label: 'Bank',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.family_restroom),
              label: 'Family',
            ),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ), tabBuilder: (context, index) {
          return TabView[_currentIndex];
        },)): DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar:  AppBar(
          backgroundColor: Colorr.themcolor,
          centerTitle: true,
          leading: IconButton(
            splashRadius: 18,
            onPressed: () {
              if(widget.name==null)
                {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                    return const AllEmployees();
                  },));
                }else{
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                  return const EmployeeProfileScreen();
                },));
              }
            },
            icon:  const Icon(Icons.arrow_back_ios_new_outlined),
          ),
          elevation: 0,
          title: CustomWidgets.poppinsText(widget.e == null ? "Add New Employee" : "Update Employee", Colorr.White, 14.5, FWeight.fW600),
          actions: [
            IconButton(splashRadius: 18,onPressed: () {
              addAll=!addAll;
              setState(() {
              });
            }, icon: const Icon(Icons.add))
          ],
          bottom: addAll ? TabBar(isScrollable: true,
              controller: _tabController,
              indicatorColor: Colorr.themcolor,tabs: const [
            Tab(child: Text("Personal"),),
            Tab(child: Text("Bank"),),
            Tab(child: Text("Family"),),
            Tab(child: Text("Goverment"),),
          ]) : null,
        ),
        body: addAll ? Container(
          height: double.infinity,
          width: double.infinity,
          color: Colorr.White,
          child: TabBarView(
              controller: _tabController,
              children: [
            personal(),
            Bank(),
            Family(), Goverment(),
          ]),
        ) : Container(
          height: double.infinity,
          width: double.infinity,
          color: Colorr.White,
          child: SingleChildScrollView(
            child: Column(children: [
              personal(),
              Bank(),
              Family(),
              Goverment(),
            ]),
          ),
        ),
      ),
    ));
  }

  Widget personal(){
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(left: 5,right: 5),
        decoration: BoxDecoration(color: Colorr.White, boxShadow: [
          BoxShadow(
            color: Colorr.themcolor100,
            blurStyle: BlurStyle.outer,
            blurRadius: 8,
          ),
        ]),
        child: Column(
          children: [
          CustomWidgets.height(10),
            addAll ? Container() : Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Text("   Personal Details :"),
              ],
            ),
            addAll ? Container() : CustomWidgets.height(5),
          CustomWidgets.textField(hintText: "Employee Code",controller: EMPCode,readOnly: true),
          CustomWidgets.textField(hintText: "First Name",controller: FristName),
          CustomWidgets.textField(hintText: "Middle Name",controller: MiddleName),
          CustomWidgets.textField(hintText: "Last Name",controller: LastName),
            CustomDropdown.search(
              listItemStyle: CustomWidgets.style(),
              hintText: 'Select Branch',
              controller: BranchName,
              items: Branchadd,
            ),
            CustomDropdown.search(
              listItemStyle: CustomWidgets.style(),
              hintText: 'Select Department',
              controller: DeparmentName,
              items: DeparmentAdd,
              onChanged: (value) async {
                if (Con_List.DeparmenntSelect.where((element) => DeparmentName.text == element['name']).isNotEmpty) {
                  Con_List.DesignationSelect = await Designations_api.DesignationsSelect(Con_List.DeparmenntSelect.firstWhere((e) => ['name'] == DeparmentName.text)['_id'].toString());
                  FocusScope.of(context).unfocus();
                  DesignationNameList.clear();
                  DesignationName.text="";
                  for (var element in Con_List.DesignationSelect) {
                    if(element['isActive']==true)
                      {
                        DesignationNameList.add(element['name']);
                      }

                  }
                  setState(() {
                  });
                }
              },
            ),
            CustomDropdown.search(listItemStyle: CustomWidgets.style(),
              hintText: 'Select Designation',
              controller: DesignationName,
              items: DesignationNameList,
            ),
            CustomDropdown.search(listItemStyle: CustomWidgets.style(),
              hintText: 'Select Role',
              controller: RoleName,
              items: RoleSelect,
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Radio(
                activeColor: Colorr.themcolor,
                value: 'male',
                groupValue: selectedGender,
                onChanged: (value) {
                  setState(() {
                    selectedGender = value!;
                  });
                },
              ),
              const Text('Male'),
              const SizedBox(width: 20),
              Radio(
                activeColor: Colorr.themcolor,
                value: 'female',
                groupValue: selectedGender,
                onChanged: (value) {
                  setState(() {
                    selectedGender = value!;
                  });
                },
              ),
              const Text('Female'),
            ],
          ),
            CustomDropdown.search(listItemStyle: CustomWidgets.style(),
              hintText: 'Shift',
              controller: ShiftName,
              items: AllShift,
            ),
          CustomWidgets.textField(hintText: "Phone No.",controller: PhoneNo, keyboardType: TextInputType.phone,MaxFont: 13,height:perphone ==false ? 65:65,
            onChanged: (value) {
              if(value.toString().length > 9 ){
                perphone=true;
              }else{
                perphone=false;
              }
              setState(() {});
            },
              erroreText: perphone == false ? "Enter Phone number" : null,
              eorror   :  perphone == false ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.red,)
              ) : null
          ),
          CustomWidgets.textField(hintText: "Email Id",controller: EmailName,keyboardType: TextInputType.emailAddress,height:erore == false ?  65 : null,
              onChanged: (value) {
            if(CustomWidgets.isValidEmail(value)){
              erore=true;
            }else{
              erore=false;
            }
            setState(() {
            });
              },
              erroreText: erore == false ? "Enter Valid Email" : null,
              eorror   :  erore == false ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red,)
          ) : null),
          CustomWidgets.textField(hintText: "Joining Date",readOnly: true,controller: JoiningDate,suffixIcon: InkWell(onTap: () =>
             _selectDate(context, "Joining"),child: CustomWidgets.DateIcon())),
          CustomWidgets.textField(hintText: "Date of Birth",readOnly: true,controller: DateofBirth,suffixIcon: InkWell(onTap: () =>
              CustomWidgets.selectDate(Future: true,context: context, controller: DateofBirth),child: CustomWidgets.DateIcon())),
          CustomWidgets.textField(hintText: "Anniversary Date",readOnly: true,controller: AnniversaryDate,suffixIcon: InkWell(onTap: () => CustomWidgets.selectDate(context: context, controller: AnniversaryDate),child: CustomWidgets.DateIcon())),
          CustomWidgets.textField(hintText: "Closed Date",readOnly: true,controller: ClosedDate,suffixIcon: InkWell(onTap: () =>
              _selectDate(context, "Close"),child: CustomWidgets.DateIcon())),
            CustomWidgets.textField1(hintText: "Address",controller: Address,keyboardType: TextInputType.streetAddress,maxLines: 3,height: height/10,textAlignVertical: TextAlignVertical.top, textAlign: TextAlign.start,),
            Row(children : [
              Checkbox(
                shape: const CircleBorder(),
                value: isActive,
                activeColor: Colorr.themcolor,
                onChanged: (value) {
                  setState(() {
                    isActive = value!;
                  });
                },
              ),
              const Text("Active"),
            ]),
          addAll ?  Row(mainAxisAlignment: MainAxisAlignment.end,children: [
            CustomWidgets.confirmButton(onTap:() {
              FocusScope.of(context).unfocus();
              FunControllerblank();
            }, height:  height/20, width: width/3.5, text: "Reset",Clr: Colorr.Reset),
            CustomWidgets.width(10),
            CustomWidgets.confirmButton(onTap:() {
              FocusScope.of(context).unfocus();
              if (FristName.text.trim().isEmpty) {
                CustomWidgets.showToast(context, "First Name is required",false);
              } else if (EMPCode.text.trim().isEmpty) {
                CustomWidgets.showToast(context, "Employee Code is required",false);
              } else if (MiddleName.text.trim().isEmpty) {
                CustomWidgets.showToast(context, "Middle Name is required",false);
              } else if (LastName.text.trim().isEmpty) {
                CustomWidgets.showToast(context, "Last Name is required",false);
              } else if (BranchName.text.trim().isEmpty) {
                CustomWidgets.showToast(context, "Branch Name is required",false);
              } else if (Con_List.BranchSelect.where((e) => e['name'] == BranchName.text).isEmpty) {
                CustomWidgets.showToast(context, "Enter Valid Branch",false);
              } else if (DeparmentName.text.trim().isEmpty) {
                CustomWidgets.showToast(context, "Deparment Name is required",false);
              } else if (Con_List.DeparmenntSelect.where((e) => e['name'] == DeparmentName.text).isEmpty) {
                CustomWidgets.showToast(context, "Enter Valid Deparment",false);
              } else if (DesignationName.text.trim().isEmpty) {
                CustomWidgets.showToast(context, "Designation Name is required",false);
              } else if (Con_List.DesignationSelect.where((e) => e['name'] == DesignationName.text).isEmpty) {
                CustomWidgets.showToast(context, "Enter Valid Designation Name",false);
              } else if (RoleName.text.trim().isEmpty) {
                CustomWidgets.showToast(context, "Role Name is required",false);
              } else if (Con_List.RoleSelect.where((e) => e['name'] == RoleName.text).isEmpty) {
                CustomWidgets.showToast(context, "Enter Valid Role Name",false);
              } else if (ShiftName.text.trim().isEmpty) {
                CustomWidgets.showToast(context, "Shift Name is required",false);
              } else if (Con_List.Allshift_Select.where((e) => e['name'] == ShiftName.text).isEmpty) {
                CustomWidgets.showToast(context, "Enter Valid Shift Name",false);
              } else if (selectedGender.isEmpty) {
                CustomWidgets.showToast(context, "Select Gender",false);
              } else if (PhoneNo.text.length < 10 ) {
                CustomWidgets.showToast(context, "Enter Valid Contact",false);
              } else if (EmailName.text.trim().isEmpty) {
                CustomWidgets.showToast(context, "Email Id is required",false);
              } else if (CustomWidgets.isValidEmail(EmailName.text)) {
                if (JoiningDate.text.trim().isEmpty) {
                  CustomWidgets.showToast(context, "Joining Name is required",false);
                } else if (DateofBirth.text.trim().isEmpty) {
                  CustomWidgets.showToast(context, "Date of Birth is required",false);
                }else if (Address.text.trim().isEmpty) {
                  CustomWidgets.showToast(context, "Address is required",false);
                }else{
                  goToNextTab();
                }
              }else{
                CustomWidgets.showToast(context, "Enter Valid Email",false);
              }
            }, height: height/20, width: width/3.5, text: "Next"),
            CustomWidgets.width(10)
          ],) : Container(),
            CustomWidgets.height(5),
        ],),
      ),
    );
  }
  Widget personalIOS(){
    return Container(
      height: MediaQuery.of(context).size.height-kToolbarHeight-72,
      padding: const EdgeInsets.only(left: 5,right: 5),
      decoration: BoxDecoration(color: Colorr.White, boxShadow: [
        BoxShadow(
          color: Colorr.themcolor100,
          blurStyle: BlurStyle.outer,
          blurRadius: 8,
        ),
      ]),
      child: SingleChildScrollView(
        child: Column(
          children: [
            CustomWidgets.height(10),
            addAll ? Container() : Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Text("   Personal Details :"),
              ],
            ),
            addAll ? Container() : CustomWidgets.height(5),
            CustomWidgets.textFieldIOS(hintText: "First Name",controller: FristName),
            CustomWidgets.textFieldIOS(hintText: "Middle Name",controller: MiddleName),
            CustomWidgets.textFieldIOS(hintText: "Last Name",controller: LastName),
            CustomWidgets.textFieldIOS(hintText: "Select Branch",controller: BranchName,readOnly: true,onTap: () {
              CustomWidgets.SelectDroupDown(context: context,items: Branchadd, onSelectedItemChanged: (value) {
                BranchName.text=Branchadd[value];
                setState(() {
                });
              });
            },suffix: CustomWidgets.aarowCupertinobutton(),
            ),
            CustomWidgets.textFieldIOS(hintText: "Select Department",controller: DeparmentName,readOnly: true,onTap: () {
              CustomWidgets.SelectDroupDown(context: context,items: DeparmentAdd, onSelectedItemChanged: (value ) async {
                DeparmentName.text=DeparmentAdd[value];
                if (Con_List.DeparmenntSelect.where((element) => DeparmentName.text == element['name']).isNotEmpty) {
                  Con_List.DesignationSelect = await Designations_api.DesignationsSelect(Con_List.DeparmenntSelect.firstWhere((e) => e['name'] == DeparmentName.text)['_id'].toString());
                  FocusScope.of(context).unfocus();
                  DesignationNameList.clear();
                  DesignationName.text="";
                  for (var element in Con_List.DesignationSelect) {
                    if(element['isActive']==true)
                    {
                      DesignationNameList.add(element['name']);
                    }
                  }
                  setState(() {
                  });
                }
                setState(() {
                });
              });
            },suffix: CustomWidgets.aarowCupertinobutton(),
            ),
            CustomWidgets.textFieldIOS(hintText: "Select Designation",controller: DesignationName,readOnly: true,onTap: () {
              CustomWidgets.SelectDroupDown(context: context,items: DesignationNameList, onSelectedItemChanged: (value) {
                DesignationName.text=DesignationNameList[value];
                setState(() {
                });
              });
            },suffix: CustomWidgets.aarowCupertinobutton()),
            CustomWidgets.textFieldIOS(hintText: "Select Role",controller: RoleName,readOnly: true,onTap: () {
              CustomWidgets.SelectDroupDown(context: context,items: RoleSelect, onSelectedItemChanged: (value) {
                RoleName.text=RoleSelect[value];
                setState(() {
                });
              });
            },suffix: CustomWidgets.aarowCupertinobutton(),),
            CustomWidgets.textFieldIOS(hintText: "Select Shift",controller: ShiftName,readOnly: true,onTap: () {
              CustomWidgets.SelectDroupDown(context: context,items: AllShift, onSelectedItemChanged: (value) {
                ShiftName.text=AllShift[value];
                setState(() {
                });
              });
            },suffix: CustomWidgets.aarowCupertinobutton(),),
          Row(children: [
            CupertinoButton(child: selectedGender!="Male" ? const Icon(CupertinoIcons.circle,color: Colors.black) :  Icon(CupertinoIcons.circle_filled,color: Colorr.themcolor), onPressed: () {
              selectedGender="Male";
              setState(() {
              });
            },),
            const Text("Male") ,
            CupertinoButton(child: selectedGender!="female" ? const Icon(CupertinoIcons.circle,color: Colors.black) :  Icon(CupertinoIcons.circle_filled,color: Colorr.themcolor), onPressed: () {
              selectedGender="female";
              setState(() {
              });
            },),
            const Text("female")
          ],),
            CustomWidgets.textFieldIOS(hintText: "Phone No.",controller: PhoneNo, keyboardType: TextInputType.phone),
            CustomWidgets.textFieldIOS(hintText: "Email Id",controller: EmailName,keyboardType: TextInputType.emailAddress),
            CustomWidgets.textFieldIOS(hintText: "Joining Date",readOnly: true,controller: JoiningDate,suffix: GestureDetector(onTap: () => CustomWidgets.selectDateIOS(context: context,controller: JoiningDate),child: CustomWidgets.DateIcon())),
            CustomWidgets.textFieldIOS(hintText: "Date of Birth",readOnly: true,controller: DateofBirth,suffix: GestureDetector(onTap: () => CustomWidgets.selectDateIOS(Future: true,context: context,controller: DateofBirth),child: CustomWidgets.DateIcon())),
            CustomWidgets.textFieldIOS(hintText: "Anniversary Date",readOnly: true,controller: AnniversaryDate,suffix: GestureDetector(onTap: () => CustomWidgets.selectDateIOS(context: context,controller: AnniversaryDate),child: CustomWidgets.DateIcon())),
            CustomWidgets.textFieldIOS(hintText: "Closed Date",readOnly: true,controller: ClosedDate,suffix: GestureDetector(onTap: () => CustomWidgets.selectDateIOS(context: context,controller: ClosedDate),child: CustomWidgets.DateIcon())),
            CustomWidgets.textFieldIOS(hintText: "Address",controller: Address,keyboardType: TextInputType.streetAddress,maxLines: 3,height: height/10,textAlignVertical: TextAlignVertical.top, textAlign: TextAlign.start,),
            CupertinoFormRow(
              child: Row(
                children: [
                  CupertinoSwitch(
                    value: isActive,
                    onChanged: (value) {
                      setState(() {
                        isActive = value;
                      });
                    },
                  ),
                  const Text("Active"),
                ],
              ),
            ),
            addAll ?  Row(mainAxisAlignment: MainAxisAlignment.end,children: [
              SizedBox( height:  height/20, width: width/3.5,
              child:  CupertinoButton(padding: EdgeInsets.zero,color: Colorr.Reset,child: const Text("Reset"), onPressed: () {
                FocusScope.of(context).unfocus();
                FunControllerblank();
              },),
              ),
              CustomWidgets.width(10),
              SizedBox( height:  height/20, width: width/3.5,
              child:  CupertinoButton(padding: EdgeInsets.zero,color: Colorr.themcolor,child: const Text("Next"), onPressed: () {
                FocusScope.of(context).unfocus();
                if (FristName.text.trim().isEmpty) {
                  CustomWidgets.showToast(context, "First Name is required",false);
                } else if (MiddleName.text.trim().isEmpty) {
                  CustomWidgets.showToast(context, "Middle Name is required",false);
                }else if (EMPCode.text.trim().isEmpty) {
                  CustomWidgets.showToast(context, "Employee Code is required",false);
                } else if (LastName.text.trim().isEmpty) {
                  CustomWidgets.showToast(context, "Last Name is required",false);
                } else if (BranchName.text.trim().isEmpty) {
                  CustomWidgets.showToast(context, "Branch Name is required",false);
                } else if (Con_List.BranchSelect.where((e) => e['name'] == BranchName.text).isEmpty) {
                  CustomWidgets.showToast(context, "Enter Valid Branch",false);
                } else if (DeparmentName.text.trim().isEmpty) {
                  CustomWidgets.showToast(context, "Deparment Name is required",false);
                } else if (Con_List.DeparmenntSelect.where((e) => e['name'] == DeparmentName.text).isEmpty) {
                  CustomWidgets.showToast(context, "Enter Valid Deparment",false);
                } else if (DesignationName.text.trim().isEmpty) {
                  CustomWidgets.showToast(context, "Designation Name is required",false);
                } else if (Con_List.DesignationSelect.where((e) => e['name'] == DesignationName.text).isEmpty) {
                  CustomWidgets.showToast(context, "Enter Valid Designation Name",false);
                } else if (RoleName.text.trim().isEmpty) {
                  CustomWidgets.showToast(context, "Role Name is required",false);
                } else if (Con_List.RoleSelect.where((e) => e['name'] == RoleName.text).isEmpty) {
                  CustomWidgets.showToast(context, "Enter Valid Role Name",false);
                } else if (ShiftName.text.trim().isEmpty) {
                  CustomWidgets.showToast(context, "Shift Name is required",false);
                } else if (Con_List.Allshift_Select.where((e) => e['name'] == ShiftName.text).isEmpty) {
                  CustomWidgets.showToast(context, "Enter Valid Shift Name",false);
                } else if (selectedGender.isEmpty) {
                  CustomWidgets.showToast(context, "Select Gender",false);
                } else if (PhoneNo.text.length < 10 ) {
                  CustomWidgets.showToast(context, "Enter Valid Contact",false);
                } else if (EmailName.text.trim().isEmpty) {
                  CustomWidgets.showToast(context, "Email Id is required",false);
                } else if (CustomWidgets.isValidEmail(EmailName.text)) {
                  if (JoiningDate.text.trim().isEmpty) {
                    CustomWidgets.showToast(context, "Joining Name is required",false);
                  } else if (DateofBirth.text.trim().isEmpty) {
                    CustomWidgets.showToast(context, "Date of Birth is required",false);
                  }else if (Address.text.trim().isEmpty) {
                    CustomWidgets.showToast(context, "Address is required",false);
                  }else{
                    _currentIndex++;
                    setState(() {
                    });
                  }
                }else{
                  CustomWidgets.showToast(context, "Enter Valid Email",false);
                }

              },),
              ),
              CustomWidgets.width(10)
            ],) :Container(),
            CustomWidgets.height(height/12),
          ],),
      ),
    );
  }
  Widget Bank(){
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(left: 5,right: 5),
        margin: const EdgeInsets.only(top: 10),
        decoration: addAll ? const BoxDecoration() : BoxDecoration(color: Colorr.White, boxShadow: [
          BoxShadow(
            color: Colorr.themcolor100,
            blurStyle: BlurStyle.outer,
            blurRadius: 8,
          ),
        ]),
        child: Column(
          children: [
            CustomWidgets.height(5),
            addAll ? Container() : Container(height: 10,width: double.infinity,color: Colors.white,),
            addAll ? Container() : Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Text("   Bank Details :"),
              ],
            ),
            addAll ? Container() : CustomWidgets.height(5),
             CustomDropdown.search(hintText: "Bank Name",items: ALLBank.map((e) => e['value'].toString()).toList(), controller: BankName,onChanged: (p0) async {
               StatebyBank= await Shift_Add_api.StateBank(ALLBank.firstWhere((element) => element['value']==BankName.text)['key']);
               setState(() {});
             },),
            CustomDropdown.search(hintText: "State",items: StatebyBank.map((e) => e['value'].toString()).toList(), controller: State,onChanged:(p0) async {
              DistbyBank = await Shift_Add_api.DistrictBank(ALLBank.firstWhere((element) => element['value']==BankName.text)['key'], StatebyBank.firstWhere((element) => element['value']==State.text)['key']);
              setState(() {});
            },),
            CustomDropdown.search(hintText: "District",items: DistbyBank.map((e) => e['value'].toString()).toList(), controller: District,onChanged: (p0) async {
              BranchBank = await Shift_Add_api.BankBaranches(ALLBank.firstWhere((element) => element['value']==BankName.text)['key'], StatebyBank.firstWhere((element) => element['value']==State.text)['key'], DistbyBank.firstWhere((element) => element['value']==District.text)['key']);
              setState(() {});
              },),
            CustomDropdown.search(hintText: "Branch",items: BranchBank.map((e) => e['value'].toString()).toList(), controller: BankBranch,onChanged: (p0) {
              IfSCCode.text = BranchBank.firstWhere((element) => element['value']==BankBranch.text)['ifscCode'].toString();
              setState(() {});
            },),
            CustomWidgets.textField(hintText: "IFSC Code",controller: IfSCCode,readOnly: true),
            CustomWidgets.textField(hintText: "Bank Account No",controller: BankAccountNo,keyboardType:TextInputType.number),



            CustomWidgets.height(5),
            addAll ?  Row(mainAxisAlignment: MainAxisAlignment.end,children: [
              CustomWidgets.confirmButton(onTap:() {
                FocusScope.of(context).unfocus();
                FunControllerblank();
              }, height:  height/20, width: width/3.5, text: "Reset",Clr: Colorr.Reset),
              CustomWidgets.width(10),
              CustomWidgets.confirmButton(onTap:() {
                FocusScope.of(context).unfocus();
                if(BankAccountNo.text.isNotEmpty)
                  {
                    bool isValid = isValidAccountNumber(BankAccountNo.text);
                    if(isValid)
                      {
                        goToNextTab();
                      }else{
                      CustomWidgets.showToast(context, "Enter Valid Bank Account Number",false);
                    }
                  }else if(BankAccountNo.text.isEmpty)
                    {
                      goToNextTab();
                    }
              },height:  height/20, width: width/3.5, text: "Next"),
              CustomWidgets.width(10)
            ],) :Container(),
            CustomWidgets.height(5),
          ],),
      ),
    );
  }
  Widget BankIOS() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(left: 5,right: 5),
        margin: const EdgeInsets.only(top: 10),
        decoration: addAll ? const BoxDecoration() : BoxDecoration(color: Colorr.White, boxShadow: [
          BoxShadow(
            color: Colorr.themcolor100,
            blurStyle: BlurStyle.outer,
            blurRadius: 8,
          ),
        ]),
        child: Column(
          children: [
            CustomWidgets.height(5),
            addAll ? Container() : Container(height: 10,width: double.infinity,color: Colors.white,),
            addAll ? Container() : Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Text("   Bank Details :"),
              ],
            ),
            addAll ? Container() : CustomWidgets.height(5),
            CustomWidgets.textFieldIOS(hintText: "Bank Name",controller: BankName),
            CustomWidgets.textFieldIOS(hintText: "Branch Name",controller: BankBranch),
            CustomWidgets.textFieldIOS(hintText: "Bank Account No.",controller: BankAccountNo),
            CustomWidgets.textFieldIOS(hintText: "IFSC Code",controller: IfSCCode),
            CustomWidgets.textFieldIOS(hintText: "Pan No.",controller: PanNo),
            CustomWidgets.textFieldIOS(hintText: "Select State",controller: State),
            CustomWidgets.textFieldIOS(hintText: "Select District",controller:District),
            CustomWidgets.height(5),
            addAll ?  Row(mainAxisAlignment: MainAxisAlignment.end,children: [
              SizedBox( height:  height/20, width: width/3.5,
                child:  CupertinoButton(padding: EdgeInsets.zero,color: Colorr.Reset,child: const Text("Reset"), onPressed: () {
                  FocusScope.of(context).unfocus();
                  FunControllerblank();
                },),
              ),
              CustomWidgets.width(10),
              SizedBox( height:  height/20, width: width/3.5,
                child:  CupertinoButton(padding: EdgeInsets.zero,color: Colorr.themcolor,child: const Text("Next"), onPressed: () {
                  FocusScope.of(context).unfocus();
                  if(BankAccountNo.text.isNotEmpty)
                  {
                    bool isValid = isValidAccountNumber(BankAccountNo.text);
                    if(isValid)
                    {
                      _currentIndex++;
                      setState(() {
                      });
                    }else{
                      CustomWidgets.showToast(context, "Enter Valid Bank Account Number",false);
                    }
                  }else if(BankAccountNo.text.isEmpty)
                  {
                    _currentIndex++;
                    setState(() {
                    });
                  }

                },),
              ),
              CustomWidgets.width(10)
            ],) :Container(),
            CustomWidgets.height(height/12),
          ],),
      ),
    );
  }
  Widget Family(){
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(left: 5,right: 5),
        margin: const EdgeInsets.only(top: 10),
        decoration: addAll ? const BoxDecoration() : BoxDecoration(color: Colorr.White, boxShadow: [
          BoxShadow(
            color: Colorr.themcolor100,
            blurStyle: BlurStyle.outer,
            blurRadius: 8,
          ),
        ]),
        child: Column(
          children: [
            CustomWidgets.height(5),
            addAll ? Container() :
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Text("   Family Details :"),
              ],
            ),
            addAll ? Container() : CustomWidgets.height(5),
            CustomWidgets.textField(hintText: "Name",controller: Name),
            CustomWidgets.textField(hintText: "Relation With Employee",controller: ReletionWithEmployee),
            CustomWidgets.textField(hintText: "Phone No",controller: PhoneNoFamily,keyboardType: TextInputType.phone,MaxFont: 13,height:65,
              onChanged: (value) {
              if(value.toString().length < 9)
                {
                  Familyphone=true;
                }else{
                Familyphone=false;
              }
              setState(() {
              });
              },
                erroreText: perphone == false ? "Enter Phone number" : null,
                eorror   :  perphone == false ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.red,)
                ) : null
            ),
            CustomWidgets.textField(hintText: "Address",controller: AddressFamily,keyboardType: TextInputType.streetAddress,maxLines: 3,height: height/10),
            CustomWidgets.height(5),
          addAll? Row(mainAxisAlignment: MainAxisAlignment.end,
               children: [
             CustomWidgets.confirmButton(onTap:() {
               FocusScope.of(context).unfocus();
               FunControllerblank();
             }, height: height/20, width: width/3.5, text: "Reset",Clr: Colorr.Reset),
                 CustomWidgets.width(5),
             CustomWidgets.confirmButton(onTap:() async {
               FocusScope.of(context).unfocus();
               if(await CustomWidgets.CheakConnectionInternetButton())
               {
                 goToNextTab();
               }else{
               CustomWidgets.showToast(context, "No Internet Connection", false);
               }
             }, height: height/20, width: width/3.5, text: "Next")
           ]):Container(),
          ],),
      ),
    );
  }
  Widget Goverment(){
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(left: 5,right: 5),
        margin: const EdgeInsets.only(top: 10),
        decoration: addAll ? const BoxDecoration() : BoxDecoration(color: Colorr.White, boxShadow: [
          BoxShadow(
            color: Colorr.themcolor100,
            blurStyle: BlurStyle.outer,
            blurRadius: 8,
          ),
        ]),
        child: Column(
          children: [
            CustomWidgets.height(5),
            addAll ? Container() :
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Text("   Goverment Details :"),
              ],
            ),
            addAll ? Container() : CustomWidgets.height(5),
            CustomWidgets.textField(hintText: "Pan No",controller: PanNo),
            CustomWidgets.textField(hintText: "PF No",controller: PfNo,keyboardType: const TextInputType.numberWithOptions()),
            CustomWidgets.textField(hintText: "ESIS No",controller: EsisNo,keyboardType: const TextInputType.numberWithOptions()),
            CustomWidgets.textField(hintText: "UN No",controller: UnNo,keyboardType: const TextInputType.numberWithOptions()
            ),
            CustomWidgets.height(5),
           widget.e==null ? Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
               children: [
             CustomWidgets.confirmButton(onTap:() {
               FocusScope.of(context).unfocus();
               FunControllerblank();
             }, height:  height/20, width: width/3.5, text: "Reset",Clr: Colorr.Reset),
             CustomWidgets.confirmButton(onTap:() async {
               FocusScope.of(context).unfocus();
               if(await CustomWidgets.CheakConnectionInternetButton())
               {
                 SaveButton("Save");
               }else{
                 CustomWidgets.showToast(context, "No Internet Connection", false);
               }
             }, height:  height/20, width:  width/3.5, text: "Save"),
             CustomWidgets.confirmButton(onTap:() async {
               FocusScope.of(context).unfocus();
               if(await CustomWidgets.CheakConnectionInternetButton())
               {
               SaveButton("Save&Continue");
               }else{
               CustomWidgets.showToast(context, "No Internet Connection", false);
               }
             }, height:  height/20, width: width/2.6, text: "Save & Continue",),
           ]) :
           Row(mainAxisAlignment: MainAxisAlignment.center,
               children: [
             CustomWidgets.confirmButton(onTap:() {
               FocusScope.of(context).unfocus();
               FunControllerblank();
             }, height: height/20, width: width/3, text: "Reset",Clr: Colorr.Reset),
                 CustomWidgets.width(5),
             CustomWidgets.confirmButton(onTap:() async {
               FocusScope.of(context).unfocus();
               if(await CustomWidgets.CheakConnectionInternetButton())
               {
                 SaveButton("Update");
               }else{
               CustomWidgets.showToast(context, "No Internet Connection", false);
               }
             }, height: height/20, width: width/3, text: "Update")
           ]),
          ],),
      ),
    );
  }
  Widget FamilyIOS(){
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(left: 5,right: 5),
        margin: const EdgeInsets.only(top: 10),
        decoration: addAll ? const BoxDecoration() : BoxDecoration(color: Colorr.White, boxShadow: [
          BoxShadow(
            color: Colorr.themcolor100,
            blurStyle: BlurStyle.outer,
            blurRadius: 8,
          ),
        ]),
        child: Column(
          children: [
            CustomWidgets.height(5),
            addAll ? Container() : Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Text("   Family Details :"),
              ],
            ),
            addAll ? Container() : CustomWidgets.height(5),
            CustomWidgets.textFieldIOS(hintText: "Name",controller: Name),
            CustomWidgets.textFieldIOS(hintText: "Relation With Employee",controller: ReletionWithEmployee),
            CustomWidgets.textFieldIOS(hintText: "Phone No",controller: PhoneNoFamily,keyboardType: TextInputType.phone),
            CustomWidgets.textFieldIOS(hintText: "Address",controller: AddressFamily,keyboardType: TextInputType.streetAddress,maxLines: 3,height: height/10),
            CustomWidgets.height(5),

           if (widget.e==null) Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
               children: [
                 SizedBox(height:  height/20, width: width/3.5,child: CupertinoButton(color: Colorr.Reset,padding: EdgeInsets.zero, onPressed: () {
                   FocusScope.of(context).unfocus();
                   FunControllerblank();
                 },child: const Text("Reset"),),),
                 SizedBox(height:  height/20, width: width/3.5,child: CupertinoButton(color: Colorr.themcolor,padding: EdgeInsets.zero, onPressed: () async {
                   FocusScope.of(context).unfocus();
                   if(await CustomWidgets.CheakConnectionInternetButton())
                   {
                   SaveButton("Save");
                   }else{
                   CustomWidgets.showToast(context, "No Internet Connection", false);
                   }
                 },child: const Text("Save"),),),
                 SizedBox(height:  height/20, width: width/2.6,child: CupertinoButton(color: Colorr.themcolor,padding: EdgeInsets.zero, onPressed: () async {
                   FocusScope.of(context).unfocus();
                   if(await CustomWidgets.CheakConnectionInternetButton())
                   {
                     SaveButton("Save&Continue");
                   }else{
                     CustomWidgets.showToast(context, "No Internet Connection", false);
                   }
                 },child: const Text("Save & Continue"),),),
           ]) else Row(mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 SizedBox(height:  height/20, width: width/3.5,child: CupertinoButton(color: Colorr.Reset,padding: EdgeInsets.zero, onPressed: () {
                   FocusScope.of(context).unfocus();
                   FunControllerblank();
                 },child: const Text("Reset"),),),
                 CustomWidgets.width(5),
                 SizedBox(height:  height/20, width: width/3.5,child: CupertinoButton(color: Colorr.themcolor,padding: EdgeInsets.zero, onPressed: () async {
                   FocusScope.of(context).unfocus();
                   if(await CustomWidgets.CheakConnectionInternetButton())
                   {
                     SaveButton("Update");
                   }else{
                     CustomWidgets.showToast(context, "No Internet Connection", false);
                   }
                 },child: const Text("Update"),),),

           ]),
          ],),
      ),
    );
  }
  SaveButton(String Save)
  async {
    FocusScope.of(context).unfocus();
    if (FristName.text.trim().isEmpty) {
      CustomWidgets.showToast(context, "First Name is required",false);
    } else if (MiddleName.text.trim().isEmpty) {
      CustomWidgets.showToast(context, "Middle Name is required",false);
    }else if (EMPCode.text.trim().isEmpty) {
      CustomWidgets.showToast(context, "Employee Code is required",false);
    } else if (LastName.text.trim().isEmpty) {
      CustomWidgets.showToast(context, "Last Name is required",false);
    } else if (BranchName.text.trim().isEmpty) {
      CustomWidgets.showToast(context, "Branch Name is required",false);
    } else if (Con_List.BranchSelect.where((e) => e['name'] == BranchName.text).isEmpty) {
      CustomWidgets.showToast(context, "Enter Valid Branch",false);
    } else if (DeparmentName.text.trim().isEmpty) {
      CustomWidgets.showToast(context, "Deparment Name is required",false);
    } else if (Con_List.DeparmenntSelect.where((e) => e['name'] == DeparmentName.text).isEmpty) {
      CustomWidgets.showToast(context, "Enter Valid Deparment",false);
    } else if (DesignationName.text.trim().isEmpty) {
      CustomWidgets.showToast(context, "Designation Name is required",false);
    } else if (Con_List.DesignationSelect.where((e) => e['name'] == DesignationName.text).isEmpty) {
      CustomWidgets.showToast(context, "Enter Valid Designation Name",false);
    } else if (RoleName.text.trim().isEmpty) {
      CustomWidgets.showToast(context, "Role Name is required",false);
    }else if (Con_List.RoleSelect.where((e) => e['name'] == RoleName.text).isEmpty) {
      CustomWidgets.showToast(context, "Enter Valid Role Name",false);
    } else if (ShiftName.text.trim().isEmpty) {
      CustomWidgets.showToast(context, "Shift Name is required",false);
    }else if (Con_List.Allshift_Select.where((e) => e['name'] == ShiftName.text).isEmpty) {
      CustomWidgets.showToast(context, "Enter Valid Shift Name",false);
    } else if (selectedGender.isEmpty) {
      CustomWidgets.showToast(context, "Select Gender",false);
    } else if (PhoneNo.text.length < 10 ) {
      CustomWidgets.showToast(context, "Enter Valid Contact",false);
    } else if (EmailName.text.trim().isEmpty) {
      CustomWidgets.showToast(context, "Email Id is required",false);
    } else if (CustomWidgets.isValidEmail(EmailName.text)) {
       if (JoiningDate.text.trim().isEmpty) {
      CustomWidgets.showToast(context, "Joining Name is required",false);
    } else if (DateofBirth.text.trim().isEmpty) {
      CustomWidgets.showToast(context, "Date of Birth is required",false);
    }else if (Address.text.trim().isEmpty) {
      CustomWidgets.showToast(context, "Address is required",false);
    } else if (BankAccountNo.text.isNotEmpty) {
         bool isValid = isValidAccountNumber(BankAccountNo.text);
         if(isValid)
           {
              if (Name.text.trim().isEmpty) {
               CustomWidgets.showToast(context, "Name is required",false);
             } else if (ReletionWithEmployee.text.trim().isEmpty) {
               CustomWidgets.showToast(context, "Enter Reletion With Employee",false);
             } else if (PhoneNoFamily.text.length < 13) {
               CustomWidgets.showToast(context, "Enter Valid Family Phone No",false);
             } else if (AddressFamily.text.trim().isEmpty) {
               CustomWidgets.showToast(context, "Address is required",false);
             } else {
               Map data = {
                 if(widget.e == null)  "companyId": Constants_Usermast.companyId else "id" :widget.e!['_id'],
                 "branchId": Con_List.BranchSelect.firstWhere((e) => e['name'] == BranchName.text)['_id'].toString(),
                 "FirstName": FristName.text,
                 "MiddelName": MiddleName.text,
                 "LastName": LastName.text,
                 "departmentId":  Con_List.DeparmenntSelect.firstWhere((e) => e['name'] == DeparmentName.text)['_id'].toString(),
                 "designationId": Con_List.DesignationSelect.firstWhere((e) => e['name'] == DesignationName.text)['_id'].toString(),
                 "roleId":  Con_List.RoleSelect.firstWhere((e) => e['name'] == RoleName.text)['_id'].toString(),
                 "ShiftId" :   Con_List.Allshift_Select.firstWhere((e) => e['name'] == ShiftName.text)['_id'].toString(),
                 "Email": EmailName.text,
                 "JoiningDate": JoiningDate.text,
                 "Dob": DateofBirth.text,
                 "StateName" : State.text,
                 "DistrictName" : District.text,
                 "AnniversaryDate" : AnniversaryDate.text,
                 "ClosedDate": ClosedDate.text,
                 "Gender": selectedGender,
                 "Number": PhoneNo.text,
                 "Address": Address.text,
                 // "faceId": "sagar",
                 "BankName": BankName.text,
                 "BankBranch": BankBranch.text,
                 "BankAccountNo": BankAccountNo.text,
                 "IFSCcode": IfSCCode.text,
                 "PANno": PanNo.text,
                 "PFno": PfNo.text,
                 "ESICno": EsisNo.text,
                 "UNno": UnNo.text,
                 "EmpCode":EMPCode.text,
                 "FamilyName": Name.text,
                 "Relationship": ReletionWithEmployee.text,
                 "FamilyPhone": PhoneNoFamily.text,
                 "FamilyAddress" : AddressFamily.text,
                 "isActive": isActive.toString()
               };
               if(widget.e==null) {
                 if (await AllEmployee_api.Employeeadd(data,context)) {
                   if (Save == "Save") {
                     CustomWidgets.showToast(context, "Employee Add Successfully",true);
                     Navigator.pushReplacement(
                         context, MaterialPageRoute(builder: (context) {
                       return const AllEmployees();
                     },));
                   } else {
                     CustomWidgets.showToast(context, "Employee Add Successfully",true);
                     FunControllerblank();
                   }
                 }
               }else{

                 if (await AllEmployee_api.EmployeeUpdate(data,context)) {
                   if (Save == "Update") {
                     CustomWidgets.showToast(context, "Employee Update Successfully",true);
                     if(widget.name==null)
                     {
                       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                         return const AllEmployees();
                       },));
                     }else{
                       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                         return const EmployeeProfileScreen();
                       },));
                     }
                   } else {
                     CustomWidgets.showToast(context, "Employee Not Update Successfully",false);
                     FunControllerblank();
                   }
                 }
               }
             }
           }else {
           CustomWidgets.showToast(context, "Enter Valid Bank Account Number",false);
         }
    }else if (Name.text.trim().isEmpty) {
         CustomWidgets.showToast(context, "Name is required",false);
       }
       else if (ReletionWithEmployee.text.trim().isEmpty) {
         CustomWidgets.showToast(context, "Enter Reletion With Employee",false);
       }
       else if (PhoneNoFamily.text.length!=10) {
         CustomWidgets.showToast(context, "Enter Valid Family Phone No",false);
       }
       else if (AddressFamily.text.trim().isEmpty) {
         CustomWidgets.showToast(context, "Address is required",false);
       }
       else {
         Map data = {
           if(widget.e == null)  "companyId": Constants_Usermast.companyId else "id" :widget.e!['_id'],
           "branchId": Con_List.BranchSelect.firstWhere((e) => e['name'] == BranchName.text)['_id'].toString(),
           "FirstName": FristName.text,
           "MiddelName": MiddleName.text,
           "LastName": LastName.text,
           "departmentId":  Con_List.DeparmenntSelect.firstWhere((e) => e['name'] == DeparmentName.text)['_id'].toString(),
           "designationId": Con_List.DesignationSelect.firstWhere((e) => e['name'] == DesignationName.text)['_id'].toString(),
           "roleId":  Con_List.RoleSelect.firstWhere((e) => e['name'] == RoleName.text)['_id'].toString(),
           "ShiftId" :   Con_List.Allshift_Select.firstWhere((e) => e['name'] == ShiftName.text)['_id'].toString(),
           "Email": EmailName.text,
           "JoiningDate": JoiningDate.text,
           "Dob": DateofBirth.text,
           "EmpCode":EMPCode.text,
           "StateName" : State.text,
           "DistrictName" : District.text,
           "AnniversaryDate" : AnniversaryDate.text,
           "ClosedDate": ClosedDate.text,
           "Gender": selectedGender,
           "Number": PhoneNo.text,
           "Address": Address.text,
           // "faceId": "sagar",
           "BankName": BankName.text,
           "BankBranch": BankBranch.text,
           "BankAccountNo": BankAccountNo.text,
           "IFSCcode": IfSCCode.text,
           "PANno": PanNo.text,
           "PFno": PfNo.text,
           "ESICno": EsisNo.text,
           "UNno": UnNo.text,
           "FamilyName": Name.text,
           "Relationship": ReletionWithEmployee.text,
           "FamilyPhone": PhoneNoFamily.text,
           "FamilyAddress" : AddressFamily.text,
           "isActive": isActive.toString()
         };
         if(widget.e==null) {
           if (await AllEmployee_api.Employeeadd(data,context)) {
             if (Save == "Save") {
               CustomWidgets.showToast(context, "Employee Add Successfully",true);
               Navigator.pushReplacement(
                   context, MaterialPageRoute(builder: (context) {
                 return const AllEmployees();
               },));
             } else {
               CustomWidgets.showToast(context, "Employee Add Successfully",true);
               FunControllerblank();
             }
           }
         }else{
           if (await AllEmployee_api.EmployeeUpdate(data,context)) {
             if (Save == "Update") {
               CustomWidgets.showToast(context, "Employee Update Successfully",true);
               if(widget.name==null)
               {
                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                   return const AllEmployees();
                 },));
               }else{
                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                   return const EmployeeProfileScreen();
                 },));
               }
             } else {
               CustomWidgets.showToast(context, "Employee Not Update Successfully",false);
               FunControllerblank();
             }
           }
         }
       }
    }else{
      CustomWidgets.showToast(context, "Enter Valid Email",false);
    }
  }
  FunControllerblank(){
    FristName.text="";
    MiddleName.text="";
    LastName.text="";
    BranchName.text="";
    DeparmentName.text="";
    DesignationName.text="";
    RoleName.text="";
    GenderName.text="";
    PhoneNo.text="";
    PhoneNoFamily.text="";
    EmailName.text="";
    JoiningDate.text="";
    DateofBirth.text="";
    ClosedDate.text="";
    BankName.text="";
    BankBranch.text="";
    BankAccountNo.text="";
    IfSCCode.text="";
    PanNo.text="";
    Name.text="";
    EMPCode.text="";
    ReletionWithEmployee.text="";
    PhoneNo.text="";
    Address.text="";
    AddressFamily.text="";
    setState(() {
    });
  }
  Future<void> _selectDate(BuildContext context, String date) async {
    DateTime selectedDate = DateTime.now();
    DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    DateTime dateTime=DateTime.now();
    if(JoiningDate.text.isNotEmpty){
      dateTime = dateFormat.parse(JoiningDate.text);
    }
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: JoiningDate.text.isNotEmpty ? dateTime: selectedDate,
      firstDate: JoiningDate.text.isNotEmpty ? dateTime.add(const Duration(minutes: 10)): DateTime(2015),
      lastDate: selectedDate,
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
                foregroundColor: Colorr.themcolor, // button text color
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
        if (date == "Joining") {
          joinDate = picked;
          JoiningDate.text = DateFormat('dd-MM-yyyy').format(picked);
        } else if (date == "Close") {
          CloseDate = picked;
          ClosedDate.text = DateFormat('dd-MM-yyyy').format(picked);
          // Format and update text field with selected date
        }
      });
    }
  }
  // Future<void> _selectDate1(BuildContext context, String date) async {
  //   DateTime selectedDate = DateTime.now();
  //   DateFormat dateFormat = DateFormat('dd-MM-yyyy');
  //   DateTime dateTime=DateTime.now();
  //   if(ClosedDate.text.isNotEmpty){
  //     dateTime = dateFormat.parse(ClosedDate.text);
  //   }
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: ClosedDate.text.isNotEmpty ? dateTime: selectedDate,
  //     firstDate: joinDate ?? DateTime(2015),
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
  //       if (date == "Joining") {
  //         joinDate = picked;
  //         JoiningDate.text = DateFormat('dd-MM-yyyy').format(picked);
  //       } else if (date == "Close") {
  //         CloseDate = picked;
  //         ClosedDate.text = DateFormat('dd-MM-yyyy').format(picked);
  //
  //       }
  //     });
  //   }
  // }
  bool isValidAccountNumber(String accountNumber) {
    RegExp regex = RegExp(r"""
^[1-9]\d{8,17}$""");
    return regex.hasMatch(accountNumber);
  }
}
