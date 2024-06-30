import 'dart:convert';

import 'A_ApiUrl.dart';
import 'A_NetworkHelp.dart';
import 'Con_List.dart';
import 'Con_Usermast.dart';
import 'package:http/http.dart' as http;

class Leave_api{
  static  Future<bool>  Leaveadd(Map data)async{
    final Response = await ApiCalling.CreateGet(AppUrl.Leaveinsert, data);
    if(Response['success']==true)
    {
      return true;
    }else{
      return false;
    }
  }
  static Future  LeaveSelect()async{
    Map data = {
      "companyId": Constants_Usermast.companyId,
    };
    final Response = await ApiCalling.CreateGet(AppUrl.LeaveSelect, data);
    Con_List.Leave=Response['data'];
    return Con_List.Leave;
  }
  static Future  LeaveDelete(String id)async{
    Map data = {
      "id": id,
      "Time":DateTime.now().toString()
    };
    final Response = await ApiCalling.CreateGet(AppUrl.LeaveDelete, data);
    if(Response!=null)
    {
      return true;
    }else{
      return false;
    }
  }
  static Future  LeaveUpdate(Map data)async{
    final Response = await http.post(Uri.parse(AppUrl.LeaveUpdate), body: data);
    print(Response.statusCode);
    print(Response.body);
    if(Response.statusCode==200);
    {

      Map Data = jsonDecode(Response.body);
      if(Data['success']==true)
      {
        return true;
      }else{
        return false;
      }
    }


  }
  static Future  LeaveNotification()async{
    Map data={
      "companyId":Constants_Usermast.companyId
    };
    final Response = await http.post(Uri.parse(AppUrl.LeaveNotification), body: data);
      int statusCode = Response.statusCode;
      if (statusCode!=200) {
        return [];
      } else {
        final responseObject = jsonDecode(Response.body);
        return responseObject['adminUserData']['leaveData'];
      }
  }
  static Future  LeaveNotification1(String Data)async{
    Map data = {
      "companyId": Data,
    };
    final Response = await ApiCalling.CreateGet(AppUrl.LeaveSelect, data);
    return Response['data'];
  }
}