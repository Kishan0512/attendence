
import 'A_ApiUrl.dart';
import 'A_NetworkHelp.dart';
import 'Con_List.dart';
import 'Con_Usermast.dart';

class Branch_api{

  static Future<bool> BranchInsert(Map data)async{

    try{
      final Response = await ApiCalling.CreateGet(AppUrl.BranchInsert, data);
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
  static Future BranchSelect()async{
    Map data = {
      "companyId": Constants_Usermast.companyId,
    };
    final Response = await ApiCalling.CreateGet(AppUrl.BranchSelect, data);
    Con_List.BranchSelect=Response['data'];
    return Con_List.BranchSelect;
  }
  static Future BranchDelete(String id)async{
    Map data = {
      "id": id,
    };
    final Response = await ApiCalling.CreateGet(AppUrl.BranchDelete, data);
    if(Response!=null)
    {
      return true;
    }else{
      return false;
    }
  }
  static Future BranchUpdate(String id,String name,bool isActive,String Address,String ContactNumber,String ord)async{
    Map data = {
      "id": id,
      "name" : name,
      "address" : Address,
      "ord" : ord.toString(),
      "number" : ContactNumber,
      "isActive" : isActive.toString()
    };
    final Response = await ApiCalling.CreateGet(AppUrl.BranchUpdate, data);
    if(Response!=null)
    {
      return true;
    }else{
      return false;
    }
  }
}