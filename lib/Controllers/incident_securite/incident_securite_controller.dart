import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualipro_flutter/Models/type_incident_model.dart';
import '../../Models/incident_securite/incident_securite_model.dart';
import '../../Services/incident_securite/incident_securite_service.dart';
import '../../Services/incident_securite/local_incident_securite_service.dart';
import '../../Utils/shared_preference.dart';
import '../../Utils/snack_bar.dart';
import '../api_controllers_call.dart';
import '../sync_data_controller.dart';

class IncidentSecuriteController extends GetxController {
  IncidentSecuriteService incidentSecuriteService = IncidentSecuriteService();
  var listIncident = List<IncidentSecuriteModel>.empty(growable: true).obs;
  var filterIncident = List<IncidentSecuriteModel>.empty(growable: true);
  var isDataProcessing = false.obs;
  LocalIncidentSecuriteService localIncidentSecuriteService =
      LocalIncidentSecuriteService();
  final matricule = SharedPreference.getMatricule();
  //search
  TextEditingController searchNumero = TextEditingController();
  TextEditingController searchDesignation = TextEditingController();
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
  }

  Future<void> checkConnectivity() async {
    var connection = await Connectivity().checkConnectivity();
    if (connection == ConnectivityResult.none) {
      Get.snackbar("No Connection", "Mode Offline",
          colorText: Colors.blue,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(milliseconds: 500));
    } else if (connection == ConnectivityResult.wifi ||
        connection == ConnectivityResult.mobile) {
      Get.snackbar("Internet Connection", "Mode Online",
          colorText: Colors.blue,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(milliseconds: 500));
    }
  }

  void getIncident() async {
    try {
      isDataProcessing.value = true;
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        //get local data
        var response =
            await localIncidentSecuriteService.readIncidentSecurite();
        response.forEach((data) {
          var model = IncidentSecuriteModel();
          model.online = data['online'];
          model.ref = data['ref'];
          model.typeIncident = data['typeIncident'];
          model.site = data['site'];
          model.dateInc = data['dateInc'];
          model.contract = data['contract'];
          model.statut = data['statut'];
          model.designation = data['designation'];
          model.gravite = data['gravite'];
          model.categorie = data['categorie'];
          model.typeConsequence = data['typeConsequence'];
          model.typeCause = data['typeCause'];
          model.secteur = data['secteur'];
          listIncident.add(model);
          listIncident.forEach((element) {
            print('element incident ${element.ref} - ${element.designation}');
          });
        });
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //rest api
        await incidentSecuriteService.getIncident(matricule).then(
            (response) async {
          //isDataProcessing(false);
          print('response incident securite : $response');
          response.forEach((data) async {
            var model = IncidentSecuriteModel();
            model.online = 1;
            model.ref = data['ref'];
            model.typeIncident = data['typeIncident'];
            model.site = data['site'];
            model.dateInc = data['date_Inc'];
            model.contract = data['contract'];
            model.statut = data['statut'];
            model.designation = data['designation'];
            model.gravite = data['gravite'];
            model.categorie = data['categorie'];
            model.typeConsequence = data['typeConsequence'];
            model.typeCause = data['typeCause'];
            model.secteur = data['secteur'];
            listIncident.add(model);
            listIncident.forEach((element) {
              print('element incident ${element.ref} - ${element.designation}');
            });
          });
        }, onError: (err) {
          isDataProcessing.value = false;
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
          print('Error incident Securite : ${err.toString()}');
        });
      }
    } catch (exception) {
      isDataProcessing.value = false;
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      print('Exception : ${exception.toString()}');
    } finally {
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
        var response =
            await localIncidentSecuriteService.searchIncidentSecurite(
                searchNumero.text, searchDesignation.text, searchType);
        response.forEach((data) {
          var model = IncidentSecuriteModel();
          model.online = data['online'];
          model.ref = data['ref'];
          model.typeIncident = data['typeIncident'];
          model.site = data['site'];
          model.dateInc = data['dateInc'];
          model.contract = data['contract'];
          model.statut = data['statut'];
          model.designation = data['designation'];
          model.gravite = data['gravite'];
          model.categorie = data['categorie'];
          model.typeConsequence = data['typeConsequence'];
          model.typeCause = data['typeCause'];
          model.secteur = data['secteur'];
          listIncident.add(model);
          listIncident.forEach((element) {
            print('element incident ${element.ref} - ${element.designation}');
          });
          searchNumero.clear();
          searchDesignation.clear();
        });
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //rest api
        await IncidentSecuriteService()
            .searchIncident(matricule, searchNumero.text,
                searchDesignation.text, searchCodeType)
            .then((resp) async {
          //isDataProcessing(false);
          resp.forEach((data) async {
            print('search incident : ${data} ');
            var model = IncidentSecuriteModel();
            model.online = 1;
            model.ref = data['ref'];
            model.typeIncident = data['typeIncident'];
            model.site = data['site'];
            model.dateInc = data['date_Inc'];
            model.contract = data['contract'];
            model.statut = data['statut'];
            model.designation = data['designation'];
            model.gravite = data['gravite'];
            model.categorie = data['categorie'];
            model.typeConsequence = data['typeConsequence'];
            model.typeCause = data['typeCause'];
            model.secteur = data['secteur'];
            listIncident.add(model);
            listIncident.forEach((element) {
              print('element incident ${element.ref} - ${element.designation}');
            });
            searchNumero.clear();
            searchDesignation.clear();
            searchCodeType = '';
          });
        }, onError: (err) {
          isDataProcessing.value = false;
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
      }
    } catch (exception) {
      isDataProcessing.value = false;
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      print('Exception : ${exception.toString()}');
    } finally {
      isDataProcessing.value = false;
    }
  }

  //synchronization
  Future syncIncidentToWebService() async {
    try {
      DateTime dateNow = DateTime.now();
      isDataProcessing(true);
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        Get.snackbar("No Connection", "Cannot synchronize Data",
            colorText: Colors.blue, snackPosition: SnackPosition.TOP);
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        await SyncDataController().syncIncidentSecuriteToSQLServer();
        await SyncDataController().syncTypeCauseIncSecToSQLServer();
        await SyncDataController().syncTypeConsequenceIncSecToSQLServer();
        await SyncDataController().syncCauseTypiqueIncSecToSQLServer();
        await SyncDataController().syncSiteLesionIncSecToSQLServer();
        await SyncDataController().syncActionIncSecRattacherToSQLServer();
        //save data in db local
        await incidentSecuriteService.getIncident(matricule).then((resp) async {
          //delete table
          await localIncidentSecuriteService.deleteTableIncidentSecurite();
          resp.forEach((data) async {
            var model = IncidentSecuriteModel();
            model.online = 1;
            model.ref = data['ref'];
            model.typeIncident = data['typeIncident'];
            model.site = data['site'];
            model.dateInc = data['date_Inc'];
            model.contract = data['contract'];
            model.statut = data['statut'];
            model.designation = data['designation'];
            model.gravite = data['gravite'];
            model.categorie = data['categorie'];
            model.typeConsequence = data['typeConsequence'];
            model.typeCause = data['typeCause'];
            model.secteur = data['secteur'];
            //save data
            await localIncidentSecuriteService.saveIncidentSecurite(model);
            debugPrint(
                'Inserting data in table IncidentSecurite : ${model.ref} - ${model.designation}');
          });
          listIncident.clear();
          getIncident();
        }, onError: (err) {
          isDataProcessing(false);
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
        await ApiControllersCall().getTypeCauseIncidentSecRattacher();
        await ApiControllersCall().getTypeConsequenceIncSecRattacher();
        await ApiControllersCall().getCauseTypiqueIncSecRattacher();
        await ApiControllersCall().getSiteLesionIncSecRattacher();
        await ApiControllersCall().getActionIncSecRattacher();
      }
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }
}
