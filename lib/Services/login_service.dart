import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get_connect/connect.dart';

import '../Models/user_model.dart';
import '../Utils/Sqflite/db_helper.dart';
import '../Utils/Sqflite/db_table.dart';
import '../Utils/constants.dart';
import '../Utils/snack_bar.dart';

class LoginService extends GetConnect {
  DBHelper dbHelper = DBHelper();

  // Fetch Data
  Future<List<dynamic>> loginService(Map data) async {
    debugPrint('${AppConstants.AUTHENTICATION_URL}/authentification');
    debugPrint('login : ${json.encode(data)}');
    try {
      var response = await http.post(
          Uri.parse('${AppConstants.AUTHENTICATION_URL}/authentification'),
          body: json.encode(data),
          headers: {'Content-Type': 'application/json'});
      //print('response ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        var result = await jsonDecode(response.body);
        debugPrint('result ${result['auth']}');
        return result['auth'];
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error('service : ${exception.toString()}');
    }
  }
  //second method
  /*Future<Response> postData(dynamic body) async{
    try
    {
      Response response = await post(
          AppConstants.LOGIN_URL,
          body,
          headers: {
            'Content-Type':' application/json'
          }
      );
      print('response ${jsonDecode(response.body)}');
      if (response.status.hasError) {
        return Future.error(response.statusText.toString());
      }
      else {
        print('data saved');
        return response;
      }
    }
    catch(exception)
    {
      return Future.error(exception.toString());
    }
  }
  */

  //begin licence
  Future<dynamic> beginLicenceService(Map data) async {
    debugPrint('${AppConstants.AUTHENTICATION_URL}/beginLicense');
    debugPrint('data begin licence : ${json.encode(data)}');
    try {
      var response = await http.post(
          Uri.parse('${AppConstants.AUTHENTICATION_URL}/beginLicense'),
          body: json.encode(data),
          headers: {'Content-Type': 'application/json'});
      //print('response ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error('service : ${exception.toString()}');
    }
  }

  //end licence
  Future<dynamic> isLicenceEndService(Map data) async {
    debugPrint('${AppConstants.AUTHENTICATION_URL}/isLicenceEnd');
    debugPrint('data is licence end : ${json.encode(data)}');
    try {
      var response = await http.post(
          Uri.parse('${AppConstants.AUTHENTICATION_URL}/isLicenceEnd'),
          body: json.encode(data),
          headers: {'Content-Type': 'application/json'});
      //print('response ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error('service : ${exception.toString()}');
    }
  }

  //save device name and matricule in table autorisation
  Future<dynamic> insertAutorisationService(Map data) async {
    debugPrint('${AppConstants.AUTHENTICATION_URL}/insertAutorisation');
    debugPrint('data autorisation : ${json.encode(data)}');
    try {
      var response = await http.post(
          Uri.parse('${AppConstants.AUTHENTICATION_URL}/insertAutorisation'),
          body: json.encode(data),
          headers: {'Content-Type': 'application/json'});
      //print('response ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error('service : ${exception.toString()}');
    }
  }

  //check permission of user by matricule
  Future<dynamic> checkPermissionService(Map data) async {
    debugPrint('${AppConstants.AUTHENTICATION_URL}/checkPermission');
    debugPrint('data check permission : ${json.encode(data)}');
    try {
      var response = await http.post(
          Uri.parse('${AppConstants.AUTHENTICATION_URL}/checkPermission'),
          body: json.encode(data),
          headers: {'Content-Type': 'application/json'});
      //print('response ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else if (response.statusCode == 204) {
        ShowSnackBar.snackBar(
            "Check Permission", 'Your Matricule not exist', Colors.green);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error('service : ${exception.toString()}');
    }
  }

  //begin licence
  Future<dynamic> LicenceDeviceByLicenceId(deviceId) async {
    debugPrint(
        '${AppConstants.AUTHENTICATION_URL}/licenceDevice?deviceId=$deviceId');
    try {
      var response = await http.get(
          Uri.parse(
              '${AppConstants.AUTHENTICATION_URL}/licenceDevice?deviceId=$deviceId'),
          headers: {'Content-Type': 'application/json'});
      //print('response ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else if (response.statusCode == 204) {
        ShowSnackBar.snackBar(
            "Licence Device", 'Licence not exist', Colors.green);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error('service : ${exception.toString()}');
    }
  }

  //db local
  readUser() async {
    return await dbHelper.readUser(DBTable.user);
  }

  saveUser(UserModel model) async {
    return await dbHelper.insertUser(DBTable.user, model.dataMap());
  }

  deleteTableUser() async {
    await dbHelper.deleteTableUser();
    print('delete table user');
  }
}
