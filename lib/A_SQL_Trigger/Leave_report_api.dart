import 'A_ApiUrl.dart';
import 'A_NetworkHelp.dart';
import 'Con_List.dart';
import 'Con_Usermast.dart';

class Leave_report_api{

  static  Future<bool>  Leave_report_add(Map data)async{

    final Response = await ApiCalling.CreateGet(AppUrl.Leave_report_insert, data);
    if(Response['success']==true)
    {
      return true;
    }else{
      return false;
    }
  }
  static Future  Leave_report_Select()async{
    Map data = {
      "companyId": Constants_Usermast.companyId,
    };
    final Response = await ApiCalling.CreateGet(AppUrl.Leave_report_Select, data);
    Con_List.All_Leave_report=Response['data'];
    return Con_List.All_Leave_report;
  }
  static Future  Leave_report_Delete(String id)async{
    Map data = {
      "id": id,
    };
    final Response = await ApiCalling.CreateGet(AppUrl.Leave_report_Delete, data);
    if(Response!=null)
    {
      return true;
    }else{
      return false;
    }
  }
  static Future  Leave_report_Update(Map data)async{
    final Response = await ApiCalling.CreateGet(AppUrl.Leave_report_Update, data);
    if(Response!=null)
    {
      return true;
    }else{
      return false;
    }
  }
}