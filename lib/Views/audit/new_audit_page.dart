import 'package:connectivity/connectivity.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:qualipro_flutter/Models/audit/champ_audit_model.dart';
import 'package:qualipro_flutter/Models/audit/type_audit_model.dart';
import 'package:qualipro_flutter/Services/audit/audit_service.dart';

import '../../Controllers/audit/new_audit_controller.dart';
import '../../Models/activity_model.dart';
import '../../Models/direction_model.dart';
import '../../Models/processus_model.dart';
import '../../Models/service_model.dart';
import '../../Models/site_model.dart';
import '../../Services/api_services_call.dart';
import '../../Utils/custom_colors.dart';
import '../../Utils/snack_bar.dart';
import '../../Validators/validator.dart';
import '../../Widgets/loading_widget.dart';

class NewAuditPage extends GetView<NewAuditController> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
    final _filterEditTextController = TextEditingController();

    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        leading: TextButton(
          onPressed: (){
            Get.back();
            //controller.clearData();
          },
          child: Icon(Icons.arrow_back, color: Colors.white,),
        ),
        title: Center(
          child: Text("Ajouter Audit"),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(5.0),
            child: Obx((){
              if(controller.isVisibleNewAudit.value == true){
                return Card(
                  child: SingleChildScrollView(
                    child: Form(
                      key: controller.addItemFormKey,
                        child: Padding(
                            padding: EdgeInsets.all(15.0),
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                controller: controller.dateDebutController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                validator: (value) => Validator.validateField(
                                    value: value!
                                ),
                                onChanged: (value){
                                  controller.selectedDateDebut(context);
                                },
                                decoration: InputDecoration(
                                    labelText: 'Date Debut Prevue *',
                                    hintText: 'date',
                                    labelStyle: TextStyle(
                                      fontSize: 14.0,
                                    ),
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10.0,
                                    ),
                                    suffixIcon: InkWell(
                                      onTap: (){
                                        controller.selectedDateDebut(context);
                                      },
                                      child: Icon(Icons.calendar_today),
                                    ),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.lightBlue, width: 1),
                                        borderRadius: BorderRadius.all(Radius.circular(10))
                                    )
                                ),
                                style: TextStyle(fontSize: 14.0),
                              ),
                              SizedBox(height: 10.0,),
                              TextFormField(
                                controller: controller.dateFinController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                validator: (value) => Validator.validateField(
                                    value: value!
                                ),
                                onChanged: (value){
                                  controller.selectedDateFin(context);
                                },
                                decoration: InputDecoration(
                                    labelText: 'Date Fin Prevue *',
                                    hintText: 'date',
                                    labelStyle: TextStyle(
                                      fontSize: 14.0,
                                    ),
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10.0,
                                    ),
                                    suffixIcon: InkWell(
                                      onTap: (){
                                        controller.selectedDateFin(context);
                                      },
                                      child: Icon(Icons.calendar_today),
                                    ),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.lightBlue, width: 1),
                                        borderRadius: BorderRadius.all(Radius.circular(10))
                                    )
                                ),
                                style: TextStyle(fontSize: 14.0),
                              ),
                              SizedBox(height: 10.0,),
                              TextFormField(
                                controller: controller.descriptionController,
                                keyboardType: TextInputType.multiline,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  labelText: 'Description Audit',
                                  hintText: 'Description Audit',
                                  labelStyle: TextStyle(
                                    fontSize: 14.0,
                                  ),
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10.0,
                                  ),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.lightBlue, width: 1),
                                      borderRadius: BorderRadius.all(Radius.circular(10))
                                  ),
                                ),
                               /* validator: (value) =>
                                (controller.description_cause_obligatoire.value==1 && controller.descriptionCauseController=='') ? "Description Cause is required " : null,
                                */
                                style: TextStyle(fontSize: 14.0),
                                minLines: 2,
                                maxLines: 5,
                              ),
                              SizedBox(height: 10.0,),
                              TextFormField(
                                controller: controller.objectifController,
                                keyboardType: TextInputType.multiline,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  labelText: 'Objectif Audit',
                                  hintText: 'Objectif Audit',
                                  labelStyle: TextStyle(
                                    fontSize: 14.0,
                                  ),
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10.0,
                                  ),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.lightBlue, width: 1),
                                      borderRadius: BorderRadius.all(Radius.circular(10))
                                  ),
                                ),
                                /* validator: (value) =>
                                (controller.description_cause_obligatoire.value==1 && controller.descriptionCauseController=='') ? "Description Cause is required " : null,
                                */
                                style: TextStyle(fontSize: 14.0),
                                minLines: 2,
                                maxLines: 5,
                              ),
                              SizedBox(height: 10.0,),
                              Visibility(
                                visible: true,
                                child: TextFormField(
                                  controller: controller.refInterneController,
                                  keyboardType: TextInputType.multiline,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                      labelText: 'Ref interne ',
                                      hintText: 'Ref interne',
                                      labelStyle: TextStyle(
                                        fontSize: 14.0,
                                      ),
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 10.0,
                                      ),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.lightBlue, width: 1),
                                          borderRadius: BorderRadius.all(Radius.circular(10))
                                      )
                                  ),
                                  style: TextStyle(fontSize: 14.0),
                                ),
                              ),
                              SizedBox(height: 10.0,),
                              DropdownSearch<TypeAuditModel>(
                                showSearchBox: true,
                                showSelectedItems: true,
                                showClearButton: true,
                                showAsSuffixIcons: true,
                                isFilteredOnline: true,
                                compareFn: (i, model) => i?.isEqual(model) ?? false,
                                dropdownSearchDecoration: InputDecoration(
                                  labelText: "Type Audit *",
                                  contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                  border: OutlineInputBorder()
                                ),
                                onFind: (String? filter) => getType(filter),
                                onChanged: (data){
                                  controller.typeAuditModel = data;
                                  controller.selectedCodeTypeAudit = data?.codeType;
                                  controller.typeAudit = data?.type;
                                  if(kDebugMode){
                                    print('type audit : ${controller.typeAudit}, code : ${controller.selectedCodeTypeAudit}');
                                  }
                                },
                                dropdownBuilder: controller.customDropDownType,
                                popupItemBuilder: controller.customPopupItemBuilderType,
                                validator: (u) =>
                                u== null ? "Type est obligatoire " : null,
                              ),
                              SizedBox(height: 10.0,),
                              Visibility(
                                visible: true,
                                child: DropdownSearch<ChampAuditModel>.multiSelection(
                                  searchFieldProps: TextFieldProps(
                                    controller: _filterEditTextController,
                                    decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        icon: Icon(Icons.clear),
                                        onPressed: () {
                                          _filterEditTextController.clear();
                                        },
                                      ),
                                    ),
                                  ),
                                  mode: Mode.DIALOG,
                                  isFilteredOnline: true,
                                  showClearButton: false,
                                  showSelectedItems: true,
                                  compareFn: (item, selectedItem) => item?.codeChamp == selectedItem?.codeChamp,
                                  showSearchBox: true,
                                  /* dropdownSearchDecoration: InputDecoration(
                                    labelText: 'User *',
                                    filled: true,
                                    fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                                  ), */
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText: "Champ d'audit *",
                                    contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                    border: OutlineInputBorder(),
                                  ),
                                  autoValidateMode: AutovalidateMode.onUserInteraction,
                                  onFind: (String? filter) => getChampAudit(filter),
                                  onChanged: (data) {
                                    //print(data);
                                    controller.listChampAudit.clear();
                                    controller.codeChampAuditList.clear();
                                    controller.champAuditList.clear();
                                    controller.listChampAudit.addAll(data);
                                    data.forEach((element) {
                                      print('champ audit: ${element.champ}, code: ${element.codeChamp}');
                                      List<int> listCodeChamp = [];
                                      List<String> listChamp = [];
                                      listCodeChamp.add(element.codeChamp!);
                                      controller.codeChampAuditList.addAll(listCodeChamp);
                                      listChamp.add(element.champ!);
                                      controller.champAuditList.addAll(listChamp);
                                    });
                                  },
                                  dropdownBuilder: controller.customDropDownMultiSelectionChampAudit,
                                  popupItemBuilder: controller.customPopupItemBuilderChampAudit,
                                  popupSafeArea: PopupSafeAreaProps(top: true, bottom: true),
                                  scrollbarProps: ScrollbarProps(
                                    isAlwaysShown: true,
                                    thickness: 7,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.0,),
                              Visibility(
                                  visible:controller.site_visible.value == 1 ? controller.isVisibileSite=true : controller.isVisibileSite=false,
                                  child: DropdownSearch<SiteModel>(
                                    showSelectedItems: true,
                                    showClearButton: controller.siteModel?.site=="" ? false : true,
                                    showSearchBox: true,
                                    isFilteredOnline: true,
                                    compareFn: (i, s) => i?.isEqual(s) ?? false,
                                    dropdownSearchDecoration: InputDecoration(
                                      labelText: "Site ${controller.site_obligatoire.value==1?'*':''}",
                                      contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                      border: OutlineInputBorder(),
                                    ),
                                    onFind: (String? filter) => getSite(filter),
                                    onChanged: (data) {
                                      controller.siteModel = data;
                                      controller.selectedCodeSite = data?.codesite;
                                      controller.siteIncident = data?.site;
                                      if(controller.siteModel == null){
                                        controller.selectedCodeSite = 0;
                                        controller.siteIncident = "";
                                      }
                                      print('site: ${controller.siteModel?.site}, code: ${controller.selectedCodeSite}');
                                    },
                                    dropdownBuilder: controller.customDropDownSite,
                                    popupItemBuilder: controller.customPopupItemBuilderSite,
                                    validator: (u) =>
                                    (controller.site_obligatoire.value==1 && controller.siteModel==null) ? "site is required " : null,
                                  )
                              ),
                              SizedBox(height: 10.0,),
                              Visibility(
                                  visible: controller.processus_visible.value == 1 ? controller.isVisibileProcessus=true : controller.isVisibileProcessus=false,
                                  child: DropdownSearch<ProcessusModel>(
                                    showSelectedItems: true,
                                    showClearButton: controller.processusModel?.processus=="" ? false : true,
                                    showSearchBox: true,
                                    isFilteredOnline: true,
                                    compareFn: (i, s) => i?.isEqual(s) ?? false,
                                    dropdownSearchDecoration: InputDecoration(
                                      labelText: "Processus ${controller.processus_obligatoire.value==1?'*':''}",
                                      contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                      border: OutlineInputBorder(),
                                    ),
                                    onFind: (String? filter) => getProcessus(filter),
                                    onChanged: (data) {
                                      controller.processusModel = data;
                                      controller.selectedCodeProcessus = data?.codeProcessus;
                                      controller.processusIncident = data?.processus;
                                      if(controller.processusModel == null){
                                        controller.selectedCodeProcessus = 0;
                                        controller.processusIncident = "";
                                      }
                                      print('processus: ${controller.processusModel?.processus}, code: ${controller.selectedCodeProcessus}');
                                    },
                                    dropdownBuilder: controller.customDropDownProcessus,
                                    popupItemBuilder: controller.customPopupItemBuilderProcessus,
                                    validator: (u) =>
                                    (controller.processus_obligatoire.value==1 && controller.processusModel==null) ? "processus is required " : null,

                                  )
                              ),
                              SizedBox(height: 10.0,),
                              Visibility(
                                  visible: controller.direction_visible.value == 1 ? controller.isVisibileDirection=true : controller.isVisibileDirection=false,
                                  child: DropdownSearch<DirectionModel>(
                                      showSelectedItems: true,
                                      showClearButton: controller.directionModel?.direction=="" ? false : true,
                                      showSearchBox: true,
                                      isFilteredOnline: true,
                                      compareFn: (i, s) => i?.isEqual(s) ?? false,
                                      dropdownSearchDecoration: InputDecoration(
                                        labelText: "Direction ${controller.direction_obligatoire.value==1?'*':''}",
                                        contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                        border: OutlineInputBorder(),
                                      ),
                                      onFind: (String? filter) => getDirection(filter),
                                      onChanged: (data) {
                                        controller.selectedCodeDirection = data?.codeDirection;
                                        controller.directionIncident = data?.direction;
                                        controller.directionModel = data;
                                        if(controller.directionModel == null){
                                          controller.selectedCodeDirection = 0;
                                          controller.directionIncident = "";
                                        }
                                        print('direction: ${controller.directionModel?.direction}, code: ${controller.selectedCodeDirection}');
                                      },
                                      dropdownBuilder: controller.customDropDownDirection,
                                      popupItemBuilder: controller.customPopupItemBuilderDirection,
                                      validator: (u) =>
                                      (controller.direction_obligatoire.value==1 && controller.directionModel==null) ? "direction is required " : null,
                                      onBeforeChange: (a, b) {
                                        if (b == null) {
                                          AlertDialog alert = AlertDialog(
                                            title: Text("Are you sure..."),
                                            content: Text("...you want to clear the selection"),
                                            actions: [
                                              TextButton(
                                                child: Text("OK"),
                                                onPressed: () {
                                                  Navigator.of(context).pop(true);
                                                },
                                              ),
                                              TextButton(
                                                child: Text("Cancel"),
                                                onPressed: () {
                                                  Navigator.of(context).pop(false);
                                                },
                                              ),
                                            ],
                                          );
                                          return showDialog<bool>(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return alert;
                                              });
                                        }
                                        return Future.value(true);
                                      }
                                  )
                              ),
                              SizedBox(height: 10.0,),
                              Visibility(
                                  visible: controller.service_visible.value == 1 ? controller.isVisibileService=true : controller.isVisibileService=false,
                                  child: DropdownSearch<ServiceModel>(
                                      showSelectedItems: true,
                                      showClearButton: controller.serviceModel?.service=="" ? false : true,
                                      showSearchBox: true,
                                      isFilteredOnline: true,
                                      compareFn: (i, s) => i?.isEqual(s) ?? false,
                                      dropdownSearchDecoration: InputDecoration(
                                        labelText: "Service ${controller.service_obligatoire.value==1?'*':''}",
                                        contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                        border: OutlineInputBorder(),
                                      ),
                                      onFind: (String? filter) => getService(filter),
                                      onChanged: (data) {
                                        controller.selectedCodeService = data?.codeService;
                                        controller.serviceIncident = data?.service;
                                        controller.serviceModel = data;
                                        if(controller.serviceModel == null){
                                          controller.selectedCodeService = 0;
                                          controller.serviceIncident = "";
                                        }
                                        print('service: ${controller.serviceModel?.service}, code: ${controller.selectedCodeService}');
                                      },
                                      dropdownBuilder: controller.customDropDownService,
                                      popupItemBuilder: controller.customPopupItemBuilderService,
                                      validator: (u) =>
                                      (controller.serviceModel==null && controller.service_obligatoire.value==1) ? "service is required " : null,
                                      //u == null ? "service is required " : null,
                                      onBeforeChange: (a, b) {
                                        if (b == null) {
                                          AlertDialog alert = AlertDialog(
                                            title: Text("Are you sure..."),
                                            content: Text("...you want to clear the selection"),
                                            actions: [
                                              TextButton(
                                                child: Text("OK"),
                                                onPressed: () {
                                                  Navigator.of(context).pop(true);
                                                },
                                              ),
                                              TextButton(
                                                child: Text("Cancel"),
                                                onPressed: () {
                                                  Navigator.of(context).pop(false);
                                                },
                                              ),
                                            ],
                                          );
                                          return showDialog<bool>(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return alert;
                                              });
                                        }
                                        return Future.value(true);
                                      }
                                  )
                              ),
                              SizedBox(height: 10.0,),
                              Visibility(
                                  visible: controller.activity_visible.value == 1 ? controller.isVisibileActivity=true : controller.isVisibileActivity=false,
                                  child: DropdownSearch<ActivityModel>(
                                      showSelectedItems: true,
                                      showClearButton: controller.activityModel?.domaine=="" ? false : true,
                                      showSearchBox: true,
                                      isFilteredOnline: true,
                                      mode: Mode.DIALOG,
                                      compareFn: (i, s) => i?.isEqual(s) ?? false,
                                      dropdownSearchDecoration: InputDecoration(
                                        labelText: "Activity ${controller.activity_obligatoire.value==1?'*':''}",
                                        contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                        border: OutlineInputBorder(),
                                      ),
                                      onFind: (String? filter) => getActivity(filter),
                                      onChanged: (data) {
                                        controller.selectedCodeActivity = data?.codeDomaine;
                                        controller.activityIncident = data?.domaine;
                                        controller.activityModel = data;
                                        if(controller.activityModel == null){
                                          controller.selectedCodeActivity = 0;
                                          controller.activityIncident = "";
                                        }
                                        print('activity:${controller.activityModel?.domaine}, code:${controller.selectedCodeActivity}');
                                      },
                                      dropdownBuilder: controller.customDropDownActivity,
                                      popupItemBuilder: controller.customPopupItemBuilderActivity,
                                      validator: (u) =>
                                      (controller.activity_obligatoire.value==1 && controller.activityModel==null) ? "activity is required " : null,
                                      onBeforeChange: (a, b) {
                                        if (b == null) {
                                          AlertDialog alert = AlertDialog(
                                            title: Text("Are you sure..."),
                                            content: Text("...you want to clear the selection"),
                                            actions: [
                                              TextButton(
                                                child: Text("OK"),
                                                onPressed: () {
                                                  controller.selectedCodeActivity = 0;
                                                  Navigator.of(context).pop(true);
                                                },
                                              ),
                                              TextButton(
                                                child: Text("Cancel"),
                                                onPressed: () {
                                                  Navigator.of(context).pop(false);
                                                },
                                              ),
                                            ],
                                          );
                                          return showDialog<bool>(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return alert;
                                              });
                                        }
                                        return Future.value(true);
                                      }
                                  )
                              ),

                              SizedBox(height: 20.0,),
                              ConstrainedBox(
                                constraints: BoxConstraints.tightFor(width: 130, height: 50),
                                child: ElevatedButton.icon(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    backgroundColor:
                                    MaterialStateProperty.all(CustomColors.googleBackground),
                                    padding: MaterialStateProperty.all(EdgeInsets.all(14)),
                                  ),
                                  icon: controller.isDataProcessing.value ? CircularProgressIndicator():Icon(Icons.save),
                                  label: Text(
                                    controller.isDataProcessing.value ? 'Processing' : 'Save',
                                    style: TextStyle(fontSize: 16, color: Colors.white),
                                  ),
                                  onPressed: () {
                                    controller.isDataProcessing.value ? null : controller.saveBtn();
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                    ),
                  ),
                );
              }
              else{
                return Center(
                  child: LoadingView(),
                );
              }
            }),
          )
      ),
    );
  }

  //dropdown
  //type audit
  Future<List<TypeAuditModel>> getType(filter) async {
    try {
      List<TypeAuditModel> listType = await List<TypeAuditModel>.empty(growable: true);
      List<TypeAuditModel> filterType = await List<TypeAuditModel>.empty(growable: true);
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none){
        var response = await controller.localAuditService.readTypeAudit();
        response.forEach((data){
          var model = TypeAuditModel();
          model.codeType = data['codeType'];
          model.type = data['type'];
          listType.add(model);
        });
      }
      else if(connection == ConnectivityResult.mobile || connection == ConnectivityResult.wifi){
        await AuditService().getTypeAudit(controller.matricule).then((resp) async {
          resp.forEach((element) async {
            var model = TypeAuditModel();
            model.codeType = element['codeTypeA'];
            model.type = element['typeA'];
            listType.add(model);
          });
        }
            , onError: (err) {
              ShowSnackBar.snackBar("Error type audit", err.toString(), Colors.red);
            });
      }
      filterType = listType.where((u) {
        var code = u.codeType.toString().toLowerCase();
        var description = u.type!.toLowerCase();
        return code.contains(filter) ||
            description.contains(filter);
      }).toList();
      return filterType;
    }
    catch(Exception) {
      if(kDebugMode){
        print('exception type audit : ${Exception.toString()}');
      }
      ShowSnackBar.snackBar("Exception type audit", Exception.toString(), Colors.red);
      return Future.error('service : ${Exception.toString()}');
    }
  }
  //champ audit
  Future<List<ChampAuditModel>> getChampAudit(filter) async {
    try {
      List<ChampAuditModel> listType = await List<ChampAuditModel>.empty(growable: true);
      List<ChampAuditModel> filterType = await List<ChampAuditModel>.empty(growable: true);
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none){
        var response = await controller.localAuditService.readChampAudit();
        response.forEach((element){
          var model = ChampAuditModel();
          model.codeChamp = element['codeChamp'];
          model.champ = element['champ'];
          model.criticite = element['criticite'];
          listType.add(model);
        });
      }
      else if(connection == ConnectivityResult.mobile || connection == ConnectivityResult.wifi){
        await AuditService().getChampAudit(controller.matricule).then((resp) async {
          resp.forEach((element) async {
            var model = ChampAuditModel();
            model.codeChamp = element['codeChamp'];
            model.champ = element['champ'];
            model.criticite = element['criticite'];
            listType.add(model);
          });
        }
            , onError: (err) {
              ShowSnackBar.snackBar("Error type audit", err.toString(), Colors.red);
            });
      }
      filterType = listType.where((u) {
        var code = u.codeChamp.toString().toLowerCase();
        var description = u.champ!.toLowerCase();
        return code.contains(filter) ||
            description.contains(filter);
      }).toList();
      return filterType;
    }
    catch(Exception) {
      if(kDebugMode){
        print('exception type audit : ${Exception.toString()}');
      }
      ShowSnackBar.snackBar("Exception type audit", Exception.toString(), Colors.red);
      return Future.error('service : ${Exception.toString()}');
    }
  }
