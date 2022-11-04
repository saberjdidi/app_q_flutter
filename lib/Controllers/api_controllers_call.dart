import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualipro_flutter/Models/action/action_suite_audit.dart';
import 'package:qualipro_flutter/Models/action/action_suivi_model.dart';
import 'package:qualipro_flutter/Models/audit/champ_audit_model.dart';
import 'package:qualipro_flutter/Models/audit/constat_audit_model.dart';
import 'package:qualipro_flutter/Models/audit/type_audit_model.dart';
import 'package:qualipro_flutter/Models/audit_action_model.dart';
import 'package:qualipro_flutter/Models/category_model.dart';
import 'package:qualipro_flutter/Models/champ_cache_model.dart';
import 'package:qualipro_flutter/Models/champ_obligatoire_action_model.dart';
import 'package:qualipro_flutter/Models/client_model.dart';
import 'package:qualipro_flutter/Models/direction_model.dart';
import 'package:qualipro_flutter/Models/documentation/type_document_model.dart';
import 'package:qualipro_flutter/Models/employe_model.dart';
import 'package:qualipro_flutter/Models/gravite_model.dart';
import 'package:qualipro_flutter/Models/incident_environnement/action_inc_env.dart';
import 'package:qualipro_flutter/Models/incident_environnement/cout_estime_inc_env_model.dart';
import 'package:qualipro_flutter/Models/incident_securite/incident_securite_agenda_model.dart';
import 'package:qualipro_flutter/Models/lieu_model.dart';
import 'package:qualipro_flutter/Models/pnc/atelier_pnc_model.dart';
import 'package:qualipro_flutter/Models/pnc/source_pnc_model.dart';
import 'package:qualipro_flutter/Models/pnc/type_pnc_model.dart';
import 'package:qualipro_flutter/Models/priorite_model.dart';
import 'package:qualipro_flutter/Models/processus_employe_model.dart';
import 'package:qualipro_flutter/Models/processus_model.dart';
import 'package:qualipro_flutter/Models/product_model.dart';
import 'package:qualipro_flutter/Models/site_model.dart';
import 'package:qualipro_flutter/Models/action/type_action_model.dart';
import 'package:qualipro_flutter/Models/type_cause_model.dart';
import 'package:qualipro_flutter/Models/type_incident_model.dart';
import 'package:qualipro_flutter/Models/visite_securite/equipe_visite_securite_model.dart';
import 'package:qualipro_flutter/Models/visite_securite/taux_checklist_vs.dart';
import 'package:qualipro_flutter/Models/visite_securite/unite_model.dart';
import 'package:qualipro_flutter/Models/visite_securite/zone_model.dart';
import 'package:qualipro_flutter/Services/audit/local_audit_service.dart';
import 'package:qualipro_flutter/Services/document/documentation_service.dart';
import 'package:qualipro_flutter/Services/document/local_documentation_service.dart';
import 'package:qualipro_flutter/Services/incident_environnement/local_incident_environnement_service.dart';
import 'package:qualipro_flutter/Services/incident_securite/incident_securite_service.dart';
import 'package:qualipro_flutter/Services/reunion/local_reunion_service.dart';

import '../Models/Domaine_affectation_model.dart';
import '../Models/action/action_model.dart';
import '../Models/action/action_realisation_model.dart';
import '../Models/activity_model.dart';
import '../Models/audit/audit_model.dart';
import '../Models/audit/auditeur_model.dart';
import '../Models/documentation/documentation_model.dart';
import '../Models/fournisseur_model.dart';
import '../Models/incident_environnement/champ_obligatore_incident_env_model.dart';
import '../Models/incident_environnement/incident_env_agenda_model.dart';
import '../Models/incident_environnement/incident_env_model.dart';
import '../Models/incident_environnement/source_inc_env_model.dart';
import '../Models/incident_environnement/type_cause_incident_model.dart';
import '../Models/incident_environnement/type_consequence_incident_model.dart';
import '../Models/incident_securite/action_inc_sec.dart';
import '../Models/incident_securite/cause_typique_model.dart';
import '../Models/incident_securite/champ_obligatore_incident_securite_model.dart';
import '../Models/incident_securite/evenement_declencheur_model.dart';
import '../Models/incident_securite/incident_securite_model.dart';
import '../Models/incident_securite/poste_travail_model.dart';
import '../Models/incident_securite/site_lesion_model.dart';
import '../Models/pnc/champ_obligatoire_pnc_model.dart';
import '../Models/pnc/gravite_pnc_model.dart';
import '../Models/pnc/pnc_a_corriger_model.dart';
import '../Models/pnc/pnc_a_traiter_model.dart';
import '../Models/pnc/pnc_model.dart';
import '../Models/pnc/pnc_suivre_model.dart';
import '../Models/pnc/pnc_validation_decision_model.dart';
import '../Models/pnc/product_pnc_model.dart';
import '../Models/pnc/traitement_decision_model.dart';
import '../Models/pnc/type_cause_pnc_model.dart';
import '../Models/resp_cloture_model.dart';
import '../Models/reunion/action_reunion.dart';
import '../Models/reunion/participant_reunion_model.dart';
import '../Models/reunion/reunion_model.dart';
import '../Models/reunion/type_reunion_model.dart';
import '../Models/secteur_model.dart';
import '../Models/service_model.dart';
import '../Models/action/source_action_model.dart';
import '../Models/action/sous_action_model.dart';
import '../Models/type_consequence_model.dart';
import '../Models/visite_securite/action_visite_securite.dart';
import '../Models/visite_securite/checklist_critere_model.dart';
import '../Models/visite_securite/checklist_model.dart';
import '../Models/visite_securite/visite_securite_model.dart';
import '../Services/action/action_service.dart';
import '../Services/api_services_call.dart';
import '../Services/action/local_action_service.dart';
import '../Services/audit/audit_service.dart';
import '../Services/incident_environnement/incident_environnement_service.dart';
import '../Services/incident_securite/local_incident_securite_service.dart';
import '../Services/pnc/local_pnc_service.dart';
import '../Services/pnc/pnc_service.dart';
import '../Services/reunion/reunion_service.dart';
import '../Services/visite_securite/local_visite_securite_service.dart';
import '../Services/visite_securite/visite_securite_service.dart';
import '../Utils/shared_preference.dart';
import '../Utils/snack_bar.dart';

class ApiControllersCall extends GetxController {
  var isDataProcessing = false.obs;
  final matricule = SharedPreference.getMatricule();
  LocalActionService localActionService = LocalActionService();
  LocalPNCService localPNCService = LocalPNCService();
  LocalReunionService localReunionService = LocalReunionService();
  LocalDocumentationService localDocumentationService =
      LocalDocumentationService();
  LocalIncidentEnvironnementService localIncidentEnvironnementService =
      LocalIncidentEnvironnementService();
  LocalIncidentSecuriteService localIncidentSecuriteService =
      LocalIncidentSecuriteService();
  LocalVisiteSecuriteService localVisiteSecuriteService =
      LocalVisiteSecuriteService();
  LocalAuditService localAuditService = LocalAuditService();

  var listSourceAction = List<SourceActionModel>.empty(growable: true).obs;
  var listTypeAction = List<TypeActionModel>.empty(growable: true).obs;
  var listTypeCauseAction = List<TypeCauseModel>.empty(growable: true).obs;
  var listRespCloture = List<RespClotureModel>.empty(growable: true).obs;
  var listSite = List<SiteModel>.empty(growable: true).obs;
  var listProcessus = List<ProcessusModel>.empty(growable: true).obs;
  var listProcessusEmploye =
      List<ProcessusEmployeModel>.empty(growable: true).obs;
  var listProduct = List<ProductModel>.empty(growable: true).obs;
  var listDirection = List<DirectionModel>.empty(growable: true).obs;
  var listEmploye = List<EmployeModel>.empty(growable: true).obs;
  var listAuditAction = List<AuditActionModel>.empty(growable: true).obs;
  var listActivity = List<ActivityModel>.empty(growable: true).obs;
  var listService = List<ServiceModel>.empty(growable: true).obs;
  var listDomaine = List<DomaineAffectationModel>.empty(growable: true).obs;
  var listPriorite = List<PrioriteModel>.empty(growable: true).obs;
  var listGravite = List<GraviteModel>.empty(growable: true).obs;
  var listChampObligatoireAction =
      List<ChampObligatoireActionModel>.empty(growable: true).obs;
  var listChampCache = List<ChampCacheModel>.empty(growable: true).obs;
  var listSousAction = List<SousActionModel>.empty(growable: true).obs;
  var listActionReal = List<ActionRealisationModel>.empty(growable: true).obs;
  var listActionSuivi = List<ActionSuiviModel>.empty(growable: true).obs;
  var listActionSuiteAudit = List<ActionSuiteAudit>.empty(growable: true).obs;

  @override
  void onInit() async {
    super.onInit();
    //matricule = SharedPreference.getMatricule();

    /* getDomaineAffectation();
    getChampObligatoireAction();
    getSourceAction();
    getTypeAction();
    getTypeCauseAction();
    getResponsableCloture();
    getSite();
    getProcessus();
    getProduct();
    getDirection();
    getEmploye();
    getAuditAction();
    getActivity();
    getPriorite();
    getGravite(); */
  }

