import 'A_ApiUrl.dart';
import 'A_NetworkHelp.dart';
import 'Con_List.dart';
import 'Con_Usermast.dart';

class Policies_api{
  static  Future<bool> Policiesadd(Map data)async{
    final Response = await ApiCalling.CreateGet(AppUrl.PolicyInsert, data);
    if(Response['success'] == true)
    {
      return true;
    }else{
      return false;
    }
  }
  static Future PoliciesSelect()async{
    Map data = {
      "companyId": Constants_Usermast.companyId,
    };
    final Response = await ApiCalling.CreateGet(AppUrl.PolicySelect, data);
    Con_List.Policies=Response['data'];
    return Con_List.Policies;
  }
  static Future PoliciesDelete(String id)async{
    Map data = {
      "id": id,
    };
    final Response = await ApiCalling.CreateGet(AppUrl.PolicyDelete, data);
    if(Response['success']==true)
    {
      return true;
    }else{
      return false;
    }
  }
  static Future PoliciesUpdate(Map data)async{

    final Response = await ApiCalling.CreateGet(AppUrl.PolicyUpdate, data);
    if(Response['success']==true)
    {
      return true;
    }else{
      return false;
    }
  }
}