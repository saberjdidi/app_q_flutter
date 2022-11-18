import 'dart:math';
import 'dart:typed_data';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:qualipro_flutter/Controllers/incident_environnement/incident_environnement_controller.dart';
import 'package:qualipro_flutter/Controllers/reunion/reunion_controller.dart';
import 'package:qualipro_flutter/Models/category_model.dart';
import 'package:qualipro_flutter/Models/lieu_model.dart';
import 'package:qualipro_flutter/Models/secteur_model.dart';
import 'package:qualipro_flutter/Models/type_consequence_model.dart';
import 'package:qualipro_flutter/Services/action/local_action_service.dart';
import 'package:qualipro_flutter/Services/incident_environnement/incident_environnement_service.dart';
import 'package:qualipro_flutter/Services/incident_environnement/local_incident_environnement_service.dart';
import 'package:qualipro_flutter/Services/reunion/local_reunion_service.dart';

import '../../Models/Domaine_affectation_model.dart';
import '../../Models/activity_model.dart';
import '../../Models/champ_cache_model.dart';
import '../../Models/direction_model.dart';
import '../../Models/employe_model.dart';
import '../../Models/gravite_model.dart';
import '../../Models/image_model.dart';
import '../../Models/incident_environnement/champ_obligatore_incident_env_model.dart';
import '../../Models/incident_environnement/cout_estime_inc_env_model.dart';
import '../../Models/incident_environnement/incident_env_model.dart';
import '../../Models/incident_environnement/source_inc_env_model.dart';
import '../../Models/incident_environnement/type_cause_incident_model.dart';
import '../../Models/incident_environnement/type_consequence_incident_model.dart';
import '../../Models/incident_environnement/upload_image_model.dart';
import '../../Models/pnc/champ_obligatoire_pnc_model.dart';
import '../../Models/pnc/gravite_pnc_model.dart';
import '../../Models/pnc/pnc_model.dart';
import '../../Models/processus_model.dart';
import '../../Models/service_model.dart';
import '../../Models/site_model.dart';
import '../../Models/type_cause_model.dart';
import '../../Models/type_incident_model.dart';
import '../../Route/app_route.dart';
import '../../Services/api_services_call.dart';
import '../../Services/pnc/pnc_service.dart';
import '../../Utils/message.dart';
import '../../Utils/shared_preference.dart';
import '../../Utils/snack_bar.dart';
import 'package:path/path.dart' as mypath;

class NewIncidentEnvironnementController extends GetxController {
  var isDataProcessing = false.obs;
  var isVisibleNewIncident = true.obs;
  LocalActionService localActionService = LocalActionService();
  LocalReunionService localReunionService = LocalReunionService();
  LocalIncidentEnvironnementService localIncidentEnvironnementService =
      LocalIncidentEnvironnementService();
  final matricule = SharedPreference.getMatricule();

  final addItemFormKey = GlobalKey<FormState>();
  late TextEditingController dateIncidentController,
      dateEntreController,
      designationController,
      numInterneController,
      heureIncidentController,
      quantityRejController,
      descriptionIncidentController,
      descriptionCauseController,
      descriptionConsequenceController,
      actionImmediateController;
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
  LieuModel? lieuModel = null;
  String? selectedCodeLieu = "";
  String? lieuIncident = "";
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
  List<TypeCauseIncidentModel> listTypeCauseIncident = [];
  //tpe consequence
  List<int> typeConsequenceList = [];
  List<TypeConsequenceIncidentModel> listTypeConsequenceIncident = [];
  //isps
  String? isps = "0";

  //radio
  var etat = 0.obs;
  onChangeEtat(var valeur) {
    etat.value = valeur;
    print('etat : ${etat.value}');
  }

  //upload images
  final ImagePicker imagePicker = ImagePicker();
  var imageFileList = List<XFile>.empty(growable: true).obs;
  var base64List = List<ImageModel>.empty(growable: true).obs;
  //var base64String = ''.obs;
  //var filename = ''.obs;
  //var filenameList = List<String>.empty(growable: true).obs;

