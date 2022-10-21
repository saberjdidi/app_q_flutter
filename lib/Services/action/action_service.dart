import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../Models/action/action_model.dart';
import '../../Utils/constants.dart';
import 'package:http/http.dart' as http;

class ActionService extends GetConnect {
  // Fetch Data
  Future<List<ActionModel>> getAction(numAction, action , matricule, type) async {
    print('body : ${json.encode({
      "nact": numAction,
      "act": action,
      "refaud": "",
      "mat": matricule,
      "action_plus0": "",
      "action_plus1": "",
      "typeAction": type
    })}');
    print(Uri.parse('${AppConstants.ACTION_URL}/ListeAction'));

    try {
      var response = await http.post(
          Uri.parse('${AppConstants.ACTION_URL}/ListeAction'),
          body: json.encode({
            "nact": numAction,
            "act": action,
            "refaud": "",
            "mat": matricule,
            "action_plus0": "",
            "action_plus1": "",
            "typeAction": type
          }),
          headers: {
            'Content-Type':' application/json'
          }
      );
      //print(AppConstants.ACTION_URL);
      //print('response ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        final List result = jsonDecode(
            response.body); //jsonDecode(response.body)['data'];
        return result.map((
                (e) => ActionModel.fromJson(e)
        )).toList();
      }
      else {
        return Future.error(response.statusCode.toString());
      }
    }
    catch (exception) {
      return Future.error('service action : ${exception.toString()}');
    }
  }

  Future<List<dynamic>> getActionMethod2(Map data) async {
    print('data : ${json.encode(data)}');
    print(Uri.parse('${AppConstants.ACTION_URL}/ListeAction'));
    try {
      var response = await http.post(
          Uri.parse('${AppConstants.ACTION_URL}/ListeAction'),
          body: json.encode(data),
        headers: {
          'Content-Type':' application/json'
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
      /* final response = await post(
          AppConstants.ACTION_URL,
          body,
          headers: {
            'Content-Type':' application/json'
          }
      );
      print(AppConstants.ACTION_URL);
      print('response ${response.body}');
      if (response.statusCode == 200) {
        return await response.body;
      }
      else {
        return Future.error(response.statusText.toString());
      } */
    }
    catch (exception) {
      return Future.error('service : ${exception.toString()}');
    }
  }

  Future<dynamic> saveAction(Map data) async{
    try
    {
      print('data : ${json.encode(data)}');
      print(Uri.parse('${AppConstants.ACTION_URL}/addAction'));
      var response = await http.post(
        //Uri.parse('${AppConstants.ACTION_URL}/addActionTest2'),
          Uri.parse('${AppConstants.ACTION_URL}/addAction'),
          body: json.encode(data),
          headers: {
            'Content-Type':' application/json'
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
    /*  Response response = await post(
          AppConstants.ACTION_URL,
          data,
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
      } */
    }
    catch(exception)
    {
      return Future.error(exception.toString());
    }
  }

  //sous action
  Future<List<dynamic>> getSousAction(id) async {
    //print('${AppConstants.SOUS_ACTION_URL}/getListeSousAction?nac=$id');
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.SOUS_ACTION_URL}/getListeSousAction?nac=$id'),
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
      /* final response = await post(
          AppConstants.ACTION_URL,
          body,
          headers: {
            'Content-Type':' application/json'
          }
      );
      print(AppConstants.ACTION_URL);
      print('response ${response.body}');
      if (response.statusCode == 200) {
        return await response.body;
      }
      else {
        return Future.error(response.statusText.toString());
      } */
    }
    catch (exception) {
      return Future.error('service : ${exception.toString()}');
    }
  }
  Future<dynamic> saveSousAction(Map data) async{
    try
    {
      print('data : ${json.encode(data)}');
      var response = await http.post(
          Uri.parse('${AppConstants.SOUS_ACTION_URL}/addSousAction'),
          body: json.encode(data),
          headers: {
            'Content-Type':' application/json'
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
      /*  Response response = await post(
          AppConstants.ACTION_URL,
          data,
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
      } */
    }
    catch(exception)
    {
      return Future.error(exception.toString());
    }
  }

  //intervenants
  Future<List<dynamic>> getIntervenant(id_action, id_sous_action) async {
    print('${AppConstants.ACTION_URL}/listeEmployesIntervenants?nact=$id_action&nsact=$id_sous_action');
    try {
      var response = await http.post(
          Uri.parse('${AppConstants.ACTION_URL}/listeEmployesIntervenants?nact=$id_action&nsact=$id_sous_action'),
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
      return Future.error('service : ${exception.toString()}');
    }
  }
  //list employe a rattaché
  Future<List<dynamic>> getIntervenantEmploye(Map data) async {
    try {
      var response = await http.post(
          Uri.parse('${AppConstants.ACTION_URL}/listeEmployesNonIntervenants'),
          body: json.encode(data),
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
      return Future.error('service : ${exception.toString()}');
    }
  }
  Future<dynamic> saveIntervenant(nact, nsact, liste) async{
    try
    {
      print('url : ${AppConstants.ACTION_URL}/AjoutListeIntervenants?nact=$nact&nsact=$nsact&liste=$liste');
      var response = await http.post(
          Uri.parse('${AppConstants.ACTION_URL}/AjoutListeIntervenants?nact=$nact&nsact=$nsact&liste=$liste'),
          headers: {
            'Content-Type':' application/json'
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

  //action realisation
  Future<List<dynamic>> getActionRealisation(Map data) async {
    print('data : ${json.encode(data)}');
    try {
      var response = await http.post(
          Uri.parse('${AppConstants.ACTION_URL}/Action_realisation'),
          body: json.encode(data),
          headers: {
            'Content-Type':' application/json'
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
      return Future.error('service : ${exception.toString()}');
    }
  }
  Future<dynamic> saveActionRealisation(Map data) async{
    try
    {
      print('data : ${json.encode(data)}');
      //print('url : ${AppConstants.ACTION_URL}/remplir_action_realisation');
      var response = await http.post(
          Uri.parse('${AppConstants.ACTION_URL}/remplir_action_realisation'),
          body: json.encode(data),
          headers: {
            'Content-Type':' application/json'
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
  Future<dynamic> saveActionRealisationOfProject(Map data) async{
    try
    {
      print('data : ${json.encode(data)}');
      var response = await http.post(
          Uri.parse('${AppConstants.ACTION_URL}/RemplirActionRealisationFicheProjet'),
          body: json.encode(data),
          headers: {
            'Content-Type':' application/json'
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
  Future<dynamic> getIdProjectOfAction(num_action) async{
    try
    {
      print('url : ${AppConstants.ACTION_URL}/getProjectID?NumAction=$num_action');
      var response = await http.get(
          Uri.parse('${AppConstants.ACTION_URL}/getProjectID?NumAction=$num_action'),
          headers: {
            'Content-Type':' application/json'
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
  Future<dynamic> saveActionRealisation2(commentaire, pourcent_real, depense, n_sous_act, n_act) async{
    try
    {
      print('url : ${AppConstants.ACTION_URL}/remplir_action_realisation?Commentaire=$commentaire&PourcentReal=$pourcent_real&depense=$depense&NSousAct=$n_sous_act&NAct=$n_act');
      var response = await http.post(
          Uri.parse('${AppConstants.ACTION_URL}/remplir_action_realisation?Commentaire=$commentaire&PourcentReal=$pourcent_real&depense=$depense&NSousAct=$n_sous_act&NAct=$n_act'),
          headers: {
            'Content-Type':' application/json'
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

  //action suivi
  Future<List<dynamic>> getActionSuivi(Map data) async {
    print('data : ${json.encode(data)}');
    try {
      var response = await http.post(
          Uri.parse('${AppConstants.SOUS_ACTION_URL}/GetAction_suivie'),
          body: json.encode(data),
          headers: {
            'Content-Type':' application/json'
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
      return Future.error('service : ${exception.toString()}');
    }
  }
  Future<dynamic> saveActionSuivi(Map data) async{
    try
    {
      print('data : ${json.encode(data)}');
      print('url : ${AppConstants.SOUS_ACTION_URL}/UpdateAction_Suivre');
      var response = await http.post(
          Uri.parse('${AppConstants.SOUS_ACTION_URL}/UpdateAction_Suivre'),
          body: json.encode(data),
          headers: {
            'Content-Type':' application/json'
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

  //action suite audit
  Future<List<dynamic>> getActionSuiteAudit(mat) async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.ACTION_URL}/list_Action_Audit?mat=$mat'),
          headers: {
            'Content-Type':' application/json'
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
      return Future.error('service : ${exception.toString()}');
    }
  }
  //taux realisation
  Future<dynamic> updateTauxRealisation(Map data) async{
    try
    {
      print('data : ${json.encode(data)}');
      print('url : ${AppConstants.SOUS_ACTION_URL}/UpdateTauxRealisation');
      var response = await http.post(
          Uri.parse('${AppConstants.SOUS_ACTION_URL}/UpdateTauxRealisation'),
          body: json.encode(data),
          headers: {
            'Content-Type':' application/json'
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
  //upload image sous action
  Future<dynamic> uploadImageSousAction(Map data) async{
    try
    {
      print('data : ${json.encode(data)}');
      //print('url : ${AppConstants.UPLOAD_URL}/uploadImgSousAction');
      var response = await http.post(
          Uri.parse('${AppConstants.UPLOAD_URL}/uploadImgSousAction'),
          body: json.encode(data),
          headers: {
            'Content-Type':' application/json'
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
  //products of action
  Future<List<dynamic>> getProductsOfAction(mat, num_action) async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.ACTION_URL}/produitByNactMat?Mat=$mat&NumAction=$num_action'),
          headers: {
            'Content-Type':' application/json'
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
      return Future.error('service : ${exception.toString()}');
    }
  }
  Future<dynamic> deleteProductActionById(id) async {
    try {
      print('${AppConstants.ACTION_URL}/deleteProduit/$id');
      var response = await http.delete(
          Uri.parse('${AppConstants.ACTION_URL}/deleteProduit/$id'),
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
  //type cause of action
  Future<List<dynamic>> getTypesCausesOfAction(mat, num_action, online) async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.ACTION_URL}/typeCauseActionByNact?Mat=$mat&NumAction=$num_action&online=$online'),
          headers: {
            'Content-Type':'application/json'
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
      return Future.error('service : ${exception.toString()}');
    }
  }
  Future<List<dynamic>> getTypesCauseActionARattacher(mat, num_action) async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.ACTION_URL}/listTypeCauseARattacher?mat=$mat&numAction=$num_action'),
          headers: {
            'Content-Type':'application/json'
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
      return Future.error('service : ${exception.toString()}');
    }
  }
  Future<dynamic> saveTypeCauseAction(int? nAct, int? codeTypeCause) async {
    try {
      debugPrint('${AppConstants.ACTION_URL}/ajoutTypeCauseAction?nAction=$nAct&codeTypeCause=$codeTypeCause');
      var response = await http.post(
          Uri.parse('${AppConstants.ACTION_URL}/ajoutTypeCauseAction?nAction=$nAct&codeTypeCause=$codeTypeCause'),
          headers: {
            'Content-Type':'application/json'
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
      return Future.error('service : ${exception.toString()}');
    }
  }
  Future<dynamic> deleteTypeCauseActionById(id) async {
    try {
      print('${AppConstants.ACTION_URL}/deleteTypeCause/$id');
      var response = await http.delete(
          Uri.parse('${AppConstants.ACTION_URL}/deleteTypeCause/$id'),
          headers: {
            'Content-Type':' application/json'
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
}