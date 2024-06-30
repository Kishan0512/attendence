import 'dart:developer';

import 'package:attendy/A_SQL_Trigger/Con_Usermast.dart';

import 'A_ApiUrl.dart';
import 'A_NetworkHelp.dart';
import 'Con_List.dart';

class Attendance_api{
  static Future AttendanceInsert(Map data)async{

    try{

      final Response = await ApiCalling.CreateGet(AppUrl.AttendyInsert, data);

      if(Response['success']==true)
        {
          return 200;
        }else{
        if(Response['message'].toString().contains("companyId"))
          {
            return "CompanyID";
          }else if(Response['message'].toString().contains("employeeId"))
            {
              return "EmployeeID";
            }else if(Response['message'].toString().contains("faceId"))
              {
                return "FaceID";
              }else{
          return "";
        }
      }
    }catch(e)
    {
      print('Attndance Insert erore$e');
      return false;
    }
  }
  static Future AttendanceSelect()async{
    try{
      Con_List.AllAttandance=[];
      Map data= {
        "companyId": Constants_Usermast.companyId
      };
      final Response = await ApiCalling.CreateGet(AppUrl.AttendySelect, data);

      Con_List.PresentAttandance = Response['data']['PresentList'];
      Con_List.EarlyOutAttandance = Response['data']['EarlyOutList'];
      Con_List.LatAttandance = Response['data']['LatInList'];
      Con_List.AbsentAttandance = Response['data']['AbsentList'];
      Con_List.PresentAttandance.forEach((element) {
        Con_List.AllAttandance.add(element);
      });
      Con_List.EarlyOutAttandance.forEach((element) {
        Con_List.AllAttandance.add(element);
      });
      Con_List.LatAttandance.forEach((element) {
        Con_List.AllAttandance.add(element);
      });
      return Con_List.AllAttandance;
    }catch(e)
    {
      print('Attndance Select erore$e');
      return false;

    }
  }
  static Future AttendancePresentSelect()async{
    try{
      Map data= {
        "companyId": Constants_Usermast.companyId,
        "key" : "Present"
      };
      final Response = await ApiCalling.CreateGet(AppUrl.AttendySelect, data);
      Con_List.PresentAttandance=Response['data'];
      return Con_List.PresentAttandance;
    }catch(e)
    {
      print('Attndance Select erore$e');
      return false;

    }
  }
  static Future AttendanceLatein()async{
    try{
      Map data= {
        "companyId": Constants_Usermast.companyId,
        "key" : "LatIn"
      };
      final Response = await ApiCalling.CreateGet(AppUrl.AttendySelect, data);
      Con_List.LatAttandance=Response['data'];
      return Con_List.LatAttandance;
    }catch(e)
    {
      print('Attndance Select erore$e');
      return false;

    }
  }
  static Future AttendanceEarltout()async{
    try{
      Map data= {
        "companyId": Constants_Usermast.companyId,
          "key" : "EarlyOut"
      };
      final Response = await ApiCalling.CreateGet(AppUrl.AttendySelect, data);
      Con_List.EarlyOutAttandance=Response['data'];
      return Con_List.EarlyOutAttandance;
    }catch(e)
    {
      print('Attndance Select erore$e');
      return false;

    }
  }
  static Future AttendanceAbsent()async{
    try{
      Map data= {
        "companyId": Constants_Usermast.companyId,
        "key" : "Absent"
      };
      final Response = await ApiCalling.CreateGet(AppUrl.AttendySelect, data);
      if(Response!=null){
        Con_List.AbsentAttandance=Response['data'];
        return Con_List.AbsentAttandance;
      }else{
        return Con_List.AbsentAttandance;
      }
    }catch(e)
    {
      print('Attndance Select erore$e');
      return false;

    }
  }
  static Future FilterApiSingalDate1(String SingalDate)async{
    try{
      Map data={
        "companyId":Constants_Usermast.companyId.toString(),
        "fromDate": SingalDate,
        "key":"MobileDate"
      };
      final Response = await ApiCalling.CreateGet(AppUrl.DateSelectAttendance, data);
      if(Response!=null){
        return Response['data'];
      }else{
        return null;
      }
    }catch(e)
    {
      print('Attndance FilterApi erore$e');
      return false;
    }
  }
  static Future FilterApiSingalDate(String SingalDate)async{
    try{
      Map data={
        "companyId":Constants_Usermast.companyId.toString(),
        "fromDate": SingalDate,
        // "toDate":"2023-06-25"
      };
      final Response = await ApiCalling.CreateGet(AppUrl.DateSelectAttendance, data);
      if(Response!=null){
        return Response['data'];
      }else{
        return null;
      }
    }catch(e)
    {
      print('Attndance FilterApi erore$e');
      return false;

    }
  }
  static Future FilterApiToDate(String FromDate,String ToDate)async{
    try{
      Map data={
        "companyId":Constants_Usermast.companyId.toString(),
        "fromDate": FromDate,
        "toDate": ToDate
      };
      final Response = await ApiCalling.CreateGet(AppUrl.DateSelectAttendance, data);
      if(Response!=null){
        return Response['data'];
      }else{
        return null;
      }
    }catch(e)
    {
      print('Attndance FilterApi erore$e');
      return false;

    }
  }
  static Future FilterApiSingalDateBirth(String SingalDate)async{
    try{
      Map data={
        "companyId":Constants_Usermast.companyId.toString(),
        "birthDate": SingalDate,
        // "toDate":"2023-06-25"
      };
      final Response = await ApiCalling.CreateGet(AppUrl.DateSelectBirthDate, data);
      if(Response!=null){
        return Response['data'];
      }else{
        return null;
      }
    }catch(e)
    {
      print('Attndance FilterApiBirthDate erore$e');
      return false;

    }
  }
  static Future FilterApiToDateBirth(String FromDate,String ToDate)async{
    try{
      Map data={
        "companyId":Constants_Usermast.companyId.toString(),
        "fromDate": FromDate,
        "toDate": ToDate
      };
      final Response = await ApiCalling.CreateGet(AppUrl.DateSelectBirthDate, data);
      if(Response!=null){
        return Response['data'];
      }else{
        return null;
      }
    }catch(e)
    {
      print('Attndance FilterApiBirthDate erore$e');
      return false;

    }
  }
  static Future FilterApiSingalDateAnny(String SingalDate)async{
    try{
      Map data={
        "companyId":Constants_Usermast.companyId.toString(),
        "anniversaryDate": SingalDate,
        // "toDate":"2023-06-25"
      };
      final Response = await ApiCalling.CreateGet(AppUrl.DateSelectAnniversaryDate, data);
      if(Response!=null){
        return Response['data'];
      }else{
        return null;
      }
    }catch(e)
    {
      print('Attndance FilterApiBirthDate erore$e');
      return false;

    }
  }
  static Future FilterApiToDateAnny(String FromDate,String ToDate)async{
    try{
      Map data={
        "companyId":Constants_Usermast.companyId.toString(),
        "fromDate": FromDate,
        "toDate": ToDate
      };
      final Response = await ApiCalling.CreateGet(AppUrl.DateSelectAnniversaryDate, data);
      if(Response!=null){
        return Response['data'];
      }else{
        return null;
      }
    }catch(e)
    {
      print('Attndance FilterApiBirthDate erore$e');
      return false;

    }
  }
  static Future StatisticsAttendence(String EmployeeID) async {
    try{
      Map data={
        "companyId":Constants_Usermast.companyId.toString(),
        "employeeId":EmployeeID
      };
      final Response = await ApiCalling.CreateGet(AppUrl.StatisticsAttendcnce, data);
      if(Response['success']==true){
        return Response['Statistics'];
      }else{
        return null;
      }
    }catch(e)
    {
      print('Attndance FilterApiBirthDate erore$e');
      return false;

    }
  }
  static Future AttendanceReport(String Date) async {
    try{
      Map data={
        "companyId":Constants_Usermast.companyId.toString(),
        "date":Date
      };
      final Response = await ApiCalling.CreateGet(AppUrl.AttendanceReport, data);
      if(Response['success']==true){
        return Response['data'];
      }else{
        return null;
      }
    }catch(e)
    {
      print('Attndance FilterApiBirthDate erore$e');
      return false;

    }
  }
  static AttendenceMonthlyReport({required String Month,required String Year}) async {
    try{
      Map data={
        "companyId":Constants_Usermast.companyId.toString(),
        "month":Month,
        "year":Year
      };
      final Response = await ApiCalling.CreateGet(AppUrl.AttendanceMonthlyReport, data);
      if(Response !=null){
        return Response['attendance'];
      }else{
        return null;
      }
    }catch(e)
    {
      print('Attendance Monthly Report error $e');
      return false;

    }

  }
}