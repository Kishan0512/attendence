import 'A_ApiUrl.dart';
import 'A_NetworkHelp.dart';
import 'Con_List.dart';
import 'Con_Usermast.dart';

class Role_api{
  static Future<bool> Roleinsert(Map data)async{
    try{
      final Response = await ApiCalling.CreateGet(AppUrl.RoleInsert, data);
      if(Response['success']==true)
      {
        return true;
      }else{
        return false;
      }
    }catch(e)
    {
      print('EroreinsertEmploye0e$e');
      return false;
    }
  }
  static Future RoleSelect()async{
    Map data = {
      "companyId": Constants_Usermast.companyId
    };
    final Response = await ApiCalling.CreateGet(AppUrl.RoleSelect, data);
    Con_List.RoleSelect=Response['data'];
    return Con_List.RoleSelect;
  }
  static Future RoleDelete(String id)async{
    Map data = {
      "id": id,
    };
    final Response = await ApiCalling.CreateGet(AppUrl.RoleDelete, data);
    if(Response!=null)
    {
      return true;
    }else{
      return false;
    }
  }
  static Future RoleUpdate(String id,String name,bool IsActive)async{
    Map data = {
      "id": id,
      "name":name,
      "isActive" : IsActive.toString(),
      "shortKey" : name.toUpperCase().substring(0,1)
    };
    final Response = await ApiCalling.CreateGet(AppUrl.RoleUpdate, data);
    if(Response!=null)
    {
      return true;
    }else{
      return false;
    }
  }
}