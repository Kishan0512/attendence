import 'package:attendy/Modal/All_import.dart';
import 'package:http/http.dart' as http;

import 'Notification_api.dart';


class api_page {
  static Future logincheck(String pStrUsername, String pStrPassword,
      String? Email, String? phone, String tipe) async {
    if (tipe == "log_in") {
      Map data = {
        "name": pStrUsername.toString().trimLeft().trimRight(),
        "password": pStrPassword.toString().trimLeft().trimRight(),
      };
      try{
      final response = await http.post(Uri.parse(AppUrl.login), body: data).timeout(Duration(seconds: 8));
      if (response.statusCode == 200) {
        var Response = jsonDecode(response.body);
        if (Response['status'] == true) {
          if (Response.toString().isNotEmpty && Response.toString() != "null") {
            if (Response['data']['isActive'] == true) {
              login_user p = login_user.fromJson(Response);
              if (Response['data'].isNotEmpty) {
                Notification_Api.ComapnyID = Response['data']['company_id'];
                SharedPref.save_bool(SrdPrefkey.login.toString(), true);
                SharedPref.save_string(SrdPrefkey.LoginPassword.toString(),
                    pStrPassword.toString().trimLeft().trimRight());
                SharedPref.save_string(
                    SrdPrefkey.token.toString(), p.token.toString());
                SharedPref.save_string(
                    SrdPrefkey.message.toString(), p.message);
                SharedPref.save_string(
                    SrdPrefkey.name.toString(), p.data.name.toString());
                SharedPref.save_int(SrdPrefkey.phone.toString(), p.data.phone);
                SharedPref.save_string(SrdPrefkey.companyId.toString(),
                    p.data.companyId.toString());
                SharedPref.save_string(
                    SrdPrefkey.email.toString(), p.data.email.toString());
                SharedPref.save_string(SrdPrefkey.createdAt.toString(),
                    p.data.createdAt.toString());
                SharedPref.save_string(SrdPrefkey.employeeCount.toString(),
                    p.data.employeeCount.toString());
                SharedPref.save_bool(
                    SrdPrefkey.isActive.toString(), p.data.isActive);
                SharedPref.save_string(
                    SrdPrefkey.otp.toString(), p.data.otp.toString());
                SharedPref.save_string(
                    SrdPrefkey.password.toString(), p.data.password.toString());
                SharedPref.save_string(
                    SrdPrefkey.Profile.toString(), p.data.image.toString());
                SharedPref.save_string(
                    SrdPrefkey.sId.toString(), p.data.sId.toString());
                SharedPref.save_string(SrdPrefkey.updatedAt.toString(),
                    p.data.updatedAt.toString());
                SharedPref.save_string(
                    SrdPrefkey.roleId.toString(), p.data.roleId.toString());
                SharedPref.save_string(
                    SrdPrefkey.faceId.toString(), p.data.faceID.toString());
                SharedPref.save_string(SrdPrefkey.employeeId.toString(),
                    p.data.employeeId.toString());
                SharedPref.save_string(
                    SrdPrefkey.roleName.toString(), p.data.roleName.toString());
                return true;
              } else {
                return false;
              }
            } else {
              Con_List.Active.value = true;
              return false;
            }
          }
        } else {
            return false;
        }
      } else if (response.statusCode == 500) {
        Con_List.Server.value = true;
        return false;
      } else if(response.statusCode == 400)
      {
          Con_List.Pass.value = true;
          return false;
      }}  on TimeoutException catch (e) {
        print('Server is offline: $e');
        Con_List.Server.value = true;
        return false;
      } on http.ClientException catch (e) {
        print('HTTP Exception: $e');
        Con_List.Server.value = true;
        return false;
      } on SocketException catch (e) {
        print('Error: $e');
        Con_List.Server.value = true;
        return false;
      } catch (e){
        print("Other error $e");
        false;
      }

    } else {
      Map data = {
        "name": pStrUsername.toString(),
        "email": Email.toString(),
        "password": pStrPassword.toString(),
        "phone": phone.toString(),
      };
      final Response = await ApiCalling.CreateGet(AppUrl.Createuser, data);
      if (Response['success'] == true &&
          Response['message'] == "User already exists.") {
        return false;
      } else if (Response['success'] == true &&
          Response['message'] == "Sign up successfully.") {
        Map Data = Response['data'];
        Constants_Usermast.Createuserid = Data['_id'];
        // Constants_Usermast.Createroleid=Response['roleId'];
        return true;
      } else {
        return false;
      }
    }
  }

  static Future CreateUser(Map data) async {
    final Response = await ApiCalling.CreateGet(AppUrl.Createuser, data);
    if (Response['success'] == true &&
        Response['message'] == "User already exists.") {
      return false;
    } else if (Response['success'] == true &&
        Response['message'] == "Sign up successfully.") {
      return true;
    }
  }

  static Future CompanySelect() async {
    Map data = {
      "name": "",
      "user_id": Constants_Usermast.Createuserid,
    };
    final Response = await ApiCalling.CreateGet(AppUrl.CompanySelect, data);
    Con_List.CompanySelect = Response['data'];
    return Con_List.CompanySelect;
  }

