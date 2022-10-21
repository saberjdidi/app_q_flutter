import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qualipro_flutter/Controllers/visite_securite/visite_securite_controller.dart';
import 'package:qualipro_flutter/Models/employe_model.dart';
import 'package:qualipro_flutter/Models/visite_securite/checklist_model.dart';
import 'package:qualipro_flutter/Models/visite_securite/unite_model.dart';
import 'package:qualipro_flutter/Services/visite_securite/local_visite_securite_service.dart';
import 'package:qualipro_flutter/Services/visite_securite/visite_securite_service.dart';
import '../../Models/site_model.dart';
import '../../Models/visite_securite/equipe_model.dart';
import '../../Models/visite_securite/equipe_visite_securite_model.dart';
import '../../Models/visite_securite/zone_model.dart';
import '../../Route/app_route.dart';
import '../../Services/action/local_action_service.dart';
import '../../Utils/message.dart';
import '../../Utils/shared_preference.dart';
import '../../Utils/snack_bar.dart';

class NewVisiteSecuriteController extends GetxController {
  var isDataProcessing = false.obs;
  var isVisibleVisiteSecurite = true.obs;
  LocalActionService localActionService = LocalActionService();
  LocalVisiteSecuriteService localVisiteSecuriteService = LocalVisiteSecuriteService();
  final matricule = SharedPreference.getMatricule();
  final addItemFormKey = GlobalKey<FormState>();
  late TextEditingController dateVisiteController, situationObserveController, comportementSurObserveController, comportementRisqueObserveController, correctionImmediateController;

  DateTime datePickerVisite = DateTime.now();
  //CheckList
  CheckListModel? checkListModel = null;
  int? selectedIdCheckList = 0;
  String? checkList = "";
  //site
  var site_visible = 0.obs;
  late bool isVisibileSite;
  var site_obligatoire = 0.obs;
  SiteModel? siteModel = null;
  int? selectedCodeSite = 0;
  String? siteIncident = "";
  //unite
  UniteModel? uniteModel = null;
  int? selectedIdUnite = 0;
  String? unite = "";
  //zone
  ZoneModel? zoneModel = null;
  int? selectedIdZone = 0;
  String? zone = "";
  //equipe
  List<EquipeVisiteSecuriteModel> listEquipeVisiteSecurite = List<EquipeVisiteSecuriteModel>.empty(growable: true);
  List<EquipeModel> listEquipeSave = List<EquipeModel>.empty(growable: true);
  List<EquipeModel> listEquipeToList = List<EquipeModel>.empty(growable: true);
  List<EmployeModel?> listEquipe = List<EmployeModel?>.empty(growable: true);
  EmployeModel? employeModel = null;
  var etat = 1.obs;
  onChangeEtat(var valeur){
    etat.value = valeur;
    print('etat : ${etat.value}');
  }


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    dateVisiteController = TextEditingController();
    situationObserveController = TextEditingController();
    comportementSurObserveController = TextEditingController();
    comportementRisqueObserveController = TextEditingController();
    correctionImmediateController = TextEditingController();
    dateVisiteController.text = DateFormat('dd/MM/yyyy').format(datePickerVisite);

