import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../Utils/constants.dart';
import 'package:http/http.dart' as http;

class IncidentSecuriteService {
  // Fetch Data
  Future<List<dynamic>> getIncident(matricule) async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.INCIDENT_SECURETE_URL}/listeIncidents?Mat=$matricule'),
          headers: {
            'Content-Type':'application/json'
          }
      );
      //print(AppConstants.ACTION_URL);
      //print('response incident securite : ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      }
      else {
        return Future.error(response.statusCode.toString());
      }
    }
    catch (exception) {
      return Future.error('service Inc Securite : ${exception.toString()}');
    }
  }
  //search data
  Future<List<dynamic>> searchIncident(matricule, numero, designation, type) async {
    try {
      print('${AppConstants.INCIDENT_SECURETE_URL}/listeIncidents?Mat=$matricule&Ref=$numero&Designation=$designation&type=$type');
      var response = await http.get(
          Uri.parse('${AppConstants.INCIDENT_SECURETE_URL}/listeIncidents?Mat=$matricule&Ref=$numero&Designation=$designation&type=$type'),
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
      return Future.error('service Inc Securite : ${exception.toString()}');
    }
  }

  Future<dynamic> saveIncident(Map data) async{
    try
    {
      debugPrint('data : ${json.encode(data)}');
      if(kDebugMode) print(Uri.parse('${AppConstants.INCIDENT_SECURETE_URL}/AddIncidentSecurite'));
      var response = await http.post(
          Uri.parse('${AppConstants.INCIDENT_SECURETE_URL}/AddIncidentSecurite'),
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
  //champ obligatoire
  Future<dynamic> getChampObligatoireIncidentSecurite() async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.PARAMETRE_SOCIETE_URL}/ChampsObligatoireIncidentSec'),
          headers: {
            'Content-Type':' application/json'
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
      return Future.error('service Inc Securite : ${exception.toString()}');
    }
  }
  //poste travail
  Future<List<dynamic>> getPosteTravailIncidentSecurite() async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.INCIDENT_SECURETE_URL}/listPosteTravail'),
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
      return Future.error('service Inc Securite : ${exception.toString()}');
    }
  }
  //type incident securite
  Future<List<dynamic>> getTypeIncidentSecurite() async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.INCIDENT_SECURETE_URL}/listeTypeIncident'),
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
      return Future.error('service Inc Securite : ${exception.toString()}');
    }
  }
  //category
  Future<List<dynamic>> getCategoryIncidentSecurite() async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.INCIDENT_SECURETE_URL}/GetlisteCategory'),
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
      return Future.error('service Inc Securite : ${exception.toString()}');
    }
  }
  //gravite incident
  Future<List<dynamic>> getGraviteIncidentSecurite() async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.INCIDENT_SECURETE_URL}/listeGraviteIncident'),
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
      return Future.error('service Inc Securite : ${exception.toString()}');
    }
  }
  //secteur incident
  Future<List<dynamic>> getSecteurIncidentSecurite() async {
    try {
      //print('${AppConstants.INCIDENT_SECURETE_URL}/listeSecteur');
      var response = await http.get(
          Uri.parse('${AppConstants.INCIDENT_SECURETE_URL}/listeSecteur'),
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
      return Future.error('service Inc Securite : ${exception.toString()}');
    }
  }
  //cout esteme
  Future<List<dynamic>> getCoutEstemeIncidentSecurite() async {
    try {
      //print('${AppConstants.INCIDENT_SECURETE_URL}/listeSecteur');
      var response = await http.get(
          Uri.parse('${AppConstants.INCIDENT_SECURETE_URL}/listCoutsEstimes'),
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
      return Future.error('service Inc Securite : ${exception.toString()}');
    }
  }
  //evenement declencheur
  Future<List<dynamic>> getEvenementDeclencheurIncidentSecurite() async {
    try {
      //print('${AppConstants.INCIDENT_SECURETE_URL}/listeSecteur');
      var response = await http.get(
          Uri.parse('${AppConstants.INCIDENT_SECURETE_URL}/listEvenementsDeclencheurs'),
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
      return Future.error('service Inc Securite : ${exception.toString()}');
    }
  }

  //type cause of incident
  Future<List<dynamic>> getTypeCauseIncidentSecurite() async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.INCIDENT_SECURETE_URL}/GetlisteCause'),
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
      return Future.error('service Inc Securite : ${exception.toString()}');
    }
  }
  Future<List<dynamic>> getTypeCauseIncSecRattacher(idIncident, mat, online) async {
    try {
      debugPrint('${AppConstants.INCIDENT_SECURETE_URL}/listTypeCauseIncSecRattacher?idIncident=$idIncident&mat=$mat&online=$online');
      var response = await http.get(
          Uri.parse('${AppConstants.INCIDENT_SECURETE_URL}/listTypeCauseIncSecRattacher?idIncident=$idIncident&mat=$mat&online=$online'),
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
      return Future.error('service type cause Inc Sec : ${exception.toString()}');
    }
  }
  Future<List<dynamic>> getTypeCauseIncSecARattacher(idIncident, mat) async {
    try {
      debugPrint('${AppConstants.INCIDENT_SECURETE_URL}/listTypeCauseIncSecARattacher?idIncident=$idIncident&mat=$mat');
      var response = await http.get(
          Uri.parse('${AppConstants.INCIDENT_SECURETE_URL}/listTypeCauseIncSecARattacher?idIncident=$idIncident&mat=$mat'),
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
      return Future.error('service type cause Inc Sec : ${exception.toString()}');
    }
  }
  Future<dynamic> saveTypeCauseByIncident(Map data) async{
    try
    {
      print('data : ${json.encode(data)}');
      //print(Uri.parse('${AppConstants.INCIDENT_SECURETE_URL}/AddCauseByIncident'));
      var response = await http.post(
          Uri.parse('${AppConstants.INCIDENT_SECURETE_URL}/AddCauseByIncident'),
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
  Future<dynamic> deleteTypeCauseIncidentById(idIncident, idCause) async {
    try {
      print('${AppConstants.INCIDENT_SECURETE_URL}/DeleteCause?idIncident=$idIncident&idCause=$idCause');
      var response = await http.delete(
          Uri.parse('${AppConstants.INCIDENT_SECURETE_URL}/DeleteCause?idIncident=$idIncident&idCause=$idCause'),
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
      return Future.error('service Inc Securite : ${exception.toString()}');
    }
  }
  //type consequence
  Future<List<dynamic>> getTypeConsequenceIncidentSecurite() async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.INCIDENT_SECURETE_URL}/GetlisteConsequence'),
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
      return Future.error('service Inc Securite : ${exception.toString()}');
    }
  }
  Future<List<dynamic>> getTypeConsequenceIncSecRattacher(idIncident, mat, online) async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.INCIDENT_SECURETE_URL}/listTypeConsequenceIncSecRattacher?idIncident=$idIncident&mat=$mat&online=$online'),
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
      return Future.error('service type consec Inc Sec: ${exception.toString()}');
    }
  }
  Future<List<dynamic>> getTypeConsequenceIncSecARattacher(idIncident, mat) async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.INCIDENT_SECURETE_URL}/listTypeConsequenceIncSecARattacher?idIncident=$idIncident&mat=$mat'),
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
      return Future.error('service type consec Inc Sec: ${exception.toString()}');
    }
  }
  //add type consequence incident
  Future<dynamic> saveTypeConseqenceByIncident(Map data) async{
    try
    {
      print('data : ${json.encode(data)}');
      //print(Uri.parse('${AppConstants.INCIDENT_SECURETE_URL}/AddConsequenceByIncident'));
      var response = await http.post(
          Uri.parse('${AppConstants.INCIDENT_SECURETE_URL}/AddConsequenceByIncident'),
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
  //delete type consequence of incident
  Future<dynamic> deleteTypeConsequenceIncidentById(idIncedent, idConsequence) async {
    try {
      print('${AppConstants.INCIDENT_SECURETE_URL}/DeleteConsequence?idIncident=$idIncedent&idConsequence=$idConsequence');
      var response = await http.delete(
          Uri.parse('${AppConstants.INCIDENT_SECURETE_URL}/DeleteConsequence?idIncident=$idIncedent&idConsequence=$idConsequence'),
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
      return Future.error('service Inc Securite : ${exception.toString()}');
    }
  }
  //cause typique
  Future<List<dynamic>> getCauseTypiqueIncSecARattacher(incident, mat) async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.INCIDENT_SECURETE_URL}/listCauseTypiqueARattacher?idIncident=$incident&mat=$mat'),
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
      return Future.error('service Inc Securite : ${exception.toString()}');
    }
  }
  Future<List<dynamic>> getCauseTypiqueIncSecRattacher(idIncident, mat, online) async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.INCIDENT_SECURETE_URL}/listCauseTypiqueRattacher?idIncident=$idIncident&mat=$mat&online=$online'),
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
      return Future.error('service Inc Securite : ${exception.toString()}');
    }
  }
  Future<dynamic> saveCauseTypiqueByIncident(Map data) async{
    try
    {
      print('data : ${json.encode(data)}');
      //print(Uri.parse('${AppConstants.INCIDENT_SECURETE_URL}/AddCauseTypiqueByIncident'));
      var response = await http.post(
          Uri.parse('${AppConstants.INCIDENT_SECURETE_URL}/AddCauseTypiqueByIncident'),
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
  Future<dynamic> deleteCauseTypiqueIncidentById(idIncedent, idCauseTypique) async {
    try {
      print('${AppConstants.INCIDENT_SECURETE_URL}/DeleteCauseTypique?idIncident=$idIncedent&idCauseTypique=$idCauseTypique');
      var response = await http.delete(
          Uri.parse('${AppConstants.INCIDENT_SECURETE_URL}/DeleteCauseTypique?idIncident=$idIncedent&idCauseTypique=$idCauseTypique'),
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
      return Future.error('service Inc Securite : ${exception.toString()}');
    }
  }
  //site lesion
  Future<List<dynamic>> getSiteLesionIncidentSecurite(idIncident, mat) async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.INCIDENT_SECURETE_URL}/listSiteLesionARattacher?idIncident=$idIncident&mat=$mat'),
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
      return Future.error('service Inc Securite : ${exception.toString()}');
    }
  }
  Future<List<dynamic>> getSiteLesionIncSecRattacher(idIncident, mat, online) async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.INCIDENT_SECURETE_URL}/listSiteLesionRattacher?idIncident=$idIncident&mat=$mat&online=$online'),
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
      return Future.error('service Inc Securite : ${exception.toString()}');
    }
  }
  //add site lesion incident
  Future<dynamic> saveSiteLesionByIncident(Map data) async{
    try
    {
      print('data : ${json.encode(data)}');
      //print(Uri.parse('${AppConstants.INCIDENT_SECURETE_URL}/AddSiteLesionByIncident'));
      var response = await http.post(
          Uri.parse('${AppConstants.INCIDENT_SECURETE_URL}/AddSiteLesionByIncident'),
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
  //delete site lesion of incident
  Future<dynamic> deleteSiteLesionIncidentById(idIncedent, idSiteLesion) async {
    try {
      print('${AppConstants.INCIDENT_SECURETE_URL}/DeleteSiteLesion?idIncident=$idIncedent&idSiteLesion=$idSiteLesion');
      var response = await http.delete(
          Uri.parse('${AppConstants.INCIDENT_SECURETE_URL}/DeleteSiteLesion?idIncident=$idIncedent&idSiteLesion=$idSiteLesion'),
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
      return Future.error('service Inc Securite : ${exception.toString()}');
    }
  }
  //Agenda
  //Decision Traitement
  Future<List<dynamic>> getListIncidentSecuriteDecisionTraitement(matricule) async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.INCIDENT_SECURETE_URL}/listeIncidDecision?mat=$matricule'),
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
      return Future.error('service Inc Env : ${exception.toString()}');
    }
  }
  Future<dynamic> validerIncidentSecuriteDecisionTraitement(Map data) async{
    try
    {
      print('data : ${json.encode(data)}');
      print(Uri.parse('${AppConstants.INCIDENT_SECURETE_URL}/ValidIncidDecisionTraitement'));
      var response = await http.post(
          Uri.parse('${AppConstants.INCIDENT_SECURETE_URL}/ValidIncidDecisionTraitement'),
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
  //responsable cloture
  Future<List<dynamic>> getResponsableCloture(site, processus) async {
    try {
      print(Uri.parse('${AppConstants.INCIDENT_SECURETE_URL}/RespCloture?idSite=$site&idProcessus=$processus'));
      var response = await http.get(
          Uri.parse('${AppConstants.INCIDENT_SECURETE_URL}/RespCloture?idSite=$site&idProcessus=$processus'),
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
      return Future.error('service Inc Env : ${exception.toString()}');
    }
  }
  //incident a traiter
  Future<List<dynamic>> getListIncidentSecuriteATraiter(matricule) async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.INCIDENT_SECURETE_URL}/listeIncidTraiter?mat=$matricule'),
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
      return Future.error('service Inc Env : ${exception.toString()}');
    }
  }
  Future<dynamic> validerIncidentSecuriteATraiter(Map data) async{
    try
    {
      print('data : ${json.encode(data)}');
      print(Uri.parse('${AppConstants.INCIDENT_SECURETE_URL}/ValidIncid_aTraiter'));
      var response = await http.post(
          Uri.parse('${AppConstants.INCIDENT_SECURETE_URL}/ValidIncid_aTraiter'),
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
  //incident a cloturer
  Future<List<dynamic>> getListIncidentSecuriteACloturer(matricule) async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.INCIDENT_SECURETE_URL}/listeIncidCloturer?mat=$matricule'),
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
      return Future.error('service Inc securite : ${exception.toString()}');
    }
  }
  Future<dynamic> validerIncidentSecuriteACloturer(Map data) async{
    try
    {
      print('data : ${json.encode(data)}');
      print(Uri.parse('${AppConstants.INCIDENT_SECURETE_URL}/ValidIncidCloturer'));
      var response = await http.post(
          Uri.parse('${AppConstants.INCIDENT_SECURETE_URL}/ValidIncidCloturer'),
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
  //action
  Future<List<dynamic>> getActionsIncidentSecurite(idFiche) async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.INCIDENT_SECURETE_URL}/ListActionIncidentSecu?Ref=$idFiche'),
          headers: {
            'Content-Type':'application/json'
          }
      );
      //print(AppConstants.ACTION_URL);
      //print('response incident securite : ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      }
      else {
        return Future.error(response.statusCode.toString());
      }
    }
    catch (exception) {
      return Future.error('service Inc Securite : ${exception.toString()}');
    }
  }
  Future<dynamic> saveActionIncidentSecurite(Map data) async{
    try
    {
      print('data : ${json.encode(data)}');
      print(Uri.parse('${AppConstants.INCIDENT_SECURETE_URL}/AddActionIncidentSecu'));
      var response = await http.post(
          Uri.parse('${AppConstants.INCIDENT_SECURETE_URL}/AddActionIncidentSecu'),
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
  Future<dynamic> deleteActionIncidentSecuriteById(idAction, idFiche) async {
    try {
      print('${AppConstants.INCIDENT_SECURETE_URL}/DeleteActionIncidentSecu?Nact=$idAction&Ref=$idFiche');
      var response = await http.delete(
          Uri.parse('${AppConstants.INCIDENT_SECURETE_URL}/DeleteActionIncidentSecu?Nact=$idAction&Ref=$idFiche'),
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
      return Future.error('service Inc Securite : ${exception.toString()}');
    }
  }
}