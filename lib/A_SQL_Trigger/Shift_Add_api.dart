import 'dart:convert';

import 'A_ApiUrl.dart';
import 'A_NetworkHelp.dart';
import 'Con_Usermast.dart';
import 'package:http/http.dart' as http;

class Shift_Add_api{
  static Future<bool> shift_insert(Map data)async{
    try{
      final Response = await ApiCalling.CreateGet(AppUrl.shift_Insert, data);
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
  static Future shift_Select()async{
    Map data = {
      "companyId": Constants_Usermast.companyId,
    };
    final Response = await ApiCalling.CreateGet(AppUrl.shift_Select, data);
    return Response['data'];
  }
  static Future shift_Delete(String id)async{
    Map data = {
      "id": id,
    };
    final Response = await ApiCalling.CreateGet(AppUrl.shift_Delete, data);
    if(Response!=null)
    {
      return true;
    }else{
      return false;
    }
  }
  static Future shift_Update(Map data)async{

    final Response = await ApiCalling.CreateGet(AppUrl.shift_Update, data);
    if(Response['success']==true)
    {
      return true;
    }else{
      return false;
    }
  }
  static Future Get_bank() async {
    final res = await http.post(Uri.parse(AppUrl.GetAllBank));

    if(res.statusCode==200)
      {
        return jsonDecode(res.body)['ulip']['results'];
      }else
        {
          return [];
        }

  }
  static Future StateBank(String bank) async {
    final res = await http.post(Uri.parse("https://mfapps.indiatimes.com/ET_Calculators/statesByBank.htm?bankname=$bank"));

    if(res.statusCode==200)
      {
        return jsonDecode(res.body)['stateList'];
      }
    else{
      return [];
    }
  }
  static Future DistrictBank(String bank,String Statebank) async {
    final res = await http.post(Uri.parse("https://mfapps.indiatimes.com/ET_Calculators/getDistrictByBankAndState.htm?bankname=$bank&statename=$Statebank"));

    if(res.statusCode==200)
    {
      return jsonDecode(res.body)['districtList'];
    }
    else{
      return [];
    }
  }
  static Future BankBaranches(String bank,String Statebank,String Districte) async {
    final res = await http.post(Uri.parse("https://mfapps.indiatimes.com/ET_Calculators/branchList.htm?bankname=$bank&statename=$Statebank&districtname=$Districte"));

    if(res.statusCode==200)
    {
      return jsonDecode(res.body)['branchList'];
    }
    else{
      return [];
    }
  }
}