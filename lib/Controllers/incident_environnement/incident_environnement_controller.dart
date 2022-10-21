import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../Models/incident_environnement/incident_env_model.dart';
import '../../Models/type_incident_model.dart';
import '../../Services/incident_environnement/incident_environnement_service.dart';
import '../../Services/incident_environnement/local_incident_environnement_service.dart';
import '../../Utils/shared_preference.dart';
import '../../Utils/snack_bar.dart';
import '../api_controllers_call.dart';
import '../sync_data_controller.dart';

class IncidentEnvironnementController extends GetxController {

  var listIncident = List<IncidentEnvModel>.empty(growable: true).obs;
  var filterIncident = List<IncidentEnvModel>.empty(growable: true);
  var isDataProcessing = false.obs;
  LocalIncidentEnvironnementService localIncidentEnvironnementService = LocalIncidentEnvironnementService();
  final matricule = SharedPreference.getMatricule();
  //search
  TextEditingController searchNumero = TextEditingController();
  TextEditingController searchDesignation = TextEditingController();
  //TextEditingController searchType = TextEditingController();
  String? searchCodeType = "";
  String? searchType = "";
  TypeIncidentModel? typeIncidentModel = null;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getIncident();
    //checkConnectivity();
    //search
    searchNumero.text = '';
    searchDesignation.text = '';
    //searchType.text ='';
  }

  Future<void> checkConnectivity() async {
    var connection = await Connectivity().checkConnectivity();
    if (connection == ConnectivityResult.none) {
      Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.BOTTOM);
    }
    else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
      Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.BOTTOM);

    }
  }

  void getIncident() async {
    try {
      isDataProcessing.value = true;
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        //get local data
        var response = await localIncidentEnvironnementService.readIncidentEnvironnement();
        response.forEach((data) {
          var model = IncidentEnvModel();
          model.online = data['online'];
          model.n = data['n'];
          model.incident = data['incident'];
          model.dateDetect = data['dateDetect'];
          model.lieu = data['lieu'];
          model.type = data['type'];
          model.source = data['source'];
          model.act = data['act'];
          model.secteur = data['secteur'];
          model.poste = data['poste'];
          model.site = data['site'];
          model.processus = data['processus'];
          model.domaine = data['domaine'];
          model.direction = data['direction'];
          model.service = data['service'];
          model.typeCause = data['typeCause'];
          model.typeConseq = data['typeConseq'];
          model.delaiTrait = data['delaiTrait'];
          model.traite = data['traite'];
          model.cloture = data['cloture'];
          model.categorie = data['categorie'];
          model.gravite = data['gravite'];
          model.statut = data['statut'];
          listIncident.add(model);

        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        //rest api
        await IncidentEnvironnementService().getIncident(matricule).then((resp) async {
          //isDataProcessing(false);
          resp.forEach((data) async {
            print('get incident : ${data} ');
            var model = IncidentEnvModel();
            model.online = 1;
            model.n = data['n'];
            model.incident = data['incident'];
            model.dateDetect = data['date_detect'];
            model.lieu = data['lieu'];
            if(model.lieu == null){
              model.lieu ="";
            }
            model.type = data['type'];
            model.source = data['source'];
            model.act = data['act'];
            model.secteur = data['secteur'];
            model.poste = data['poste'];
            model.site = data['site'];
            model.processus = data['processus'];
            model.domaine = data['domaine'];
            model.direction = data['direction'];
            model.service = data['service'];
            model.typeCause = data['type_cause'];
            model.typeConseq = data['type_conseq'];
            model.delaiTrait = data['delai_trait'];
            model.traite = data['traite'];
            model.cloture = data['cloture'];
            model.categorie = data['categorie'];
            model.gravite = data['gravite'];
            model.statut = data['statut'];
            listIncident.add(model);

          });
        }
            , onError: (err) {
              isDataProcessing.value = false;
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });
      }

    } catch (exception) {
      isDataProcessing.value = false;
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      print('Exception : ${exception.toString()}');
    }
    finally {
      isDataProcessing.value = false;
    }
  }
  void searchIncident() async {
    try {
      isDataProcessing.value = true;
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        //search local data
        var response = await localIncidentEnvironnementService.searchIncidentEnvironnement(searchNumero.text, searchType, searchDesignation.text);
        response.forEach((data) {
          var model = IncidentEnvModel();
          model.online = data['online'];
          model.n = data['n'];
          model.incident = data['incident'];
          model.dateDetect = data['dateDetect'];
          model.lieu = data['lieu'];
          model.type = data['type'];
          model.source = data['source'];
          model.act = data['act'];
          model.secteur = data['secteur'];
          model.poste = data['poste'];
          model.site = data['site'];
          model.processus = data['processus'];
          model.domaine = data['domaine'];
          model.direction = data['direction'];
          model.service = data['service'];
          model.typeCause = data['typeCause'];
          model.typeConseq = data['typeConseq'];
          model.delaiTrait = data['delaiTrait'];
          model.traite = data['traite'];
          model.cloture = data['cloture'];
          model.categorie = data['categorie'];
          model.gravite = data['gravite'];
          model.statut = data['statut'];
          listIncident.add(model);
          listIncident.forEach((element) {
            print('element incident ${element.n} - ${element.incident}');
          });
          searchNumero.clear();
          //searchType.clear();
          searchDesignation.clear();
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        //rest api
        await IncidentEnvironnementService().searchIncident(matricule, searchNumero.text, searchCodeType, searchDesignation.text).then((resp) async {
          //isDataProcessing(false);
          resp.forEach((data) async {
            print('search incident : ${data} ');
            var model = IncidentEnvModel();
            model.online = 1;
            model.n = data['n'];
            model.incident = data['incident'];
            model.dateDetect = data['date_detect'];
            model.lieu = data['lieu'];
            if(model.lieu == null){
              model.lieu ="";
            }
            model.type = data['type'];
            model.source = data['source'];
            model.act = data['act'];
            model.secteur = data['secteur'];
            model.poste = data['poste'];
            model.site = data['site'];
            model.processus = data['processus'];
            model.domaine = data['domaine'];
            model.direction = data['direction'];
            model.service = data['service'];
            model.typeCause = data['type_cause'];
            model.typeConseq = data['type_conseq'];
            model.delaiTrait = data['delai_trait'];
            model.traite = data['traite'];
            model.cloture = data['cloture'];
            model.categorie = data['categorie'];
            model.gravite = data['gravite'];
            model.statut = data['statut'];
            listIncident.add(model);
            listIncident.forEach((element) {
              print('element incident ${element.n} - ${element.incident}');
            });
              searchNumero.clear();
              searchDesignation.clear();
              searchCodeType = '';
          });
        }
            , onError: (err) {
              isDataProcessing.value = false;
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });
      }

    } catch (exception) {
      isDataProcessing.value = false;
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      print('Exception : ${exception.toString()}');
    }
    finally {
      isDataProcessing.value = false;
    }
  }

  //synchronization
  Future syncIncidentToWebService() async {
    try {
      DateTime dateNow = DateTime.now();
      isDataProcessing(true);
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        Get.snackbar("No Connection", "Cannot synchronize Data", colorText: Colors.blue,
            snackPosition: SnackPosition.TOP);
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {

        await SyncDataController().syncIncidentEnvironnementToSQLServer();
        await SyncDataController().syncTypeCauseIncEnvToSQLServer();
        await SyncDataController().syncTypeConsequenceIncEnvToSQLServer();
        //save data in db local
        await IncidentEnvironnementService().getIncident(matricule).then((resp) async {
          resp.forEach((data) async {
            var model = IncidentEnvModel();
            model.online = 1;
            model.n = data['n'];
            model.incident = data['incident'];
            model.dateDetect = data['date_detect'];
            model.lieu = data['lieu'];
            if(model.lieu == null){
              model.lieu ="";
            }
            model.type = data['type'];
            model.source = data['source'];
            model.act = data['act'];
            model.secteur = data['secteur'];
            model.poste = data['poste'];
            model.site = data['site'];
            model.processus = data['processus'];
            model.domaine = data['domaine'];
            model.direction = data['direction'];
            model.service = data['service'];
            model.typeCause = data['type_cause'];
            model.typeConseq = data['type_conseq'];
            model.delaiTrait = data['delai_trait'];
            model.traite = data['traite'];
            model.cloture = data['cloture'];
            model.categorie = data['categorie'];
            model.gravite = data['gravite'];
            model.statut = data['statut'];

            //delete table
            await localIncidentEnvironnementService.deleteTableIncidentEnvironnement();
            //save data
            await localIncidentEnvironnementService.saveIncidentEnvironnement(model);
            print('Inserting data in table IncidentEnvironnement : ${model.n} - ${model.incident}');
          });
          listIncident.clear();
          getIncident();
        }
            , onError: (err) {
              isDataProcessing(false);
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });
        await ApiControllersCall().getTypeCauseIncidentEnvRattacher();
        await ApiControllersCall().getTypeConsequenceIncidentEnvRattacher();
      }
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    }
    finally{
      isDataProcessing(false);
    }
  }
}