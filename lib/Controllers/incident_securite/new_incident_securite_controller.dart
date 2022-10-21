import 'dart:typed_data';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qualipro_flutter/Models/category_model.dart';
import 'package:qualipro_flutter/Models/incident_environnement/type_consequence_incident_model.dart';
import 'package:qualipro_flutter/Models/incident_securite/cause_typique_model.dart';
import 'package:qualipro_flutter/Models/incident_securite/evenement_declencheur_model.dart';
import 'package:qualipro_flutter/Models/incident_securite/poste_travail_model.dart';
import 'package:qualipro_flutter/Models/incident_securite/site_lesion_model.dart';
import 'package:qualipro_flutter/Models/secteur_model.dart';
import 'package:qualipro_flutter/Models/type_consequence_model.dart';
import 'package:qualipro_flutter/Services/action/local_action_service.dart';
import 'package:qualipro_flutter/Services/incident_securite/incident_securite_service.dart';
import '../../Models/Domaine_affectation_model.dart';
import '../../Models/activity_model.dart';
import '../../Models/champ_cache_model.dart';
import '../../Models/direction_model.dart';
import '../../Models/employe_model.dart';
import '../../Models/gravite_model.dart';
import '../../Models/incident_environnement/cout_estime_inc_env_model.dart';
import '../../Models/incident_environnement/source_inc_env_model.dart';
import '../../Models/incident_environnement/type_cause_incident_model.dart';
import '../../Models/incident_securite/champ_obligatore_incident_securite_model.dart';
import '../../Models/incident_securite/incident_securite_model.dart';
import '../../Models/pnc/champ_obligatoire_pnc_model.dart';
import '../../Models/processus_model.dart';
import '../../Models/service_model.dart';
import '../../Models/site_model.dart';
import '../../Models/type_cause_model.dart';
import '../../Models/type_incident_model.dart';
import '../../Services/api_services_call.dart';
import '../../Services/incident_securite/local_incident_securite_service.dart';
import '../../Utils/message.dart';
import '../../Utils/shared_preference.dart';
import '../../Utils/snack_bar.dart';
import 'incident_securite_controller.dart';

class NewIncidentSecuriteController extends GetxController {

  var isDataProcessing = false.obs;
  var isVisibleNewIncident = true.obs;
  LocalActionService localActionService = LocalActionService();
  //LocalReunionService localReunionService = LocalReunionService();
  //LocalIncidentEnvironnementService localIncidentEnvironnementService = LocalIncidentEnvironnementService();
  LocalIncidentSecuriteService localIncidentSecuriteService = LocalIncidentSecuriteService();
  final matricule = SharedPreference.getMatricule();

  final addItemFormKey = GlobalKey<FormState>();
  late TextEditingController dateIncidentController, dateEntreController,
      designationController, numInterneController, heureIncidentController,
      nombreJourController, descriptionIncidentController, descriptionCauseController, 
      descriptionConsequenceController, actionImmediateController;
  DateTime dateNow = DateTime.now();
  DateTime datePickerIncident = DateTime.now();
  DateTime datePickerEntre = DateTime.now();
  TimeOfDay timeDebut = TimeOfDay(hour: 10, minute: 00);
  dynamic currentTime = DateFormat('kk:mm').format(DateTime.now());

  //type
  TypeIncidentModel? typeIncidentModel = null;
  int? selectedCodeTypeIncident = 0;
  String? typeIncident = "";
  //category
  CategoryModel? categoryModel = null;
  int? selectedCodeCategory = 0;
  String? categoryIncident = "";
  //lieu
  PosteTravailModel? posteTravailModel = null;
  String? selectedCodePoste = "";
  String? posteIncident = "";
  //secteur
  SecteurModel? secteurModel = null;
  String? selectedCodeSecteur = "";
  String? secteurIncident = "";
  //source
  SourceIncidentEnvModel? sourceModel = null;
  int? selectedCodeSource = 0;
  String? sourceIncident = "";
  //cout esteme
  CoutEstimeIncidentEnvModel? coutEstemeModel = null;
  int? selectedCodeCoutEsteme = 0;
  String? coutEstemeIncident = "";
  //gravite
  GraviteModel? graviteModel = null;
  int? selectedCodeGravite = 0;
  String? graviteIncident = "";
  //evenement declencheur
  EvenementDeclencheurModel? evenementDeclencheurModel = null;
  int? selectedCodeEvenementDeclencheur = 0;
  String? evenementDeclencheurIncident = "";
  //employe
  EmployeModel? employeModel = null;
  EmployeModel? detectedEmployeModel = null;
  String? origineEmployeMatricule = "";
  String? detectedEmployeMatricule = "";
  //site
  var site_visible = 0.obs;
  late bool isVisibileSite;
  var site_obligatoire = 0.obs;
  SiteModel? siteModel = null;
  int? selectedCodeSite = 0;
  String? siteIncident = "";
  //processus
  var processus_visible = 0.obs;
  late bool isVisibileProcessus;
  var processus_obligatoire = 0.obs;
  ProcessusModel? processusModel = null;
  int? selectedCodeProcessus = 0;
  String? processusIncident = "";
  //activity
  var activity_visible = 0.obs;
  late bool isVisibileActivity;
  var activity_obligatoire = 0.obs;
  ActivityModel? activityModel = null;
  int? selectedCodeActivity = 0;
  String? activityIncident = "";
  //direction
  var direction_visible = 0.obs;
  late bool isVisibileDirection;
  var direction_obligatoire = 0.obs;
  DirectionModel? directionModel = null;
  int? selectedCodeDirection = 0;
  String? directionIncident = "";
  //service
  var service_visible = 0.obs;
  late bool isVisibileService;
  var service_obligatoire = 0.obs;
  ServiceModel? serviceModel = null;
  int? selectedCodeService = 0;
  String? serviceIncident = "";
  //types cause
  List<int> typeCauseList = [];
  List<TypeCauseIncidentModel> listTypeCauseIncSec = [];
  //cause typique
  List<int> causeTypiqueList = [];
  List<CauseTypiqueModel> listCausetypiqueincSec = List<CauseTypiqueModel>.empty(growable: true);
  //type consequence
  List<int> typeConsequenceList = [];
  List<TypeConsequenceIncidentModel> listTypeConsequenceIncSec = [];
  //site lesion
  List<int> siteLesionList = [];
  List<SiteLesionModel> listSiteLesionIncSec = List<SiteLesionModel>.empty(growable: true);
  //isps
  String? isps = "0";
  //week
  int? week = 0;
  var currentWeek = 1.obs;