//Site
  Future<List<SiteModel>> getSite(filter) async {
    try {
      List<SiteModel> siteList = await List<SiteModel>.empty(growable: true);
      List<SiteModel> siteFilter = await <SiteModel>[];
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        var sites = await controller.localActionService.readSiteByModule("Audit", "Audit");
        sites.forEach((data){
          var model = SiteModel();
          model.codesite = data['codesite'];
          model.site = data['site'];
          siteList.add(model);
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        await ApiServicesCall().getSite({
          "mat": controller.matricule.toString(),
          "modul": "Audit",
          "site": "0",
          "agenda": 0,
          "fiche": "Audit"
        }).then((resp) async {
          resp.forEach((data) async {
            var model = SiteModel();
            model.codesite = data['codesite'];
            model.site = data['site'];
            siteList.add(model);
          });
        }
            , onError: (err) {
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });
      }
      siteFilter = siteList.where((u) {
        var name = u.codesite.toString().toLowerCase();
        var description = u.site!.toLowerCase();
        return name.contains(filter) ||
            description.contains(filter);
      }).toList();
      return siteFilter;
    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }
  //Processus
  Future<List<ProcessusModel>> getProcessus(filter) async {
    try {
      List<ProcessusModel> processusList = await List<ProcessusModel>.empty(growable: true);
      List<ProcessusModel> processusFilter = await <ProcessusModel>[];
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        var sites = await controller.localActionService.readProcessusByModule("Audit", "Audit");
        sites.forEach((data){
          var model = ProcessusModel();
          model.codeProcessus = data['codeProcessus'];
          model.processus = data['processus'];
          processusList.add(model);
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        await ApiServicesCall().getProcessus({
          "mat": controller.matricule.toString(),
          "modul": "Audit",
          "processus": "0",
          "fiche": "Audit"
        }).then((resp) async {
          resp.forEach((data) async {
            //print('get processus : ${data} ');
            var model = ProcessusModel();
            model.codeProcessus = data['codeProcessus'];
            model.processus = data['processus'];
            processusList.add(model);
          });
        }
            , onError: (err) {
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });
      }
      processusFilter = processusList.where((u) {
        var name = u.codeProcessus.toString().toLowerCase();
        var description = u.processus!.toLowerCase();
        return name.contains(filter) ||
            description.contains(filter);
      }).toList();
      return processusFilter;
    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }
  //Direction
  Future<List<DirectionModel>> getDirection(filter) async {
    try {
      List<DirectionModel> directionList = await List<DirectionModel>.empty(growable: true);
      List<DirectionModel> directionFilter = await <DirectionModel>[];
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        var response = await controller.localActionService.readDirectionByModule("Audit", "Audit");
        response.forEach((data){
          var model = DirectionModel();
          model.codeDirection = data['codeDirection'];
          model.direction = data['direction'];
          directionList.add(model);
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        await ApiServicesCall().getDirection({
          "mat": controller.matricule.toString(),
          "modul": "Audit",
          "fiche": "Audit",
          "direction": 0
        }).then((resp) async {
          resp.forEach((data) async {
            //print('get direction : ${data} ');
            var model = DirectionModel();
            model.codeDirection = data['code_direction'];
            model.direction = data['direction'];
            directionList.add(model);
          });
        }
            , onError: (err) {
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });
      }
      directionFilter = directionList.where((u) {
        var name = u.codeDirection.toString().toLowerCase();
        var description = u.direction!.toLowerCase();
        return name.contains(filter) ||
            description.contains(filter);
      }).toList();
      return directionFilter;
    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }
  //Service
  Future<List<ServiceModel>> getService(filter) async {
    if(controller.directionModel == null){
      Get.snackbar("No Data", "Please select Direction", colorText: Colors.blue, snackPosition: SnackPosition.BOTTOM);
    }
    try {

      List<ServiceModel> serviceList = await List<ServiceModel>.empty(growable: true);
      List<ServiceModel> serviceFilter = await List<ServiceModel>.empty(growable: true);

      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        var response = await controller.localActionService.readServiceByModuleAndDirection('Audit', 'Audit', controller.selectedCodeDirection);
        print('response service : $response');
        response.forEach((data){
          var model = ServiceModel();
          model.codeService = data['codeService'];
          model.service = data['service'];
          model.codeDirection = data['codeDirection'];
          model.direction = data['direction'];
          serviceList.add(model);
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        await ApiServicesCall().getService(controller.matricule, controller.selectedCodeDirection, 'Audit', 'Audit')
            .then((resp) async {
          resp.forEach((data) async {
            print('get service : ${data} ');
            var model = ServiceModel();
            model.codeService = data['codeService'];
            model.service = data['service'];
            model.codeDirection = data['idDirection'];
            model.module = data['module'];
            model.fiche = data['fiche'];
            serviceList.add(model);
          });
        }
            , onError: (err) {
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });
      }
      serviceFilter = await serviceList.where((u) {
        serviceFilter = List<ServiceModel>.empty(growable: true);
        var query = u.service!.toLowerCase();
        return query.contains(filter);
      }).toList();
      return serviceFilter;
      /* return serviceList.where((element) {
        final query = element.service!.toLowerCase();
        return query.contains(filter);
      }).toList();*/
    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }
  //Activity
  Future<List<ActivityModel>> getActivity(filter) async {
    try {
      List<ActivityModel> activityList = await List<ActivityModel>.empty(growable: true);
      List<ActivityModel> activityFilter = await <ActivityModel>[];
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        var response = await controller.localActionService.readActivityByModule("Audit", "Audit");
        response.forEach((data){
          var model = ActivityModel();
          model.codeDomaine = data['codeDomaine'];
          model.domaine = data['domaine'];
          activityList.add(model);
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        await ApiServicesCall().getActivity({
          "mat": controller.matricule.toString(),
          "modul": "Audit",
          "fiche": "Audit",
          "domaine": ""
        }).then((resp) async {
          resp.forEach((data) async {
            //print('get activity : ${data} ');
            var model = ActivityModel();
            model.codeDomaine = data['code_domaine'];
            model.domaine = data['domaine'];
            activityList.add(model);
          });
        }
            , onError: (err) {
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });
      }
      activityFilter = activityList.where((u) {
        var name = u.codeDomaine.toString().toLowerCase();
        var description = u.domaine!.toLowerCase();
        return name.contains(filter) ||
            description.contains(filter);
      }).toList();
      return activityFilter;
    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }
}