import 'dart:math';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:qualipro_flutter/Models/client_model.dart';
import 'package:qualipro_flutter/Models/fournisseur_model.dart';
import 'package:qualipro_flutter/Models/pnc/atelier_pnc_model.dart';
import 'package:qualipro_flutter/Models/pnc/source_pnc_model.dart';
import 'package:qualipro_flutter/Models/pnc/type_pnc_model.dart';
import 'package:qualipro_flutter/Models/product_model.dart';
import 'package:qualipro_flutter/Services/action/local_action_service.dart';
import 'package:qualipro_flutter/Services/pnc/local_pnc_service.dart';
import '../../Models/Domaine_affectation_model.dart';
import '../../Models/activity_model.dart';
import '../../Models/champ_cache_model.dart';
import '../../Models/direction_model.dart';
import '../../Models/employe_model.dart';
import '../../Models/image_model.dart';
import '../../Models/incident_environnement/upload_image_model.dart';
import '../../Models/pnc/champ_obligatoire_pnc_model.dart';
import '../../Models/pnc/gravite_pnc_model.dart';
import '../../Models/pnc/pnc_model.dart';
import '../../Models/pnc/product_pnc_model.dart';
import '../../Models/processus_model.dart';
import '../../Models/service_model.dart';
import '../../Models/site_model.dart';
import '../../Route/app_route.dart';
import '../../Services/api_services_call.dart';
import '../../Services/pnc/pnc_service.dart';
import '../../Utils/message.dart';
import '../../Utils/shared_preference.dart';
import '../../Utils/snack_bar.dart';
import '../../Views/pnc/add_products_pnc/products_pnc_page.dart';
import 'pnc_controller.dart';

class NewPNCController extends GetxController {
  var isDataProcessing = false.obs;
  var isVisibleNewPNC = true.obs;
  LocalPNCService localPNCService = LocalPNCService();
  LocalActionService localActionService = LocalActionService();
  final matricule = SharedPreference.getMatricule();

  final addItemFormKey = GlobalKey<FormState>();
  late TextEditingController dateDetectionController,
      dateLivraisonController,
      dateSaisieController,
      designationController,
      actionPriseController,
      numInterneController,
      numeroOfController,
      numeroLotController,
      uniteController,
      quantityDetectController,
      quantityProductController,
      pourcentageController;
  DateTime datePickerDetection = DateTime.now();
  DateTime datePickerLivraison = DateTime.now();
  DateTime datePickerSaisie = DateTime.now();

  //type
  TypePNCModel? typePNCModel = null;
  var type_obligatoire = 1.obs;
  int? selectedCodeType = 0;
  String? selectedTypeNc = "";
  //gravite
  GravitePNCModel? graviteModel = null;
  int? selectedCodeGravite = 0;
  //source
  SourcePNCModel? sourcePNCModel = null;
  int? selectedCodeSource = 0;
  //atelier
  AtelierPNCModel? atelierPNCModel = null;
  int? selectedCodeAtelier = 0;
  //product
  ProductModel? productModel = null;
  String? selectedCodeProduct = "";
  String? selectedProduct = "";
  int? product_visible = 1;
  bool isVisibileProduct = true;
  //fournisseur
  FournisseurModel? fournisseurModel = null;
  String? selectedCodeFournisseur = "";
  String? selectedFournisseur = "";

  //employe
  EmployeModel? employeModel = null;
  EmployeModel? detectedEmployeModel = null;
  String? origineNCMatricule = "";
  String? detectedEmployeMatricule = "";
  //site
  var site_visible = 0.obs;
  late bool isVisibileSite;
  var site_obligatoire = 0.obs;
  SiteModel? siteModel = null;
  int? selectedCodeSite = 0;
  String? selectedSite = "";
  //processus
  var processus_visible = 0.obs;
  late bool isVisibileProcessus;
  var processus_obligatoire = 0.obs;
  ProcessusModel? processusModel = null;
  int? selectedCodeProcessus = 0;
  //activity
  var activity_visible = 0.obs;
  late bool isVisibileActivity;
  var activity_obligatoire = 0.obs;
  ActivityModel? activityModel = null;
  int? selectedCodeActivity = 0;
  //direction
  var direction_visible = 0.obs;
  late bool isVisibileDirection;
  var direction_obligatoire = 0.obs;
  DirectionModel? directionModel = null;
  int? selectedCodeDirection = 0;
  //service
  var service_visible = 0.obs;
  late bool isVisibileService;
  var service_obligatoire = 0.obs;
  ServiceModel? serviceModel = null;
  int? selectedCodeService = 0;
  String? isps = "0";
  //quantity
  int quantity_detect = 0;
  int quantity_product = 0;
  //PNC radio button
  var pncDetected = 0.obs;
  var isVisibleCLient = false.obs;
  //client
  ClientModel? clientModel = null;
  String? selectedCodeClient = "";