  //domaine affectation
  getDomaineAffectation() async {
    List<DomaineAffectationModel> domaineList = await List<
        DomaineAffectationModel>.empty(growable: true);
    var connection = await Connectivity().checkConnectivity();
    if (connection == ConnectivityResult.none) {
      var response = await localActionService.readDomaineAffectationByModule(
          "Sécurité", "Incident");
      response.forEach((data) {
        var model = DomaineAffectationModel();
        model.id = data['id'];
        model.module = data['module'];
        model.fiche = data['fiche'];
        model.vSite = data['vSite'];
        model.oSite = data['oSite'];
        model.rSite = data['rSite'];
        model.vProcessus = data['vProcessus'];
        model.oProcessus = data['oProcessus'];
        model.rProcessus = data['rProcessus'];
        model.vDomaine = data['vDomaine'];
        model.oDomaine = data['oDomaine'];
        model.rDomaine = data['rDomaine'];
        model.vDirection = data['vDirection'];
        model.oDirection = data['oDirection'];
        model.rDirection = data['rDirection'];
        model.vService = data['vService'];
        model.oService = data['oService'];
        model.rService = data['rService'];
        model.vEmpSite = data['vEmpSite'];
        model.vEmpProcessus = data['vEmpProcessus'];
        model.vEmpDomaine = data['vEmpDomaine'];
        model.vEmpDirection = data['vEmpDirection'];
        model.vEmpService = data['vEmpService'];
        domaineList.add(model);

        site_visible.value = model.vSite!;
        processus_visible.value = model.vProcessus!;
        activity_visible.value = model.vDomaine!;
        direction_visible.value  = model.vDirection!;
        service_visible.value  = model.vService!;

        site_obligatoire.value = model.oSite!;
        processus_obligatoire.value  = model.oProcessus!;
        activity_obligatoire.value  = model.oDomaine!;
        direction_obligatoire.value  = model.oDirection!;
        service_obligatoire.value  = model.oService!;
        print('fiche: ${model.fiche}, site visible :${site_visible.value}, site obligatoire :${site_obligatoire.value}');
      });
    }
    else if (connection == ConnectivityResult.wifi ||
        connection == ConnectivityResult.mobile) {
      await ApiServicesCall().getDomaineAffectation().then((resp) async {
        resp.forEach((data) async {
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
          domaineList.add(model);
          if (model.module == "Sécurité" && model.fiche == "Incident") {
            site_visible.value = model.vSite!;
            processus_visible.value = model.vProcessus!;
            activity_visible.value = model.vDomaine!;
            direction_visible.value  = model.vDirection!;
            service_visible.value  = model.vService!;

            site_obligatoire.value = model.oSite!;
            processus_obligatoire.value  = model.oProcessus!;
            activity_obligatoire.value  = model.oDomaine!;
            direction_obligatoire.value  = model.oDirection!;
            service_obligatoire.value  = model.oService!;
            print('fiche: ${model
                .fiche}, site visible :${site_visible.value}, site obligatoire :${site_obligatoire.value}');
          }
        });
      }
          , onError: (err) {
            ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
          });
    }
  }

  //champ cache
  int? isps_visible = 1;
  int? type_incident_visible = 1;
  bool isVisibileTypeIncident = true;
  int? poste_visible = 1;
  bool isVisibilePoste = true;
  int? category_visible = 1;
  int? cout_esteme_visible = 1;
  int? date_entre_visible = 1;
  int? gravite_visible = 1;
  int? cause_typique_visible = 1;
  int? site_lesion_visible = 1;
  int? week_visible = 1;
  int? evenenement_declencheur_visible = 1;
  getChampCache() async {
    try {
      List<ChampCacheModel> listChampCache = await List<ChampCacheModel>.empty(
          growable: true);
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        var response = await localActionService.readChampCacheByModule(
            "Sécurité\\Maîtrise des risques", "Incident");
        response.forEach((data) {
          var model = ChampCacheModel();
          model.id = data['id'];
          model.module = data['module'];
          model.fiche = data['fiche'];
          model.listOrder = data['listOrder'];
          model.nomParam = data['nomParam'];
          model.visible = data['visible'];
          print('module : ${model.module}, nom_param:${model.nomParam}, visible:${model.visible}');
          listChampCache.add(model);

          if (model.nomParam == "ISPS" && model.module == "Sécurité\\Maîtrise des risques" && model.fiche == "Fiche incident sécurité") {
            isps_visible = model.visible;
          }
          else if (model.nomParam == "Type incident" && model.module == "Sécurité\\Maîtrise des risques" && model.fiche == "Incident (Personnes à informer automatiquement)") {
            type_incident_visible = model.visible;
            //type_incident_visible = 0;
          }
          else if (model.nomParam == "Poste de travail" && model.module == "Sécurité\\Maîtrise des risques" && model.fiche == "Fiche incident sécurité") {
            poste_visible = model.visible;
            //product_bloque_visible = 0;
          }
          else if (model.nomParam == "Catégorie" && model.module == "Sécurité\\Maîtrise des risques" && model.fiche == "Fiche incident sécurité") {
            category_visible = model.visible;
          }
          else if (model.nomParam == "Date d'entrée" && model.module == "Sécurité\\Maîtrise des risques" && model.fiche == "Fiche incident sécurité") {
            date_entre_visible = model.visible;
          }
          else if (model.nomParam == "Gravité" && model.module == "Sécurité\\Maîtrise des risques" && model.fiche == "Fiche incident sécurité") {
            gravite_visible = model.visible;
          }
          else if (model.nomParam == "Coût estimé" && model.module == "Sécurité\\Maîtrise des risques" && model.fiche == "Fiche incident sécurité") {
            cout_esteme_visible = model.visible;
          }
          else if (model.nomParam == "Causes typiques" && model.module == "Sécurité\\Maîtrise des risques" && model.fiche == "Fiche incident sécurité") {
            cause_typique_visible = model.visible;
          }
          else if (model.nomParam == "Site de lésion" && model.module == "Sécurité\\Maîtrise des risques" && model.fiche == "Fiche incident sécurité") {
            site_lesion_visible = model.visible;
          }
          else if (model.nomParam == "Semaine" && model.module == "Sécurité\\Maîtrise des risques" && model.fiche == "Fiche incident sécurité") {
            week_visible = model.visible;
          }
          else if (model.nomParam == "Evènement déclencheur" && model.module == "Sécurité\\Maîtrise des risques" && model.fiche == "Fiche incident sécurité") {
            evenenement_declencheur_visible = model.visible;
          }
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        await ApiServicesCall().getChampCache({
          "module": "Sécurité\\Maîtrise des risques",
          "fiche": "Incident"
        }).then((resp) async {
          resp.forEach((data) async {
            //print('get champ obligatoire : ${data} ');
            var model = ChampCacheModel();
            model.id = data['id'];
            model.module = data['module'];
            model.fiche = data['fiche'];
            model.listOrder = data['list_order'];
            model.nomParam = data['nom_param'];
            model.visible = data['visible'];
            print('module : ${model.module}, nom_param:${model.nomParam}, visible:${model.visible}');
            listChampCache.add(model);

            if (model.nomParam == "ISPS" && model.module == "Sécurité\\Maîtrise des risques" && model.fiche == "Fiche incident sécurité") {
              isps_visible = model.visible;
            }
            else if (model.nomParam == "Type incident" && model.module == "Sécurité\\Maîtrise des risques" && model.fiche == "Incident (Personnes à informer automatiquement)") {
              type_incident_visible = model.visible;
              //type_incident_visible = 0;
            }
            else if (model.nomParam == "Poste de travail" && model.module == "Sécurité\\Maîtrise des risques" && model.fiche == "Fiche incident sécurité") {
              poste_visible = model.visible;
              //print('poste_visible : $poste_visible');
              //product_bloque_visible = 0;
            }
            else if (model.nomParam == "Catégorie" && model.module == "Sécurité\\Maîtrise des risques" && model.fiche == "Fiche incident sécurité") {
              category_visible = model.visible;
            }
            else if (model.nomParam == "Date d'entrée" && model.module == "Sécurité\\Maîtrise des risques" && model.fiche == "Fiche incident sécurité") {
              date_entre_visible = model.visible;
            }
            else if (model.nomParam == "Gravité" && model.module == "Sécurité\\Maîtrise des risques" && model.fiche == "Fiche incident sécurité") {
              gravite_visible = model.visible;
            }
            else if (model.nomParam == "Coût estimé" && model.module == "Sécurité\\Maîtrise des risques" && model.fiche == "Fiche incident sécurité") {
              cout_esteme_visible = model.visible;
            }
            else if (model.nomParam == "Causes typiques" && model.module == "Sécurité\\Maîtrise des risques" && model.fiche == "Fiche incident sécurité") {
              cause_typique_visible = model.visible;
            }
            else if (model.nomParam == "Site de lésion" && model.module == "Sécurité\\Maîtrise des risques" && model.fiche == "Fiche incident sécurité") {
              site_lesion_visible = model.visible;
            }
            else if (model.nomParam == "Semaine" && model.module == "Sécurité\\Maîtrise des risques" && model.fiche == "Fiche incident sécurité") {
              week_visible = model.visible;
            }
            else if (model.nomParam == "Evènement déclencheur" && model.module == "Sécurité\\Maîtrise des risques" && model.fiche == "Fiche incident sécurité") {
              evenenement_declencheur_visible = model.visible;
            }
          });
        }
            , onError: (err) {
              isDataProcessing(false);
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });
      }
    }
    catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    }
  }

