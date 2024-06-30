
import 'A_ApiUrl.dart';
import 'A_NetworkHelp.dart';
import 'Con_List.dart';
import 'Con_Usermast.dart';


class Pagepermission_api{

  static Future PagepermissionSelect(String Role)async{
    Map data = {
      "companyId": Constants_Usermast.companyId,
      "roleId" : Role
    };
    final Response = await ApiCalling.CreateGet(AppUrl.PagePermissionSelect, data);
    Con_List.Pagepermission=Response['data'];
    return Con_List.Pagepermission;
  }

  static Future PagepermissionUpdate(Map data)async{
    final Response = await ApiCalling.CreateGet(AppUrl.PagePermissionUpdate, data);
    if(Response!=null)
    {
      return true;
    }else{
      return false;
    }
  }

}