import 'package:attendy/A_SQL_Trigger/Con_List.dart';
import 'package:attendy/A_SQL_Trigger/Con_Usermast.dart';
import 'package:attendy/A_SQL_Trigger/Employee_Add_api.dart';
import 'package:attendy/A_SQL_Trigger/Role_api.dart';
import 'package:attendy/A_SQL_Trigger/api_page.dart';
import 'package:attendy/utils/Constant/LocalCustomWidgets.dart';
import 'package:attendy/view/Users/User.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../utils/Constant/Colors.dart';
import '../../utils/DroupDown/custom_dropdown.dart';

class AddUser extends StatefulWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  List<String> RoleName=[],CompanyName=[],AllEmployee=[];
  TextEditingController Username=TextEditingController();
  TextEditingController Email=TextEditingController();
  TextEditingController password=TextEditingController();
  TextEditingController Confirmpassword=TextEditingController();
  TextEditingController phone=TextEditingController();
  TextEditingController Role=TextEditingController();
  TextEditingController Employee=TextEditingController();
  TextEditingController Company=TextEditingController();
  bool erore=true;
  bool perphone=true;
  bool AddActive=false;
  bool Showconpassword=true;
  bool Showpassword=true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }
  getdata()
  async {
    Con_List.RoleSelect=await Role_api.RoleSelect();
    Con_List.AllEmployee=await AllEmployee_api.EmployeeSelect();
    Con_List.CompanySelect =await api_page.CompanySelect();
    Con_List.RoleSelect.forEach((element) {
      if(element['isActive']==true) {
        RoleName.add(element['name']);
      }
    });
    Con_List.AllEmployee.forEach((element) {
      if(element['isActive']==true)
      {
        AllEmployee.add(element['FirstName']);
      }
    });
    Con_List.CompanySelect.forEach((element) {
      if(element['_id'].toString()==Constants_Usermast.companyId.toString())
      {
        CompanyName.add(element['name'].toString());
      }
    });
  }
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height-kToolbarHeight;
    double width=MediaQuery.of(context).size.width;
    Future<bool> onBackPress() {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return User();
      },));
      return Future.value(false);
    }
    return WillPopScope(
        onWillPop: () => onBackPress(),
    child:  Constants_Usermast.IOS==true ? CupertinoPageScaffold(
      navigationBar:CustomWidgets.appbarIOS(title:"Add New User" , action: [], context: context, onTap: () {
        Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) {
          return User();
        },));
      },),
      child:  SingleChildScrollView(
        child: Column(children: [
          CustomWidgets.height(10),
          CustomWidgets.textFieldIOS(hintText: "Username",controller: Username),
          CustomWidgets.textFieldIOS(hintText: "Email",controller: Email),
          CustomWidgets.textFieldIOS(hintText: "Password",controller: password,obscureText: Showpassword,suffixIcon: IconButton(
              splashRadius: 18,
              onPressed: () {
                if(Showpassword)
                {
                  Showpassword=false;
                }else{
                  Showpassword=true;
                }
                setState(() {
                });
              }, icon: Icon(Icons.remove_red_eye,color: Colorr.Grey600,))),
          CustomWidgets.textFieldIOS(hintText: "Confirm password",controller: Confirmpassword,obscureText: Showconpassword,suffixIcon: IconButton(splashRadius: 18,onPressed: () {
            if(Showconpassword)
            {
              Showconpassword=false;
            }else{
              Showconpassword=true;
            }
            setState(() {
            });
          }, icon: Icon(Icons.remove_red_eye,color: Colorr.Grey600,))),
          CustomWidgets.textFieldIOS(hintText: "Phone",controller: phone,keyboardType: TextInputType.phone,MaxFont: 13),
          CustomWidgets.textFieldIOS(hintText: "Select Role",controller: Role,readOnly: true,onTap: () {
            CustomWidgets.SelectDroupDown(context: context,items: RoleName, onSelectedItemChanged: (int) {
              Role.text=RoleName[int];
              setState(() {
              });
            });
          },suffix: CustomWidgets.aarowCupertinobutton(),
          ),
          CustomWidgets.textFieldIOS(hintText: "Select Company",controller: Company,readOnly: true,onTap: () {
            CustomWidgets.SelectDroupDown(context: context,items: CompanyName, onSelectedItemChanged: (int) {
              Company.text=CompanyName[int];
              setState(() {
              });
            });
          },suffix: CustomWidgets.aarowCupertinobutton(),
          ),
          CustomWidgets.textFieldIOS(hintText: "Select Employee",controller: Employee,readOnly: true,onTap: () {
            CustomWidgets.SelectDroupDown(context: context,items: AllEmployee, onSelectedItemChanged: (int) {
              Employee.text=AllEmployee[int];
              setState(() {
              });
            });
          },suffix: CustomWidgets.aarowCupertinobutton(),
          ),
          Row(
            children: [
              CupertinoSwitch(
                value: AddActive,
                onChanged: (value) {
                  setState(() {
                    AddActive = value;
                  });
                },
                activeColor: Colorr.themcolor,
              ),
              Text("Active"),
            ],
          ),
          CustomWidgets.height(height/20),
          Row(
            children: [
              SizedBox(width: 5),
              Expanded(
                flex: 2,
                child: CupertinoButton(
                  color: Colorr.Reset,
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    Username.text="";
                    Email.text="";
                    password.text="";
                    Confirmpassword.text="";
                    phone.text="";
                    Role.text="";
                    Company.text="";
                    Employee.text="";
                    setState(() {
                    });
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
                    Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) {
                      return User();
                    },));
                  },
                  child: Text('Cancel'),
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
                     Savebutton();
                    }else{
                      CustomWidgets.showToast(context, "No Internet Connection", false);
                    }
                  },
                  child: Text('Save'),
                ),
              ),
              SizedBox(width: 5),
            ],
          )
        ]
        ),
      ),
    ) :
    Scaffold(
      appBar: CustomWidgets.appbar(title: "Add New User",action:  [
      ],context:  context,onTap: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return User();
        },));
      },),
      body: SingleChildScrollView(
        child: Column(children: [
          CustomWidgets.height(10),
          CustomWidgets.textField(hintText: "Username",controller: Username),
          CustomWidgets.textField(hintText: "Email Id",controller: Email,keyboardType: TextInputType.emailAddress,height:erore == false ?  65 : null,
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
                  borderSide: BorderSide(color: Colors.red,)
              ) : null),
          CustomWidgets.textField(hintText: "Password",controller: password,obscureText: Showpassword,suffixIcon: IconButton(
              splashRadius: 18,
              onPressed: () {
            if(Showpassword)
            {
              Showpassword=false;
            }else{
              Showpassword=true;
            }
            setState(() {
            });
          }, icon: Icon(Icons.remove_red_eye,color: Colorr.Grey600,))),
          CustomWidgets.textField(hintText: "Confirm password",controller: Confirmpassword,obscureText: Showconpassword,suffixIcon: IconButton(splashRadius: 18,onPressed: () {
           if(Showconpassword)
             {
               Showconpassword=false;
             }else{
             Showconpassword=true;
           }
            setState(() {
            });
          }, icon: Icon(Icons.remove_red_eye,color: Colorr.Grey600,))),
          CustomWidgets.textField(hintText: "Phone No.",controller: phone, keyboardType: TextInputType.phone,MaxFont: 13,height:perphone ==false ? 65:65,
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
                  borderSide: BorderSide(color: Colors.red,)
              ) : null
          ),
          CustomDropdown.search(  listItemStyle: CustomWidgets.style(),
            hintText: 'Select Role',
            controller: Role,
            items: RoleName,
          ),
          CustomDropdown.search(listItemStyle: CustomWidgets.style(),
            hintText: 'Select Company',
            controller: Company,
            items: CompanyName,
          ),
          CustomDropdown.search(listItemStyle: CustomWidgets.style(),
            hintText: 'Select Employee',
            controller: Employee,
            items: AllEmployee,
          ),
          Row(children : [
            Checkbox(
              shape: CircleBorder(),
              value: AddActive,
              activeColor: Colorr.themcolor,
              onChanged: (value) {
                setState(() {
                  AddActive = value!;
                });
              },
            ),
            Text("Active"),
          ]),
          CustomWidgets.height(height/10),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
           CustomWidgets.confirmButton(onTap: () {
             Focus.of(context).unfocus();
             Username.text="";
             Email.text="";
             password.text="";
             Confirmpassword.text="";
             phone.text="";
             Role.text="";
             Company.text="";
             Employee.text="";
             setState(() {
             });
           }, height: height/20, width: width/3.1, text: "Reset",Clr: Colorr.Reset),
            CustomWidgets.confirmButton(onTap: () {
              Focus.of(context).unfocus();
             Navigator.push(context, MaterialPageRoute(builder: (context) {
               return User();
             },));
           }, height: height/20, width: width/3.1, text: "Cancel",Clr: Colorr.Reset),
            CustomWidgets.confirmButton(onTap: () async {
              if(await CustomWidgets.CheakConnectionInternetButton())
              {
                Savebutton();
              }else{
              CustomWidgets.showToast(context, "No Internet Connection", false);
              }
           }, height: height/20, width: width/3.1, text: "Save")
          ],)
        ]),
      ),
    ));
  }
  Savebutton()
  async {
    if(Username.text.trim().isEmpty)
      {
        CustomWidgets.showToast(context,"Enter Username",false);
      }
    else if(Email.text.trim().isEmpty)
        {
          CustomWidgets.showToast(context,"Enter Email",false);
        }else if(CustomWidgets.isValidEmail(Email.text))
          {
            if(password.text.trim().isEmpty)
              {
                CustomWidgets.showToast(context,"Enter Password",false);
              }else if (Confirmpassword.text.trim().isEmpty)
                {
                  CustomWidgets.showToast(context,"Enter Confirm Password",false);
                }if(password.text==Confirmpassword.text)
                  {
                    if(phone.text.length < 10 )
                      {
                        CustomWidgets.showToast(context,"Enter Valid phone",false);
                      }else if(Role.text.trim().isEmpty)
                        {
                          CustomWidgets.showToast(context,"Enter Role",false);
                        }else if(Con_List.AllEmployee.where((element) => element['roleId']['name'] == Role.text).isEmpty)
                        {
                          CustomWidgets.showToast(context,"Enter Valid Role",false);
                        }else if(Company.text.trim().isEmpty)
                        {
                          CustomWidgets.showToast(context,"Enter Company",false);
                        }else if(Con_List.CompanySelect.where((element) => element['name']==Company.text).isEmpty)
                        {
                          CustomWidgets.showToast(context,"Enter Valid Company",false);
                        }else if(Employee.text.trim().isEmpty)
                        {
                          CustomWidgets.showToast(context,"Enter Employee",false);
                        }else if(Con_List.AllEmployee.where((element) => element['FirstName']==Employee.text).isEmpty)
                        {
                          CustomWidgets.showToast(context,"Enter Valid employeeName",false);
                        }
                    else{
                      Map data= {
                        "name" : Username.text,
                        "email" : Email.text,
                        "company_id" : Constants_Usermast.companyId,
                        "phone" :  phone.text,
                        "isActive" : AddActive.toString(),
                        "password" : password.text,
                        "roleId" : Con_List.AllEmployee.firstWhere((element) => element['roleId']['name'].toString() == Role.text, orElse: () => {'_id': ''})['_id'].toString(),
                        "employeeId" :  Con_List.AllEmployee.firstWhere((element) => element['FirstName'].toString() == Employee.text,orElse: () => {'_id': ''})['_id'].toString()
                      };
                      if(await api_page.CreateUser(data)){
                        CustomWidgets.showToast(context,"User Add Successfully",true);
                      }else{
                        CustomWidgets.showToast(context,"User Not Add",false);
                      }
                    }
                  }else{
              CustomWidgets.showToast(context,"Password Not Match",false);
            }
          }else{
     CustomWidgets.showToast(context,"Enter Valid Email",false);
    }
  }
}
