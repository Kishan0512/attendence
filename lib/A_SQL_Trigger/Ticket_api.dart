import 'A_ApiUrl.dart';
import 'A_NetworkHelp.dart';
import 'Con_List.dart';
import 'Con_Usermast.dart';

class Ticket_api{
  static Future<bool> Ticketinsert(Map data)async{
    try{
      final Response = await ApiCalling.CreateGet(AppUrl.TicketInsert, data);
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
  static Future TicketSelect()async{
    Map data = {
      "companyId": Constants_Usermast.companyId
    };
    final Response = await ApiCalling.CreateGet(AppUrl.TicketSelect, data);
    Con_List.TiccketSelect=Response['data'];
    return Con_List.TiccketSelect;
  }
  static Future TicketDelete(String id)async{
    Map data = {
      "id": id,
    };
    final Response = await ApiCalling.CreateGet(AppUrl.TicketDelete, data);
    if(Response!=null)
    {
      return true;
    }else{
      return false;
    }
  }
  static Future TicketUpdate(String id,String name,String Order,bool IsActive)async{
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