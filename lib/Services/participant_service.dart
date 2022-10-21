import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../Utils/constants.dart';

class ParticipantService extends GetConnect implements GetxService {
  var client = http.Client();
  var remoteUrl = AppConstants.PATICIPANT_URL;

  //1st method
  Future<dynamic> getParticipantService() async {
    var response = await client.get(
        Uri.parse(
            '$remoteUrl'
        )
    );
    return response;
  }
  //second method
  Future<Response> getData(String uri) async{
    if(kDebugMode){
      print(AppConstants.PATICIPANT_URL);
    }
    Response response = await get(
        uri,
        headers: {
          'Content-Type':' application/json; charset=UTF8'
        }
    );
    return response;
  }

  Future<Response> postData(String uri, dynamic body) async{
    Response response = await post(
        uri,
        body,
        headers: {
          'Content-Type':' application/json'
        }
    );
    return response;
  }

  Future<Response> deleteData(String uri) async{
    Response response = await delete(
        uri,
        headers: {
          'Content-Type':' application/json'
        }
    );
    return response;
  }

}