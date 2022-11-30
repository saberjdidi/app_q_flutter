import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualipro_flutter/Services/visite_securite/local_visite_securite_service.dart';
import '../../Models/begin_licence_model.dart';
import '../../Models/licence_end_model.dart';
import '../../Models/visite_securite/visite_securite_model.dart';
import '../../Services/incident_securite/local_incident_securite_service.dart';
import '../../Services/licence_service.dart';
import '../../Services/login_service.dart';
import '../../Services/visite_securite/visite_securite_service.dart';
import '../../Utils/http_response.dart';
import '../../Utils/shared_preference.dart';
import '../../Utils/snack_bar.dart';
import '../../Views/licence/licence_page.dart';
import '../api_controllers_call.dart';
import '../sync_data_controller.dart';

class VisiteSecuriteController extends GetxController {
  VisiteSecuriteService visiteSecuriteService = VisiteSecuriteService();
  var listVisiteSecurite = List<VisiteSecuriteModel>.empty(growable: true).obs;
  //var listEquipeVS = List<EquipeVisiteSecuriteModel>.empty(growable: true).obs;
  var filterList = List<VisiteSecuriteModel>.empty(growable: true);
  var isDataProcessing = false.obs;
  LocalIncidentSecuriteService localIncidentSecuriteService =
      LocalIncidentSecuriteService();
  LocalVisiteSecuriteService localVisiteSecuriteService =
      LocalVisiteSecuriteService();
  final matricule = SharedPreference.getMatricule();
  //search
  TextEditingController searchNumero = TextEditingController();
  TextEditingController searchUnite = TextEditingController();
  TextEditingController searchZone = TextEditingController();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getData();
    checkLicence();
    //checkConnectivity();
    //search
    searchNumero.text = '';
    searchUnite.text = '';
    searchZone.text = '';
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

