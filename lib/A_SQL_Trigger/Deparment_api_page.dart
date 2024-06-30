

import 'package:attendy/A_SQL_Trigger/Con_List.dart';
import 'package:attendy/A_SQL_Trigger/Con_Usermast.dart';
import 'package:flutter/rendering.dart';
import 'A_ApiUrl.dart';
import 'A_NetworkHelp.dart';

class Deparmentapi{
  static Future Deparmentinsert(String name,String Ord,bool isActive)async{
    Map data = {
      "companyId": Constants_Usermast.companyId,
      "name" : name,
      "ord" : Ord.toString(),
      "isActive" : isActive.toString()
    };
    final Response = await ApiCalling.CreateGet(AppUrl.DeparmentInsert, data);
    if(Response!=null)
      {
        return true;
      }else{
      return false;
    }
  }
  static Future DeparmentSelect()async{
    Map data = {
      "companyId": Constants_Usermast.companyId,
    };
    final Response = await ApiCalling.CreateGet(AppUrl.DeparmentSelect, data);
      Con_List.DeparmenntSelect=Response['data'];
      return Con_List.DeparmenntSelect;
  }
   static Future DeparmentAttendanceSelect()async{
    Map data = {
      "companyId": Constants_Usermast.companyId,
    };
    final Response = await ApiCalling.CreateGet(AppUrl.DeparmentAttendanceSelect, data);
      Con_List.DeparmenntSelect=Response['departmentEmp'];
      return Con_List.DeparmenntSelect;
  }

  static Future DeparmentDelete(String id)async{
    Map data = {
      "id": id,
    };
    final Response = await ApiCalling.CreateGet(AppUrl.DeparmentDelete, data);
    if(Response!=null)
    {
      return true;
    }else{
      return false;
    }
  }
  static Future DeparmentUpdate(String id,String name,String ord,bool isActive)async{
    Map data = {
      "id": id,
      "name":name,
      "ord" : ord.toString(),
      "isActive":isActive.toString()
    };
    final Response = await ApiCalling.CreateGet(AppUrl.Deparmentupdate, data);
    if(Response!=null)
    {
      return true;
    }else{
      return false;
    }
  }
}