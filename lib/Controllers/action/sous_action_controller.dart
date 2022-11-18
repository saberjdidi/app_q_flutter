import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qualipro_flutter/Models/champ_obligatoire_action_model.dart';
import 'package:qualipro_flutter/Models/gravite_model.dart';
import 'package:qualipro_flutter/Models/priorite_model.dart';
import 'package:qualipro_flutter/Models/action/sous_action_model.dart';
import '../../Models/employe_model.dart';
import '../../Models/processus_employe_model.dart';
import '../../Services/action/action_service.dart';
import '../../Services/action/local_action_service.dart';
import '../../Services/api_services_call.dart';
import '../../Utils/message.dart';
import '../../Utils/shared_preference.dart';
import '../../Utils/snack_bar.dart';
import '../sync_data_controller.dart';

class SousActionController extends GetxController {
  var listSousAction = List<SousActionModel>.empty(growable: true).obs;
  var isDataProcessing = false.obs;
  LocalActionService localActionService = LocalActionService();

  int? id_action;
  int? cout_prev;

  //add sous action
  final addItemFormKey = GlobalKey<FormState>();
  late TextEditingController delaiRealisationController,
      delaiSuiviController,
      designationController,
      risqueController,
      coutPrevController;
  DateTime datePickerReal = DateTime.now();
  DateTime datePickerSuivi = DateTime.now();
  final declencheur = SharedPreference.getNomPrenom();
  final matricule = SharedPreference.getMatricule();

  //priorite
  int? selectedCodePriorite = 0;
  PrioriteModel? prioriteModel = null;
  late int? priorite_obligatoire;
  //gravite
  int? selectedCodeGravite = 0;
  GraviteModel? graviteModel = null;
  late int? gravite_obligatoire;
  //processus
  int? selectedProcessusCode = 0;
  ProcessusEmployeModel? processusModel = null;
  //resp suivi
  String? selectedResSuiviCode = "";
  EmployeModel? resSuiviModel = null;
  late int? delai_suivi_obligatoire;
  //resp real
  String? selectedResRealCode = "";
  EmployeModel? respRealModel = null;

  //Champ obligatoire
  getChampObligatoire() async {
    List<ChampObligatoireActionModel> champObligatoireList =
        await List<ChampObligatoireActionModel>.empty(growable: true);
    var response = await localActionService.readChampObligatoireAction();
    response.forEach((data) {
      var model = ChampObligatoireActionModel();
      model.commentaire_Realisation_Action =
          data['commentaire_Realisation_Action'];
      model.rapport_Suivi_Action = data['rapport_Suivi_Action'];
      model.delai_Suivi_Action = data['delai_Suivi_Action'];
      model.priorite = data['priorite'];
      model.gravite = data['gravite'];
      model.commentaire = data['commentaire'];
      champObligatoireList.add(model);

      priorite_obligatoire = model.priorite;
      gravite_obligatoire = model.gravite;
      delai_suivi_obligatoire = model.delai_Suivi_Action;
    });
  }

  bool _dataValidation() {
    if (designationController.text.trim() == '') {
      Message.taskErrorOrWarning(
          'warning'.tr, "${'designation'.tr} ${'is_required'.tr}");
      return false;
    } else if (delai_suivi_obligatoire == 1 &&
        delaiRealisationController.text.trim() == '') {
      Message.taskErrorOrWarning(
          'warning'.tr, "${'delai_real'.tr} ${'is_required'.tr}");
      return false;
    } else if (delaiSuiviController.text.trim() == '') {
      Message.taskErrorOrWarning(
          'warning'.tr, "${'delai_suivi'.tr} ${'is_required'.tr}");
      return false;
    } else if (priorite_obligatoire == 1 && prioriteModel == null) {
      Message.taskErrorOrWarning(
          'warning'.tr, "${'priority'.tr} ${'is_required'.tr}");
      return false;
    } else if (gravite_obligatoire == 1 && graviteModel == null) {
      Message.taskErrorOrWarning(
          'warning'.tr, "${'gravity'.tr} ${'is_required'.tr}");
      return false;
    } else if (respRealModel == null) {
      Message.taskErrorOrWarning(
          'warning'.tr, "${'resp_real'.tr} ${'is_required'.tr}");
      return false;
    } else if (resSuiviModel == null) {
      Message.taskErrorOrWarning(
          'warning'.tr, "${'resp_suivi'.tr} ${'is_required'.tr}");
      return false;
    }
    return true;
  }

