import 'dart:convert';
import 'dart:typed_data';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qualipro_flutter/Models/champ_cache_model.dart';
import 'package:qualipro_flutter/Models/employe_model.dart';
import 'package:qualipro_flutter/Models/resp_cloture_model.dart';
import '../../Models/Domaine_affectation_model.dart';
import '../../Models/action/action_model.dart';
import '../../Models/action/action_sync.dart';
import '../../Models/activity_model.dart';
import '../../Models/audit_action_model.dart';
import '../../Models/direction_model.dart';
import '../../Models/processus_model.dart';
import '../../Models/product_model.dart';
import '../../Models/service_model.dart';
import '../../Models/site_model.dart';
import '../../Models/action/source_action_model.dart';
import '../../Models/action/type_action_model.dart';
import '../../Models/type_cause_model.dart';
import '../../Route/app_route.dart';
import '../../Services/action/action_service.dart';
import '../../Services/action/local_action_service.dart';
import '../../Services/api_services_call.dart';
import '../../Utils/message.dart';
import '../../Utils/shared_preference.dart';
import '../../Utils/snack_bar.dart';
import '../api_controllers_call.dart';
import '../sync_data_controller.dart';

class ActionController extends GetxController {

  var listAction = List<ActionModel>.empty(growable: true).obs;
  //List<ActionModel> listAction = List<ActionModel>.empty(growable: true);
  var filterAction = List<ActionModel>.empty(growable: true);
  var isDataProcessing = false.obs;
  var isVisibleNewAction = true.obs;
  //ActionService actionService = ActionService();
  LocalActionService localActionService = LocalActionService();
  String Nact = "";
  final countActionLocal = LocalActionService().getCountActionSync();

  //add action
  final addItemFormKey = GlobalKey<FormState>();
  late TextEditingController declencheurController, dateController, dateSaisieController, actionController, descriptionController,
      causeController, commentaireController, refInterneController, objectifController;
  DateTime dateTime = DateTime.now();
  final declencheur = SharedPreference.getNomPrenom();
  final matricule = SharedPreference.getMatricule();
  final currentYear = DateFormat.y().format(DateTime.now());
  
  //type
  int? selectedCodeTypeAct = 0;
  TypeActionModel? typeActionModel = null;
  //source
  int? selectedCodeSourceAct = 0;
  SourceActionModel? sourceActionModel = null;
  //ref audit
  String? selectedRefAuditAct = "";
  int? selectedIdAudit = 0;
  AuditActionModel? auditActionModel = null;
  int? ref_audit_visible = 1;
  bool isVisibileRefAudit = true;
  //resp cloture
  String? selectedRespClotureCode = "";
  RespClotureModel? respClotureModel = null;
  //employe
  String? selectedResSuiviCode = "";
  String? selectedOriginActionMat = "";
  EmployeModel? employeModel = null;
  EmployeModel? resSuiviModel = null;
  //site
  int? site_visible;
  //var site_visible = 1.obs;
  late bool isVisibileSite;
  int? site_obligatoire;
  int? selectedSiteCode = 0;
  SiteModel? siteModel = null;
  //processus
  int? processus_visible;
  late bool isVisibileProcessus;
  int? processus_obligatoire;
  int? selectedProcessusCode = 0;
  ProcessusModel? processusModel = null;
  //activity
  int? activity_visible;
  late bool isVisibileActivity;
  int? activity_obligatoire;
  int? selectedActivityCode = 0;
  ActivityModel? activityModel = null;
  //direction
  int? direction_visible;
  late bool isVisibileDirection;
  int? direction_obligatoire;
  int? selectedDirectionCode = 0;
  DirectionModel? directionModel = null;
  //service
  int? service_visible;
  late bool isVisibileService;
  int? service_obligatoire;
  int? selectedServiceCode = 0;
  ServiceModel? serviceModel = null;
  //product
  //List<String> productList = [];
  //int? product_visible = 1;
  //bool isVisibileProduct = true;
  //types cause
  List<int?> typeCauseList = [];
  List<TypeCauseModel> listTypeCauseOffline = [];
  int? type_cause_visible = 1;
  bool isVisibileTypeCause = true;
  //visibility champ cache
  int? ref_interne_visible = 1;
  bool isVisibileRefInterne = true;
  int? objectif_visible = 1;
  bool isVisibileObjectif = true;
  int? origine_action_visible = 1;
  bool isVisibileOrigineAction = true;
  int? date_saisie_visible = 1;
  bool isVisibileDateSaisie = true;

