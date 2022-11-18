import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualipro_flutter/Controllers/sync_data_controller.dart';
import 'package:qualipro_flutter/Utils/shared_preference.dart';

import '../Services/licence_service.dart';
import '../Services/login_service.dart';
import '../Services/pnc/pnc_service.dart';
import '../Utils/snack_bar.dart';
import 'api_controllers_call.dart';

class OnBoardingController extends GetxController {
  ApiControllersCall apiControllersCall = ApiControllersCall();
  SyncDataController syncDataController = SyncDataController();
  var isDataProcessing = false.obs;

  @override
  void onInit() {
    super.onInit();
    syncApiCallToLocalDB();
  }

  Future syncApiCallToLocalDB() async {
    try {
      isDataProcessing.value = true;
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        Get.snackbar("No Connection", "Mode Offline",
            colorText: Colors.blue, snackPosition: SnackPosition.TOP);
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //verify licence
        final licenceDevice = await LicenceService().getBeginLicence();
        String? device_id = licenceDevice?.DeviceId;
        await LoginService().isLicenceEndService({
          "deviceid": device_id.toString(),
        }).then((responseLicenceEnd) async {
          debugPrint('responseLicenceEnd : ${responseLicenceEnd['retour']}');
          if (responseLicenceEnd['retour'] == 0) {
            Get.snackbar("Internet Connection", "Add Data in DataBase Local",
                colorText: Colors.blue, snackPosition: SnackPosition.TOP);

            //----------------------------sync from db local to web service------------------------------
            //sync action
            if (SharedPreference.getIsVisibleAction() == 1) {
              await syncDataController.syncActionToSQLServer();
              await syncDataController.syncSousActionToSQLServer();
              await syncDataController.syncTypeCauseActionToSQLServer();
            }
            //sync audit
            if (SharedPreference.getIsVisibleAudit() == 1) {
              await syncDataController.syncAuditToSQLServer();
              await syncDataController.syncConstatAuditToSQLServer();
              await syncDataController.syncAuditeurInterneToSQLServer();
              await syncDataController.syncAuditeurExterneToSQLServer();
              await syncDataController.syncEmployeHabiliteAuditToSQLServer();
              await syncDataController.syncCritereCheckListAudit();
            }
            //sync reunion
            if (SharedPreference.getIsVisibleReunion() == 1) {
              await syncDataController.syncReunionToSQLServer();
              await syncDataController.syncParticipantOfReunionToSQLServer();
              await syncDataController.syncActionOfReunionToSQLServer();
            }
            //sync pnc
            if (SharedPreference.getIsVisiblePNC() == 1) {
              await syncDataController.syncPNCToSQLServer();
              await syncDataController.syncProductPNCToSQLServer();
              await syncDataController.syncTypeCausePNCToSQLServer();
              await syncDataController.syncTypeProductPNCToSQLServer();
            }
            //sync incident env
            if (SharedPreference.getIsVisibleIncidentEnvironnement() == 1) {
              await syncDataController.syncIncidentEnvironnementToSQLServer();
              await syncDataController.syncTypeCauseIncEnvToSQLServer();
              await syncDataController.syncTypeConsequenceIncEnvToSQLServer();
              await syncDataController.syncActionIncEnvRattacherToSQLServer();
            }
            //sync incident sec
            if (SharedPreference.getIsVisibleIncidentSecurite() == 1) {
              await syncDataController.syncIncidentSecuriteToSQLServer();
              await syncDataController.syncTypeCauseIncSecToSQLServer();
              await syncDataController.syncTypeConsequenceIncSecToSQLServer();
              await syncDataController.syncCauseTypiqueIncSecToSQLServer();
              await syncDataController.syncSiteLesionIncSecToSQLServer();
              await syncDataController.syncActionIncSecRattacherToSQLServer();
            }
            //sync visite securite
            if (SharedPreference.getIsVisibleVisiteSecurite() == 1) {
              await syncDataController.syncVisiteSecuriteToSQLServer();
              await syncDataController.syncEquipeVSToSQLServer();
              await syncDataController.syncCheckListVSToSQLServer();
              await syncDataController.syncActionVSRattacherToSQLServer();
            }

            //---------------------------sync from web service to DB Local-------------------------

            await apiControllersCall.getDomaineAffectation();
            await apiControllersCall.getChampCache();
            await apiControllersCall.getChampObligatoireAction();

            ///action
            if (SharedPreference.getIsVisibleAction() == 1) {
              //agenda
              await apiControllersCall.getActionsRealisation();
              await apiControllersCall.getActionsSuivi();
              await apiControllersCall.getActionsSuiteAudit();
              //module action
              await apiControllersCall.getAction();
              await apiControllersCall.getSourceAction();
              await apiControllersCall.getTypeAction();
              await apiControllersCall.getResponsableCloture();
              await apiControllersCall.getAuditAction();
              await apiControllersCall.getTypeCauseAction();
              await apiControllersCall.getTypeCauseActionARattacher();
              await apiControllersCall.getAllSousAction();
              await apiControllersCall.getGravite();
              await apiControllersCall.getPriorite();
              await apiControllersCall.getProcessusEmploye();
            }

            ///pnc
            if (SharedPreference.getIsVisiblePNC() == 1) {
              //agenda
              await apiControllersCall.getPNCAValider();
              await apiControllersCall.getPNCACorriger();
              //await apiControllersCall.getPNCDecision();
              await apiControllersCall.getPNCInvestigationEffectuer();
              await apiControllersCall.getPNCInvestigationApprouver();
              await apiControllersCall.getPNCASuivre();
              await apiControllersCall.getPNCApprobationFinale();
              await apiControllersCall.getPNCDecisionTraitementAValidater();
              //module pnc
              await apiControllersCall.getPNC();
              await apiControllersCall.getAllProductsPNC();
              await apiControllersCall.getAllTypeCausePNC();
              await apiControllersCall.getChampObligatoirePNC();
              await apiControllersCall.getFournisseurs();
              await apiControllersCall.getTypePNC();
              await apiControllersCall.getGravitePNC();
              await apiControllersCall.getSourcePNC();
              await apiControllersCall.getAtelierPNC();
              await apiControllersCall.getClients();
              await apiControllersCall.getAllTypeCausePNCARattacher();
              //save is one/many product(s) in shared preference
              await PNCService().parametrageProduct().then((param) {
                Future oneProduct =
                    SharedPreference.setIsOneProduct(param['seulProduit']);
                if (param['seulProduit'] == 0) {
                  apiControllersCall.getAllTypeProductPNC();
                }
              }, onError: (error) {
                ShowSnackBar.snackBar(
                    'Error one product', error.toString(), Colors.red);
              });
            }
            //agenda pnc
            await apiControllersCall.getPNCDecision();
            await apiControllersCall.getPNCATraiter();

            ///reunion
            if (SharedPreference.getIsVisibleReunion() == 1) {
              //agenda
              await apiControllersCall.getReunionInformer();
              await apiControllersCall.getReunionPlanifier();

              ///module
              await apiControllersCall.getReunion();
              await apiControllersCall.getParticipantsReunion();
              await apiControllersCall.getActionReunionRattacher();
              await apiControllersCall.getTypeReunion();
            }
            // incident environnement
            if (SharedPreference.getIsVisibleIncidentEnvironnement() == 1) {
              //agenda
              await apiControllersCall.getIncidentEnvDecisionTraitement();
              await apiControllersCall.getIncidentEnvATraiter();
              await apiControllersCall.getIncidentEnvACloturer();

              ///module
              await apiControllersCall.getIncidentEnvironnement();
              await apiControllersCall.getChampObligatoireIncidentEnv();
              await apiControllersCall.getTypeIncidentEnv();
              await apiControllersCall.getTypeCauseIncidentEnv();
              await apiControllersCall.getTypeCauseIncidentEnvRattacher();
              await apiControllersCall.getCategoryIncidentEnv();
              await apiControllersCall.getTypeConsequenceIncidentEnvRattacher();
              await apiControllersCall.getTypeConsequenceIncidentEnv();
              await apiControllersCall.getLieuIncidentEnv();
              await apiControllersCall.getSourceIncidentEnv();
              await apiControllersCall.getCoutEstimeIncidentEnv();
              await apiControllersCall.getGraviteIncidentEnv();
              await apiControllersCall.getSecteurIncidentEnv();
              await apiControllersCall.getActionIncEnvRattacher();
            }
            //incident securite
            if (SharedPreference.getIsVisibleIncidentSecurite() == 1) {
              //agenda
              await apiControllersCall.getIncidentSecuriteDecisionTraitement();
              await apiControllersCall.getIncidentSecuriteATraiter();
              await apiControllersCall.getIncidentSecuriteACloturer();

              ///module
              await apiControllersCall.getIncidentSecurite();
              await apiControllersCall.getChampObligatoireIncidentSecurite();
              await apiControllersCall.getPosteTravailIncidentSecurite();
              await apiControllersCall.getTypeIncidentSecurite();
              await apiControllersCall.getCategoryIncidentSecurite();
              await apiControllersCall.getCauseTypiqueIncidentSecurite();
              await apiControllersCall.getTypeCauseIncidentSecRattacher();
              await apiControllersCall.getTypeConsequenceIncSecRattacher();
              await apiControllersCall.getCauseTypiqueIncSecRattacher();
              await apiControllersCall.getSiteLesionIncSecRattacher();
              await apiControllersCall.getTypeCauseIncidentSecurite();
              await apiControllersCall.getTypeConsequenceIncidentSecurite();
              await apiControllersCall.getSiteLesionIncidentSecurite();
              await apiControllersCall.getGraviteIncidentSecurite();
              await apiControllersCall.getSecteurIncidentSecurite();
              await apiControllersCall.getCoutEstemeIncedentSecurite();
              await apiControllersCall
                  .getEvenementDeclencheurIncidentSecurite();
              await apiControllersCall.getActionIncSecRattacher();
            }
            //Audit
            if (SharedPreference.getIsVisibleAudit() == 1) {
              //agenda
              await apiControllersCall.getAuditEnTantQueAudite();
              await apiControllersCall.getAuditEnTantQueAuditeur();
              await apiControllersCall.getRapportAuditsAValider();
              //Module
              await apiControllersCall.getAudits();
              await apiControllersCall.getChampAudit();
              await apiControllersCall.getTypeAudit();
              await apiControllersCall.getGraviteAudit();
              await apiControllersCall.getTypeConstatAudit();
              await apiControllersCall.getConstatsActionProv();
              await apiControllersCall.getConstatsAction();
              await apiControllersCall.getChampAuditByRefAudit();
              await apiControllersCall.getAuditeurInterne();
              await apiControllersCall.getAuditeurInterneARattacher();
              await apiControllersCall.getCheckListAudit();
              await apiControllersCall.getAuditeurExterneRattacher();
              await apiControllersCall.getAllAuditeursExterne();
              await apiControllersCall.getEmployeHabiliteAudit();
              //await apiControllersCall.getCritereCheckListAudit();
            }

            ///Module Visite Securite
            if (SharedPreference.getIsVisibleVisiteSecurite() == 1) {
              await apiControllersCall.getVisiteSecurite();
              await apiControllersCall.getCheckList();
              await apiControllersCall.getUniteVisiteSecurite();
              await apiControllersCall.getZoneVisiteSecurite();
              await apiControllersCall.getSiteVisiteSecurite();
              await apiControllersCall.getEquipeVisiteSecuriteFromAPI();
              await apiControllersCall.getCheckListVSRattacher();
              await apiControllersCall.getTauxCheckListVS();
              await apiControllersCall.getActionVSRattacher();
            }

            ///Module documentation
            if (SharedPreference.getIsVisibleDocumentation() == 1) {
              await apiControllersCall.getDocument();
              await apiControllersCall.getTypeDocument();
            }

            ///Domaine affectation
            await apiControllersCall.getEmploye();
            await apiControllersCall.getProduct();
            await apiControllersCall.getSite();
            await apiControllersCall.getProcessus();
            await apiControllersCall.getDirection();
            await apiControllersCall.getActivity();
            await apiControllersCall.getService();
          } else {
            ShowSnackBar.snackBar('Expired Licence', 'Your licence has expired',
                Colors.lightBlueAccent);
          }
        }, onError: (errorLicenceEnd) {
          ShowSnackBar.snackBar(
              "Error Licence End", errorLicenceEnd.toString(), Colors.red);
        });
      }
    } catch (exception) {
      isDataProcessing.value = false;
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    } finally {
      isDataProcessing.value = false;
    }
  }

  /*
  Future syncApiCallToLocalDB() async {
    try {
      isDataProcessing.value = true;
    var connection = await Connectivity().checkConnectivity();
    if(connection == ConnectivityResult.none) {
      Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue,
          snackPosition: SnackPosition.TOP);
    }
    else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
      Get.snackbar(
          "Internet Connection", "Add Data in DataBase Local", colorText: Colors.blue,
          snackPosition: SnackPosition.TOP);

      await apiControllersCall.getDomaineAffectation();
      await apiControllersCall.getChampCache();
      await apiControllersCall.getChampObligatoireAction();
      //agenda
      ///action
      await apiControllersCall.getActionsRealisation();
      await apiControllersCall.getActionsSuivi();
      await apiControllersCall.getActionsSuiteAudit();
      ///pnc
      await apiControllersCall.getPNCAValider();
      await apiControllersCall.getPNCACorriger();
      await apiControllersCall.getPNCDecision();
      await apiControllersCall.getPNCInvestigationEffectuer();
      await apiControllersCall.getPNCInvestigationApprouver();
      await apiControllersCall.getPNCATraiter();
      await apiControllersCall.getPNCASuivre();
      await apiControllersCall.getPNCApprobationFinale();
      await apiControllersCall.getPNCDecisionTraitementAValidater();
      ///reunion
      await apiControllersCall.getReunionInformer();
      await apiControllersCall.getReunionPlanifier();
      //incident env
      await apiControllersCall.getIncidentEnvDecisionTraitement();
      await apiControllersCall.getIncidentEnvATraiter();
      await apiControllersCall.getIncidentEnvACloturer();
      //incident securite
      await apiControllersCall.getIncidentSecuriteDecisionTraitement();
      await apiControllersCall.getIncidentSecuriteATraiter();
      await apiControllersCall.getIncidentSecuriteACloturer();
      //audite
      await apiControllersCall.getAuditEnTantQueAudite();
      await apiControllersCall.getAuditEnTantQueAuditeur();
      await apiControllersCall.getRapportAuditsAValider();
      ///domaine affectation
      await apiControllersCall.getSite();
      await apiControllersCall.getProcessus();
      await apiControllersCall.getDirection();
      await apiControllersCall.getActivity();
      await apiControllersCall.getService();
      await apiControllersCall.getEmploye();
      //module action
      await apiControllersCall.getAction();
      await apiControllersCall.getSourceAction();
      await apiControllersCall.getTypeAction();
      await apiControllersCall.getResponsableCloture();
      await apiControllersCall.getAuditAction();
      await apiControllersCall.getProduct();
      await apiControllersCall.getTypeCauseAction();
      await apiControllersCall.getTypeCauseActionARattacher();
      await apiControllersCall.getAllSousAction();
      await apiControllersCall.getGravite();
      await apiControllersCall.getPriorite();
      await apiControllersCall.getProcessusEmploye();
      //module pnc
      await apiControllersCall.getPNC();
      await apiControllersCall.getAllProductsPNC();
      await apiControllersCall.getAllTypeCausePNC();
      await apiControllersCall.getChampObligatoirePNC();
      await apiControllersCall.getFournisseurs();
      await apiControllersCall.getTypePNC();
      await apiControllersCall.getGravitePNC();
      await apiControllersCall.getSourcePNC();
      await apiControllersCall.getAtelierPNC();
      await apiControllersCall.getClients();
      await apiControllersCall.getAllTypeCausePNCARattacher();
      ///module reunion
      await apiControllersCall.getReunion();
      await apiControllersCall.getParticipantsReunion();
      await apiControllersCall.getTypeReunion();
      ///module documentation
      await apiControllersCall.getDocument();
      await apiControllersCall.getTypeDocument();
      ///module incident environnement
      await apiControllersCall.getIncidentEnvironnement();
      await apiControllersCall.getChampObligatoireIncidentEnv();
      await apiControllersCall.getTypeIncidentEnv();
      await apiControllersCall.getTypeCauseIncidentEnv();
      await apiControllersCall.getTypeCauseIncidentEnvRattacher();
      await apiControllersCall.getCategoryIncidentEnv();
      await apiControllersCall.getTypeConsequenceIncidentEnvRattacher();
      await apiControllersCall.getTypeConsequenceIncidentEnv();
      await apiControllersCall.getLieuIncidentEnv();
      await apiControllersCall.getSourceIncidentEnv();
      await apiControllersCall.getCoutEstimeIncidentEnv();
      await apiControllersCall.getGraviteIncidentEnv();
      await apiControllersCall.getSecteurIncidentEnv();
      ///module incident securite
      await apiControllersCall.getIncidentSecurite();
      await apiControllersCall.getChampObligatoireIncidentSecurite();
      await apiControllersCall.getPosteTravailIncidentSecurite();
      await apiControllersCall.getTypeIncidentSecurite();
      await apiControllersCall.getCategoryIncidentSecurite();
      await apiControllersCall.getCauseTypiqueIncidentSecurite();
      await apiControllersCall.getTypeCauseIncidentSecRattacher();
      await apiControllersCall.getTypeConsequenceIncSecRattacher();
      await apiControllersCall.getCauseTypiqueIncSecRattacher();
      await apiControllersCall.getSiteLesionIncSecRattacher();
      await apiControllersCall.getTypeCauseIncidentSecurite();
      await apiControllersCall.getTypeConsequenceIncidentSecurite();
      await apiControllersCall.getSiteLesionIncidentSecurite();
      await apiControllersCall.getGraviteIncidentSecurite();
      await apiControllersCall.getSecteurIncidentSecurite();
      await apiControllersCall.getCoutEstemeIncedentSecurite();
      await apiControllersCall.getEvenementDeclencheurIncidentSecurite();
      ///Module Visite Securite
      await apiControllersCall.getVisiteSecurite();
      await apiControllersCall. getCheckList();
      await apiControllersCall.getUniteVisiteSecurite();
      await apiControllersCall.getZoneVisiteSecurite();
      await apiControllersCall.getSiteVisiteSecurite();
      await apiControllersCall.getEquipeVisiteSecuriteFromAPI();
      //Module Audit
      await apiControllersCall.getAudits();
      await apiControllersCall.getChampAudit();
      await apiControllersCall.getTypeAudit();
      await apiControllersCall.getGraviteAudit();
      await apiControllersCall.getTypeConstatAudit();
      await apiControllersCall.getConstatsActionProv();
      await apiControllersCall.getConstatsAction();
      await apiControllersCall.getChampAuditByRefAudit();
      await apiControllersCall.getAuditeurInterne();
      await apiControllersCall.getAuditeurInterneARattacher();

      //save is one product in shared preference
      await PNCService().parametrageProduct().then((param){
        Future oneProduct = SharedPreference.setIsOneProduct(param['seulProduit']);
      },
          onError: (error){
            ShowSnackBar.snackBar('Error one product', error.toString(), Colors.red);
          });
    }
  } catch (exception) {
      isDataProcessing.value = false;
  ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
  return Future.error('service : ${exception.toString()}');
  }
  finally {
    isDataProcessing.value = false;
  }
  }
   */
}