  @override
  void onInit() {
    super.onInit();
    getSousActions();
    getChampObligatoire();

    designationController = TextEditingController();
    risqueController = TextEditingController();
    coutPrevController = TextEditingController();
    delaiRealisationController = TextEditingController();
    delaiSuiviController = TextEditingController();
    delaiRealisationController.text =
        DateFormat('dd/MM/yyyy').format(datePickerReal);
    delaiSuiviController.text =
        DateFormat('dd/MM/yyyy').format(datePickerSuivi);

    checkConnectivity();
  }

  Future<void> checkConnectivity() async {
    var connection = await Connectivity().checkConnectivity();
    var countSousActionLocal = LocalActionService().getCountSousActionOffline();
    print('count Table SousAction : ${countSousActionLocal}');
    if (connection == ConnectivityResult.none) {
      // Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
    } else if (connection == ConnectivityResult.wifi ||
        connection == ConnectivityResult.mobile) {
      //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
      /* if(countSousActionLocal > 0){
        ShowSnackBar.snackBar("Synchronization", " data synchronized", Colors.cyan.shade400);
        await syncSousActionToWebService();
      } */
      // await syncSousActionToWebService();
    }
  }

  selectedDateReal(BuildContext context) async {
    datePickerReal = (await showDatePicker(
        context: context,
        initialDate: datePickerReal,
        firstDate: DateTime(2021),
        lastDate: DateTime(2100)
        //lastDate: DateTime.now()
        ))!;
    if (datePickerReal != null) {
      delaiRealisationController.text =
          DateFormat('dd/MM/yyyy').format(datePickerReal);
      //delaiRealisationController.text = DateFormat.yMMMMd().format(datePickerReal);
    }
  }

  selectedDateSuivi(BuildContext context) async {
    datePickerSuivi = (await showDatePicker(
        context: context,
        initialDate: datePickerSuivi,
        firstDate: DateTime(2021),
        lastDate: DateTime(2100)
        //firstDate: datePickerReal,
        //lastDate: DateTime.now()
        ))!;
    if (datePickerSuivi != null) {
      delaiSuiviController.text =
          DateFormat('dd/MM/yyyy').format(datePickerSuivi);
    }
  }

  void getSousActions() async {
    try {
      isDataProcessing(true);

      id_action = Get.arguments['id_action'];
      print('id action $id_action');
      //rest api
      await Future.delayed(Duration(seconds: 1), () async {
        var connection = await Connectivity().checkConnectivity();
        if (connection == ConnectivityResult.none) {
          //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

          var response =
              await localActionService.readSousActionByNumAction(id_action);
          //print('response sous action local  : $response');
          response.forEach((data) {
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
            model.respRealNom = data['respRealNompre'];
            model.respSuivieNom = data['respSuiviNompre'];
            model.respReal = data['respRealMat'];
            model.respSuivi = data['respSuiviMat'];
            model.priorite = data['priorite'];
            model.gravite = data['gravite'];
            model.processus = data['processus'];
            model.risques = data['risques'];
            model.online = data['online'];

            listSousAction.add(model);
            listSousAction.forEach((element) {
              print('sous act ${element.sousAct}, online: ${element.online}');
            });
          });
        } else if (connection == ConnectivityResult.wifi ||
            connection == ConnectivityResult.mobile) {
          //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

          await ActionService().getSousAction(id_action).then((resp) async {
            //isDataProcessing(false);
            resp.forEach((data) async {
              print('get sous actions : ${data} ');
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
              model.gravite = data['gravite'];
              model.processus = data['processus'];
              model.risques = data['risques'];
              model.online = 1;

              listSousAction.add(model);
              listSousAction.forEach((element) {
                print(
                    'element act ${element.sousAct}, online: ${element.online}');
              });
              //delete db local
              ///await localActionService.deleteAllSousAction();
              //save data in local db
              ///await localActionService.saveSousAction(model);
              //print('Inserting sous action : ${model.sousAct} ');
            });
            print('get data');
          }, onError: (err) {
            isDataProcessing(false);
            ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
          });
        }
      });
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      print('exception : ${exception.toString()}');
    } finally {
      isDataProcessing(false);
    }
  }

