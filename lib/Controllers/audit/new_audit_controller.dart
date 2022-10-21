import 'dart:typed_data';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qualipro_flutter/Controllers/audit/audit_controller.dart';
import 'package:qualipro_flutter/Models/audit/champ_audit_model.dart';
import 'package:qualipro_flutter/Models/audit/type_audit_model.dart';
import 'package:qualipro_flutter/Models/employe_model.dart';
import 'package:qualipro_flutter/Services/audit/local_audit_service.dart';

import '../../Models/Domaine_affectation_model.dart';
import '../../Models/activity_model.dart';
import '../../Models/audit/audit_model.dart';
import '../../Models/direction_model.dart';
import '../../Models/processus_model.dart';
import '../../Models/service_model.dart';
import '../../Models/site_model.dart';
import '../../Services/action/local_action_service.dart';
import '../../Services/api_services_call.dart';
import '../../Services/audit/audit_service.dart';
import '../../Utils/message.dart';
import '../../Utils/shared_preference.dart';
import '../../Utils/snack_bar.dart';
import '../api_controllers_call.dart';

class NewAuditController extends GetxController {
  var isDataProcessing = false.obs;
  var isVisibleNewAudit = true.obs;
  LocalActionService localActionService = LocalActionService();
  LocalAuditService localAuditService = LocalAuditService();
  final matricule = SharedPreference.getMatricule();
  final addItemFormKey = GlobalKey<FormState>();

  TextEditingController descriptionController = TextEditingController();
  TextEditingController objectifController = TextEditingController();
  TextEditingController refInterneController = TextEditingController();
  TextEditingController dateDebutController = TextEditingController();
  TextEditingController dateFinController = TextEditingController();
  DateTime dateNow = DateTime.now();
  DateTime datePickerDebut = DateTime.now();
  DateTime datePickerFin = DateTime.now();

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
  //type audit
  TypeAuditModel? typeAuditModel = null;
  int? selectedCodeTypeAudit = 0;
  String? typeAudit = "";
  //types cause
  List<int> codeChampAuditList = [];
  List<String> champAuditList = [];
  List<EmployeModel> listEmployeValidation = [];
  List<ChampAuditModel> listChampAudit = [];

