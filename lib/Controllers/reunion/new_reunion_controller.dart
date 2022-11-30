import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qualipro_flutter/Controllers/reunion/reunion_controller.dart';
import 'package:qualipro_flutter/Models/reunion/reunion_model.dart';
import 'package:qualipro_flutter/Models/reunion/type_reunion_model.dart';
import 'package:qualipro_flutter/Services/action/local_action_service.dart';
import 'package:qualipro_flutter/Services/pnc/local_pnc_service.dart';
import 'package:qualipro_flutter/Services/reunion/local_reunion_service.dart';
import 'package:qualipro_flutter/Services/reunion/reunion_service.dart';
import '../../Models/Domaine_affectation_model.dart';
import '../../Models/activity_model.dart';
import '../../Models/direction_model.dart';
import '../../Models/processus_model.dart';
import '../../Models/service_model.dart';
import '../../Models/site_model.dart';
import '../../Services/api_services_call.dart';
import '../../Utils/http_response.dart';
import '../../Utils/message.dart';
import '../../Utils/shared_preference.dart';
import '../../Utils/snack_bar.dart';
import '../../Views/reunion/participant/participant_page.dart';

class NewReunionController extends GetxController {
  var isDataProcessing = false.obs;
  var isVisibleNewPNC = true.obs;
  LocalPNCService localPNCService = LocalPNCService();
  LocalActionService localActionService = LocalActionService();
  LocalReunionService localReunionService = LocalReunionService();
  final matricule = SharedPreference.getMatricule();

  final addItemFormKey = GlobalKey<FormState>();
  late TextEditingController datePrevueController,
      dateRealisationController,
      orderController,
      lieuController,
      heureDebutController,
      heureFinController,
      dureeRealController,
      commentaireController,
      dureeReunionController;
  DateTime datePickerPrevue = DateTime.now();
  DateTime datePickerRealisation = DateTime.now();
  TimeOfDay timeDebut = TimeOfDay(hour: 10, minute: 00);
  TimeOfDay timeFin = TimeOfDay(hour: 12, minute: 00);
  dynamic currentTime = DateFormat('kk:mm').format(DateTime.now());
  int duree_hour = 00;
  int duree_minute = 00;

  //stepper
  var currentStep = 0.obs;

  //type
  TypeReunionModel? typeReunionModel = null;
  var type_obligatoire = 1.obs;
  int? selectedCodeType = 0;
  //site
  var site_visible = 0.obs;
  late bool isVisibileSite;
  var site_obligatoire = 0.obs;
  SiteModel? siteModel = null;
  int? selectedCodeSite = 0;
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

  //radio
  var etat = 0.obs;
  onChangeEtat(var valeur) {
    etat.value = valeur;
    print('etat : ${etat.value}');
  }

