import 'A_ApiUrl.dart';
import 'A_NetworkHelp.dart';
import 'Con_List.dart';
import 'Con_Usermast.dart';

class Shift_typee_api{
  static Future<bool> shift_typeeinsert(Map data)async{
    try{
      final Response = await ApiCalling.CreateGet(AppUrl.shift_typeeInsert, data);
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
  static Future shift_typeeSelect()async{
    Map data = {
      "companyId": Constants_Usermast.companyId
    };
    final Response = await ApiCalling.CreateGet(AppUrl.shift_typeeSelect, data);
    Con_List.shift_typeetSelect=Response['data'];
    return Con_List.shift_typeetSelect;
  }
  static Future shift_typeeDelete(String id)async{
    Map data = {
      "id": id,
    };
    final Response = await ApiCalling.CreateGet(AppUrl.shift_typeeDelete, data);
    if(Response!=null)
    {
      return true;
    }else{
      return false;
    }
  }
  static Future shift_typeeUpdate(String id,String name,String Order,bool IsActive)async{
    Map data = {
      "id": id,
      "name":name,
      "ord" : Order,
      "isActive" : IsActive.toString(),
    };
    final Response = await ApiCalling.CreateGet(AppUrl.shift_typeeUpdate, data);
    if(Response!=null)
    {
      return true;
    }else{
      return false;
    }
  }
}