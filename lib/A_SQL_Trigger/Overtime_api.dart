import 'A_ApiUrl.dart';
import 'A_NetworkHelp.dart';
import 'Con_List.dart';
import 'Con_Usermast.dart';

class Overtime_api{

  static  Future<bool>  Overtime_add(Map data)async{

    final Response = await ApiCalling.CreateGet(AppUrl.Overtime_add, data);

    if(Response['success']==true)
    {
      return true;
    }else{
      return false;
    }
  }
  static Future  Overtime_Select()async{
    Map data = {
      "companyId": Constants_Usermast.companyId,
    };
    final Response = await ApiCalling.CreateGet(AppUrl.Overtime_Select, data);
    Con_List.Leave=Response['data'];
    return Con_List.Leave;
  }
  static Future  Overtime_Delete(String id)async{
    Map data = {
      "id" : id,
    };
    final Response = await ApiCalling.CreateGet(AppUrl.Overtime_Delete, data);
    if(Response!=null)
    {
      return true;
    }else{
      return false;
    }
  }
  static  Future<bool>  Overtime_Update(Map data)async{

    final Response = await ApiCalling.CreateGet(AppUrl.Overtime_Update, data);
    if(Response['success']==true)
    {
      return true;
    }else{
      return false;
    }
  }

}