  static Future CompanyUpdate(Map data) async {
    final Response = await ApiCalling.CreateGet(AppUrl.CompanyUpdate, data);

  }

  static Future NewCompany(String name, String CountEmployee) async {
    Map data = {
      "name": name,
      "user_id": Constants_Usermast.Createuserid.toString(),
    };
    final Response = await ApiCalling.CreateGet(AppUrl.Companyinsert, data);

    Con_List.newComanydata = Response['data'];
    String newComanyId = Con_List.newComanydata['_id'].toString();
    String Userid = Con_List.newComanydata['user_id'].toString();
    NewCompanyRoleID(CountEmployee, newComanyId);
    Map Data = {
      "companyId": newComanyId,
      "userId": Userid,
      "mainPlan": "Monthly",
      "startDate": DateTime.now().toLocal().toString(),
      "endDate": DateTime.now().add(Duration(days: 7)).toLocal().toString(),
      "subPlan": "Free",
      "paymentId": "0",
      "totalDays": "7",
      "planAmount": "0",
    };
    Subscription_api.Subscription_insert(Data);
  }

  static Future NewCompanyRoleID(
      String CountEmployee, String newComanyId) async {
    Map data = {
      "companyId": newComanyId,
      "name": "ADMIN",
      "shortKey": "A",
      "isActive": "true"
    };
    final Response = await ApiCalling.CreateGet(AppUrl.InsertRole, data);
    Map MasterRole = Response['data'];
    String Roleid = MasterRole['_id'].toString();
    UserUpdateComid(newComanyId, CountEmployee, Roleid);
  }

  static UserUpdateComid(
      String Companyid, String CountEmployee, String role) async {
    Map data = {
      "id": Constants_Usermast.Createuserid,
      "company_id": Companyid,
      "employeeCount": CountEmployee,
      "roleId": role
    };
    final Response = await ApiCalling.CreateGet(AppUrl.Createuserupdate, data);
  }

  static EmployeeUpdateComid(String Companyid) async {
    Map data = {
      "id": Constants_Usermast.Createuserid,
      "company_id": Companyid,
    };
    final Response = await ApiCalling.CreateGet(AppUrl.Createuserupdate, data);
  }

  static Future roleMasterCheak(String Company) async {
    Map data = {
      "companyId": Company,
    };
    final Response = await ApiCalling.CreateGet(AppUrl.SelectRole, data);
    List<dynamic> RoleMaster = Response['data'];
    RoleMaster.forEach((element) {
      if (element['name'] == "USER") {
        userupdateRole(element['_id'].toString(), Company);
      }
    });

    if (RoleMaster.where((e) => e['name'] == 'USER').isEmpty) {
      insertRoll(Company);
    }
  }

  static Future insertRoll(String Company) async {
    Map data = {
      "companyId": Company,
      "name": "USER",
      "shortKey": "U",
      "isActive": true
    };
    final Response = await ApiCalling.CreateGet(AppUrl.InsertRole, data);
    Map NewRole = Response['data'];
    String Roleid = NewRole['_id'];
    userupdateRole(Roleid, Company);
  }

  static Future userupdateRole(String Role, String Company) async {
    Map data = {
      "id": Constants_Usermast.Createuserid,
      "roleId": Role,
      "company_id": Company
    };
    final Response = await ApiCalling.CreateGet(AppUrl.Createuserupdate, data);
  }

  static Future userupdate(Map data) async {
    final Response = await ApiCalling.CreateGet(AppUrl.Createuserupdate, data);

    if (Response['success'] == true) {
      return true;
    } else {
      return false;
    }
  }

  static Future userSelect() async {
    Map data = {
      "company_id": Constants_Usermast.companyId,
    };
    final Response = await ApiCalling.CreateGet(AppUrl.CreateuserSelect, data);
    Con_List.Users = Response['data'];

    return Con_List.Users;
  }

  static Future userupdateFaceid(List face) async {
    String face1 = face.join(",");
    Map data = {
      "id": "${Constants_Usermast.sId}",
      "faceId": face1,
    };
    final response = await ApiCalling.CreateGet(AppUrl.Createuserupdate, data);
  }

  static Future userupdateprofile(var face) async {
    Map data = {"id": "${Constants_Usermast.sId}", "": ""};
    final Response = await ApiCalling.CreateGet(AppUrl.Createuserupdate, data);
  }

  static Future PagepermissionApi() async {
    Map data = {
      "companyId": Constants_Usermast.companyId,
      "roleId": Constants_Usermast.roleid,
    };
    final Response = await ApiCalling.CreateGet(AppUrl.Pagepermission, data);
    if (Response.toString().isNotEmpty ||
        Response.Statuscode == 200 ||
        Response.toString().toLowerCase() != "null") {
      Con_List.Drawer = Response['data'];
      return Con_List.Drawer;
    }
  }

  static Future ForgotPassword({required String Email}) async {
    Map data = {"email": Email};
    final Response = await ApiCalling.CreateGet(AppUrl.ForgotPassword, data);
    if (Response['success'] = true) {
      return Response['data'];
    } else {
      return ['email does not exist'];
    }
  }
}