  //upload images
  final ImagePicker imagePicker = ImagePicker();
  var imageFileList = List<XFile>.empty(growable: true).obs;
  var base64List = List<ImageModel>.empty(growable: true).obs;
  //random data
  var _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  onChangePNCDetected(var detectedBy) {
    pncDetected.value = detectedBy;
    debugPrint('detected by : ${pncDetected.value}');
    debugPrint('code client : ${selectedCodeClient}');
    if (pncDetected.value == 1) {
      isVisibleCLient.value = true;
    } else {
      isVisibleCLient.value = false;
      clientModel = null;
      selectedCodeClient = "";
    }
  }

  //checkbox product
  var checkProductBloque = false.obs;
  var productBloque = 0.obs;
  var checkProductIsole = false.obs;
  var productIsole = 0.obs;

  //domaine affectation
  getDomaineAffectation() async {
    List<DomaineAffectationModel> domaineList =
        await List<DomaineAffectationModel>.empty(growable: true);
    var connection = await Connectivity().checkConnectivity();
    if (connection == ConnectivityResult.none) {
      var response =
          await localActionService.readDomaineAffectationByModule("PNC", "PNC");
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
        print(
            'fiche: ${model.fiche}, site visible :${site_visible.value}, site obligatoire :${site_obligatoire.value}');
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
          if (model.module == "PNC" && model.fiche == "PNC") {
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
            print(
                'fiche: ${model.fiche}, site visible :${site_visible.value}, site obligatoire :${site_obligatoire.value}');
          }
        });
      }, onError: (err) {
        ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
      });
    }
  }

  //champ cache
  int? isps_visible = 1;
  int? type_nc_visible = 1;
  int? product_bloque_visible = 1;
  int? product_isole_visible = 1;
  int? num_interne_visible = 1;
  int? detected_by_visible = 1;
  int? origine_nc_visible = 1;
  int? atelier_visible = 1;
  int? fournisseur_visible = 1;
  int? unite_visible = 1;
  int? numero_lot_visible = 1;
  int? numero_of_visible = 1;
  int? quantity_visible = 1;
  getChampCache() async {
    try {
      List<ChampCacheModel> listChampCache =
          await List<ChampCacheModel>.empty(growable: true);
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        var response = await localActionService.readChampCacheByModule(
            "P.N.C.", "PNC"); //Demande action
        response.forEach((data) {
          var model = ChampCacheModel();
          model.id = data['id'];
          model.module = data['module'];
          model.fiche = data['fiche'];
          model.listOrder = data['listOrder'];
          model.nomParam = data['nomParam'];
          model.visible = data['visible'];
          debugPrint(
              'champ cache : module : ${model.module}, nom_param:${model.nomParam}, visible:${model.visible}');
          listChampCache.add(model);

          if (model.nomParam == "ISPS" && model.module == "P.N.C.") {
            isps_visible = model.visible;
            //isps_visible = 0;
          } else if (model.nomParam == "Type N.C." &&
              model.module == "P.N.C.") {
            type_nc_visible = model.visible;
            //type_nc_visible = 0;
          } else if (model.nomParam == "Produit bloqué" &&
              model.module == "P.N.C.") {
            product_bloque_visible = model.visible;
            //product_bloque_visible = 0;
          } else if (model.nomParam == "Produit isolé" &&
              model.module == "P.N.C.") {
            product_isole_visible = model.visible;
            //product_isole_visible = 0;
          } else if (model.nomParam == "N° interne" &&
              model.module == "P.N.C.") {
            num_interne_visible = model.visible;
            //num_interne_visible = 0;
          } else if (model.nomParam == "Détectée par" &&
              model.module == "P.N.C.") {
            detected_by_visible = model.visible;
            //detected_by_visible = 0;
          } else if (model.nomParam == "A l'origine de la N.C." &&
              model.module == "P.N.C.") {
            origine_nc_visible = model.visible;
            //origine_nc_visible = 0;
          } else if (model.nomParam == "Atelier" && model.module == "P.N.C.") {
            atelier_visible = model.visible;
            //atelier_visible = 0;
          } else if (model.nomParam == "Fournisseur" &&
              model.module == "P.N.C.") {
            fournisseur_visible = model.visible;
            //fournisseur_visible = 0;
          } else if (model.nomParam == "Unité" && model.module == "P.N.C.") {
            unite_visible = model.visible;
            //unite_visible = 0;
          } else if (model.nomParam == "N° Lot" && model.module == "P.N.C.") {
            numero_lot_visible = model.visible;
          } else if (model.nomParam == "N° OF" && model.module == "P.N.C.") {
            numero_of_visible = model.visible;
          } else if (model.nomParam == "Quantité + Valeur" &&
              model.module == "P.N.C.") {
            quantity_visible = model.visible;
          }
        });
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        await ApiServicesCall()
            .getChampCache({"module": "P.N.C.", "fiche": ""}).then(
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
            debugPrint(
                'champ cache : module : ${model.module}, nom_param:${model.nomParam}, visible:${model.visible}');
            listChampCache.add(model);

            if (model.nomParam == "ISPS" && model.module == "P.N.C.") {
              isps_visible = model.visible;
              //isps_visible = 0;
            } else if (model.nomParam == "Type N.C." &&
                model.module == "P.N.C.") {
              type_nc_visible = model.visible;
              //type_nc_visible = 0;
            } else if (model.nomParam == "Produit bloqué" &&
                model.module == "P.N.C.") {
              product_bloque_visible = model.visible;
              //product_bloque_visible = 0;
            } else if (model.nomParam == "Produit isolé" &&
                model.module == "P.N.C.") {
              product_isole_visible = model.visible;
              //product_isole_visible = 0;
            } else if (model.nomParam == "N° interne" &&
                model.module == "P.N.C.") {
              num_interne_visible = model.visible;
              //num_interne_visible = 0;
            } else if (model.nomParam == "Détectée par" &&
                model.module == "P.N.C.") {
              detected_by_visible = model.visible;
              //detected_by_visible = 0;
            } else if (model.nomParam == "A l'origine de la N.C." &&
                model.module == "P.N.C.") {
              origine_nc_visible = model.visible;
              //origine_nc_visible = 0;
            } else if (model.nomParam == "Atelier" &&
                model.module == "P.N.C.") {
              atelier_visible = model.visible;
              //atelier_visible = 0;
            } else if (model.nomParam == "Fournisseur" &&
                model.module == "P.N.C.") {
              fournisseur_visible = model.visible;
              //fournisseur_visible = 0;
            } else if (model.nomParam == "Unité" && model.module == "P.N.C.") {
              unite_visible = model.visible;
            } else if (model.nomParam == "N° Lot" && model.module == "P.N.C.") {
              numero_lot_visible = model.visible;
            } else if (model.nomParam == "N° OF" && model.module == "P.N.C.") {
              numero_of_visible = model.visible;
            } else if (model.nomParam == "Quantité + Valeur" &&
                model.module == "P.N.C.") {
              quantity_visible = model.visible;
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
  var num_interne_obligatoire = 1.obs;
  int? date_liv_obligatoire = 1;
  int? num_of_obligatoire = 1;
  int? num_lot_obligatoire = 1;
  int? fournisseur_obligatoire = 1;
  int? qte_detect_obligatoire = 1;
  int? qte_produit_obligatoire = 1;
  int? unite_obligatoire = 1;
  int? gravite_obligatoire = 1;
  int? source_obligatoire = 1;
  int? atelier_obligatoire = 1;
  int? origine_nc_obligatoire = 1;
  getChampObligatoire() async {
    List<ChampObligatoirePNCModel> champObligatoireList =
        await List<ChampObligatoirePNCModel>.empty(growable: true);
    var connection = await Connectivity().checkConnectivity();
    if (connection == ConnectivityResult.none) {
      var response = await localPNCService.readChampObligatoirePNC();
      response.forEach((data) {
        var model = ChampObligatoirePNCModel();
        model.numInterne = data['numInterne'];
        model.enregistre = data['enregistre'];
        model.dateLivr = data['dateLivr'];
        model.numOf = data['numOf'];
        model.numLot = data['numLot'];
        model.fournisseur = data['fournisseur'];
        model.qteDetect = data['qteDetect'];
        model.qteProduite = data['qteProduite'];
        model.unite = data['unite'];
        model.gravite = data['gravite'];
        model.source = data['source'];
        model.atelier = data['atelier'];
        model.origine = data['origine'];
        model.nonConf = data['nonConf'];
        model.traitNc = data['traitNc'];
        model.typeTrait = data['typeTrait'];
        model.respTrait = data['respTrait'];
        model.delaiTrait = data['delaiTrait'];
        model.respSuivi = data['respSuivi'];
        model.datTrait = data['datTrait'];
        model.coutTrait = data['coutTrait'];
        model.quantite = data['quantite'];
        model.valeur = data['valeur'];
        model.rapTrait = data['rapTrait'];
        model.datClo = data['datClo'];
        model.rapClo = data['rapClo'];
        model.pourcTypenc = data['pourcTypenc'];
        model.detectPar = data['detectPar'];

        num_interne_obligatoire.value = int.parse(model.numInterne.toString());
        date_liv_obligatoire = model.dateLivr;
        num_of_obligatoire = model.numOf;
        num_lot_obligatoire = model.numLot;
        fournisseur_obligatoire = model.fournisseur;
        qte_detect_obligatoire = model.qteDetect;
        qte_produit_obligatoire = model.qteProduite;
        unite_obligatoire = model.unite;
        gravite_obligatoire = model.gravite;
        source_obligatoire = model.source;
        atelier_obligatoire = model.atelier;
        origine_nc_obligatoire = model.origine;

        debugPrint('champ obligatoire PNC : ${data}');
      });
    } else if (connection == ConnectivityResult.wifi ||
        connection == ConnectivityResult.mobile) {
      await ApiServicesCall().getChampObligatoirePNC().then((data) async {
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

        //num_interne_obligatoire = model.numInterne;
        num_interne_obligatoire.value = int.parse(model.numInterne.toString());
        date_liv_obligatoire = model.dateLivr;
        num_of_obligatoire = model.numOf;
        num_lot_obligatoire = model.numLot;
        fournisseur_obligatoire = model.fournisseur;
        qte_detect_obligatoire = model.qteDetect;
        qte_produit_obligatoire = model.qteProduite;
        unite_obligatoire = model.unite;
        gravite_obligatoire = model.gravite;
        source_obligatoire = model.source;
        atelier_obligatoire = model.atelier;
        origine_nc_obligatoire = model.origine;
        debugPrint('champ obligatoire PNC : ${data}');
      }, onError: (err) {
        ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
      });
    }
  }

  bool _dataValidation() {
    if (designationController.text.trim() == '') {
      Message.taskErrorOrWarning(
          'warning'.tr, "designation ${'is_required'.tr}");
      return false;
    } else if (dateDetectionController.text.trim() == '') {
      Message.taskErrorOrWarning('warning'.tr, "Date ${'is_required'.tr}");
      return false;
    } else if (date_liv_obligatoire == 1 &&
        dateLivraisonController.text.trim() == '') {
      Message.taskErrorOrWarning(
          'warning'.tr, "Date ${'delivery'.tr} ${'is_required'.tr}");
      return false;
    } else if (typePNCModel == null) {
      Message.taskErrorOrWarning('warning'.tr, "Type ${'is_required'.tr}");
      return false;
    } else if (graviteModel == null && gravite_obligatoire == 1) {
      Message.taskErrorOrWarning(
          'warning'.tr, "${'gravity'.tr} ${'is_required'.tr}");
      return false;
    } else if (sourcePNCModel == null && source_obligatoire == 1) {
      Message.taskErrorOrWarning('warning'.tr, "Source ${'is_required'.tr}");
      return false;
    } else if (atelierPNCModel == null &&
        atelier_visible == 1 &&
        atelier_obligatoire == 1) {
      Message.taskErrorOrWarning(
          'warning'.tr, "${'atelier'.tr} ${'is_required'.tr}");
      return false;
    } else if (productModel == null &&
        selectedCodeProduct == "" &&
        selectedProduct == "") {
      Message.taskErrorOrWarning(
          'warning'.tr, "${'product'.tr} ${'is_required'.tr}");
      return false;
    } else if (fournisseur_visible == 1 &&
        fournisseur_obligatoire == 1 &&
        fournisseurModel == null) {
      Message.taskErrorOrWarning(
          'warning'.tr, "${'fournisseur'.tr} ${'is_required'.tr}");
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
    } else if (origine_nc_visible == 1 &&
        origine_nc_obligatoire == 1 &&
        employeModel == null) {
      Message.taskErrorOrWarning(
          'warning'.tr, "${'origine_pnc'.tr} ${'is_required'.tr}");
      return false;
    } else if (num_interne_obligatoire == 1 &&
        num_interne_visible == 1 &&
        numInterneController.text.trim() == '') {
      Message.taskErrorOrWarning(
          'warning'.tr, "${'ref_interne'.tr} ${'is_required'.tr}");
      return false;
    } else if (num_of_obligatoire == 1 &&
        numeroOfController.text.trim() == '') {
      Message.taskErrorOrWarning('warning'.tr, "Numero Of ${'is_required'.tr}");
      return false;
    } else if (num_lot_obligatoire == 1 &&
        numero_lot_visible == 1 &&
        numeroLotController.text.trim() == '') {
      Message.taskErrorOrWarning(
          'warning'.tr, "Numero Lot ${'is_required'.tr}");
      return false;
    } else if (unite_obligatoire == 1 &&
        unite_visible == 1 &&
        uniteController.text.trim() == '') {
      Message.taskErrorOrWarning(
          'warning'.tr, "${'unite'.tr} ${'is_required'.tr}");
      return false;
    } else if (qte_detect_obligatoire == 1 &&
        quantityDetectController.text.trim() == '') {
      Message.taskErrorOrWarning(
          'warning'.tr, "${'quantity'.tr} ${'detect'.tr} ${'is_required'.tr}");
      return false;
    } else if (qte_produit_obligatoire == 1 &&
        quantityProductController.text.trim() == '') {
      Message.taskErrorOrWarning(
          'warning'.tr, "${'quantity'.tr} ${'product'.tr} ${'is_required'.tr}");
      return false;
    }

    if (quantityDetectController.text.trim() == '') {
      quantity_detect = 0;
    } else {
      quantity_detect = int.parse(quantityDetectController.text.toString());
    }
    if (quantityProductController.text.trim() == '') {
      quantity_product = 0;
    } else {
      quantity_product = int.parse(quantityProductController.text.toString());
    }
    if (quantity_detect > quantity_product) {
      Message.taskErrorOrWarning('warning'.tr,
          'quantity_product_greater_or_equal_quantity_detected'.tr);
      return false;
    }

    return true;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    designationController = TextEditingController();
    actionPriseController = TextEditingController();
    quantityDetectController = TextEditingController();
    quantityProductController = TextEditingController();
    dateDetectionController = TextEditingController();
    dateLivraisonController = TextEditingController();
    dateSaisieController = TextEditingController();
    numInterneController = TextEditingController();
    numeroOfController = TextEditingController();
    numeroLotController = TextEditingController();
    uniteController = TextEditingController();
    pourcentageController = TextEditingController();
    dateDetectionController.text =
        DateFormat('yyyy-MM-dd').format(datePickerDetection);
    dateLivraisonController.text =
        DateFormat('yyyy-MM-dd').format(datePickerLivraison);
    dateSaisieController.text =
        DateFormat('yyyy-MM-dd').format(datePickerSaisie);
    //quantityDetectController.text = '0';
    //quantityProductController.text = '0';

    getDomaineAffectation();
    getChampCache();
    getChampObligatoire();
    parametrageProduct();
    checkConnectivity();
  }

  var isVisiblePercentagePNC = false.obs;
  void parametrageProduct() async {
    try {
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        int? oneProduct = SharedPreference.getIsOneProduct();
        if (oneProduct == 1) {
          isVisiblePercentagePNC.value = false;
          pourcentageController.text = '0';
        } else {
          isVisiblePercentagePNC.value = true;
        }
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //rest api
        PNCService().parametrageProduct().then((params) async {
          final paramProduct = params['seulProduit'];
          if (paramProduct == 1) {
            isVisiblePercentagePNC.value = false;
            pourcentageController.text = '0';
          } else {
            isVisiblePercentagePNC.value = true;
          }
        }, onError: (err) {
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
      }
    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      //isDataProcessing(false);
    }
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

  selectedDateDetection(BuildContext context) async {
    datePickerDetection = (await showDatePicker(
        context: context,
        initialDate: datePickerDetection,
        firstDate: DateTime(2021),
        lastDate: DateTime(2100)
        //lastDate: DateTime.now()
        ))!;
    if (datePickerDetection != null) {
      dateDetectionController.text =
          DateFormat('yyyy-MM-dd').format(datePickerDetection);
      //dateDetectionController.text = DateFormat.yMMMMd().format(datePickerDetection);
    }
  }

  selectedDateLivraison(BuildContext context) async {
    datePickerLivraison = (await showDatePicker(
        context: context,
        initialDate: datePickerLivraison,
        firstDate: DateTime(2021),
        lastDate: DateTime(2100)
        //lastDate: DateTime.now()
        ))!;
    if (datePickerLivraison != null) {
      dateLivraisonController.text =
          DateFormat('yyyy-MM-dd').format(datePickerLivraison);
    }
  }

  Future saveBtn() async {
    if (_dataValidation() && addItemFormKey.currentState!.validate()) {
      try {
        var connection = await Connectivity().checkConnectivity();
        if (connection == ConnectivityResult.none) {
          int max_num_pnc = await localPNCService.getMaxNumPNC();
          var model = PNCModel();
          model.nnc = max_num_pnc + 1;
          model.nc = designationController.text.trim();
          model.codePdt = selectedCodeProduct;
          model.codeTypeNC = selectedCodeType;
          model.dateDetect = dateDetectionController.text;
          model.dateLivraison = '${dateLivraisonController.text}T09:44:35.943Z';
          model.valRej = 0;
          model.unite = uniteController.text;
          model.recep = detectedEmployeMatricule;
          model.qteDetect = quantity_detect;
          model.traitee = 0;
          model.online = 0;
          model.actionIm = actionPriseController.text;
          model.dateSaisie = dateSaisieController.text;
          model.codeFournisseur = selectedCodeFournisseur;
          model.codeClient = selectedCodeClient;
          model.numInterne = numInterneController.text;
          model.qteProduct = quantity_product;
          model.numeroOf = numeroOfController.text;
          model.numeroLot = numeroLotController.text;
          model.matOrigine = origineNCMatricule;
          model.isps = isps;
          model.codeGravite = selectedCodeGravite;
          model.codeSource = selectedCodeSource;
          model.codeSite = selectedCodeSite;
          model.codeProcessus = selectedCodeProcessus;
          model.codeDirection = selectedCodeDirection;
          model.codeService = selectedCodeService;
          model.codeActivity = selectedCodeActivity;
          model.codeAtelier = selectedCodeAtelier;
          model.bloque = productBloque.value;
          model.isole = productIsole.value;
          model.pourcentage = int.parse(pourcentageController.text);
          model.typeNC = selectedTypeNc;
          model.produit = selectedProduct;
          model.site = selectedSite;
          model.fournisseur = selectedFournisseur;
          model.rapportT = "";
          //save data sync
          await localPNCService.savePNCSync(model);

          //save product
          int max_product_id = await LocalPNCService().getMaxNumProductPNC();
          var modelProduct = ProductPNCModel();
          modelProduct.online = 3;
          modelProduct.nnc = max_num_pnc + 1;
          modelProduct.idNCProduct = max_product_id + 1;
          modelProduct.codeProduit = selectedCodeProduct;
          modelProduct.produit = selectedProduct;
          modelProduct.numOf = numeroOfController.text;
          modelProduct.numLot = numeroLotController.text;
          modelProduct.qdetect = quantity_detect;
          modelProduct.qprod = quantity_product;
          modelProduct.typeProduit = '';
          modelProduct.unite = uniteController.text.toString();
          await localPNCService.saveProductPNC(modelProduct);

          //save type product
          int max_id_type_product_nc =
              await localPNCService.getMaxIdTypeProductPNC();
          var modelTypeProduct = TypePNCModel();
          modelTypeProduct.online = 2;
          modelTypeProduct.nnc = max_num_pnc + 1;
          modelTypeProduct.idProduct = max_product_id + 1;
          modelTypeProduct.idTabNcProductType = max_id_type_product_nc + 1;
          modelTypeProduct.codeTypeNC = selectedCodeType;
          modelTypeProduct.typeNC = selectedTypeNc;
          modelTypeProduct.color = 'FFFFFF';
          modelTypeProduct.pourcentage = int.parse(pourcentageController.text);
          await localPNCService.saveTypeProductPNC(modelTypeProduct);

          //upload images offline
          base64List.forEach((element) async {
            print('base64 image: ${element.fileName} - ${element.image}');
            var modelImage = UploadImageModel();
            modelImage.idFiche = max_num_pnc + 1;
            modelImage.image = element.image.toString();
            modelImage.fileName = element.fileName.toString();

            await localPNCService.uploadImagePNC(modelImage);
          });

          Get.back();
          Get.find<PNCController>().listPNC.clear();
          Get.find<PNCController>().getPNC();
          ShowSnackBar.snackBar(
              "Mode Offline", "PNC Added Successfully", Colors.green);
          //Get.offAllNamed(AppRoute.pnc);
        } else if (connection == ConnectivityResult.wifi ||
            connection == ConnectivityResult.mobile) {
          await PNCService().savePNC({
            "codePdt": selectedCodeProduct,
            "codeTypeNC": selectedCodeType,
            "dateDetect": dateDetectionController.text,
            "nc": designationController.text.trim(),
            "recep": detectedEmployeMatricule,
            "qteDetect": quantity_detect,
            "unite": uniteController.text,
            "valRej": 0,
            "traitement": "string",
            "ctr": 0,
            "ctt": 0,
            "traitee": 0,
            "respTrait": "",
            "numOf": numeroOfController.text,
            "delaiTrait": dateSaisieController.text,
            "qteRej": 0,
            "matOrigine": origineNCMatricule,
            "ngravite": selectedCodeGravite,
            "repSuivi": "",
            "cloturee": 0,
            "dateT": dateSaisieController.text,
            "codeSite": selectedCodeSite,
            "codeSourceNC": selectedCodeSource,
            "codeTypeT": 0,
            "nLot": numeroLotController.text,
            "rapportT": "",
            "nAct": 0,
            "dateClot": dateSaisieController.text,
            "rapportClot": "",
            "bloque": productBloque.value,
            "isole": productIsole.value,
            "numCession": "",
            "numEnvoi": "",
            "dateSaisie": dateSaisieController.text,
            "matEnreg": matricule.toString(),
            "qtConforme": 0,
            "qtNonConforme": 0,
            "prix": 0,
            "dateLiv":
                '${dateLivraisonController.text}T09:44:35.943Z', //dateLivraisonController.text,
            "atelier": selectedCodeAtelier,
            "qteprod": quantity_product,
            "ninterne": numInterneController.text,
            "det_type": 1,
            "avec_retour": 19,
            "processus": selectedCodeProcessus,
            "domaine": selectedCodeActivity,
            "direction": selectedCodeDirection,
            "service": selectedCodeService,
            "id_client": selectedCodeClient,
            "actionIm": actionPriseController.text,
            "causeNC": "default",
            "isps": isps,
            "id_fournisseur": selectedCodeFournisseur,
            "pourcentage": int.parse(pourcentageController.text)
          }).then((resp) {
            final nnc = resp['nnc'];
            print('nnc : ${nnc}');

            //parametrage product
            PNCService().parametrageProduct().then((params) async {
              final paramProduct = params['seulProduit'];
              print('parametre Product : ${paramProduct}');
              if (paramProduct == 1) {
                Get.back();
                Get.find<PNCController>().listPNC.clear();
                Get.find<PNCController>().getPNC();
                //Get.offAllNamed(AppRoute.pnc);
                ShowSnackBar.snackBar(
                    "Successfully", "PNC Added ", Colors.green);
              } else {
                ShowSnackBar.snackBar(
                    "Successfully", "PNC Added ", Colors.green);
                Get.defaultDialog(
                    title: 'Add Products',
                    backgroundColor: Colors.white,
                    titleStyle: TextStyle(color: Colors.black),
                    middleTextStyle: TextStyle(color: Colors.white),
                    textConfirm: "Yes",
                    textCancel: "No",
                    onConfirm: () {
                      //Get.find<PNCController>().listPNC.clear();
                      //Get.find<PNCController>().getPNC();
                      //Get.to(ProductsPNCPage(nnc: nnc));
                      Get.offAll(ProductsPNCPage(nnc: nnc));
                    },
                    onCancel: () {
                      //Get.offAllNamed(AppRoute.pnc);
                      Get.find<PNCController>().listPNC.clear();
                      Get.find<PNCController>().getPNC();
                      Get.offAllNamed(AppRoute.pnc);
                      //clearData();
                    },
                    confirmTextColor: Colors.white,
                    buttonColor: Colors.blue,
                    barrierDismissible: false,
                    radius: 20,
                    content: Text(
                      '${'do_you_want_add'.tr} ${'product'.tr}s',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Brand-Bold'),
                    ));
              }
            }, onError: (err) {
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });

            //upload images
            base64List.forEach((element) async {
              print('base64 image: ${element.fileName} - ${element.image}');
              await PNCService().uploadImagePNC({
                "image": element.image.toString(),
                "idFiche": nnc,
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
        if (kDebugMode) {
          print("throwing new error " + ex.toString());
        }
        throw Exception("Error " + ex.toString());
      }
    }
  }

  clearData() {
    //onInit();
    designationController.clear();
    actionPriseController.clear();
    detectedEmployeModel = null;
    detectedEmployeMatricule = "";
    dateDetectionController.text =
        DateFormat('yyyy-MM-dd').format(datePickerDetection);
    dateLivraisonController.text =
        DateFormat('yyyy-MM-dd').format(datePickerLivraison);
    dateSaisieController.text =
        DateFormat('yyyy-MM-dd').format(datePickerSaisie);
    typePNCModel = null;
    selectedCodeType = 0;
    graviteModel = null;
    selectedCodeGravite = 0;
    sourcePNCModel = null;
    selectedCodeSource = 0;
    atelierPNCModel = null;
    selectedCodeAtelier = 0;
    productModel = null;
    selectedCodeProduct = "";
    fournisseurModel = null;
    selectedCodeFournisseur = "";
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
    employeModel = null;
    origineNCMatricule = "";
    uniteController.clear();
    numInterneController.clear();
    numeroOfController.clear();
    numeroLotController.clear();
    quantityDetectController.clear();
    quantityProductController.clear();
    numeroLotController.clear();
    pncDetected = 0.obs;
    isVisibleCLient.value = false;
    clientModel = null;
    selectedCodeClient = "";
    checkProductBloque = false.obs;
    checkProductIsole = false.obs;
  }

  //type pnc
  Widget customDropDownType(BuildContext context, TypePNCModel? item) {
    if (typePNCModel == null) {
      return Container();
    } else {
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${typePNCModel?.typeNC}'),
        ),
      );
    }
  }

  Widget customPopupItemBuilderType(
      BuildContext context, typePNCModel, bool isSelected) {
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
        title: Text(typePNCModel?.typeNC ?? ''),
        subtitle: Text(typePNCModel?.codeTypeNC.toString() ?? ''),
      ),
    );
  }

  //gravite pnc
  Widget customDropDownGravite(BuildContext context, GravitePNCModel? item) {
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
        subtitle: Text(graviteModel?.nGravite.toString() ?? ''),
      ),
    );
  }

  //source pnc
  Widget customDropDownSource(BuildContext context, SourcePNCModel? item) {
    if (sourcePNCModel == null) {
      return Container();
    } else {
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${sourcePNCModel?.sourceNC}'),
        ),
      );
    }
  }

  Widget customPopupItemBuilderSource(
      BuildContext context, sourcePNCModel, bool isSelected) {
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
        title: Text(sourcePNCModel?.sourceNC ?? ''),
        subtitle: Text(sourcePNCModel?.codeSourceNC.toString() ?? ''),
      ),
    );
  }

  //atelier pnc
  Widget customDropDownAtelier(BuildContext context, AtelierPNCModel? item) {
    if (atelierPNCModel == null) {
      return Container();
    } else {
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${atelierPNCModel?.atelier}'),
        ),
      );
    }
  }

  Widget customPopupItemBuilderAtelier(
      BuildContext context, atelierPNCModel, bool isSelected) {
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
        title: Text(atelierPNCModel?.atelier ?? ''),
        subtitle: Text(atelierPNCModel?.codeAtelier.toString() ?? ''),
      ),
    );
  }

  //product
  Widget customDropDownProduct(BuildContext context, ProductModel? item) {
    if (productModel == null) {
      return Container();
    } else {
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${productModel?.produit}'),
          subtitle: Text('${productModel?.codePdt}'),
        ),
      );
    }
  }

  Widget customPopupItemBuilderProduct(
      BuildContext context, productModel, bool isSelected) {
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
        title: Text(productModel?.produit ?? ''),
        subtitle: Text(productModel?.codePdt.toString() ?? ''),
      ),
    );
  }

  //fournisseur
  Widget customDropDownFournisseur(
      BuildContext context, FournisseurModel? item) {
    if (fournisseurModel == null) {
      return Container();
    } else {
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${fournisseurModel?.raisonSociale}'),
        ),
      );
    }
  }

  Widget customPopupItemBuilderFournisseur(
      BuildContext context, fournisseurModel, bool isSelected) {
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
        title: Text(fournisseurModel?.raisonSociale ?? ''),
        subtitle: Text(fournisseurModel?.codeFr.toString() ?? ''),
      ),
    );
  }

  //client
  Widget customDropDownClient(BuildContext context, ClientModel? item) {
    if (clientModel == null) {
      return Container();
    } else {
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${clientModel?.nomClient}'),
          subtitle: Text('${clientModel?.codeclt}'),
        ),
      );
    }
  }

  Widget customPopupItemBuilderClient(
      BuildContext context, clientModel, bool isSelected) {
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
        title: Text(clientModel?.nomClient ?? ''),
        subtitle: Text(clientModel?.codeclt.toString() ?? ''),
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
}
