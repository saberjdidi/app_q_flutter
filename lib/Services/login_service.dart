import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get_connect/connect.dart';

import '../Models/user_model.dart';
import '../Utils/Sqflite/db_helper.dart';
import '../Utils/Sqflite/db_table.dart';
import '../Utils/constants.dart';

class LoginService extends GetConnect {

  DBHelper dbHelper = DBHelper();

  // Fetch Data
  Future<List<dynamic>> loginService(Map data) async {
    print('login : ${json.encode(data)}');
    try {
      var response = await http.post(
          Uri.parse(AppConstants.LOGIN_URL),
          body: json.encode(data),
          headers: {
            'Content-Type': ' application/json'
          }
      );
      print(AppConstants.LOGIN_URL);
      //print('response ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        var result =  await jsonDecode(response.body);
        print('result ${result['auth']}');
        return result['auth'];
      }
      else {
        return Future.error(response.statusCode.toString());
      }
    }
    catch (exception) {
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