  //random data
  var _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  //domaine affectation
  getDomaineAffectation() async {
    List<DomaineAffectationModel> domaineList =
        await List<DomaineAffectationModel>.empty(growable: true);
    var connection = await Connectivity().checkConnectivity();
    if (connection == ConnectivityResult.none) {
      var response = await localActionService.readDomaineAffectationByModule(
          "Environnement", "Incident");
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
        direction_visible.value = model.vDirection!;
        service_visible.value = model.vService!;

        site_obligatoire.value = model.oSite!;
        processus_obligatoire.value = model.oProcessus!;
        activity_obligatoire.value = model.oDomaine!;
        direction_obligatoire.value = model.oDirection!;
        service_obligatoire.value = model.oService!;
        debugPrint(
            'Domaine affectation : fiche: ${model.fiche}, site visible :${site_visible.value}, site obligatoire :${site_obligatoire.value}');
      });
    } else if (connection == ConnectivityResult.wifi ||
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
          if (model.module == "Environnement" && model.fiche == "Incident") {
            site_visible.value = model.vSite!;
            processus_visible.value = model.vProcessus!;
            activity_visible.value = model.vDomaine!;
            direction_visible.value = model.vDirection!;
            service_visible.value = model.vService!;

            site_obligatoire.value = model.oSite!;
            processus_obligatoire.value = model.oProcessus!;
            activity_obligatoire.value = model.oDomaine!;
            direction_obligatoire.value = model.oDirection!;
            service_obligatoire.value = model.oService!;
            debugPrint(
                ' domaine affectation : fiche: ${model.fiche}, site visible :${site_visible.value}, site obligatoire :${site_obligatoire.value}');
          }
        });
      }, onError: (err) {
        ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
      });
    }
  }

  //champ cache
  int? isps_visible = 1;
  bool isVisibileISPS = true;
  int? type_incident_visible = 1;
  bool isVisibileTypeIncident = true;
  int? lieu_visible = 1;
  int? lieu_obligatoire = 1;
  bool isVisibileLieu = true;
  int? cout_esteme_visible = 1;
  bool isVisibileCoutEsteme = true;
  int? date_entre_visible = 1;
  bool isVisibileDateEntre = true;
  int? origine_employe_visible = 1;
  bool isVisibileOrigineEmploye = true;
  int? source_visible = 1;
  bool isVisibileSource = true;
  int? cout_visible = 1;
  bool isVisibileCout = true;
  getChampCache() async {
    try {
      List<ChampCacheModel> listChampCache =
          await List<ChampCacheModel>.empty(growable: true);
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        var response = await localActionService.readChampCacheByModule(
            "Environnement", "Incident");
        response.forEach((data) {
          var model = ChampCacheModel();
          model.id = data['id'];
          model.module = data['module'];
          model.fiche = data['fiche'];
          model.listOrder = data['listOrder'];
          model.nomParam = data['nomParam'];
          model.visible = data['visible'];
          debugPrint(
              'module : ${model.module}, nom_param:${model.nomParam}, visible:${model.visible}');
          listChampCache.add(model);

          if (model.nomParam == "ISPS" &&
              model.module == "Environnement" &&
              model.fiche == "Incident") {
            isps_visible = model.visible;
            //isps_visible = 0;
          } else if (model.nomParam == "Type incident" &&
              model.module == "Environnement" &&
              model.fiche == "Incident") {
            type_incident_visible = model.visible;
            //type_incident_visible = 0;
          } else if (model.nomParam == "Lieu" &&
              model.module == "Environnement" &&
              model.fiche == "Incident") {
            lieu_visible = model.visible;
            lieu_obligatoire = model.visible;
            //product_bloque_visible = 0;
          } else if (model.nomParam == "Coût estimé" &&
              model.module == "Environnement" &&
              model.fiche == "Incident") {
            cout_esteme_visible = model.visible;
            //cout_esteme_visible = 0;
          } else if (model.nomParam == "Date d'entrée" &&
              model.module == "Environnement" &&
              model.fiche == "Incident") {
            date_entre_visible = model.visible;
            //date_entre_visible = 0;
          } else if (model.nomParam == "A l'origine" &&
              model.module == "Environnement" &&
              model.fiche == "Incident") {
            origine_employe_visible = model.visible;
            //origine_employe_visible = 0;
          } else if (model.nomParam == "Source incident" &&
              model.module == "Environnement" &&
              model.fiche == "Incident") {
            source_visible = model.visible;
            //source_visible = 0;
          } else if (model.nomParam == "Coût" &&
              model.module == "Environnement" &&
              model.fiche == "Incident") {
            cout_visible = model.visible;
            //cout_visible = 0;
          }
        });
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        await ApiServicesCall().getChampCache({
          "module": "Environnement",
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
            debugPrint(
                'module : ${model.module}, nom_param:${model.nomParam}, visible:${model.visible}');
            listChampCache.add(model);

            if (model.nomParam == "ISPS" &&
                model.module == "Environnement" &&
                model.fiche == "Incident") {
              isps_visible = model.visible;
              //isps_visible = 0;
            } else if (model.nomParam == "Type incident" &&
                model.module == "Environnement" &&
                model.fiche == "Incident") {
              type_incident_visible = model.visible;
              //type_incident_visible = 0;
            } else if (model.nomParam == "Lieu" &&
                model.module == "Environnement" &&
                model.fiche == "Incident") {
              lieu_visible = model.visible;
              lieu_obligatoire = model.visible;
            } else if (model.nomParam == "Coût estimé" &&
                model.module == "Environnement" &&
                model.fiche == "Incident") {
              cout_esteme_visible = model.visible;
              //cout_esteme_visible = 0;
            } else if (model.nomParam == "Date d'entrée" &&
                model.module == "Environnement" &&
                model.fiche == "Incident") {
              date_entre_visible = model.visible;
              //date_entre_visible = 0;
            } else if (model.nomParam == "A l'origine" &&
                model.module == "Environnement" &&
                model.fiche == "Incident") {
              origine_employe_visible = model.visible;
              //origine_employe_visible = 0;
            } else if (model.nomParam == "Source incident" &&
                model.module == "Environnement" &&
                model.fiche == "Incident") {
              source_visible = model.visible;
              //source_visible = 0;
            } else if (model.nomParam == "Coût" &&
                model.module == "Environnement" &&
                model.fiche == "Incident") {
              cout_visible = model.visible;
              //cout_visible = 0;
            }
          });
        }, onError: (err) {
          isDataProcessing(false);
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
      }
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    }
  }

  //champ obligatoire
  var category_obligatoire = 0.obs;
  var type_consequence_obligatoire = 0.obs;
  var type_cause_obligatoire = 0.obs;
  //var lieu_obligatoire = 0.obs;
  var designation_incident_obligatoire = 0.obs;
  var type_incident_obligatoire = 0.obs;
  var date_incident_obligatoire = 0.obs;
  var action_immediate_obligatoire = 0.obs;
  var gravite_obligatoire = 0.obs;
  var description_incident_obligatoire = 0.obs;
  var description_cause_obligatoire = 0.obs;
  getChampObligatoire() async {
    List<ChampObligatoirePNCModel> champObligatoireList =
        await List<ChampObligatoirePNCModel>.empty(growable: true);
    var connection = await Connectivity().checkConnectivity();
    if (connection == ConnectivityResult.none) {
      var response = await localIncidentEnvironnementService
          .readChampObligatoireIncidentEnv();
      response.forEach((data) {
        var model = ChampObligatoireIncidentEnvModel();
        model.incCat = data['incCat'];
        model.incTypecons = data['incTypecons'];
        model.incTypecause = data['incTypecause'];
        model.lieu = data['lieu'];
        model.desIncident = data['desIncident'];
        model.typeIncident = data['typeIncident'];
        model.dateIncident = data['dateIncident'];
        model.actionImmediates = data['actionImmediates'];
        model.descIncident = data['descIncident'];
        model.descCauses = data['descCauses'];
        model.gravite = data['gravite'];

        category_obligatoire.value = model.incCat!;
        type_consequence_obligatoire.value = model.incTypecons!;
        type_cause_obligatoire.value = model.incTypecause!;
        //lieu_obligatoire.value = model.lieu!;
        designation_incident_obligatoire.value = model.desIncident!;
        type_incident_obligatoire.value = model.typeIncident!;
        date_incident_obligatoire.value = model.dateIncident!;
        action_immediate_obligatoire.value = model.actionImmediates!;
        description_incident_obligatoire.value = model.descIncident!;
        description_cause_obligatoire.value = model.descCauses!;
        gravite_obligatoire.value = model.gravite!;
        debugPrint('champ obligatoire incident : ${data}');
      });
    } else if (connection == ConnectivityResult.wifi ||
        connection == ConnectivityResult.mobile) {
      await IncidentEnvironnementService()
          .getChampObligatoireIncidentEnv()
          .then((data) async {
        var model = ChampObligatoireIncidentEnvModel();
        //model.aspectRappclot = data['aspect_rappclot'];
        model.incCat = data['inc_cat'];
        model.incTypecons = data['inc_typecons'];
        model.incTypecause = data['inc_typecause'];
        //model.aspect = data['aspect'];
        //model.facteur = data['facteur'];
        model.lieu = data['lieu'];
        //model.condition = data['condition'];
        //model.codeImpact = data['code_impact'];
        //model.impact = data['impact'];
        //model.codeLieu = data['code_lieu'];
        model.desIncident = data['des_incident'];
        model.typeIncident = data['type_incident'];
        model.dateIncident = data['date_incident'];
        model.actionImmediates = data['action_immediates'];
        model.descIncident = data['desc_incident'];
        model.descCauses = data['desc_causes'];
        model.gravite = data['gravite'];

        category_obligatoire.value = model.incCat!;
        type_consequence_obligatoire.value = model.incTypecons!;
        type_cause_obligatoire.value = model.incTypecause!;
        //lieu_obligatoire.value = model.lieu!;
        designation_incident_obligatoire.value = model.desIncident!;
        type_incident_obligatoire.value = model.typeIncident!;
        date_incident_obligatoire.value = model.dateIncident!;
        action_immediate_obligatoire.value = model.actionImmediates!;
        description_incident_obligatoire.value = model.descIncident!;
        description_cause_obligatoire.value = model.descCauses!;
        gravite_obligatoire.value = model.gravite!;
        debugPrint('champ obligatoire incident : ${data}');
      }, onError: (err) {
        ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
      });
    }
  }

  bool _dataValidation() {
    if (designationController.text.trim() == '' &&
        designation_incident_obligatoire.value == 1) {
      Message.taskErrorOrWarning(
          'warning'.tr, "Designation incident ${'is_required'.tr}");
      return false;
    } else if (typeIncidentModel == null &&
        type_incident_obligatoire.value == 1) {
      Message.taskErrorOrWarning('warning'.tr, "Type ${'is_required'.tr}");
      return false;
    } else if (categoryModel == null && category_obligatoire.value == 1) {
      Message.taskErrorOrWarning(
          'warning'.tr, "${'categorie'.tr} ${'is_required'.tr}");
      return false;
    } else if (lieuModel == null &&
        lieu_visible == 1 &&
        lieu_obligatoire == 1) {
      Message.taskErrorOrWarning(
          'warning'.tr, "${'lieu'.tr} ${'is_required'.tr}");
      return false;
    } else if (dateIncidentController.text.trim() == '' &&
        date_incident_obligatoire.value == 1) {
      Message.taskErrorOrWarning(
          'warning'.tr, "Date Incident ${'is_required'.tr}");
      return false;
    } else if (graviteModel == null && gravite_obligatoire.value == 1) {
      Message.taskErrorOrWarning(
          'warning'.tr, "${'gravity'.tr} ${'is_required'.tr}");
      return false;
    } else if (site_visible.value == 1 &&
        site_obligatoire.value == 1 &&
        siteModel == null) {
      Message.taskErrorOrWarning('warning'.tr, "Site ${'is_required'.tr}");
      return false;
    } else if (processus_visible.value == 1 &&
        processus_obligatoire.value == 1 &&
        processusModel == null) {
      Message.taskErrorOrWarning('warning'.tr, "Processus ${'is_required'.tr}");
      return false;
    } else if (direction_visible.value == 1 &&
        direction_obligatoire.value == 1 &&
        directionModel == null) {
      Message.taskErrorOrWarning('warning'.tr, "Direction ${'is_required'.tr}");
      return false;
    } else if (service_visible.value == 1 &&
        service_obligatoire.value == 1 &&
        serviceModel == null) {
      Message.taskErrorOrWarning('warning'.tr, "Service ${'is_required'.tr}");
      return false;
    } else if (activity_visible.value == 1 &&
        activity_obligatoire.value == 1 &&
        activityModel == null) {
      Message.taskErrorOrWarning(
          'warning'.tr, "${'activity'.tr} ${'is_required'.tr}");
      return false;
    } else if ((typeCauseList == null ||
            typeCauseList == [] ||
            typeCauseList.isEmpty) &&
        type_cause_obligatoire.value == 1) {
      Message.taskErrorOrWarning(
          'warning'.tr, "Type Cause ${'is_required'.tr}");
      return false;
    } else if ((typeConsequenceList == null ||
            typeConsequenceList == [] ||
            typeConsequenceList.isEmpty) &&
        type_consequence_obligatoire.value == 1) {
      Message.taskErrorOrWarning(
          'warning'.tr, "Type Consequence ${'is_required'.tr}");
      return false;
    } else if (descriptionIncidentController.text.trim() == '' &&
        description_incident_obligatoire.value == 1) {
      Message.taskErrorOrWarning(
          'warning'.tr, "Description incident ${'is_required'.tr}");
      return false;
    } else if (descriptionCauseController.text.trim() == '' &&
        description_cause_obligatoire.value == 1) {
      Message.taskErrorOrWarning(
          'warning'.tr, "Description cause ${'is_required'.tr}");
      return false;
    } else if (actionImmediateController.text.trim() == '' &&
        action_immediate_obligatoire.value == 1) {
      Message.taskErrorOrWarning(
          'warning'.tr, "Description cause ${'is_required'.tr}");
      return false;
    } else if (quantityRejController.text.trim() == '') {
      quantityRejController.text = '0';
    }
    return true;
  }

  @override
  void onInit() {
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
    quantityRejController = TextEditingController();
    dateIncidentController.text =
        DateFormat('yyyy-MM-dd').format(datePickerIncident);
    dateEntreController.text = DateFormat('yyyy-MM-dd').format(datePickerEntre);
    heureIncidentController.text = currentTime.toString();

    getDomaineAffectation();
    getChampCache();
    getChampObligatoire();
    checkConnectivity();
  }

  Future<void> checkConnectivity() async {
    var connection = await Connectivity().checkConnectivity();
    if (connection == ConnectivityResult.none) {
      Get.snackbar("No Connection", "Mode Offline",
          colorText: Colors.blue,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(milliseconds: 900));
    } else if (connection == ConnectivityResult.wifi ||
        connection == ConnectivityResult.mobile) {
      Get.snackbar("Internet Connection", "Mode Online",
          colorText: Colors.blue,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(milliseconds: 900));
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
      dateIncidentController.text =
          DateFormat('yyyy-MM-dd').format(datePickerIncident);
      //dateIncidentController.text = DateFormat.yMMMMd().format(datePickerIncident);
    }
  }

  selectedDateEntre(BuildContext context) async {
    datePickerEntre = (await showDatePicker(
        context: context,
        initialDate: datePickerEntre,
        firstDate: DateTime(2021),
        lastDate: DateTime(2030)))!;
    if (datePickerEntre != null) {
      dateEntreController.text =
          DateFormat('yyyy-MM-dd').format(datePickerEntre);
    }
  }

  //final hours = timeDebut.hour.toString().padLeft(2, '0');
  selectedTimeDebut(BuildContext context) async {
    timeDebut =
        (await showTimePicker(context: context, initialTime: timeDebut))!;
    if (timeDebut == null) return;
    if (timeDebut != null) {
      heureIncidentController.text = '${timeDebut.hour}:${timeDebut.minute}';
    }
  }

  Future saveBtn() async {
    if (_dataValidation() && addItemFormKey.currentState!.validate()) {
      try {
        var connection = await Connectivity().checkConnectivity();
        if (connection == ConnectivityResult.none) {
          int max_num_incident = await localIncidentEnvironnementService
              .getMaxNumIncidentEnvironnement();
          Uint8List? bytesTypeCause = Uint8List.fromList(typeCauseList);
          Uint8List? bytesTypeConsequence =
              Uint8List.fromList(typeConsequenceList);
          var model = IncidentEnvModel();
          model.online = 0;
          model.statut = 1;
          model.n = max_num_incident + 1;
          model.incident = designationController.text;
          model.dateDetect = dateIncidentController.text;
          model.lieu = lieuIncident.toString();
          model.type = typeIncident.toString();
          model.source = sourceIncident.toString();
          model.act = 0;
          model.secteur = secteurIncident.toString();
          model.poste = "";
          model.site = siteIncident.toString();
          model.processus = processusIncident.toString();
          model.domaine = activityIncident.toString();
          model.direction = directionIncident.toString();
          model.service = serviceIncident.toString();
          model.typeCause = "";
          model.typeConseq = "";
          model.delaiTrait = dateEntreController.text;
          model.traite = 0;
          model.cloture = 0;
          model.categorie = categoryIncident.toString();
          model.gravite = graviteIncident.toString();
          model.codeLieu = selectedCodeLieu;
          model.codeSecteur = selectedCodeSecteur;
          model.codeType = selectedCodeTypeIncident;
          model.codeGravite = selectedCodeGravite;
          model.codeSource = selectedCodeSource;
          model.codeCoutEsteme = selectedCodeCoutEsteme;
          model.detectedEmployeMatricule = detectedEmployeMatricule;
          model.origineEmployeMatricule = origineEmployeMatricule;
          model.rapport = descriptionIncidentController.text;
          model.codeCategory = selectedCodeCategory;
          model.heure = heureIncidentController.text;
          model.codeSite = selectedCodeSite;
          model.codeProcessus = selectedCodeProcessus;
          model.codeDirection = selectedCodeDirection;
          model.codeService = selectedCodeService;
          model.codeActivity = selectedCodeActivity;
          model.descriptionConsequence = descriptionConsequenceController.text;
          model.descriptionCause = descriptionCauseController.text;
          model.actionImmediate = actionImmediateController.text;
          model.quantity = quantityRejController.text;
          model.numInterne = numInterneController.text;
          model.isps = isps.toString();
          model.listTypeCause = bytesTypeCause;
          model.listTypeConsequence = bytesTypeConsequence;
          //save data sync
          await localIncidentEnvironnementService
              .saveIncidentEnvironnementSync(model);

          //save list of type cause in db local
          int max_id_inc_cause = await LocalIncidentEnvironnementService()
              .getMaxNumTypeCauseIncidentEnvironnementRattacher();
          listTypeCauseIncident.forEach((element) async {
            int? id_incident_cause = max_id_inc_cause + 1;
            var model = TypeCauseIncidentModel();
            model.online = 2;
            model.idIncidentCause = id_incident_cause;
            model.idIncident = max_num_incident + 1;
            model.idTypeCause = element.idTypeCause;
            model.typeCause = element.typeCause;
            await localIncidentEnvironnementService
                .saveTypeCauseRattacherIncidentEnv(model);
            debugPrint(
                'type cause list off : ${model.idIncident} - ${model.idIncidentCause} - ${model.typeCause}');
          });
          //save list of type consequence in db local
          int max_id_inc_conseq = await LocalIncidentEnvironnementService()
              .getMaxNumTypeConsequenceIncidentEnvironnementRattacher();
          listTypeConsequenceIncident.forEach((element) async {
            int? id_incident_conseq = max_id_inc_conseq + 1;
            var model = TypeConsequenceIncidentModel();
            model.online = 2;
            model.idIncidentConseq = id_incident_conseq;
            model.idIncident = max_num_incident + 1;
            model.idConsequence = element.idConsequence;
            model.typeConsequence = element.typeConsequence;
            //save data
            await localIncidentEnvironnementService
                .saveTypeConsequenceRattacherIncidentEnv(model);
            debugPrint(
                'type consequence list off : ${model.idIncident} - ${model.idIncidentConseq} - ${model.typeConsequence}');
          });

          //upload images offline
          base64List.forEach((element) async {
            print('base64 image: ${element.fileName} - ${element.image}');
            var modelImage = UploadImageModel();
            modelImage.idFiche = max_num_incident + 1;
            modelImage.image = element.image.toString();
            modelImage.fileName = element.fileName.toString();

            await localIncidentEnvironnementService
                .uploadImageIncidentEnvironnement(modelImage);
          });

          Get.back();
          ShowSnackBar.snackBar(
              "Mode Offline", "Incident Added Successfully", Colors.green);
          Get.find<IncidentEnvironnementController>().listIncident.clear();
          Get.find<IncidentEnvironnementController>().getIncident();
          //Get.toNamed(AppRoute.incident_environnement);
          clearData();
        } else if (connection == ConnectivityResult.wifi ||
            connection == ConnectivityResult.mobile) {
          await IncidentEnvironnementService().saveIncident({
            "incident": designationController.text,
            "date_detect": dateIncidentController.text,
            "lieu": selectedCodeLieu,
            "type": selectedCodeTypeIncident.toString(),
            "gravite": selectedCodeGravite.toString(),
            "source": selectedCodeSource.toString(),
            "mat_detect": detectedEmployeMatricule,
            "mat_origine": origineEmployeMatricule,
            "traitement": "",
            "mat_trait": "",
            "mat_suivi": "0",
            "delai_trait": dateEntreController.text,
            "traite": 0,
            "date_trait": DateFormat('yyyy-MM-dd').format(dateNow),
            "rapport_trait": "",
            "cout": 0,
            "cloture": "",
            "date_cloture": DateFormat('yyyy-MM-dd').format(dateNow),
            "rapport_cloture": "",
            "accident": 0,
            "cause": "",
            "date1": dateIncidentController.text,
            "rapport": descriptionIncidentController.text,
            "categorie": selectedCodeCategory.toString(),
            "heure": heureIncidentController.text,
            "poste": "",
            "secteur": selectedCodeSecteur,
            "desc_cons": descriptionConsequenceController.text,
            "desc_cause": descriptionCauseController.text,
            "act_im": actionImmediateController.text,
            "type_cause": "",
            "quantite": quantityRejController.text,
            "ninter": numInterneController.text,
            "matEnreg": matricule.toString(),
            "detectPar": detectedEmployeMatricule,
            "mat": matricule.toString(),
            "id_site": selectedCodeSite.toString(),
            "id_process": selectedCodeProcessus.toString(),
            "id_domaine": selectedCodeActivity.toString(),
            "id_direction": selectedCodeDirection.toString(),
            "id_service": selectedCodeService.toString(),
            "isps": int.parse(isps.toString()),
            "cout_estime": selectedCodeCoutEsteme,
            "date_creat": dateEntreController.text,
            "consequences": typeConsequenceList,
            "causes": typeCauseList
          }).then((response) {
            response.forEach((data) {
              debugPrint('response inc env : ${data['id']}');
              base64List.forEach((element) async {
                print('base64 image: ${element.fileName} - ${element.image}');
                await IncidentEnvironnementService().uploadImageIncEnv({
                  "image": element.image.toString(),
                  "idFiche": data['id'],
                  "fileName": element.fileName.toString()
                }).then((resp) async {
                  //ShowSnackBar.snackBar("Action Successfully", "images uploaded", Colors.green);
                  //Get.to(ActionRealisationPage());
                }, onError: (err) {
                  isDataProcessing(false);
                  //ShowSnackBar.snackBar("Error upload images", err.toString(), Colors.red);
                  print('Error upload images : ${err.toString()}');
                });
              });
            });

            Get.back();
            ShowSnackBar.snackBar(
                "Successfully", "Incident Environnement Added ", Colors.green);
            Get.find<IncidentEnvironnementController>().listIncident.clear();
            Get.find<IncidentEnvironnementController>().getIncident();
            //Get.toNamed(AppRoute.incident_environnement);
            clearData();
          }, onError: (err) {
            isDataProcessing(false);
            print('Error : ${err.toString()}');
            ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
          });
        }
      } catch (ex) {
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
            content: Text(
              '${ex.toString()}',
              style: TextStyle(color: Colors.black),
            ));
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
    quantityRejController.clear();
    descriptionIncidentController.clear();
    descriptionCauseController.clear();
    descriptionConsequenceController.clear();
    actionImmediateController.clear();
    dateIncidentController.text =
        DateFormat('yyyy-MM-dd').format(datePickerIncident);
    dateEntreController.text = DateFormat('yyyy-MM-dd').format(datePickerEntre);
    selectedCodeTypeIncident = 0;
    typeIncidentModel = null;
    categoryModel = null;
    selectedCodeCategory = 0;
    lieuModel = null;
    selectedCodeLieu = "";
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
    lieuIncident = "";
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
    } else {
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text(
            '${typeIncidentModel?.typeIncident}',
            style: TextStyle(color: Colors.black),
          ),
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
    } else {
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

  //lieu
  Widget customDropDownLieu(BuildContext context, LieuModel? item) {
    if (lieuModel == null) {
      return Container();
    } else {
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${lieuModel?.lieu}'),
        ),
      );
    }
  }

  Widget customPopupItemBuilderLieu(
      BuildContext context, lieuModel, bool isSelected) {
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
        title: Text(lieuModel?.lieu ?? ''),
        //subtitle: Text(lieuModel?.code.toString() ?? ''),
      ),
    );
  }

  //secteur
  Widget customDropDownSecteur(BuildContext context, SecteurModel? item) {
    if (secteurModel == null) {
      return Container();
    } else {
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

  //source
  Widget customDropDownSource(
      BuildContext context, SourceIncidentEnvModel? item) {
    if (sourceModel == null) {
      return Container();
    } else {
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${sourceModel?.source}'),
        ),
      );
    }
  }

  Widget customPopupItemBuilderSource(
      BuildContext context, sourceModel, bool isSelected) {
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
        title: Text(sourceModel?.source ?? ''),
        //subtitle: Text(sourceModel?.code.toString() ?? ''),
      ),
    );
  }

  //gravite
  Widget customDropDownGravite(BuildContext context, GraviteModel? item) {
    if (graviteModel == null) {
      return Container();
    } else {
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
  Widget customDropDownCoutEsteme(
      BuildContext context, CoutEstimeIncidentEnvModel? item) {
    if (coutEstemeModel == null) {
      return Container();
    } else {
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

  //employe
  Widget customDropDownEmploye(BuildContext context, EmployeModel? item) {
    if (employeModel == null) {
      return Container();
    } else {
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${employeModel?.nompre}',
              style: TextStyle(color: Colors.black)),
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
  Widget customDropDownDetectedEmploye(
      BuildContext context, EmployeModel? item) {
    if (detectedEmployeModel == null) {
      return Container();
    } else {
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${detectedEmployeModel?.nompre}',
              style: TextStyle(color: Colors.black)),
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
    } else {
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text(
            '${siteModel?.site}',
            style: TextStyle(color: Colors.black),
          ),
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
    } else {
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text(
            '${processusModel?.processus}',
            style: TextStyle(color: Colors.black),
          ),
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
    } else {
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
    } else {
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text(
            '${directionModel?.direction}',
            style: TextStyle(color: Colors.black),
          ),
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
    } else {
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text(
            '${serviceModel?.service}',
            style: TextStyle(color: Colors.black),
          ),
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

  Widget customPopupItemBuilderTypeConsequence(BuildContext context,
      TypeConsequenceIncidentModel? item, bool isSelected) {
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
}
