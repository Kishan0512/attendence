
import 'A_ApiUrl.dart';
import 'A_NetworkHelp.dart';
import 'Con_List.dart';
import 'Con_Usermast.dart';

class Designations_api{

  static Future<bool> DesignationsInsert(Map data)async{
    try{
      final Response = await ApiCalling.CreateGet(AppUrl.DesignationInsert, data);

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
  static Future DesignationsSelect(String DeparmentId)async{
    Map data = {
      "companyId": Constants_Usermast.companyId,
      // "deparmentId" : DeparmentId
    };
    final Response = await ApiCalling.CreateGet(AppUrl.DesignationSelect, data);


    Con_List.DesignationSelect=Response['data'];
    return Con_List.DesignationSelect;
  }
  static Future DesignationsDelete(String id)async{
    Map data = {
      "id": id,
    };
    final Response = await ApiCalling.CreateGet(AppUrl.DesignationDelete, data);
    if(Response!=null)
    {
      return true;
    }else{
      return false;
    }
  }
  static Future DesignationsUpdate(String Deparment,String id,String name,String Ord,bool isActive)async{
    Map data = {
      "id": id,
      "deparmentId" : Deparment,
      "name":name,
      "ord" : Ord,
      "isActive":isActive.toString()
    };
    final Response = await ApiCalling.CreateGet(AppUrl.DesignationUpdate, data);
    if(Response!=null)
    {
      return true;
    }else{
      return false;
    }
  }
}