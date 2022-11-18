import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualipro_flutter/Services/pnc/local_pnc_service.dart';

import '../../Models/pnc/pnc_model.dart';
import '../../Models/reunion/reunion_model.dart';
import '../../Models/reunion/type_reunion_model.dart';
import '../../Services/pnc/pnc_service.dart';
import '../../Services/reunion/local_reunion_service.dart';
import '../../Services/reunion/reunion_service.dart';
import '../../Utils/shared_preference.dart';
import '../../Utils/snack_bar.dart';
import '../api_controllers_call.dart';
import '../sync_data_controller.dart';

class ReunionController extends GetxController {
  var listReunion = List<ReunionModel>.empty(growable: true).obs;
  var filterReunion = List<ReunionModel>.empty(growable: true);
  var isDataProcessing = false.obs;
  LocalReunionService localReunionService = LocalReunionService();
  final matricule = SharedPreference.getMatricule();
  //search
  TextEditingController searchNumero = TextEditingController();
  TextEditingController searchDesignation = TextEditingController();
  //TextEditingController searchType = TextEditingController();
  String? searchCodeType = "";

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getReunion();
    //checkConnectivity();
    searchNumero.text = '';
    searchDesignation.text = '';
  }

  Future<void> checkConnectivity() async {
    var connection = await Connectivity().checkConnectivity();
    if (connection == ConnectivityResult.none) {
      Get.snackbar("No Connection", "Mode Offline",
          colorText: Colors.blue, snackPosition: SnackPosition.BOTTOM);
    } else if (connection == ConnectivityResult.wifi ||
        connection == ConnectivityResult.mobile) {
      Get.snackbar("Internet Connection", "Mode Online",
          colorText: Colors.blue, snackPosition: SnackPosition.BOTTOM);
    }
  }

  void getReunion() async {
    try {
      isDataProcessing.value = true;
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        //get local data
        var response = await localReunionService.readReunion();
        response.forEach((data) {
          var model = ReunionModel();
          model.online = data['online'];
          model.nReunion = data['nReunion'];
          model.typeReunion = data['typeReunion'];
          model.codeTypeReunion = data['codeTypeReunion'];
          model.datePrev = data['datePrev'];
          model.dateReal = data['dateReal'];
          model.etat = data['etat'];
          model.lieu = data['lieu'];
          model.site = data['site'];
          model.ordreJour = data['ordreJour'];
          listReunion.add(model);
        });
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //rest api
        await ReunionService().getReunion(matricule).then((resp) async {
          //isDataProcessing(false);
          resp.forEach((data) async {
            print('get reunion : ${data} ');
            var model = ReunionModel();
            model.nReunion = data['nReunion'];
            model.typeReunion = data['typeReunion'];
            model.codeTypeReunion = data['codeTypeReunion'];
            model.datePrev = data['datePrev'];
            //model.dateReal = data['dateReal'];
            model.etat = data['etat'];
            model.lieu = data['lieu'];
            model.site = data['site'];
            model.ordreJour = data['ordreJour'];
            model.online = 1;
            //model.strEtat = data['strEtat'];
            //model.reunionPlus0 = data['reunion_plus0'];
            //model.reunionPlus1 = data['reunion_plus1'];
            listReunion.add(model);
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

  searchReunion() async {
    try {
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        var response = await localReunionService.searchReunion(
            searchNumero.text, searchCodeType, searchDesignation.text);
        response.forEach((data) {
          var model = ReunionModel();
          model.online = data['online'];
          model.nReunion = data['nReunion'];
          model.typeReunion = data['typeReunion'];
          model.codeTypeReunion = data['codeTypeReunion'];
          model.datePrev = data['datePrev'];
          model.dateReal = data['dateReal'];
          model.etat = data['etat'];
          model.lieu = data['lieu'];
          model.site = data['site'];
          model.ordreJour = data['ordreJour'];
          listReunion.add(model);
        });
        searchNumero.text = '';
        searchDesignation.text = '';
      } else if (connection == ConnectivityResult.mobile ||
          connection == ConnectivityResult.wifi) {
        await ReunionService()
            .searchReunion(matricule, searchNumero.text, searchCodeType,
                searchDesignation.text)
            .then((response) {
          response.forEach((data) async {
            var model = ReunionModel();
            model.nReunion = data['nReunion'];
            model.typeReunion = data['typeReunion'];
            model.codeTypeReunion = data['codeTypeReunion'];
            model.datePrev = data['datePrev'];
            model.etat = data['etat'];
            model.lieu = data['lieu'];
            model.site = data['site'];
            model.ordreJour = data['ordreJour'];
            model.online = 1;
            listReunion.add(model);
            searchNumero.text = '';
            searchDesignation.text = '';
          });
        }, onError: (error) {
          isDataProcessing.value = false;
          ShowSnackBar.snackBar("Error", error.toString(), Colors.red);
          debugPrint('Error : ${error.toString()}');
        });
      }
    } catch (exception) {
      isDataProcessing.value = false;
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      debugPrint('Exception : ${exception.toString()}');
    } finally {
      isDataProcessing.value = false;
    }
  }

  //synchronization
  Future syncReunionToWebService() async {
    try {
      isDataProcessing(true);
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        Get.snackbar("No Connection", "Cannot synchronize Data",
            colorText: Colors.blue, snackPosition: SnackPosition.TOP);
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //sync reunion
        await SyncDataController().syncReunionToSQLServer();
        //sync participant of reunion
        await SyncDataController().syncParticipantOfReunionToSQLServer();
        await SyncDataController().syncActionOfReunionToSQLServer();
        //save data in db local
        await ReunionService().getReunion(matricule).then((resp) async {
          resp.forEach((data) async {
            var model = ReunionModel();
            model.online = 1;
            model.nReunion = data['nReunion'];
            model.typeReunion = data['typeReunion'];
            model.codeTypeReunion = data['codeTypeReunion'];
            model.datePrev = data['datePrev'];
            model.dateReal = data['dateReal'];
            model.etat = data['etat'];
            model.lieu = data['lieu'];
            model.site = data['site'];
            model.ordreJour = data['ordreJour'];

            //delete table
            await localReunionService.deleteTableReunion();
            //save data
            await localReunionService.saveReunion(model);
            print(
                'Inserting data in table Reunion : ${model.nReunion} - ${model.ordreJour}');
          });
          listReunion.clear();
          getReunion();
        }, onError: (err) {
          //isDataProcessing(false);
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
        await ApiControllersCall().getParticipantsReunion();
        await ApiControllersCall().getActionReunionRattacher();
      }
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }
}