  //champ obligatoire
  var category_obligatoire = 0.obs;
  var type_consequence_obligatoire = 0.obs;
  var type_cause_obligatoire = 0.obs;
  var poste_travail_obligatoire = 0.obs;
  var designation_incident_obligatoire = 0.obs;
  var nombre_jour_incident_obligatoire = 0.obs;
  var cause_typique_incident_obligatoire = 0.obs;
  var site_lesion_obligatoire = 0.obs;
  var type_incident_obligatoire = 1.obs;
  var date_incident_obligatoire = 0.obs;
  var action_immediate_obligatoire = 0.obs;
  var gravite_obligatoire = 0.obs;
  var secteur_obligatoire = 0.obs;
  var evenement_declencheur_obligatoire = 0.obs;
  var description_incident_obligatoire = 0.obs;
  var description_cause_obligatoire = 0.obs;
  var description_consequence_obligatoire = 0.obs;
  getChampObligatoire() async {
    List<ChampObligatoirePNCModel> champObligatoireList = await List<
        ChampObligatoirePNCModel>.empty(growable: true);
    var connection = await Connectivity().checkConnectivity();
    if (connection == ConnectivityResult.none) {
      var response = await localIncidentSecuriteService.readChampObligatoireIncidentSecurite();
      response.forEach((data) {
        var model = ChampObligatoireIncidentSecuriteModel();
        model.incidentGrav = data['incidentGrav'];
        model.incidentCat = data['incidentCat'];
        model.incidentTypeCons = data['incidentTypeCons'];
        model.incidentTypeCause = data['incidentTypeCause'];
        model.incidentPostet = data['incidentPostet'];
        model.incidentSecteur = data['incidentSecteur'];
        model.incidentDescInc = data['incidentDescInc'];
        model.incidentDescCons = data['incidentDescCons'];
        model.incidentDescCause = data['incidentDescCause'];
        model.incidentAct = data['incidentAct'];
        model.incidentNbrj = data['incidentNbrj'];
        model.incidentDesig = data['incidentDesig'];
        model.incidentClot = data['incidentClot'];
        model.risqueClot = data['risqueClot'];
        model.incidentSemaine = data['incidentSemaine'];
        model.incidentSiteLesion = data['incidentSiteLesion'];
        model.incidentCauseTypique = data['incidentCauseTypique'];
        model.incidentEventDeclencheur = data['incidentEventDeclencheur'];
        model.dateVisite = data['dateVisite'];
        model.comportementsObserve = data['comportementsObserve'];
        model.comportementRisquesObserves = data['comportementRisquesObserves'];
        model.correctionsImmediates = data['correctionsImmediates'];

        category_obligatoire.value = model.incidentCat!;
        type_consequence_obligatoire.value = model.incidentTypeCons!;
        type_cause_obligatoire.value = model.incidentTypeCause!;
        cause_typique_incident_obligatoire.value = model.incidentCauseTypique!;
        site_lesion_obligatoire.value = model.incidentSiteLesion!;
        poste_travail_obligatoire.value = model.incidentPostet!;
        designation_incident_obligatoire.value = model.incidentDesig!;
        //type_incident_obligatoire.value = model.typeIncident!;
        nombre_jour_incident_obligatoire.value = model.incidentNbrj!;
        date_incident_obligatoire.value = model.dateVisite!;
        description_incident_obligatoire.value = model.incidentDescInc!;
        description_cause_obligatoire.value = model.incidentDescCause!;
        description_consequence_obligatoire.value = model.incidentDescCons!;
        action_immediate_obligatoire.value = model.incidentAct!; //model.correctionsImmediates
        gravite_obligatoire.value = model.incidentGrav!;
        secteur_obligatoire.value = model.incidentSecteur!;
        evenement_declencheur_obligatoire.value = model.incidentEventDeclencheur!;
        print('champ obligatoire incident : ${data}');
      });
    }
    else if (connection == ConnectivityResult.wifi ||
        connection == ConnectivityResult.mobile) {
      await IncidentSecuriteService().getChampObligatoireIncidentSecurite().then((data) async {
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
        model.comportementRisquesObserves = data['comportement_risques_observes'];
        model.correctionsImmediates = data['corrections_immediates'];

        category_obligatoire.value = model.incidentCat!;
        type_consequence_obligatoire.value = model.incidentTypeCons!;
        type_cause_obligatoire.value = model.incidentTypeCause!;
        cause_typique_incident_obligatoire.value = model.incidentCauseTypique!;
        site_lesion_obligatoire.value = model.incidentSiteLesion!;
        poste_travail_obligatoire.value = model.incidentPostet!;
        designation_incident_obligatoire.value = model.incidentDesig!;
        //type_incident_obligatoire.value = model.typeIncident!;
        nombre_jour_incident_obligatoire.value = model.incidentNbrj!;
        date_incident_obligatoire.value = model.dateVisite!;
        description_incident_obligatoire.value = model.incidentDescInc!;
        description_cause_obligatoire.value = model.incidentDescCause!;
        description_consequence_obligatoire.value = model.incidentDescCons!;
        action_immediate_obligatoire.value = model.incidentAct!; //model.correctionsImmediates
        gravite_obligatoire.value = model.incidentGrav!;
        secteur_obligatoire.value = model.incidentSecteur!;
        evenement_declencheur_obligatoire.value = model.incidentEventDeclencheur!;
        print('champ obligatoire incident : ${data}');
      }
          , onError: (err) {
            ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
          });
    }
  }

