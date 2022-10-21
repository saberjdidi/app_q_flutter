import 'dart:convert';
import 'package:get/get.dart';
import '../../Utils/constants.dart';
import 'package:http/http.dart' as http;

class PNCService {
  // Fetch Data
  Future<List<dynamic>> getPNC(matricule) async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.PNC_URL}/getPNCListe?mat=$matricule'),
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

  Future<dynamic> savePNC(Map data) async{
    try
    {
      print('data : ${json.encode(data)}');
      print(Uri.parse('${AppConstants.PNC_URL}/addPNC'));
      var response = await http.post(
          Uri.parse('${AppConstants.PNC_URL}/addPNC'),
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
  //get pnc by nnc
  Future<dynamic> getPNCByNNC(nnc) async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.PNC_URL}/getNCbynnc?nnc=$nnc'),
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
  //type cause of pnc
  Future<List<dynamic>> getTypesCausesOfPNC(nnc) async {
    try {
      print('${AppConstants.PNC_URL}/listeTypeCauseByNnc?nnc=$nnc');
      var response = await http.get(
          Uri.parse('${AppConstants.PNC_URL}/listeTypeCauseByNnc?nnc=$nnc'),
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
  Future<List<dynamic>> getTypesCausesToAdded(nnc) async {
    try {
      print('${AppConstants.PNC_URL}/listeTypecauseaAjoute?nnc=$nnc');
      var response = await http.get(
          Uri.parse('${AppConstants.PNC_URL}/listeTypecauseaAjoute?nnc=$nnc'),
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
  Future<dynamic> addTypeCauseByNNC(Map data) async{
    try
    {
      print('data : ${json.encode(data)}');
      var response = await http.post(
          Uri.parse('${AppConstants.PNC_URL}/addTypeCausePnc'),
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
  Future<dynamic> deleteTypeCausePNCByID(id) async {
    try {
      print('${AppConstants.PNC_URL}/deleteTypeCausePNC/$id');
      var response = await http.delete(
          Uri.parse('${AppConstants.PNC_URL}/deleteTypeCausePNC/$id'),
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
  //decideur pnc
  Future<List<dynamic>> getDecideurPNC(site, processus) async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.PNC_URL}/listDecideur?site=$site&processus=$processus'),
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
  Future<List<dynamic>> getDecideurByNNC(nnc) async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.PNC_URL}/listDecideurByNNC?nnc=$nnc'),
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
  Future<dynamic> saveProduct(Map data) async{
    try
    {
      print('data : ${json.encode(data)}');
       var response = await http.post(
          Uri.parse('${AppConstants.PNC_URL}/addProduitFicheNc'),
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
  //parametrage product
  Future<dynamic> parametrageProduct() async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.PNC_URL}/isUnSeulProduit'),
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
  //get product pnc
  Future<List<dynamic>> getProductsPNC(nnc, matricule) async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.PNC_URL}/listProduitNc?nnc=$nnc&mat=$matricule'),
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
    }
    catch (exception) {
      return Future.error('service : ${exception.toString()}');
    }
  }
  Future<List<dynamic>> getProductsPNCARattacher(nnc, mat) async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.PNC_URL}/listProductNNCARattacher?nnc=$nnc&numPage=300&mat=$mat'),
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
    }
    catch (exception) {
      return Future.error('service : ${exception.toString()}');
    }
  }
  //get all product of pnc
  Future<List<dynamic>> getAllProductsPNC(nnc) async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.PNC_URL}/ListeProduitByNC?NNC=$nnc'),
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
  //add product pnc
  Future<dynamic> addProductNC(Map data) async{
    try
    {
      print('data : ${json.encode(data)}');
      var response = await http.post(
          Uri.parse('${AppConstants.PNC_URL}/addNcProduit'),
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
  Future<dynamic> deleteProductNCByID(id) async {
    try {
      print('${AppConstants.PNC_URL}/deleteProduitPNC/$id');
      var response = await http.delete(
          Uri.parse('${AppConstants.PNC_URL}/deleteProduitPNC/$id'),
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
  //type product nc
  Future<List<dynamic>> getTypeProductNC(nnc, product) async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.PNC_URL}/listTypeNc?nnc=$nnc&codeproduit=$product'),
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
  //add type product pnc
  Future<dynamic> addTypeProductNC(Map data) async{
    try
    {
      print('data : ${json.encode(data)}');
      var response = await http.post(
          Uri.parse('${AppConstants.PNC_URL}/addTypePourcentage'),
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

  //responsable traitement
  Future<List<dynamic>> getResponsableTraitementByNNC(nnc) async {
    try {
      print('${AppConstants.PNC_URL}/listNcRresponsableTraitement?nnc=$nnc');
      var response = await http.get(
          Uri.parse('${AppConstants.PNC_URL}/listNcRresponsableTraitement?nnc=$nnc'),
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
  Future<dynamic> addResponsableTraitement(Map data) async{
    try
    {
      print('data : ${json.encode(data)}');
      print('${AppConstants.PNC_URL}/addResponsableTraitement');
      var response = await http.post(
          Uri.parse('${AppConstants.PNC_URL}/addResponsableTraitement'),
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
  Future<dynamic> deleteResponsableTraitementByID(id) async {
    try {
      print('${AppConstants.PNC_URL}/deleteRespTraitement/$id');
      var response = await http.delete(
          Uri.parse('${AppConstants.PNC_URL}/deleteRespTraitement/$id'),
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
  //Agenda
  //pnc a traiter
  Future<List<dynamic>> getPNCATraiter(Map data) async {
    print('data : ${json.encode(data)}');
    try {
      var response = await http.post(
          Uri.parse('${AppConstants.PNC_URL}/liste_nc_a_traiter'),
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
  Future<List<dynamic>> getProductsOfPNCTraiter(nnc) async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.PNC_URL}/ncProduit?nnc=$nnc'),
          headers: {
            'Content-Type':' application/json'
          }
      );
      print('${AppConstants.PNC_URL}/ncProduit?nnc=$nnc');
      print('response ProductsOfPNCTraiter : ${jsonDecode(response.body)}');
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
  Future<dynamic> remplirPNCTraitement1(Map data) async{
    try
    {
      print('data : ${json.encode(data)}');
      print('${AppConstants.PNC_URL}/valid_Traitement');
      var response = await http.post(
          Uri.parse('${AppConstants.PNC_URL}/valid_Traitement'),
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
  Future<dynamic> remplirPNCTraitement2(Map data) async{
    try
    {
      print('data : ${json.encode(data)}');
      print('${AppConstants.PNC_URL}/update_resp_traitement');
      var response = await http.post(
          Uri.parse('${AppConstants.PNC_URL}/update_resp_traitement'),
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

  //pnc a corriger
  Future<List<dynamic>> getPNCACorriger(matricule) async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.PNC_URL}/liste_nc_a_corriger?mat=$matricule'),
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
  Future<dynamic> remplirPNCACorriger(Map data) async{
    try
    {
      print('data : ${json.encode(data)}');
      print('${AppConstants.PNC_URL}/ValiderNCaCorriger');
      var response = await http.post(
          Uri.parse('${AppConstants.PNC_URL}/ValiderNCaCorriger'),
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
  Future<dynamic> updatePncValidationCorriger(Map data) async{
    try
    {
      print('data : ${json.encode(data)}');
      print('${AppConstants.PNC_URL}/updatePncValidationCorriger');
      var response = await http.post(
          Uri.parse('${AppConstants.PNC_URL}/updatePncValidationCorriger'),
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
  //pnc a valider
  Future<List<dynamic>> getPNCAValider(matricule) async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.PNC_URL}/liste_nc_avalider?mat=$matricule'),
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
  Future<dynamic> updatePNCValidation(Map data) async{
    try
    {
      print('data : ${json.encode(data)}');
      var response = await http.post(
          Uri.parse('${AppConstants.PNC_URL}/pnc_update_validation'),
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
  //pnc a suivre
  Future<List<dynamic>> getPNCASuivre(matricule) async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.PNC_URL}/liste_nc_a_Suivre?mat=$matricule'),
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
  Future<dynamic> remplirPNCSuivre(Map data) async{
    try
    {
      print('data : ${json.encode(data)}');
      print('${AppConstants.PNC_URL}/CloturePNC');
      var response = await http.post(
          Uri.parse('${AppConstants.PNC_URL}/CloturePNC'),
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
  //pnc investigation effectuer
  Future<List<dynamic>> getPNCInvestigationEffectuer(matricule) async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.PNC_URL}/listeInvestigationEffectue?mat=$matricule'),
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
  //pnc investigation approuver
  Future<List<dynamic>> getPNCInvestigationApprouver(matricule) async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.PNC_URL}/listInvestigation_a_approuver?mat=$matricule'),
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
  Future<dynamic> remplirPNCInvestigation(Map data) async{
    try
    {
      print('data : ${json.encode(data)}');
      print('${AppConstants.PNC_URL}/modifierInvestigation');
      var response = await http.post(
          Uri.parse('${AppConstants.PNC_URL}/modifierInvestigation'),
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
  //pnc traitement decision
  Future<List<dynamic>> getPNCTraitementDecision(matricule) async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.PNC_URL}/getlisteTraitementDecision?mat=$matricule'),
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
  Future<dynamic> validerPNCTraitementDecision(Map data) async{
    try
    {
      print('data : ${json.encode(data)}');
      print('${AppConstants.PNC_URL}/validerDecisionTraitement');
      var response = await http.post(
          Uri.parse('${AppConstants.PNC_URL}/validerDecisionTraitement'),
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
  //type traitement
  Future<List<dynamic>> getTypeTraitement() async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.PNC_URL}/listeTypeTraitement'),
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
  //pnc valid decision traitement
  Future<List<dynamic>> getPNCValiderDecisionTraitement(matricule) async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.PNC_URL}/ListeDecisionTraitementValider?mat=$matricule'),
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
  Future<dynamic> validDecisionTraitementPNC(Map data) async{
    try
    {
      print('${AppConstants.PNC_URL}/validDecisionTraitementValider');
      print('data : ${json.encode(data)}');
      var response = await http.post(
          Uri.parse('${AppConstants.PNC_URL}/validDecisionTraitementValider'),
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
  //approbation finale
  Future<List<dynamic>> getApprobationFinale(matricule) async {
    try {
      var response = await http.get(
          Uri.parse('${AppConstants.PNC_URL}/listeApprobFinale?mat=$matricule'),
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
  Future<dynamic> validerApprobationFinale(Map data) async{
    try
    {
      print('data : ${json.encode(data)}');
      var response = await http.post(
          Uri.parse('${AppConstants.PNC_URL}/modifApprobFinale'),
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