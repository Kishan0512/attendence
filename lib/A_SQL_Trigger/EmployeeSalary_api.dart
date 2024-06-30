import 'A_ApiUrl.dart';
import 'A_NetworkHelp.dart';
import 'Con_List.dart';
import 'Con_Usermast.dart';
class EmployeeSalary_api{
  static  Future<bool> EmployeeSalaryadd(Map data)async{
    final Response = await ApiCalling.CreateGet(AppUrl.EmployeeSalayAdd, data);
    if(Response['success']==true)
    {
      return true;
    }else{
      return false;
    }
  }
  static Future EmployeeSalarySelect()async{
    Map data = {
      "companyId": Constants_Usermast.companyId,
    };
    final Response = await ApiCalling.CreateGet(AppUrl.EmployeeSalarySelect, data);
    Con_List.EmployeeSalary=Response['data'];
    return Con_List.EmployeeSalary;
  }
  static Future EmployeeSalaryDelete(String id)async{
    Map data = {
      "id": id,
    };
    final Response = await ApiCalling.CreateGet(AppUrl.EmployeeSalaryDelete, data);
    if(Response['success']==true)
    {
      return true;
    }else{
      return false;
    }
  }
  static Future EmployeeSalaryUpdate(Map data)async{
    final Response = await ApiCalling.CreateGet(AppUrl.EmployeeSalaryUpdate, data);
    if(Response['success']==true)
    {
      return true;
    }else{
      return false;
    }
  }
}