  //domaine affectation
  getDomaineAffectation() async {
    List<DomaineAffectationModel> domaineList =
        await List<DomaineAffectationModel>.empty(growable: true);
    var connection = await Connectivity().checkConnectivity();
    if (connection == ConnectivityResult.none) {
      var response = await localActionService.readDomaineAffectationByModule(
          "Réunion", "Réunion");
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
          if (model.module == "Réunion" && model.fiche == "Réunion") {
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

  bool _dataValidation() {
    if (typeReunionModel == null) {
      Message.taskErrorOrWarning('warning'.tr, "Type ${'is_required'.tr}");
      return false;
    }
    /*  else if (orderController.text.trim() == '') {
      Message.taskErrorOrWarning("Warning", "Order is required");
      return false;
    } */
    else if (datePrevueController.text.trim() == '') {
      Message.taskErrorOrWarning(
          'warning'.tr, "${'date_prevue'.tr} ${'is_required'.tr}");
      return false;
    } else if (dateRealisationController.text.trim() == '') {
      Message.taskErrorOrWarning(
          'warning'.tr, "Date ${'realisation'.tr} ${'is_required'.tr}");
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
    }
    double _doubleTimeDebut =
        timeDebut.hour.toDouble() + (timeDebut.minute.toDouble() / 60);
    double _doubleTimeFin =
        timeFin.hour.toDouble() + (timeFin.minute.toDouble() / 60);
    if (_doubleTimeDebut > _doubleTimeFin) {
      isDataProcessing.value = false;
      Get.defaultDialog(
          title: "Exception",
          backgroundColor: Colors.white,
          titleStyle: TextStyle(color: Colors.black),
          middleTextStyle: TextStyle(color: Colors.black87),
          textConfirm: "OK",
          onConfirm: () {
            Get.back();
          },
          textCancel: "Cancel",
          cancelTextColor: Colors.red,
          confirmTextColor: Colors.white,
          buttonColor: Colors.blue,
          barrierDismissible: false,
          radius: 20,
          content: Text(
            'heure_debut_inferieur_heure_fin'.tr,
            style: TextStyle(color: Colors.black87),
          ));
      return false;
    }
    return true;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    orderController = TextEditingController();
    lieuController = TextEditingController();
    commentaireController = TextEditingController();
    datePrevueController = TextEditingController();
    dateRealisationController = TextEditingController();
    heureDebutController = TextEditingController();
    heureFinController = TextEditingController();
    dureeReunionController = TextEditingController();
    dureeRealController = TextEditingController();
    datePrevueController.text =
        DateFormat('yyyy-MM-dd').format(datePickerPrevue);
    dateRealisationController.text =
        DateFormat('yyyy-MM-dd').format(datePickerRealisation);
    heureDebutController.text = currentTime.toString();
    heureFinController.text =
        currentTime.toString(); //TimeOfDay.now().toString();
    dureeReunionController.text = '${duree_hour}:${duree_minute}';

    getDomaineAffectation();
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

  selectedDatePrevue(BuildContext context) async {
    datePickerPrevue = (await showDatePicker(
        context: context,
        initialDate: datePickerPrevue,
        firstDate: DateTime(2021),
        lastDate: DateTime(2100)
        //lastDate: DateTime.now()
        ))!;
    if (datePickerPrevue != null) {
      datePrevueController.text =
          DateFormat('yyyy-MM-dd').format(datePickerPrevue);
      //datePrevueController.text = DateFormat.yMMMMd().format(datePickerPrevue);
    }
  }

  selectedDateRealisation(BuildContext context) async {
    datePickerRealisation = (await showDatePicker(
        context: context,
        initialDate: datePickerRealisation,
        firstDate: DateTime(2021),
        lastDate: DateTime.now()))!;
    if (datePickerRealisation != null) {
      dateRealisationController.text =
          DateFormat('yyyy-MM-dd').format(datePickerRealisation);
    }
  }

  //final hours = timeDebut.hour.toString().padLeft(2, '0');
  selectedTimeDebut(BuildContext context) async {
    timeDebut =
        (await showTimePicker(context: context, initialTime: timeDebut))!;
    if (timeDebut == null) return;
    if (timeDebut != null) {
      heureDebutController.text = '${timeDebut.hour}:${timeDebut.minute}';

      duree_hour = timeFin.hour - timeDebut.hour;
      duree_minute = timeFin.minute - timeDebut.minute;
      dureeReunionController.text = '${duree_hour}:${duree_minute}';
    }
  }

  selectedTimeFin(BuildContext context) async {
    timeFin = (await showTimePicker(context: context, initialTime: timeFin))!;
    if (timeFin == null) return;
    if (timeFin != null) {
      heureFinController.text = '${timeFin.hour}:${timeFin.minute}';

      duree_hour = timeFin.hour - timeDebut.hour;
      duree_minute = timeFin.minute - timeDebut.minute;
      dureeReunionController.text = '${duree_hour}:${duree_minute}';
    }
  }

  Future saveBtn() async {
    if (_dataValidation() && addItemFormKey.currentState!.validate()) {
      try {
        var connection = await Connectivity().checkConnectivity();
        if (connection == ConnectivityResult.none) {
          int max_num_reunion = await localReunionService.getMaxNumReunion();
          var model = ReunionModel();
          model.online = 0;
          model.nReunion = max_num_reunion + 1;
          model.typeReunion = typeReunionModel?.typeReunion;
          model.codeTypeReunion = selectedCodeType;
          model.datePrev = datePrevueController.text;
          model.dateReal = dateRealisationController.text;
          model.etat = etat.toString();
          model.lieu = lieuController.text;
          model.site = siteModel?.site;
          model.ordreJour = orderController.text;
          model.dureePrev = dureeReunionController.text;
          model.heureDeb = heureDebutController.text;
          model.heureFin = heureFinController.text;
          model.dureReal = dureeRealController.text;
          model.commentaire = commentaireController.text;
          model.codeSite = selectedCodeSite;
          model.codeProcessus = selectedCodeProcessus;
          model.codeDirection = selectedCodeDirection;
          model.codeService = selectedCodeService;
          model.codeActivity = selectedCodeActivity;
          //save data sync
          await localReunionService.saveReunionSync(model);
          Get.back();
          ShowSnackBar.snackBar(
              "Mode Offline", "Reunion Added Successfully", Colors.green);
          Get.find<ReunionController>().listReunion.clear();
          Get.find<ReunionController>().getReunion();
          //Get.toNamed(AppRoute.reunion);
          clearData();
        } else if (connection == ConnectivityResult.wifi ||
            connection == ConnectivityResult.mobile) {
          await ReunionService().saveReunion({
            "codetypeR": selectedCodeType,
            "dateprev": datePrevueController.text,
            "dureePrev": dureeReunionController.text,
            "heuredeb": heureDebutController.text,
            "heurefin": heureFinController.text,
            "ordrejour": orderController.text,
            "dateReal": dateRealisationController.text,
            "durereal": dureeRealController.text,
            "etat": etat.toString(),
            "commentaire": commentaireController.text,
            "lieu": lieuController.text,
            "site": selectedCodeSite,
            "id_process": selectedCodeProcessus,
            "id_domaine": selectedCodeActivity,
            "id_direction": selectedCodeDirection,
            "id_service": selectedCodeService,
            "matdecl": matricule
          }).then((resp) {
            ShowSnackBar.snackBar(
                "Successfully", "Reunion Added ", Colors.green);
            final num_reunion = resp['nReunion'];
            debugPrint('num reunion : ${num_reunion}');

            Get.defaultDialog(
                title: '${'new'.tr} Participants',
                backgroundColor: Colors.white,
                titleStyle: TextStyle(color: Colors.black),
                middleTextStyle: TextStyle(color: Colors.white),
                textConfirm: "Yes",
                textCancel: "No",
                onConfirm: () {
                  //Get.find<ReunionController>().listReunion.clear();
                  //Get.find<ReunionController>().getReunion();
                  //Get.to(ParticipantPage(nReunion: num_reunion));
                  Get.offAll(ParticipantPage(nReunion: num_reunion));
                },
                onCancel: () {
                  Get.find<ReunionController>().listReunion.clear();
                  Get.find<ReunionController>().getReunion();
                  //Get.toNamed(AppRoute.reunion);
                  Get.back();
                  clearData();
                },
                confirmTextColor: Colors.white,
                buttonColor: Colors.blue,
                barrierDismissible: false,
                radius: 20,
                content: Text(
                  '${'do_you_want_add'.tr} participants',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Brand-Bold'),
                ));
          }, onError: (error) {
            isDataProcessing(false);
            print('Error : ${error.toString()}');
            HttpResponse.StatusCode(error.toString());
            //ShowSnackBar.snackBar("Error", error.toString(), Colors.red);
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
    orderController.clear();
    lieuController.clear();
    dureeRealController.clear();
    commentaireController.clear();
    datePrevueController.text =
        DateFormat('yyyy-MM-dd').format(datePickerPrevue);
    dateRealisationController.text =
        DateFormat('yyyy-MM-dd').format(datePickerRealisation);
    selectedCodeType = 0;
    typeReunionModel = null;
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
    heureDebutController.text = currentTime.toString();
    heureFinController.text =
        currentTime.toString(); //TimeOfDay.now().toString();
    dureeReunionController.text = '${duree_hour}:${duree_minute}';
  }

  //type reunion
  Widget customDropDownType(BuildContext context, TypeReunionModel? item) {
    if (typeReunionModel == null) {
      return Container();
    } else {
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${typeReunionModel?.typeReunion}'),
        ),
      );
    }
  }

  Widget customPopupItemBuilderType(
      BuildContext context, typeReunionModel, bool isSelected) {
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
        title: Text(typeReunionModel?.typeReunion ?? ''),
        subtitle: Text(typeReunionModel?.codeTypeR.toString() ?? ''),
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
