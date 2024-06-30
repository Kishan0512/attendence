import 'A_ApiUrl.dart';
import 'A_NetworkHelp.dart';
import 'Con_List.dart';
import 'Con_Usermast.dart';

class Leave_Type_api{

  static  Future<bool>  Leave_Typeadd(String name,String ord,bool isActive)async{
    Map data ={
      "companyId": Constants_Usermast.companyId,
      "name" : name,
      "ord" : ord,
      "isActive" : isActive.toString()
    };
    final Response = await ApiCalling.CreateGet(AppUrl.LeaveTypeinsert, data);
    if(Response['success']==true)
    {
      return true;
    }else{
      return false;
    }
  }
  static Future  Leave_TypeSelect()async{
    Map data = {
      "companyId": Constants_Usermast.companyId,
    };
    final Response = await ApiCalling.CreateGet(AppUrl.LeaveTypeSelect, data);
    Con_List.LeaveType=Response['data'];
    return Con_List.LeaveType;
  }
  static Future  Leave_TypeDelete(String id)async{
    Map data = {
      "id": id,
    };
    final Response = await ApiCalling.CreateGet(AppUrl.LeaveTypeDelete, data);
    if(Response!=null)
    {
      return true;
    }else{
      return false;
    }
  }
  static Future  Leave_TypeUpdate(String id,String name,String ord,bool isActive)async{
    Map data = {
      "id": id,
      "name":name,
      "ord" : ord,
      "isActive":isActive.toString()
    };
    final Response = await ApiCalling.CreateGet(AppUrl.LeaveTypeUpdate, data);
    if(Response!=null)
    {
      return true;
    }else{
      return false;
    }
  }
}