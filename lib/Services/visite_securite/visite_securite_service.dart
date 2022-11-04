import 'dart:convert';
import '../../Utils/constants.dart';
import 'package:http/http.dart' as http;

class VisiteSecuriteService {
  // Fetch Data
  Future<List<dynamic>> getVisiteSecurite(matricule) async {
    try {
      var response = await http.get(
          Uri.parse(
              '${AppConstants.VISITE_SECURETE_URL}/ListeVisite?Mat=$matricule'),
          headers: {'Content-Type': 'application/json'});
      //print(AppConstants.ACTION_URL);
      //print('response incident securite : ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error('service Visite Securite : ${exception.toString()}');
    }
  }

  //search data
  Future<List<dynamic>> searchVisiteSecurite(
      numero, unite, zone, matricule) async {
    try {
      print(
          '${AppConstants.VISITE_SECURETE_URL}/ListeVisite?Num=$numero&Unite=$unite&Zone=$zone&Mat=$matricule');
      var response = await http.get(
          Uri.parse(
              '${AppConstants.VISITE_SECURETE_URL}/ListeVisite?Num=$numero&Unite=$unite&Zone=$zone&Mat=$matricule'),
          headers: {'Content-Type': 'application/json'});

      //print('response ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error('service Visite Securite : ${exception.toString()}');
    }
  }

  Future<dynamic> saveVisiteSecurite(Map data) async {
    try {
      print('data : ${json.encode(data)}');
      print(Uri.parse('${AppConstants.VISITE_SECURETE_URL}/AddVisite'));
      var response = await http.post(
          Uri.parse('${AppConstants.VISITE_SECURETE_URL}/AddVisite'),
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

  // CheckList
  Future<List<dynamic>> getCheckList() async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.VISITE_SECURETE_URL}/GetCheckList'),
          headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error('service Visite Securite : ${exception.toString()}');
    }
  }

  // Unite
  Future<List<dynamic>> getUniteVisiteSecurite() async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.VISITE_SECURETE_URL}/ListeUnite'),
          headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error('service Visite Securite : ${exception.toString()}');
    }
  }

  // Zone
  Future<List<dynamic>> getZone() async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.VISITE_SECURETE_URL}/ListUniteZone'),
          headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error('service Visite Securite : ${exception.toString()}');
    }
  }

  Future<List<dynamic>> getZoneByUnite(idUnite) async {
    try {
      var response = await http.get(
          Uri.parse(
              '${AppConstants.VISITE_SECURETE_URL}/GetZoneByUnite?IdUnite=$idUnite'),
          headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error('service Visite Securite : ${exception.toString()}');
    }
  }

  // Site
  Future<List<dynamic>> getSiteVisiteSecurite(matricule) async {
    try {
      var response = await http.get(
          Uri.parse(
              '${AppConstants.SITE_URL}/SiteVisiteSecurite?mat=$matricule'),
          headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error('service Visite Securite : ${exception.toString()}');
    }
  }

  // CheckList Critere
  Future<List<dynamic>> getCheckListCritere(idFiche) async {
    try {
      var response = await http.get(
          Uri.parse(
              '${AppConstants.VISITE_SECURETE_URL}/ListVisiteCheckList?idFiche=$idFiche'),
          headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error('service Visite Securite : ${exception.toString()}');
    }
  }

  Future<dynamic> saveCheckListCritere(Map data) async {
    try {
      print('data : ${json.encode(data)}');
      print(Uri.parse('${AppConstants.VISITE_SECURETE_URL}/ValidCheckList'));
      var response = await http.post(
          Uri.parse('${AppConstants.VISITE_SECURETE_URL}/ValidCheckList'),
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

  //taux respect checklist vs
  Future<dynamic> getTauxRespect(idFiche) async {
    try {
      var response = await http.get(
          Uri.parse(
              '${AppConstants.VISITE_SECURETE_URL}/TauxRespectVisite?idViste=$idFiche'),
          headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error('service Visite Securite : ${exception.toString()}');
    }
  }

  //equipe
  Future<List<dynamic>> getEquipeVisiteSecurite(idFiche) async {
    try {
      var response = await http.get(
          Uri.parse(
              '${AppConstants.VISITE_SECURETE_URL}/ListEquipeVisite?idFiche=$idFiche'),
          headers: {'Content-Type': 'application/json'});
      //print(AppConstants.ACTION_URL);
      //print('response incident securite : ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error('service Visite Securite : ${exception.toString()}');
    }
  }

  Future<dynamic> saveEquipeVisiteSecurite(Map data) async {
    try {
      print('data : ${json.encode(data)}');
      print(Uri.parse('${AppConstants.VISITE_SECURETE_URL}/AddEquipeVisite'));
      var response = await http.post(
          Uri.parse('${AppConstants.VISITE_SECURETE_URL}/AddEquipeVisite'),
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

  Future<dynamic> deleteEquipeVisiteSecuriteById(idFiche, mat) async {
    try {
      print(
          '${AppConstants.VISITE_SECURETE_URL}/DeleteEquipeVisite?IdFiche=$idFiche&Mat=$mat');
      var response = await http.delete(
          Uri.parse(
              '${AppConstants.VISITE_SECURETE_URL}/DeleteEquipeVisite?IdFiche=$idFiche&Mat=$mat'),
          headers: {'Content-Type': 'application/json'});
      print('response : ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error('service Inc Securite : ${exception.toString()}');
    }
  }

  //action
  Future<List<dynamic>> getActionsVisiteSecurite(idFiche) async {
    try {
      var response = await http.get(
          Uri.parse(
              '${AppConstants.VISITE_SECURETE_URL}/listActionVSRattacher?idFiche=$idFiche'),
          headers: {'Content-Type': 'application/json'});
      //print(AppConstants.ACTION_URL);
      //print('response incident securite : ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error('service Visite Securite : ${exception.toString()}');
    }
  }

  Future<List<dynamic>> getActionsVSARattacher(
      nPage, numPage, idFiche, module, mat) async {
    try {
      var response = await http.get(
          Uri.parse(
              '${AppConstants.VISITE_SECURETE_URL}/listActionVSARattacher?nPage=$nPage&numPage=$numPage&idFiche=$idFiche&module=$module&mat=$mat'),
          headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error(
          'service action vs a rattacher : ${exception.toString()}');
    }
  }

  Future<dynamic> saveActionVisiteSecurite(Map data) async {
    try {
      print('data : ${json.encode(data)}');
      print(Uri.parse('${AppConstants.VISITE_SECURETE_URL}/RattachAction'));
      var response = await http.post(
          Uri.parse('${AppConstants.VISITE_SECURETE_URL}/RattachAction'),
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

  Future<dynamic> deleteActionVisiteSecuriteById(idFiche, idAction) async {
    try {
      print(
          '${AppConstants.VISITE_SECURETE_URL}/DeleteActionVisite?IdFiche=$idFiche&IdAct=$idAction');
      var response = await http.delete(
          Uri.parse(
              '${AppConstants.VISITE_SECURETE_URL}/DeleteActionVisite?IdFiche=$idFiche&IdAct=$idAction'),
          headers: {'Content-Type': 'application/json'});
      print('response : ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error('service Inc Securite : ${exception.toString()}');
    }
  }
}