    getEquipeVisiteSecurite();

  }

  Future getEquipeVisiteSecurite() async {
    //keyRefresh.currentState?.show();
    //await Future.delayed(Duration(milliseconds: 4000));

    var response = await LocalVisiteSecuriteService().readEquipeVisiteSecurite();
    response.forEach((data){
      var model = EquipeVisiteSecuriteModel();
      model.affectation = data['affectation'];
      model.mat = data['mat'];
      model.nompre = data['nompre'];
      listEquipeVisiteSecurite.add(model);
      var modelToSave = EquipeModel();
      modelToSave.mat = data['mat'];
      modelToSave.affectation = data['affectation'];
      listEquipeSave.add(modelToSave);
      update();
      print('length equipe : ${listEquipeVisiteSecurite.length}');

    });
  }

  bool _dataValidation() {

    if (dateVisiteController.text.trim() == '' ) {
      Message.taskErrorOrWarning("Warning", "Date is required");
      return false;
    }
    else if (checkList == null) {
      Message.taskErrorOrWarning("Warning", "CheckList is required");
      return false;
    }
    else if (uniteModel == null) {
      Message.taskErrorOrWarning("Warning", "Unite is required");
      return false;
    }
    else if (siteModel == null) {
      Message.taskErrorOrWarning("Warning", "Site is required");
      return false;
    }
    return true;
  }

  selectedDate(BuildContext context) async {
    datePickerVisite = (await showDatePicker(
        context: context,
        initialDate: datePickerVisite,
        firstDate: DateTime(2021),
        lastDate: DateTime(2050)
      //lastDate: DateTime.now()
    ))!;
    if (datePickerVisite != null) {
      dateVisiteController.text = DateFormat('dd/MM/yyyy').format(datePickerVisite);
    }
  }

  Future saveBtn() async {
    if(_dataValidation() && addItemFormKey.currentState!.validate()){
      try {
        listEquipe.forEach((element) {
          print('list equipe : ${element?.mat.toString()} - ${element?.nompre}');
        });
        var connection = await Connectivity().checkConnectivity();
        if (connection == ConnectivityResult.none) {

        }
        else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
          //List<EquipeModel> jsonTags = jsonEncode(listEquipeSave);
          //print('jsonTags : ${listEquipeSave}');
         await VisiteSecuriteService().saveVisiteSecurite(
             {
            "idSite": selectedCodeSite,
            "dateVisite": dateVisiteController.text,
            "idUnite": selectedIdUnite,
            "idZone": selectedIdZone,
            "comportementObserve": comportementSurObserveController.text,
            "comportementRisque": comportementRisqueObserveController.text,
            "correctImmediate": correctionImmediateController.text,
            "autres": "",
            "idCHK": selectedIdCheckList,
            "stObserve": situationObserveController.text,
            "equipes": listEquipeSave
          }
          ).then((resp) {
            //Get.back();
            LocalVisiteSecuriteService().deleteTableEquipeVisiteSecurite();
            Get.toNamed(AppRoute.visite_securite);
            ShowSnackBar.snackBar("Successfully", "Visite Securite Added ", Colors.green);
            Get.find<VisiteSecuriteController>().listVisiteSecurite.clear();
            Get.find<VisiteSecuriteController>().getData();
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

  ///DropDown
  //checklist
  Widget customDropDownCheckList(BuildContext context, CheckListModel? item) {
    if (checkListModel == null) {
      return Container();
    }
    else{
      return Container(

        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${checkListModel?.checklist}', style: TextStyle(color: Colors.black),),
        ),
      );
    }
  }
  Widget customPopupItemBuilderCheckList(
      BuildContext context, checkListModel, bool isSelected) {
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
        title: Text(checkListModel?.checklist ?? ''),
        subtitle: Text(checkListModel?.code.toString() ?? ''),
      ),
    );
  }
  //unite
  Widget customDropDownUnite(BuildContext context, UniteModel? item) {
    if (uniteModel == null) {
      return Container();
    }
    else{
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${uniteModel?.unite}', style: TextStyle(color: Colors.black),),
        ),
      );
    }
  }
  Widget customPopupItemBuilderUnite(
      BuildContext context, uniteModel, bool isSelected) {
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
        title: Text(uniteModel?.unite ?? ''),
        subtitle: Text(uniteModel?.code.toString() ?? ''),
      ),
    );
  }
  //zone
  Widget customDropDownZone(BuildContext context, ZoneModel? item) {
    if (zoneModel == null) {
      return Container();
    }
    else{
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${zoneModel?.zone}', style: TextStyle(color: Colors.black),),
        ),
      );
    }
  }
  Widget customPopupItemBuilderZone(
      BuildContext context, zoneModel, bool isSelected) {
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
        title: Text(zoneModel?.zone ?? ''),
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
}