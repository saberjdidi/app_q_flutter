import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/foundation.dart';
import 'package:qualipro_flutter/Models/status_request.dart';
import '../../Utils/constants.dart';
import 'package:http/http.dart' as http;

class IncidentEnvironnementService {
  // Fetch Data
  Future<List<dynamic>> getIncident(matricule) async {
    try {
      var response = await http.get(
          Uri.parse(
              '${AppConstants.INCIDENT_ENVIRONNEMENT_URL}/getListeIncidentEnvironnement?mat=$matricule'),
          headers: {'Content-Type': 'application/json'});
      //print(AppConstants.ACTION_URL);
      //print('response incident env : ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error('service Inc Env : ${exception.toString()}');
    }
  }

  //search data
  Future<List<dynamic>> searchIncident(
      matricule, numero, type, designation) async {
    try {
      print(
          '${AppConstants.INCIDENT_ENVIRONNEMENT_URL}/getListeIncidentEnvironnement?mat=$matricule&Numero=$numero&Type=$type&designation=$designation');
      var response = await http.get(
          Uri.parse(
              '${AppConstants.INCIDENT_ENVIRONNEMENT_URL}/getListeIncidentEnvironnement?mat=$matricule&Numero=$numero&Type=$type&designation=$designation'),
          headers: {'Content-Type': 'application/json'});

      //print('response ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error('service Inc Env : ${exception.toString()}');
    }
  }

