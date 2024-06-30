import 'dart:convert';
import 'package:http/http.dart' as http;
import 'A_ApiUrl.dart';
import 'A_NetworkHelp.dart';
import 'Con_List.dart';
import 'Con_Usermast.dart';

class LoginActivity{

  static  Future<bool>  LoginActivityInsert(String Time,String System)async{
    Map data ={
      "userId" : Constants_Usermast.sId,
      "companyId": Constants_Usermast.companyId,
      "name" : Constants_Usermast.name,
      "ip" : "${Con_List.Location['ip'].toString()}",
      "loginTime" : Time,
      "contry" : "${Con_List.Location['country']}",
      "state" : "${Con_List.Location['region']}",
      "city" : "${Con_List.Location['city']}",
       "system" : System
    };

    final Response = await ApiCalling.CreateGet(AppUrl.LoginActivityInsert, data);
    if(Response['success']==true)
    {
      return true;
    }else{
      return false;
    }
  }
  static Future  LoginActivitySelect()async{
    Map data;
    if(Constants_Usermast.statuse=="ADMIN")
      {
         data = {
          "companyId": Constants_Usermast.companyId,
        };
      }else{
       data = {
        "companyId": Constants_Usermast.companyId,
        "userId": Constants_Usermast.sId,
      };
    }
    Con_List.ActivitiesSelect=[];
    final Response = await ApiCalling.CreateGet(AppUrl.LoginActivitySelect, data);
    List jsonList = Response['data'].map((item) => jsonEncode(item)).toList();
    final uniqueJsonList = jsonList.toSet().toList();
    Con_List.ActivitiesSelect = uniqueJsonList.map((item) => jsonDecode(item)).toList();
    return Con_List.ActivitiesSelect;
  }
  static Future getIPGeolocation() async {
    final response = await http.get(Uri.parse('https://ipinfo.io/json'));

    if (response.statusCode == 200) {
      Con_List.Location = json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to get IP geolocation');
    }
  }
}