  bool _dataValidation() {

    if (designationController.text.trim() == '' && designation_incident_obligatoire.value == 1) {
      Message.taskErrorOrWarning("Warning", "Designation incident is required");
      return false;
    }
     else if (typeIncidentModel == null && type_incident_obligatoire.value == 1 && type_incident_visible == 1) {
    Message.taskErrorOrWarning("Warning", "Type is required");
    return false;
    }
    else if (categoryModel == null && category_obligatoire.value == 1 && category_visible == 1) {
      Message.taskErrorOrWarning("Warning", "Category is required");
      return false;
    }
    else if (posteTravailModel == null && poste_travail_obligatoire.value == 1 && poste_visible == 1) {
      Message.taskErrorOrWarning("Warning", "Poste is required");
      return false;
    }
    else if (dateIncidentController.text.trim() == '' && date_incident_obligatoire.value == 1) {
      Message.taskErrorOrWarning("Warning", "Date Incident is required");
      return false;
    }
    if (nombreJourController.text.trim() == '' && nombre_jour_incident_obligatoire.value == 1) {
      Message.taskErrorOrWarning("Warning", "Nombre Jour is required");
      return false;
    }
    else if (secteurModel == null && secteur_obligatoire.value == 1) {
      Message.taskErrorOrWarning("Warning", "Secteur is required");
      return false;
    }
    else if (graviteModel == null && gravite_obligatoire.value == 1 && gravite_visible == 1) {
      Message.taskErrorOrWarning("Warning", "Gravite is required");
      return false;
    }else if (evenementDeclencheurModel == null && evenement_declencheur_obligatoire.value == 1 && evenenement_declencheur_visible == 1) {
      Message.taskErrorOrWarning("Warning", "Evenement Declencheur is required");
      return false;
    }
    else if (site_visible.value == 1 && site_obligatoire.value == 1 && siteModel == null) {
      Message.taskErrorOrWarning("Warning", "Site is required");
      return false;
    }
    else if (processus_visible.value == 1 && processus_obligatoire.value == 1 && processusModel == null) {
      Message.taskErrorOrWarning("Warning", "Processus is required");
      return false;
    }
    else if (direction_visible.value == 1 && direction_obligatoire.value == 1 &&
        directionModel == null) {
      Message.taskErrorOrWarning("Warning", "Direction is required");
      return false;
    }
    else if (service_visible.value == 1 && service_obligatoire.value == 1 &&
        serviceModel == null) {
      Message.taskErrorOrWarning("Warning", "Service is required");
      return false;
    }
    else if (activity_visible.value == 1 && activity_obligatoire.value == 1 &&
        activityModel == null) {
      Message.taskErrorOrWarning("Warning", "Activity is required");
      return false;
    }
    else if ((typeCauseList == null || typeCauseList == [] || typeCauseList.isEmpty) && type_cause_obligatoire.value == 1) {
      Message.taskErrorOrWarning("Warning", "Type Cause is required");
      return false;
    }
    else if ((causeTypiqueList == null || causeTypiqueList == [] || causeTypiqueList.isEmpty) && cause_typique_incident_obligatoire.value == 1 && cause_typique_visible == 1) {
      Message.taskErrorOrWarning("Warning", "Cause Typique is required");
      return false;
    }
    else if ((typeConsequenceList == null || typeConsequenceList == [] || typeConsequenceList.isEmpty) && type_consequence_obligatoire.value == 1) {
      Message.taskErrorOrWarning("Warning", "Type Consequence is required");
      return false;
    }
    else if ((siteLesionList == null || siteLesionList == [] || siteLesionList.isEmpty) && site_lesion_obligatoire.value == 1 && site_lesion_visible == 1) {
      Message.taskErrorOrWarning("Warning", "Site lesion is required");
      return false;
    }
    else if (descriptionIncidentController.text.trim() == '' && description_incident_obligatoire.value == 1) {
      Message.taskErrorOrWarning("Warning", "Description incident is required");
      return false;
    }
    else if (descriptionCauseController.text.trim() == '' && description_cause_obligatoire.value == 1) {
      Message.taskErrorOrWarning("Warning", "Description cause is required");
      return false;
    }
    else if (descriptionConsequenceController.text.trim() == '' && description_consequence_obligatoire.value == 1) {
      Message.taskErrorOrWarning("Warning", "Description consequence is required");
      return false;
    }
    else if (actionImmediateController.text.trim() == '' && action_immediate_obligatoire.value == 1) {
      Message.taskErrorOrWarning("Warning", "Action Immediate is required");
      return false;
    }
    else if(nombreJourController.text.trim() == ''){
      nombreJourController.text = '0';
    }
    return true;
  }

