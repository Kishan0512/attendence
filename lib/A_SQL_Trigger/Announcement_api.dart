import 'package:attendy/Modal/All_import.dart';

class Announcement_Api{
  static AnnouncementSelect() async {
    final Response = await ApiCalling.CreateGet( AppUrl.AnnouncementSelect, {
      "companyId":Constants_Usermast.companyId
    });
    if(Response['success'])
      {
        return Response['data'];
      }else{
      return [];
    }
  }
  static AnnouncementInser(Map data) async {

    final Response = await ApiCalling.CreateGet( AppUrl.AnnouncementInsert, data);

  }
  static AnnouncementUpdate(Map data) async {

    final Response = await ApiCalling.CreateGet(AppUrl.AnnouncementUpdate, data);


  }
  static AnnouncementDelete(Map data) async {
    final Response = await ApiCalling.CreateGet(AppUrl.AnnouncementDelete, data);

    if(Response['success']==true) {
      return true;
    }else{
      return false;
    }
  }
}