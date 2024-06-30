import 'A_ApiUrl.dart';
import 'A_NetworkHelp.dart';
import 'Con_List.dart';
import 'Con_Usermast.dart';

class Subscription_api{
  static Future<bool> Subscription_insert(Map data)async{
    try{
      final Response = await ApiCalling.CreateGet(AppUrl.Subscriptioninsert, data);
      if(Response['success']==true)
      {
        return true;
      }else{
        return false;
      }
    }catch(e)
    {
      print('$e');
      return false;
    }
  }
  static Future Subscription_select()async{
    Map data = {
      "companyId": Constants_Usermast.companyId,
      "userId" : "1"
    };
    final Response = await ApiCalling.CreateGet(AppUrl.Subscriptionselect, data);
    return Response['data'];
  }
}