import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Models/begin_licence_model.dart';
import '../../Models/licence_end_model.dart';
import '../../Models/reunion/reunion_model.dart';
import '../../Services/licence_service.dart';
import '../../Services/login_service.dart';
import '../../Services/reunion/local_reunion_service.dart';
import '../../Services/reunion/reunion_service.dart';
import '../../Utils/http_response.dart';
import '../../Utils/shared_preference.dart';
import '../../Utils/snack_bar.dart';
import '../../Views/licence/licence_page.dart';
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
    super.onInit();
    getReunion();
    checkLicence();
    //checkConnectivity();
    searchNumero.text = '';
    searchDesignation.text = '';
  }

  //check if licence end
  BeginLicenceModel? licenceDevice;
  LicenceEndModel? licenceEndModel;
  var isLicenceEnd = 0.obs;
  final deviceId = SharedPreference.getDeviceIdKey();
  checkLicence() async {
    var connection = await Connectivity().checkConnectivity();
    if (connection == ConnectivityResult.none) {
      licenceDevice = await LicenceService().getBeginLicence();
      String? device_id = licenceDevice?.DeviceId;
      licenceEndModel = await LicenceService().getIsLicenceEnd(device_id);
      if (licenceEndModel?.retour == 0) {
        debugPrint('licence of device : $device_id');
      } else {
        Get.snackbar("Licence ${SharedPreference.getLicenceKey().toString()}",
            'licence_expired'.tr,
            colorText: Colors.lightBlue, snackPosition: SnackPosition.BOTTOM);
        SharedPreference.clearSharedPreference();
        Get.off(LicencePage());
      }
    } else if (connection == ConnectivityResult.wifi ||
        connection == ConnectivityResult.mobile) {
      await LoginService().isLicenceEndService({
        "deviceid": deviceId.toString(),
      }).then((responseLicenceEnd) async {
        debugPrint('responseLicenceEnd : ${responseLicenceEnd['retour']}');
        if (responseLicenceEnd['retour'] == 0) {
          debugPrint('licence of device : ${deviceId.toString()}');
        } else {
          ShowSnackBar.snackBar(
              "Licence ${SharedPreference.getLicenceKey().toString()}",
              'licence_expired'.tr,
              Colors.lightBlueAccent);
          SharedPreference.clearSharedPreference();
          Get.off(LicencePage());
        }
      }, onError: (errorLicenceEnd) {
        HttpResponse.StatusCode(errorLicenceEnd.toString());
        //ShowSnackBar.snackBar("Error Licence End", errorLicenceEnd.toString(), Colors.red);
      });
    }
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
        }, onError: (error) {
          isDataProcessing.value = false;
          HttpResponse.StatusCode(error.toString());
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
          HttpResponse.StatusCode(error.toString());
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
        Get.snackbar("No Connection", 'cannot_synchronize_data'.tr,
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
          //delete table
          await localReunionService.deleteTableReunion();
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

            //save data
            await localReunionService.saveReunion(model);
            debugPrint(
                'Inserting data in table Reunion : ${model.nReunion} - ${model.ordreJour}');
          });
          listReunion.clear();
          getReunion();
        }, onError: (error) {
          //isDataProcessing(false);
          HttpResponse.StatusCode(error.toString());
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