  Future<void> getDomaineAffectation() async {
    try {
      isDataProcessing(true);
      //rest api
      await ApiServicesCall().getDomaineAffectation().then((resp) async {
        resp.forEach((data) async {
          //print('get domaine affectation : ${data} ');
          var model = DomaineAffectationModel();
          model.id = data['id'];
          model.module = data['module'];
          model.fiche = data['fiche'];
          model.vSite = data['v_site'];
          model.oSite = data['o_site'];
          model.rSite = data['r_site'];
          model.vProcessus = data['v_processus'];
          model.oProcessus = data['o_processus'];
          model.rProcessus = data['r_processus'];
          model.vDomaine = data['v_domaine'];
          model.oDomaine = data['o_domaine'];
          model.rDomaine = data['r_domaine'];
          model.vDirection = data['v_direction'];
          model.oDirection = data['o_direction'];
          model.rDirection = data['r_direction'];
          model.vService = data['v_service'];
          model.oService = data['o_service'];
          model.rService = data['r_service'];
          model.vEmpSite = data['vEmpSite'];
          model.vEmpProcessus = data['vEmpProcessus'];
          model.vEmpDomaine = data['vEmpDomaine'];
          model.vEmpDirection = data['vEmpDirection'];
          model.vEmpService = data['vEmpService'];
          listDomaine.add(model);

          //delete table
          await localActionService.deleteTableDomaineAffectation();
          //save data
          await localActionService.saveDomaineAffectation(model);
          print(
              'Inserting data in table DomaineAffectation : ${model.id}, ${model.module} ');
        });
        print('get data');
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error DomaineAffectation", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getChampCache() async {
    try {
      isDataProcessing(true);
      //rest api
      await ApiServicesCall().getChampCache({"module": "", "fiche": ""}).then(
          (resp) async {
        resp.forEach((data) async {
          //print('get champ obligatoire : ${data} ');
          var model = ChampCacheModel();
          model.id = data['id'];
          model.module = data['module'];
          model.fiche = data['fiche'];
          model.listOrder = data['list_order'];
          model.nomParam = data['nom_param'];
          model.visible = data['visible'];
          listChampCache.add(model);

          //delete table
          await localActionService.deleteTableChampCache();
          //save data
          await localActionService.saveChampCache(model);
          print(
              'Inserting data in table ChampCache : ${model.module}-${model.fiche}-${model.nomParam}-visible${model.visible} ');
        });
        print('get data');
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar("Error ChampCache", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getChampObligatoireAction() async {
    try {
      isDataProcessing(true);
      //rest api
      await ApiServicesCall().getChampObligatoireAction().then((resp) async {
        resp.forEach((data) async {
          //print('get champ obligatoire : ${data} ');
          var model = ChampObligatoireActionModel();
          model.commentaire_Realisation_Action =
              data['commentaire_Realisation_Action'];
          model.rapport_Suivi_Action = data['rapport_Suivi_Action'];
          model.delai_Suivi_Action = data['delai_Suivi_Action'];
          model.priorite = data['priorite'];
          model.gravite = data['gravite'];
          model.commentaire = data['commentaire'];
          listChampObligatoireAction.add(model);

          //delete table
          await localActionService.deleteTableChampObligatoireAction();
          //save data
          await localActionService.saveChampObligatoireAction(model);
          print(
              'Inserting data in table ChampObligatoireAction : ${model.commentaire} ');
        });
        print('get data');
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error ChampObligatoireAction", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getChampObligatoirePNC() async {
    try {
      isDataProcessing(true);
      //rest api
      await ApiServicesCall().getChampObligatoirePNC().then((data) async {
        //print('get champ obligatoire : ${data} ');
        var model = ChampObligatoirePNCModel();
        model.numInterne = data['num_interne'];
        model.enregistre = data['enregistre'];
        model.dateLivr = data['date_livr'];
        model.numOf = data['num_of'];
        model.numLot = data['num_lot'];
        model.fournisseur = data['fournisseur'];
        model.qteDetect = data['qte_detect'];
        model.qteProduite = data['qte_produite'];
        model.unite = data['unite'];
        model.gravite = data['gravite'];
        model.source = data['source'];
        model.atelier = data['atelier'];
        model.origine = data['origine'];
        model.nonConf = data['non_conf'];
        model.traitNc = data['trait_nc'];
        model.typeTrait = data['type_trait'];
        model.respTrait = data['resp_trait'];
        model.delaiTrait = data['delai_trait'];
        model.respSuivi = data['resp_suivi'];
        model.datTrait = data['dat_trait'];
        model.coutTrait = data['cout_trait'];
        model.quantite = data['quantite'];
        model.valeur = data['valeur'];
        model.rapTrait = data['rap_trait'];
        model.datClo = data['dat_clo'];
        model.rapClo = data['rap_clo'];
        model.pourcTypenc = data['pourc_typenc'];
        model.detectPar = data['detect_par'];

        //delete table
        await localPNCService.deleteTableChampObligatoirePNC();
        //save data
        await localPNCService.saveChampObligatoirePNC(model);
        print('Inserting data in table ChampObligatoirePNC : ${data} ');
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error ChampObligatoirePNC", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  //--------------------------------Domaine affectation
  Future<void> getSite() async {
    try {
      isDataProcessing(true);
      //rest api
      await ApiServicesCall().getSiteOffline(matricule).then((resp) async {
        resp.forEach((data) async {
          //print('get site : ${data} ');
          var model = SiteModel();
          model.codesite = data['codeSite'];
          model.site = data['site'];
          model.module = data['module'];
          model.fiche = data['fiche'];
          //delete table
          await localActionService.deleteAllSite();
          //save data
          await localActionService.saveSite(model);
          print('Inserting data in table Site : ${model.site} ');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar("Error Site", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getProcessus() async {
    try {
      isDataProcessing(true);
      //rest api
      await ApiServicesCall().getProcessusOffline(matricule).then((resp) async {
        resp.forEach((data) async {
          //print('get processus : ${data} ');
          var model = ProcessusModel();
          model.codeProcessus = data['codeProcessus'];
          model.processus = data['processus'];
          model.module = data['module'];
          model.fiche = data['fiche'];
          //listProcessus.add(model);
          //delete table
          await localActionService.deleteAllProcessus();
          //save data
          await localActionService.saveProcessus(model);
          print('Inserting data in table processus : ${model.processus} ');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar("Error Processus", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getDirection() async {
    try {
      isDataProcessing(true);
      //rest api
      await ApiServicesCall().getDirectionOffline(matricule).then((resp) async {
        resp.forEach((data) async {
          //print('get direction : ${data} ');
          var model = DirectionModel();
          model.codeDirection = data['codeDirection'];
          model.direction = data['direction'];
          model.module = data['module'];
          model.fiche = data['fiche'];
          //listDirection.add(model);
          //delete table
          await localActionService.deleteAllDirection();
          //save data
          await localActionService.saveDirection(model);
          print(
              'Inserting data in table direction : ${model.direction}- module : ${model.module} - fiche: ${model.fiche} ');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar("Error Direction", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getService() async {
    try {
      isDataProcessing(true);
      //rest api
      await ApiServicesCall().getService(matricule, 0, '', '').then(
          (resp) async {
        resp.forEach((data) async {
          //print('get service : ${data} ');
          var model = ServiceModel();
          model.codeService = data['codeService'];
          model.service = data['service'];
          model.codeDirection = data['idDirection'];
          model.module = data['module'];
          model.fiche = data['fiche'];
          //listService.add(model);
          //delete table
          await localActionService.deleteAllService();
          //save data
          await localActionService.saveService(model);
          print('Inserting data in table service : ${model.service} ');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar("Error Service", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getEmploye() async {
    try {
      isDataProcessing(true);
      //rest api
      await ApiServicesCall().getEmploye({"act": "", "lang": ""}).then(
          (resp) async {
        resp.forEach((data) async {
          //print('get employe : ${data} ');
          var model = EmployeModel();
          model.mat = data['mat'];
          model.nompre = data['nompre'];
          listEmploye.add(model);

          //delete table
          await localActionService.deleteAllEmploye();
          //save data
          await localActionService.saveEmploye(model);
          print(
              'Inserting data in table employe : ${model.nompre} - ${model.mat} ');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar("Error Employe", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getActivity() async {
    try {
      isDataProcessing(true);
      //rest api
      await ApiServicesCall().getActivityOffline(matricule).then((resp) async {
        resp.forEach((data) async {
          //print('get activity : ${data} ');
          var model = ActivityModel();
          model.codeDomaine = data['codeDomaine'];
          model.domaine = data['domaine'];
          model.module = data['module'];
          model.fiche = data['fiche'];
          //listActivity.add(model);
          //delete table
          await localActionService.deleteAllActivity();
          //save data
          await localActionService.saveActivity(model);
          print('Inserting data in table activity : ${model.domaine} ');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar("Error Activity", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  //----------------------------------Module Action--------------------------------------
  Future<void> getAction() async {
    try {
      isDataProcessing(true);
      //rest api
      await ActionService().getActionMethod2({
        "nact": "",
        "act": "",
        "refaud": "",
        "mat": matricule.toString(),
        "action_plus0": "",
        "action_plus1": "",
        "typeAction": ""
      }).then((resp) async {
        //isDataProcessing(false);
        resp.forEach((data) async {
          var model = ActionModel();
          model.nAct = data['nAct'];
          model.site = data['site'];
          model.sourceAct = data['sourceAct'];
          model.typeAct = data['typeAct'];
          model.date = data['date'];
          model.cloture = data['cloture'];
          model.act = data['act'];
          //model.tauxEff = data['tauxEff'];
          //model.tauxRea = data['tauxRea'];
          model.nomOrigine = data['nom_origine'];
          model.respClot = data['resp_clot'];
          model.fSimp = data['fSimp'];
          model.idAudit = data['idAudit'];
          model.actionPlus0 = data['action_plus0'];
          model.actionPlus1 = data['action_plus1'];
          //model.isd = data['isd'];
          //model.datsuivPrv = data['datsuiv_prv'];
          model.online = 1;
          //delete db local
          await localActionService.deleteAllAction();
          //save data in local db
          await localActionService.saveAction(model);
          print(
              'Inserting data in table Action : ${model.act} - nact:${model.nAct}');
        });
      }, onError: (err) {
        isDataProcessing.value = false;
        ShowSnackBar.snackBar("Error Action", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getTypeCauseAction() async {
    try {
      isDataProcessing(true);
      var connection = await Connectivity().checkConnectivity();
      //rest api
      /*await ApiServicesCall().getTypeCauseAction({
        "act": "",
        "typeC": "",
        "mat": matricule.toString(),
        "prov": ""
      })*/
      //delete table
      await localActionService.deleteTableTypeCauseAction();
      await ActionService().getTypesCausesOfAction(matricule, 0, 0).then(
          (resp) async {
        resp.forEach((data) async {
          var model = TypeCauseModel();
          model.online = 1;
          model.nAct = data['nact'];
          model.idTypeCause = data['id_tab_act_typecause'];
          model.codetypecause = data['codeTypeCause'];
          model.typecause = data['typeCause'];

          //save data
          await localActionService.saveTypeCauseAction(model);
          print(
              'Inserting data in table TypeCauseAction : ${model.nAct} - ${model.typecause} ');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error TypeCauseAction", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getTypeCauseActionARattacher() async {
    try {
      isDataProcessing(true);
      var connection = await Connectivity().checkConnectivity();
      //rest api
      //delete table
      await localActionService.deleteTableTypeCauseActionARattacher();
      await ActionService().getTypesCauseActionARattacher(matricule, 0).then(
          (resp) async {
        resp.forEach((data) async {
          //print('get source actions : ${data} ');
          var model = TypeCauseModel();
          model.codetypecause = data['codeTypeCause'];
          model.typecause = data['typeCause'];

          //save data
          await localActionService.saveTypeCauseActionARattacher(model);
          print(
              'Inserting data in table TypeCauseActionARattacher : ${model.codetypecause} - ${model.typecause} ');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar("Error SousAction", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getSourceAction() async {
    try {
      isDataProcessing(true);
      var connection = await Connectivity().checkConnectivity();
      //rest api
      await ApiServicesCall().getSourceAction().then((resp) async {
        resp.forEach((data) async {
          //print('get source actions : ${data} ');
          var model = SourceActionModel();
          model.codeSouceAct = data['codeSouceAct'];
          model.sourceAct = data['sourceAct'];
          listSourceAction.add(model);

          //delete table
          await localActionService.deleteAllSourceAction();
          //save data
          await localActionService.saveSourceAction(model);
          print('Inserting data in table SourceA : ${model.sourceAct} ');
        });
        print('get data');
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar("Error SousAction", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getTypeAction() async {
    try {
      isDataProcessing(true);
      var connection = await Connectivity().checkConnectivity();
      //rest api
      await ApiServicesCall().getTypeAction({"nom": "", "lang": ""}).then(
          (resp) async {
        resp.forEach((data) async {
          //print('get type actions : ${data} ');
          var model = TypeActionModel();
          model.codetypeAct = data['codetypeAct'];
          model.typeAct = data['typeAct'];
          model.actSimpl = data['act_simpl'];
          model.analyseCause = data['analyse_cause'];
          listTypeAction.add(model);

          //delete table
          await localActionService.deleteAllTypeAction();
          //save data
          await localActionService.saveTypeAction(model);
          print('Inserting data in table TypeA : ${model.typeAct} ');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar("Error TypeAction", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getResponsableCloture() async {
    try {
      isDataProcessing(true);
      //rest api
      await ApiServicesCall().getAllResponsableCloture().then((resp) async {
        resp.forEach((data) async {
          //print('get resp cloture : ${data} ');
          var model = RespClotureModel();
          model.mat = data['mat'];
          model.codeSite = data['codeSite'];
          model.codeProcessus = data['codeProcessus'];
          model.nompre = data['nompre'];
          model.site = data['site'];
          model.processus = data['processus'];
          listRespCloture.add(model);

          //delete table
          await localActionService.deleteAllResponsableCloture();
          //save data
          await localActionService.saveResponsableCloture(model);
          print('Inserting data in table RespCloture : ${model.mat} ');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error ResponsableCloture", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getProcessusEmploye() async {
    try {
      isDataProcessing(true);
      //rest api
      await ApiServicesCall().getProcessusEmploye().then((resp) async {
        resp.forEach((data) async {
          //print('get processus employe : ${data} ');
          var model = ProcessusEmployeModel();
          model.codeProcessus = data['codeProcessus'];
          model.processus = data['processus'];
          model.mat = data['mat'];
          listProcessusEmploye.add(model);

          //delete table
          await localActionService.deleteTableProcessusEmploye();
          //save data
          await localActionService.saveProcessusEmploye(model);
          print(
              'Inserting data in table processus employe : ${model.processus} ');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error processus emp", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar(
          "Exception processus emp", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getProduct() async {
    try {
      isDataProcessing(true);
      //rest api
      await ApiServicesCall()
          .getProduct({"codeProduit": "", "produit": ""}).then((resp) async {
        resp.forEach((data) async {
          //print('get product : ${data} ');
          var model = ProductModel();
          model.codePdt = data['codePdt'];
          model.produit = data['produit'];
          model.prix = data['prix'];
          model.typeProduit = data['typeProduit'];
          model.codeTypeProduit = data['codeTypeProduit'];
          listProduct.add(model);

          //delete table
          await localActionService.deleteAllProduct();
          //save data
          await localActionService.saveProduct(model);
          print('Inserting data in table product : ${model.produit} ');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar("Error Product", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getAuditAction() async {
    try {
      isDataProcessing(true);
      //rest api
      await ApiServicesCall().getAuditAction().then((resp) async {
        resp.forEach((data) async {
          //print('get audit actions : ${data} ');
          var model = AuditActionModel();
          model.idaudit = data['idaudit'];
          model.refAudit = data['refAudit'];
          model.interne = data['interne'];
          listAuditAction.add(model);

          //delete table
          await localActionService.deleteAllAuditAction();
          //save data
          await localActionService.saveAuditAction(model);
          print('Inserting data in table AuditAction : ${model.idaudit} ');
        });
        print('get data');
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar("Error AuditAction", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getPriorite() async {
    try {
      isDataProcessing(true);
      //rest api
      await ApiServicesCall().getPriorite().then((resp) async {
        resp.forEach((data) async {
          //print('get priorite : ${data} ');
          var model = PrioriteModel();
          model.codepriorite = data['codepriorite'];
          model.priorite = data['priorite'];
          listPriorite.add(model);

          //delete table
          await localActionService.deleteAllPriorite();
          //save data
          await localActionService.savePriorite(model);
          print('Inserting data in table Priorite : ${model.priorite} ');
        });
        //print('get data');
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar("Error Priorite", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getGravite() async {
    try {
      isDataProcessing(true);
      //rest api
      await ApiServicesCall().getGravite().then((resp) async {
        resp.forEach((data) async {
          //print('get gravite : ${data} ');
          var model = GraviteModel();
          model.codegravite = data['codegravite'];
          model.gravite = data['gravite'];
          listGravite.add(model);

          //delete table
          await localActionService.deleteAllGravite();
          //save data
          await localActionService.saveGravite(model);
          print('Inserting data in table Gravite : ${model.gravite} ');
        });
        //print('get data');
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar("Error Gravite", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getAllSousAction() async {
    try {
      isDataProcessing(true);
      //rest api
      await ApiServicesCall().getAllSousAction().then((resp) async {
        resp.forEach((data) async {
          //print('get all SousAction : ${data} ');
          var model = SousActionModel();
          model.nSousAct = data['nSousAct'];
          model.nAct = data['nAct'];
          model.cloture = data['cloture'];
          model.sousAct = data['sousAct'];
          model.delaiReal = data['delaiReal'];
          model.delaiSuivi = data['delaiSuivi'];
          model.dateReal = data['dateReal'];
          model.dateSuivi = data['dateSuivi'];
          model.coutPrev = data['coutPrev'];
          model.pourcentReal = data['pourcentReal'];
          model.depense = data['depense'];
          model.pourcentSuivie = data['pourcentSuivie'];
          model.rapportEff = data['rapportEff'];
          model.commentaire = data['commentaire'];
          model.respRealNom = data['respRealNom'];
          model.respSuivieNom = data['respSuivieNom'];
          model.respReal = data['respReal'];
          model.respSuivi = data['respSuivi'];
          model.priorite = data['priorite'];
          model.codePriorite = 1;
          model.gravite = data['gravite'];
          model.codeGravite = 1;
          model.processus = data['processus'];
          model.risques = data['risques'];
          model.online = 1;
          listSousAction.add(model);

          //delete table
          await localActionService.deleteAllSousAction();
          //save data
          await localActionService.saveSousAction(model);
          print(
              'Inserting data in table SousAction : NAct: ${model.nAct}, NSousAct ${model.nSousAct}, SousAct: ${model.sousAct}, online:${model.online} ');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error AllSousAction", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar(
          "Exception processus emp", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  //-----------------------------------Module PNC----------------------------------------------
  Future<void> getPNC() async {
    try {
      isDataProcessing(true);
      //rest api
      await PNCService().getPNC(matricule).then((resp) async {
        resp.forEach((data) async {
          //print('get site : ${data} ');
          var model = PNCModel();
          model.online = 1;
          model.nnc = data['nnc'];
          model.nc = data['nc'];
          model.codePdt = data['codePdt'];
          model.codeTypeNC = data['codeTypeNC'];
          model.dateDetect = data['dateDetect'];
          model.valRej = data['valRej'];
          model.unite = data['unite'];
          model.recep = data['recep'];
          model.qteDetect = data['qteDetect'];
          model.traitee = data['traitee'];
          model.etatNC = data['etatNC'];
          model.numInterne = data['ninterne'];
          model.numeroOf = data['numOf'];
          model.numeroLot = data['nlot'];
          model.rapportT = data['rapportT'];
          if (data['typeNC'] == null) {
            model.typeNC = '';
          } else {
            model.typeNC = data['typeNC'];
          }
          model.produit = data['produit'];
          model.site = data['site'];
          model.fournisseur = data['frs'];

          //delete table
          await localPNCService.deleteTablePNC();
          //save data
          await localPNCService.savePNC(model);
          print(
              'Inserting data in table PNC : ${model.nnc}-${model.nc}-${model.produit}');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar("Error PNC", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getAllProductsPNC() async {
    try {
      isDataProcessing(true);
      //rest api
      await PNCService().getAllProductsPNC(0).then((resp) async {
        resp.forEach((data) async {
          //print('get site : ${data} ');
          var model = ProductPNCModel();
          model.online = 1;
          model.nnc = data['nnc'];
          model.idNCProduct = data['id'];
          model.codeProduit = data['codeProduit'];
          model.produit = data['produit'];
          model.numOf = data['nof'];
          model.numLot = data['lot'];
          model.qdetect = data['qDetect'];
          model.qprod = data['qProd'];
          model.typeProduit = data['typeproduit'];
          model.unite = data['unite'];
          //model.typeNC = data['typeNC'];
          //delete table
          await localPNCService.deleteTableProductPNC();
          //save data
          await localPNCService.saveProductPNC(model);
          print(
              'Inserting data in table ProductPNC : ${model.nnc}-${model.codeProduit}-${model.produit}');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar("Error PNC", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getAllTypeCausePNC() async {
    try {
      isDataProcessing(true);
      //rest api
      await PNCService().getTypesCausesOfPNC(0).then((resp) async {
        resp.forEach((data) async {
          var model = TypeCausePNCModel();
          model.online = 1;
          model.nnc = data['nnc'];
          model.idTypeCause = data['id_tab_pnc_typeCause'];
          model.codetypecause = data['codeTypeCause'];
          model.typecause = data['typeCause'];

          //delete table
          await localPNCService.deleteTableTypeCausePNC();
          //save data
          await localPNCService.saveTypeCausePNC(model);
          print(
              'Inserting data in table TypeCausePNC : ${model.nnc}-${model.codetypecause}-${model.typecause}');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar("Error PNC", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getAllTypeCausePNCARattacher() async {
    try {
      isDataProcessing(true);
      //rest api
      await PNCService().getTypesCausesToAdded(0).then((resp) async {
        resp.forEach((data) async {
          var model = TypeCausePNCModel();
          model.codetypecause = data['codeTypeCause'];
          model.typecause = data['typeCause'];

          //delete table
          await localPNCService.deleteTableTypeCausePNCARattacher();
          //save data
          await localPNCService.saveTypeCausePNCARattacher(model);
          print(
              'Inserting data in table TypeCausePNCARattacher : ${model.codetypecause}-${model.typecause}');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar("Error PNC", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  //list fournisseur
  Future<void> getFournisseurs() async {
    try {
      isDataProcessing(true);
      //rest api
      await ApiServicesCall().getFournisseurs(matricule).then((resp) async {
        resp.forEach((data) async {
          //print('get site : ${data} ');
          var model = FournisseurModel();
          model.raisonSociale = data['raisonSociale'];
          model.activite = data['activite'];
          model.codeFr = data['codeFr'];

          //delete table
          await localPNCService.deleteTableFournisseur();
          //save data
          await localPNCService.saveFournisseur(model);
          print('Inserting data in table Fournisseur : ${model.codeFr} ');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar("Error Fournisseurs", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  //list client
  Future<void> getClients() async {
    try {
      isDataProcessing(true);
      //rest api
      await ApiServicesCall().getClients().then((resp) async {
        resp.forEach((data) async {
          //print('get site : ${data} ');
          var model = ClientModel();
          model.codeclt = data['codeclt'];
          model.nomClient = data['nomClient'];

          //delete table
          await localPNCService.deleteTableClient();
          //save data
          await localPNCService.saveClient(model);
          print('Inserting data in table Fournisseur : ${model.nomClient} ');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar("Error Clients", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  //list type pnc
  Future<void> getTypePNC() async {
    try {
      isDataProcessing(true);
      //rest api
      await ApiServicesCall().getTypePNC().then((resp) async {
        resp.forEach((data) async {
          //print('get site : ${data} ');
          var model = TypePNCModel();
          model.codeTypeNC = data['codeTypeNC'];
          model.typeNC = data['typeNC'];
          model.color = data['color'];

          //delete table
          await localPNCService.deleteTableTypePNC();
          //save data
          await localPNCService.saveTypePNC(model);
          print('Inserting data in table TypePNC : ${model.typeNC} ');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar("Error TypePNC", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  //list gravite pnc
  Future<void> getGravitePNC() async {
    try {
      isDataProcessing(true);
      //rest api
      await ApiServicesCall().getGravitePNC().then((resp) async {
        resp.forEach((data) async {
          //print('get site : ${data} ');
          var model = GravitePNCModel();
          model.nGravite = data['nGravite'];
          model.gravite = data['gravite'];

          //delete table
          await localPNCService.deleteTableGravitePNC();
          //save data
          await localPNCService.saveGravitePNC(model);
          print('Inserting data in table GravitePNC : ${model.gravite} ');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar("Error GravitePNC", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  //list source pnc
  Future<void> getSourcePNC() async {
    try {
      isDataProcessing(true);
      //rest api
      await ApiServicesCall().getSourcePNC().then((resp) async {
        resp.forEach((data) async {
          //print('get site : ${data} ');
          var model = SourcePNCModel();
          model.codeSourceNC = data['codeSourceNC'];
          model.sourceNC = data['sourceNC'];

          //delete table
          await localPNCService.deleteTableSourcePNC();
          //save data
          await localPNCService.saveSourcePNC(model);
          print('Inserting data in table SourcePNC : ${model.sourceNC} ');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar("Error SourcePNC", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  //list atelier pnc
  Future<void> getAtelierPNC() async {
    try {
      isDataProcessing(true);
      //rest api
      await ApiServicesCall().getAtelierPNC().then((resp) async {
        resp.forEach((data) async {
          //print('get site : ${data} ');
          var model = AtelierPNCModel();
          model.codeAtelier = data['codeAtelier'];
          model.atelier = data['atelier'];

          //delete table
          await localPNCService.deleteTableAtelierPNC();
          //save data
          await localPNCService.saveAtelierPNC(model);
          print('Inserting data in table AtelierPNC : ${model.atelier} ');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar("Error AtelierPNC", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  ///-----------------------------------------------------Module Reunion-------------------------
  Future<void> getReunion() async {
    try {
      isDataProcessing(true);
      //rest api
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
          //model.strEtat = data['strEtat'];
          //model.reunionPlus0 = data['reunion_plus0'];
          //model.reunionPlus1 = data['reunion_plus1'];

          //delete table
          await localReunionService.deleteTableReunion();
          //save data
          await localReunionService.saveReunion(model);
          print(
              'Inserting data in table Reunion : ${model.nReunion} - ${model.ordreJour}');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar("Error Reunion", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getParticipantsReunion() async {
    try {
      isDataProcessing(true);
      //rest api
      await ReunionService().getParticipant(0).then((resp) async {
        resp.forEach((data) async {
          var model = ParticipantReunionModel();
          model.online = 1;
          model.nompre = data['nomPre'];
          model.mat = data['mat'];
          model.aparticipe = data['aparticipe'];
          model.comment = data['comment'];
          model.confirm = data['confirm'];
          model.nReunion = data['nReunion'];

          //delete table
          await localReunionService.deleteTableParticipantReunion();
          //save data
          await localReunionService.saveParticipantReunion(model);
          print(
              'Inserting data in table ParticipantReunion : ${model.nReunion} - ${model.nompre}');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error ParticipantReunion", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getActionReunionRattacher() async {
    try {
      isDataProcessing(true);
      //rest api
      await ReunionService().getActionReunionRattacher(0).then((resp) async {
        //delete table
        await localReunionService.deleteTableActionReunion();
        resp.forEach((element) async {
          var model = ActionReunion();
          model.online = 1;
          model.nReunion = element['nReunion'];
          model.decision = element['decision'];
          model.nAct = element['nAct'];
          model.act = element['act'];
          model.efficacite = element['efficacite'];
          model.tauxRealisation = element['tauxRealisation'];
          model.actSimplif = element['act_simplif'];

          //save data
          await localReunionService.saveActionReunion(model);
          print(
              'Inserting data in table ActionReunion : ${model.nReunion} - ${model.nAct} - ${model.decision}');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error ActionReunion", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  //list type pnc
  Future<void> getTypeReunion() async {
    try {
      isDataProcessing(true);
      //rest api
      await ReunionService().getTypeReunion().then((resp) async {
        resp.forEach((data) async {
          //print('get site : ${data} ');
          var model = TypeReunionModel();
          model.codeTypeR = data['codeTypeR'];
          model.typeReunion = data['type_Reunion'];

          //delete table
          await localReunionService.deleteTableTypeReunion();
          //save data
          await localReunionService.saveTypeReunion(model);
          print('Inserting data in table TypeReunion : ${model.typeReunion} ');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar("Error TypeReunion", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  ///-----------------------------------------------------Module Documentation-------------------------
  Future<void> getDocument() async {
    try {
      isDataProcessing(true);
      //rest api
      await DocumentationService().getDocument(matricule).then((resp) async {
        resp.forEach((data) async {
          var model = DocumentationModel();
          model.online = 1;
          model.cdi = data['cdi'];
          model.libelle = data['libelle'];
          model.indice = data['indice'];
          model.typeDI = data['typeDI'];
          model.fichierLien = data['fichierLien'];
          model.motifMAJ = data['motifMAJ'];
          model.fl = data['fl'];
          model.dateRevis = data['dateRevis'];
          model.suffixe = data['suffixe'];
          model.favoris = data['favoris'];
          model.favorisEtat = data['favoris_etat'];
          model.mail = data['mail'];
          model.dateCreat = data['date_creat'];
          if (model.dateCreat == null) {
            model.dateCreat = "";
          }
          model.dateRevue = data['dateRevue'];
          model.dateprochRevue = data['dateprochRevue'];
          model.superv = data['superv'];
          model.sitesuperv = data['sitesuperv'];
          if (model.sitesuperv == null) {
            model.sitesuperv = "";
          }
          model.important = data['important'];
          model.issuperviseur = data['issuperviseur'];

          //delete table
          await localDocumentationService.deleteTableDocumentation();
          //save data
          await localDocumentationService.saveDocumentation(model);
          print(
              'Inserting data in table Documentation : ${model.cdi} - ${model.libelle}');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar("Error Document", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getTypeDocument() async {
    try {
      isDataProcessing(true);
      //rest api
      await DocumentationService().getTypeDocument().then((resp) async {
        resp.forEach((data) async {
          var model = TypeDocumentModel();
          model.codeType = data['codeTypeDI'];
          model.type = data['type'];

          //delete table
          await localDocumentationService.deleteTableTypeDocument();
          //save data
          await localDocumentationService.saveTypeDocument(model);
          print(
              'Inserting data in table TypeDocument : ${model.codeType} - ${model.type}');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar("Error TypeDocument", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  ///------------------------------------------Module Incident Environnement-------------------------
  Future<void> getIncidentEnvironnement() async {
    try {
      isDataProcessing(true);
      //rest api
      await IncidentEnvironnementService().getIncident(matricule).then(
          (resp) async {
        resp.forEach((data) async {
          var model = IncidentEnvModel();
          model.online = 1;
          model.n = data['n'];
          model.incident = data['incident'];
          model.dateDetect = data['date_detect'];
          model.lieu = data['lieu'];
          if (model.lieu == null) {
            model.lieu = "";
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
          await localIncidentEnvironnementService
              .deleteTableIncidentEnvironnement();
          //save data
          await localIncidentEnvironnementService
              .saveIncidentEnvironnement(model);
          print(
              'Inserting data in table IncidentEnvironnement : ${model.n} - ${model.incident}');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error IncidentEnvironnement", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getChampObligatoireIncidentEnv() async {
    try {
      isDataProcessing(true);
      //rest api
      await IncidentEnvironnementService()
          .getChampObligatoireIncidentEnv()
          .then((data) async {
        //print('get champ obligatoire : ${data} ');
        var model = ChampObligatoireIncidentEnvModel();
        model.incCat = data['inc_cat'];
        model.incTypecons = data['inc_typecons'];
        model.incTypecause = data['inc_typecause'];
        model.lieu = data['lieu'];
        model.desIncident = data['des_incident'];
        model.typeIncident = data['type_incident'];
        model.dateIncident = data['date_incident'];
        model.actionImmediates = data['action_immediates'];
        model.descIncident = data['desc_incident'];
        model.descCauses = data['desc_causes'];
        model.gravite = data['gravite'];
        //delete table
        await localIncidentEnvironnementService
            .deleteTableChampObligatoireIncidentEnv();
        //save data
        await localIncidentEnvironnementService
            .saveChampObligatoireIncidentEnv(model);
        print('Inserting data in table ChampObligatoireIncidentEnv : ${data} ');
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error ChampObligatoireIncidentEnv", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  //list type cause inc env
  Future<void> getTypeCauseIncidentEnv() async {
    try {
      isDataProcessing(true);
      //rest api
      await IncidentEnvironnementService().getTypeCauseIncidentEnv().then(
          (resp) async {
        resp.forEach((data) async {
          //print('get site : ${data} ');
          var model = TypeCauseIncidentModel();
          model.idTypeCause = data['idTypeCause'];
          model.typeCause = data['typeCause'];
          //delete table
          await localIncidentEnvironnementService
              .deleteTableTypeCauseIncidentEnv();
          //save data
          await localIncidentEnvironnementService
              .saveTypeCauseIncidentEnv(model);
          print(
              'Inserting data in table TypeCauseIncidentEnv : ${model.typeCause} ');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error TypeCauseIncidentEnv", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getTypeCauseIncidentEnvRattacher() async {
    try {
      isDataProcessing(true);
      //rest api
      await IncidentEnvironnementService()
          .getTypeCauseByIncident(0, matricule, 0)
          .then((resp) async {
        //delete table
        await localIncidentEnvironnementService
            .deleteTableTypeCauseIncidentEnvRattacher();
        resp.forEach((data) async {
          //print('get site : ${data} ');
          var model = TypeCauseIncidentModel();
          model.online = 1;
          model.idIncidentCause = data['id_incid_cause'];
          model.idIncident = data['idIncident'];
          model.idTypeCause = data['idCause'];
          model.typeCause = data['typeCause'];
          //save data
          await localIncidentEnvironnementService
              .saveTypeCauseRattacherIncidentEnv(model);
          print(
              'Inserting data in table TypeCauseIncidentEnvRattacher : ${model.idIncident} - ${model.typeCause} ');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error TypeCauseIncidentEnvR", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  //list category inc env
  Future<void> getCategoryIncidentEnv() async {
    try {
      isDataProcessing(true);
      //rest api
      await IncidentEnvironnementService().getCategoryIncidentEnv().then(
          (resp) async {
        resp.forEach((data) async {
          //print('get site : ${data} ');
          var model = CategoryModel();
          model.idCategorie = data['idCategorie'];
          model.categorie = data['categorie'];
          //delete table
          await localIncidentEnvironnementService
              .deleteTableCategoryIncidentEnv();
          //save data
          await localIncidentEnvironnementService
              .saveCategoryIncidentEnv(model);
          print(
              'Inserting data in table CategoryIncidentEnv : ${model.categorie} ');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error CategoryIncidentEnv", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  //list type consequence inc env
  Future<void> getTypeConsequenceIncidentEnv() async {
    try {
      isDataProcessing(true);
      //rest api
      await IncidentEnvironnementService().getTypeConsequenceIncidentEnv().then(
          (resp) async {
        //delete table
        await localIncidentEnvironnementService
            .deleteTableTypeConsequenceIncidentEnv();
        resp.forEach((data) async {
          //print('get site : ${data} ');
          var model = TypeConsequenceIncidentModel();
          model.idConsequence = data['idTypeConseq'];
          model.typeConsequence = data['typeConseq'];
          //save data
          await localIncidentEnvironnementService
              .saveTypeConsequenceIncidentEnv(model);
          print(
              'Inserting data in table TypeConsequenceIncidentEnv : ${model.typeConsequence} ');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error TypeConsequenceIncidentEnv", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getTypeConsequenceIncidentEnvRattacher() async {
    try {
      isDataProcessing(true);
      //rest api
      await IncidentEnvironnementService()
          .getTypeConsequenceByIncident(0, matricule, 0)
          .then((response) async {
        //delete table
        await localIncidentEnvironnementService
            .deleteTableTypeConsequenceIncidentEnvRattacher();
        response.forEach((data) async {
          var model = TypeConsequenceIncidentModel();
          model.online = 1;
          model.idIncidentConseq = data['id_incid_conseq'];
          model.idIncident = data['idIncident'];
          model.idConsequence = data['idConsequence'];
          model.typeConsequence = data['typeConsequence'];
          //save data
          await localIncidentEnvironnementService
              .saveTypeConsequenceRattacherIncidentEnv(model);
          print(
              'Inserting data in table TypeConsequenceIncidentEnvRattacher : ${model.idIncident} - ${model.typeConsequence} -idIncConseq:${model.idIncidentConseq} ');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar("Error TypeConsequenceIncidentEnvRattacher",
            err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  //list type inc env
  Future<void> getTypeIncidentEnv() async {
    try {
      isDataProcessing(true);
      //rest api
      await IncidentEnvironnementService().getTypeIncidentEnv().then(
          (resp) async {
        resp.forEach((data) async {
          //print('get site : ${data} ');
          var model = TypeIncidentModel();
          model.idType = data['idType'];
          model.typeIncident = data['type_Incident_Env'];
          //delete table
          await localIncidentEnvironnementService.deleteTableTypeIncidentEnv();
          //save data
          await localIncidentEnvironnementService.saveTypeIncidentEnv(model);
          print(
              'Inserting data in table TypeIncidentEnv : ${model.typeIncident}');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error TypeIncidentEnv", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  //list lieu inc env
  Future<void> getLieuIncidentEnv() async {
    try {
      isDataProcessing(true);
      //rest api
      await IncidentEnvironnementService().getLieuIncidentEnv(matricule).then(
          (resp) async {
        resp.forEach((data) async {
          //print('get site : ${data} ');
          var model = LieuModel();
          model.code = data['code'];
          model.lieu = data['lieu'];
          //delete table
          await localIncidentEnvironnementService.deleteTableLieuIncidentEnv();
          //save data
          await localIncidentEnvironnementService.saveLieuIncidentEnv(model);
          print('Inserting data in table LieuIncidentEnv : ${model.lieu}');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error LieuIncidentEnv", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  //list source inc env
  Future<void> getSourceIncidentEnv() async {
    try {
      isDataProcessing(true);
      //rest api
      await IncidentEnvironnementService().getSourceIncidentEnv().then(
          (resp) async {
        resp.forEach((data) async {
          //print('get site : ${data} ');
          var model = SourceIncidentEnvModel();
          model.idSource = data['id_Source'];
          model.source = data['source'];
          //delete table
          await localIncidentEnvironnementService
              .deleteTableSourceIncidentEnv();
          //save data
          await localIncidentEnvironnementService.saveSourceIncidentEnv(model);
          print('Inserting data in table SourceIncidentEnv : ${model.source}');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error SourceIncidentEnv", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  //list cout estime inc env
  Future<void> getCoutEstimeIncidentEnv() async {
    try {
      isDataProcessing(true);
      //rest api
      await IncidentEnvironnementService().getCoutEstimeIncidentEnv().then(
          (resp) async {
        resp.forEach((data) async {
          //print('get site : ${data} ');
          var model = CoutEstimeIncidentEnvModel();
          model.idCout = data['id_cout'];
          model.cout = data['cout'];
          //delete table
          await localIncidentEnvironnementService
              .deleteTableCoutEstimeIncidentEnv();
          //save data
          await localIncidentEnvironnementService
              .saveCoutEstimeIncidentEnv(model);
          print(
              'Inserting data in table CoutEstimeIncidentEnv : ${model.cout}');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error CoutEstimeIncidentEnv", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  //list gravite inc env
  Future<void> getGraviteIncidentEnv() async {
    try {
      isDataProcessing(true);
      //rest api
      await IncidentEnvironnementService().getGraviteIncidentEnv().then(
          (resp) async {
        resp.forEach((data) async {
          //print('get site : ${data} ');
          var model = GraviteModel();
          model.codegravite = data['code'];
          model.gravite = data['gravite'];
          //delete table
          await localIncidentEnvironnementService
              .deleteTableGraviteIncidentEnv();
          //save data
          await localIncidentEnvironnementService.saveGraviteIncidentEnv(model);
          print(
              'Inserting data in table GraviteIncidentEnv : ${model.gravite}');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error GraviteIncidentEnv", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  //list secteur inc env
  Future<void> getSecteurIncidentEnv() async {
    try {
      isDataProcessing(true);
      //rest api
      await IncidentEnvironnementService().getSecteurIncidentEnv().then(
          (resp) async {
        resp.forEach((data) async {
          //print('get site : ${data} ');
          var model = SecteurModel();
          model.codeSecteur = data['code'];
          model.secteur = data['secteur'];
          //delete table
          await localIncidentEnvironnementService
              .deleteTableSecteurIncidentEnv();
          //save data
          await localIncidentEnvironnementService.saveSecteurIncidentEnv(model);
          print(
              'Inserting data in table SecteurIncidentEnv : ${model.secteur}');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error SecteurIncidentEnv", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getActionIncEnvRattacher() async {
    try {
      isDataProcessing(true);
      await IncidentEnvironnementService()
          .getActionsIncidentEnvironnement(0)
          .then((response) async {
        await localIncidentEnvironnementService
            .deleteTableActionIncEnvRattacher();
        response.forEach((data) async {
          var model = ActionIncEnv();
          model.online = 1;
          model.idFiche = data['n_incid'];
          model.nAct = data['nAct'];
          model.act = data['act'];
          await localIncidentEnvironnementService
              .saveActionIncEnvRattacher(model);
          debugPrint(
              'Inserting data in table ActionIncEnvRattacher :${model.idFiche} - ${model.nAct} - ${model.act}');
        });
      }, onError: (error) {
        ShowSnackBar.snackBar(
            'Error ActionIncEnvRattacher', error.toString(), Colors.redAccent);
      });
    } catch (Exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar(
          'Exception ActionIncEnvRattacher', Exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  ///------------------------------------------Module Incident Securite-------------------------
  Future<void> getIncidentSecurite() async {
    try {
      isDataProcessing(true);
      //rest api
      await IncidentSecuriteService().getIncident(matricule).then((resp) async {
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

          //delete table
          await localIncidentSecuriteService.deleteTableIncidentSecurite();
          //save data
          await localIncidentSecuriteService.saveIncidentSecurite(model);
          print(
              'Inserting data in table IncidentSecurite : ${model.ref} - ${model.designation}');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error IncidentSecurite", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getChampObligatoireIncidentSecurite() async {
    try {
      isDataProcessing(true);
      //rest api
      await IncidentSecuriteService()
          .getChampObligatoireIncidentSecurite()
          .then((data) async {
        //print('get champ obligatoire : ${data} ');
        var model = ChampObligatoireIncidentSecuriteModel();
        model.incidentGrav = data['incident_grav'];
        model.incidentCat = data['incident_cat'];
        model.incidentTypeCons = data['incident_typeCons'];
        model.incidentTypeCause = data['incident_typeCause'];
        model.incidentPostet = data['incident_postet'];
        model.incidentSecteur = data['incident_secteur'];
        model.incidentDescInc = data['incident_descInc'];
        model.incidentDescCons = data['incident_descCons'];
        model.incidentDescCause = data['incident_descCause'];
        model.incidentAct = data['incident_act'];
        model.incidentNbrj = data['incident_nbrj'];
        model.incidentDesig = data['incident_desig'];
        model.incidentClot = data['incident_clot'];
        model.risqueClot = data['risque_clot'];
        model.incidentSemaine = data['incident_semaine'];
        model.incidentSiteLesion = data['incident_siteLesion'];
        model.incidentCauseTypique = data['incident_CauseTypique'];
        model.incidentEventDeclencheur = data['incident_EventDeclencheur'];
        model.dateVisite = data['date_visite'];
        model.comportementsObserve = data['comportements_observe'];
        model.comportementRisquesObserves =
            data['comportement_risques_observes'];
        model.correctionsImmediates = data['corrections_immediates'];
        //delete table
        await localIncidentSecuriteService
            .deleteTableChampObligatoireIncidentSecurite();
        //save data
        await localIncidentSecuriteService
            .saveChampObligatoireIncidentSecurite(model);
        print(
            'Inserting data in table ChampObligatoireIncidentSecurite : ${data} ');
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar("Error ChampObligatoireIncidentSecurite",
            err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getPosteTravailIncidentSecurite() async {
    try {
      isDataProcessing(true);
      //rest api
      await IncidentSecuriteService().getPosteTravailIncidentSecurite().then(
          (resp) async {
        resp.forEach((data) async {
          var model = PosteTravailModel();
          model.code = data['code'];
          model.poste = data['poste'];

          //delete table
          await localIncidentSecuriteService.deleteTablePosteTravail();
          //save data
          await localIncidentSecuriteService.savePosteTravail(model);
          print(
              'Inserting data in table PosteTravail : ${model.code} - ${model.poste}');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error PosteTravailIncidentSecurite", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getTypeIncidentSecurite() async {
    try {
      isDataProcessing(true);
      //rest api
      await IncidentSecuriteService().getTypeIncidentSecurite().then(
          (resp) async {
        resp.forEach((data) async {
          var model = TypeIncidentModel();
          model.idType = data['id_Type'];
          model.typeIncident = data['type_incident'];

          //delete table
          await localIncidentSecuriteService.deleteTableTypeIncidentSecurite();
          //save data
          await localIncidentSecuriteService.saveTypeIncidentSecurite(model);
          print(
              'Inserting data in table TypeIncidentSecurite : ${model.idType} - ${model.typeIncident}');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error TypeIncidentSecurite", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getCategoryIncidentSecurite() async {
    try {
      isDataProcessing(true);
      //rest api
      await IncidentSecuriteService().getCategoryIncidentSecurite().then(
          (resp) async {
        resp.forEach((data) async {
          var model = CategoryModel();
          model.idCategorie = data['idCategorie'];
          model.categorie = data['categorie'];

          //delete table
          await localIncidentSecuriteService
              .deleteTableCategoryIncidentSecurite();
          //save data
          await localIncidentSecuriteService
              .saveCategoryIncidentSecurite(model);
          print(
              'Inserting data in table CategoryIncidentSecurite : ${model.idCategorie} - ${model.categorie}');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error CategoryIncidentSecurite", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getCauseTypiqueIncidentSecurite() async {
    try {
      isDataProcessing(true);
      //rest api
      await IncidentSecuriteService()
          .getCauseTypiqueIncSecARattacher('', matricule)
          .then((resp) async {
        //delete table
        await localIncidentSecuriteService
            .deleteTableCauseTypiqueIncidentSecurite();
        resp.forEach((data) async {
          var model = CauseTypiqueModel();
          model.idIncidentCauseTypique = data['id_TypeCause'];
          model.causeTypique = data['causeTypique'];
          model.idCauseTypique = data['id_CauseTypique'];
          //save data
          await localIncidentSecuriteService
              .saveCauseTypiqueIncidentSecurite(model);
          print(
              'Inserting data in table CauseTypiqueIncidentSecurite : ${model.idCauseTypique} - ${model.causeTypique}');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error CauseTypiqueIncidentSecurite", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getCauseTypiqueIncSecRattacher() async {
    try {
      isDataProcessing(true);
      await IncidentSecuriteService()
          .getCauseTypiqueIncSecRattacher(0, matricule, 0)
          .then((response) async {
        await localIncidentSecuriteService
            .deleteTableCauseTypiqueIncSecRattacher();
        response.forEach((data) async {
          var model = CauseTypiqueModel();
          model.online = 1;
          model.idIncidentCauseTypique = data['id_inc_causeTypique'];
          model.causeTypique = data['causeTypique'];
          model.idCauseTypique = data['id_CauseTypique'];
          model.idIncident = data['id_incident'];
          //save table in db local
          await localIncidentSecuriteService
              .saveCauseTypiqueIncSecRattacher(model);
          debugPrint(
              'Inserting data in table CauseTypiqueIncSecRattacher : ${model.idIncident} - ${model.causeTypique}');
        });
      }, onError: (error) {
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            'error cause typique inc sec', error.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar(
          'Exception cause typique inc sec', exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getTypeCauseIncidentSecurite() async {
    try {
      isDataProcessing(true);
      //rest api
      await IncidentSecuriteService().getTypeCauseIncidentSecurite().then(
          (resp) async {
        resp.forEach((data) async {
          var model = TypeCauseIncidentModel();
          model.idTypeCause = data['id_cause'];
          model.typeCause = data['cause'];

          //delete table
          await localIncidentSecuriteService
              .deleteTableTypeCauseIncidentSecurite();
          //save data
          await localIncidentSecuriteService
              .saveTypeCauseIncidentSecurite(model);
          print(
              'Inserting data in table TypeCauseIncidentSecurite : ${model.idTypeCause} - ${model.typeCause}');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error TypeCauseIncidentSecurite", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getTypeCauseIncidentSecRattacher() async {
    try {
      isDataProcessing(true);
      //rest api
      await IncidentSecuriteService()
          .getTypeCauseIncSecRattacher(0, matricule, 0)
          .then((resp) async {
        //delete table
        await localIncidentSecuriteService
            .deleteTableTypeCauseIncSecRattacher();
        resp.forEach((data) async {
          var model = TypeCauseIncidentModel();
          model.online = 1;
          model.idIncident = data['id_incident'];
          model.idIncidentCause = data['id_incid_cause'];
          model.idTypeCause = data['id_cause'];
          model.typeCause = data['cause'];
          //save data
          await localIncidentSecuriteService
              .saveTypeCauseIncSecRattacher(model);
          print(
              'Inserting data in table TypeCauseIncidentSecRattacher : ${model.idIncident} - ${model.typeCause} ');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error TypeCauseIncSecR", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getTypeConsequenceIncidentSecurite() async {
    try {
      isDataProcessing(true);
      //rest api
      await IncidentSecuriteService().getTypeConsequenceIncidentSecurite().then(
          (resp) async {
        resp.forEach((data) async {
          var model = TypeConsequenceModel();
          model.idTypeConseq = data['id_conseq'];
          model.typeConseq = data['consequence'];

          //delete table
          await localIncidentSecuriteService
              .deleteTableTypeConsequenceIncidentSecurite();
          //save data
          await localIncidentSecuriteService
              .saveTypeConsequenceIncidentSecurite(model);
          print(
              'Inserting data in table TypeConsequenceIncidentSecurite : ${model.idTypeConseq} - ${model.typeConseq}');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar("Error TypeConsequenceIncidentSecurite",
            err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getTypeConsequenceIncSecRattacher() async {
    try {
      await IncidentSecuriteService()
          .getTypeConsequenceIncSecRattacher(0, matricule, 0)
          .then((response) async {
        //delete table
        await localIncidentSecuriteService
            .deleteTableTypeConsequenceIncSecRattacher();
        response.forEach((data) async {
          var model = TypeConsequenceIncidentModel();
          model.online = 1;
          model.idIncident = data['id_incident'];
          model.idIncidentConseq = data['id_incid_conseq'];
          model.idConsequence = data['id_conseq'];
          model.typeConsequence = data['consequence'];
          //save data
          await localIncidentSecuriteService
              .saveTypeConsequenceIncSecRattacher(model);
          print(
              'Inserting data in table TypeConsequenceIncSecRattacher : ${model.idIncident} - ${model.typeConsequence} -idIncConseq:${model.idIncidentConseq} ');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error TypeConsequenceIncSecRattacher", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getSiteLesionIncidentSecurite() async {
    try {
      isDataProcessing(true);
      //rest api
      await IncidentSecuriteService()
          .getSiteLesionIncidentSecurite('', matricule)
          .then((resp) async {
        resp.forEach((data) async {
          var model = SiteLesionModel();
          model.codeSiteLesion = data['code_siteDeLesion'];
          model.siteLesion = data['siteDeLesion'];

          //delete table
          await localIncidentSecuriteService
              .deleteTableSiteLesionIncidentSecurite();
          //save data
          await localIncidentSecuriteService
              .saveSiteLesionIncidentSecurite(model);
          print(
              'Inserting data in table SiteLesionIncidentSecurite : ${model.codeSiteLesion} - ${model.siteLesion}');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error SiteLesionIncidentSecurite", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getSiteLesionIncSecRattacher() async {
    try {
      isDataProcessing(true);
      //rest api
      await IncidentSecuriteService()
          .getSiteLesionIncSecRattacher(0, matricule, 0)
          .then((resp) async {
        await localIncidentSecuriteService
            .deleteTableSiteLesionIncSecRattacher();
        resp.forEach((data) async {
          var model = SiteLesionModel();
          model.online = 1;
          model.idIncident = data['id_incident'];
          model.idIncCodeSiteLesion = data['id_inc_siteLesion'];
          model.codeSiteLesion = data['code_siteDeLesion'];
          model.siteLesion = data['siteDeLesion'];
          //save data
          await localIncidentSecuriteService
              .saveSiteLesionIncSecRattacher(model);
          print(
              'Inserting data in table SiteLesionIncidentSecuriteRattacher : ${model.idIncident} - ${model.siteLesion}');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar("Error SiteLesionIncidentSecuriteRattacher",
            err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception SiteLesionIncidentSecuriteRattacher",
          exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getGraviteIncidentSecurite() async {
    try {
      isDataProcessing(true);
      //rest api
      await IncidentSecuriteService().getGraviteIncidentSecurite().then(
          (resp) async {
        resp.forEach((data) async {
          var model = GraviteModel();
          model.codegravite = data['codegravite'];
          model.gravite = data['gravite'];

          //delete table
          await localIncidentSecuriteService
              .deleteTableGraviteIncidentSecurite();
          //save data
          await localIncidentSecuriteService.saveGraviteIncidentSecurite(model);
          print(
              'Inserting data in table GraviteIncidentSecurite : ${model.codegravite} - ${model.gravite}');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error GraviteIncidentSecurite", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getSecteurIncidentSecurite() async {
    try {
      isDataProcessing(true);
      //rest api
      await IncidentSecuriteService().getSecteurIncidentSecurite().then(
          (resp) async {
        resp.forEach((data) async {
          var model = SecteurModel();
          model.codeSecteur = data['code'];
          model.secteur = data['secteur'];

          //delete table
          await localIncidentSecuriteService
              .deleteTableSecteurIncidentSecurite();
          //save data
          await localIncidentSecuriteService.saveSecteurIncidentSecurite(model);
          print(
              'Inserting data in table SecteurIncidentSecurite : ${model.codeSecteur} - ${model.secteur}');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error SecteurIncidentSecurite", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getCoutEstemeIncedentSecurite() async {
    try {
      isDataProcessing(true);
      await IncidentSecuriteService().getCoutEstemeIncidentSecurite().then(
          (response) async {
        response.forEach((element) async {
          var model = CoutEstimeIncidentEnvModel();
          model.idCout = element['id_cout'];
          model.cout = element['cout'];
          //delete table
          await localIncidentSecuriteService
              .deleteTableCoutEstimeIncidentSecurite();
          //save data
          await localIncidentSecuriteService
              .saveCoutEstimeIncidentSecurite(model);
          print(
              'Inserting data in table CoutEstimeIncidentSecurite : ${model.idCout} - ${model.cout}');
        });
      }, onError: (error) {
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error CoutEstemeIncedentSecurite", error.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getEvenementDeclencheurIncidentSecurite() async {
    try {
      isDataProcessing(true);
      //rest api
      await IncidentSecuriteService()
          .getEvenementDeclencheurIncidentSecurite()
          .then((resp) async {
        resp.forEach((data) async {
          var model = EvenementDeclencheurModel();
          model.idEvent = data['id_Event'];
          model.event = data['evenement'];

          //delete table
          await localIncidentSecuriteService
              .deleteTableEvenementDeclencheurIncidentSecurite();
          //save data
          await localIncidentSecuriteService
              .saveEvenementDeclencheurIncidentSecurite(model);
          print(
              'Inserting data in table EvenementDeclencheurIncidentSecurite : ${model.idEvent} - ${model.event}');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar("Error EvenementDeclencheurIncidentSecurite",
            err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getActionIncSecRattacher() async {
    try {
      isDataProcessing(true);
      await IncidentSecuriteService().getActionsIncidentSecurite(0, '0').then(
          (response) async {
        await localIncidentSecuriteService.deleteTableActionIncSecRattacher();
        response.forEach((data) async {
          var model = ActionIncSec();
          model.online = 1;
          model.idFiche = data['ref'];
          model.nAct = data['nact'];
          model.act = data['act'];
          await localIncidentSecuriteService.saveActionIncSecRattacher(model);
          debugPrint(
              'Inserting data in table ActionIncSecRattacher :${model.idFiche} - ${model.nAct} - ${model.act}');
        });
      }, onError: (error) {
        ShowSnackBar.snackBar(
            'Error ActionIncSecRattacher', error.toString(), Colors.redAccent);
      });
    } catch (Exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar(
          'Exception ActionIncSecRattacher', Exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  //------------------------------------------Module Visite Securite--------------------------
  Future<void> getVisiteSecurite() async {
    try {
      isDataProcessing(true);
      //rest api
      await VisiteSecuriteService().getVisiteSecurite(matricule).then(
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
          await localVisiteSecuriteService.deleteTableVisiteSecurite();
          //save data
          await localVisiteSecuriteService.saveVisiteSecurite(model);
          print(
              'Inserting data in table VisiteSecurite : ${model.id} - ${model.unite} - ${model.zone}');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error VisiteSecurite", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getCheckList() async {
    try {
      isDataProcessing(true);
      //rest api
      await VisiteSecuriteService().getCheckList().then((resp) async {
        resp.forEach((data) async {
          var model = CheckListModel();
          model.idCheck = data['id_Check'];
          model.code = data['code'];
          model.checklist = data['checklist'];

          //delete table
          await localVisiteSecuriteService.deleteTableCheckList();
          //save data
          await localVisiteSecuriteService.saveCheckList(model);
          print(
              'Inserting data in table CheckList : ${model.idCheck} - ${model.checklist}');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar("Error CheckList", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getUniteVisiteSecurite() async {
    try {
      isDataProcessing(true);
      //rest api
      await VisiteSecuriteService().getUniteVisiteSecurite().then((resp) async {
        resp.forEach((data) async {
          var model = UniteModel();
          model.idUnite = data['id_unite'];
          model.code = data['code'];
          model.unite = data['unite'];

          //delete table
          await localVisiteSecuriteService.deleteTableUniteVisiteSecurite();
          //save data
          await localVisiteSecuriteService.saveUniteVisiteSecurite(model);
          print(
              'Inserting data in table UniteVisiteSecurite : ${model.idUnite} - ${model.unite}');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error UniteVisiteSecurite", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getZoneVisiteSecurite() async {
    try {
      isDataProcessing(true);
      //rest api
      await VisiteSecuriteService().getZone().then((resp) async {
        resp.forEach((data) async {
          var model = ZoneModel();
          model.idZone = data['id_Zone'];
          model.idUnite = data['id_Unite'];
          model.code = data['codeZone'];
          model.zone = data['zone'];

          //delete table
          await localVisiteSecuriteService.deleteTableZoneVisiteSecurite();
          //save data
          await localVisiteSecuriteService.saveZoneVisiteSecurite(model);
          print(
              'Inserting data in table ZoneVisiteSecurite : ${model.idZone} - ${model.zone}');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error ZoneVisiteSecurite", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getSiteVisiteSecurite() async {
    try {
      isDataProcessing(true);
      //rest api
      await VisiteSecuriteService().getSiteVisiteSecurite(matricule).then(
          (resp) async {
        resp.forEach((data) async {
          var model = SiteModel();
          model.codesite = data['codesite'];
          model.site = data['site'];

          //delete table
          await localVisiteSecuriteService.deleteTableSiteVisiteSecurite();
          //save data
          await localVisiteSecuriteService.saveSiteVisiteSecurite(model);
          print('Inserting data in table SiteVisiteSecurite : ${model.site}');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar("Error  ", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar(
          "Exception SiteVisiteSecurite", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getEquipeVisiteSecuriteFromAPI() async {
    try {
      isDataProcessing(true);
      //rest api
      await VisiteSecuriteService().getEquipeVisiteSecurite(0).then(
          (resp) async {
        resp.forEach((data) async {
          var model = EquipeVisiteSecuriteModel();
          model.online = 1;
          model.id = data['id_Fiche'];
          model.affectation = data['affectation'];
          model.mat = data['resp'];
          model.nompre = data['nomPre'];

          //delete table
          await localVisiteSecuriteService
              .deleteTableEquipeVisiteSecuriteOffline();
          //save data
          await localVisiteSecuriteService
              .saveEquipeVisiteSecuriteOffline(model);
          print(
              'Inserting data in table EquipeVisiteSecuriteOffline : ${model.id} - ${model.nompre}');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error EquipeVisiteSecuriteFromAPI", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getCheckListVSRattacher() async {
    try {
      isDataProcessing(true);
      //rest api
      await VisiteSecuriteService().getCheckListCritere(0).then((resp) async {
        //delete table
        await localVisiteSecuriteService.deleteTableCheckListRattacher();
        resp.forEach((data) async {
          var model = CheckListCritereModel();
          model.online = 1;
          model.id = data['id'];
          model.idFiche = data['idFiche'];
          model.idReg = data['id_Reg'];
          model.lib = data['lib'];
          model.eval = data['eval'];
          model.commentaire = data['commentaire'];
          //save data
          await localVisiteSecuriteService.saveCheckListRattacher(model);
          debugPrint(
              'Inserting data in table CheckListVSRattacher : ${model.idFiche} - ${model.id} - ${model.lib}');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error CheckListVSRattacher", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar(
          "Exception CheckListVSRattacher", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getTauxCheckListVS() async {
    try {
      isDataProcessing(true);
      await VisiteSecuriteService().getTauxRespect(0).then((response) async {
        await localVisiteSecuriteService.deleteTableTauxCheckListVS();
        response.forEach((data) async {
          var model = TauxCheckListVS();
          model.id = data['id'];
          model.taux = data['taux'];
          await localVisiteSecuriteService.saveTauxCheckListVS(model);
          debugPrint(
              'Inserting data in table TauxCheckListVS :${model.id} - ${model.taux}');
        });
      }, onError: (error) {
        ShowSnackBar.snackBar(
            'Error TauxCheckListVS', error.toString(), Colors.redAccent);
      });
    } catch (Exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar(
          'Exception TauxCheckListVS', Exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getActionVSRattacher() async {
    try {
      isDataProcessing(true);
      await VisiteSecuriteService().getActionsVisiteSecurite(0).then(
          (response) async {
        await localVisiteSecuriteService.deleteTableActionVSRattacher();
        response.forEach((data) async {
          var model = ActionVisiteSecurite();
          model.online = 1;
          model.idFiche = data['idFiche'];
          model.nAct = data['nAct'];
          model.act = data['act'];
          await localVisiteSecuriteService.saveActionVSRattacher(model);
          debugPrint(
              'Inserting data in table ActionVSRattacher :${model.idFiche} - ${model.nAct} - ${model.act}');
        });
      }, onError: (error) {
        ShowSnackBar.snackBar(
            'Error ActionVSRattacher', error.toString(), Colors.redAccent);
      });
    } catch (Exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar(
          'Exception ActionVSRattacher', Exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  //------------------------------------------Module Audit--------------------------
  Future<void> getAudits() async {
    try {
      isDataProcessing(true);
      //rest api
      //final listAudit = await AuditService().getAudits() as List<AuditModel>;
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
          if (data.rapportClot == null) {
            model.rapportClot = '';
          } else {
            model.rapportClot = data.rapportClot;
          }

          //delete table
          await localAuditService.deleteTableAudit();
          //save data
          await localAuditService.saveAudit(model);
          print(
              'Inserting data in table Audit : ${model.idAudit} - ${model.champ}');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar("Error Audits", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getConstatsActionProv() async {
    try {
      isDataProcessing(true);
      //rest api
      //final listAudit = await AuditService().getAudits() as List<AuditModel>;
      await AuditService().getConstatAudit(0, '%24_act_prov').then(
          (resp) async {
        resp.forEach((data) async {
          var model = ConstatAuditModel();
          model.online = 1;
          model.refAudit = data['refAudit'];
          int? idAudit = int.parse(data['refAudit'].toString().substring(5));
          model.idAudit = idAudit;
          model.nact = data['nact'];
          model.idCrit = data['idCrit'];
          model.ngravite = data['ngravite'];
          model.codeTypeE = data['codeTypeE'];
          model.gravite = data['gravite'];
          model.typeE = data['typeE'];
          model.mat = data['mat'];
          model.nomPre = data['nomPre'];
          if (data['prov'] == null) {
            model.prov = 0;
          } else {
            model.prov = data['prov'];
          }
          model.idEcart = data['id_Ecart'];
          model.pr = data['pr'];
          model.ps = data['ps'];
          model.descPb = data['descPb'];
          model.act = data['act'];
          model.typeAct = data['typeAct'];
          model.sourceAct = data['sourceAct'];
          model.codeChamp = data['codeChamp'];
          model.champ = data['champ'];
          if (data['delaiReal'] == null) {
            model.delaiReal = '';
          } else {
            model.delaiReal = data['delaiReal'];
          }

          //delete table
          await localAuditService.deleteTableConstatAudit();
          //save data
          await localAuditService.saveConstatAudit(model);
          print(
              'Inserting data in table ConstatAudit Action Prov : ${model.refAudit} - ${model.idAudit} - ${model.champ}');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error Constat Audits", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getConstatsAction() async {
    try {
      isDataProcessing(true);
      //rest api
      //final listAudit = await AuditService().getAudits() as List<AuditModel>;
      await AuditService().getConstatAudit(0, '%24_act').then((resp) async {
        resp.forEach((data) async {
          var model = ConstatAuditModel();
          model.online = 1;
          model.refAudit = data['refAudit'];
          int? idAudit = int.parse(data['refAudit'].toString().substring(5));
          model.idAudit = idAudit;
          model.nact = data['nact'];
          model.idCrit = data['idCrit'];
          model.ngravite = data['ngravite'];
          model.codeTypeE = data['codeTypeE'];
          model.gravite = data['gravite'];
          model.typeE = data['typeE'];
          model.mat = data['mat'];
          model.nomPre = data['nomPre'];
          if (data['prov'] == null) {
            model.prov = 0;
          } else {
            model.prov = data['prov'];
          }
          model.idEcart = data['id_Ecart'];
          model.pr = data['pr'];
          model.ps = data['ps'];
          model.descPb = data['descPb'];
          model.act = data['act'];
          model.typeAct = data['typeAct'];
          model.sourceAct = data['sourceAct'];
          model.codeChamp = data['codeChamp'];
          model.champ = data['champ'];
          if (data['delaiReal'] == null) {
            model.delaiReal = '';
          } else {
            model.delaiReal = data['delaiReal'];
          }

          //delete table
          //await localAuditService.deleteTableConstatAudit();
          //save data
          await localAuditService.saveConstatAudit(model);
          print(
              'Inserting data in table ConstatAudit Action : ${model.refAudit} - ${model.idAudit} - ${model.champ}');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error Constat Audits", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getAuditeurInterne() async {
    try {
      await AuditService().getAuditeurInterne(0).then((response) async {
        response.forEach((data) async {
          var model = AuditeurModel();
          model.online = 1;
          model.refAudit = data['refAudit'];
          model.mat = data['mat'];
          model.nompre = data['nomPre'];
          model.affectation = data['affectation'];
          //delete table local
          await localAuditService.deleteTableAuditeurInterne();
          //save data in db local
          await localAuditService.saveAuditeurInterne(model);
          print(
              'Inserting data in table AuditeurInterne : ${model.refAudit} - ${model.nompre}');
        });
      }, onError: (error) {
        if (kDebugMode) {
          print('error : ${error.toString()}');
        }
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error AuditeurInterne", error.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getAuditeurInterneARattacher() async {
    try {
      await AuditService().getAuditeurInterneToAdd(0).then((response) async {
        response.forEach((data) async {
          var model = AuditeurModel();
          model.refAudit = data['refAudit'];
          model.mat = data['mat'];
          model.nompre = data['nompre'];
          //delete table local
          await localAuditService.deleteTableAuditeurInterneARattacher();
          //save data in db local
          await localAuditService.saveAuditeurInterneARattacher(model);
          print(
              'Inserting data in table AuditeurInterneARattacher : ${model.refAudit} - ${model.nompre}');
        });
      }, onError: (error) {
        if (kDebugMode) {
          print('error : ${error.toString()}');
        }
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error AuditeurInterneARattacher", error.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getChampAudit() async {
    try {
      await AuditService().getChampAudit(matricule).then((response) async {
        response.forEach((element) async {
          var model = ChampAuditModel();
          model.codeChamp = element['codeChamp'];
          model.champ = element['champ'];
          model.criticite = element['criticite'];
          //delete table local
          await localAuditService.deleteTableChampAudit();
          //save data in db local
          await localAuditService.saveChampAudit(model);
          print('Inserting data in table ChampAudit : ${model.champ}');
        });
      }, onError: (error) {
        if (kDebugMode) {
          print('error : ${error.toString()}');
        }
        isDataProcessing(false);
        ShowSnackBar.snackBar("Error ChampAudit", error.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getChampAuditByRefAudit() async {
    try {
      await AuditService().getChampAuditByFiche(0).then((response) async {
        response.forEach((element) async {
          var model = ChampAuditModel();
          model.online = 1;
          model.codeChamp = element['codeChamp'];
          model.champ = element['champ'];
          model.criticite = element['criticite'];
          model.refAudit = element['refAudit'];
          //delete table local
          await localAuditService.deleteTableChampAuditConstat();
          //save data in db local
          await localAuditService.saveChampAuditConstat(model);
          print(
              'Inserting data in table ChampAuditConstat : ${model.refAudit} - ${model.champ}');
        });
      }, onError: (error) {
        if (kDebugMode) {
          print('error : ${error.toString()}');
        }
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error TypeConstatAudit", error.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getTypeAudit() async {
    try {
      await AuditService().getTypeAudit(matricule).then((response) async {
        //delete table local
        await localAuditService.deleteTableTypeAudit();
        response.forEach((element) async {
          var model = TypeAuditModel();
          model.codeType = element['codeTypeA'];
          model.type = element['typeA'];
          //save data in db local
          await localAuditService.saveTypeAudit(model);
          print('Inserting data in table TypeAudit : ${model.type}');
        });
      }, onError: (error) {
        if (kDebugMode) {
          print('error TypeAudit : ${error.toString()}');
        }
        isDataProcessing(false);
        ShowSnackBar.snackBar("Error TypeAudit", error.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getGraviteAudit() async {
    try {
      isDataProcessing(true);
      //rest api
      await AuditService().getGraviteAudit().then((resp) async {
        resp.forEach((data) async {
          //print('get site : ${data} ');
          var model = GraviteModel();
          model.codegravite = data['nGravite'];
          model.gravite = data['gravite'];
          //delete table
          await localAuditService.deleteTableGraviteAudit();
          //save data
          await localAuditService.saveGraviteAudit(model);
          print('Inserting data in table GraviteAudit : ${model.gravite}');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar("Error GraviteAudit", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getTypeConstatAudit() async {
    try {
      await AuditService().getTypeConstatAudit().then((response) async {
        response.forEach((element) async {
          var model = TypeAuditModel();
          model.codeType = element['codeTypeE'];
          model.type = element['typeE'];

          //delete table local
          await localAuditService.deleteTableTypeConstatAudit();
          //save data in db local
          await localAuditService.saveTypeConstatAudit(model);
          print('Inserting data in table TypeConstatAudit : ${model.type}');
        });
      }, onError: (error) {
        if (kDebugMode) {
          print('error : ${error.toString()}');
        }
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error TypeConstatAudit", error.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  //---------------------------------------------Agenda--------------------------------------------
  //----------------------------------------Action-----------------------------
  //action realisation
  Future<void> getActionsRealisation() async {
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
          //delete table
          await localActionService.deleteAllActionRealisation();
          //save data
          await localActionService.saveActionRealisation(model);
          print(
              'Inserting data in table ActionRealisation : ${model.nAct} - ${model.sousAct} ');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error ActionsRealisation", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  //action suivi
  Future<void> getActionsSuivi() async {
    try {
      isDataProcessing(true);

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
          //delete table
          await localActionService.deleteAllActionSuivi();
          //save data
          await localActionService.saveActionSuivi(model);
          print(
              'Inserting data in table ActionSuivi : ${model.nAct} - ${model.sousAct} ');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar("Error ActionsSuivi", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  //action realisation
  Future<void> getActionsSuiteAudit() async {
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
          //delete table
          await localActionService.deleteAllActionSuiteAudit();
          //save data
          await localActionService.saveActionSuiteAudit(model);
          print(
              'Inserting data in table ActionSuiteAudit : ${model.nact} - ${model.act} ');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error ActionsSuiteAudit", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  //--------------------------------PNC------------------------------------------
  //PNC a valider
  Future<void> getPNCAValider() async {
    try {
      isDataProcessing(true);

      //rest api
      PNCService().getPNCAValider(matricule).then((resp) async {
        //isDataProcessing(false);
        resp.forEach((data) async {
          var model = PNCCorrigerModel();
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
          model.ninterne = data['ninterne'];
          //delete table
          await localPNCService.deleteTablePNCValider();
          //save data
          await localPNCService.savePNCValider(model);
          print(
              'Inserting data in table PNCValider : ${model.nnc} - ${model.produit} ');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar("Error PNCAValider", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  //PNC a corriger
  Future<void> getPNCACorriger() async {
    try {
      isDataProcessing(true);
      //rest api
      PNCService().getPNCACorriger(matricule).then((resp) async {
        //isDataProcessing(false);
        resp.forEach((data) async {
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
          //delete table
          await localPNCService.deleteTablePNCACorriger();
          //save data
          await localPNCService.savePNCACorriger(model);
          print(
              'Inserting data in table PNCACorriger : ${model.nnc} - ${model.produit} ');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar("Error PNCACorriger", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  //PNC a decider
  Future<void> getPNCDecision() async {
    try {
      isDataProcessing(true);
      //rest api
      PNCService().getPNCTraitementDecision(matricule).then((resp) async {
        //isDataProcessing(false);
        //delete table
        await localPNCService.deleteTablePNCDecision();
        resp.forEach((data) async {
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
          //save data
          await localPNCService.savePNCDecision(model);
          print(
              'Inserting data in table PNCDecision : ${model.nnc} - ${model.produit} ');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error PNC Decision Traitement", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  //PNC a decider
  Future<void> getPNCATraiter() async {
    try {
      isDataProcessing(true);
      //rest api
      PNCService().getPNCATraiter({
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
          //delete table
          await localPNCService.deleteTablePNCATraiter();
          //save data
          await localPNCService.savePNCATraiter(model);
          print(
              'Inserting data in table PNCATraiter : ${model.nnc} - ${model.produit} ');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar("Error PNCATraiter", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  //PNC Investigation Approuver
  Future<void> getPNCInvestigationApprouver() async {
    try {
      isDataProcessing(true);

      //rest api
      PNCService().getPNCInvestigationApprouver(matricule).then((resp) async {
        //isDataProcessing(false);
        resp.forEach((data) async {
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
          //delete table
          await localPNCService.deleteTablePNCInvestigationApprouver();
          //save data
          await localPNCService.savePNCInvestigationApprouver(model);
          print(
              'Inserting data in table InvestigationApprouver : ${model.nnc} - ${model.produit} ');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error PNCInvestigationApprouver", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  //PNC Investigation Effectuer
  Future<void> getPNCInvestigationEffectuer() async {
    try {
      isDataProcessing(true);

      //rest api
      PNCService().getPNCInvestigationEffectuer(matricule).then((resp) async {
        //isDataProcessing(false);
        resp.forEach((data) async {
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
          //delete table
          await localPNCService.deleteTablePNCInvestigationEffectuer();
          //save data
          await localPNCService.savePNCInvestigationEffectuer(model);
          print(
              'Inserting data in table InvestigationEffectuer : ${model.nnc} - ${model.produit} ');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error PNCInvestigationEffectuer", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  //PNC a suivre
  Future<void> getPNCASuivre() async {
    try {
      isDataProcessing(true);

      //rest api
      PNCService().getPNCASuivre(matricule).then((resp) async {
        //isDataProcessing(false);
        resp.forEach((data) async {
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
          //delete table
          await localPNCService.deleteTablePNCASuivre();
          //save data
          await localPNCService.savePNCASuivre(model);
          print(
              'Inserting data in table PNCASuivre : ${model.nnc} - ${model.produit} ');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar("Error PNCASuivre", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  //PNC approbation finale
  Future<void> getPNCApprobationFinale() async {
    try {
      isDataProcessing(true);
      //rest api
      PNCService().getApprobationFinale(matricule).then((resp) async {
        //isDataProcessing(false);
        resp.forEach((data) async {
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
          //delete table
          await localPNCService.deleteTablePNCApprobationFinale();
          //save data
          await localPNCService.savePNCApprobationFinale(model);
          print(
              'Inserting data in table PNCApprobationFinale : ${model.nnc} - ${model.produit} ');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error PNCApprobationFinale", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  //PNC decision traitement a validater
  Future<void> getPNCDecisionTraitementAValidater() async {
    try {
      isDataProcessing(true);
      //rest api
      PNCService().getPNCValiderDecisionTraitement(matricule).then(
          (resp) async {
        //isDataProcessing(false);
        resp.forEach((data) async {
          var model = PNCValidationTraitementModel();
          model.nnc = data['nnc'];
          model.dateDetect = data['dateDetect'];
          model.produit = data['produit'];
          model.typeNC = data['typeNC'];
          model.qteDetect = data['qteDetect'];
          model.codePdt = data['codePdt'];
          model.nc = data['nc'];
          model.nomClt = data['nomClt'];
          //delete table
          await localPNCService.deleteTablePNCDecisionValidation();
          //save data
          await localPNCService.savePNCDecisionValidation(model);
          print(
              'Inserting data in table PNCDecisionValidation : ${model.nnc} - ${model.nc} ');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar("Error PNCDecisionTraitementAValidater",
            err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  //--------------------------------Reunion------------------------------------------
  //Reunion informer
  Future<void> getReunionInformer() async {
    try {
      isDataProcessing(true);

      //rest api
      ReunionService().getReunionInformer(matricule).then((resp) async {
        //isDataProcessing(false);
        resp.forEach((data) async {
          var model = ReunionModel();
          model.nReunion = data['nReunion'];
          model.typeReunion = data['typeReunion'];
          model.datePrev = data['datePrev'];
          model.heureDeb = data['heureDeb'];
          model.lieu = data['lieu'];
          //delete table
          await localReunionService.deleteTableReunionInformer();
          //save data
          await localReunionService.saveReunionInformer(model);
          print(
              'Inserting data in table ReunionInformer : ${model.nReunion} - ${model.typeReunion} ');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error ReunionInformer", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  //Reunion planifier
  Future<void> getReunionPlanifier() async {
    try {
      isDataProcessing(true);

      //rest api
      ReunionService().getReunionPlanifier(matricule).then((resp) async {
        //isDataProcessing(false);
        resp.forEach((data) async {
          var model = ReunionModel();
          model.nReunion = data['nReunion'];
          model.typeReunion = data['typeReunion'];
          model.datePrev = data['datePrev'];
          model.ordreJour = data['ordreJour'];
          model.heureDeb = data['heureDeb'];
          model.heureFin = data['heureFin'];
          model.lieu = data['lieu'];
          //delete table
          await localReunionService.deleteTableReunionPlanifier();
          //save data
          await localReunionService.saveReunionPlanifier(model);
          print(
              'Inserting data in table ReunionPlanifier : ${model.nReunion} - ${model.typeReunion} ');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error ReunionPlanifier", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  //--------------------------------Incident Environnement------------------------------------------
  //decision traitement
  Future<void> getIncidentEnvDecisionTraitement() async {
    try {
      isDataProcessing(true);

      //rest api
      IncidentEnvironnementService()
          .getListIncidentEnvDecisionTraitement(matricule)
          .then((resp) async {
        //isDataProcessing(false);
        resp.forEach((data) async {
          var model = IncidentEnvAgendaModel();
          model.nIncident = data['nIncident'];
          model.incident = data['incident'];
          model.dateDetect = data['date_detect'];
          //delete table
          await localIncidentEnvironnementService
              .deleteTableIncidentEnvDecisionTraitement();
          //save data
          await localIncidentEnvironnementService
              .saveIncidentEnvDecisionTraitement(model);
          print(
              'Inserting data in table IncidentEnvDecisionTraitement : ${model.nIncident} - ${model.incident} ');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error IncidentEnvDecisionTraitement", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  //incident env a traiter
  Future<void> getIncidentEnvATraiter() async {
    try {
      isDataProcessing(true);

      //rest api
      IncidentEnvironnementService().getListIncidentEnvATraiter(matricule).then(
          (resp) async {
        //isDataProcessing(false);
        resp.forEach((data) async {
          var model = IncidentEnvAgendaModel();
          model.nIncident = data['nIncident'];
          model.incident = data['incident'];
          model.dateDetect = data['date_detect'];
          //delete table
          await localIncidentEnvironnementService
              .deleteTableIncidentEnvATraiter();
          //save data
          await localIncidentEnvironnementService
              .saveIncidentEnvATraiter(model);
          print(
              'Inserting data in table IncidentEnvATraiter : ${model.nIncident} - ${model.incident} ');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error IncidentEnvATraiter", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  //incident env a cloturer
  Future<void> getIncidentEnvACloturer() async {
    try {
      isDataProcessing(true);
      //rest api
      IncidentEnvironnementService()
          .getListIncidentEnvACloturer(matricule)
          .then((resp) async {
        //isDataProcessing(false);
        resp.forEach((data) async {
          var model = IncidentEnvAgendaModel();
          model.nIncident = data['nIncident'];
          model.incident = data['incident'];
          model.dateDetect = data['date_detect'];
          //delete table
          await localIncidentEnvironnementService
              .deleteTableIncidentEnvACloturer();
          //save data
          await localIncidentEnvironnementService
              .saveIncidentEnvACloturer(model);
          print(
              'Inserting data in table IncidentEnvACloturer : ${model.nIncident} - ${model.incident} ');
        });
      }, onError: (err) {
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error IncidentEnvACloturer", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  //----------------incident securite---------------
  Future<void> getIncidentSecuriteDecisionTraitement() async {
    try {
      isDataProcessing(true);
      await IncidentSecuriteService()
          .getListIncidentSecuriteDecisionTraitement(matricule)
          .then((response) async {
        response.forEach((data) async {
          var model = IncidentSecuriteAgendaModel();
          model.ref = data['ref'];
          model.designation = data['designation'];
          model.dateInc = data['date_inc'];
          //delete table
          await localIncidentSecuriteService
              .deleteTableIncidentSecuriteDecisionTraitement();
          //save data
          await localIncidentSecuriteService
              .saveIncidentSecuriteDecisionTraitement(model);
          print(
              'Inserting data in table IncidentSecuriteDecisionTraitement : ${model.ref} - ${model.designation} ');
        });
      }, onError: (error) {
        isDataProcessing(false);
        ShowSnackBar.snackBar("Error IncidentSecuriteDecisionTraitement",
            error.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getIncidentSecuriteATraiter() async {
    try {
      isDataProcessing(true);
      await IncidentSecuriteService()
          .getListIncidentSecuriteATraiter(matricule)
          .then((response) async {
        response.forEach((data) async {
          var model = IncidentSecuriteAgendaModel();
          model.ref = data['ref'];
          model.designation = data['designation'];
          model.dateInc = data['date_inc'];
          //delete table
          await localIncidentSecuriteService
              .deleteTableIncidentSecuriteATraiter();
          //save data
          await localIncidentSecuriteService
              .saveIncidentSecuriteATraiter(model);
          print(
              'Inserting data in table IncidentSecuriteATraiter : ${model.ref} - ${model.designation} ');
        });
      }, onError: (error) {
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error IncidentSecuriteATraiter", error.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception IncidentSecuriteATraiter",
          exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getIncidentSecuriteACloturer() async {
    try {
      isDataProcessing(true);
      await IncidentSecuriteService()
          .getListIncidentSecuriteACloturer(matricule)
          .then((response) async {
        response.forEach((data) async {
          var model = IncidentSecuriteAgendaModel();
          model.ref = data['ref'];
          model.designation = data['designation'];
          model.dateInc = data['date_inc'];
          //delete table
          await localIncidentSecuriteService
              .deleteTableIncidentSecuriteACloturer();
          //save data
          await localIncidentSecuriteService
              .saveIncidentSecuriteACloturer(model);
          print(
              'Inserting data in table IncidentSecuriteACloturer : ${model.ref} - ${model.designation} ');
        });
      }, onError: (error) {
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error IncidentSecuriteACloturer", error.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception IncidentSecuriteACloturer",
          exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  //-------------Audit---------------------
  Future<void> getAuditEnTantQueAudite() async {
    try {
      isDataProcessing(true);
      await AuditService().getAuditsEnTantQueAudite().then((response) async {
        response.forEach((element) async {
          var model = new AuditModel();
          model.idAudit = element['idAudit'];
          model.refAudit = element['refAudit'];
          model.champ = element['champ'];
          model.dateDebPrev = element['dateDebPrev'];
          model.interne = element['interne'];
          //delete table
          await localAuditService.deleteTableAuditAudite();
          //save data
          await localAuditService.saveAuditAudite(model);
          print(
              'Inserting data in table AuditAudite : ${model.idAudit} - ${model.champ} ');
        });
      }, onError: (error) {
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error AuditAudite", error.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar(
          "Exception AuditAudite", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getAuditEnTantQueAuditeur() async {
    try {
      isDataProcessing(true);
      await AuditService().getAuditsEnTantQueAuditeur().then((response) async {
        response.forEach((element) async {
          var model = new AuditModel();
          model.idAudit = element['idAudit'];
          model.refAudit = element['refAudit'];
          model.champ = element['champ'];
          model.dateDebPrev = element['dateDebPrev'];
          model.interne = element['interne'];
          //delete table
          await localAuditService.deleteTableAuditAuditeur();
          //save data
          await localAuditService.saveAuditAuditeur(model);
          print(
              'Inserting data in table AuditAuditeur : ${model.idAudit} - ${model.champ} ');
        });
      }, onError: (error) {
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error AuditAuditeur", error.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar(
          "Exception AuditAuditeur", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> getRapportAuditsAValider() async {
    try {
      isDataProcessing(true);
      await AuditService().getRapportAuditsAValider().then((response) async {
        response.forEach((element) async {
          var model = new AuditModel();
          model.idAudit = element['idAudit'];
          model.refAudit = element['refAudit'];
          model.champ = element['champ'];
          model.typeA = element['typeA'];
          model.interne = element['interne'];
          //delete table
          await localAuditService.deleteTableRapportAuditAValider();
          //save data
          await localAuditService.saveRapportAuditAValider(model);
          print(
              'Inserting data in table RapportAuditAValider : ${model.idAudit} - ${model.champ} ');
        });
      }, onError: (error) {
        isDataProcessing(false);
        ShowSnackBar.snackBar(
            "Error AuditAudite", error.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar(
          "Exception AuditAudite", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }
}
