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
      Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.BOTTOM, duration: Duration(milliseconds: 500));
    }
    else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
      Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.BOTTOM, duration: Duration(milliseconds: 500));

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
          if(kDebugMode){
            listAudit.forEach((element) {
              print('element audit ${element.idAudit} - ${element.champ}');
            });
          }
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
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
    }
    finally {
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
        var response = await localAuditService.searchAudit(searchNumero.text, int.parse(search_etat.toString()), searchType.text);
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
          if(kDebugMode){
            listAudit.forEach((element) {
              print('element audit ${element.idAudit} - ${element.champ}');
            });
          }
          searchNumero.clear();
          searchType.clear();
          search_etat = "0";
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        //rest api
        listAudit = await auditService.searchAudit(searchNumero.text, int.parse(search_etat.toString()), searchType.text) as List<AuditModel>;
        searchNumero.clear();
        searchType.clear();
        search_etat = "0";
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
  Future syncAuditToWebService() async {
    try {
      //DateTime dateNow = DateTime.now();
      isDataProcessing(true);
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        Get.snackbar("No Connection", "Cannot synchronize Data", colorText: Colors.blue,
            snackPosition: SnackPosition.TOP);
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {

        //sync to web service
        await SyncDataController().syncAuditToSQLServer();
        await SyncDataController().syncConstatAuditToSQLServer();
        await SyncDataController().syncAuditeurInterneToSQLServer();

      /* var responseAuditByOnline = await LocalAuditService().readAuditByOnline();
       await responseAuditByOnline.forEach((data) async {
          //print('listCodeChamp : ${data['listCodeChamp']}');
          debugPrint('audit sync : $data');
          await AuditService().saveAudit({
            "descriptionAudit": data['audit'],
            "dateDebutPrev": data['dateDebPrev'],
            "dateFinPrev": data['dateFinPrev'],
            "objectif": data['objectif'],
            "codeTypeAudit": data['codeTypeA'],
            "codeSite": data['codeSite'],
            "refInterne": data['interne'],
            "matDeclencheur": matricule.toString(),
            "processus": data['idProcess'],
            "domaine": data['idDomaine'],
            "direction": data['idDirection'],
            "service": data['idService'],
            "codesChamps": data['listCodeChamp']
          }).then((resp) async {
            String? refAudit = resp['refAudit'];
            debugPrint('refAudit : $refAudit');
            //geeting employes of type audit
            await AuditService().verifierRapportAuditParMode({
              "refAudit": "",
              "mat": "",
              "codeChamp": data['codeTypeA'].toString(),
              "mode": "Cons_Param_valid"
            }).then((response2) async {
              //insert employe validation
              response2.forEach((element) async {
                print('Matricule : ${element['matricule']} - Nompre : ${element['nompre']}');

                await AuditService().ajoutEnregEmpValidAudit({
                  "refAudit": data['refAudit'].toString(),
                  "mat": element['matricule'].toString(),
                  "codeChamp": '',
                  "mode": "Ajout_enreg_empvalid"
                }).then((value) async {
                  //Get.back();
                  //ShowSnackBar.snackBar("Successfully", "responsable validation ${element['matricule']} added", Colors.green);

                }, onError: (error){
                  ShowSnackBar.snackBar("error inserting employes validation : ", error.toString(), Colors.red);
                });
              });
            }, onError: (error){
              ShowSnackBar.snackBar("error getting employe by TypeAudit : ", error.toString(), Colors.red);
            });
            //await localSecuriteEnvironnementService.deleteIncidentEnvironnementOffline();
            ShowSnackBar.snackBar("${data['audit']} added", "Synchronization successfully", Colors.green);

          }, onError: (err) {
            isDataProcessing(false);
            debugPrint('Error sync audit : ${err.toString()}');
            ShowSnackBar.snackBar("Error sync audit", err.toString(), Colors.red);
          });
        });

        var responseConstatAuditByOnline = await localAuditService.readConstatAuditByOnline();
        await responseConstatAuditByOnline.forEach((data) async {
          print('audit constat : $data');
          await AuditService().saveConstatAudit(
              {
                "refAud": data['refAudit'],
                "objetConstat": data['act'],
                "descConstat": data['descPb'],
                "typeConst": data['typeAct'],
                "matConcerne": data['mat'],
                "typeEcart": data['codeTypeE'],
                "graviteConstat": data['ngravite'],
                "mat": matricule.toString(),
                "id": data['idEcart'],
                "numAct": 0,
                "mode": "Ajout",
                "codeChamp": data['codeChamp'],
                "idCritere": 0,
                "dealiReal": data['delaiReal']
              }
          ).then((value){

          }, onError: (error){
            ShowSnackBar.snackBar("Error sync constat", error.toString(), Colors.red);
          });
        });

        var responseAuditeurInterneByOnline = await localAuditService.readAuditeurInterneByOnline();
        await responseAuditeurInterneByOnline.forEach((data) async {
          print('auditeur interne async : $data');
          await AuditService().saveAuditeurInterne({
            "mat": data['mat'],
            "refAudit": data['refAudit'],
            "affectation": data['affectation']
          }).then((value){
            print('auditeur interne  : ${data['refAudit']} - ${data['mat']}');
          }, onError: (error){
            ShowSnackBar.snackBar("Error sync constat", error.toString(), Colors.red);
          });
        }); */
        await AuditService().getAudits().then((resp) async {
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
            if(data.rapportClot == null){
              model.rapportClot = '';
            }
            else {
              model.rapportClot = data.rapportClot;
            }

            //delete table
            await localAuditService.deleteTableAudit();
            //save data
            await localAuditService.saveAudit(model);
          });
          listAudit.clear();
          getData();
        }
            , onError: (err) {
              isDataProcessing(false);
              ShowSnackBar.snackBar("Error Audits", err.toString(), Colors.red);
            });
        //await ApiControllersCall().getAudits();
        await ApiControllersCall().getConstatsActionProv();
        await ApiControllersCall().getConstatsAction();
        await ApiControllersCall().getAuditeurInterne();
        await ApiControllersCall().getChampAuditByRefAudit();
        await ApiControllersCall().getAuditeurInterneARattacher();
      }
    } catch (exception) {
      isDataProcessing(false);
      if(kDebugMode) print('Exception sync : ${exception.toString()}');
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    }
    finally{
      isDataProcessing(false);
    }
  }
}