  weekOfYear(){
    // get today's date
    var now = datePickerIncident;
    //var now = new DateTime.now();
    // set it to feb 10th for testing
    //now = now.add(new Duration(days:7));
    int today = now.weekday;
    // ISO week date weeks start on monday
    // so correct the day number
    var dayNr = (today + 6) % 7;
    // ISO 8601 states that week 1 is the week
    // with the first thursday of that year.
    // Set the target date to the thursday in the target week
    var thisMonday = now.subtract(new Duration(days:(dayNr)));
    var thisThursday = thisMonday.add(new Duration(days:3));

    // Set the target to the first thursday of the year
    // First set the target to january first
    var firstThursday = new DateTime(now.year, DateTime.january, 1);

    if(firstThursday.weekday != (DateTime.thursday))
    {
      firstThursday = new DateTime(now.year, DateTime.january, 1 + ((4 - firstThursday.weekday) + 7) % 7);
    }

    // The weeknumber is the number of weeks between the
    // first thursday of the year and the thursday in the target week
    var x = thisThursday.millisecondsSinceEpoch - firstThursday.millisecondsSinceEpoch;
    var weekNumber = x.ceil() / 604800000; // 604800000 = 7 * 24 * 3600 * 1000
    currentWeek.value = weekNumber.ceil();

   /* print("Todays date: ${now}");
    print("Monday of this week: ${thisMonday}");
    print("Thursday of this week: ${thisThursday}");
    print("First Thursday of this year: ${firstThursday}");
    print("current week : ${currentWeek}"); */
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    designationController = TextEditingController();
    numInterneController = TextEditingController();
    descriptionIncidentController = TextEditingController();
    descriptionCauseController = TextEditingController();
    descriptionConsequenceController = TextEditingController();
    actionImmediateController = TextEditingController();
    dateIncidentController = TextEditingController();
    dateEntreController = TextEditingController();
    heureIncidentController = TextEditingController();
    nombreJourController = TextEditingController();
    dateIncidentController.text = DateFormat('yyyy-MM-dd').format(datePickerIncident);
    dateEntreController.text = DateFormat('yyyy-MM-dd').format(datePickerEntre);
    heureIncidentController.text = currentTime.toString();

    getDomaineAffectation();
    getChampCache();
    getChampObligatoire();
    checkConnectivity();

    weekOfYear();
  }


