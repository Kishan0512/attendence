
import 'package:shared_preferences/shared_preferences.dart';
import '../Modal/All_import.dart';
import '../view/Dashboard/Dashboard.dart';

int Counting = 0;
class Notification_Api {
  static List<dynamic> get = [];
  static String ComapnyID = "";

  static NotificationSelect(String id) async {
    if (id == "true") {
      ComapnyID = "";
    }else{

    if (ComapnyID.isNotEmpty) {
      String EmployeeID =
          await SharedPref.read_string(SrdPrefkey.employeeId) ?? "";
      Map data = {"companyId": ComapnyID};
      final Response =
          await ApiCalling.CreateGet(AppUrl.NotificationSelect, data);
      Con_List.Notification = Response['data'];

      var temp =
          await AllEmployee_api.EmployeeSelectForNotifi(id: ComapnyID);
      List<dynamic> employe = temp
          .where((e) => e['_id'].toString() == EmployeeID.toString())
          .toList();
      Counting = Con_List.Notification.where((element) =>
          // element['EmployeeId'].toString() == temp['_id'] &&
          employe[0]['notification_read_time'].toString() != " "
              ? (DateTime.parse(element['createdAt'].toString())
                  .toLocal()
                  .isAfter(DateTime.parse(
                          employe[0]['notification_read_time'].toString())
                      .toLocal()))
              : true).toList().length;

      if (get.toString() == Con_List.Notification.toString()) {
        Con_List.Notification = [];
      } else {
        get = Con_List.Notification;
      }
      return Con_List.Notification;
    } else {


      final prefs = await SharedPreferences.getInstance();
       ComapnyID = prefs.getString('companyId') ?? "";

      return [];
    }}}


  static NotificationSelect1({String? id}) async {
    Map data = {"companyId": Constants_Usermast.companyId};
    final Response =
        await ApiCalling.CreateGet(AppUrl.NotificationSelect, data);
    Con_List.Notification = Response['data'];
    return Con_List.Notification;
  }

  static NotificationInsert(Map data) async {
    try {
      final Response =
          await ApiCalling.CreateGet(AppUrl.NotificationInsert, data);
      if (Response['success'] == true) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Attndance Select erore$e');
      return false;
    }
  }
}
