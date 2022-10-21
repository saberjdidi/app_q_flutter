import 'dart:convert';
import 'package:flutter/cupertino.dart';

import '../../Utils/constants.dart';
import 'package:http/http.dart' as http;

class ReunionService {
  // Fetch Data
  Future<List<dynamic>> getReunion(matricule) async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.REUNION_URL}/getListeReunion?mat=$matricule'),
          headers: {
            'Content-Type':'application/json'
          }
      );
      //print(AppConstants.ACTION_URL);
      //print('response ${jsonDecode(response.body)}');
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

  Future<dynamic> saveReunion(Map data) async{
    try
    {
      print('data : ${json.encode(data)}');
      //print(Uri.parse('${AppConstants.REUNION_URL}/addPNC'));
      var response = await http.post(
          Uri.parse('${AppConstants.REUNION_URL}/add_reunion'),
          body: json.encode(data),
          headers: {
            'Content-Type':'application/json'
          }
      );
      //print(AppConstants.ACTION_URL);
      print('response ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      }
      else {
        return Future.error(response.statusCode.toString());
      }
    }
    catch(exception)
    {
      return Future.error(exception.toString());
    }
  }
  ///type reunion
  Future<List<dynamic>> getTypeReunion() async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.REUNION_URL}/listTypeReunion'),
          headers: {
            'Content-Type':'application/json'
          }
      );
      //print('response ${jsonDecode(response.body)}');
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
  //get participant
  Future<List<dynamic>> getParticipant(nReunion) async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.REUNION_URL}/ListeParticipationByReunion?NReunion=$nReunion'),
          headers: {
            'Content-Type':'application/json'
          }
      );
      //print(AppConstants.ACTION_URL);
      //print('response ${jsonDecode(response.body)}');
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
  Future<List<dynamic>> getParticipationByReunionAndLangue(nReunion, lang) async {
    try {
      debugPrint('${AppConstants.REUNION_URL}/listParticipation?numReunion=$nReunion&lang=$lang');
      var response = await http.get(
          Uri.parse('${AppConstants.REUNION_URL}/listParticipation?numReunion=$nReunion&lang=$lang'),
          headers: {
            'Content-Type':'application/json'
          }
      );
      //print(AppConstants.ACTION_URL);
      //print('response ${jsonDecode(response.body)}');
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
  Future<List<dynamic>> getParticipantsARattacher(nReunion, numPage) async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.REUNION_URL}/listParticipantsReunionARattacher?nReunion=$nReunion&numPage=$numPage'),
          headers: {
            'Content-Type':'application/json'
          }
      );
      //print(AppConstants.ACTION_URL);
      //print('response ${jsonDecode(response.body)}');
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
  //add participant
  Future<dynamic> addParticipant(Map data) async{
    try
    {
      print('data : ${json.encode(data)}');
      var response = await http.post(
          Uri.parse('${AppConstants.REUNION_URL}/addParticipant'),
          body: json.encode(data),
          headers: {
            'Content-Type':'application/json'
          }
      );
      //print(AppConstants.ACTION_URL);
      print('response ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      }
      else {
        return Future.error(response.statusCode.toString());
      }
    }
    catch(exception)
    {
      return Future.error(exception.toString());
    }
  }
  Future<dynamic> addParticipantExterne(Map data) async{
    try
    {
      print('data : ${json.encode(data)}');
      print(Uri.parse('${AppConstants.REUNION_URL}/addParticipantExterene'));
      var response = await http.post(
          Uri.parse('${AppConstants.REUNION_URL}/addParticipantExterene'),
          body: json.encode(data),
          headers: {
            'Content-Type':'application/json'
          }
      );
      //print(AppConstants.ACTION_URL);
      print('response ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      }
      else {
        return Future.error(response.statusCode.toString());
      }
    }
    catch(exception)
    {
      return Future.error(exception.toString());
    }
  }
  //delete participant
  Future<dynamic> deleteParticipantById(nReunion, mat, intExt, id) async {
    try {
      print('${AppConstants.REUNION_URL}/deleteParticipant?numReunion=$nReunion&mat=$mat&int_ext=$intExt&id=$id');
      var response = await http.delete(
          Uri.parse('${AppConstants.REUNION_URL}/deleteParticipant?numReunion=$nReunion&mat=$mat&int_ext=$intExt&id=$id'),
          headers: {
            'Content-Type':'application/json'
          }
      );
      print('response : ${jsonDecode(response.body)}');
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
  ///Agenda
  ///Reunion informer
  Future<List<dynamic>> getReunionInformer(matricule) async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.REUNION_URL}/listReunionInfo?mat=$matricule'),
          headers: {
            'Content-Type':'application/json'
          }
      );
      //print(AppConstants.ACTION_URL);
      //print('response ${jsonDecode(response.body)}');
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
  Future<dynamic> validerReunionInfo(Map data) async{
    try
    {
      print('data : ${json.encode(data)}');
      //print(Uri.parse('${AppConstants.REUNION_URL}/validerReunionInfo'));
      var response = await http.post(
          Uri.parse('${AppConstants.REUNION_URL}/validerReunionInfo'),
          body: json.encode(data),
          headers: {
            'Content-Type':'application/json'
          }
      );
      //print(AppConstants.ACTION_URL);
      print('response ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      }
      else {
        return Future.error(response.statusCode.toString());
      }
    }
    catch(exception)
    {
      return Future.error(exception.toString());
    }
  }
  ///Reunion planifier
  Future<List<dynamic>> getReunionPlanifier(matricule) async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.REUNION_URL}/getPlanifiedReunion?mat=$matricule'),
          headers: {
            'Content-Type':'application/json'
          }
      );
      //print(AppConstants.ACTION_URL);
      //print('response ${jsonDecode(response.body)}');
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
  Future<dynamic> validerReunionPlanifier(Map data) async{
    try
    {
      print('data : ${json.encode(data)}');
      print(Uri.parse('${AppConstants.REUNION_URL}/confirmPresence'));
      var response = await http.post(
          Uri.parse('${AppConstants.REUNION_URL}/confirmPresence'),
          body: json.encode(data),
          headers: {
            'Content-Type':'application/json'
          }
      );
      //print(AppConstants.ACTION_URL);
      print('response ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      }
      else {
        return Future.error(response.statusCode.toString());
      }
    }
    catch(exception)
    {
      return Future.error(exception.toString());
    }
  }
}