  Future<void> checkConnectivity() async {
    var connection = await Connectivity().checkConnectivity();
    if (connection == ConnectivityResult.none) {
      Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue,
          snackPosition: SnackPosition.BOTTOM, duration: Duration(milliseconds: 900));
    }
    else if (connection == ConnectivityResult.wifi ||
        connection == ConnectivityResult.mobile) {
      Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue,
          snackPosition: SnackPosition.BOTTOM, duration: Duration(milliseconds: 900));
    }
  }

  selectedDateIncident(BuildContext context) async {
    datePickerIncident = (await showDatePicker(
        context: context,
        initialDate: datePickerIncident,
        firstDate: DateTime(2021),
        lastDate: DateTime(2100)
      //lastDate: DateTime.now()
    ))!;
    if (datePickerIncident != null) {
      dateIncidentController.text = DateFormat('yyyy-MM-dd').format(datePickerIncident);
      //dateIncidentController.text = DateFormat.yMMMMd().format(datePickerIncident);
    }
  }
  selectedDateEntre(BuildContext context) async {
    datePickerEntre = (await showDatePicker(
        context: context,
        initialDate: datePickerEntre,
        firstDate: DateTime(2021),
        lastDate: DateTime(2030)
    ))!;
    if (datePickerEntre != null) {
      dateEntreController.text = DateFormat('yyyy-MM-dd').format(datePickerEntre);
    }
  }
  //final hours = timeDebut.hour.toString().padLeft(2, '0');
  selectedTimeDebut(BuildContext context) async {
    timeDebut = (await showTimePicker(
        context: context,
        initialTime:timeDebut
    ))!;
    if(timeDebut == null) return;
    if (timeDebut != null) {
      heureIncidentController.text = '${timeDebut.hour}:${timeDebut.minute}';
    }
  }


  Future saveBtn() async {
    if(_dataValidation() && addItemFormKey.currentState!.validate()){
      try {
        var connection = await Connectivity().checkConnectivity();
        if (connection == ConnectivityResult.none) {
          int max_num_incident = await localIncidentSecuriteService.getMaxNumIncidentSecurite();
          Uint8List? bytesTypeCause = Uint8List.fromList(typeCauseList);
          Uint8List? bytesTypeConsequence = Uint8List.fromList(typeConsequenceList);
          Uint8List? bytesCauseTypique = Uint8List.fromList(causeTypiqueList);
          Uint8List? bytesSiteLesion = Uint8List.fromList(siteLesionList);
          var model = IncidentSecuriteModel();
          model.online = 0;
          model.statut = 1;
          model.ref = max_num_incident+1;
          model.typeIncident = typeIncident;
          model.site = siteIncident;
          model.dateInc = dateIncidentController.text;
          model.contract = "";
          model.designation = designationController.text;
          model.gravite = graviteIncident;
          model.categorie = categoryIncident;
          model.typeConsequence = "";
          model.typeCause = "";
          model.secteur = secteurIncident;
          model.dateCreation = dateEntreController.text;
          model.detectedEmployeMatricule = detectedEmployeMatricule;
          model.codeType = selectedCodeTypeIncident.toString();
          model.codePoste = selectedCodePoste.toString();
          model.codeGravite = selectedCodeGravite.toString();
          model.codeCategory = selectedCodeCategory.toString();
          model.codeSecteur = selectedCodeSecteur;
          model.codeEvenementDeclencheur = selectedCodeEvenementDeclencheur.toString();
          model.heure = heureIncidentController.text;
          model.codeCoutEsteme = selectedCodeCoutEsteme;
          model.codeSite = selectedCodeSite;
          model.codeProcessus = selectedCodeProcessus;
          model.codeDirection = selectedCodeDirection;
          model.codeService = selectedCodeService;
          model.codeActivity = selectedCodeActivity;
          model.descriptionIncident = descriptionIncidentController.text;
          model.descriptionConsequence = descriptionConsequenceController.text;
          model.descriptionCause = descriptionCauseController.text;
          model.actionImmediate = actionImmediateController.text;
          model.nombreJour = int.parse(nombreJourController.text);
          model.numInterne = numInterneController.text;
          model.isps = isps.toString();
          model.week = currentWeek.toString(); //week.toString();
          model.listTypeCause = bytesTypeCause;
          model.listTypeConsequence = bytesTypeConsequence;
          model.listCauseTypique = bytesCauseTypique;
          model.listSiteLesion = bytesSiteLesion;
          //save data sync
          await localIncidentSecuriteService.saveIncidentSecuriteSync(model);

          //save type cause in db local
          int max_id_inc_cause = await LocalIncidentSecuriteService().getMaxNumTypeCauseIncSecRattacher();
          listTypeCauseIncSec.forEach((element) async {
            var model = TypeCauseIncidentModel();
            model.online = 2;
            model.idIncident = max_num_incident+1;
            model.idIncidentCause = max_id_inc_cause+1;
            model.idTypeCause = element.idTypeCause;
            model.typeCause = element.typeCause;
            await LocalIncidentSecuriteService().saveTypeCauseIncSecRattacher(model);
          });
          //save type conseq in db local
          int max_id_inc_conseq = await LocalIncidentSecuriteService().getMaxNumTypeConsequenceIncSecRattacher();
          listTypeConsequenceIncSec.forEach((element) async {
            var model = TypeConsequenceIncidentModel();
            model.online = 2;
            model.idIncident = max_num_incident + 1;
            model.idIncidentConseq = max_id_inc_conseq + 1;
            model.idConsequence = element.idConsequence;
            model.typeConsequence = element.typeConsequence;
            await LocalIncidentSecuriteService().saveTypeConsequenceIncSecRattacher(model);
          });
          //save cause typique in db local
          int max_id_inc_cause_typique = await LocalIncidentSecuriteService().getMaxNumCauseTypiqueIncSecRattacher();
          listCausetypiqueincSec.forEach((element) async {
            var model = CauseTypiqueModel();
            model.online = 2;
            model.idIncidentCauseTypique = max_id_inc_cause_typique+1;
            model.causeTypique = element.causeTypique;
            model.idCauseTypique = element.idCauseTypique;
            model.idIncident = max_num_incident + 1;
            //save table in db local
            await LocalIncidentSecuriteService().saveCauseTypiqueIncSecRattacher(model);
          });
          //save site lesion in db local
          int max_inc_sitelesion = await LocalIncidentSecuriteService().getMaxNumSiteLesionIncSecRattacher();
          listSiteLesionIncSec.forEach((element) async {
            var model = SiteLesionModel();
            model.online = 2;
            model.idIncident = max_num_incident + 1;
            model.idIncCodeSiteLesion = max_inc_sitelesion + 1;
            model.codeSiteLesion = element.codeSiteLesion;
            model.siteLesion = element.siteLesion;
            await LocalIncidentSecuriteService().saveSiteLesionIncSecRattacher(model);
          });

          Get.back();
          ShowSnackBar.snackBar("Mode Offline", "Incident Added Successfully", Colors.green);
          Get.find<IncidentSecuriteController>().listIncident.clear();
          Get.find<IncidentSecuriteController>().getIncident();
          clearData();
        }
        else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
          await IncidentSecuriteService().saveIncident({
            "date_inc": dateIncidentController.text,
            "heure_inc": heureIncidentController.text,
            "type": selectedCodeTypeIncident.toString(),
            "poste": selectedCodePoste.toString(),
            "gravite": selectedCodeGravite.toString(),
            "categorie": selectedCodeCategory.toString(),
            "desc_inc": descriptionIncidentController.text,
            "desc_caus": descriptionCauseController.text,
            "designation": designationController.text,
            "desc_con": descriptionConsequenceController.text,
            "nom_jour": int.parse(nombreJourController.text),
            "actions_imm": actionImmediateController.text,
            "site": selectedCodeSite.toString(),
            "secteur": selectedCodeSecteur,
            "mat": matricule.toString(),
            "avec_regle": "",
            "id_process": selectedCodeProcessus,
            "id_domaine": selectedCodeActivity,
            "id_direction": selectedCodeDirection,
            "id_service": selectedCodeService,
            "matEnreg": matricule.toString(),
            "recep": detectedEmployeMatricule,
            "ninter": numInterneController.text,
            "isps": int.parse(isps.toString()),
            "cout_estime": selectedCodeCoutEsteme,
            "date_creat": dateEntreController.text,
            "semaine":  currentWeek.toString(), //week.toString(),
            "eventDeclencheur": selectedCodeEvenementDeclencheur.toString(),
            "typesCauses": typeCauseList,
            "typesConsequences": typeConsequenceList,
            "causesTypiques": causeTypiqueList,
            "sitesLesions": siteLesionList
          }).then((resp) {
            Get.back();
            Get.find<IncidentSecuriteController>().listIncident.clear();
            Get.find<IncidentSecuriteController>().getIncident();
            ShowSnackBar.snackBar("Successfully", "Incident Securite Added ", Colors.green);
            clearData();
          }, onError: (err) {
            isDataProcessing(false);
            print('Error : ${err.toString()}');
            ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
          });
      }
      }
      catch (ex){
        Get.defaultDialog(
            title: "Exception",
            backgroundColor: Colors.lightBlue,
            titleStyle: TextStyle(color: Colors.white),
            middleTextStyle: TextStyle(color: Colors.white),
            textConfirm: "Confirm",
            textCancel: "Cancel",
            cancelTextColor: Colors.white,
            confirmTextColor: Colors.white,
            buttonColor: Colors.red,
            barrierDismissible: false,
            radius: 50,
            content: Text('${ex.toString()}', style: TextStyle(color: Colors.black),)
        );
        //ShowSnackBar.snackBar("Exception", ex.toString(), Colors.red);
        print("throwing new error " + ex.toString());
        throw Exception("Error " + ex.toString());
      }
    }
  }

  clearData() {
    //onInit();
    designationController.clear();
    numInterneController.clear();
    nombreJourController.clear();
    descriptionIncidentController.clear();
    descriptionCauseController.clear();
    descriptionConsequenceController.clear();
    actionImmediateController.clear();
    dateIncidentController.text = DateFormat('yyyy-MM-dd').format(datePickerIncident);
    dateEntreController.text = DateFormat('yyyy-MM-dd').format(datePickerEntre);
    selectedCodeTypeIncident = 0;
    typeIncidentModel = null;
    categoryModel = null;
    selectedCodeCategory = 0;
    posteTravailModel = null;
    selectedCodePoste = "";
    detectedEmployeModel = null;
    detectedEmployeMatricule = "";
    employeModel = null;
    origineEmployeMatricule = "";
    sourceModel = null;
    selectedCodeSource = 0;
    secteurModel = null;
    selectedCodeSecteur = "";
    graviteModel = null;
    selectedCodeGravite = 0;
    coutEstemeModel = null;
    selectedCodeCoutEsteme = 0;
    siteModel = null;
    selectedCodeSite = 0;
    processusModel = null;
    selectedCodeProcessus = 0;
    directionModel = null;
    selectedCodeDirection = 0;
    serviceModel = null;
    selectedCodeService = 0;
    activityModel = null;
    selectedCodeActivity = 0;
    heureIncidentController.text = currentTime.toString();
    typeIncident = "";
    categoryIncident = "";
    posteIncident = "";
    secteurIncident = "";
    sourceIncident = "";
    graviteIncident = "";
    coutEstemeIncident = "";
    siteIncident = "";
    processusIncident = "";
    directionIncident = "";
    serviceIncident = "";
    activityIncident = "";
    typeCauseList = [];
    typeConsequenceList = [];
  }

  //type
  Widget customDropDownType(BuildContext context, TypeIncidentModel? item) {
    if (typeIncidentModel == null) {
      return Container();
    }
    else{
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${typeIncidentModel?.typeIncident}', style: TextStyle(color: Colors.black),),
        ),
      );
    }
  }
  Widget customPopupItemBuilderType(
      BuildContext context, typeIncidentModel, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: ListTile(
        selected: isSelected,
        title: Text(typeIncidentModel?.typeIncident ?? ''),
        subtitle: Text(typeIncidentModel?.idType.toString() ?? ''),
      ),
    );
  }
  //category
  Widget customDropDownCategory(BuildContext context, CategoryModel? item) {
    if (categoryModel == null) {
      return Container();
    }
    else{
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${categoryModel?.categorie}'),
        ),
      );
    }
  }
  Widget customPopupItemBuilderCategory(
      BuildContext context, categoryModel, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: ListTile(
        selected: isSelected,
        title: Text(categoryModel?.categorie ?? ''),
        //subtitle: Text(categoryModel?.idCategorie.toString() ?? ''),
      ),
    );
  }
  //poste de travail
  Widget customDropDownPoste(BuildContext context, PosteTravailModel? item) {
    if (posteTravailModel == null) {
      return Container();
    }
    else{
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${posteTravailModel?.poste}'),
        ),
      );
    }
  }
  Widget customPopupItemBuilderPoste(
      BuildContext context, posteTravailModel, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: ListTile(
        selected: isSelected,
        title: Text(posteTravailModel?.poste ?? ''),
        //subtitle: Text(posteTravailModel?.code.toString() ?? ''),
      ),
    );
  }
  //secteur
  Widget customDropDownSecteur(BuildContext context, SecteurModel? item) {
    if (secteurModel == null) {
      return Container();
    }
    else{
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${secteurModel?.secteur}'),
        ),
      );
    }
  }
  Widget customPopupItemBuilderSecteur(
      BuildContext context, secteurModel, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: ListTile(
        selected: isSelected,
        title: Text(secteurModel?.secteur ?? ''),
        //subtitle: Text(secteurModel?.code.toString() ?? ''),
      ),
    );
  }
  //gravite
  Widget customDropDownGravite(BuildContext context, GraviteModel? item) {
    if (graviteModel == null) {
      return Container();
    }
    else{
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${graviteModel?.gravite}'),
        ),
      );
    }
  }
  Widget customPopupItemBuilderGravite(
      BuildContext context, graviteModel, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: ListTile(
        selected: isSelected,
        title: Text(graviteModel?.gravite ?? ''),
        //subtitle: Text(graviteModel?.code.toString() ?? ''),
      ),
    );
  }
  //cout esteme
  Widget customDropDownCoutEsteme(BuildContext context, CoutEstimeIncidentEnvModel? item) {
    if (coutEstemeModel == null) {
      return Container();
    }
    else{
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${coutEstemeModel?.cout}'),
        ),
      );
    }
  }
  Widget customPopupItemBuilderCoutEsteme(
      BuildContext context, coutEstemeModel, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: ListTile(
        selected: isSelected,
        title: Text(coutEstemeModel?.cout ?? ''),
        //subtitle: Text(coutEstemeModel?.code.toString() ?? ''),
      ),
    );
  }
  //evenement declencheur
  Widget customDropDownEvenementDeclencheur(BuildContext context, EvenementDeclencheurModel? item) {
    if (evenementDeclencheurModel == null) {
      return Container();
    }
    else{
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${evenementDeclencheurModel?.event}'),
        ),
      );
    }
  }
  Widget customPopupItemBuilderEvenementDeclencheur(
      BuildContext context, evenementDeclencheurModel, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: ListTile(
        selected: isSelected,
        title: Text(evenementDeclencheurModel?.event ?? ''),
      ),
    );
  }
  //employe
  Widget customDropDownEmploye(BuildContext context, EmployeModel? item) {

    if (employeModel == null) {
      return Container();
    }
    else{
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${employeModel?.nompre}', style: TextStyle(color: Colors.black)),
        ),
      );
    }
  }
  Widget customPopupItemBuilderEmploye(
      BuildContext context, employeModel, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: ListTile(
        selected: isSelected,
        title: Text(employeModel?.nompre ?? ''),
        subtitle: Text(employeModel?.mat.toString() ?? ''),
      ),
    );
  }
  //detected by
  Widget customDropDownDetectedEmploye(BuildContext context, EmployeModel? item) {

    if (detectedEmployeModel == null) {
      return Container();
    }
    else{
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${detectedEmployeModel?.nompre}', style: TextStyle(color: Colors.black)),
        ),
      );
    }
  }
  Widget customPopupItemBuilderDetectedEmploye(
      BuildContext context, detectedEmployeModel, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: ListTile(
        selected: isSelected,
        title: Text(detectedEmployeModel?.nompre ?? ''),
        subtitle: Text(detectedEmployeModel?.mat.toString() ?? ''),
      ),
    );
  }
  //site
  Widget customDropDownSite(BuildContext context, SiteModel? item) {
    if (siteModel == null) {
      return Container();
    }
    else{
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${siteModel?.site}', style: TextStyle(color: Colors.black),),
        ),
      );
    }
  }
  Widget customPopupItemBuilderSite(
      BuildContext context, siteModel, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: ListTile(
        selected: isSelected,
        title: Text(siteModel?.site ?? ''),
        subtitle: Text(siteModel?.codesite.toString() ?? ''),
      ),
    );
  }
  //processus
  Widget customDropDownProcessus(BuildContext context, ProcessusModel? item) {
    if (processusModel == null) {
      return Container();
    }
    else{
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${processusModel?.processus}', style: TextStyle(color: Colors.black),),
        ),
      );
    }
  }
  Widget customPopupItemBuilderProcessus(
      BuildContext context, processusModel, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: ListTile(
        selected: isSelected,
        title: Text(processusModel?.processus ?? ''),
        subtitle: Text(processusModel?.codeProcessus.toString() ?? ''),
      ),
    );
  }
  //Activity
  Widget customDropDownActivity(BuildContext context, ActivityModel? item) {
    if (activityModel == null) {
      return Container();
    }
    else{
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${activityModel?.domaine}'),
        ),
      );
    }
  }
  Widget customPopupItemBuilderActivity(
      BuildContext context, activityModel, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: ListTile(
        selected: isSelected,
        title: Text(activityModel?.domaine ?? ''),
        subtitle: Text(activityModel?.codeDomaine.toString() ?? ''),
      ),
    );
  }
  //direction
  Widget customDropDownDirection(BuildContext context, DirectionModel? item) {
    if (directionModel == null) {
      return Container();
    }
    else{
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${directionModel?.direction}', style: TextStyle(color: Colors.black),),
        ),
      );
    }
  }
  Widget customPopupItemBuilderDirection(
      BuildContext context, directionModel, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: ListTile(
        selected: isSelected,
        title: Text(directionModel?.direction ?? ''),
        subtitle: Text(directionModel?.codeDirection.toString() ?? ''),
      ),
    );
  }
  //service
  Widget customDropDownService(BuildContext context, ServiceModel? item) {
    if (serviceModel == null) {
      return Container();
    }
    else{
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${serviceModel?.service}', style: TextStyle(color: Colors.black),),
        ),
      );
    }
  }
  Widget customPopupItemBuilderService(
      BuildContext context, serviceModel, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: ListTile(
        selected: isSelected,
        title: Text(serviceModel?.service ?? ''),
        subtitle: Text(serviceModel?.codeService.toString() ?? ''),
      ),
    );
  }
  //types causes
  Widget customDropDownMultiSelectionTypeCause(
      BuildContext context, List<TypeCauseIncidentModel?> selectedItems) {
    if (selectedItems.isEmpty) {
      return ListTile(
        contentPadding: EdgeInsets.all(0),
        //leading: CircleAvatar(),
        title: Text(""),
      );
    }

    return Wrap(
      children: selectedItems.map((e) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            child: ListTile(
              contentPadding: EdgeInsets.all(0),
              /* leading: CircleAvatar(
                // this does not work - throws 404 error
                // backgroundImage: NetworkImage(item.avatar ?? ''),
              ),
              subtitle: Text(
                e?.mat.toString() ?? '',
              ),*/
              title: Text(e?.typeCause ?? ''),

            ),
          ),
        );
      }).toList(),
    );
  }
  Widget customPopupItemBuilderTypeCause(
      BuildContext context, TypeCauseIncidentModel? item, bool isSelected) {
    /*if(isSelected == true){
      print('produit ${item?.produit}');
    } */
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: ListTile(
        selected: isSelected,
        title: Text(item?.typeCause ?? ''),
        subtitle: Text(item?.idTypeCause?.toString() ?? ''),
        leading: CircleAvatar(
          // this does not work - throws 404 error
          // backgroundImage: NetworkImage(item.avatar ?? ''),
        ),
      ),
    );
  }
  // causes typique
  Widget customDropDownMultiSelectionCauseTypique(
      BuildContext context, List<CauseTypiqueModel?> selectedItems) {
    if (selectedItems.isEmpty) {
      return ListTile(
        contentPadding: EdgeInsets.all(0),
        //leading: CircleAvatar(),
        title: Text(""),
      );
    }

    return Wrap(
      children: selectedItems.map((e) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            child: ListTile(
              contentPadding: EdgeInsets.all(0),
              /* leading: CircleAvatar(
                // this does not work - throws 404 error
                // backgroundImage: NetworkImage(item.avatar ?? ''),
              ),
              subtitle: Text(
                e?.mat.toString() ?? '',
              ),*/
              title: Text(e?.causeTypique ?? ''),

            ),
          ),
        );
      }).toList(),
    );
  }
  Widget customPopupItemBuilderCauseTypique(
      BuildContext context, CauseTypiqueModel? item, bool isSelected) {
    /*if(isSelected == true){
      print('produit ${item?.produit}');
    } */
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: ListTile(
        selected: isSelected,
        title: Text(item?.causeTypique ?? ''),
        subtitle: Text(item?.idCauseTypique?.toString() ?? ''),
        leading: CircleAvatar(
          // this does not work - throws 404 error
          // backgroundImage: NetworkImage(item.avatar ?? ''),
        ),
      ),
    );
  }
  //type consequence
  Widget customDropDownMultiSelectionTypeConsequence(
      BuildContext context, List<TypeConsequenceIncidentModel?> selectedItems) {
    if (selectedItems.isEmpty) {
      return ListTile(
        contentPadding: EdgeInsets.all(0),
        //leading: CircleAvatar(),
        title: Text(""),
      );
    }

    return Wrap(
      children: selectedItems.map((e) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            child: ListTile(
              contentPadding: EdgeInsets.all(0),
              /* leading: CircleAvatar(
                // this does not work - throws 404 error
                // backgroundImage: NetworkImage(item.avatar ?? ''),
              ),
              subtitle: Text(
                e?.mat.toString() ?? '',
              ),*/
              title: Text(e?.typeConsequence ?? ''),

            ),
          ),
        );
      }).toList(),
    );
  }
  Widget customPopupItemBuilderTypeConsequence(
      BuildContext context, TypeConsequenceIncidentModel? item, bool isSelected) {
    /*if(isSelected == true){
      print('produit ${item?.produit}');
    } */
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: ListTile(
        selected: isSelected,
        title: Text(item?.typeConsequence ?? ''),
        subtitle: Text(item?.idConsequence?.toString() ?? ''),
        leading: CircleAvatar(
          // this does not work - throws 404 error
          // backgroundImage: NetworkImage(item.avatar ?? ''),
        ),
      ),
    );
  }
  //site lesion
  Widget customDropDownMultiSelectionSiteLesion(
      BuildContext context, List<SiteLesionModel?> selectedItems) {
    if (selectedItems.isEmpty) {
      return ListTile(
        contentPadding: EdgeInsets.all(0),
        //leading: CircleAvatar(),
        title: Text(""),
      );
    }

    return Wrap(
      children: selectedItems.map((e) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            child: ListTile(
              contentPadding: EdgeInsets.all(0),
              /* leading: CircleAvatar(
                // this does not work - throws 404 error
                // backgroundImage: NetworkImage(item.avatar ?? ''),
              ),
              subtitle: Text(
                e?.mat.toString() ?? '',
              ),*/
              title: Text(e?.siteLesion ?? ''),

            ),
          ),
        );
      }).toList(),
    );
  }
  Widget customPopupItemBuilderSiteLesion(
      BuildContext context, SiteLesionModel? item, bool isSelected) {
    /*if(isSelected == true){
      print('produit ${item?.produit}');
    } */
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: ListTile(
        selected: isSelected,
        title: Text(item?.siteLesion ?? ''),
        subtitle: Text(item?.codeSiteLesion?.toString() ?? ''),
        leading: CircleAvatar(
          // this does not work - throws 404 error
          // backgroundImage: NetworkImage(item.avatar ?? ''),
        ),
      ),
    );
  }
}