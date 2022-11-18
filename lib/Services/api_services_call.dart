import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../Utils/constants.dart';

class ApiServicesCall extends GetConnect {
  //get domaine affectation
  Future<List<dynamic>> getDomaineAffectation() async {
    try {
      var response = await http.get(
          Uri.parse(
              '${AppConstants.BASE_URL}/api/ParametreSociete/ListeDomaineAffectation?avec_emp=1&avec_formation=1&avec_audit=1&avec_action=1&avec_document=1&avec_reunion=1&avec_fournisseur=1&avec_reclamation=1&avec_indicateur=1&avec_equipement=1&avec_non_conformite=1&avec_coq=1&avec_environnement=1&avec_haccp=1&avec_courrier=1&avec_amdec=1&avec_securite=1&avec_conf_reg=1&avec_part_int=1&avec_client=1&avec_risque=1&avec_changement=1&avec_Conformite=1&avec_Achat=1'),
          headers: {'Content-Type': ' application/json'});
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

  //champ obligatoire module action
  Future<List<dynamic>> getChampObligatoireAction() async {
    try {
      var response = await http.get(
          Uri.parse(
              '${AppConstants.PARAMETRE_SOCIETE_URL}/GetChampsObligatoireAction'),
          headers: {'Content-Type': ' application/json'});
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

  //champ cache
  Future<List<dynamic>> getChampCache(Map data) async {
    try {
      print('data : ${json.encode(data)}');
      var response = await http.post(
          Uri.parse('${AppConstants.GESTION_ACCES_URL}/SelectChampCache'),
          body: json.encode(data),
          headers: {'Content-Type': ' application/json'});
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

  //get sources action
  Future<List<dynamic>> getSourceAction() async {
    try {
      var response =
          await http.post(Uri.parse('${AppConstants.ACTION_URL}/AllSource'),
              //body: json.encode(data),
              headers: {'Content-Type': ' application/json'});
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

  //get type action
  Future<List<dynamic>> getTypeAction(Map data) async {
    try {
      //print('data : ${json.encode(data)}');
      var response = await http.post(
          Uri.parse('${AppConstants.ACTION_URL}/AllType'),
          body: json.encode(data),
          headers: {'Content-Type': ' application/json'});
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

  //get type cause action
  Future<List<dynamic>> getTypeCauseAction(Map data) async {
    try {
      //print('data : ${json.encode(data)}');
      var response = await http.post(
          Uri.parse('${AppConstants.ACTION_URL}/GetTypeCause'),
          body: json.encode(data),
          headers: {'Content-Type': ' application/json'});
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

  //get resp cloture
  Future<List<dynamic>> getResponsableCloture(Map data) async {
    try {
      print('data : ${json.encode(data)}');
      var response = await http.post(
          Uri.parse('${AppConstants.ACTION_URL}/ListRespCloture'),
          body: json.encode(data),
          headers: {'Content-Type': ' application/json'});
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

  Future<List<dynamic>> getAllResponsableCloture() async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.ACTION_URL}/GetAllRespCloture'),
          headers: {'Content-Type': ' application/json'});
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

  //get site
  Future<List<dynamic>> getSite(Map data) async {
    try {
      //print('data : ${json.encode(data)}');
      var response = await http.post(
          Uri.parse('${AppConstants.SITE_URL}/GetAllSite'),
          body: json.encode(data),
          headers: {'Content-Type': ' application/json'});
      print('response ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error('service : ${exception.toString()}');
    }
  }

  Future<List<dynamic>> getSiteOffline(matricule) async {
    try {
      //print('data : ${json.encode(data)}');
      var response = await http.get(
          Uri.parse(
              '${AppConstants.SITE_URL}/SiteEmployeRestriction?mat=$matricule'),
          headers: {'Content-Type': 'application/json'});
      print('response ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error('service : ${exception.toString()}');
    }
  }

  //get processus
  Future<List<dynamic>> getProcessus(Map data) async {
    try {
      if (kDebugMode) {
        print('data : ${json.encode(data)}');
        print('${AppConstants.PROCESSUS_URL}/GetAllProcessus');
      }
      var response = await http.post(
          Uri.parse('${AppConstants.PROCESSUS_URL}/GetAllProcessus'),
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

  Future<List<dynamic>> getProcessusOffline(matricule) async {
    try {
      //print('data : ${json.encode(data)}');
      var response = await http.get(
          Uri.parse(
              '${AppConstants.PROCESSUS_URL}/ProcessusParFicheEtEmploye?mat=$matricule'),
          headers: {'Content-Type': 'application/json'});
      print('response ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error('service : ${exception.toString()}');
    }
  }

  //get product
  Future<List<dynamic>> getProduct(Map data) async {
    try {
      //print('data : ${json.encode(data)}');
      var response = await http.post(
          Uri.parse('${AppConstants.ACTION_URL}/GetProduits'),
          body: json.encode(data),
          headers: {'Content-Type': ' application/json'});
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

  //get direction
  Future<List<dynamic>> getDirection(Map data) async {
    try {
      //print('data : ${json.encode(data)}');
      var response = await http.post(
          Uri.parse('${AppConstants.DIRECTION_URL}/GetAllDirection'),
          body: json.encode(data),
          headers: {'Content-Type': ' application/json'});
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

  Future<List<dynamic>> getDirectionOffline(matricule) async {
    try {
      //print('data : ${json.encode(data)}');
      var response = await http.get(
          Uri.parse(
              '${AppConstants.DIRECTION_URL}/DirectionParFicheEtEmploye?mat=$matricule'),
          headers: {'Content-Type': 'application/json'});
      print('response ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error('service : ${exception.toString()}');
    }
  }

  //get service
  Future<List<dynamic>> getService(matricule, direction, module, fiche) async {
    try {
      print(Uri.parse(
          '${AppConstants.SERVICE_URL}/ServiceParFicheEtEmployeEtDirection?mat=$matricule&CodeDirection=$direction&Module=$module&Fiche=$fiche'));
      var response = await http.get(
          Uri.parse(
              '${AppConstants.SERVICE_URL}/ServiceParFicheEtEmployeEtDirection?mat=$matricule&CodeDirection=$direction&Module=$module&Fiche=$fiche'),
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

  //get activity
  Future<List<dynamic>> getActivity(Map data) async {
    try {
      //print('data : ${json.encode(data)}');
      var response = await http.post(
          Uri.parse('${AppConstants.ACTIVITY_URL}/GetAllDomaines'),
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

  Future<List<dynamic>> getActivityOffline(matricule) async {
    try {
      //print('data : ${json.encode(data)}');
      var response = await http.get(
          Uri.parse(
              '${AppConstants.ACTIVITY_URL}/DomaineParFicheEtEmploye?mat=$matricule'),
          headers: {'Content-Type': 'application/json'});
      print('response ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error('service : ${exception.toString()}');
    }
  }

  //get employe
  Future<List<dynamic>> getEmploye(Map data) async {
    try {
      //print('data : ${json.encode(data)}');
      var response = await http.post(
          Uri.parse('${AppConstants.EMPLOYE_URL}/GetAllEmployesAction'),
          body: json.encode(data),
          headers: {'Content-Type': ' application/json'});
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

  //get audit action
  Future<List<dynamic>> getAuditAction() async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.AUDIT_URL}/GetAllAudit'),
          headers: {'Content-Type': ' application/json'});
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

  //get priorite
  Future<List<dynamic>> getPriorite() async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.SOUS_ACTION_URL}/priorite'),
          headers: {'Content-Type': ' application/json'});
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

//get gravite
  Future<List<dynamic>> getGravite() async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.GRAVITE_URL}/GetGravite'),
          headers: {'Content-Type': ' application/json'});
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

  //get resp realisation
  Future<List<dynamic>> getResponsableRealisation(Map data) async {
    try {
      print('data : ${json.encode(data)}');
      var response = await http.post(
          Uri.parse(
              '${AppConstants.SOUS_ACTION_URL}/SelectResponsableRealisation'),
          body: json.encode(data),
          headers: {'Content-Type': ' application/json'});
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

  //get resp suivi
  Future<List<dynamic>> getResponsableSuivi(Map data) async {
    try {
      print('data : ${json.encode(data)}');
      var response = await http.post(
          Uri.parse('${AppConstants.SOUS_ACTION_URL}/SelectResponsableSuivie'),
          body: json.encode(data),
          headers: {'Content-Type': ' application/json'});
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

  //get processus by matricule
  Future<List<dynamic>> getProcessusByMatricule(mat) async {
    try {
      print('${AppConstants.SOUS_ACTION_URL}/GetProcessusSousAction?mat=$mat');
      var response = await http.get(
          Uri.parse(
              '${AppConstants.SOUS_ACTION_URL}/GetProcessusSousAction?mat=$mat'),
          headers: {'Content-Type': ' application/json'});
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

  //get processus of employe
  Future<List<dynamic>> getProcessusEmploye() async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.PROCESSUS_URL}/getProcessusByMatricule'),
          headers: {'Content-Type': ' application/json'});
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

  //get all sous action
  Future<List<dynamic>> getAllSousAction() async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.SOUS_ACTION_URL}/sousActLocale'),
          headers: {'Content-Type': ' application/json'});
      //print('response ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      } else {
        return Future.error(response.statusCode.toString());
      }
    } catch (exception) {
      return Future.error('service all sous action : ${exception.toString()}');
    }
  }

  //Module PNC
  //champ obligatoire module pnc
  Future<dynamic> getChampObligatoirePNC() async {
    try {
      var response = await http.get(
          Uri.parse(
              '${AppConstants.PARAMETRE_SOCIETE_URL}/GetChampsObligatoirePnc'),
          headers: {'Content-Type': ' application/json'});
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

  //get fournisseur
  Future<List<dynamic>> getFournisseurs(matricule) async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.PNC_URL}/listeFournisseurs?mat=$matricule'),
          headers: {'Content-Type': ' application/json'});
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

  //get client
  Future<List<dynamic>> getClients() async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.PNC_URL}/listeClient'),
          headers: {'Content-Type': ' application/json'});
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

  //get type PNC
  Future<List<dynamic>> getTypePNC() async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.PNC_URL}/listeTypePnc'),
          headers: {'Content-Type': ' application/json'});
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

  //get Gravite PNC
  Future<List<dynamic>> getGravitePNC() async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.GRAVITE_URL}/GetGraviteNc'),
          headers: {'Content-Type': ' application/json'});
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

  //get Source PNC
  Future<List<dynamic>> getSourcePNC() async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.PNC_URL}/listeSource'),
          headers: {'Content-Type': ' application/json'});
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

  //get Atelier PNC
  Future<List<dynamic>> getAtelierPNC() async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.PNC_URL}/listeAtelier'),
          headers: {'Content-Type': ' application/json'});
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
}