  Future saveBtn() async {
    if (_dataValidation() && addItemFormKey.currentState!.validate()) {
      try {
        isDataProcessing.value = true;
        if (datePickerSuivi.isBefore(datePickerReal)) {
          isDataProcessing.value = false;
          Get.defaultDialog(
              title: "Exception",
              backgroundColor: Colors.lightBlue,
              titleStyle: TextStyle(color: Colors.white),
              middleTextStyle: TextStyle(color: Colors.white),
              textConfirm: "Confirm",
              onConfirm: () {
                Get.back();
              },
              textCancel: "Cancel",
              cancelTextColor: Colors.white,
              confirmTextColor: Colors.white,
              buttonColor: Colors.red,
              barrierDismissible: false,
              radius: 20,
              content: Text(
                'Le delai de suivi doit être supérieur au délai de réalisation',
                style: TextStyle(color: Colors.white),
              ));
          return;
        }
        if (coutPrevController.text.trim() == '') {
          cout_prev = 0;
        } else {
          cout_prev = int.parse(coutPrevController.text.toString());
        }

        var connection = await Connectivity().checkConnectivity();
        if (connection == ConnectivityResult.none) {
          int max_num_sous_action =
              await localActionService.getMaxNumSousAction(id_action);
          print('max num sous action: $max_num_sous_action');
          //save data in local db
          var model = SousActionModel();
          model.nSousAct = max_num_sous_action + 1; //data['nSousAct'];
          model.nAct = id_action;
          model.cloture = 0;
          model.sousAct = designationController.text.trim();
          model.delaiReal = delaiRealisationController.text;
          model.delaiSuivi = delaiSuiviController.text;
          model.dateReal = "";
          model.dateSuivi = "";
          model.coutPrev = cout_prev;
          model.pourcentReal = 0;
          model.depense = 0;
          model.pourcentSuivie = 0;
          model.rapportEff = "";
          model.commentaire = "";
          model.respRealNom = respRealModel?.nompre;
          model.respSuivieNom = resSuiviModel?.nompre;
          model.respReal = selectedResRealCode;
          model.respSuivi = selectedResSuiviCode;
          model.priorite = prioriteModel?.priorite.toString();
          model.codePriorite = selectedCodePriorite;
          model.gravite = graviteModel?.gravite.toString();
          model.codeGravite = selectedCodeGravite;
          model.processus = selectedProcessusCode.toString();
          model.risques = risqueController.text.trim();
          model.online = 0;

          await localActionService.saveSousAction(model);
          print(
              'Inserting sous action offline  : num sousAct: ${model.nSousAct}, numAct: ${model.nAct}, sousAct: ${model.sousAct}, '
              'cout prev: ${model.coutPrev}, respreal: ${model.respRealNom}, respsuivi ${model.respSuivieNom}, '
              'respreasmat: ${model.respReal}, ressuivimat:  ${model.respSuivi}, priorite: ${model.priorite}, code priorite: ${model.codePriorite}, gravite: ${model.gravite}, '
              'delai real: ${model.delaiReal}, delai suivi: ${model.delaiSuivi}, online: ${model.online} ');

          Get.back();
          listSousAction.clear();
          refreshList();
          Get.snackbar("Mode Offline", "Sous Action Successfully",
              colorText: Colors.blue, snackPosition: SnackPosition.TOP);
          /*  Get.toNamed(AppRoute.sous_action, arguments: {
            "id_action" : id_action
          }); */

          clearData();
        } else if (connection == ConnectivityResult.wifi ||
            connection == ConnectivityResult.mobile) {
          await ActionService().saveSousAction({
            "nact": id_action,
            "sousact": designationController.text.trim(),
            "respreal": selectedResRealCode,
            "respsuivi": selectedResSuiviCode,
            "delaitrait": "",
            "delaisuivi": delaiSuiviController.text,
            "datereal": delaiRealisationController.text,
            "datesuivi": "",
            "coutprev": cout_prev,
            "pourcentreal": "",
            "pourcentsuivi": "",
            "depense": "",
            "rapporteff": "",
            "commentaire": "",
            "cloture": "",
            "processus": selectedProcessusCode.toString(),
            "risk": risqueController.text.trim(),
            "priorite": selectedCodePriorite,
            "gravite": selectedCodeGravite
          }).then((resp) {
            Get.back();
            listSousAction.clear();
            refreshList();
            ShowSnackBar.snackBar(
                "Add Sous Action", "Sous Action Added", Colors.green);

            /* Get.toNamed(AppRoute.sous_action, arguments: {
            "id_action" : id_action
          }); */

            //Get.offAll(ActionPage());
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
            radius: 20,
            content: Text(
              '${ex.toString()}',
              style: TextStyle(color: Colors.black),
            ));
        print("throwing new error " + ex.toString());
        throw Exception("Error " + ex.toString());
      } finally {
        isDataProcessing.value = false;
        //Get.back();
      }
    }
  }

  clearData() {
    //onInit();
    designationController.clear();
    delaiRealisationController.text =
        DateFormat('dd/MM/yyyy').format(datePickerReal);
    delaiSuiviController.text =
        DateFormat('dd/MM/yyyy').format(datePickerSuivi);
    risqueController.clear();
    coutPrevController.clear();
    prioriteModel = null;
    selectedCodePriorite = 0;
    graviteModel = null;
    selectedCodeGravite = 0;
    selectedProcessusCode = 0;
    processusModel = null;
    selectedResSuiviCode = "";
    selectedResRealCode = "";
    respRealModel = null;
    resSuiviModel = null;
  }

  // Refresh List
  refreshList() async {
    getSousActions();
  }

  //synchronization
  Future syncSousActionToWebService() async {
    try {
      isDataProcessing(true);
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        Get.snackbar("No Connection", "Cannot synchronize Data",
            colorText: Colors.blue, snackPosition: SnackPosition.TOP);
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        await SyncDataController().syncSousActionToSQLServer();

        //save data to db local
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

            //delete table
            await localActionService.deleteAllSousAction();
            //save data
            await localActionService.saveSousAction(model);
            print(
                'Inserting data in table SousAction : NAct: ${model.nAct}, NSousAct ${model.nSousAct}, SousAct: ${model.sousAct}, online:${model.online} ');
          });

          listSousAction.clear();
          getSousActions();
        }, onError: (err) {
          isDataProcessing(false);
          ShowSnackBar.snackBar(
              "Error processus emp", err.toString(), Colors.red);
        });
      }
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  //Widgets add action
//priorite
  Widget customDropDownPriorite(BuildContext context, PrioriteModel? item) {
    if (prioriteModel == null) {
      return Container();
    } else {
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${prioriteModel?.priorite}'),
        ),
      );
    }
  }

  Widget customPopupItemBuilderPriorite(
      BuildContext context, prioriteModel, bool isSelected) {
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
        title: Text(prioriteModel?.priorite ?? ''),
        subtitle: Text(prioriteModel?.codepriorite.toString() ?? ''),
      ),
    );
  }

  //gravite action
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
        subtitle: Text(graviteModel?.codegravite.toString() ?? ''),
      ),
    );
  }

  //processus
  Widget customDropDownProcessus(
      BuildContext context, ProcessusEmployeModel? item) {
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

  //employe
  Widget customDropDownEmploye(BuildContext context, EmployeModel? item) {
    if (respRealModel == null) {
      return Container();
    } else {
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${respRealModel?.nompre}',
              style: TextStyle(color: Colors.black)),
        ),
      );
    }
  }

  Widget customDropDownRespSuivi(BuildContext context, EmployeModel? item) {
    if (resSuiviModel == null) {
      return Container();
    } else {
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${resSuiviModel?.nompre}',
              style: TextStyle(color: Colors.black)),
        ),
      );
    }
  }

  Widget customPopupItemBuilderEmploye(
      BuildContext context, respRealModel, bool isSelected) {
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
        title: Text(respRealModel?.nompre ?? ''),
        subtitle: Text(respRealModel?.mat.toString() ?? ''),
      ),
    );
  }
}