  //search
  TextEditingController searchNumAction = TextEditingController();
  TextEditingController searchAction = TextEditingController();
  String? searchType = "";

  //domaine affectation
  getDomaineAffectation() async {
    List<DomaineAffectationModel> domaineList = await List<DomaineAffectationModel>.empty(growable: true);
    var connection = await Connectivity().checkConnectivity();
    if (connection == ConnectivityResult.none) {
      var response = await localActionService.readDomaineAffectationByModule(
          "Action", "Action"); //Demande action
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

        print('fiche: ${model.fiche}, site visible :${site_visible}, site obligatoire :${site_obligatoire}');
        site_visible = model.vSite!;
        processus_visible = model.vProcessus;
        activity_visible = model.vDomaine;
        direction_visible = model.vDirection;
        service_visible = model.vService;
        //print('visibility site: $site_visible');
        site_obligatoire = model.oSite!;
        processus_obligatoire = model.oProcessus;
        activity_obligatoire = model.oDomaine;
        direction_obligatoire = model.oDirection;
        service_obligatoire = model.oService;
      });
    }
    else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
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
          if(model.module == "Action" && model.fiche == "Action"){
            site_visible = model.vSite!;
            processus_visible = model.vProcessus;
            activity_visible = model.vDomaine;
            direction_visible = model.vDirection;
            service_visible = model.vService;
            //print('visibility site: $site_visible');
            site_obligatoire = model.oSite!;
            processus_obligatoire = model.oProcessus;
            activity_obligatoire = model.oDomaine;
            direction_obligatoire = model.oDirection;
            service_obligatoire = model.oService;
            print('fiche: ${model.fiche}, site visible :${site_visible}, site obligatoire :${site_obligatoire}');
          }
        });
      }
          , onError: (err) {
            ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
          });
    }
  }
  //champ cache
  getChampCache() async {
    try {
      List<ChampCacheModel> listChampCache = await List<ChampCacheModel>.empty(
          growable: true);
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        var response = await localActionService.readChampCacheByModule(
            "Action", "Fiche Action"); //Demande action
        response.forEach((data) {
          print(
              'module : ${data['module']}, nom_param:${data['nomParam']}, visible:${data['visible']}');
          var model = ChampCacheModel();
          model.id = data['id'];
          model.module = data['module'];
          model.fiche = data['fiche'];
          model.listOrder = data['listOrder'];
          model.nomParam = data['nomParam'];
          model.visible = data['visible'];
          listChampCache.add(model);

          if (model.nomParam == "Date saisie" && model.module == "Action" &&
              model.fiche == "Fiche Action") {
            date_saisie_visible = model.visible;
            //date_saisie_visible = 0;
          }
         /* else if (model.nomParam == "Produit" && model.module == "Action" &&
              model.fiche == "Fiche Action") {
            product_visible = model.visible;
            //product_visible = 0;
          } */
          else
          if (model.nomParam == "Types de causes" && model.module == "Action" &&
              model.fiche == "Fiche Action") {
            type_cause_visible = model.visible;
          }
          else if (model.nomParam == "Objectif" && model.module == "Action" &&
              model.fiche == "Fiche Action") {
            objectif_visible = model.visible;
            //objectif_visible = 0;
          }
          else if (model.nomParam == "Réf audit" && model.module == "Action" &&
              model.fiche == "Fiche Action") {
            ref_audit_visible = model.visible;
            //ref_audit_visible = 0;
          }
          else if (model.nomParam == "A l'origine de l'action" &&
              model.module == "Action" && model.fiche == "Fiche Action") {
            origine_action_visible = model.visible;
            //origine_action_visible = 0;
          }
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        await ApiServicesCall().getChampCache({
          "module": "Action",
          "fiche": "Fiche Action"
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
            listChampCache.add(model);

            if (model.nomParam == "Date saisie" && model.module == "Action" &&
                model.fiche == "Fiche Action") {
              date_saisie_visible = model.visible;
              //date_saisie_visible = 0;
            }
           /* else if (model.nomParam == "Produit" && model.module == "Action" &&
                model.fiche == "Fiche Action") {
              product_visible = model.visible;
              //product_visible = 0;
            } */
            else if (model.nomParam == "Types de causes" && model.module == "Action" &&
                model.fiche == "Fiche Action") {
              type_cause_visible = model.visible;
            }
            else if (model.nomParam == "Objectif" && model.module == "Action" &&
                model.fiche == "Fiche Action") {
              objectif_visible = model.visible;
              //objectif_visible = 0;
            }
            else if (model.nomParam == "Réf audit" && model.module == "Action" &&
                model.fiche == "Fiche Action") {
              ref_audit_visible = model.visible;
              //ref_audit_visible = 0;
            }
            else if (model.nomParam == "A l'origine de l'action" &&
                model.module == "Action" && model.fiche == "Fiche Action") {
              origine_action_visible = model.visible;
              //origine_action_visible = 0;
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

  bool _dataValidation(){
    if(actionController.text.trim()==''){
      Message.taskErrorOrWarning("Alert", "Designation is required");
      return false;
    }
    else if(dateController.text.trim()==''){
      Message.taskErrorOrWarning("Alert", "Date is required");
      return false;
    }
    else if(typeActionModel == null){
      Message.taskErrorOrWarning("Alert", "Type is required");
      return false;
    }
    else if(sourceActionModel == null){
      Message.taskErrorOrWarning("Alert", "Source is required");
      return false;
    }
    else if(site_visible == 1 && site_obligatoire == 1 && siteModel == null){
      Message.taskErrorOrWarning("Alert", "Site is required");
      return false;
    }
    else if(processus_visible == 1 && processus_obligatoire == 1 && processusModel == null){
      Message.taskErrorOrWarning("Alert", "Processus is required");
      return false;
    }
    else if(direction_visible == 1 && direction_obligatoire == 1 && directionModel == null){
      Message.taskErrorOrWarning("Alert", "Direction is required");
      return false;
    }
    else if(service_visible == 1 && service_obligatoire == 1 && serviceModel == null){
      Message.taskErrorOrWarning("Alert", "Service is required");
      return false;
    }
    else if(activity_visible == 1 && activity_obligatoire == 1 && activityModel == null){
      Message.taskErrorOrWarning("Alert", "Activity is required");
      return false;
    }
    return true;
  }
  selectedDate(BuildContext context) async {
    var datePicker = await showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime.now()
      //lastDate: DateTime.now()
    );
    if(datePicker != null){
      dateTime = datePicker;
      dateController.text = DateFormat('yyyy-MM-dd').format(datePicker);
      //dateController.text = DateFormat.yMMMMd().format(datePicker);
    }
  }

  @override
  void onInit() async {
    super.onInit();
    getActions();

    //search
    searchNumAction.text = '';
    searchAction.text ='';
    searchType = '';
    //add action
    declencheurController = TextEditingController();
    dateController = TextEditingController();
    dateSaisieController = TextEditingController();
    actionController = TextEditingController();
    descriptionController = TextEditingController();
    causeController = TextEditingController();
    commentaireController = TextEditingController();
    refInterneController = TextEditingController();
    objectifController = TextEditingController();
    dateController.text = DateFormat('yyyy-MM-dd').format(dateTime);
    dateSaisieController.text = DateFormat('yyyy-MM-dd').format(dateTime);
    declencheurController.text = declencheur.toString();

    getDomaineAffectation();
    getChampCache();
    checkConnectivity();
  }

  @override
  void onClose() {
    actionController.dispose();
    descriptionController.dispose();
  }
  Future<void> checkConnectivity() async {
    var connection = await Connectivity().checkConnectivity();
    print('count: ${countActionLocal}');
    if (connection == ConnectivityResult.none) {
      Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.BOTTOM);
    }
    else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
      Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.BOTTOM);
     /* if(countActionLocal > 0){
          ShowSnackBar.snackBar("Synchronization", " data synchronized", Colors.cyan.shade400);
          await syncActionToWebService();
        } */
     // await syncActionToWebService();
    }
  }

  void getActions() async {
    try {
      isDataProcessing.value = true;
      //check connection internet
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none){
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        //get local data
        var response;
        if(searchNumAction.text == '' && searchAction.text == '' && searchType == ''){
          response = await localActionService.readAction();
          print('get actions');
        }
        else {
          response = await localActionService.searchAction(searchNumAction.text, searchAction.text, searchType);
          print('search actions');
        }
        response.forEach((data){
          //print('id action : ${data['nAct']}');
          //print('id action int : ${int.parse(data['nAct'].toString())}');
          var model = ActionModel();
          /*num nact_data = data['nAct'];
          num online_data = data['online'];
          print('nact data : ${nact_data}');
          print('online data : ${online_data}');


          if(nact_data * online_data == 0){
            num maxAction = localActionService.readNActionMax();
            print("maxAction ${maxAction}");
            //int? model_nact = maxAction.toInt() + int.parse(data['nAct'].toString());// + data['nAct'];

            num result_data = maxAction+nact_data;
            print('result data : ${result_data}');
            model.nAct = result_data.toInt();
            print('nact offline : ${model.nAct}');
          }
          else{
            model.nAct=data['nAct'];
            print('nact online: ${model.nAct}');
          } */
          model.nAct = data['nAct'];
          model.site = data['site'];
          model.sourceAct = data['sourceAct'];
          model.typeAct = data['typeAct'];
          model.cloture = data['cloture'];
          model.date = data['date'];
          model.act = data['act'];
          model.nomOrigine = data['nomOrigine'];
          model.respClot = data['respClot'];
          model.idAudit = data['idAudit'];
          model.actionPlus0 = data['actionPlus0'];
          model.actionPlus1 = data['actionPlus1'];
          //model.datsuivPrv = data['datsuivPrv'];
          model.online = data['online'];
          //print('get fullname ${model.act}');
          listAction.add(model);
          //isDataProcessing(false);
          searchNumAction.clear();
          searchAction.clear();
          searchType = '';
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        //rest api
        await ActionService().getActionMethod2({
          "nact": searchNumAction.text,
          "act": searchAction.text,
          "refaud": "",
          "mat": matricule.toString(),
          "action_plus0": "",
          "action_plus1": "",
          "typeAction": searchType
        }).then((resp) async {
          //isDataProcessing(false);
          resp.forEach((data) async {
            print('get actions : ${data} ');
            var model = ActionModel();
            model.nAct = data['nAct'];
            model.site = data['site'];
            model.sourceAct = data['sourceAct'];
            model.typeAct = data['typeAct'];
            model.date = data['date'];
            model.cloture = data['cloture'];
            model.act = data['act'];
            model.nomOrigine = data['nom_origine'];
            model.respClot = data['resp_clot'];
            model.fSimp = data['fSimp'];
            model.idAudit = data['idAudit'];
            model.actionPlus0 = data['action_plus0'];
            model.actionPlus1 = data['action_plus1'];
            //model.datsuivPrv = data['datsuiv_prv'];
            model.online = 1;

            listAction.add(model);
            listAction.forEach((element) {
              print('element act ${element.act}');
            });

            searchNumAction.clear();
            searchAction.clear();
            searchType = '';
          });
          print('get data');
        }
            , onError: (err) {
              isDataProcessing.value = false;
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });

       /* listAction = await ActionService().getAction(searchNumAction.text, searchAction.text, matricule.toString(), searchType) as List<ActionModel>;
        searchNumAction.clear();
        searchAction.clear();
        searchType = ''; */
      }

    } catch (exception) {
      isDataProcessing.value = false;
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      print('Exception action : ${exception.toString()}');
    }
    finally {
      isDataProcessing.value = false;
    }
  }

  Future saveBtn() async {
    if(_dataValidation() && addItemFormKey.currentState!.validate()){
      try {
        //print('code products : ${productList}');
        //currentYear = DateFormat.y().format(dateTime);
        saveAction(
            {
              "action": actionController.text.trim(),
              "typea": selectedCodeTypeAct,
              "codesource": selectedCodeSourceAct,
              "refAudit": selectedRefAuditAct,
              "descpb": descriptionController.text.trim(),
              "cause": causeController.text.trim(),
              "datepa": dateController.text,
              "cloture": 0,
              "codesite": selectedSiteCode,
              "matdeclencheur": matricule.toString(),
              "commentaire": commentaireController.text.trim(),
              "respsuivi": selectedResSuiviCode,
              "nfiche": 0,
              "imodule": 0,
              "datesaisie": dateSaisieController.text,
              "mat_origine": selectedOriginActionMat,
              "objectif": objectifController.text.trim(),
              "respclot": selectedRespClotureCode,
              "annee": currentYear,
              "ref_interne": refInterneController.text.trim(),
              "direction": selectedDirectionCode,
              "metier": 0,
              "theme": 0,
              "process": selectedProcessusCode,
              "domaine": selectedActivityCode,
              "service": selectedServiceCode,
              //"prod": productList,
              "typesCauses": typeCauseList
            }
        );

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
  Future<void> saveAction(Map data) async {
    try {
      isDataProcessing(true);
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
       /* //var response_action_sync_before = await localActionService.readIdActionSyncMax();
        //List<String> servicesList = ["one", "Two", "Thee"];
        //String serviceString = servicesList.join(", ");

        //var b = (serviceString.split(','));
        //print('ab : ${b}');
        //var ab = json.decode(serviceString);
        //print('service list join decode : ${ab[0]}'); */

        //String productString = data['prod'].join(",");
        //print('productString join : ${productString}');
        Uint8List? bytesTypeCause = Uint8List.fromList(data['typesCauses']);
        //save action sync
        var modelSync = ActionSync();
        modelSync.action = data['action'];
        modelSync.typea = data['typea'];
        modelSync.codesource = data['codesource'];
        modelSync.refAudit = data['refAudit'];
        modelSync.descpb = data['descpb'];
        modelSync.cause = data['cause'];
        modelSync.datepa = data['datepa'];
        modelSync.cloture = data['cloture'];
        modelSync.codesite = data['codesite'];
        //modelSync.matdeclencheur = data['matdeclencheur'];
        modelSync.commentaire = data['commentaire'];
        modelSync.respsuivi = data['respsuivi'];
        modelSync.datesaisie = data['datesaisie'];
        modelSync.matOrigine = data['mat_origine'];
        modelSync.objectif = data['objectif'];
        modelSync.respclot = data['respclot'];
        modelSync.annee = int.parse(data['annee']);
        modelSync.refInterne = data['ref_interne'];
        modelSync.direction = data['direction'];
        modelSync.process = data['process'];
        modelSync.domaine = data['domaine'];
        modelSync.service = data['service'];
        //modelSync.listProduct = productString;
        modelSync.listTypeCause = bytesTypeCause;
        //save data in local db
        await localActionService.saveActionSync(modelSync);
        print('Inserting action sync : ${modelSync.action}, listTypeCause: ${modelSync.listTypeCause}');

        int max_num_action = await localActionService.getMaxNumAction();
        //save data in local db
        var model = ActionModel();
        model.nAct = max_num_action+1;
        model.site = siteModel?.site;
        model.sourceAct = sourceActionModel?.sourceAct;
        model.typeAct = typeActionModel?.typeAct;
        model.cloture = 0;
        model.date = dateController.text;
        model.act = actionController.text.trim();
        //model.tauxEff = 0;
        //model.tauxRea = 0;
        model.nomOrigine = employeModel?.nompre;
        model.respClot = 0;
        model.fSimp = 0;
        model.idAudit = selectedIdAudit;
        model.actionPlus0 = "";
        model.actionPlus1 = "";
        model.online = 0;
        await localActionService.saveAction(model);

        //save type cause in db local
        listTypeCauseOffline.forEach((element) async {
          int max_type_cause = await LocalActionService().getMaxNumTypeCauseAction();
          var model = TypeCauseModel();
          model.online = 3;
          model.nAct = max_num_action+1;
          model.idTypeCause = max_type_cause+1;
          model.codetypecause = element.codetypecause;
          model.typecause = element.typecause;
          await LocalActionService().saveTypeCauseAction(model);
        });


        Get.back();
        listAction.clear();
        getActions();
        //refreshList();
        Get.snackbar("Mode Offline", "Action Successfully", colorText: Colors.blue,
            snackPosition: SnackPosition.TOP);
        //Get.toNamed(AppRoute.action);
        clearData();
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        await ActionService().saveAction(data).then((resp) {
          Get.back();
          listAction.clear();
          getActions();
          ShowSnackBar.snackBar("Add Action", "Action Added", Colors.green);
          //Get.toNamed(AppRoute.action);
          clearData();
        }, onError: (err) {
          isDataProcessing(false);
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
          print('Error : ${err.toString()}');
        });
      }

    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      print('Exception : ${exception.toString()}');
    }
    finally{
      isDataProcessing(false);
      //Get.back();
    }
  }

  clearData() {
    //onInit();
    actionController.clear();
    dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    descriptionController.clear();
    commentaireController.clear();
    causeController.clear();
    objectifController.clear();
    refInterneController.clear();
    activityModel = null;
    selectedActivityCode = 0;
    typeActionModel = null;
    selectedCodeTypeAct = 0;
    sourceActionModel = null;
    selectedCodeSourceAct = 0;
    selectedRefAuditAct = "";
    selectedIdAudit = 0;
    auditActionModel = null;
    selectedRespClotureCode = "";
    respClotureModel = null;
    selectedSiteCode = 0;
    siteModel = null;
    selectedProcessusCode = 0;
    processusModel = null;
    selectedResSuiviCode = "";
    selectedOriginActionMat = "";
    employeModel = null;
    resSuiviModel = null;
    selectedDirectionCode = 0;
    directionModel = null;
    selectedServiceCode = 0;
    serviceModel = null;
    //productList = [];
    typeCauseList = [];
  }

  //synchronization
  Future syncActionToWebService() async {
    try {
      isDataProcessing(true);
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        Get.snackbar("No Connection", "Cannot synchronize Data", colorText: Colors.blue,
            snackPosition: SnackPosition.TOP);
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {

        //sync from db local to sql server
        await SyncDataController().syncActionToSQLServer();
        await SyncDataController().syncSousActionToSQLServer();
        await SyncDataController().syncTypeCauseActionToSQLServer();
          //listAction.clear();
          //getActions();
        //save data in db local
        //await ApiControllersCall().getAction();
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
            print('Inserting data in table Action : ${model.act} - nact:${model.nAct}');

          });
          listAction.clear();
          getActions();
        }
            , onError: (err) {
              isDataProcessing.value = false;
              ShowSnackBar.snackBar("Error Action", err.toString(), Colors.red);
            });

        await ApiControllersCall().getAllSousAction();
        await ApiControllersCall().getTypeCauseAction();
      }
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    }
    finally{
      isDataProcessing(false);
    }
  }

  //Widgets add action
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
  //source action
  Widget customDropDownSource(BuildContext context, SourceActionModel? item) {
    if (sourceActionModel == null) {
      return Container();
    }
    else{
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${sourceActionModel?.sourceAct}'),
        ),
      );
    }
  }
  Widget customPopupItemBuilderSource(
      BuildContext context, sourceActionModel, bool isSelected) {
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
        title: Text(sourceActionModel?.sourceAct ?? ''),
        //subtitle: Text(item?.TypeAct ?? ''),
      ),
    );
  }
  //type action
  Widget customDropDownType(BuildContext context, TypeActionModel? item) {
    if (typeActionModel == null) {
      return Container();
    }
    else{
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${typeActionModel?.typeAct}', style: TextStyle(color: Colors.black),),
        ),
      );
    }
  }
  Widget customPopupItemBuilderType(
      BuildContext context, typeActionModel, bool isSelected) {
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
        title: Text(typeActionModel?.typeAct ?? ''),
        //subtitle: Text(item?.TypeAct ?? ''),
      ),
    );
  }
  //ref audit
  Widget customDropDownRefAudit(BuildContext context, AuditActionModel? item) {
    if (auditActionModel == null) {
      return Container();
    }
    else{
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${auditActionModel?.idaudit}', style: TextStyle(color: Colors.black),),
        ),
      );
    }
  }
  Widget customPopupItemBuilderRefAudit(
      BuildContext context, auditActionModel, bool isSelected) {
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
        title: Text(auditActionModel?.refAudit ?? ''),
        subtitle: Text(auditActionModel?.idaudit.toString() ?? ''),
      ),
    );
  }
  //resp cloture
  Widget customDropDownRespCloture(BuildContext context, RespClotureModel? item) {

    if (respClotureModel == null) {
      return Container();
    }
    else{
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${respClotureModel?.nompre}', style: TextStyle(color: Colors.black)),
        ),
      );
    }
  }
  Widget customPopupItemBuilderRespCloture(
      BuildContext context, respClotureModel, bool isSelected) {
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
        title: Text(respClotureModel?.nompre ?? ''),
        subtitle: Column(
          children: [
            Text(respClotureModel?.site.toString() ?? ''),
            Text(respClotureModel?.processus.toString() ?? '')
          ],
        ),
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
  Widget customDropDownRespSuivi(BuildContext context, EmployeModel? item) {
    if (resSuiviModel == null) {
      return Container();
    }
    else{
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${resSuiviModel?.nompre}', style: TextStyle(color: Colors.black)),
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
  //products
  Widget customDropDownMultiSelectionProduct(
      BuildContext context, List<ProductModel?> selectedItems) {
    if (selectedItems.isEmpty) {
      return ListTile(
        contentPadding: EdgeInsets.all(0),
        //leading: CircleAvatar(),
        title: Text("No item selected"),
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
              title: Text(e?.produit ?? ''),

            ),
          ),
        );
      }).toList(),
    );
  }
  Widget customPopupItemBuilderProduct(
      BuildContext context, ProductModel? item, bool isSelected) {
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
        title: Text(item?.produit ?? ''),
        subtitle: Text(item?.codePdt?.toString() ?? ''),
        leading: CircleAvatar(
          // this does not work - throws 404 error
          // backgroundImage: NetworkImage(item.avatar ?? ''),
        ),
      ),
    );
  }
  //types causes
  Widget customDropDownMultiSelectionTypeCause(
      BuildContext context, List<TypeCauseModel?> selectedItems) {
    if (selectedItems.isEmpty) {
      return ListTile(
        contentPadding: EdgeInsets.all(0),
        //leading: CircleAvatar(),
        title: Text("No item selected"),
      );
    }

    return Wrap(
      children: selectedItems.map((e) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            child: ListTile(
              contentPadding: EdgeInsets.all(0),
              title: Text(e?.typecause ?? ''),

            ),
          ),
        );
      }).toList(),
    );
  }
  Widget customPopupItemBuilderTypeCause(
      BuildContext context, TypeCauseModel? item, bool isSelected) {
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
        title: Text(item?.typecause ?? ''),
        subtitle: Text(item?.codetypecause?.toString() ?? ''),
        leading: CircleAvatar(
          // this does not work - throws 404 error
          // backgroundImage: NetworkImage(item.avatar ?? ''),
        ),
      ),
    );
  }
}