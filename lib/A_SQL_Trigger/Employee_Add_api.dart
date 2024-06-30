import 'dart:developer';

import 'package:attendy/utils/Constant/LocalCustomWidgets.dart';
import 'package:flutter/material.dart';

import 'A_ApiUrl.dart';
import 'A_NetworkHelp.dart';
import 'Con_List.dart';
import 'Con_Usermast.dart';

class AllEmployee_api {
  static Future<bool> Employeeadd(Map data, BuildContext context) async {
    final Response = await ApiCalling.CreateGet(AppUrl.EmployeeAdd, data);

    if (Response['success'] == true) {
      userupdateemployeeId(Response['data']['_id']);
      return true;
    } else {
      return CustomWidgets.showToast(context, Response['message'], false);
    }
  }

  static Future userupdateemployeeId(String employeeId) async {
    Map data = {
      "id": Constants_Usermast.Createuserid,
      "employeeId": employeeId
    };
    final Response = await ApiCalling.CreateGet(AppUrl.Createuserupdate, data);
  }

  static Future EmployeeSelect() async {
    Map data = {
      "companyId": Constants_Usermast.companyId,
    };
    final Response = await ApiCalling.CreateGet(AppUrl.EmployeeSelect, data);
    Con_List.AllEmployee = Response['data'];
    List<dynamic> Emp = Response['data'];
    Con_List.AllEmployee = Constants_Usermast.roleName == "USER"
        ? Emp.where((e) =>
                e['_id'].toString() == Constants_Usermast.employeeId.toString())
            .toList()
        : Emp;
    return Con_List.AllEmployee;
  }
  static Future EmployeeSelectForNotifi( {String? id} ) async {
    Map data = {
      "companyId": id,
    };
    final Response = await ApiCalling.CreateGet(AppUrl.EmployeeSelect, data);
    Con_List.AllEmployee = Response['data'];
    return Con_List.AllEmployee;
  }
  static Future EmployeeDelete(String id) async {
    Map data = {
      "id": id,
    };
    final Response = await ApiCalling.CreateGet(AppUrl.EmployeeDelete, data);
    if (Response['success'] == true) {
      return true;
    } else {
      return false;
    }
  }

  static Future EmployeeUpdate(Map data, BuildContext context) async {
    final Response = await ApiCalling.CreateGet(AppUrl.EmployeeUpdate, data);
    if (Response['success'] == true) {
      return true;
    } else {
      return CustomWidgets.showToast(context, Response['message'], false);
    }
  }
}
