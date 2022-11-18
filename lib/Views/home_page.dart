import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:badges/badges.dart';
import 'package:connectivity/connectivity.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualipro_flutter/Agenda/Views/pnc/pnc_valider_page.dart';
import 'package:qualipro_flutter/Agenda/Views/reunion/reunion_planifier_page.dart';
import 'package:qualipro_flutter/Models/audit/audit_model.dart';
import 'package:qualipro_flutter/Models/reunion/reunion_model.dart';
import 'package:qualipro_flutter/Services/audit/audit_service.dart';
import 'package:qualipro_flutter/Services/audit/local_audit_service.dart';
import 'package:qualipro_flutter/Services/incident_environnement/local_incident_environnement_service.dart';
import 'package:qualipro_flutter/Services/incident_securite/local_incident_securite_service.dart';
import 'package:qualipro_flutter/Services/pnc/pnc_service.dart';
import 'package:qualipro_flutter/Services/reunion/local_reunion_service.dart';

import '../Agenda/Views/action/action_realisation_page.dart';
import '../Agenda/Views/action/action_suite_audit_page.dart';
import '../Agenda/Views/action/action_suivi_page.dart';
import '../Agenda/Views/audit/audits_audite_page.dart';
import '../Agenda/Views/audit/audits_auditeur_page.dart';
import '../Agenda/Views/audit/rapport_audit_a_valider_page.dart';
import '../Agenda/Views/incident_environnement/decision_traitement_incident_env_page.dart';
import '../Agenda/Views/incident_environnement/incident_env_a_cloturer_page.dart';
import '../Agenda/Views/incident_environnement/incident_env_a_traiter_page.dart';
import '../Agenda/Views/incident_securite/decision_traitement_incident_securite_page.dart';
import '../Agenda/Views/incident_securite/incident_securite_a_cloturer_page.dart';
import '../Agenda/Views/incident_securite/incident_securite_a_traiter_page.dart';
import '../Agenda/Views/pnc/pnc_approbation_finale_page.dart';
import '../Agenda/Views/pnc/pnc_corriger_page.dart';
import '../Agenda/Views/pnc/pnc_investigation_approuver_page.dart';
import '../Agenda/Views/pnc/pnc_investigation_effectuer_page.dart';
import '../Agenda/Views/pnc/pnc_suivre_page.dart';
import '../Agenda/Views/pnc/pnc_decision_traitement_page.dart';
import '../Agenda/Views/pnc/pnc_traiter_page.dart';
import '../Agenda/Views/pnc/pnc_valider_decision_traitement_page.dart';
import '../Agenda/Views/reunion/reunion_informer_page.dart';
import '../Controllers/api_controllers_call.dart';
import '../Controllers/home_controller.dart';
import '../Controllers/network_controller.dart';
import '../Controllers/sync_data_controller.dart';
import '../Models/action/action_realisation_model.dart';
import '../Models/action/action_suite_audit.dart';
import '../Models/action/action_suivi_model.dart';
import '../Models/begin_licence_model.dart';
import '../Models/incident_environnement/incident_env_agenda_model.dart';
import '../Models/incident_securite/incident_securite_agenda_model.dart';
import '../Models/licence_end_model.dart';
import '../Models/pnc/pnc_a_corriger_model.dart';
import '../Models/pnc/pnc_a_traiter_model.dart';
import '../Models/pnc/pnc_suivre_model.dart';
import '../Models/pnc/pnc_validation_decision_model.dart';
import '../Models/pnc/traitement_decision_model.dart';
import '../Services/action/action_service.dart';
import '../Services/action/local_action_service.dart';
import '../Services/incident_environnement/incident_environnement_service.dart';
import '../Services/incident_securite/incident_securite_service.dart';
import '../Services/licence_service.dart';
import '../Services/login_service.dart';
import '../Services/pnc/local_pnc_service.dart';
import '../Services/reunion/reunion_service.dart';
import '../Utils/custom_colors.dart';
import '../Utils/shared_preference.dart';
import '../Utils/snack_bar.dart';
import '../Widgets/app_bar_title.dart';
import '../Widgets/loading_widget.dart';
import '../Widgets/navigation_drawer_widget.dart';
import 'licence/licence_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NetworkController _networkController = Get.find<NetworkController>();

  ApiControllersCall apiControllersCall = ApiControllersCall();
  SyncDataController syncDataController = SyncDataController();
  LocalActionService localActionService = LocalActionService();
  LocalPNCService localPNCService = LocalPNCService();
  LocalReunionService localReunionService = LocalReunionService();
  LocalIncidentEnvironnementService localIncidentEnvironnementService =
      LocalIncidentEnvironnementService();
  LocalIncidentSecuriteService localIncidentSecuriteService =
      LocalIncidentSecuriteService();
  LocalAuditService localAuditService = LocalAuditService();

  bool isDataProcessing = false;
  final matricule = SharedPreference.getMatricule();
  //action
  var listActionReal = List<ActionRealisationModel>.empty(growable: true);
  var listActionSuivi = List<ActionSuiviModel>.empty(growable: true);
  var listActionSuiteAudit = List<ActionSuiteAudit>.empty(growable: true);
  int countListActionRealisation = 0;
  int countListActionSuivi = 0;
  int countListActionSuitAudit = 0;
  //pnc
  var listPNCTraiter = List<PNCTraiterModel>.empty(growable: true);
  int countListPNCTraiter = 0;
  var listPNCCorriger = List<PNCCorrigerModel>.empty(growable: true);
  int countListPNCCorriger = 0;
  var listPNCValider = List<PNCCorrigerModel>.empty(growable: true);
  int countListPNCValider = 0;
  var listPNCSuivre = List<PNCSuivreModel>.empty(growable: true);
  int countListPNCSuivre = 0;
  var listPNCInvestigationEffectuer =
      List<PNCSuivreModel>.empty(growable: true);
  int countlistPNCInvestigationEffectuer = 0;
  var listPNCInvestigationApprouver =
      List<PNCSuivreModel>.empty(growable: true);
  int countlistPNCInvestigationApprouver = 0;
  var listPNCDecision = List<TraitementDecisionModel>.empty(growable: true);
  int countListPNCDecision = 0;
  var listApprobationFinale = List<PNCSuivreModel>.empty(growable: true);
  int countApprobationFinale = 0;
  var listValidationTraitement =
      List<PNCValidationTraitementModel>.empty(growable: true);
  int countValidationTraitement = 0;
  //Reunion
  var listReunionInfo = List<ReunionModel>.empty(growable: true);
  int countReunionInfo = 0;
  var listReunionPlanifier = List<ReunionModel>.empty(growable: true);
  int countReunionPlanifier = 0;
  //Incident Env
  var listDecisionTraitementIncidentEnv =
      List<IncidentEnvAgendaModel>.empty(growable: true);
  int countDecisionTraitementIncidentEnv = 0;
  var listIncidentEnvATraiter =
      List<IncidentEnvAgendaModel>.empty(growable: true);
  int countIncidentEnvATraiter = 0;
  var listIncidentEnvACloturer =
      List<IncidentEnvAgendaModel>.empty(growable: true);
  int countIncidentEnvACloturer = 0;
  //Incident securite
  var listDecisionTraitementIncidentSecurite =
      List<IncidentSecuriteAgendaModel>.empty(growable: true);
  int countDecisionTraitementIncidentSecurite = 0;
  var listIncidentSecuriteATraiter =
      List<IncidentSecuriteAgendaModel>.empty(growable: true);
  int countIncidentSecuriteATraiter = 0;
  var listIncidentSecuriteACloturer =
      List<IncidentSecuriteAgendaModel>.empty(growable: true);
  int countIncidentSecuriteACloturer = 0;
  //Audit
  var listAuditEnTantQueAudite = List<AuditModel>.empty(growable: true);
  int countAuditEnTantQueAudite = 0;
  var listAuditEnTantQueAuditeur = List<AuditModel>.empty(growable: true);
  int countAuditEnTantQueAuditeur = 0;
  var listRapportAuditAValider = List<AuditModel>.empty(growable: true);
  int countRapportAuditAValider = 0;

  //accordion
  final _headerStyle = const TextStyle(
      color: Color(0xffffffff), fontSize: 20, fontWeight: FontWeight.bold);
  final _contentStyleHeader = const TextStyle(
      color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w700);
  final _contentStyle = const TextStyle(
      color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.normal);

  late ExpandableController expandableActionController;
  late ExpandableController expandablePNCController;
  late ExpandableController expandableReunionController;
  late ExpandableController expandableIncEnvController;
  late ExpandableController expandableIncSecController;
  late ExpandableController expandableAuditController;

  @override
  void initState() {
    super.initState();

    //verify if licence end or not
    checkLicence();

    expandableActionController = ExpandableController();
    expandablePNCController = ExpandableController();
    expandableReunionController = ExpandableController();
    expandableIncEnvController = ExpandableController();
    expandableIncSecController = ExpandableController();
    expandableAuditController = ExpandableController();

    setState(() {
      checkConnectivity();
      if (SharedPreference.getIsVisibleAction() == 1) {
        getActionsRealisation();
        getActionsSuivi();
        getActionsSuiteAudit();
      }
      if (SharedPreference.getIsVisiblePNC() == 1) {
        getPNCATraiter();
        getPNCACorriger();
        getPNCAValider();
        getPNCASuivre();
        getPNCInvestigationEffectuer();
        getPNCInvestigationApprouver();
        getPNCTraitementDecision();
        getValidationTraitement();
        getApprobationFinale();
      }
      if (SharedPreference.getIsVisibleReunion() == 1) {
        getReunionInfo();
        getReunionPlanifier();
      }
      if (SharedPreference.getIsVisibleIncidentEnvironnement() == 1) {
        getDecisionTraitementIncidentEnvironnement();
        getIncidentEnvironnementATraiter();
        getIncidentEnvironnementACloturer();
      }
      if (SharedPreference.getIsVisibleIncidentSecurite() == 1) {
        getDecisionTraitementIncidentSecurite();
        getIncidentSecuriteATraiter();
        getIncidentSecuriteACloturer();
      }
      if (SharedPreference.getIsVisibleAudit() == 1) {
        getAuditsEnTantQueAudite();
        getAuditsEnTantQueAuditeur();
        getRapportAuditsAValider();
      }
    });
  }

  @override
  void dispose() {
    expandableActionController.dispose();
    expandablePNCController.dispose();
    expandableReunionController.dispose();
    expandableIncEnvController.dispose();
    expandableIncSecController.dispose();
    expandableAuditController.dispose();

    super.dispose();
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
      setState(() {
        if (licenceEndModel?.retour == 0) {
          debugPrint('licence of device : $device_id');
        } else {
          Get.snackbar("Licence expired", "Your licence has expired",
              colorText: Colors.lightBlue, snackPosition: SnackPosition.BOTTOM);
          SharedPreference.clearSharedPreference();
          Get.off(LicencePage());
        }
      });
    } else if (connection == ConnectivityResult.wifi ||
        connection == ConnectivityResult.mobile) {
      await LoginService().isLicenceEndService({
        "deviceid": deviceId.toString(),
      }).then((responseLicenceEnd) async {
        debugPrint('responseLicenceEnd : ${responseLicenceEnd['retour']}');
        if (responseLicenceEnd['retour'] == 0) {
          debugPrint('licence of device : ${deviceId.toString()}');
        } else {
          ShowSnackBar.snackBar(SharedPreference.getDeviceNameKey().toString(),
              'Your licence has expired', Colors.lightBlueAccent);
          SharedPreference.clearSharedPreference();
          Get.off(LicencePage());
        }
      }, onError: (errorLicenceEnd) {
        ShowSnackBar.snackBar(
            "Error Licence End", errorLicenceEnd.toString(), Colors.red);
      });
    }
  }

  Future<void> checkConnectivity() async {
    var connection = await Connectivity().checkConnectivity();
    if (connection == ConnectivityResult.none) {
      Get.snackbar("No Connection", "Mode Offline",
          colorText: Colors.blue,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 1));
    } else if (connection == ConnectivityResult.wifi ||
        connection == ConnectivityResult.mobile) {
      Get.snackbar("Internet Connection", "Mode Online",
          colorText: Colors.blue,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 1));
    }

    /* if(_networkController.connectionStatus.value==1) {
      setState(() {
        Get.snackbar("Internet Connection", "Wifi", colorText: Colors.blue, snackPosition: SnackPosition.BOTTOM, duration: Duration(seconds: 5));
      });
    }
    else if(_networkController.connectionStatus.value==2){
      setState(() {
        Get.snackbar("Internet Connection", "Mobile", colorText: Colors.blue, snackPosition: SnackPosition.BOTTOM, duration: Duration(seconds: 5));
      });
    }
    else {
      setState(() {
        Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.BOTTOM, duration: Duration(seconds: 5));
      });
    } */
  }

  //methods
  //action
  void getActionsRealisation() async {
    try {
      isDataProcessing = true;
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        /* var response = await localActionService.readActionRealisation();
        response.forEach((data){
          var model = ActionRealisationModel();
          model.nomPrenom = data['nomPrenom'];
          model.nAct = data['nAct'];
          model.act = data['act'];
          model.nSousAct = data['nSousAct'];
          model.sousAct = data['sousAct'];
          model.respReal = data['respReal'];
          model.delaiReal = data['delaiReal'];
          model.delaiSuivi = data['delaiSuivi'];
          model.dateReal = data['dateReal'];
          model.dateSuivi = data['dateSuivi'];
          model.pourcentReal = data['pourcentReal'];
          model.depense = data['depense'];
          model.commentaire = data['commentaire'];
          model.cloture = data['cloture'];
          model.priorite = data['priorite'];
          model.gravite = data['gravite'];

          listActionReal.add(model);
          if(listActionReal.length == null){
            setState(() {
              countListActionRealisation = 0;
            });
          } else {
            setState(() {
              countListActionRealisation = listActionReal.length;
            });
          }

        }); */
        var count_action_realisation =
            await localActionService.getCountActionRealisation();
        if (count_action_realisation == 0) {
          setState(() {
            countListActionRealisation = 0;
          });
        } else {
          setState(() {
            countListActionRealisation = count_action_realisation;
          });
        }
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
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
            if (listActionReal.length == null) {
              setState(() {
                countListActionRealisation = 0;
              });
            } else {
              setState(() {
                countListActionRealisation = listActionReal.length;
              });
            }

            /* listActionReal.forEach((element) {
              print('element act ${element.act}, id act: ${element.nAct}');
            });
            print('length list action realiser: ${countListActionRealisation}'); */
          });
        }, onError: (err) {
          isDataProcessing = false;
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
      }
    } catch (exception) {
      isDataProcessing = false;
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing = false;
    }
  }

  void getActionsSuivi() async {
    try {
      isDataProcessing = true;
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        var count_action_suivi = await localActionService.getCountActionSuivi();
        print('count ActionSuivi=${count_action_suivi}');
        if (count_action_suivi == 0) {
          setState(() {
            countListActionSuivi = 0;
          });
        } else {
          setState(() {
            countListActionSuivi = count_action_suivi;
          });
        }
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        //rest api
        await ActionService().getActionSuivi({
          "mat": matricule.toString(),
          "ch_s": "0",
          "nact": 0,
          "nsact": ""
        }).then((resp) {
          //print('response: $resp');
          //isDataProcessing(false);
          resp.forEach((data) async {
            var model = ActionSuiviModel();
            model.nSousAct = data['nSousAct'];
            model.pourcentReal = data['pourcentReal'];
            model.causeModif = data['causeModif'];
            model.dateSuivi = data['dateSuivi'];
            model.act = data['act'];
            model.dateReal = data['dateReal'];
            model.nAct = data['nAct'];
            model.sousAct = data['sousAct'];
            model.delaiSuivi = data['delaiSuivi'];
            model.nomprerr = data['nomprerr'];
            model.pourcentSuivie = data['pourcentSuivie'];
            model.rapportEff = data['rapportEff'];
            model.depense = data['depense'];
            model.isd = data['isd'];
            model.expr1 = data['expr1'];
            model.designation = data['designation'];
            model.commentaire = data['commentaire'];
            model.dateSaisieSuiv = data['date_Saisie_Suiv'];
            model.ind = data['ind'];
            model.priorite = data['priorite'];
            model.gravite = data['gravite'];

            listActionSuivi.add(model);
            if (listActionSuivi.length == null) {
              countListActionSuivi = 0;
            } else {
              setState(() {
                countListActionSuivi = listActionSuivi.length;
              });
            }

            listActionSuivi.forEach((element) {
              print(
                  'element act suivi ${element.act}, id act: ${element.nAct}');
            });
            print('length list action suivi: ${countListActionSuivi}');
          });
        }, onError: (err) {
          isDataProcessing = false;
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
      }
    } catch (exception) {
      isDataProcessing = false;
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing = false;
    }
  }

  void getActionsSuiteAudit() async {
    try {
      isDataProcessing = true;
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        var count_action_suite_audit =
            await localActionService.getCountActionSuiteAudit();
        if (count_action_suite_audit == 0) {
          setState(() {
            countListActionSuitAudit = 0;
          });
        } else {
          setState(() {
            countListActionSuitAudit = count_action_suite_audit;
          });
        }
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
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
            if (listActionSuiteAudit.length == null) {
              countListActionSuitAudit = 0;
            } else {
              setState(() {
                countListActionSuitAudit = listActionSuiteAudit.length;
              });
            }
            /*listActionSuiteAudit.forEach((element) {
            print('element act ${element.act}, id act: ${element.act}');
          }); */
          });
        }, onError: (err) {
          isDataProcessing = false;
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
      }
    } catch (exception) {
      isDataProcessing = false;
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing = false;
    }
  }

  //pnc
  void getPNCATraiter() async {
    try {
      isDataProcessing = true;
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        var count_pnc_traiter = await localPNCService.getCountPNCATraiter();
        if (count_pnc_traiter == 0) {
          setState(() {
            countListPNCTraiter = 0;
          });
        } else {
          setState(() {
            countListPNCTraiter = count_pnc_traiter;
          });
        }
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        //rest api
        await PNCService().getPNCATraiter({
          "mat": matricule.toString(),
          "nc": "",
          "nnc": ""
        }).then((resp) async {
          //isDataProcessing(false);
          resp.forEach((data) async {
            var model = PNCTraiterModel();
            model.nnc = data['nnc'];
            model.dateDetect = data['dateDetect'];
            model.produit = data['produit'];
            model.typeNC = data['typeNC'];
            model.qteDetect = data['qteDetect'];
            model.codepdt = data['codepdt'];
            model.nlot = data['nlot'];
            model.ind = data['ind'];
            model.traitee = data['traitee'];
            model.dateT = data['dateT'];
            model.dateST = data['dateST'];
            model.nc = data['nc'];
            model.nomClt = data['nomClt'];
            model.traitement = data['traitement'];
            model.typeT = data['typeT'];

            listPNCTraiter.add(model);
            if (listPNCTraiter.length == null) {
              setState(() {
                countListPNCTraiter = 0;
              });
            } else {
              setState(() {
                countListPNCTraiter = listPNCTraiter.length;
              });
            }
          });
        }, onError: (err) {
          isDataProcessing = false;
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
      }
    } catch (exception) {
      isDataProcessing = false;
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing = false;
    }
  }

  void getPNCACorriger() async {
    try {
      isDataProcessing = true;
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        var count_pnc_corriger = await localPNCService.getCountPNCACorriger();
        if (count_pnc_corriger == 0) {
          setState(() {
            countListPNCCorriger = 0;
          });
        } else {
          setState(() {
            countListPNCCorriger = count_pnc_corriger;
          });
        }
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        //rest api
        await PNCService().getPNCACorriger(matricule).then((resp) async {
          //isDataProcessing(false);
          resp.forEach((data) async {
            setState(() {
              var model = PNCCorrigerModel();
              model.nnc = data['nnc'];
              model.motifRefus = data['motif_refus'];
              model.dateDetect = data['dateDetect'];
              model.produit = data['produit'];
              model.typeNC = data['typeNC'];
              model.qteDetect = data['qteDetect'];
              model.codepdt = data['codepdt'];
              model.nlot = data['nlot'];
              model.ind = data['ind'];
              model.traitee = data['traitee'];
              model.dateT = data['dateT'];
              model.dateST = data['dateST'];
              model.ninterne = data['ninterne'];
              listPNCCorriger.add(model);
              if (listPNCCorriger.length == null) {
                setState(() {
                  countListPNCCorriger = 0;
                });
              } else {
                setState(() {
                  countListPNCCorriger = listPNCCorriger.length;
                });
              }
            });
          });
        }, onError: (err) {
          isDataProcessing = false;
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
      }
    } catch (exception) {
      isDataProcessing = false;
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing = false;
    }
  }

  void getPNCAValider() async {
    try {
      isDataProcessing = true;
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        var count_pnc_valider = await localPNCService.getCountPNCValider();
        if (count_pnc_valider == 0) {
          setState(() {
            countListPNCValider = 0;
          });
        } else {
          setState(() {
            countListPNCValider = count_pnc_valider;
          });
        }
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        //rest api
        await PNCService().getPNCAValider(matricule).then((resp) async {
          //isDataProcessing(false);
          resp.forEach((data) async {
            setState(() {
              var model = PNCCorrigerModel();
              model.nnc = data['nnc'];
              //model.motifRefus = data['motif_refus'];
              model.dateDetect = data['dateDetect'];
              model.produit = data['produit'];
              model.typeNC = data['typeNC'];
              model.qteDetect = data['qteDetect'];
              model.codepdt = data['codepdt'];
              model.nlot = data['nlot'];
              model.ind = data['ind'];
              model.traitee = data['traitee'];
              model.dateT = data['dateT'];
              model.dateST = data['dateST'];
              model.ninterne = data['ninterne'];
              listPNCValider.add(model);
              if (listPNCValider.length == null) {
                setState(() {
                  countListPNCValider = 0;
                });
              } else {
                setState(() {
                  countListPNCValider = listPNCValider.length;
                });
              }
            });
          });
        }, onError: (err) {
          isDataProcessing = false;
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
      }
    } catch (exception) {
      isDataProcessing = false;
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing = false;
    }
  }

  void getPNCASuivre() async {
    try {
      isDataProcessing = true;
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        var count_pnc_suivre = await localPNCService.getCountPNCASuivre();
        if (count_pnc_suivre == 0) {
          setState(() {
            countListPNCSuivre = 0;
          });
        } else {
          setState(() {
            countListPNCSuivre = count_pnc_suivre;
          });
        }
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        //rest api
        await PNCService().getPNCASuivre(matricule).then((resp) async {
          //isDataProcessing(false);
          resp.forEach((data) async {
            setState(() {
              var model = PNCSuivreModel();
              model.nnc = data['nnc'];
              model.dateDetect = data['dateDetect'];
              model.produit = data['produit'];
              model.typeNC = data['typeNC'];
              model.qteDetect = data['qteDetect'];
              model.codepdt = data['codepdt'];
              model.delaiTrait = data['delaiTrait'];
              model.nlot = data['nlot'];
              model.ind = data['ind'];
              model.traitee = data['traitee'];
              model.nc = data['nc'];
              model.nomClt = data['nomClt'];
              listPNCSuivre.add(model);
              if (listPNCSuivre.length == null) {
                setState(() {
                  countListPNCSuivre = 0;
                });
              } else {
                setState(() {
                  countListPNCSuivre = listPNCSuivre.length;
                });
              }
            });
          });
        }, onError: (err) {
          isDataProcessing = false;
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
      }
    } catch (exception) {
      isDataProcessing = false;
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing = false;
    }
  }

  void getPNCInvestigationEffectuer() async {
    try {
      isDataProcessing = true;
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        var count_pnc_investigation_effectuer =
            await localPNCService.getCountPNCInvestigationEffectuer();
        if (count_pnc_investigation_effectuer == 0) {
          setState(() {
            countlistPNCInvestigationEffectuer = 0;
          });
        } else {
          setState(() {
            countlistPNCInvestigationEffectuer =
                count_pnc_investigation_effectuer;
          });
        }
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        //rest api
        await PNCService().getPNCInvestigationEffectuer(matricule).then(
            (resp) async {
          //isDataProcessing(false);
          resp.forEach((data) async {
            setState(() {
              var model = PNCSuivreModel();
              model.nnc = data['nnc'];
              model.dateDetect = data['dateDetect'];
              model.produit = data['produit'];
              model.typeNC = data['typeNC'];
              model.qteDetect = data['qteDetect'];
              model.codepdt = data['codepdt'];
              model.nlot = data['nlot'];
              model.ind = data['ind'];
              model.nomClt = data['nomClt'];
              listPNCInvestigationEffectuer.add(model);
              if (listPNCInvestigationEffectuer.length == null) {
                setState(() {
                  countlistPNCInvestigationEffectuer = 0;
                });
              } else {
                setState(() {
                  countlistPNCInvestigationEffectuer =
                      listPNCInvestigationEffectuer.length;
                });
              }
            });
          });
        }, onError: (err) {
          isDataProcessing = false;
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
      }
    } catch (exception) {
      isDataProcessing = false;
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing = false;
    }
  }

  void getPNCInvestigationApprouver() async {
    try {
      isDataProcessing = true;
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        var count_pnc_investigation_approuver =
            await localPNCService.getCountPNCInvestigationApprouver();
        if (count_pnc_investigation_approuver == 0) {
          setState(() {
            countlistPNCInvestigationApprouver = 0;
          });
        } else {
          setState(() {
            countlistPNCInvestigationApprouver =
                count_pnc_investigation_approuver;
          });
        }
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        //rest api
        await PNCService().getPNCInvestigationApprouver(matricule).then(
            (resp) async {
          //isDataProcessing(false);
          resp.forEach((data) async {
            setState(() {
              var model = PNCSuivreModel();
              model.nnc = data['nnc'];
              model.dateDetect = data['dateDetect'];
              model.produit = data['produit'];
              model.typeNC = data['typeNC'];
              model.qteDetect = data['qteDetect'];
              model.codepdt = data['codepdt'];
              model.nlot = data['nlot'];
              model.ind = data['ind'];
              model.nomClt = data['nomClt'];
              listPNCInvestigationApprouver.add(model);
              if (listPNCInvestigationApprouver.length == null) {
                setState(() {
                  countlistPNCInvestigationApprouver = 0;
                });
              } else {
                setState(() {
                  countlistPNCInvestigationApprouver =
                      listPNCInvestigationApprouver.length;
                });
              }
            });
          });
        }, onError: (err) {
          isDataProcessing = false;
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
      }
    } catch (exception) {
      isDataProcessing = false;
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing = false;
    }
  }

  void getPNCTraitementDecision() async {
    try {
      isDataProcessing = true;
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        var count_pnc_decision = await localPNCService.getCountPNCDecision();
        if (count_pnc_decision == 0) {
          setState(() {
            countListPNCDecision = 0;
          });
        } else {
          setState(() {
            countListPNCDecision = count_pnc_decision;
          });
        }
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        //rest api
        await PNCService().getPNCTraitementDecision(matricule).then(
            (resp) async {
          //isDataProcessing(false);
          resp.forEach((data) async {
            setState(() {
              var model = TraitementDecisionModel();
              model.nnc = data['nnc'];
              model.dateDetect = data['dateDetect'];
              model.produit = data['produit'];
              model.typeNC = data['typeNC'];
              model.qteDetect = data['qteDetect'];
              model.codepdt = data['codepdt'];
              model.nlot = data['nlot'];
              model.ind = data['ind'];
              model.nc = data['nc'];
              model.nomClt = data['nomClt'];
              model.commentaire = data['commentaire'];
              listPNCDecision.add(model);
              if (listPNCDecision.length == null) {
                setState(() {
                  countListPNCDecision = 0;
                });
              } else {
                setState(() {
                  countListPNCDecision = listPNCDecision.length;
                });
              }
            });
          });
        }, onError: (err) {
          isDataProcessing = false;
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
      }
    } catch (exception) {
      isDataProcessing = false;
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing = false;
    }
  }

  void getApprobationFinale() async {
    try {
      isDataProcessing = true;
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        var count_pnc_approbation_finale =
            await localPNCService.getCountPNCApprobationFinale();
        if (count_pnc_approbation_finale == 0) {
          setState(() {
            countApprobationFinale = 0;
          });
        } else {
          setState(() {
            countApprobationFinale = count_pnc_approbation_finale;
          });
        }
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        //rest api
        await PNCService().getApprobationFinale(matricule).then((resp) async {
          //isDataProcessing(false);
          resp.forEach((data) async {
            setState(() {
              var model = PNCSuivreModel();
              model.nnc = data['nnc'];
              model.dateDetect = data['dateDetect'];
              model.produit = data['produit'];
              model.typeNC = data['typeNC'];
              model.qteDetect = data['qteDetect'];
              model.codepdt = data['codePdt'];
              model.nlot = data['nlot'];
              model.ind = data['ind'];
              model.nomClt = data['nomClt'];
              listApprobationFinale.add(model);
              if (listApprobationFinale.length == null) {
                setState(() {
                  countApprobationFinale = 0;
                });
              } else {
                setState(() {
                  countApprobationFinale = listApprobationFinale.length;
                });
              }
            });
          });
        }, onError: (err) {
          isDataProcessing = false;
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
      }
    } catch (exception) {
      isDataProcessing = false;
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing = false;
    }
  }

  void getValidationTraitement() async {
    try {
      isDataProcessing = true;
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        var count_pnc_decision_validation =
            await localPNCService.getCountPNCDecisionValidation();
        if (count_pnc_decision_validation == 0) {
          setState(() {
            countValidationTraitement = 0;
          });
        } else {
          setState(() {
            countValidationTraitement = count_pnc_decision_validation;
          });
        }
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        //rest api
        await PNCService().getPNCValiderDecisionTraitement(matricule).then(
            (resp) async {
          //isDataProcessing(false);
          resp.forEach((data) async {
            setState(() {
              var model = PNCValidationTraitementModel();
              model.nnc = data['nnc'];
              model.dateDetect = data['dateDetect'];
              model.produit = data['produit'];
              model.typeNC = data['typeNC'];
              model.qteDetect = data['qteDetect'];
              model.codePdt = data['codePdt'];
              model.nc = data['nc'];
              model.nomClt = data['nomClt'];
              listValidationTraitement.add(model);
              if (listValidationTraitement.length == null) {
                setState(() {
                  countValidationTraitement = 0;
                });
              } else {
                setState(() {
                  countValidationTraitement = listValidationTraitement.length;
                });
              }
            });
          });
        }, onError: (err) {
          isDataProcessing = false;
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
      }
    } catch (exception) {
      isDataProcessing = false;
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing = false;
    }
  }

  //Reunion
  void getReunionInfo() async {
    try {
      isDataProcessing = true;
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        var count_reunion = await localReunionService.getCountReunionInformer();
        if (count_reunion == 0) {
          setState(() {
            countReunionInfo = 0;
          });
        } else {
          setState(() {
            countReunionInfo = count_reunion;
          });
        }
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        //rest api
        await ReunionService().getReunionInformer(matricule).then((resp) async {
          //isDataProcessing(false);
          resp.forEach((data) async {
            setState(() {
              var model = ReunionModel();
              model.nReunion = data['nReunion'];
              model.typeReunion = data['typeReunion'];
              model.datePrev = data['datePrev'];
              model.heureDeb = data['heureDeb'];
              model.lieu = data['lieu'];
              listReunionInfo.add(model);
              if (listReunionInfo.length == null) {
                setState(() {
                  countReunionInfo = 0;
                });
              } else {
                setState(() {
                  countReunionInfo = listReunionInfo.length;
                });
              }
            });
          });
        }, onError: (err) {
          isDataProcessing = false;
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
      }
    } catch (exception) {
      isDataProcessing = false;
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing = false;
    }
  }

  void getReunionPlanifier() async {
    try {
      isDataProcessing = true;
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        var count_reunion =
            await localReunionService.getCountReunionPlanifier();
        if (count_reunion == 0) {
          setState(() {
            countReunionPlanifier = 0;
          });
        } else {
          setState(() {
            countReunionPlanifier = count_reunion;
          });
        }
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        //rest api
        await ReunionService().getReunionPlanifier(matricule).then(
            (resp) async {
          //isDataProcessing(false);
          resp.forEach((data) async {
            setState(() {
              var model = ReunionModel();
              model.nReunion = data['nReunion'];
              model.typeReunion = data['typeReunion'];
              model.datePrev = data['datePrev'];
              model.ordreJour = data['ordreJour'];
              model.heureDeb = data['heureDeb'];
              model.heureFin = data['heureFin'];
              model.lieu = data['lieu'];
              listReunionPlanifier.add(model);
              if (listReunionPlanifier.length == null) {
                setState(() {
                  countReunionPlanifier = 0;
                });
              } else {
                setState(() {
                  countReunionPlanifier = listReunionPlanifier.length;
                });
              }
            });
          });
        }, onError: (err) {
          isDataProcessing = false;
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
      }
    } catch (exception) {
      isDataProcessing = false;
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing = false;
    }
  }

  //incident environnement
  void getDecisionTraitementIncidentEnvironnement() async {
    try {
      isDataProcessing = true;
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        var count_incident_env = await localIncidentEnvironnementService
            .getCountIncidentEnvDecisionTraitement();
        if (count_incident_env == 0) {
          setState(() {
            countDecisionTraitementIncidentEnv = 0;
          });
        } else {
          setState(() {
            countDecisionTraitementIncidentEnv = count_incident_env;
          });
        }
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        //rest api
        await IncidentEnvironnementService()
            .getListIncidentEnvDecisionTraitement(matricule)
            .then((resp) async {
          //isDataProcessing(false);
          resp.forEach((data) async {
            setState(() {
              var model = IncidentEnvAgendaModel();
              model.nIncident = data['nIncident'];
              model.incident = data['incident'];
              model.dateDetect = data['date_detect'];
              listDecisionTraitementIncidentEnv.add(model);
              if (listDecisionTraitementIncidentEnv.length == null) {
                setState(() {
                  countDecisionTraitementIncidentEnv = 0;
                });
              } else {
                setState(() {
                  countDecisionTraitementIncidentEnv =
                      listDecisionTraitementIncidentEnv.length;
                });
              }
            });
          });
        }, onError: (err) {
          isDataProcessing = false;
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
      }
    } catch (exception) {
      isDataProcessing = false;
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing = false;
    }
  }

  void getIncidentEnvironnementATraiter() async {
    try {
      isDataProcessing = true;
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        var count_incident_env_traiter = await localIncidentEnvironnementService
            .getCountIncidentEnvATraiter();
        if (count_incident_env_traiter == 0) {
          setState(() {
            countIncidentEnvATraiter = 0;
          });
        } else {
          setState(() {
            countIncidentEnvATraiter = count_incident_env_traiter;
          });
        }
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        //rest api
        await IncidentEnvironnementService()
            .getListIncidentEnvATraiter(matricule)
            .then((resp) async {
          //isDataProcessing(false);
          resp.forEach((data) async {
            setState(() {
              var model = IncidentEnvAgendaModel();
              model.nIncident = data['nIncident'];
              model.incident = data['incident'];
              model.dateDetect = data['date_detect'];
              listIncidentEnvATraiter.add(model);
              if (listIncidentEnvATraiter.length == null) {
                setState(() {
                  countIncidentEnvATraiter = 0;
                });
              } else {
                setState(() {
                  countIncidentEnvATraiter = listIncidentEnvATraiter.length;
                });
              }
            });
          });
        }, onError: (err) {
          isDataProcessing = false;
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
      }
    } catch (exception) {
      isDataProcessing = false;
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing = false;
    }
  }

  void getIncidentEnvironnementACloturer() async {
    try {
      isDataProcessing = true;
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        var count_incident_env = await localIncidentEnvironnementService
            .getCountIncidentEnvACloturer();
        if (count_incident_env == 0) {
          setState(() {
            countIncidentEnvACloturer = 0;
          });
        } else {
          setState(() {
            countIncidentEnvACloturer = count_incident_env;
          });
        }
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        //rest api
        await IncidentEnvironnementService()
            .getListIncidentEnvACloturer(matricule)
            .then((resp) async {
          //isDataProcessing(false);
          resp.forEach((data) async {
            setState(() {
              var model = IncidentEnvAgendaModel();
              model.nIncident = data['nIncident'];
              model.incident = data['incident'];
              model.dateDetect = data['date_detect'];
              listIncidentEnvACloturer.add(model);
              if (listIncidentEnvACloturer.length == null) {
                setState(() {
                  countIncidentEnvACloturer = 0;
                });
              } else {
                setState(() {
                  countIncidentEnvACloturer = listIncidentEnvACloturer.length;
                });
              }
            });
          });
        }, onError: (err) {
          isDataProcessing = false;
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
      }
    } catch (exception) {
      isDataProcessing = false;
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing = false;
    }
  }

  //incident securite
  void getDecisionTraitementIncidentSecurite() async {
    try {
      isDataProcessing = true;
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        var count_incident = await localIncidentSecuriteService
            .getCountIncidentSecuriteDecisionTraitement();
        if (count_incident == 0) {
          setState(() {
            countDecisionTraitementIncidentSecurite = 0;
          });
        } else {
          setState(() {
            countDecisionTraitementIncidentSecurite = count_incident;
          });
        }
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        //rest api
        await IncidentSecuriteService()
            .getListIncidentSecuriteDecisionTraitement(matricule)
            .then((resp) async {
          //isDataProcessing(false);
          resp.forEach((data) async {
            setState(() {
              var model = IncidentSecuriteAgendaModel();
              model.ref = data['ref'];
              model.designation = data['designation'];
              model.dateInc = data['date_inc'];
              listDecisionTraitementIncidentSecurite.add(model);
              if (listDecisionTraitementIncidentSecurite.length == null) {
                setState(() {
                  countDecisionTraitementIncidentSecurite = 0;
                });
              } else {
                setState(() {
                  countDecisionTraitementIncidentSecurite =
                      listDecisionTraitementIncidentSecurite.length;
                });
              }
            });
          });
        }, onError: (err) {
          isDataProcessing = false;
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
      }
    } catch (exception) {
      isDataProcessing = false;
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing = false;
    }
  }

  void getIncidentSecuriteATraiter() async {
    try {
      isDataProcessing = true;
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        var count_incident = await localIncidentSecuriteService
            .getCountIncidentSecuriteATraiter();
        if (count_incident == 0) {
          setState(() {
            countIncidentSecuriteATraiter = 0;
          });
        } else {
          setState(() {
            countIncidentSecuriteATraiter = count_incident;
          });
        }
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        //rest api
        await IncidentSecuriteService()
            .getListIncidentSecuriteATraiter(matricule)
            .then((resp) async {
          //isDataProcessing(false);
          resp.forEach((data) async {
            setState(() {
              var model = IncidentSecuriteAgendaModel();
              model.ref = data['ref'];
              model.designation = data['designation'];
              model.dateInc = data['date_inc'];
              listIncidentSecuriteATraiter.add(model);
              if (listIncidentSecuriteATraiter.length == null) {
                setState(() {
                  countIncidentSecuriteATraiter = 0;
                });
              } else {
                setState(() {
                  countIncidentSecuriteATraiter =
                      listIncidentSecuriteATraiter.length;
                });
              }
            });
          });
        }, onError: (err) {
          isDataProcessing = false;
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
      }
    } catch (exception) {
      isDataProcessing = false;
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing = false;
    }
  }

  void getIncidentSecuriteACloturer() async {
    try {
      isDataProcessing = true;
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        var count_incident = await localIncidentSecuriteService
            .getCountIncidentSecuriteACloturer();
        if (count_incident == 0) {
          setState(() {
            countIncidentSecuriteACloturer = 0;
          });
        } else {
          setState(() {
            countIncidentSecuriteACloturer = count_incident;
          });
        }
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        //rest api
        await IncidentSecuriteService()
            .getListIncidentSecuriteACloturer(matricule)
            .then((resp) async {
          //isDataProcessing(false);
          resp.forEach((data) async {
            setState(() {
              var model = IncidentSecuriteAgendaModel();
              model.ref = data['ref'];
              model.designation = data['designation'];
              model.dateInc = data['date_inc'];
              listIncidentSecuriteACloturer.add(model);
              if (listIncidentSecuriteACloturer.length == null) {
                setState(() {
                  countIncidentSecuriteACloturer = 0;
                });
              } else {
                setState(() {
                  countIncidentSecuriteACloturer =
                      listIncidentSecuriteACloturer.length;
                });
              }
            });
          });
        }, onError: (err) {
          isDataProcessing = false;
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
      }
    } catch (exception) {
      isDataProcessing = false;
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing = false;
    }
  }

  //audit
  void getAuditsEnTantQueAudite() async {
    try {
      isDataProcessing = true;
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        var count_audit = await localAuditService.getCountAuditAudite();
        if (count_audit == 0) {
          setState(() {
            countAuditEnTantQueAudite = 0;
          });
        } else {
          setState(() {
            countAuditEnTantQueAudite = count_audit;
          });
        }
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        //rest api
        await AuditService().getAuditsEnTantQueAudite().then((resp) async {
          //isDataProcessing(false);
          resp.forEach((data) async {
            setState(() {
              var model = new AuditModel();
              model.idAudit = data['idAudit'];
              model.refAudit = data['refAudit'];
              model.champ = data['champ'];
              model.dateDebPrev = data['dateDebPrev'];
              model.interne = data['interne'];
              listAuditEnTantQueAudite.add(model);
              if (listAuditEnTantQueAudite.length == null) {
                setState(() {
                  countAuditEnTantQueAudite = 0;
                });
              } else {
                setState(() {
                  countAuditEnTantQueAudite = listAuditEnTantQueAudite.length;
                });
              }
            });
          });
        }, onError: (err) {
          isDataProcessing = false;
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
      }
    } catch (exception) {
      isDataProcessing = false;
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing = false;
    }
  }

  void getAuditsEnTantQueAuditeur() async {
    try {
      isDataProcessing = true;
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        var count_auditeur = await localAuditService.getCountAuditAuditeur();
        if (count_auditeur == 0) {
          setState(() {
            countAuditEnTantQueAuditeur = 0;
          });
        } else {
          setState(() {
            countAuditEnTantQueAuditeur = count_auditeur;
          });
        }
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        //rest api
        await AuditService().getAuditsEnTantQueAuditeur().then((resp) async {
          //isDataProcessing(false);
          resp.forEach((data) async {
            setState(() {
              var model = new AuditModel();
              model.idAudit = data['idAudit'];
              model.refAudit = data['refAudit'];
              model.champ = data['champ'];
              model.dateDebPrev = data['dateDebPrev'];
              model.interne = data['interne'];
              listAuditEnTantQueAuditeur.add(model);
              if (listAuditEnTantQueAuditeur.length == null) {
                setState(() {
                  countAuditEnTantQueAuditeur = 0;
                });
              } else {
                setState(() {
                  countAuditEnTantQueAuditeur =
                      listAuditEnTantQueAuditeur.length;
                });
              }
            });
          });
        }, onError: (err) {
          isDataProcessing = false;
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
      }
    } catch (exception) {
      isDataProcessing = false;
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing = false;
    }
  }

  void getRapportAuditsAValider() async {
    try {
      isDataProcessing = true;
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        var count_rapport_audit =
            await localAuditService.getCountRapportAuditAValider();
        if (count_rapport_audit == 0) {
          setState(() {
            countRapportAuditAValider = 0;
          });
        } else {
          setState(() {
            countRapportAuditAValider = count_rapport_audit;
          });
        }
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        //rest api
        await AuditService().getRapportAuditsAValider().then((response) async {
          //isDataProcessing(false);
          response.forEach((data) async {
            setState(() {
              var model = new AuditModel();
              model.idAudit = data['idAudit'];
              model.refAudit = data['refAudit'];
              model.champ = data['champ'];
              model.typeA = data['typeA'];
              model.interne = data['interne'];
              listRapportAuditAValider.add(model);
              if (listRapportAuditAValider.length == null) {
                setState(() {
                  countRapportAuditAValider = 0;
                });
              } else {
                setState(() {
                  countRapportAuditAValider = listRapportAuditAValider.length;
                });
              }
            });
          });
        }, onError: (err) {
          isDataProcessing = false;
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
      }
    } catch (exception) {
      isDataProcessing = false;
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing = false;
    }
  }

  /*
  static Future<bool> isInternet()async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      if (await DataConnectionChecker().hasConnection) {
        print("Mobile data detected & internet connection confirmed.");
        return true;
      }else{
        print('No internet :( Reason:');
        return false;
      }
    } else if (connectivityResult == ConnectivityResult.wifi) {
      if (await DataConnectionChecker().hasConnection) {
        print("wifi data detected & internet connection confirmed.");
        return true;
      }else{
        print('No internet :( Reason:');
        return false;
      }
    }else {
      print("Neither mobile data or WIFI detected, not internet connection found.");
      return false;
    }
  }
   */

  Future syncApiCallToLocalDB() async {
    //await Get.find<OnBoardingController>().syncApiCallToLocalDB();
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
          Get.snackbar(
              "Internet Connection", "Please wait to Synchronization Data",
              colorText: Colors.blue,
              snackPosition: SnackPosition.TOP,
              duration: Duration(seconds: 10),
              titleText: CircularProgressIndicator());
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
            await apiControllersCall.getPriorite();
            await apiControllersCall.getGravite();
            await apiControllersCall.getProcessusEmploye();
            await apiControllersCall.getAllSousAction();
          }

          ///pnc
          if (SharedPreference.getIsVisiblePNC() == 1) {
            //agenda
            await apiControllersCall.getPNCAValider();
            await apiControllersCall.getPNCACorriger();
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
            //save is one product in shared preference
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

          ///reunion
          if (SharedPreference.getIsVisibleReunion() == 1) {
            //agenda
            await apiControllersCall.getReunionInformer();
            await apiControllersCall.getReunionPlanifier();

            ///module reunion
            await apiControllersCall.getReunion();
            await apiControllersCall.getParticipantsReunion();
            await apiControllersCall.getActionReunionRattacher();
            await apiControllersCall.getTypeReunion();
          }
          //incident env
          if (SharedPreference.getIsVisibleIncidentEnvironnement() == 1) {
            //agenda
            await apiControllersCall.getIncidentEnvDecisionTraitement();
            await apiControllersCall.getIncidentEnvATraiter();
            await apiControllersCall.getIncidentEnvACloturer();

            ///module incident environnement
            await apiControllersCall.getIncidentEnvironnement();
            await apiControllersCall.getChampObligatoireIncidentEnv();
            await apiControllersCall.getTypeIncidentEnv();
            await apiControllersCall.getTypeCauseIncidentEnvRattacher();
            await apiControllersCall.getTypeCauseIncidentEnv();
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
            await apiControllersCall.getActionIncSecRattacher();
          }
          //audit
          if (SharedPreference.getIsVisibleAudit() == 1) {
            //agenda
            await apiControllersCall.getAuditEnTantQueAudite();
            await apiControllersCall.getAuditEnTantQueAuditeur();
            await apiControllersCall.getRapportAuditsAValider();
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

          ///module documentation
          if (SharedPreference.getIsVisibleDocumentation() == 1) {
            await apiControllersCall.getDocument();
            await apiControllersCall.getTypeDocument();
          }
          //agenda pnc
          await apiControllersCall.getPNCDecision();
          await apiControllersCall.getPNCATraiter();
          //domaine affectation
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
  }

  //View
  @override
  Widget build(BuildContext context) {
    final keyRefresh = GlobalKey<RefreshIndicatorState>();
    const Color lightPrimary = Colors.white;
    const Color darkPrimary = Colors.white;
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,

        /// 2- to call ui of AppBarTitle class ///
        title: AppBarTitle(),
        iconTheme: IconThemeData(color: CustomColors.blueAccent, size: 40),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              splashColor: CustomColors.blueAccent,
              onTap: () {
                syncApiCallToLocalDB();
              },
              child: Icon(
                Icons.sync,
                color: CustomColors.blueMarin,
                size: 40,
              ),
            ),
          )
        ],
      ),
      body: isDataProcessing == true
          ? Center(
              child: LoadingView(),
            )
          : ListView(
              children: <Widget>[
                //agenda Action
                Visibility(
                  visible:
                      SharedPreference.getIsVisibleAction() == 1 ? true : false,
                  child: ExpandableNotifier(
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        color: const Color(0xFF0B9205),
                        child: ScrollOnExpand(
                          child: ExpandablePanel(
                            controller: expandableActionController,
                            theme: const ExpandableThemeData(
                                expandIcon: Icons.arrow_downward,
                                collapseIcon: Icons.arrow_upward,
                                tapBodyToCollapse: true,
                                tapBodyToExpand: true,
                                hasIcon: true),
                            header: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  const Icon(Icons.pending_actions,
                                      color: Colors.white),
                                  Text(
                                    'Action',
                                    style: _headerStyle,
                                  ),
                                  Badge(
                                    badgeColor: Colors.white,
                                    badgeContent: Text(
                                      '${countListActionRealisation + countListActionSuivi + countListActionSuitAudit}',
                                      style: const TextStyle(
                                          color: Color(0xFF0B9205)),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            collapsed: const Padding(
                              padding: EdgeInsets.all(0),
                            ),
                            /*collapsed: Text('Module Action',
                        style: TextStyle(fontSize: 18, color: Colors.black), softWrap: true,
                        maxLines: 2, overflow: TextOverflow.ellipsis,), */
                            expanded: Column(
                              children: <Widget>[
                                Visibility(
                                  visible: countListActionRealisation == 0
                                      ? false
                                      : true,
                                  child: GestureDetector(
                                    onTap: () {
                                      countListActionRealisation == 0
                                          ? null
                                          : Get.to(ActionRealisationPage(),
                                              transition: Transition.zoom,
                                              duration:
                                                  Duration(milliseconds: 500));
                                    },
                                    child: Card(
                                      color: Color(0xFFFFFFFF),
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.access_time,
                                          color: Colors.black87,
                                          size: 45,
                                        ),
                                        title: Text(
                                          'Action à realiser',
                                          style: _contentStyleHeader,
                                        ),
                                        trailing: Badge(
                                          badgeColor: const Color(0xFF0B9205),
                                          badgeContent: Text(
                                            '$countListActionRealisation',
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible:
                                      countListActionSuivi == 0 ? false : true,
                                  child: GestureDetector(
                                    onTap: () {
                                      countListActionSuivi == 0
                                          ? null
                                          : Get.to(ActionSuiviPage(),
                                              transition: Transition.zoom,
                                              duration:
                                                  Duration(milliseconds: 500));
                                    },
                                    child: Card(
                                      color: Color(0xFFE9EAEE),
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.book_rounded,
                                          color: Colors.black87,
                                          size: 45,
                                        ),
                                        title: Text('Action à suivre',
                                            style: _contentStyleHeader),
                                        trailing: Badge(
                                          badgeColor: const Color(0xFF0B9205),
                                          badgeContent: Text(
                                            '$countListActionSuivi',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: countListActionSuitAudit == 0
                                      ? false
                                      : true,
                                  child: GestureDetector(
                                    onTap: () {
                                      countListActionSuitAudit == 0
                                          ? null
                                          : Get.to(ActionSuiteAuditPage(),
                                              transition: Transition.zoom,
                                              duration:
                                                  Duration(milliseconds: 500));
                                    },
                                    child: Card(
                                      color: Color(0xFFE9EAEE),
                                      child: ListTile(
                                        leading: const Icon(
                                          Icons.bookmark_border,
                                          color: Colors.black87,
                                          size: 45,
                                        ),
                                        title: Text('Action suite à audit',
                                            style: _contentStyleHeader),
                                        trailing: Badge(
                                          badgeColor: const Color(0xFF0B9205),
                                          badgeContent: Text(
                                            '$countListActionSuitAudit',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            builder: (_, collapsed, expanded) => Padding(
                              padding:
                                  const EdgeInsets.all(8.0).copyWith(top: 0),
                              child: Expandable(
                                  collapsed: collapsed, expanded: expanded),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //agenda PNC
                Visibility(
                  visible:
                      SharedPreference.getIsVisiblePNC() == 1 ? true : false,
                  child: ExpandableNotifier(
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        color: Color(0xFF3687CB),
                        child: ScrollOnExpand(
                          child: ExpandablePanel(
                            controller: expandablePNCController,
                            theme: const ExpandableThemeData(
                                expandIcon: Icons.arrow_downward,
                                collapseIcon: Icons.arrow_upward,
                                tapBodyToCollapse: true,
                                tapBodyToExpand: true,
                                hasIcon: true),
                            header: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  const Icon(Icons.compare_rounded,
                                      color: Colors.white),
                                  const Text(
                                    'PNC',
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  Badge(
                                    badgeColor: Colors.white,
                                    badgeContent: Text(
                                      '${countListPNCValider + countListPNCCorriger + countlistPNCInvestigationEffectuer + countListPNCDecision + countlistPNCInvestigationApprouver + countValidationTraitement + countListPNCTraiter + countListPNCSuivre + countApprobationFinale}',
                                      style: const TextStyle(
                                          color: Color(0xFF3687CB)),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            collapsed: const Padding(
                              padding: EdgeInsets.all(0),
                            ),
                            /*collapsed: Text('Module Action',
                        style: TextStyle(fontSize: 18, color: Colors.black), softWrap: true,
                        maxLines: 2, overflow: TextOverflow.ellipsis,), */
                            expanded: Column(
                              children: <Widget>[
                                Visibility(
                                  visible:
                                      countListPNCValider == 0 ? false : true,
                                  child: GestureDetector(
                                    onTap: () {
                                      countListPNCValider == 0
                                          ? null
                                          : Get.to(PNCValiderPage(),
                                              transition: Transition.zoom,
                                              duration:
                                                  Duration(milliseconds: 500));
                                    },
                                    child: Card(
                                      color: Color(0xFFFFFFFF),
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.library_add_check,
                                          color: Colors.black87,
                                          size: 45,
                                        ),
                                        title: Text(
                                          'Non Confirmité à Valider',
                                          style: _contentStyleHeader,
                                        ),
                                        trailing: Badge(
                                          badgeColor: Colors.blue,
                                          badgeContent: Text(
                                            '$countListPNCValider',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible:
                                      countListPNCCorriger == 0 ? false : true,
                                  child: GestureDetector(
                                    onTap: () {
                                      countListPNCCorriger == 0
                                          ? null
                                          : Get.to(PNCCorrigerPage(),
                                              transition: Transition.zoom,
                                              duration:
                                                  Duration(milliseconds: 500));
                                    },
                                    child: Card(
                                      color: Color(0xFFE9EAEE),
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.library_add_check_outlined,
                                          color: Colors.black87,
                                          size: 45,
                                        ),
                                        title: Text('Non Confirmité à Corriger',
                                            style: _contentStyleHeader),
                                        trailing: Badge(
                                          badgeColor: Colors.blue,
                                          badgeContent: Text(
                                            '$countListPNCCorriger',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible:
                                      countlistPNCInvestigationEffectuer == 0
                                          ? false
                                          : true,
                                  child: GestureDetector(
                                    onTap: () {
                                      countlistPNCInvestigationEffectuer == 0
                                          ? null
                                          : Get.to(
                                              PNCInvestigationEffectuerPage(),
                                              transition: Transition.zoom,
                                              duration:
                                                  Duration(milliseconds: 500));
                                    },
                                    child: Card(
                                      color: Color(0xFFE9EAEE),
                                      child: ListTile(
                                        leading: const Icon(
                                          Icons.my_library_add_outlined,
                                          color: Colors.black87,
                                          size: 45,
                                        ),
                                        title: Text('Investigation à effectuer',
                                            style: _contentStyleHeader),
                                        trailing: Badge(
                                          badgeColor: Colors.blue,
                                          badgeContent: Text(
                                            '$countlistPNCInvestigationEffectuer',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible:
                                      countListPNCDecision == 0 ? false : true,
                                  child: GestureDetector(
                                    onTap: () {
                                      countListPNCDecision == 0
                                          ? null
                                          : Get.to(PNCTraitementDecisionPage(),
                                              transition: Transition.zoom,
                                              duration:
                                                  Duration(milliseconds: 500));
                                    },
                                    child: Card(
                                      color: Color(0xFFE9EAEE),
                                      child: ListTile(
                                        leading: const Icon(
                                          Icons.library_music_rounded,
                                          color: Colors.black87,
                                          size: 45,
                                        ),
                                        title: Text('Decision de Traitement',
                                            style: _contentStyleHeader),
                                        trailing: Badge(
                                          badgeColor: Colors.blue,
                                          badgeContent: Text(
                                            '$countListPNCDecision',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible:
                                      countlistPNCInvestigationApprouver == 0
                                          ? false
                                          : true,
                                  child: GestureDetector(
                                    onTap: () {
                                      countlistPNCInvestigationApprouver == 0
                                          ? null
                                          : Get.to(
                                              PNCInvestigationApprouverPage(),
                                              transition: Transition.zoom,
                                              duration:
                                                  Duration(milliseconds: 500));
                                    },
                                    child: Card(
                                      color: Color(0xFFE9EAEE),
                                      child: ListTile(
                                        leading: const Icon(
                                          Icons.library_add,
                                          color: Colors.black87,
                                          size: 45,
                                        ),
                                        title: Text('Investigation à approuver',
                                            style: _contentStyleHeader),
                                        trailing: Badge(
                                          badgeColor: Colors.blue,
                                          badgeContent: Text(
                                            '$countlistPNCInvestigationApprouver',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: countValidationTraitement == 0
                                      ? false
                                      : true,
                                  child: GestureDetector(
                                    onTap: () {
                                      countValidationTraitement == 0
                                          ? null
                                          : Get.to(
                                              PNCValiderDecisionTraitementPage(),
                                              transition: Transition.zoom,
                                              duration:
                                                  Duration(milliseconds: 500));
                                    },
                                    child: Card(
                                      color: Color(0xFFE9EAEE),
                                      child: ListTile(
                                        leading: const Icon(
                                          Icons.library_music_outlined,
                                          color: Colors.black87,
                                          size: 45,
                                        ),
                                        title: Text('Traitement à Valider',
                                            style: _contentStyleHeader),
                                        trailing: Badge(
                                          badgeColor: Colors.blue,
                                          badgeContent: Text(
                                            '$countValidationTraitement',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible:
                                      countListPNCTraiter == 0 ? false : true,
                                  child: GestureDetector(
                                    onTap: () {
                                      countListPNCTraiter == 0
                                          ? null
                                          : Get.to(PNCTraiterPage(),
                                              transition: Transition.zoom,
                                              duration:
                                                  Duration(milliseconds: 500));
                                    },
                                    child: Card(
                                      color: Color(0xFFE9EAEE),
                                      child: ListTile(
                                        leading: const Icon(
                                          Icons.library_books,
                                          color: Colors.black87,
                                          size: 45,
                                        ),
                                        title: Text('Non Confirmité à Traiter',
                                            style: _contentStyleHeader),
                                        trailing: Badge(
                                          badgeColor: Colors.blue,
                                          badgeContent: Text(
                                            '$countListPNCTraiter',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible:
                                      countListPNCSuivre == 0 ? false : true,
                                  child: GestureDetector(
                                    onTap: () {
                                      countListPNCSuivre == 0
                                          ? null
                                          : Get.to(PNCSuivrePage(),
                                              transition: Transition.zoom,
                                              duration:
                                                  Duration(milliseconds: 500));
                                    },
                                    child: Card(
                                      color: Color(0xFFE9EAEE),
                                      child: ListTile(
                                        leading: const Icon(
                                          Icons.library_books_outlined,
                                          color: Colors.black87,
                                          size: 45,
                                        ),
                                        title: Text('Non Confirmité à Suivre',
                                            style: _contentStyleHeader),
                                        trailing: Badge(
                                          badgeColor: Colors.blue,
                                          badgeContent: Text(
                                            '$countListPNCSuivre',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: countApprobationFinale == 0
                                      ? false
                                      : true,
                                  child: GestureDetector(
                                    onTap: () {
                                      countApprobationFinale == 0
                                          ? null
                                          : Get.to(PNCApprobationFinalePage(),
                                              transition: Transition.zoom,
                                              duration:
                                                  Duration(milliseconds: 500));
                                    },
                                    child: Card(
                                      color: Color(0xFFE9EAEE),
                                      child: ListTile(
                                        leading: const Icon(
                                          Icons.local_library,
                                          color: Colors.black87,
                                          size: 45,
                                        ),
                                        title: Text('Approbation Finale',
                                            style: _contentStyleHeader),
                                        trailing: Badge(
                                          badgeColor: Colors.blue,
                                          badgeContent: Text(
                                            '$countApprobationFinale',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            builder: (_, collapsed, expanded) => Padding(
                              padding:
                                  const EdgeInsets.all(8.0).copyWith(top: 0),
                              child: Expandable(
                                  collapsed: collapsed, expanded: expanded),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //agenda Reunion
                Visibility(
                  visible: SharedPreference.getIsVisibleReunion() == 1
                      ? true
                      : false,
                  child: ExpandableNotifier(
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        color: const Color(0xFFEF9A08),
                        child: ScrollOnExpand(
                          child: ExpandablePanel(
                            controller: expandableReunionController,
                            theme: const ExpandableThemeData(
                                expandIcon: Icons.arrow_downward,
                                collapseIcon: Icons.arrow_upward,
                                tapBodyToCollapse: true,
                                tapBodyToExpand: true,
                                hasIcon: true),
                            header: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  const Icon(Icons.reduce_capacity,
                                      color: Colors.white),
                                  Text(
                                    'Reunion',
                                    style: _headerStyle,
                                  ),
                                  Badge(
                                    badgeColor: Colors.white,
                                    badgeContent: Text(
                                      '${countReunionInfo + countReunionPlanifier}',
                                      style: const TextStyle(
                                          color: Color(0xFFEF9A08)),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            collapsed: const Padding(
                              padding: EdgeInsets.all(0),
                            ),
                            /*collapsed: Text('Module Action',
                        style: TextStyle(fontSize: 18, color: Colors.black), softWrap: true,
                        maxLines: 2, overflow: TextOverflow.ellipsis,), */
                            expanded: Column(
                              children: <Widget>[
                                Visibility(
                                  visible: countReunionInfo == 0 ? false : true,
                                  child: GestureDetector(
                                    onTap: () {
                                      countReunionInfo == 0
                                          ? null
                                          : Get.to(ReunionInformerPage(),
                                              transition: Transition.zoom,
                                              duration:
                                                  Duration(milliseconds: 500));
                                    },
                                    child: Card(
                                      color: Color(0xFFFFFFFF),
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.album_outlined,
                                          color: Colors.black87,
                                          size: 45,
                                        ),
                                        title: Text(
                                          'Reunion pour Info',
                                          style: _contentStyleHeader,
                                        ),
                                        trailing: Badge(
                                          badgeColor: const Color(0xFFEF9A08),
                                          badgeContent: Text(
                                            '$countReunionInfo',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible:
                                      countReunionPlanifier == 0 ? false : true,
                                  child: GestureDetector(
                                    onTap: () {
                                      countReunionPlanifier == 0
                                          ? null
                                          : Get.to(ReunionPlanifierPage(),
                                              transition: Transition.zoom,
                                              duration:
                                                  Duration(milliseconds: 500));
                                    },
                                    child: Card(
                                      color: Color(0xFFE9EAEE),
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.album,
                                          color: Colors.black87,
                                          size: 45,
                                        ),
                                        title: Text('Reunion Planifiée',
                                            style: _contentStyleHeader),
                                        trailing: Badge(
                                          badgeColor: const Color(0xFFEF9A08),
                                          badgeContent: Text(
                                            '$countReunionPlanifier',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            builder: (_, collapsed, expanded) => Padding(
                              padding:
                                  const EdgeInsets.all(8.0).copyWith(top: 0),
                              child: Expandable(
                                  collapsed: collapsed, expanded: expanded),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //agenda Environnement
                Visibility(
                  visible:
                      SharedPreference.getIsVisibleIncidentEnvironnement() == 1
                          ? true
                          : false,
                  child: ExpandableNotifier(
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        color: const Color(0xFF17DB47),
                        child: ScrollOnExpand(
                          child: ExpandablePanel(
                            controller: expandableIncEnvController,
                            theme: const ExpandableThemeData(
                                expandIcon: Icons.arrow_downward,
                                collapseIcon: Icons.arrow_upward,
                                tapBodyToCollapse: true,
                                tapBodyToExpand: true,
                                hasIcon: true),
                            header: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  const Icon(Icons.whatshot,
                                      color: Colors.white),
                                  Text(
                                    'Environnement',
                                    style: _headerStyle,
                                  ),
                                  Badge(
                                    badgeColor: Colors.white,
                                    badgeContent: Text(
                                      '${countDecisionTraitementIncidentEnv + countIncidentEnvATraiter + countIncidentEnvACloturer}',
                                      style: const TextStyle(
                                          color: Color(0xFF17DB47)),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            collapsed: const Padding(
                              padding: EdgeInsets.all(0),
                            ),
                            expanded: Column(
                              children: <Widget>[
                                Visibility(
                                  visible:
                                      countDecisionTraitementIncidentEnv == 0
                                          ? false
                                          : true,
                                  child: GestureDetector(
                                    onTap: () {
                                      countDecisionTraitementIncidentEnv == 0
                                          ? null
                                          : Get.to(
                                              DecisionTraitementIncidentEnvPage(),
                                              transition: Transition.zoom,
                                              duration:
                                                  Duration(milliseconds: 500));
                                    },
                                    child: Card(
                                      color: Color(0xFFFFFFFF),
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.access_time,
                                          color: Colors.black87,
                                          size: 45,
                                        ),
                                        title: Text(
                                          'Decision de Traitement',
                                          style: _contentStyleHeader,
                                        ),
                                        trailing: Badge(
                                          badgeColor: const Color(0xFF17DB47),
                                          badgeContent: Text(
                                            '$countDecisionTraitementIncidentEnv',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: countIncidentEnvATraiter == 0
                                      ? false
                                      : true,
                                  child: GestureDetector(
                                    onTap: () {
                                      countIncidentEnvATraiter == 0
                                          ? null
                                          : Get.to(IncidentEnvATraiterPage(),
                                              transition: Transition.zoom,
                                              duration:
                                                  Duration(milliseconds: 500));
                                    },
                                    child: Card(
                                      color: Color(0xFFE9EAEE),
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.check,
                                          color: Colors.black87,
                                          size: 45,
                                        ),
                                        title: Text('Incident A Traiter',
                                            style: _contentStyleHeader),
                                        trailing: Badge(
                                          badgeColor: const Color(0xFF17DB47),
                                          badgeContent: Text(
                                            '$countIncidentEnvATraiter',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: countIncidentEnvACloturer == 0
                                      ? false
                                      : true,
                                  child: GestureDetector(
                                    onTap: () {
                                      countIncidentEnvACloturer == 0
                                          ? null
                                          : Get.to(IncidentEnvACloturerPage(),
                                              transition: Transition.zoom,
                                              duration:
                                                  Duration(milliseconds: 500));
                                    },
                                    child: Card(
                                      color: Color(0xFFE9EAEE),
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.close,
                                          color: Colors.black87,
                                          size: 45,
                                        ),
                                        title: Text('Incident a Cloturer',
                                            style: _contentStyleHeader),
                                        trailing: Badge(
                                          badgeColor: const Color(0xFF17DB47),
                                          badgeContent: Text(
                                            '$countIncidentEnvACloturer',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            builder: (_, collapsed, expanded) => Padding(
                              padding:
                                  const EdgeInsets.all(8.0).copyWith(top: 0),
                              child: Expandable(
                                  collapsed: collapsed, expanded: expanded),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //agenda Security
                Visibility(
                  visible: SharedPreference.getIsVisibleIncidentSecurite() == 1
                      ? true
                      : false,
                  child: ExpandableNotifier(
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        color: const Color(0xFFE20B24),
                        child: ScrollOnExpand(
                          child: ExpandablePanel(
                            controller: expandableIncSecController,
                            theme: const ExpandableThemeData(
                                expandIcon: Icons.arrow_downward,
                                collapseIcon: Icons.arrow_upward,
                                tapBodyToCollapse: true,
                                tapBodyToExpand: true,
                                hasIcon: true),
                            header: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  const Icon(Icons.security,
                                      color: Colors.white),
                                  Text(
                                    'Securite',
                                    style: _headerStyle,
                                  ),
                                  Badge(
                                    badgeColor: Colors.white,
                                    badgeContent: Text(
                                      '${countDecisionTraitementIncidentSecurite + countIncidentSecuriteATraiter + countIncidentSecuriteACloturer}',
                                      style: const TextStyle(
                                          color: Color(0xFFE20B24)),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            collapsed: const Padding(
                              padding: EdgeInsets.all(0),
                            ),
                            expanded: Column(
                              children: <Widget>[
                                Visibility(
                                  visible:
                                      countDecisionTraitementIncidentSecurite ==
                                              0
                                          ? false
                                          : true,
                                  child: GestureDetector(
                                    onTap: () {
                                      countDecisionTraitementIncidentSecurite ==
                                              0
                                          ? null
                                          : Get.to(
                                              DecisionTraitementIncidentSecuritePage(),
                                              transition: Transition.zoom,
                                              duration:
                                                  Duration(milliseconds: 500));
                                    },
                                    child: Card(
                                      color: Color(0xFFFFFFFF),
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.access_time,
                                          color: Colors.black87,
                                          size: 45,
                                        ),
                                        title: Text(
                                          'Decision de Traitement',
                                          style: _contentStyleHeader,
                                        ),
                                        trailing: Badge(
                                          badgeColor: const Color(0xFFE20B24),
                                          badgeContent: Text(
                                            '$countDecisionTraitementIncidentSecurite',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: countIncidentSecuriteATraiter == 0
                                      ? false
                                      : true,
                                  child: GestureDetector(
                                    onTap: () {
                                      countIncidentSecuriteATraiter == 0
                                          ? null
                                          : Get.to(
                                              IncidentSecuriteATraiterPage(),
                                              transition: Transition.zoom,
                                              duration:
                                                  Duration(milliseconds: 500));
                                    },
                                    child: Card(
                                      color: Color(0xFFE9EAEE),
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.check,
                                          color: Colors.black87,
                                          size: 45,
                                        ),
                                        title: Text('Incident A Traiter',
                                            style: _contentStyleHeader),
                                        trailing: Badge(
                                          badgeColor: const Color(0xFFE20B24),
                                          badgeContent: Text(
                                            '$countIncidentSecuriteATraiter',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: countIncidentSecuriteACloturer == 0
                                      ? false
                                      : true,
                                  child: GestureDetector(
                                    onTap: () {
                                      countIncidentSecuriteACloturer == 0
                                          ? null
                                          : Get.to(
                                              IncidentSecuriteACloturerPage(),
                                              transition: Transition.zoom,
                                              duration:
                                                  Duration(milliseconds: 500));
                                    },
                                    child: Card(
                                      color: Color(0xFFE9EAEE),
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.close,
                                          color: Colors.black87,
                                          size: 45,
                                        ),
                                        title: Text('Incident a Cloturer',
                                            style: _contentStyleHeader),
                                        trailing: Badge(
                                          badgeColor: const Color(0xFFE20B24),
                                          badgeContent: Text(
                                            '$countIncidentSecuriteACloturer',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            builder: (_, collapsed, expanded) => Padding(
                              padding:
                                  const EdgeInsets.all(8.0).copyWith(top: 0),
                              child: Expandable(
                                  collapsed: collapsed, expanded: expanded),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //agenda Audit
                Visibility(
                  visible:
                      SharedPreference.getIsVisibleAudit() == 1 ? true : false,
                  child: ExpandableNotifier(
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        color: const Color(0xFFC20BE2),
                        child: ScrollOnExpand(
                          child: ExpandablePanel(
                            controller: expandableAuditController,
                            theme: const ExpandableThemeData(
                                expandIcon: Icons.arrow_downward,
                                collapseIcon: Icons.arrow_upward,
                                tapBodyToCollapse: true,
                                tapBodyToExpand: true,
                                hasIcon: true),
                            header: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  const Icon(Icons.check_circle_rounded,
                                      color: Colors.white),
                                  Text(
                                    'Audit',
                                    style: _headerStyle,
                                  ),
                                  Badge(
                                    badgeColor: Colors.white,
                                    badgeContent: Text(
                                      '${countAuditEnTantQueAudite + countAuditEnTantQueAuditeur + countRapportAuditAValider}',
                                      style: const TextStyle(
                                          color: Color(0xFFC20BE2)),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            collapsed: const Padding(
                              padding: EdgeInsets.all(0),
                            ),
                            expanded: Column(
                              children: <Widget>[
                                Visibility(
                                  visible: countAuditEnTantQueAudite == 0
                                      ? false
                                      : true,
                                  child: GestureDetector(
                                    onTap: () {
                                      countAuditEnTantQueAudite == 0
                                          ? null
                                          : Get.to(AuditsAuditePage(),
                                              transition: Transition.zoom,
                                              duration:
                                                  Duration(milliseconds: 500));
                                    },
                                    child: Card(
                                      color: Color(0xFFFFFFFF),
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.person_search_rounded,
                                          color: Colors.black87,
                                          size: 45,
                                        ),
                                        title: Text(
                                          'Audits en tant que audité',
                                          style: _contentStyleHeader,
                                        ),
                                        trailing: Badge(
                                          badgeColor: const Color(0xFFC20BE2),
                                          badgeContent: Text(
                                            '$countAuditEnTantQueAudite',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: countAuditEnTantQueAuditeur == 0
                                      ? false
                                      : true,
                                  child: GestureDetector(
                                    onTap: () {
                                      countAuditEnTantQueAuditeur == 0
                                          ? null
                                          : Get.to(AuditsAuditeurPage(),
                                              transition: Transition.zoom,
                                              duration:
                                                  Duration(milliseconds: 500));
                                    },
                                    child: Card(
                                      color: Color(0xFFE9EAEE),
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.how_to_reg,
                                          color: Colors.black87,
                                          size: 45,
                                        ),
                                        title: Text(
                                            'Audits en tant que auditeur',
                                            style: _contentStyleHeader),
                                        trailing: Badge(
                                          badgeColor: const Color(0xFFC20BE2),
                                          badgeContent: Text(
                                            '$countAuditEnTantQueAuditeur',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: countRapportAuditAValider == 0
                                      ? false
                                      : true,
                                  child: GestureDetector(
                                    onTap: () {
                                      countRapportAuditAValider == 0
                                          ? null
                                          : Get.to(RapportAuditAValiderPage(),
                                              transition: Transition.zoom,
                                              duration:
                                                  Duration(milliseconds: 500));
                                    },
                                    child: Card(
                                      color: Color(0xFFE9EAEE),
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.edit,
                                          color: Colors.black87,
                                          size: 45,
                                        ),
                                        title: Text('Rapport audits à valider',
                                            style: _contentStyleHeader),
                                        trailing: Badge(
                                          badgeColor: const Color(0xFFC20BE2),
                                          badgeContent: Text(
                                            '$countRapportAuditAValider',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            builder: (_, collapsed, expanded) => Padding(
                              padding:
                                  const EdgeInsets.all(8.0).copyWith(top: 0),
                              child: Expandable(
                                  collapsed: collapsed, expanded: expanded),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

      /* body: isDataProcessing == true
          ? Center(child: LoadingView(),)
     : SingleChildScrollView(
       child: Accordion(
         scrollIntoViewOfItems: ScrollIntoViewOfItems.fast,
         disableScrolling: true,
         maxOpenSections: 2,
         headerBackgroundColorOpened: Colors.black54,
         openAndCloseAnimation: true,
         headerPadding:
         const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
         sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
         sectionClosingHapticFeedback: SectionHapticFeedback.light,
         children: <AccordionSection>[
           AccordionSection(
             isOpen: false,
             leftIcon: const Icon(Icons.insights_rounded, color: Colors.white),
             headerBackgroundColor: Color(0xFF95E03F),
             headerBackgroundColorOpened: Color(0xFF09A02E),
             header: Text('Action', style: _headerStyle),
             content: SizedBox(
                 height: 110,

                 child: GridView.count(
                   primary: false,
                   padding: const EdgeInsets.all(1),
                   crossAxisSpacing: 10,
                   mainAxisSpacing: 10,
                   crossAxisCount: 3,
                   children: <Widget>[
                     Visibility(
                       visible: true,
                       child: GestureDetector(
                         onTap: (){
                           countListActionRealisation == 0
                               ? null
                               : Get.to(ActionRealisationPage(), transition: Transition.zoom, duration: Duration(milliseconds: 500));
                         },
                         child: Container(
                           padding: const EdgeInsets.all(4),
                           //color: Color(0xFF95E03F),
                           child: GridTile(
                             header: Text('${countListActionRealisation}', textAlign: TextAlign.end,
                                 style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold)),
                             child: Icon(Icons.access_time, color: Colors.white, size: 45,),
                             footer: Text(
                               'Action à realiser', textAlign: TextAlign.center,
                               style: TextStyle(fontSize: 13, color: Colors.white),),
                           ),
                           decoration: BoxDecoration(
                             color: const Color(0xFF95E03F),
                             border: Border.all(
                               color: Color(0xFF70A830),
                               width: 1,
                             ),
                             borderRadius: BorderRadius.circular(8),
                           ),
                         ),
                       ),
                     ),
                     Visibility(
                       visible:true, // countListActionSuivi == 0 ? false : true,
                       child: GestureDetector(
                         onTap: (){
                           countListActionSuivi == 0
                               ? null
                               : Get.to(ActionSuiviPage(), transition: Transition.zoom, duration: Duration(milliseconds: 500));
                         },
                         child: Container(
                           padding: const EdgeInsets.all(4),
                           //color: Color(0xFF95E03F),
                           child: GridTile(
                             header: Text('${countListActionSuivi}', textAlign: TextAlign.end,
                                 style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold)),
                             child: Icon(Icons.book_rounded, color: Colors.white, size: 45,),
                             footer: Text(
                               'Action à suivre', textAlign: TextAlign.center,
                               style: TextStyle(fontSize: 13, color: Colors.white),),
                           ),
                           decoration: BoxDecoration(
                             color: const Color(0xFF29BD32),
                             border: Border.all(
                               color: Color(0xFF24A82C),
                               width: 1,
                             ),
                             borderRadius: BorderRadius.circular(8),
                           ),
                         ),
                       ),
                     ),
                     Visibility(
                       visible: countListActionSuitAudit == 0 ? false : true,
                       child: GestureDetector(
                         onTap: (){
                           countListActionSuitAudit == 0
                               ? null
                               : Get.to(ActionSuiteAuditPage(), transition: Transition.zoom, duration: Duration(milliseconds: 500));
                         },
                         child: Container(
                           padding: const EdgeInsets.all(4),
                           //color: Color(0xFF95E03F),
                           child: GridTile(
                             header: Text('${countListActionSuitAudit}', textAlign: TextAlign.end,
                                 style: TextStyle(fontSize: 13, color: Colors.white
                                     , fontWeight: FontWeight.bold)),
                             child: Icon(Icons.bookmark_border, color: Colors.white, size: 45,),
                             footer: Text(
                               'Action suite à audit', textAlign: TextAlign.center,
                               style: TextStyle(fontSize: 13, color: Colors.white),),
                           ),
                           decoration: BoxDecoration(
                             color: const Color(0xFF09A02E),
                             border: Border.all(
                               color: Color(0xFF09892A),
                               width: 1,
                             ),
                             borderRadius: BorderRadius.circular(8),
                           ),
                         ),
                       ),
                     ),
                   ],
                 )
             ),
             contentHorizontalPadding: 5,
             contentBorderWidth: 1,
           ),
           AccordionSection(
             isOpen: false,
             leftIcon: const Icon(Icons.compare_rounded, color: Colors.white),
             header: Text('PNC', style: _headerStyle),
             contentBorderColor: const Color(0xffffffff),
             headerBackgroundColorOpened: Color(0xFF12B9E5),
             content: SizedBox(
               height: 330,
               child: GridView.count(
                 primary: false,
                 padding: const EdgeInsets.all(5),
                 crossAxisSpacing: 5,
                 mainAxisSpacing: 5,
                 crossAxisCount: 3,
                 children: <Widget>[
                   Visibility(
                     visible: true,
                     child: GestureDetector(
                       onTap: (){
                         countListPNCValider == 0
                             ? null
                             : Get.to(PNCValiderPage(), transition: Transition.zoom, duration: Duration(milliseconds: 500));
                       },
                       child: Container(
                         padding: const EdgeInsets.all(4),
                         //color: Color(0xFF95E03F),
                         child: GridTile(
                           header: Text('${countListPNCValider}', textAlign: TextAlign.end,
                               style: TextStyle(fontSize: 13, color: Colors.white
                                   , fontWeight: FontWeight.bold)),
                           child: Icon(Icons.library_add_check, color: Colors.white, size: 45,),
                           footer: Text(
                             'Non Confirmité à Valider', textAlign: TextAlign.center,
                             style: TextStyle(fontSize: 13, color: Colors.white),),
                         ),
                         decoration: BoxDecoration(
                           color: const Color(0xFF12B9E5),
                           border: Border.all(
                             color: Color(0xFF0C6C84),
                             width: 1,
                           ),
                           borderRadius: BorderRadius.circular(8),
                         ),
                       ),
                     ),
                   ),
                   Visibility(
                     visible: true,
                     child: GestureDetector(
                       onTap: (){
                         countListPNCCorriger == 0
                             ? null
                             : Get.to(PNCCorrigerPage(), transition: Transition.zoom, duration: Duration(milliseconds: 500));
                       },
                       child: Container(
                         padding: const EdgeInsets.all(4),
                         //color: Color(0xFF95E03F),
                         child: GridTile(
                           header: Text('${countListPNCCorriger}', textAlign: TextAlign.end,
                               style: TextStyle(fontSize: 13, color: Colors.white
                                   , fontWeight: FontWeight.bold)),
                           child: Icon(Icons.library_add_check_outlined, color: Colors.white, size: 45,),
                           footer: Text(
                             'Non Confirmité à Corriger', textAlign: TextAlign.center,
                             style: TextStyle(fontSize: 13, color: Colors.white),),
                         ),
                         decoration: BoxDecoration(
                           color: const Color(0xFF1473C6),
                           border: Border.all(
                             color: Color(0xFF123F89),
                             width: 1,
                           ),
                           borderRadius: BorderRadius.circular(8),
                         ),
                       ),
                     ),
                   ),
                   Visibility(
                     visible: true,
                     child: GestureDetector(
                       onTap: (){
                         countlistPNCInvestigationEffectuer == 0
                             ?null
                             :Get.to(PNCInvestigationEffectuerPage(), transition: Transition.zoom, duration: Duration(milliseconds: 500));
                       },
                       child: Container(
                         padding: const EdgeInsets.all(4),
                         //color: Color(0xFF95E03F),
                         child: GridTile(
                           header: Text('${countlistPNCInvestigationEffectuer}', textAlign: TextAlign.end,
                               style: TextStyle(fontSize: 13, color: Colors.white
                                   , fontWeight: FontWeight.bold)),
                           child: Icon(Icons.my_library_add_outlined, color: Colors.white, size: 45,),
                           footer: Text(
                             'Investigation à effectuer', textAlign: TextAlign.center,
                             style: TextStyle(fontSize: 13, color: Colors.white),),
                         ),
                         decoration: BoxDecoration(
                           color: const Color(0xFF1F87F5),
                           border: Border.all(
                             color: Color(0xFF074182),
                             width: 1,
                           ),
                           borderRadius: BorderRadius.circular(8),
                         ),
                       ),
                     ),
                   ),
                   Visibility(
                     visible: true,
                     child: GestureDetector(
                       onTap: (){
                         countListPNCDecision == 0
                             ? null
                             : Get.to(PNCTraitementDecisionPage(), transition: Transition.zoom, duration: Duration(milliseconds: 500));
                       },
                       child: Container(
                         padding: const EdgeInsets.all(4),
                         //color: Color(0xFF95E03F),
                         child: GridTile(
                           header: Text('${countListPNCDecision}', textAlign: TextAlign.end,
                               style: TextStyle(fontSize: 13, color: Colors.white
                                   , fontWeight: FontWeight.bold)),
                           child: Icon(Icons.library_music_rounded, color: Colors.white, size: 45,),
                           footer: Text(
                             'Decision de Traitement', textAlign: TextAlign.center,
                             style: TextStyle(fontSize: 13, color: Colors.white),),
                         ),
                         decoration: BoxDecoration(
                           color: const Color(0xFF4215DB),
                           border: Border.all(
                             color: Color(0xFF260B82),
                             width: 1,
                           ),
                           borderRadius: BorderRadius.circular(8),
                         ),
                       ),
                     ),
                   ),
                   Visibility(
                     visible: true,
                     child: GestureDetector(
                       onTap: (){
                         countlistPNCInvestigationApprouver == 0
                             ?null
                             :Get.to(PNCInvestigationApprouverPage(), transition: Transition.zoom, duration: Duration(milliseconds: 500));
                       },
                       child: Container(
                         padding: const EdgeInsets.all(4),
                         //color: Color(0xFF95E03F),
                         child: GridTile(
                           header: Text('${countlistPNCInvestigationApprouver}', textAlign: TextAlign.end,
                               style: TextStyle(fontSize: 13, color: Colors.white
                                   , fontWeight: FontWeight.bold)),
                           child: Icon(Icons.library_add, color: Colors.white, size: 45,),
                           footer: Text(
                             'Investigation à approuver', textAlign: TextAlign.center,
                             style: TextStyle(fontSize: 13, color: Colors.white),),
                         ),
                         decoration: BoxDecoration(
                           color: Colors.blue,
                           border: Border.all(
                             color: Color(0xFF480D82),
                             width: 1,
                           ),
                           borderRadius: BorderRadius.circular(8),
                         ),
                       ),
                     ),
                   ),
                   Visibility(
                     visible: true,
                     child: GestureDetector(
                       onTap: (){
                         countValidationTraitement == 0
                             ?null
                             :Get.to(PNCValiderDecisionTraitementPage(), transition: Transition.zoom, duration: Duration(milliseconds: 500));
                       },
                       child: Container(
                         padding: const EdgeInsets.all(4),
                         //color: Color(0xFF95E03F),
                         child: GridTile(
                           header: Text('${countValidationTraitement}', textAlign: TextAlign.end,
                               style: TextStyle(fontSize: 13, color: Colors.white
                                   , fontWeight: FontWeight.bold)),
                           child: Icon(Icons.library_music_outlined, color: Colors.white, size: 45,),
                           footer: Text(
                             'Traitement à Valider', textAlign: TextAlign.center,
                             style: TextStyle(fontSize: 13, color: Colors.white),),
                         ),
                         decoration: BoxDecoration(
                           color: Color(0xFF3C2286),
                           border: Border.all(
                             color: Color(0xFF480D82),
                             width: 1,
                           ),
                           borderRadius: BorderRadius.circular(8),
                         ),
                       ),
                     ),
                   ),
                   Visibility(
                     visible: true,
                     child: GestureDetector(
                       onTap: (){
                         Get.to(PNCTraiterPage(), transition: Transition.zoom, duration: Duration(milliseconds: 500));
                       },
                       child: Container(
                         padding: const EdgeInsets.all(4),
                         //color: Color(0xFF95E03F),
                         child: GridTile(
                           header: Text('${countListPNCTraiter}', textAlign: TextAlign.end,
                               style: TextStyle(fontSize: 13, color: Colors.white
                                   , fontWeight: FontWeight.bold)),
                           child: Icon(Icons.library_books, color: Colors.white, size: 45,),
                           footer: Text(
                             'Non Confirmité à Traiter', textAlign: TextAlign.center,
                             style: TextStyle(fontSize: 13, color: Colors.white),),
                         ),
                         decoration: BoxDecoration(
                           color: const Color(0xFF11D0B9),
                           border: Border.all(
                             color: Color(0xFF0C8273),
                             width: 1,
                           ),
                           borderRadius: BorderRadius.circular(8),
                         ),
                       ),
                     ),
                   ),
                   Visibility(
                     visible: true,
                     child: GestureDetector(
                       onTap: (){
                         Get.to(PNCSuivrePage(), transition: Transition.zoom, duration: Duration(milliseconds: 500));
                       },
                       child: Container(
                         padding: const EdgeInsets.all(4),
                         //color: Color(0xFF95E03F),
                         child: GridTile(
                           header: Text('${countListPNCSuivre}', textAlign: TextAlign.end,
                               style: TextStyle(fontSize: 13, color: Colors.white
                                   , fontWeight: FontWeight.bold)),
                           child: Icon(Icons.library_books_outlined, color: Colors.white, size: 45,),
                           footer: Text(
                             'Non Confirmité à Suivre', textAlign: TextAlign.center,
                             style: TextStyle(fontSize: 13, color: Colors.white),),
                         ),
                         decoration: BoxDecoration(
                           color: const Color(0xFF0791CE),
                           border: Border.all(
                             color: Color(0xFF0B6186),
                             width: 1,
                           ),
                           borderRadius: BorderRadius.circular(8),
                         ),
                       ),
                     ),
                   ),
                   Visibility(
                     visible: true,
                     child: GestureDetector(
                       onTap: (){
                         Get.to(PNCApprobationFinalePage(), transition: Transition.zoom, duration: Duration(milliseconds: 500));
                       },
                       child: Container(
                         padding: const EdgeInsets.all(4),
                         //color: Color(0xFF95E03F),
                         child: GridTile(
                           header: Text('${countApprobationFinale}', textAlign: TextAlign.end,
                               style: TextStyle(fontSize: 13, color: Colors.white
                                   , fontWeight: FontWeight.bold)),
                           child: Icon(Icons.local_library, color: Colors.white, size: 45,),
                           footer: Text(
                             'Approbation Finale', textAlign: TextAlign.center,
                             style: TextStyle(fontSize: 13, color: Colors.white),),
                         ),
                         decoration: BoxDecoration(
                           color: const Color(0xFF098989),
                           border: Border.all(
                             color: Color(0xFF098080),
                             width: 1,
                           ),
                           borderRadius: BorderRadius.circular(8),
                         ),
                       ),
                     ),
                   ),
                 ],
               ),
             ),
           ),
           SharedPreference.getIsVisibleReunion() == 1 ? AccordionSection(
             isOpen: false,
             leftIcon: const Icon(Icons.reduce_capacity, color: Colors.white),
             headerBackgroundColor: Color(0xFFEF9A08),
             headerBackgroundColorOpened: Color(0xFFBB260B),
             header: Text('Reunion', style: _headerStyle),
             contentBorderColor: const Color(0xffffffff),
             content: SizedBox(
                 height: 170,
                 child: GridView.count(
                   primary: false,
                   padding: const EdgeInsets.all(1),
                   crossAxisSpacing: 10,
                   mainAxisSpacing: 10,
                   crossAxisCount: 2,
                   children: <Widget>[
                     SizedBox(
                       height: 50.0,
                       child: Visibility(
                         visible: true,
                         child: GestureDetector(
                           onTap: (){
                             countReunionInfo == 0
                                 ?null
                                 :Get.to(ReunionInformerPage(), transition: Transition.zoom, duration: Duration(milliseconds: 500));
                           },
                           child: Container(
                             padding: const EdgeInsets.all(4),
                             //color: Color(0xFF95E03F),
                             child: GridTile(
                               header: Text('${countReunionInfo}', textAlign: TextAlign.end,
                                   style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                               child: Icon(Icons.album_outlined, color: Colors.white, size: 100,),
                               footer: Text(
                                 'Reunion pour Info', textAlign: TextAlign.center,
                                 style: TextStyle(fontSize: 16, color: Colors.white),),
                             ),
                             decoration: BoxDecoration(
                               color: const Color(0xFFF1B82A),
                               border: Border.all(
                                 color: Color(0xFF9FA811),
                                 width: 1,
                               ),
                               borderRadius: BorderRadius.circular(8),
                             ),
                           ),
                         ),
                       ),
                     ),
                     Visibility(
                       visible: true,
                       child: GestureDetector(
                         onTap: (){
                           countReunionPlanifier == 0
                               ?null
                               :Get.to(ReunionPlanifierPage(), transition: Transition.zoom, duration: Duration(milliseconds: 500));
                         },
                         child: Container(
                           padding: const EdgeInsets.all(4),
                           //color: Color(0xFF95E03F),
                           child: GridTile(
                             header: Text('${countReunionPlanifier}', textAlign: TextAlign.end,
                                 style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                             child: Icon(Icons.album, color: Colors.white, size: 100,),
                             footer: Text(
                               'Reunion Planifiée', textAlign: TextAlign.center,
                               style: TextStyle(fontSize: 16, color: Colors.white),),
                           ),
                           decoration: BoxDecoration(
                             color: const Color(0xFFAFAD09),
                             border: Border.all(
                               color: Color(0xFFA19F12),
                               width: 1,
                             ),
                             borderRadius: BorderRadius.circular(8),
                           ),
                         ),
                       ),
                     ),
                   ],
                 )
             ),
             contentHorizontalPadding: 5,
             contentBorderWidth: 1,
             // onOpenSection: () => print('onOpenSection ...'),
             // onCloseSection: () => print('onCloseSection ...'),
           )
               : AccordionSection( contentBorderWidth: 0,header: Text(''), content: Text(''),
             contentBackgroundColor: Colors.white, contentBorderColor: Colors.white, contentHorizontalPadding: 0.0,
             contentVerticalPadding: 0.0, headerBackgroundColor: Colors.white, headerBackgroundColorOpened: Colors.white,
             headerPadding: EdgeInsets.all(0), contentBorderRadius: 0.0,),
           AccordionSection(
             isOpen: false,
             leftIcon: const Icon(Icons.whatshot, color: Colors.white),
             headerBackgroundColor: Color(0xFF0BE2B7),
             headerBackgroundColorOpened: Color(0xFFA00964),
             header: Text('Environnement', style: _headerStyle),
             content: SizedBox(
                 height: 110,
                 child: GridView.count(
                   primary: false,
                   padding: const EdgeInsets.all(1),
                   crossAxisSpacing: 10,
                   mainAxisSpacing: 10,
                   crossAxisCount: 3,
                   children: <Widget>[
                     Visibility(
                       visible: true,
                       child: GestureDetector(
                         onTap: (){
                           countDecisionTraitementIncidentEnv == 0
                               ? null
                               : Get.to(DecisionTraitementIncidentEnvPage(), transition: Transition.zoom, duration: Duration(milliseconds: 500));
                         },
                         child: Container(
                           padding: const EdgeInsets.all(4),
                           //color: Color(0xFF95E03F),
                           child: GridTile(
                             header: Text('${countDecisionTraitementIncidentEnv}', textAlign: TextAlign.end,
                                 style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold)),

                             child: Icon(Icons.access_time, color: Colors.white, size: 45,),
                             footer: Text(
                               'Decision de Traitement', textAlign: TextAlign.center,
                               style: TextStyle(fontSize: 13, color: Colors.white),),
                           ),
                           decoration: BoxDecoration(
                             color: const Color(0xFF903FE0),
                             border: Border.all(
                               color: Color(0xFF4F2984),
                               width: 1,
                             ),
                             borderRadius: BorderRadius.circular(8),
                           ),
                         ),
                       ),
                     ),
                     Visibility(
                       visible: true,
                       child: GestureDetector(
                         onTap: (){
                           countIncidentEnvATraiter == 0
                               ? null
                               : Get.to(IncidentEnvATraiterPage(), transition: Transition.zoom, duration: Duration(milliseconds: 500));
                         },
                         child: Container(
                           padding: const EdgeInsets.all(4),
                           //color: Color(0xFF95E03F),
                           child: GridTile(
                             header: Text('${countIncidentEnvATraiter}', textAlign: TextAlign.end,
                                 style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold)),

                             child: Icon(Icons.access_time, color: Colors.white, size: 45,),
                             footer: Text(
                               'Incident A Traiter', textAlign: TextAlign.center,
                               style: TextStyle(fontSize: 13, color: Colors.white),),
                           ),
                           decoration: BoxDecoration(
                             color: const Color(0xFFAD2EE3),
                             border: Border.all(
                               color: Color(0xFF45108E),
                               width: 1,
                             ),
                             borderRadius: BorderRadius.circular(8),
                           ),
                         ),
                       ),
                     ),
                     Visibility(
                       visible: true,
                       child: GestureDetector(
                         onTap: (){
                           countIncidentEnvACloturer == 0
                               ? null
                               : Get.to(IncidentEnvACloturerPage(), transition: Transition.zoom, duration: Duration(milliseconds: 500));
                         },
                         child: Container(
                           padding: const EdgeInsets.all(4),
                           //color: Color(0xFF95E03F),
                           child: GridTile(
                             header: Text('${countIncidentEnvACloturer}', textAlign: TextAlign.end,
                                 style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold)),

                             child: Icon(Icons.access_time, color: Colors.white, size: 45,),
                             footer: Text(
                               'Incident a Cloturer', textAlign: TextAlign.center,
                               style: TextStyle(fontSize: 13, color: Colors.white),),
                           ),
                           decoration: BoxDecoration(
                             color: const Color(0xFFD729C0),
                             border: Border.all(
                               color: Color(0xFF721E67),
                               width: 1,
                             ),
                             borderRadius: BorderRadius.circular(8),
                           ),
                         ),
                       ),
                     ),
                   ],
                 )
             ),
             contentHorizontalPadding: 5,
             contentBorderWidth: 1,
             // onOpenSection: () => print('onOpenSection ...'),
             // onCloseSection: () => print('onCloseSection ...'),
           ),
           AccordionSection(
             isOpen: false,
             leftIcon: const Icon(Icons.security, color: Colors.white),
             headerBackgroundColor: Color(0xFFE20B24),
             headerBackgroundColorOpened: Color(0xFFC74720),
             header: Text('Securite', style: _headerStyle),
             content: SizedBox(
                 height: 110,
                 child: GridView.count(
                   primary: false,
                   padding: const EdgeInsets.all(1),
                   crossAxisSpacing: 10,
                   mainAxisSpacing: 10,
                   crossAxisCount: 3,
                   children: <Widget>[
                     Visibility(
                       visible: true,
                       child: GestureDetector(
                         onTap: (){
                           countDecisionTraitementIncidentSecurite == 0
                               ? null
                               : Get.to(DecisionTraitementIncidentSecuritePage(), transition: Transition.zoom, duration: Duration(milliseconds: 500));
                         },
                         child: Container(
                           padding: const EdgeInsets.all(4),
                           //color: Color(0xFF95E03F),
                           child: GridTile(
                             header: Text('${countDecisionTraitementIncidentSecurite}', textAlign: TextAlign.end,
                                 style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold)),

                             child: Icon(Icons.access_time, color: Colors.white, size: 45,),
                             footer: Text(
                               'Decision de Traitement', textAlign: TextAlign.center,
                               style: TextStyle(fontSize: 13, color: Colors.white),),
                           ),
                           decoration: BoxDecoration(
                             color: const Color(0xFFE2442F),
                             border: Border.all(
                               color: Color(0xFFE20505),
                               width: 1,
                             ),
                             borderRadius: BorderRadius.circular(8),
                           ),
                         ),
                       ),
                     ),
                     Visibility(
                       visible: true,
                       child: GestureDetector(
                         onTap: (){
                           countIncidentSecuriteATraiter == 0
                               ? null
                               : Get.to(IncidentSecuriteATraiterPage(), transition: Transition.zoom, duration: Duration(milliseconds: 500));
                         },
                         child: Container(
                           padding: const EdgeInsets.all(4),
                           //color: Color(0xFF95E03F),
                           child: GridTile(
                             header: Text('${countIncidentSecuriteATraiter}', textAlign: TextAlign.end,
                                 style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold)),

                             child: Icon(Icons.access_time, color: Colors.white, size: 45,),
                             footer: Text(
                               'Incident A Traiter', textAlign: TextAlign.center,
                               style: TextStyle(fontSize: 13, color: Colors.white),),
                           ),
                           decoration: BoxDecoration(
                             color: const Color(0xFFA11154),
                             border: Border.all(
                               color: Color(0xFF651239),
                               width: 1,
                             ),
                             borderRadius: BorderRadius.circular(8),
                           ),
                         ),
                       ),
                     ),
                     Visibility(
                       visible: true,
                       child: GestureDetector(
                         onTap: (){
                           countIncidentSecuriteACloturer == 0
                               ? null
                               : Get.to(IncidentSecuriteACloturerPage(), transition: Transition.zoom, duration: Duration(milliseconds: 500));
                         },
                         child: Container(
                           padding: const EdgeInsets.all(4),
                           //color: Color(0xFF95E03F),
                           child: GridTile(
                             header: Text('${countIncidentSecuriteACloturer}', textAlign: TextAlign.end,
                                 style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold)),

                             child: Icon(Icons.access_time, color: Colors.white, size: 45,),
                             footer: Text(
                               'Incident a Cloturer', textAlign: TextAlign.center,
                               style: TextStyle(fontSize: 13, color: Colors.white),),
                           ),
                           decoration: BoxDecoration(
                             color: const Color(0xFFCE0930),
                             border: Border.all(
                               color: Color(0xFF5A0508),
                               width: 1,
                             ),
                             borderRadius: BorderRadius.circular(8),
                           ),
                         ),
                       ),
                     ),
                   ],
                 )
             ),
             contentHorizontalPadding: 5,
             contentBorderWidth: 1,
             // onOpenSection: () => print('onOpenSection ...'),
             // onCloseSection: () => print('onCloseSection ...'),
           ),
           AccordionSection(
             isOpen: false,
             leftIcon: const Icon(Icons.security, color: Colors.white),
             headerBackgroundColor: Color(0xFFC20BE2),
             headerBackgroundColorOpened: Color(0xFF20A6C7),
             header: Text('Audit', style: _headerStyle),
             content: SizedBox(
                 height: 110,
                 child: GridView.count(
                   primary: false,
                   padding: const EdgeInsets.all(1),
                   crossAxisSpacing: 10,
                   mainAxisSpacing: 10,
                   crossAxisCount: 3,
                   children: <Widget>[
                     Visibility(
                       visible: true,
                       child: GestureDetector(
                         onTap: (){
                           countAuditEnTantQueAudite == 0
                               ? null
                               : Get.to(AuditsAuditePage(), transition: Transition.zoom, duration: Duration(milliseconds: 500));
                         },
                         child: Container(
                           padding: const EdgeInsets.all(4),
                           //color: Color(0xFF95E03F),
                           child: GridTile(
                             header: Text('${countAuditEnTantQueAudite}', textAlign: TextAlign.end,
                                 style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold)),

                             child: Icon(Icons.access_time, color: Colors.white, size: 45,),
                             footer: Text(
                               'Audits en tant que audité', textAlign: TextAlign.center,
                               style: TextStyle(fontSize: 13, color: Colors.white),),
                           ),
                           decoration: BoxDecoration(
                             color: const Color(0xFFDB1170),
                             border: Border.all(
                               color: Color(0xFFDB1170),
                               width: 1,
                             ),
                             borderRadius: BorderRadius.circular(8),
                           ),
                         ),
                       ),
                     ),
                     Visibility(
                       visible: true,
                       child: GestureDetector(
                         onTap: (){
                           countAuditEnTantQueAuditeur == 0
                               ? null
                               : Get.to(AuditsAuditeurPage(), transition: Transition.zoom, duration: Duration(milliseconds: 500));
                         },
                         child: Container(
                           padding: const EdgeInsets.all(4),
                           //color: Color(0xFF95E03F),
                           child: GridTile(
                             header: Text('${countAuditEnTantQueAuditeur}', textAlign: TextAlign.end,
                                 style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold)),

                             child: Icon(Icons.access_time, color: Colors.white, size: 45,),
                             footer: Text(
                               'Audits en tant que auditeur', textAlign: TextAlign.center,
                               style: TextStyle(fontSize: 13, color: Colors.white),),
                           ),
                           decoration: BoxDecoration(
                             color: const Color(0xFFCB1488),
                             border: Border.all(
                               color: Color(0xFFCB1488),
                               width: 1,
                             ),
                             borderRadius: BorderRadius.circular(8),
                           ),
                         ),
                       ),
                     ),
                     Visibility(
                       visible: true,
                       child: GestureDetector(
                         onTap: (){
                           countRapportAuditAValider == 0
                               ? null
                               : Get.to(RapportAuditAValiderPage(), transition: Transition.zoom, duration: Duration(milliseconds: 500));
                         },
                         child: Container(
                           padding: const EdgeInsets.all(4),
                           //color: Color(0xFF95E03F),
                           child: GridTile(
                             header: Text('${countRapportAuditAValider}', textAlign: TextAlign.end,
                                 style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold)),

                             child: Icon(Icons.access_time, color: Colors.white, size: 45,),
                             footer: Text(
                               'Rapport audits à valider', textAlign: TextAlign.center,
                               style: TextStyle(fontSize: 13, color: Colors.white),),
                           ),
                           decoration: BoxDecoration(
                             color: const Color(0xFFB6104B),
                             border: Border.all(
                               color: Color(0xFFB6104B),
                               width: 1,
                             ),
                             borderRadius: BorderRadius.circular(8),
                           ),
                         ),
                       ),
                     ),
                   ],
                 )
             ),
             contentHorizontalPadding: 5,
             contentBorderWidth: 1,
             // onOpenSection: () => print('onOpenSection ...'),
             // onCloseSection: () => print('onCloseSection ...'),
           ),
         ],
       ),
     ),
        ListView(
          children: <Widget>[
            ExpandableNotifier(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: ScrollOnExpand(
                    child: ExpandablePanel(
                      controller: expandableController,
                      theme: ExpandableThemeData(
                          expandIcon: Icons.arrow_downward,
                          collapseIcon: Icons.arrow_upward,
                          tapBodyToCollapse: true,
                          tapBodyToExpand: true,
                          hasIcon: true
                      ),
                      header: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(Icons.insights_rounded, color: Colors.blueAccent),
                            Text('Action', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueAccent),)
                          ],
                        ),
                      ),
                      collapsed: Text(''),
                      /*collapsed: Text('Module Action',
                      style: TextStyle(fontSize: 18, color: Colors.black), softWrap: true,
                      maxLines: 2, overflow: TextOverflow.ellipsis,), */
                      expanded: Column(
                        children: <Widget>[
                          Text('view 1', style: TextStyle(fontSize: 18, color: Colors.black)),
                          Text('view 2'),
                          Text('view 3'),
                        ],
                      ),
                      builder: (_, collapsed, expanded) => Padding(
                        padding: const EdgeInsets.all(8.0).copyWith(top: 0),
                        child: Expandable(
                            collapsed: collapsed,
                            expanded: expanded
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
     floatingActionButton:  Obx(()=>Text(
          _networkController.connectionStatus.value==1 ?
              'Wifi connected' :
          (_networkController.connectionStatus.value==2 ?
          'Mobile internet' : 'No connection')
        ))
      Obx((){
        if(_networkController.connectionStatus.value==1) {
           ShowSnackBar.snackBar('Internet Connection', 'Wifi', Colors.green, );
           return Text('Wifi');
        }
        else if(_networkController.connectionStatus.value==2){
          ShowSnackBar.snackBar('Internet Connection', 'Mobile', Colors.blueAccent);
          return Text('');
        }
        else {
          ShowSnackBar.snackBar('No Internet Connection', 'offline mode', Colors.red);
          return Text('No Internet Connection');
        }
      }), */
    );
  }
}

//method use controller
/*
class HomePage extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    final keyRefresh = GlobalKey<RefreshIndicatorState>();
    const Color lightPrimary = Colors.white;
    const Color darkPrimary = Colors.white;
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        /// 2- to call ui of AppBarTitle class ///
        title: AppBarTitle(),
        iconTheme: IconThemeData(color: CustomColors.blueAccent),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              splashColor: CustomColors.blueAccent,
              onTap: (){
                controller.syncApiCallToLocalDB();
              },
              child: Icon(Icons.sync, color: CustomColors.blueMarin,),
            ),
          )
        ],
      ),
      body: Obx((){
        if (controller.isDataProcessing.value == true){
          return Center(
            child: LoadingView(),
          );
        }
        else {
         return Column(
            children: <Widget>[
              Text('Action', textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              Expanded(
                  child: GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(5),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 3,
                    children: <Widget>[
                      Visibility(
                        visible: true,
                        child: GestureDetector(
                          onTap: (){
                            Get.to(ActionRealisationPage(), transition: Transition.zoom, duration: Duration(milliseconds: 500));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            //color: Color(0xFF95E03F),
                            child: GridTile(
                              header: Text('${controller.countListActionRealisation}', textAlign: TextAlign.end,
                                  style: TextStyle(fontSize: 12, color: Colors.white)),
                             /* header: Positioned(
                                top: 1,
                                right: 2,
                                child: Badge(
                                  toAnimate: false,
                                  shape: BadgeShape.circle,
                                  badgeColor: const Color(0xFF1E7206),
                                  borderRadius: BorderRadius.circular(10),
                                  badgeContent: Text('${controller.countListActionRealisation}', style: TextStyle(color: Colors.white)),
                                  //position: BadgePosition.topEnd(top: 30, end: 10),
                                ),
                              ), */
                              child: Icon(Icons.access_time, color: Colors.white, size: 50,),
                              footer: Text(
                                'Action à realiser', textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12, color: Colors.white),),
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF95E03F),
                              border: Border.all(
                                color: Color(0xFF70A830),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: controller.countListActionSuivi.value == 0 ? false : true,
                        child: GestureDetector(
                          onTap: (){
                            Get.to(ActionSuiviPage(), transition: Transition.zoom, duration: Duration(milliseconds: 500));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            //color: Color(0xFF95E03F),
                            child: GridTile(
                              header: Text('${controller.countListActionSuivi.value}', textAlign: TextAlign.end,
                                  style: TextStyle(fontSize: 12, color: Colors.white)),
                              child: Icon(Icons.book_rounded, color: Colors.white, size: 50,),
                              footer: Text(
                                'Action à suivre', textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12, color: Colors.white),),
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF29BD32),
                              border: Border.all(
                                color: Color(0xFF24A82C),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: controller.countListActionSuitAudit == 0 ? false : true,
                        child: GestureDetector(
                          onTap: (){
                            Get.to(ActionSuiteAuditPage(), transition: Transition.zoom, duration: Duration(milliseconds: 500));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            //color: Color(0xFF95E03F),
                            child: GridTile(
                              header: Text('${controller.countListActionSuitAudit}', textAlign: TextAlign.end,
                                  style: TextStyle(fontSize: 12, color: Colors.white)),
                              child: Icon(Icons.bookmark_border, color: Colors.white, size: 50,),
                              footer: Text(
                                'Action suite à audit', textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12, color: Colors.white),),
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF09A02E),
                              border: Border.all(
                                color: Color(0xFF09892A),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
              )
            ],
          );
        }
      }),
    );
  }
} */