  //domaine affectation
  getDomaineAffectation() async {
    List<DomaineAffectationModel> domaineList = await List<DomaineAffectationModel>.empty(growable: true);
    var connection = await Connectivity().checkConnectivity();
    if (connection == ConnectivityResult.none) {
      var response = await localActionService.readDomaineAffectationByModule(
          "Audit", "Audit");
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
          if (model.module == "Audit" && model.fiche == "Audit") {
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
            ShowSnackBar.snackBar("Error Domaine Affectation", err.toString(), Colors.red);
          });
    }
  }

  bool _dataValidation() {
    if (datePickerDebut.isAfter(datePickerFin) && datePickerDebut != datePickerFin) {
      Message.taskErrorOrWarning("Warning", "La date Fin doit être supérieure ou égale à la date Début");
      return false;
    }
    else if(dateDebutController.text.trim() == ''){
      Message.taskErrorOrWarning("Warning", "Date début est obligatoire");
    }
    else if(dateFinController.text.trim() == ''){
      Message.taskErrorOrWarning("Warning", "Date fin est obligatoire");
    }
    else if (typeAuditModel == null) {
      Message.taskErrorOrWarning("Warning", "Type audit est obligatoire");
      return false;
    }
    else if (codeChampAuditList == null || codeChampAuditList == [] || codeChampAuditList.isEmpty || champAuditList.isEmpty) {
      Message.taskErrorOrWarning("Warning", "Champ Audit est obligatoire");
      return false;
    }
    else if (site_visible.value == 1 && site_obligatoire.value == 1 && siteModel == null) {
      Message.taskErrorOrWarning("Warning", "Site est obligatoire");
      return false;
    }
    else if (processus_visible.value == 1 && processus_obligatoire.value == 1 && processusModel == null) {
      Message.taskErrorOrWarning("Warning", "Processus est obligatoire");
      return false;
    }
    else if (direction_visible.value == 1 && direction_obligatoire.value == 1 &&
        directionModel == null) {
      Message.taskErrorOrWarning("Warning", "Direction est obligatoire");
      return false;
    }
    else if (service_visible.value == 1 && service_obligatoire.value == 1 &&
        serviceModel == null) {
      Message.taskErrorOrWarning("Warning", "Service est obligatoire");
      return false;
    }
    else if (activity_visible.value == 1 && activity_obligatoire.value == 1 &&
        activityModel == null) {
      Message.taskErrorOrWarning("Warning", "Activity est obligatoire");
      return false;
    }

    return true;
  }

  @override
  void onInit() {
    super.onInit();
    getDomaineAffectation();
    dateDebutController.text = DateFormat('yyyy-MM-dd').format(datePickerDebut);
    dateFinController.text = DateFormat('yyyy-MM-dd').format(datePickerFin);
  }

  selectedDateDebut(BuildContext context) async {
    datePickerDebut = (await showDatePicker(
        context: context,
        initialDate: datePickerDebut,
        firstDate: DateTime(2021),
        lastDate: DateTime(2100)
      //lastDate: DateTime.now()
    ))!;
    if(datePickerDebut != null){
      dateDebutController.text = DateFormat('yyyy-MM-dd').format(datePickerDebut);
      //dateDebutController.text = DateFormat.yMMMMd().format(datePickerDebut);
    }
  }

  selectedDateFin(BuildContext context) async {
    datePickerFin = (await showDatePicker(
        context: context,
        initialDate: datePickerFin,
        firstDate: DateTime(2021),
        lastDate: DateTime(2100)
      //firstDate: datePickerDebut,
      //lastDate: DateTime.now()
    ))!;
    if(datePickerFin != null){
      dateFinController.text = DateFormat('yyyy-MM-dd').format(datePickerFin);
    }
  }
  
  Future saveBtn() async {

    if(_dataValidation() && addItemFormKey.currentState!.validate()) {
      try {
        int? max_idAudit = await localAuditService.getMaxNumAudit();
        int? idAuditMax = max_idAudit! + 1;
        String refAuditMax = '00000'+idAuditMax.toString();
        if(kDebugMode) print('max_idAudit : $idAuditMax, refAuditMax :$refAuditMax');

        var connection = await Connectivity().checkConnectivity();
        if(connection == ConnectivityResult.none){
          Uint8List? bytesCodeChampList = Uint8List.fromList(codeChampAuditList);
          var model = AuditModel();
          model.online = 0;
          model.idAudit = idAuditMax;
          model.refAudit = refAuditMax;
          model.dateDebPrev = dateDebutController.text;
          model.dateFinPrev = dateFinController.text;
          model.dateDeb = '';
          model.etat = 1;
          model.validation = 1;
          model.site = siteIncident;
          model.interne = refInterneController.text;
          model.cloture = '';
          model.typeA = typeAudit;
          model.codeTypeA = selectedCodeTypeAudit;
          model.audit = descriptionController.text;
          model.objectif = objectifController.text;
          model.rapportClot = '';
          model.codeSite = selectedCodeSite;
          model.idProcess = selectedCodeProcessus;
          model.idDomaine = selectedCodeActivity;
          model.idDirection = selectedCodeDirection;
          model.idService = selectedCodeService;
          model.champ = champAuditList.toString();
          model.listCodeChamp = bytesCodeChampList;

          if(kDebugMode) print('audit : ${idAuditMax}-${refAuditMax}-${model.champ}-${model.listCodeChamp}-${model.audit}-Processus:$selectedCodeProcessus');
          
          await localAuditService.saveAuditSync(model);

          listChampAudit.forEach((element) async {
            debugPrint('champ audit : ${refAuditMax} - ${element.codeChamp} - ${element.champ}');
            var modelChampAudit = ChampAuditModel();
            modelChampAudit.online = 0;
            modelChampAudit.codeChamp = element.codeChamp;
            modelChampAudit.champ = element.champ;
            modelChampAudit.criticite = '';
            modelChampAudit.refAudit = refAuditMax;
            await localAuditService.saveChampAuditConstat(modelChampAudit);
          });
          //save champs audit

          Get.back();
          ShowSnackBar.snackBar("Successfully", "Audit Added ", Colors.green);
          Get.find<AuditController>().listAudit.clear();
          Get.find<AuditController>().getData();
        }
        else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile){
       // print('codeChampAuditList : $codeChampAuditList');
          await AuditService().saveAudit({
            "descriptionAudit": descriptionController.text,
            "dateDebutPrev": dateDebutController.text,
            "dateFinPrev": dateFinController.text,
            "objectif": objectifController.text,
            "codeTypeAudit": selectedCodeTypeAudit,
            "codeSite": selectedCodeSite,
            "refInterne": refInterneController.text,
            "matDeclencheur": matricule.toString(),
            "processus": selectedCodeProcessus,
            "domaine": selectedCodeActivity,
            "direction": selectedCodeDirection,
            "service": selectedCodeService,
            "codesChamps": codeChampAuditList
          }).then((response) async {
            String? refAudit = response['refAudit'];
            print('refAudit : $refAudit');
             //geeting employes of type audit
              await AuditService().verifierRapportAuditParMode({
                "refAudit": "",
                "mat": "",
                "codeChamp": selectedCodeTypeAudit.toString(),
                "mode": "Cons_Param_valid"
              }).then((response2) async {
                  //insert employe validation
                response2.forEach((element) async {
                     var employe = new EmployeModel();
                     employe.mat = element['matricule'];
                     employe.nompre = element['nompre'];
                     listEmployeValidation.add(employe);
                     print('Matricule : ${element['matricule']} - Nompre : ${element['nompre']}');

                     await AuditService().ajoutEnregEmpValidAudit({
                       "refAudit": refAudit,
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

            Get.back();
            ShowSnackBar.snackBar("Successfully", "Audit Added ", Colors.green);
            Get.find<AuditController>().listAudit.clear();
            Get.find<AuditController>().getData();
            await ApiControllersCall().getAudits();
          },
              onError: (error){
                isDataProcessing(false);
                print('Error : ${error.toString()}');
                ShowSnackBar.snackBar("Error", error.toString(), Colors.red);
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

  //dropdown
  //type
  Widget customDropDownType(BuildContext context, TypeAuditModel? item) {
    if (typeAuditModel == null) {
      return Container();
    }
    else{
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${typeAuditModel?.type}', style: TextStyle(color: Colors.black),),
        ),
      );
    }
  }
  Widget customPopupItemBuilderType(
      BuildContext context, typeAuditModel, bool isSelected) {
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
        title: Text(typeAuditModel?.type ?? ''),
        subtitle: Text(typeAuditModel?.codeType.toString() ?? ''),
      ),
    );
  }
  //champ audit
  Widget customDropDownMultiSelectionChampAudit(
      BuildContext context, List<ChampAuditModel?> selectedItems) {
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
              title: Text(e?.champ ?? ''),

            ),
          ),
        );
      }).toList(),
    );
  }
  Widget customPopupItemBuilderChampAudit(
      BuildContext context, ChampAuditModel? item, bool isSelected) {
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
        title: Text(item?.champ ?? ''),
        subtitle: Text(item?.codeChamp?.toString() ?? ''),
        leading: CircleAvatar(
          // this does not work - throws 404 error
          // backgroundImage: NetworkImage(item.avatar ?? ''),
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
}