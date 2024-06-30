

import 'A_ApiUrl.dart';
import 'A_NetworkHelp.dart';
import 'Con_List.dart';
import 'Con_Usermast.dart';

class Holiday_api{
  static  Future<bool> Hodidayadd(Map data)async{
    final Response = await ApiCalling.CreateGet(AppUrl.HolidayInsert, data);

    if(Response['success']==true)
    {
      return true;
    }else{
      return false;
    }
  }
  static Future HolidaySelect()async{
    Map data = {
      "companyId": Constants_Usermast.companyId,
    };
    final Response = await ApiCalling.CreateGet(AppUrl.HolidaySelect, data);
    Con_List.HolidaysSelect=Response['data'];
    return Con_List.HolidaysSelect;
  }
  static Future HolidayDelete(String id)async{
    Map data = {
      "id": id,
    };
    final Response = await ApiCalling.CreateGet(AppUrl.HolidayDelete, data);
    if(Response!=null)
    {
      return true;
    }else{
      return false;
    }
  }
  static Future HolidayUpdate(Map Data)async{
    final Response = await ApiCalling.CreateGet(AppUrl.HolidayUpdate, Data);

    if(Response!=null)
    {
      return true;
    }else{
      return false;
    }
  }
}