  void getData() async {
    try {
      isDataProcessing.value = true;
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        //get local data
        var response = await localVisiteSecuriteService.readVisiteSecurite();
        response.forEach((data) {
          var model = VisiteSecuriteModel();
          model.online = data['online'];
          model.id = data['id'];
          model.site = data['site'];
          model.dateVisite = data['dateVisite'];
          model.unite = data['unite'];
          model.zone = data['zone'];
          listVisiteSecurite.add(model);
        });
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //rest api
        await visiteSecuriteService.getVisiteSecurite(matricule).then(
            (response) async {
          //isDataProcessing(false);
          print('response visite securite : $response');
          response.forEach((data) async {
            var model = VisiteSecuriteModel();
            model.online = 1;
            model.id = data['id'];
            model.site = data['site'];
            model.dateVisite = data['dateVisite'];
            model.unite = data['unite'];
            model.zone = data['zone'];
            listVisiteSecurite.add(model);
            /*
           //model.listEquipe = data['listEquipe'];
            if (data['listEquipe'] != null) {
             //var listEquipe = <EquipeVisiteSecuriteModel>[];
              data['listEquipe'].forEach((v) {
                var modelEquipe = EquipeVisiteSecuriteModel();
                modelEquipe.id = v['id'];
                modelEquipe.mat = v['resp'];
                modelEquipe.nompre = v['nomPre'];
                modelEquipe.affectation = v['affectation'];
                //listEquipe!.add(modelEquipe);
                 listEquipeVS.add(modelEquipe);
                listEquipeVS.forEach((elementEquipe) {
                  print('element visite equipe : ${data['id']} - ${elementEquipe.id} - ${elementEquipe.nompre}');
                });
              });
            }
            */
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

  void searchData() async {
    try {
      isDataProcessing.value = true;
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        //search local data
        var response = await localVisiteSecuriteService.searchVisiteSecurite(
            searchNumero.text, searchUnite.text, searchZone.text);
        response.forEach((data) {
          var model = VisiteSecuriteModel();
          model.online = data['online'];
          model.id = data['id'];
          model.site = data['site'];
          model.dateVisite = data['dateVisite'];
          model.unite = data['unite'];
          model.zone = data['zone'];
          listVisiteSecurite.add(model);
          searchNumero.clear();
          searchUnite.clear();
          searchZone.clear();
        });
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //rest api
        await VisiteSecuriteService()
            .searchVisiteSecurite(
                searchNumero.text, searchUnite.text, searchZone.text, matricule)
            .then((resp) async {
          //isDataProcessing(false);
          resp.forEach((data) async {
            print('search visite securite : ${data} ');
            var model = VisiteSecuriteModel();
            model.online = 1;
            model.id = data['id'];
            model.site = data['site'];
            model.dateVisite = data['dateVisite'];
            model.unite = data['unite'];
            model.zone = data['zone'];
            listVisiteSecurite.add(model);

            searchNumero.clear();
            searchUnite.clear();
            searchZone.clear();
          });
        }, onError: (error) {
          isDataProcessing.value = false;
          HttpResponse.StatusCode(error.toString());
          //ShowSnackBar.snackBar("Error", error.toString(), Colors.red);
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
  Future syncVisiteSecuriteToWebService() async {
    try {
      DateTime dateNow = DateTime.now();
      isDataProcessing(true);
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        Get.snackbar("No Connection", 'cannot_synchronize_data'.tr,
            colorText: Colors.blue, snackPosition: SnackPosition.TOP);
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        await SyncDataController().syncVisiteSecuriteToSQLServer();
        await SyncDataController().syncEquipeVSToSQLServer();
        await SyncDataController().syncCheckListVSToSQLServer();
        await SyncDataController().syncActionVSRattacherToSQLServer();
        /* var response = await localVisiteSecuriteService.readVisiteSecuriteByOnline();
        response.forEach((data) async {
          print('data: $data');

          List<EquipeModel> listEquipeToSync = List<EquipeModel>.empty(growable: true);
          var responseEquipe = await localVisiteSecuriteService.readEquipeVisiteSecuriteEmployeById(data['id']);
          responseEquipe.forEach((element) async {
            var modelToSync = EquipeModel();
            modelToSync.mat = element['mat'];
            modelToSync.affectation = element['affectation'];
            //print('equipe to sync : ${data['id']}-${modelToSync.mat}-${modelToSync.affectation}');
            listEquipeToSync.add(modelToSync);
            //print('list equipe to sync 1 : ${listEquipeToSync.length}');
          });

          final dateVisite = data['dateVisite'];
          DateTime? dt1 = DateTime.tryParse(dateVisite!);
          await VisiteSecuriteService().saveVisiteSecurite(
              {
                "idSite": data['codeSite'],
                "dateVisite": DateFormat('dd/MM/yyyy').format(dt1!),
                "idUnite": data['idUnite'],
                "idZone": data['idZone'],
                "comportementObserve": data['comportementSurObserve'],
                "comportementRisque": data['comportementRisqueObserve'],
                "correctImmediate": data['correctionImmediate'],
                "autres": data['autres'],
                "idCHK": data['idCheckList'],
                "stObserve": data['situationObserve'],
                "equipes": listEquipeToSync
              }
          ).then((resp) async {
            //await localSecuriteEnvironnementService.deleteIncidentEnvironnementOffline();
            ShowSnackBar.snackBar("data added", "Synchronization successfully", Colors.green);
            //listVisiteSecurite.clear();
            //getData();
          }, onError: (err) {
            isDataProcessing(false);
            ShowSnackBar.snackBar("Error Save Visite Securite", err.toString(), Colors.red);
          });
        });
        //synchronize equipe
        var response_equipe = await localVisiteSecuriteService.readEquipeVisiteSecuriteOfflineByOnline();
        response_equipe.forEach((dataEquipe) async{
          await VisiteSecuriteService().saveEquipeVisiteSecurite({
            "idFiche": dataEquipe['idFiche'],
            "respMat": dataEquipe['mat'],
            "affectation": dataEquipe['affectation']
          }).then((resp) async {
            if (kDebugMode) {
              print('${dataEquipe['mat']} added to equipe');
            }
            ShowSnackBar.snackBar("${dataEquipe['mat']} added to equipe", "Synchronization successfully", Colors.green);
          }, onError: (err) {
            print('err : ${err.toString()}');
            ShowSnackBar.snackBar("Error Equipe", err.toString(), Colors.red);
          });
        }); */
        //save data in db local
        await visiteSecuriteService.getVisiteSecurite(matricule).then(
            (resp) async {
          resp.forEach((data) async {
            var model = VisiteSecuriteModel();
            model.online = 1;
            model.id = data['id'];
            model.site = data['site'];
            model.dateVisite = data['dateVisite'];
            model.unite = data['unite'];
            model.zone = data['zone'];
            //delete table
            await localVisiteSecuriteService
                .deleteTableEquipeVisiteSecuriteEmploye();
            await localVisiteSecuriteService.deleteTableVisiteSecurite();
            //await localVisiteSecuriteService.deleteTableEquipeVisiteSecuriteOffline();
            //save data
            await localVisiteSecuriteService.saveVisiteSecurite(model);
            debugPrint(
                'Inserting data in table VisiteSecurite : ${model.id} - ${model.unite} - ${model.zone}');
          });
          listVisiteSecurite.clear();
          getData();
        }, onError: (error) {
          isDataProcessing(false);
          HttpResponse.StatusCode(error.toString());
          // ShowSnackBar.snackBar("Error Visite Securite", error.toString(), Colors.red);
        });

        await ApiControllersCall().getEquipeVisiteSecuriteFromAPI();
        await ApiControllersCall().getCheckListVSRattacher();
        await ApiControllersCall().getTauxCheckListVS();
        await ApiControllersCall().getActionVSRattacher();
      }
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }
}
