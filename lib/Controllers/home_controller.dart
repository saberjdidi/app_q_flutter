import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Models/action/action_realisation_model.dart';
import '../Models/action/action_suite_audit.dart';
import '../Models/action/action_model.dart';
import '../Services/action/action_service.dart';
import '../Services/action/local_action_service.dart';
import '../Utils/shared_preference.dart';
import '../Utils/snack_bar.dart';
import 'api_controllers_call.dart';

class HomeController extends GetxController {
  var tabIndex = 0;
  ApiControllersCall apiControllersCall = ApiControllersCall();
  LocalActionService localActionService = LocalActionService();
  var listActionReal = List<ActionRealisationModel>.empty(growable: true).obs;
  var listActionSuivi = List<ActionRealisationModel>.empty(growable: true).obs;
  var listActionSuiteAudit = List<ActionSuiteAudit>.empty(growable: true).obs;
  var isDataProcessing = false.obs;
  final matricule = SharedPreference.getMatricule();
  late int countListActionRealisation;
  RxInt countListActionSuivi = 0.obs;
  int countListActionSuitAudit = 0;

  void updateIndex(int index){
    tabIndex++;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    getActionsRealisation();
    getActionsSuivi();
    getActionsSuiteAudit();
  }

  void getActionsRealisation() async {
    try {
      isDataProcessing(true);

        //rest api
        await ActionService().getActionRealisation({
          "mat": matricule.toString(),
          "nact": 0,
          "nsousact": 0,
          "realise": 0,
          "retard": 0,
          "filtre_sous_act": "",
          "filtre_nact": ""
        }).then((resp) async {
          //isDataProcessing(false);
          resp.forEach((data) async {
            var model = ActionRealisationModel();
            model.nomPrenom = data['nompre'];
            model.causemodif = data['causemodif'];
            model.nAct = data['nAct'];
            model.nSousAct = data['nSousAct'];
            model.respReal = data['respReal'];
            model.act = data['act'];
            model.sousAct = data['sousAct'];
            model.delaiReal = data['delaiReal'];
            model.delaiSuivi = data['delaiSuivi'];
            model.dateReal = data['dateReal'];
            model.dateSuivi = data['dateSuivi'];
            model.coutPrev = data['coutPrev'];
            model.pourcentReal = data['pourcentReal'];
            model.depense = data['depense'];
            model.rapportEff = data['rapportEff'];
            model.pourcentSuivie = data['pourcentSuivie'];
            model.commentaire = data['commentaire'];
            model.cloture = data['cloture'];
            model.designation = data['designation'];
            model.dateSaisieReal = data['date_Saisie_Real'];
            model.ind = data['ind'];
            model.priorite = data['priorite'];
            model.gravite = data['gravite'];
            model.returnRespS = data['returnRespS'];

            listActionReal.add(model);
            if(listActionReal.length == null){
              countListActionRealisation = 0;
            } else {
              countListActionRealisation = listActionReal.length;
            }

           /* listActionReal.forEach((element) {
              print('element act ${element.act}, id act: ${element.nAct}');
            });
            print('length list action realiser: ${countListActionRealisation}'); */
          });
        }
            , onError: (err) {
              isDataProcessing(false);
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });

    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    }
    finally {
      isDataProcessing(false);
    }
  }
  void getActionsSuivi() async {
    try {
      isDataProcessing(true);

      //rest api
      await ActionService().getActionSuivi({
        "mat": matricule.toString(),
        "ch_s": "",
        "nact": 0,
        "nsact": "",
        "filtre_nact": "",
        "filtre_sous_act": ""
      }).then((resp) {
        //isDataProcessing(false);
        resp.forEach((data) async {
          var model = ActionRealisationModel();
          model.nomPrenom = data['nomprerr'];
          model.causemodif = data['causeModif'];
          model.nAct = data['nAct'];
          model.nSousAct = int.parse(data['nSousAct']);
          //model.respReal = data['respReal'];
          model.act = data['act'];
          model.sousAct = data['sousAct'];
          //model.delaiReal = data['delaiReal'];
          model.delaiSuivi = data['delaiSuivi'];
          model.dateReal = data['dateReal'];
          model.dateSuivi = data['dateSuivi'];
          //model.coutPrev = data['coutPrev'];
          model.pourcentReal = data['pourcentReal'];
          model.depense = data['depense'];
          model.rapportEff = data['rapportEff'];
          model.pourcentSuivie = data['pourcentSuivie'];
          model.commentaire = data['commentaire'];
          //model.cloture = data['cloture'];
          model.designation = data['designation'];
          //model.dateSaisieReal = data['date_Saisie_Real'];
          //model.dateSaisieSuivi = data['date_Saisie_Suiv'];
          model.ind = data['ind'];
          model.priorite = data['priorite'];
          model.gravite = data['gravite'];
          //model.returnRespS = data['returnRespS'];

          listActionSuivi.add(model);
          if(listActionSuivi.length == null){
            countListActionSuivi.value = 0;
          } else {
            countListActionSuivi.value = listActionSuivi.length;
          }

         /* listActionSuivi.forEach((element) {
              print('element act suivi ${element.act}, id act: ${element.nAct}');
            });
            print('length list action suivi: ${countListActionSuivi}'); */
        });
      }
          , onError: (err) {
            isDataProcessing(false);
            ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
          });

    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    }
    finally {
      isDataProcessing(false);
    }
  }
  void getActionsSuiteAudit() async {
    try {
      isDataProcessing(true);
      //rest api
      await ActionService().getActionSuiteAudit(matricule).then((resp) async {
        resp.forEach((data) async {
          var model = ActionSuiteAudit();
          model.nact = data['nact'];
          model.act = data['act'];
          model.ind = data['ind'];
          model.datsuivPrv = data['datsuiv_prv'];
          model.isd = data['isd'];
          listActionSuiteAudit.add(model);
          if(listActionSuiteAudit.length == null){
            countListActionSuitAudit = 0;
          } else {
            countListActionSuitAudit = listActionSuiteAudit.length;
          }
          /*listActionSuiteAudit.forEach((element) {
            print('element act ${element.act}, id act: ${element.act}');
          }); */
        });
      }
          , onError: (err) {
            isDataProcessing(false);
            ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
          });

    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    }
    finally {
      isDataProcessing(false);
    }
  }
  Future syncApiCallToLocalDB() async {
    //await Get.find<OnBoardingController>().syncApiCallToLocalDB();
    var connection = await Connectivity().checkConnectivity();
    if(connection == ConnectivityResult.none) {
      Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue,
          snackPosition: SnackPosition.TOP);
    }
    else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
      Get.snackbar(
          "Internet Connection", "Please wait to add all data in DB local", colorText: Colors.blue,
          snackPosition: SnackPosition.TOP);

      await apiControllersCall.getDomaineAffectation();
      await apiControllersCall.getSourceAction();
      await apiControllersCall.getTypeAction();
      await apiControllersCall.getTypeCauseAction();
      await apiControllersCall.getResponsableCloture();
      await apiControllersCall.getSite();
      await apiControllersCall.getProcessus();
      await apiControllersCall.getProduct();
      await apiControllersCall.getDirection();
      await apiControllersCall.getEmploye();
      await apiControllersCall.getAuditAction();
      await apiControllersCall.getActivity();
      await apiControllersCall.getService();
      await apiControllersCall.getPriorite();
      await apiControllersCall.getGravite();
      await apiControllersCall.getChampObligatoireAction();
      await apiControllersCall.getProcessusEmploye();
      await apiControllersCall.getAllSousAction();
    }

  }
}