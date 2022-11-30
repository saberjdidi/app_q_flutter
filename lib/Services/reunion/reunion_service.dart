import 'dart:convert';
import 'package:flutter/cupertino.dart';
import '../../Utils/constants.dart';
import 'package:http/http.dart' as http;

class ReunionService {
  // Fetch Data
  Future<List<dynamic>> getReunion(matricule) async {
    try {
      var response = await http.get(
          Uri.parse(
              '${AppConstants.REUNION_URL}/getListeReunion?mat=$matricule'),
          headers: {'Content-Type': 'application/json'});
      //print(AppConstants.ACTION_URL);
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

  Future<List<dynamic>> searchReunion(mat, nReunion, type, order) async {
    try {
      debugPrint(
          '${AppConstants.REUNION_URL}/getListeReunion?mat=$mat&numReunion=$nReunion&type=$type&ordreDuJour=$order');
      var response = await http.get(
          Uri.parse(
              '${AppConstants.REUNION_URL}/getListeReunion?mat=$mat&numReunion=$nReunion&type=$type&ordreDuJour=$order'),
          headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error('service : ${exception.toString()}');
    }
  }

  Future<dynamic> saveReunion(Map data) async {
    try {
      print('data : ${json.encode(data)}');
      //print(Uri.parse('${AppConstants.REUNION_URL}/addPNC'));
      var response = await http.post(
          Uri.parse('${AppConstants.REUNION_URL}/add_reunion'),
          body: json.encode(data),
          headers: {'Content-Type': 'application/json'});
      //print(AppConstants.ACTION_URL);
      print('response ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }

  ///type reunion
  Future<List<dynamic>> getTypeReunion() async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.REUNION_URL}/listTypeReunion'),
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

  Future<List<dynamic>> getTypeReunionByMatricule(mat, online) async {
    try {
      var response = await http.get(
          Uri.parse(
              '${AppConstants.REUNION_URL}/getTypeReunionByMatricule?mat=$mat&online=$online'),
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

  //get participant
  Future<List<dynamic>> getParticipant(nReunion) async {
    try {
      var response = await http.get(
          Uri.parse(
              '${AppConstants.REUNION_URL}/ListeParticipationByReunion?NReunion=$nReunion'),
          headers: {'Content-Type': 'application/json'});
      //print(AppConstants.ACTION_URL);
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

  Future<List<dynamic>> getParticipationByReunionAndLangue(
      nReunion, lang) async {
    try {
      debugPrint(
          '${AppConstants.REUNION_URL}/listParticipation?numReunion=$nReunion&lang=$lang');
      var response = await http.get(
          Uri.parse(
              '${AppConstants.REUNION_URL}/listParticipation?numReunion=$nReunion&lang=$lang'),
          headers: {'Content-Type': 'application/json'});
      //print(AppConstants.ACTION_URL);
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

  Future<List<dynamic>> getParticipantsARattacher(nReunion, numPage) async {
    try {
      var response = await http.get(
          Uri.parse(
              '${AppConstants.REUNION_URL}/listParticipantsReunionARattacher?nReunion=$nReunion&numPage=$numPage'),
          headers: {'Content-Type': 'application/json'});
      //print(AppConstants.ACTION_URL);
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

  //add participant
  Future<dynamic> addParticipant(Map data) async {
    try {
      print('data : ${json.encode(data)}');
      var response = await http.post(
          Uri.parse('${AppConstants.REUNION_URL}/addParticipant'),
          body: json.encode(data),
          headers: {'Content-Type': 'application/json'});
      //print(AppConstants.ACTION_URL);
      print('response ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }

  Future<dynamic> addParticipantExterne(Map data) async {
    try {
      print('data : ${json.encode(data)}');
      print(Uri.parse('${AppConstants.REUNION_URL}/addParticipantExterene'));
      var response = await http.post(
          Uri.parse('${AppConstants.REUNION_URL}/addParticipantExterene'),
          body: json.encode(data),
          headers: {'Content-Type': 'application/json'});
      //print(AppConstants.ACTION_URL);
      print('response ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }

  //delete participant
  Future<dynamic> deleteParticipantById(nReunion, mat, intExt, id) async {
    try {
      print(
          '${AppConstants.REUNION_URL}/deleteParticipant?numReunion=$nReunion&mat=$mat&int_ext=$intExt&id=$id');
      var response = await http.delete(
          Uri.parse(
              '${AppConstants.REUNION_URL}/deleteParticipant?numReunion=$nReunion&mat=$mat&int_ext=$intExt&id=$id'),
          headers: {'Content-Type': 'application/json'});
      print('response : ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error('service : ${exception.toString()}');
    }
  }

  //decision(action)
  Future<List<dynamic>> getActionReunionRattacher(nReunion) async {
    try {
      debugPrint(
          '${Uri.parse('${AppConstants.REUNION_URL}/listActionsOfReunionRattacher?nReunion=$nReunion')}');
      var response = await http.get(
          Uri.parse(
              '${AppConstants.REUNION_URL}/listActionsOfReunionRattacher?nReunion=$nReunion'),
          headers: {'Content-Type': 'application/json'});
      //print(AppConstants.ACTION_URL);
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

  Future<List<dynamic>> getActionReunionARattacher(
      nPage, numPage, nReunion, mat) async {
    try {
      var response = await http.get(
          Uri.parse(
              '${AppConstants.REUNION_URL}/listActionsOfReunionARattacher?nPage=$nPage&numPage=$numPage&nReunion=$nReunion&mat=$mat'),
          headers: {'Content-Type': 'application/json'});
      //print(AppConstants.ACTION_URL);
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

  Future<dynamic> addActionReunion(Map data) async {
    try {
      debugPrint('data : ${json.encode(data)}');
      debugPrint(
          '${Uri.parse('${AppConstants.REUNION_URL}/newActionReunion')}');
      var response = await http.post(
          Uri.parse('${AppConstants.REUNION_URL}/newActionReunion'),
          body: json.encode(data),
          headers: {'Content-Type': 'application/json'});
      //print(AppConstants.ACTION_URL);
      debugPrint('response ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }

  Future<dynamic> deleteActionReunion(nReunion, nAct) async {
    try {
      debugPrint(
          '${AppConstants.REUNION_URL}/deleteReunionAction?nReunion=$nReunion&nAct=$nAct');
      var response = await http.delete(
          Uri.parse(
              '${AppConstants.REUNION_URL}/deleteReunionAction?nReunion=$nReunion&nAct=$nAct'),
          headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error('service : ${exception.toString()}');
    }
  }

  ///Agenda
  ///Reunion informer
  Future<List<dynamic>> getReunionInformer(matricule) async {
    try {
      var response = await http.get(
          Uri.parse(
              '${AppConstants.REUNION_URL}/listReunionInfo?mat=$matricule'),
          headers: {'Content-Type': 'application/json'});
      //print(AppConstants.ACTION_URL);
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

  Future<dynamic> validerReunionInfo(Map data) async {
    try {
      print('data : ${json.encode(data)}');
      //print(Uri.parse('${AppConstants.REUNION_URL}/validerReunionInfo'));
      var response = await http.post(
          Uri.parse('${AppConstants.REUNION_URL}/validerReunionInfo'),
          body: json.encode(data),
          headers: {'Content-Type': 'application/json'});
      //print(AppConstants.ACTION_URL);
      print('response ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }

  ///Reunion planifier
  Future<List<dynamic>> getReunionPlanifier(matricule) async {
    try {
      var response = await http.get(
          Uri.parse(
              '${AppConstants.REUNION_URL}/getPlanifiedReunion?mat=$matricule'),
          headers: {'Content-Type': 'application/json'});
      //print(AppConstants.ACTION_URL);
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

  Future<dynamic> validerReunionPlanifier(Map data) async {
    try {
      print('data : ${json.encode(data)}');
      print(Uri.parse('${AppConstants.REUNION_URL}/confirmPresence'));
      var response = await http.post(
          Uri.parse('${AppConstants.REUNION_URL}/confirmPresence'),
          body: json.encode(data),
          headers: {'Content-Type': 'application/json'});
      //print(AppConstants.ACTION_URL);
      print('response ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }
}
