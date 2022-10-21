import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:qualipro_flutter/Models/audit/audit_model.dart';
import 'package:qualipro_flutter/Utils/snack_bar.dart';
import '../../Utils/constants.dart';
import '../../Utils/shared_preference.dart';
import 'package:http/http.dart' as http;

class AuditService {

  final matricule = SharedPreference.getMatricule();
  //fetch data
  Future<List<AuditModel>> getAudits() async {
    try {
      Response response = await get(
          Uri.parse('${AppConstants.AUDIT_URL}/GetListAudit?mat=$matricule'),
          headers: {
            'Content-Type': 'application/json'
          }
      );
      if (response.statusCode == 200) {
        final List result = jsonDecode(
            response.body); //jsonDecode(response.body)['data'];
        return result.map((
                (e) => AuditModel.fromJson(e)
        )).toList();
      }
      else {
        throw Exception(response.reasonPhrase);
      }
    }
    catch (exception) {
      return Future.error('service audit : ${exception.toString()}');
    }
  }
  //search
  Future<List<AuditModel>> searchAudit(idAudit, etat, type) async {
    try {
      if(kDebugMode){
        print(Uri.parse('${AppConstants.AUDIT_URL}/GetListAudit?mat=$matricule&idAudit=$idAudit&etat=$etat&typeA=$type'));
      }
      Response response = await get(
          Uri.parse('${AppConstants.AUDIT_URL}/GetListAudit?mat=$matricule&idAudit=$idAudit&etat=$etat&typeA=$type'),
          headers: {
            'Content-Type': 'application/json'
          }
      );
      if (response.statusCode == 200) {
        final List result = jsonDecode(
            response.body); //jsonDecode(response.body)['data'];
        return result.map((
                (e) => AuditModel.fromJson(e)
        )).toList();
      }
      else {
        throw Exception(response.reasonPhrase);
      }
    }
    catch (exception) {
      return Future.error('service audit : ${exception.toString()}');
    }
  }
  //save
  Future<dynamic> saveAudit(Map data) async{
    try
    {
      print('data : ${json.encode(data)}');
      print(Uri.parse('${AppConstants.AUDIT_URL}/AddAudit'));
      var response = await http.post(
          Uri.parse('${AppConstants.AUDIT_URL}/AddAudit'),
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
  //get audit by ref
  Future<dynamic> getAuditByRefAudit(refAudit) async {
    try {
      Response response = await get(
          Uri.parse('${AppConstants.AUDIT_URL}/AuditByRefAudit/$refAudit'),
          headers: {
            'Content-Type': 'application/json'
          }
      );
      if (response.statusCode == 200) {
        return await jsonDecode(response.body);
      }
      else {
        return Future.error(response.statusCode.toString());
      }
    }
    catch (exception) {
      return Future.error('service audit : ${exception.toString()}');
    }
  }
  //constat
  Future<List<dynamic>> getConstatAudit(refAudit, mode) async {
    try {
      if(kDebugMode) print(Uri.parse('${AppConstants.AUDIT_URL}/GetListConstat?RefAudit=$refAudit&Mode=$mode'));
      var response = await http.get(
          Uri.parse('${AppConstants.AUDIT_URL}/GetListConstat?RefAudit=$refAudit&Mode=$mode'),
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
      return Future.error('service audit: ${exception.toString()}');
    }
  }
  Future<dynamic> saveConstatAudit(Map data) async {
    try
    {
      print('data : ${json.encode(data)}');
      print(Uri.parse('${AppConstants.AUDIT_URL}/AddConstat'));
      var response = await http.post(
          Uri.parse('${AppConstants.AUDIT_URL}/AddConstat'),
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
  Future<dynamic> deleteConstatAudit(idEcart, nAct, refAudit) async {
    try {
      print('${AppConstants.AUDIT_URL}/deleteConstatAudit?idEcart=$idEcart&nAct=$nAct&refAudit=$refAudit');
      var response = await http.delete(
          Uri.parse('${AppConstants.AUDIT_URL}/deleteConstatAudit?idEcart=$idEcart&nAct=$nAct&refAudit=$refAudit'),
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
      return Future.error('service audit : ${exception.toString()}');
    }
  }
  //max num constat
  Future<dynamic> getMaxConstatAudit() async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.AUDIT_URL}/MaxActAudit'),
          headers: {
            'Content-Type':'application/json'
          }
      );
      if(response.statusCode == 200){
        return await jsonDecode(response.body);
      }
      else {
        return Future.error(response.statusCode.toString());
      }
    }
    catch(exception){
      return Future.error('service audit : ${exception.toString()}');
    }
  }
  //champ audit
  Future<List<dynamic>> getChampAudit(matricule) async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.AUDIT_URL}/ListChampsAudit?Mat=$matricule'),
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
      return Future.error('service audit : ${exception.toString()}');
    }
  }
  //champ audit
  Future<List<dynamic>> getChampAuditByFiche(refAudit) async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.AUDIT_URL}/ListChampsAuditAjoutes?RefAudit=$refAudit'),
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
      return Future.error('service audit : ${exception.toString()}');
    }
  }
  //type audit
  Future<List<dynamic>> getTypeAudit(matricule) async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.AUDIT_URL}/ListeTypeAudit?Mat=$matricule'),
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
      return Future.error('service audit : ${exception.toString()}');
    }
  }
  //gravite
  Future<List<dynamic>> getGraviteAudit() async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.AUDIT_URL}/GraviteConstatAudit'),
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
      return Future.error('service audit : ${exception.toString()}');
    }
  }
  //type constat
  Future<List<dynamic>> getTypeConstatAudit() async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.AUDIT_URL}/TypeConstat'),
          headers: {
            'Content-Type':'application/json'
          }
      );
      if(response.statusCode == 200){
        return await jsonDecode(response.body);
      }
      else {
        return Future.error(response.statusCode.toString());
      }
    }
    catch(exception){
      return Future.error('service audit : ${exception.toString()}');
    }
  }
  //person of constat
  Future<List<dynamic>> getPersonConstatAudit(refAudit, matricule) async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.AUDIT_URL}/PersonneConcerneeConstat?RefAudit=$refAudit&Mat=$matricule'),
          headers: {
            'Content-Type':'application/json'
          }
      );
      if(kDebugMode) print('response : ${response.body}');
      if(response.statusCode == 200){
        return await jsonDecode(response.body);
      }
      else {
        return Future.error(response.statusCode.toString());
      }
    }
    catch(exception){
      return Future.error('service audit : ${exception.toString()}');
    }
  }
  //auditeur interne
  Future<List<dynamic>> getAuditeurInterne(refAudit) async {
    try {
      if(kDebugMode) print(Uri.parse('${AppConstants.AUDIT_URL}/ListeAuditeursInternes?Ref=$refAudit'));
      var response = await http.get(
          Uri.parse('${AppConstants.AUDIT_URL}/ListeAuditeursInternes?Ref=$refAudit'),
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
      return Future.error('service audit: ${exception.toString()}');
    }
  }
  Future<List<dynamic>> getAuditeurInterneToAdd(refAudit) async {
    try {
     if(kDebugMode) print(Uri.parse('${AppConstants.AUDIT_URL}/ListeAuditeursInternes_aAjoutes?Ref=$refAudit'));
      var response = await http.get(
          Uri.parse('${AppConstants.AUDIT_URL}/ListeAuditeursInternes_aAjoutes?Ref=$refAudit'),
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
      return Future.error('service audit: ${exception.toString()}');
    }
  }
  Future<dynamic> saveAuditeurInterne(Map data) async{
    try
    {
      if(kDebugMode){
        print('data : ${json.encode(data)}');
        print(Uri.parse('${AppConstants.AUDIT_URL}/AddAuditeurInterne'));
      }
      var response = await http.post(
          Uri.parse('${AppConstants.AUDIT_URL}/AddAuditeurInterne'),
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
  Future<dynamic> deleteAutideurInterne(matricule, refAudit) async {
    try {
      print('${AppConstants.AUDIT_URL}/DeleteAuditeurInterne?Mat=$matricule&RefAudit=$refAudit');
      var response = await http.delete(
          Uri.parse('${AppConstants.AUDIT_URL}/DeleteAuditeurInterne?Mat=$matricule&RefAudit=$refAudit'),
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
      return Future.error('service audit : ${exception.toString()}');
    }
  }
  //auditeur externe
  Future<List<dynamic>> getAuditeurExterne(refAudit) async {
    try {
      if(kDebugMode) print(Uri.parse('${AppConstants.AUDIT_URL}/ListeAuditeursExternes?Ref=$refAudit'));
      var response = await http.get(
          Uri.parse('${AppConstants.AUDIT_URL}/ListeAuditeursExternes?Ref=$refAudit'),
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
      return Future.error('service audit: ${exception.toString()}');
    }
  }
  Future<List<dynamic>> getAuditeurExterneToAdd(refAudit) async {
    try {
      var response = await http.get(
        Uri.parse('${AppConstants.AUDIT_URL}/ListeAuditeursExternesaAjoutes?Ref=$refAudit'),
        headers: {
          'Content-Type':'application/json'
        }
      );
      if(response.statusCode == 200){
        return await jsonDecode(response.body);
      }
      else {
        return Future.error('status : ${response.statusCode.toString()}, body : ${response.body}');
      }
    }
    catch(exception){
      return Future.error('service auditeur externe : ${exception.toString()}');
    }
  }

  Future<dynamic> saveAuditeurExterne(Map data) async{
    try
    {
      print('data : ${json.encode(data)}');
      print(Uri.parse('${AppConstants.AUDIT_URL}/AddAuditeurExterne'));
      var response = await http.post(
          Uri.parse('${AppConstants.AUDIT_URL}/AddAuditeurExterne'),
          body: json.encode(data),
          headers: {
            'Content-Type':'application/json'
          }
      );
      //print(AppConstants.ACTION_URL);
      print('response : ${jsonDecode(response.body)}');
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
  Future<dynamic> deleteAuditeurExterne(code, refAudit) async {
    try {
     if(kDebugMode) print('${AppConstants.AUDIT_URL}/DeleteAuditeurExterne?CodeAuditeur=$code&RefAudit=$refAudit');
      var response = await http.delete(
          Uri.parse('${AppConstants.AUDIT_URL}/DeleteAuditeurExterne?CodeAuditeur=$code&RefAudit=$refAudit'),
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
      return Future.error('service audit : ${exception.toString()}');
    }
  }
  //employe habilite audit
  Future<List<dynamic>> getEmployeHabiliteAudit(refAudit) async {
    try {
      if(kDebugMode) print(Uri.parse('${AppConstants.AUDIT_URL}/listEmployeHabiliteAudit?refAudit=$refAudit'));
      var response = await http.get(
          Uri.parse('${AppConstants.AUDIT_URL}/listEmployeHabiliteAudit?refAudit=$refAudit'),
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
      return Future.error('service audit: ${exception.toString()}');
    }
  }
  Future<dynamic> addEmployeHabiliteAudit(Map data) async {
    try {
      if(kDebugMode) print('data : ${json.encode(data)}');
      var response = await http.post(
        Uri.parse('${AppConstants.AUDIT_URL}/addEmployeHabiliteAudit'),
        body: json.encode(data),
        headers: {
          'Content-Type':'application/json'
        }
      );
      if(response.statusCode == 200){
        return await jsonDecode(response.body);
      }
      else {
        return Future.error(response.statusCode.toString());
      }
    }
    catch(exception) {
      return Future.error('service add employe habilte : ${exception.toString()}');
    }
  }
  Future<dynamic> deleteEmployeHabiliteAudit(refAudit, mat) async {
    try {
      if(kDebugMode) print('${AppConstants.AUDIT_URL}/deleteEmployeHabiliteAudit?refAudit=$refAudit&mat=$mat');
      var response = await http.delete(
        Uri.parse('${AppConstants.AUDIT_URL}/deleteEmployeHabiliteAudit?refAudit=$refAudit&mat=$mat'),
          headers: {
            'Content-Type':'application/json'
          }
      );
      if(response.statusCode == 200){
        return await jsonDecode(response.body);
      }
      else {
        return Future.error(response.statusCode.toString());
      }
    }
    catch(exception){
      return Future.error('service employe habilite : ${exception.toString()}');
    }
  }
  //checklist
  Future<List<dynamic>> getCheckListByRefAudit(refAudit) async {
    try {
      if(kDebugMode) print('${AppConstants.AUDIT_URL}/checkList?refAudit=$refAudit');
      var response = await http.get(
        Uri.parse('${AppConstants.AUDIT_URL}/checkList?refAudit=$refAudit'),
          headers: {
            'Content-Type':'application/json'
          }
      );
      if(response.statusCode == 200){
        return await jsonDecode(response.body);
      }
      else {
       return Future.error(response.statusCode.toString());
      }
    }
    catch(exception) {
      return Future.error('service checklist audit : ${exception.toString()}');
    }
  }
  //critere of checklist
  Future<List<dynamic>> getCritereOfCheckList(refAudit, idChamp) async {
    try {
      var response = await http.get(
        Uri.parse('${AppConstants.AUDIT_URL}/critereOfCheckList?refAudit=$refAudit&idChamp=$idChamp'),
          headers: {
            'Content-Type':'application/json'
          }
      );
      if(response.statusCode == 200){
        return await jsonDecode(response.body);
      }
      else {
        return Future.error(response.statusCode.toString());
      }
    }
    catch(exception){
      return Future.error('service critere checklist audit : ${exception.toString()}');
    }
  }
  Future<dynamic> evaluerCritereOfCheckList(Map data) async {
    try {
      if(kDebugMode) print('data : ${json.encode(data)}');
      var response = await http.post(
          Uri.parse('${AppConstants.AUDIT_URL}/evaluerCritereCheckList'),
          body: json.encode(data),
          headers: {
            'Content-Type':'application/json'
          }
      );
      if(response.statusCode == 200){
        return await jsonDecode(response.body);
      }
      else {
        return Future.error(response.statusCode.toString());
      }
    }
    catch(exception) {
      return Future.error('service add employe habilte : ${exception.toString()}');
    }
  }

  //Agenda
  //Audits EnTantQue Audite
  Future<List<dynamic>> getAuditsEnTantQueAudite() async {
    try {
      Response response = await get(
          Uri.parse('${AppConstants.AUDIT_URL}/ListeAuditEnTantQueAudite?Mat=$matricule'),
          headers: {
            'Content-Type': 'application/json'
          }
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      else {
        throw Exception(response.reasonPhrase);
      }
    }
    catch (exception) {
      return Future.error('service audite : ${exception.toString()}');
    }
  }
  Future<dynamic> getConfirmAuditAudite(refAudit, mode) async {
    try {
      Response response = await get(
          Uri.parse('${AppConstants.AUDIT_URL}/confirmAuditAudite?refAudit=$refAudit&mat=$matricule&mode=$mode'),
          headers: {
            'Content-Type': 'application/json'
          }
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      else {
        throw Exception(response.reasonPhrase);
      }
    }
    catch (exception) {
      return Future.error('service audite : ${exception.toString()}');
    }
  }
  Future<dynamic> confirmeAuditEnTantqueAudite(Map data) async {
    try{
      if(kDebugMode) print('data : ${json.encode(data)}');
      var response = await http.post(
        Uri.parse('${AppConstants.AUDIT_URL}/ValiderListeAuditEnTantQueAudite'),
        body: json.encode(data),
        headers: {
          'Content-Type': 'application/json'
        }
      );
      if(response.statusCode == 200){
        return await jsonDecode(response.body);
      }
      else {
        return Future.error(response.statusCode.toString());
      }
    }
    catch(exception){
      return Future.error('service confirme audit : ${exception.toString()}');
    }
  }
  //Audits EnTantQue Auditeur
  Future<List<dynamic>> getAuditsEnTantQueAuditeur() async {
    try {
      Response response = await get(
          Uri.parse('${AppConstants.AUDIT_URL}/ListeAuditEnTantQueAuditeur?Mat=$matricule'),
          headers: {
            'Content-Type': 'application/json'
          }
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      else {
        throw Exception(response.reasonPhrase);
      }
    }
    catch (exception) {
      return Future.error('service auditeur : ${exception.toString()}');
    }
  }
  Future<dynamic> confirmeAuditEnTantqueAuditeur(Map data) async {
    try{
      if(kDebugMode) print('data : ${json.encode(data)}');
      var response = await http.post(
          Uri.parse('${AppConstants.AUDIT_URL}/ValiderListeAuditEnTantQueAuditeur'),
          body: json.encode(data),
          headers: {
            'Content-Type': 'application/json'
          }
      );
      if(response.statusCode == 200){
        return await jsonDecode(response.body);
      }
      else {
        return Future.error(response.statusCode.toString());
      }
    }
    catch(exception){
      return Future.error('service auditeur : ${exception.toString()}');
    }
  }
  //rapport audit a valider
  Future<List<dynamic>> getRapportAuditsAValider() async {
    try {
      Response response = await get(
          Uri.parse('${AppConstants.AUDIT_URL}/RapportAuditA_Valider?Mat=$matricule'),
          headers: {
            'Content-Type': 'application/json'
          }
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      else {
        throw Exception(response.reasonPhrase);
      }
    }
    catch (exception) {
      return Future.error('service auditeur : ${exception.toString()}');
    }
  }
  Future<dynamic> validerRapportAudit(refAudit) async {
    try{
      var response = await http.put(
          Uri.parse('${AppConstants.AUDIT_URL}/validerRapportAudit?RefAudit=$refAudit'),
          headers: {
            'Content-Type': 'application/json'
          }
      );
      if(response.statusCode == 200){
        return await jsonDecode(response.body);
      }
      else {
        return Future.error(response.statusCode.toString());
      }
    }
    catch(exception){
      return Future.error('service audit : ${exception.toString()}');
    }
  }
  Future<dynamic> validerAuditActionProv(Map data) async {
    try {
      if(kDebugMode) print('data : ${json.encode(data)}');
      var response = await http.post(
          Uri.parse('${AppConstants.AUDIT_URL}/validerAuditActionProv'),
          body: json.encode(data),
          headers: {
            'Content-Type': 'application/json'
          }
      );
      if(response.statusCode == 200){
        return await jsonDecode(response.body);
      }
      else {
        return Future.error(response.statusCode.toString());
      }
    }
    catch(exception){
      return Future.error('service audit : ${exception.toString()}');
    }
  }
  Future<dynamic> envoyerRapportAudit(refAudit) async {
    try{
      var response = await http.put(
          Uri.parse('${AppConstants.AUDIT_URL}/envoyerRapportAudit?RefAudit=$refAudit'),
          headers: {
            'Content-Type': 'application/json'
          }
      );
      if(response.statusCode == 200){
        return await jsonDecode(response.body);
      }
      else {
        return Future.error(response.statusCode.toString());
      }
    }
    catch(exception){
      return Future.error('service audit : ${exception.toString()}');
    }
  }
  Future<List<dynamic>> verifierRapportAuditParMode(Map data) async {
    try {
      debugPrint('${AppConstants.AUDIT_URL}/verifierRapportAuditParMode');
      if(kDebugMode) print('data rapport audit : ${json.encode(data)}');
      var response = await http.post(
          Uri.parse('${AppConstants.AUDIT_URL}/verifierRapportAuditParMode'),
          body: json.encode(data),
          headers: {
            'Content-Type': 'application/json'
          }
      );
      if(response.statusCode == 200){
        return await jsonDecode(response.body);
      }
      else {
        return Future.error(response.statusCode.toString());
      }
    }
    catch(exception){
      return Future.error('service audit : ${exception.toString()}');
    }
  }
  Future<dynamic> ajoutEnregEmpValidAudit(Map data) async {
    try {
      debugPrint('${AppConstants.AUDIT_URL}/ajoutEnregEmpValidAudit');
      if(kDebugMode) print('insert employe validation : ${json.encode(data)}');
      var response = await http.post(
          Uri.parse('${AppConstants.AUDIT_URL}/ajoutEnregEmpValidAudit'),
          body: json.encode(data),
          headers: {
            'Content-Type': 'application/json'
          }
      );
      if(response.statusCode == 200){
        return await jsonDecode(response.body);
      }
      else {
        return Future.error(response.statusCode.toString());
      }
    }
    catch(exception){
      return Future.error('service audit : ${exception.toString()}');
    }
  }
}