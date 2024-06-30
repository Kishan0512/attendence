import 'dart:convert';
import 'package:attendy/A_SQL_Trigger/Con_List.dart';
import 'package:attendy/A_SQL_Trigger/Notification_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Con_Usermast.dart';

class SrdPrefkey {
  static String status = "status";
  static String token = "token";
  static String login =  "Login";
  static String message = "message";
  static String name = "user_name";
  static String phone = "phone";
  static String companyId = "companyId";
  static String email = "email";
  static String createdAt = "createdAt";
  static String employeeCount = "employeeCount";
  static String isActive = "Active";
  static String otp = "otp";
  static String password = "password";
  static String sId = "sId";
  static String updatedAt = "updatedAt";
  static String joincompanyId = "joincompanyId";
  static String roleId ="roleId";
  static String faceId ="faceId";
  static String Profile ="Profile";
  static String employeeId ="employeeId";
  static String roleName ="roleName";
  static String Username = "Username";
  static String LoginPassword = "LoginPassword";
  static List<String> KeyClear = [
    status,
    token,
    login,
    message,
    name,
    phone,
    companyId,
    email,
    createdAt,
    employeeCount,
    isActive,
    otp,
    password,
    sId,
    sId,Profile,
    updatedAt,
    joincompanyId,
    roleId,
    faceId,
    employeeId,
    LoginPassword,
    roleId
  ];

}

class SharedPref {
  static read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString(key) == "null" ||
        prefs.getString(key) == "" ||
        prefs.getString(key) == "[]" ||
        prefs.getString(key) == null) {
      return "";
    }


    return json.decode(prefs.getString(key) ?? '');
  }

  static clear() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  static save_string(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, (value));
  }

  static read_string(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getString(key) ?? '');
  }


  static save_int(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  static read_int(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getInt(key) ?? 0);
  }

  static remove_key(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  static save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }


  static savelist(String key,List<dynamic> value) async {
    final List<String> jsonList = value.map((item) => jsonEncode(item)).toList();
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key, (jsonList));
  }

  static readlist(String key) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> Value = prefs.getStringList(key) ?? [];
    if (Value.isEmpty) {
      return Value;
    }
    return Value;
  }

  static Future<List> readlistDrawer(String key) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> jsonList = prefs.getStringList(key) ?? [];
    List<dynamic> list = jsonList.map((item) => jsonDecode(item)).toList();
    return list;
  }

  static read_bool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  static save_bool(String key,bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  static remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
  static SyncUserData() async {
    Constants_Usermast.Login = await SharedPref.read_bool(SrdPrefkey.login.toString()) ?? false;
      Constants_Usermast.token = await SharedPref.read_string(SrdPrefkey.token);
      Constants_Usermast.token = await SharedPref.read_string(SrdPrefkey.LoginPassword);
      Constants_Usermast.message = await SharedPref.read_string(SrdPrefkey.message);
      Constants_Usermast.name = await SharedPref.read_string(SrdPrefkey.name);
      Constants_Usermast.phone = await SharedPref.read_int(SrdPrefkey.phone);
      Constants_Usermast.companyId= await SharedPref.read_string(SrdPrefkey.companyId);
      Notification_Api.ComapnyID= await SharedPref.read_string(SrdPrefkey.companyId);
      Constants_Usermast.email = await SharedPref.read_string(SrdPrefkey.email);
      Constants_Usermast.createdAt = await SharedPref.read_string(SrdPrefkey.createdAt);
      Constants_Usermast.employeeCount = await SharedPref.read_string(SrdPrefkey.employeeCount);
      Constants_Usermast.isActive = await SharedPref.read_bool(SrdPrefkey.isActive.toString()) ?? false;
      Constants_Usermast.otp = await SharedPref.read_string(SrdPrefkey.otp);
      Constants_Usermast.otp = await SharedPref.read_string(SrdPrefkey.Profile);
      Constants_Usermast.password = await SharedPref.read_string(SrdPrefkey.password);
      Constants_Usermast.sId = await SharedPref.read_string(SrdPrefkey.sId);
      Constants_Usermast.updatedAt = await SharedPref.read_string(SrdPrefkey.updatedAt);
      Constants_Usermast.joincompanyId = await SharedPref.read_string(SrdPrefkey.joincompanyId);
      Constants_Usermast.roleid = await SharedPref.read_string(SrdPrefkey.roleId);
      Constants_Usermast.FaceID = await SharedPref.read_string(SrdPrefkey.faceId.toString());
      Constants_Usermast.employeeId = await SharedPref.read_string(SrdPrefkey.employeeId.toString());
      Constants_Usermast.roleName = await SharedPref.read_string(SrdPrefkey.roleName.toString());
    }

}