  Future<dynamic> saveIncident(Map data) async {
    try {
      print('data : ${json.encode(data)}');
      print(Uri.parse('${AppConstants.INCIDENT_ENVIRONNEMENT_URL}/addIncEnv'));
      var response = await http.post(
          Uri.parse('${AppConstants.INCIDENT_ENVIRONNEMENT_URL}/addIncEnv'),
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

  Future<dynamic> uploadImageIncEnv(Map data) async {
    try {
      debugPrint('data : ${json.encode(data)}');
      var response = await http
          .post(Uri.parse('${AppConstants.UPLOAD_URL}/uploadPhotoIncEnv'),
              //Uri.parse('https://10.0.2.2:7019/api/Upload/uploadPhotoIncEnv'),
              body: json.encode(data),
              headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }

  Future<List<dynamic>> getImageIncEnv(idFiche) async {
    try {
      debugPrint('${AppConstants.UPLOAD_URL}/getImageIncEnv?idFiche=$idFiche');
      var response = await http.get(
          Uri.parse(
              '${AppConstants.UPLOAD_URL}/getImageIncEnv?idFiche=$idFiche'),
          headers: {'Content-Type': 'application/json'});
      debugPrint('response image inc env : $response');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }

  //champ obligatoire
  Future<dynamic> getChampObligatoireIncidentEnv() async {
    try {
      var response = await http.get(
          Uri.parse(
              '${AppConstants.PARAMETRE_SOCIETE_URL}/ChampsObligatoireIncidentEnv'),
          headers: {'Content-Type': ' application/json'});
      //print('response ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error('service Inc Env : ${exception.toString()}');
    }
  }

  //type cause
  Future<List<dynamic>> getTypeCauseIncidentEnv() async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.INCIDENT_ENVIRONNEMENT_URL}/listTypeCause'),
          headers: {'Content-Type': 'application/json'});
      //print('response ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error('service Inc Env : ${exception.toString()}');
    }
  }

  //category
  Future<List<dynamic>> getCategoryIncidentEnv() async {
    try {
      var response = await http.get(
          Uri.parse(
              '${AppConstants.INCIDENT_ENVIRONNEMENT_URL}/listCategorieEnvironment'),
          headers: {'Content-Type': 'application/json'});
      //print('response ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error('service Inc Env : ${exception.toString()}');
    }
  }

  //type consequence
  Future<List<dynamic>> getTypeConsequenceIncidentEnv() async {
    try {
      var response = await http.get(
          Uri.parse(
              '${AppConstants.INCIDENT_ENVIRONNEMENT_URL}/listTypeConsequence'),
          headers: {'Content-Type': 'application/json'});
      //print('response ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error('service Inc Env : ${exception.toString()}');
    }
  }

  //type incident
  Future<List<dynamic>> getTypeIncidentEnv() async {
    try {
      var response = await http.get(
          Uri.parse(
              '${AppConstants.INCIDENT_ENVIRONNEMENT_URL}/listTypeIncEnv'),
          headers: {'Content-Type': 'application/json'});
      //print('response ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error('service Inc Env : ${exception.toString()}');
    }
  }

  //lieu incident
  Future<List<dynamic>> getLieuIncidentEnv(matricule) async {
    try {
      var response = await http.get(
          Uri.parse(
              '${AppConstants.INCIDENT_ENVIRONNEMENT_URL}/lieuIncidentEnv?mat=$matricule'),
          headers: {'Content-Type': 'application/json'});
      //print('response ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error('service Inc Env : ${exception.toString()}');
    }
  }

  //source incident
  Future<List<dynamic>> getSourceIncidentEnv() async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.INCIDENT_ENVIRONNEMENT_URL}/ListSource'),
          headers: {'Content-Type': 'application/json'});
      //print('response ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error('service Inc Env : ${exception.toString()}');
    }
  }

  //cout estime incident
  Future<List<dynamic>> getCoutEstimeIncidentEnv() async {
    try {
      var response = await http.get(
          Uri.parse(
              '${AppConstants.INCIDENT_ENVIRONNEMENT_URL}/ListCoutEstime'),
          headers: {'Content-Type': 'application/json'});
      //print('response ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error('service Inc Env : ${exception.toString()}');
    }
  }

  //gravite incident
  Future<List<dynamic>> getGraviteIncidentEnv() async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.INCIDENT_ENVIRONNEMENT_URL}/ListGravite'),
          headers: {'Content-Type': 'application/json'});
      //print('response ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error('service Inc Env : ${exception.toString()}');
    }
  }

  //secteur incident
  Future<List<dynamic>> getSecteurIncidentEnv() async {
    try {
      print('${AppConstants.INCIDENT_ENVIRONNEMENT_URL}/ListSecteur');
      var response = await http.get(
          Uri.parse('${AppConstants.INCIDENT_ENVIRONNEMENT_URL}/ListSecteur'),
          headers: {'Content-Type': 'application/json'});
      print('response : ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error('service Inc Env : ${exception.toString()}');
    }
  }

  //type cause of incident
  Future<List<dynamic>> getTypeCauseByIncident(incident, mat, online) async {
    try {
      var response = await http.get(
          Uri.parse(
              '${AppConstants.INCIDENT_ENVIRONNEMENT_URL}/listTypeCauseByIncident?idIncident=$incident&mat=$mat&online=$online'),
          headers: {'Content-Type': 'application/json'});
      //print('response ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error('service Inc Env : ${exception.toString()}');
    }
  }

  Future<List<dynamic>> getTypeCauseOfIncidentARattacher(
      incident, mat, online) async {
    try {
      var response = await http.get(
          Uri.parse(
              '${AppConstants.INCIDENT_ENVIRONNEMENT_URL}/listTypeCauseARattacher?idIncident=$incident&mat=$mat&online=$online'),
          headers: {'Content-Type': 'application/json'});
      //print('response ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error('service Inc Env : ${exception.toString()}');
    }
  }

  Future<dynamic> saveTypeCauseByIncident(Map data) async {
    try {
      print('data : ${json.encode(data)}');
      //print(Uri.parse('${AppConstants.INCIDENT_ENVIRONNEMENT_URL}/addTypeCauseIncidEnv'));
      var response = await http.post(
          Uri.parse(
              '${AppConstants.INCIDENT_ENVIRONNEMENT_URL}/addTypeCauseIncidEnv'),
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

  Future<dynamic> deleteTypeCauseIncidentById(idCauseIncident) async {
    try {
      debugPrint(
          '${AppConstants.INCIDENT_ENVIRONNEMENT_URL}/DeleteTypeCauseIncident/$idCauseIncident');
      var response = await http.delete(
          Uri.parse(
              '${AppConstants.INCIDENT_ENVIRONNEMENT_URL}/DeleteTypeCauseIncident/$idCauseIncident'),
          headers: {'Content-Type': 'application/json'});
      debugPrint('response : ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error('service Inc Env : ${exception.toString()}');
    }
  }

  //type consequence of incident
  Future<List<dynamic>> getTypeConsequenceByIncident(
      idIncident, mat, online) async {
    try {
      var response = await http.get(
          Uri.parse(
              '${AppConstants.INCIDENT_ENVIRONNEMENT_URL}/listTypeConseqByIncident?idIncident=$idIncident&mat=$mat&online=$online'),
          headers: {'Content-Type': 'application/json'});
      //print('response ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error('service Inc Env : ${exception.toString()}');
    }
  }

  Future<List<dynamic>> getTypeConsequenceByIncidentARattacher(
      idIncident, mat) async {
    try {
      var response = await http.get(
          Uri.parse(
              '${AppConstants.INCIDENT_ENVIRONNEMENT_URL}/listTypeConseqARattacher?idIncident=$idIncident&mat=$mat'),
          headers: {'Content-Type': 'application/json'});
      //print('response ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error('service Inc Env : ${exception.toString()}');
    }
  }

  Future<dynamic> saveTypeConseqenceByIncident(Map data) async {
    try {
      print('data : ${json.encode(data)}');
      //print(Uri.parse('${AppConstants.INCIDENT_ENVIRONNEMENT_URL}/AddTypeConsequenceIncidentEnv'));
      var response = await http.post(
          Uri.parse(
              '${AppConstants.INCIDENT_ENVIRONNEMENT_URL}/AddTypeConsequenceIncidentEnv'),
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

  //delete type consequence of incident
  Future<dynamic> deleteTypeConsequenceIncidentById(
      idConsequenceIncident) async {
    try {
      print(
          '${AppConstants.INCIDENT_ENVIRONNEMENT_URL}/DeleteTypeConseqIncident/$idConsequenceIncident');
      var response = await http.delete(
          Uri.parse(
              '${AppConstants.INCIDENT_ENVIRONNEMENT_URL}/DeleteTypeConseqIncident/$idConsequenceIncident'),
          headers: {'Content-Type': 'application/json'});
      print('response : ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error('service Inc Env : ${exception.toString()}');
    }
  }

  //Agenda
  //DecisionTraitement incident env
  Future<List<dynamic>> getListIncidentEnvDecisionTraitement(matricule) async {
    try {
      var response = await http.get(
          Uri.parse(
              '${AppConstants.INCIDENT_ENVIRONNEMENT_URL}/listDecisionTraitement?mat=$matricule'),
          headers: {'Content-Type': 'application/json'});
      //print('response ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error('service Inc Env : ${exception.toString()}');
    }
  }

  Future<dynamic> validerIncidentEnvDecisionTraitement(Map data) async {
    try {
      print('data : ${json.encode(data)}');
      print(Uri.parse(
          '${AppConstants.INCIDENT_ENVIRONNEMENT_URL}/ValidDecisionTraitement'));
      var response = await http.post(
          Uri.parse(
              '${AppConstants.INCIDENT_ENVIRONNEMENT_URL}/ValidDecisionTraitement'),
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

  //incident env a traiter
  Future<List<dynamic>> getListIncidentEnvATraiter(matricule) async {
    try {
      var response = await http.get(
          Uri.parse(
              '${AppConstants.INCIDENT_ENVIRONNEMENT_URL}/listDecision_aTraiter?mat=$matricule'),
          headers: {'Content-Type': 'application/json'});
      //print('response ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error('service Inc Env : ${exception.toString()}');
    }
  }

  Future<dynamic> validerIncidentEnvTraiter(Map data) async {
    try {
      print('data : ${json.encode(data)}');
      //print(Uri.parse('${AppConstants.REUNION_URL}/validerReunionInfo'));
      var response = await http.post(
          Uri.parse(
              '${AppConstants.INCIDENT_ENVIRONNEMENT_URL}/ValidIncidentTraiter'),
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

  //incident env a cloturer
  Future<List<dynamic>> getListIncidentEnvACloturer(matricule) async {
    try {
      var response = await http.get(
          Uri.parse(
              '${AppConstants.INCIDENT_ENVIRONNEMENT_URL}/listDecisionCloturer?mat=$matricule'),
          headers: {'Content-Type': 'application/json'});
      //print('response ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error('service Inc Env : ${exception.toString()}');
    }
  }

  //Either use to return 2 types
  Future<Either<StatusRequest, Map>> validerIncidentEnvCloturer(
      Map data) async {
    try {
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        print('data : ${json.encode(data)}');
        //print(Uri.parse('${AppConstants.REUNION_URL}/validerReunionInfo'));
        var response = await http.post(
            Uri.parse(
                '${AppConstants.INCIDENT_ENVIRONNEMENT_URL}/ValiderIncidentCloturer'),
            body: json.encode(data),
            headers: {'Content-Type': 'application/json'});
        //print(AppConstants.ACTION_URL);
        print('response ${jsonDecode(response.body)}');
        if (response.statusCode == 200 || response.statusCode == 201) {
          Map responseBody = jsonDecode(response.body);
          return Right(responseBody);
        } else {
          return const Left(StatusRequest.serverfailure);
          //return Future.error(response.statusCode.toString());
        }
      } else {
        return const Left(StatusRequest.modeoffline);
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }

  //responsable cloture
  Future<List<dynamic>> getResponsableCloture(site, processus) async {
    try {
      print(Uri.parse(
          '${AppConstants.INCIDENT_ENVIRONNEMENT_URL}/GetResponsableCloture?idSite=$site&idProcessus=$processus'));
      var response = await http.get(
          Uri.parse(
              '${AppConstants.INCIDENT_ENVIRONNEMENT_URL}/GetResponsableCloture?idSite=$site&idProcessus=$processus'),
          headers: {'Content-Type': 'application/json'});
      //print('response ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error('service Inc Env : ${exception.toString()}');
    }
  }

  //rattach action
  Future<List<dynamic>> getActionsIncidentEnvironnement(idFiche) async {
    try {
      var response = await http.get(
          Uri.parse(
              '${AppConstants.INCIDENT_ENVIRONNEMENT_URL}/listActionRattacherIncEnv?IdFiche=$idFiche'),
          headers: {'Content-Type': 'application/json'});
      //print(AppConstants.ACTION_URL);
      //print('response incident securite : ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error('service Inc env : ${exception.toString()}');
    }
  }

  Future<dynamic> saveActionIncidentEnvironnement(Map data) async {
    try {
      print('data : ${json.encode(data)}');
      print(Uri.parse(
          '${AppConstants.INCIDENT_ENVIRONNEMENT_URL}/RattachEnvAction'));
      var response = await http.post(
          Uri.parse(
              '${AppConstants.INCIDENT_ENVIRONNEMENT_URL}/RattachEnvAction'),
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
      return Future.error('service Inc env : ${exception.toString()}');
    }
  }

  Future<dynamic> deleteActionIncidentEnvironnementId(idFiche, idAction) async {
    try {
      print(
          '${AppConstants.INCIDENT_ENVIRONNEMENT_URL}/DeleteEnvAction?IdFiche=$idFiche&IdAction=$idAction');
      var response = await http.delete(
          Uri.parse(
              '${AppConstants.INCIDENT_ENVIRONNEMENT_URL}/DeleteEnvAction?IdFiche=$idFiche&IdAction=$idAction'),
          headers: {'Content-Type': 'application/json'});
      print('response : ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error('service Inc env : ${exception.toString()}');
    }
  }
}
