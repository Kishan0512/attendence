
import 'package:flutter/material.dart';

class Con_List{
  static ValueNotifier<bool> Active = ValueNotifier(false);
  static ValueNotifier<bool> Pass = ValueNotifier(false);
  static ValueNotifier<bool> Server = ValueNotifier(false);
  static ValueNotifier<String> Admin = ValueNotifier("");
  static ValueNotifier<List> AllNotification = ValueNotifier([]);
  static List<dynamic> CompanySelect=[];
  static List<dynamic> Drawer=[];
  static List<dynamic> Users=[];
  static List<dynamic> DeparmenntSelect=[];
  static List<dynamic> AllAttandance=[];
  static List<dynamic> PresentAttandance=[];
  static List<dynamic> LatAttandance=[];
  static List<dynamic> AbsentAttandance=[];
  static List<dynamic> EarlyOutAttandance=[];
  static List<dynamic> HolidaysSelect=[];
  static List<dynamic> EmployeeSalary=[];
  static List<dynamic> ActivitiesSelect=[];
  static Map Location={};
  static List<dynamic> BranchSelect=[];
  static List<dynamic> DesignationSelect=[];
  static List<dynamic> AllDesignation=[];
  static List<dynamic> Pagepermission=[];
  static List<dynamic> RoleSelect=[];
  static List<dynamic> shift_typeetSelect=[];
  static List<dynamic> Notification=[];
  static List<dynamic> priority=[];
  static List<dynamic> Allshift_Select=[];
  static List<dynamic> AllOvertime=[];
  static List<dynamic> All_Leave_report=[];
  static List<dynamic> LeaveType=[];
  static List<dynamic> Leave=[];
  static List<dynamic> AllEmployee=[];
  static List<dynamic> TiccketSelect=[];
  static List<dynamic> Policies=[];
  static Map newComanydata={};
  static Map newComanyrole={};
  static List<Map<String, dynamic>> Attandance=[];

}

