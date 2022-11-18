import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:qualipro_flutter/Controllers/api_controllers_call.dart';
import 'package:qualipro_flutter/Services/audit/audit_service.dart';
import 'package:qualipro_flutter/Services/audit/local_audit_service.dart';
import '../../Models/audit/audit_model.dart';
import '../../Models/incident_securite/incident_securite_model.dart';
import '../../Services/incident_securite/incident_securite_service.dart';
import '../../Services/incident_securite/local_incident_securite_service.dart';
import '../../Utils/shared_preference.dart';
import '../../Utils/snack_bar.dart';
import '../sync_data_controller.dart';

class AuditController extends GetxController {
  AuditService auditService = AuditService();
  List<AuditModel> listAudit = List<AuditModel>.empty(growable: true);
  var filterAudit = List<AuditModel>.empty(growable: true);
  var isDataProcessing = false.obs;
  LocalAuditService localAuditService = LocalAuditService();
  final matricule = SharedPreference.getMatricule();
  String? langue = SharedPreference.getLangue();
  //search
  TextEditingController searchNumero = TextEditingController();
  TextEditingController searchType = TextEditingController();
  String? search_etat = "0";
  //details
  var nomAudit = "".obs;

  @override
  void onInit() {
    super.onInit();
    getData();
    //checkConnectivity();
    //search
    searchNumero.text = '';
    searchType.text = '';
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
        var response = await localAuditService.readAudit();
        response.forEach((data) {
          var model = AuditModel();
          model.online = data['online'];
          model.idAudit = data['idAudit'];
          model.refAudit = data['refAudit'];
          model.dateDebPrev = data['dateDebPrev'];
          model.etat = data['etat'];
          model.dateDeb = data['dateDeb'];
          model.champ = data['champ'];
          model.site = data['site'];
          model.interne = data['interne'];
          model.cloture = data['cloture'];
          model.typeA = data['typeA'];
          model.validation = data['validation'];
          model.dateFinPrev = data['dateFinPrev'];
          model.audit = data['audit'];
          model.objectif = data['objectif'];
          model.rapportClot = data['rapportClot'];
          listAudit.add(model);
          if (kDebugMode) {
            listAudit.forEach((element) {
              print('element audit ${element.idAudit} - ${element.champ}');
            });
          }
        });
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //rest api
        listAudit = await auditService.getAudits() as List<AuditModel>;
        /*  await auditService.getAudits().then((response) async {
          //isDataProcessing(false);
          //print('response audit : $response');
          listAudit = await auditService.getAudits() as List<AuditModel>;

          listAudit.forEach((element) {
            print('element audit ${element.refAudit} - ${element.champ}');
          });
        }
            , onError: (err) {
              isDataProcessing.value = false;
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
              print('Error audit : ${err.toString()}');
            }
            ); */
      }
    } catch (exception) {
      isDataProcessing.value = false;
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      print('Exception : ${exception.toString()}');
    } finally {
      isDataProcessing.value = false;
    }
  }

  void searchAudit() async {
    try {
      isDataProcessing.value = true;
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        //search local data
        var response = await localAuditService.searchAudit(searchNumero.text,
            int.parse(search_etat.toString()), searchType.text);
        response.forEach((data) {
          var model = AuditModel();
          model.online = data['online'];
          model.idAudit = data['idAudit'];
          model.refAudit = data['refAudit'];
          model.dateDebPrev = data['dateDebPrev'];
          model.etat = data['etat'];
          model.dateDeb = data['dateDeb'];
          model.champ = data['champ'];
          model.site = data['site'];
          model.interne = data['interne'];
          model.cloture = data['cloture'];
          model.typeA = data['typeA'];
          listAudit.add(model);
          if (kDebugMode) {
            listAudit.forEach((element) {
              print('element audit ${element.idAudit} - ${element.champ}');
            });
          }
          searchNumero.clear();
          searchType.clear();
          search_etat = "0";
        });
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //rest api
        listAudit = await auditService.searchAudit(
            searchNumero.text,
            int.parse(search_etat.toString()),
            searchType.text) as List<AuditModel>;
        searchNumero.clear();
        searchType.clear();
        search_etat = "0";
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
  Future syncAuditToWebService() async {
    try {
      //DateTime dateNow = DateTime.now();
      isDataProcessing(true);
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        Get.snackbar("No Connection", "Cannot synchronize Data",
            colorText: Colors.blue, snackPosition: SnackPosition.TOP);
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //sync to web service
        await SyncDataController().syncAuditToSQLServer();
        await SyncDataController().syncConstatAuditToSQLServer();
        await SyncDataController().syncAuditeurInterneToSQLServer();
        await SyncDataController().syncAuditeurExterneToSQLServer();
        await SyncDataController().syncEmployeHabiliteAuditToSQLServer();
        await SyncDataController().syncCritereCheckListAudit();
        await AuditService().getAudits().then((resp) async {
          //delete table
          await localAuditService.deleteTableAudit();
          resp.forEach((data) async {
            var model = AuditModel();
            model.online = 1;
            model.idAudit = data.idAudit;
            model.refAudit = data.refAudit;
            model.dateDebPrev = data.dateDebPrev;
            model.etat = data.etat;
            model.dateDeb = data.dateDeb;
            model.champ = data.champ;
            model.site = data.site;
            model.interne = data.interne;
            model.cloture = data.cloture;
            model.typeA = data.typeA;
            model.validation = data.validation;
            model.dateFinPrev = data.dateFinPrev;
            model.audit = data.audit;
            model.objectif = data.objectif;
            if (data.rapportClot == null) {
              model.rapportClot = '';
            } else {
              model.rapportClot = data.rapportClot;
            }
            //save data
            await localAuditService.saveAudit(model);
          });
          listAudit.clear();
          getData();
        }, onError: (err) {
          isDataProcessing(false);
          ShowSnackBar.snackBar("Error Audits", err.toString(), Colors.red);
        });
        //await ApiControllersCall().getAudits();
        await ApiControllersCall().getConstatsActionProv();
        await ApiControllersCall().getConstatsAction();
        await ApiControllersCall().getAuditeurInterne();
        await ApiControllersCall().getChampAuditByRefAudit();
        await ApiControllersCall().getAuditeurInterneARattacher();
        await ApiControllersCall().getCheckListAudit();
        await ApiControllersCall().getAuditeurExterneRattacher();
        await ApiControllersCall().getAllAuditeursExterne();
        await ApiControllersCall().getEmployeHabiliteAudit();
        await ApiControllersCall().getCritereCheckListAudit();
      }
    } catch (exception) {
      isDataProcessing(false);
      if (kDebugMode) print('Exception sync : ${exception.toString()}');
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }
}
