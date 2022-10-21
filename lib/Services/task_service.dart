import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../Utils/constants.dart';

class TaskService extends GetConnect {
  // Fetch Data
  Future<List<dynamic>> getTask() async {
    try {
      final response = await get(AppConstants.PATICIPANT_URL);
      if(response.statusCode == 200){
        return await response.body['fetchedParticipants'];
      }
      else {
        return Future.error(response.statusText.toString());
      }
      /*if (response.status.hasError) {
        return Future.error(response.statusText.toString());
      } else {
        return await response.body['fetchedParticipants'];
      } */
    }
    catch(exception)
    {
      return Future.error('service : ${exception.toString()}');
    }
  }

  //Save Data
  //first method
  Future<String> saveTask(Map data) async {
    try
    {
      final response = await post(
          AppConstants.PATICIPANT_URL,data);
      if (response.status.hasError) {
        return Future.error(response.statusText.toString());
      } else {

        print('data saved');
        //return  response.body['participant'];
        return response.body;
      }
    }
    catch(exception)
    {
      return Future.error(exception.toString());
    }
  }
  //second method
  Future<Response> postData(dynamic body) async{
    try
    {
    Response response = await post(
        AppConstants.PATICIPANT_URL,
        body,
        headers: {
          'Content-Type':' application/json'
        }
    );
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

  Future<Response> putTask(String? id, dynamic body) async{
    try
    {
      Response response = await put(
          '${AppConstants.PATICIPANT_URL}/${id}',
          body,
          headers: {
            'Content-Type':' application/json'
          }
      );
      if (response.status.hasError) {
        return Future.error(response.statusText.toString());
      }
      else {
        print('data updated');
        return response;
      }
    }
    catch(exception)
    {
      return Future.error(exception.toString());
    }
  }
  Future<Response> deleteTask(String id) async{
    try
    {
      Response response = await delete(
          '${AppConstants.PATICIPANT_URL}/${id}',
          headers: {
            'Content-Type':' application/json'
          }
      );
      if (response.status.hasError) {
        return Future.error(response.statusText.toString());
      }
      else {
        print('data updated');
        return response;
      }
    }
    catch(exception)
    {
      return Future.error(exception.toString());
    }
  }
}