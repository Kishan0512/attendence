import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class ApiCalling {
  static createPost(String url, String header, var body) async {
    try {
      return http.post(Uri.parse(url), headers: header != null
              ? {HttpHeaders.authorizationHeader: header}
              : null, body: jsonEncode(body)).then((http.Response response) {
        final int statusCode = response.statusCode;
        return response;
      });
    } catch (e) {
      print("ApiCalling.createPost Error ==> $e");
    }
  }
  static CreateGet(String url, Map body) async {
    try {
      return await http.post(Uri.parse(url), body: body).then((
          http.Response response) {
        int statusCode = response.statusCode;

        if (statusCode < 200 || statusCode > 400 || json == null) {
          return null;
        } else {
          final responseObject = jsonDecode(response.body);
          return responseObject;
        }
      });
    }catch(e){
      print("ApieroreCcreatGet $e");
    }

  }

  static getdata(String url, String header) async {
    final res = await http.get(Uri.parse(url), headers: {"Authorization": "Bearer " + header});
    final responseObject = jsonDecode(res.body);
    return responseObject;
  }
}
