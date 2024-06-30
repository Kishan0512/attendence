import 'package:attendy/Modal/All_import.dart';

class Resignation_Api {
  static ResignationInser(Map data) async {

    final Response = await ApiCalling.CreateGet(AppUrl.ResignationInsert, data);

    if(Response['success'] == true)
      {
        return true;
      }else{
      return false;
    }

  }
  static ResiganationSelect() async {
    final Response = await ApiCalling.CreateGet(AppUrl.ResignationSelect, {  "companyId":Constants_Usermast.companyId});

    if(Response['success'] == true)
    {
      return Response['data'];
    }else{
      return [];
    }
  }
  static ResignationDelete(Map data) async {
    final Response = await ApiCalling.CreateGet(AppUrl.ResignationDelete, data);
    if(Response['success'] == true)
      {
        return true;
      }else{
      return false;
    }

  }
  static ResignationUpdate(Map data) async {
    final Response = await ApiCalling.CreateGet(AppUrl.ResignationUpdate, data);
    if(Response['success'] == true)
      {
        return true;
      }else{
      return false;
    }

  }
}