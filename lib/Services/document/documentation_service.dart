import 'dart:convert';
import '../../Utils/constants.dart';
import 'package:http/http.dart' as http;

class DocumentationService {
  // Fetch Data
  Future<List<dynamic>> getDocument(matricule) async {
    try {
      print(Uri.parse('${AppConstants.DOCUMENTATION_URL}/getListeDocument?mat=$matricule'));
      var response = await http.get(
          Uri.parse('${AppConstants.DOCUMENTATION_URL}/getListeDocument?mat=$matricule'),
          /*headers: {
            'Content-Type':'application/json'
          } */
      );
      //print(AppConstants.ACTION_URL);
     // print('response documentation : ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      }
      else {
        return Future.error(response.statusCode.toString());
      }
    }
    catch (exception) {
      return Future.error('service : ${exception.toString()}');
    }
  }
  //search document
  Future<List<dynamic>> searchDocument(matricule, code, libelle, type) async {
    try {
      print(Uri.parse('${AppConstants.DOCUMENTATION_URL}/getListeDocument?mat=$matricule&Code=$code&Libelle=$libelle&type=$type'));
      var response = await http.get(
          Uri.parse('${AppConstants.DOCUMENTATION_URL}/getListeDocument?mat=$matricule&Code=$code&Libelle=$libelle&type=$type'),
         /*
          headers: {
            'Content-Type':'application/json'
          } */
      );
      //print(AppConstants.ACTION_URL);
      // print('response documentation : ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      }
      else {
        return Future.error(response.statusCode.toString());
      }
    }
    catch (exception) {
      return Future.error('service : ${exception.toString()}');
    }
  }
  //type document
  Future<List<dynamic>> getTypeDocument() async {
    try {
      var response = await http.get(
        Uri.parse('${AppConstants.DOCUMENTATION_URL}/TypeDocument'),
        /*headers: {
            'Content-Type':'application/json'
          } */
      );
      //print(AppConstants.ACTION_URL);
      // print('response documentation : ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      }
      else {
        return Future.error(response.statusCode.toString());
      }
    }
    catch (exception) {
      return Future.error('service : ${exception.toString()}');
    }
  }

}