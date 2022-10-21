import 'package:connectivity/connectivity.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:qualipro_flutter/Models/type_cause_model.dart';
import '../../Controllers/action/action_controller.dart';
import '../../Models/activity_model.dart';
import '../../Models/audit_action_model.dart';
import '../../Models/direction_model.dart';
import '../../Models/employe_model.dart';
import '../../Models/processus_model.dart';
import '../../Models/product_model.dart';
import '../../Models/resp_cloture_model.dart';
import '../../Models/service_model.dart';
import '../../Models/site_model.dart';
import '../../Models/action/source_action_model.dart';
import '../../Models/action/type_action_model.dart';
import '../../Models/user_model.dart';
import '../../Services/api_services_call.dart';
import '../../Utils/custom_colors.dart';
import '../../Utils/snack_bar.dart';
import '../../Validators/validator.dart';
import '../../Widgets/loading_widget.dart';

class NewActionPage extends GetView<ActionController> {
  @override
  Widget build(BuildContext context) {

    final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
    final _multiKey = GlobalKey<DropdownSearchState<String>>();
    final _filterEditTextController = TextEditingController();

    return Scaffold(
        key: _globalKey,
        appBar: AppBar(
          leading: RaisedButton(
            onPressed: (){
              Get.back();
              controller.clearData();
            },
            elevation: 0.0,
            child: Icon(Icons.arrow_back, color: Colors.white,),
            color: Colors.blue,
          ),
          title: Center(
            child: Text("Ajouter Action"),
          ),
          backgroundColor: Colors.blue,
        ),
        body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx((){
                if(controller.isVisibleNewAction.value == true){
                  return Card(
                    child: SingleChildScrollView(
                      child: Form(
                          key: controller.addItemFormKey,
                          child: Padding(
                              padding: EdgeInsets.all(25.0),
                              child: Column(
                                children: <Widget>[
                                  SizedBox(height: 8.0,),
                                  TextFormField(
                                    enabled: false,
                                    controller: controller.declencheurController,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    validator: (value) => Validator.validateField(
                                        value: value!
                                    ),
                                    decoration: InputDecoration(
                                      labelText: 'Declencheur',
                                      hintText: 'declencheur',
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
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                  SizedBox(height: 10.0,),
                                  TextFormField(
                                    controller: controller.actionController,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    validator: (value) => Validator.validateField(
                                        value: value!
                                    ),
                                    decoration: InputDecoration(
                                      labelText: 'Action *',
                                      hintText: 'action',
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
                                      /*suffixIcon: InkWell(
                                    onTap: (){
                                      actionController.clear();
                                    },
                                    child: Icon(Icons.close),
                                  ) */
                                    ),
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                  SizedBox(height: 10.0,),
                                  TextFormField(
                                    controller: controller.descriptionController,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      labelText: 'Description',
                                      hintText: 'description',
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
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                  SizedBox(height: 10.0,),
                                  TextFormField(
                                    controller: controller.causeController,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                        labelText: 'Cause',
                                        hintText: 'cause',
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
                                  SizedBox(height: 10.0,),
                                  Visibility(
                                    visible: true,
                                    child: TextFormField(
                                      controller: controller.refInterneController,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                          labelText: 'Ref. interne',
                                          hintText: 'Ref. interne',
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
                                  TextFormField(
                                    controller: controller.dateController,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    validator: (value) => Validator.validateField(
                                        value: value!
                                    ),
                                    onChanged: (value){
                                      controller.selectedDate(context);
                                    },
                                    decoration: InputDecoration(
                                        labelText: 'Date creation',
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
                                            controller.selectedDate(context);
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
                                  Visibility(
                                    visible: controller.date_saisie_visible == 1 ? controller.isVisibileDateSaisie=true : controller.isVisibileDateSaisie=false,
                                    child: TextFormField(
                                      enabled: false,
                                      controller: controller.dateSaisieController,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      validator: (value) => Validator.validateField(
                                          value: value!
                                      ),
                                      onChanged: (value){
                                        controller.selectedDate(context);
                                      },
                                      decoration: InputDecoration(
                                          labelText: 'Date saisie',
                                          hintText: 'date saisie',
                                          labelStyle: TextStyle(
                                            fontSize: 14.0,
                                          ),
                                          hintStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 10.0,
                                          ),
                                          suffixIcon: InkWell(
                                            onTap: (){
                                              controller.selectedDate(context);
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
                                  ),
                                  SizedBox(height: 10.0,),
                                  Visibility(
                                      visible: true,
                                      child: DropdownSearch<TypeActionModel>(
                                        showSelectedItems: true,
                                        showClearButton: controller.typeActionModel?.typeAct=="" ? false : true,
                                        showSearchBox: true,
                                        isFilteredOnline: true,
                                        compareFn: (i, s) => i?.isEqual(s) ?? false,
                                        dropdownSearchDecoration: InputDecoration(
                                          labelText: "Type *",
                                          contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                          border: OutlineInputBorder(),
                                        ),
                                        onFind: (String? filter) => getTypes(filter),
                                        onChanged: (data) {
                                          controller.selectedCodeTypeAct = data?.codetypeAct;
                                          controller.typeActionModel = data;
                                          if(controller.typeActionModel == null){
                                            controller.selectedCodeTypeAct = 0;
                                          }
                                          print('type action: ${controller.typeActionModel?.typeAct}, code: ${controller.selectedCodeTypeAct}');
                                        },
                                        dropdownBuilder: controller.customDropDownType,
                                        popupItemBuilder: controller.customPopupItemBuilderType,
                                        validator: (u) =>
                                        u == null ? "type is required " : null,
                                      )
                                  ),

                                  SizedBox(height: 10.0,),
                                  Visibility(
                                      visible: true,
                                      child: DropdownSearch<SourceActionModel>(
                                        showSelectedItems: true,
                                        showClearButton: controller.sourceActionModel?.sourceAct=="" ? false : true,
                                        showSearchBox: true,
                                        isFilteredOnline: true,
                                        compareFn: (i, s) => i?.isEqual(s) ?? false,
                                        dropdownSearchDecoration: InputDecoration(
                                          labelText: "Source *",
                                          contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                          border: OutlineInputBorder(),
                                        ),
                                        onFind: (String? filter) => getSources(filter),
                                        onChanged: (data) {
                                          controller.selectedCodeSourceAct = data?.codeSouceAct;
                                          controller.sourceActionModel =data;
                                          if(controller.sourceActionModel == null){
                                            controller.selectedCodeSourceAct = 0;
                                          }
                                          print('source action :${controller.sourceActionModel?.sourceAct}, code :${controller.selectedCodeSourceAct}');
                                        },
                                        dropdownBuilder: controller.customDropDownSource,
                                        popupItemBuilder: controller.customPopupItemBuilderSource,
                                        validator: (u) =>
                                        u == null ? "source is required " : null,
                                      )
                                  ),

                                  SizedBox(height: 10.0,),
                                  Visibility(
                                      visible: controller.ref_audit_visible == 1 ? controller.isVisibileRefAudit=true : controller.isVisibileRefAudit=false,
                                      child: DropdownSearch<AuditActionModel>(
                                        showSelectedItems: true,
                                        showClearButton: controller.auditActionModel?.idaudit=="" ? false : true,
                                        showSearchBox: true,
                                        isFilteredOnline: true,
                                        compareFn: (i, s) => i?.isEqual(s) ?? false,
                                        dropdownSearchDecoration: InputDecoration(
                                          labelText: "Ref Audit",
                                          contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                          border: OutlineInputBorder(),
                                        ),
                                        onFind: (String? filter) => getRefAudit(filter),
                                        onChanged: (data) {
                                          controller.selectedRefAuditAct = data?.refAudit;
                                          controller.selectedIdAudit = data?.idaudit;
                                          controller.auditActionModel = data;
                                          if(controller.auditActionModel == null){
                                            controller.selectedIdAudit = 0;
                                          }
                                          print(controller.selectedRefAuditAct);
                                          print(controller.selectedIdAudit);
                                          print('ref audit:${controller.auditActionModel?.refAudit}, id: ${controller.selectedIdAudit}');
                                        },
                                        dropdownBuilder: controller.customDropDownRefAudit,
                                        popupItemBuilder: controller.customPopupItemBuilderRefAudit,
                                      )
                                  ),
                                  SizedBox(height: 10.0,),
                                  Visibility(
                                      visible:controller.site_visible == 1 ? controller.isVisibileSite=true : controller.isVisibileSite=false,
                                      child: DropdownSearch<SiteModel>(
                                          showSelectedItems: true,
                                          showClearButton: controller.siteModel?.site=="" ? false : true,
                                          showSearchBox: true,
                                          isFilteredOnline: true,
                                          compareFn: (i, s) => i?.isEqual(s) ?? false,
                                          dropdownSearchDecoration: InputDecoration(
                                            labelText: "Site ${controller.site_obligatoire==1?'*':''}",
                                            contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                            border: OutlineInputBorder(),
                                          ),
                                          onFind: (String? filter) => getSite(filter),
                                          onChanged: (data) {
                                            controller.siteModel = data;
                                            print(controller.siteModel?.site);
                                            controller.selectedSiteCode = data?.codesite;
                                            print(controller.selectedSiteCode);
                                            if(controller.siteModel == null){
                                              controller.selectedSiteCode = 0;
                                            }
                                          },
                                          dropdownBuilder: controller.customDropDownSite,
                                          popupItemBuilder: controller.customPopupItemBuilderSite,
                                          validator: (u) =>
                                          (controller.site_obligatoire==1 && controller.siteModel==null) ? "site is required " : null,
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
                                                    controller.selectedSiteCode = 0;
                                                    print('clear site : ${controller.selectedSiteCode}');
                                                    return alert;
                                                  });
                                            }

                                            return Future.value(true);
                                          }
                                      )
                                  ),
                                  SizedBox(height: 10.0,),
                                  Visibility(
                                      visible: controller.processus_visible == 1 ? controller.isVisibileProcessus=true : controller.isVisibileProcessus=false,
                                      child: DropdownSearch<ProcessusModel>(
                                          showSelectedItems: true,
                                          showClearButton: controller.processusModel?.processus=="" ? false : true,
                                          showSearchBox: true,
                                          isFilteredOnline: true,
                                          compareFn: (i, s) => i?.isEqual(s) ?? false,
                                          dropdownSearchDecoration: InputDecoration(
                                            labelText: "Processus ${controller.processus_obligatoire==1?'*':''}",
                                            contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                            border: OutlineInputBorder(),
                                          ),
                                          onFind: (String? filter) => getProcessus(filter),
                                          onChanged: (data) {
                                            controller.selectedProcessusCode = data?.codeProcessus;
                                            controller.processusModel = data;
                                            print(controller.processusModel?.processus);
                                            print(controller.selectedProcessusCode);
                                            if(controller.processusModel == null){
                                              controller.selectedProcessusCode = 0;
                                            }
                                          },
                                          dropdownBuilder: controller.customDropDownProcessus,
                                          popupItemBuilder: controller.customPopupItemBuilderProcessus,
                                          validator: (u) =>
                                          (controller.processus_obligatoire==1 && controller.processusModel==null) ? "processus is required " : null,
                                          onBeforeChange: (a, b) {
                                            if (b == null) {
                                              AlertDialog alert = AlertDialog(
                                                title: Text("Are you sure..."),
                                                content: Text("...you want to clear the selection"),
                                                actions: [
                                                  TextButton(
                                                    child: Text("OK"),
                                                    onPressed: () {
                                                      controller.selectedProcessusCode = 0;
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
                                      visible: true,
                                      child: DropdownSearch<RespClotureModel>(
                                          showSelectedItems: true,
                                          showClearButton: controller.respClotureModel?.nompre=="" ? false : true,
                                          showSearchBox: true,
                                          isFilteredOnline: true,
                                          compareFn: (i, s) => i?.isEqual(s) ?? false,
                                          dropdownSearchDecoration: InputDecoration(
                                            labelText: "Responsable Cloture",
                                            contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                            border: OutlineInputBorder(),
                                          ),
                                          onFind: (String? filter) => getRespCloture(filter),
                                          onChanged: (data) {
                                            controller.selectedRespClotureCode = data?.mat;
                                            controller.respClotureModel = data;
                                            if(controller.respClotureModel == null){
                                              controller.selectedRespClotureCode = "";
                                            }
                                            print('resp cloture: ${controller.respClotureModel?.nompre}, mat : ${controller.selectedRespClotureCode}');
                                          },
                                          dropdownBuilder: controller.customDropDownRespCloture,
                                          popupItemBuilder: controller.customPopupItemBuilderRespCloture,
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
                                      visible: true,
                                      child: DropdownSearch<EmployeModel>(
                                          showSelectedItems: true,
                                          showClearButton: controller.resSuiviModel?.nompre=="" ? false : true,
                                          showSearchBox: true,
                                          isFilteredOnline: true,
                                          compareFn: (i, s) => i?.isEqual(s) ?? false,
                                          dropdownSearchDecoration: InputDecoration(
                                            labelText: "Responsable Suivi",
                                            contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                            border: OutlineInputBorder(),
                                          ),
                                          onFind: (String? filter) => getEmploye(filter),
                                          onChanged: (data) {
                                            controller.selectedResSuiviCode = data?.mat;
                                            controller.resSuiviModel = data;
                                            if(controller.resSuiviModel == null){
                                              controller.selectedResSuiviCode = "";
                                            }
                                            print('resp suivi : ${controller.resSuiviModel?.nompre}, mat:${controller.selectedResSuiviCode}');
                                          },
                                          dropdownBuilder: controller.customDropDownRespSuivi,
                                          popupItemBuilder: controller.customPopupItemBuilderEmploye,
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
                                      visible: controller.origine_action_visible == 1 ? controller.isVisibileOrigineAction=true : controller.isVisibileOrigineAction=false,
                                      child: DropdownSearch<EmployeModel>(
                                          showSelectedItems: true,
                                          showClearButton: controller.employeModel?.nompre=="" ? false : true,
                                          showSearchBox: true,
                                          isFilteredOnline: true,
                                          compareFn: (i, s) => i?.isEqual(s) ?? false,
                                          dropdownSearchDecoration: InputDecoration(
                                            labelText: "A l'origine de l'action",
                                            contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                            border: OutlineInputBorder(),
                                          ),
                                          onFind: (String? filter) => getEmploye(filter),
                                          onChanged: (data) {
                                            controller.selectedOriginActionMat = data?.mat;
                                            controller.employeModel = data;
                                            if(controller.employeModel == null){
                                              controller.selectedOriginActionMat = "";
                                            }
                                            print('origine de action : ${controller.employeModel?.nompre}, mat:${controller.selectedOriginActionMat}');
                                          },
                                          dropdownBuilder: controller.customDropDownEmploye,
                                          popupItemBuilder: controller.customPopupItemBuilderEmploye,
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
                                      visible: controller.direction_visible == 1 ? controller.isVisibileDirection=true : controller.isVisibileDirection=false,
                                      child: DropdownSearch<DirectionModel>(
                                          showSelectedItems: true,
                                          showClearButton: controller.directionModel?.direction=="" ? false : true,
                                          showSearchBox: true,
                                          isFilteredOnline: true,
                                          compareFn: (i, s) => i?.isEqual(s) ?? false,
                                          dropdownSearchDecoration: InputDecoration(
                                            labelText: "Direction ${controller.direction_obligatoire==1?'*':''}",
                                            contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                            border: OutlineInputBorder(),
                                          ),
                                          onFind: (String? filter) => getDirection(filter),
                                          onChanged: (data) {
                                            controller.selectedDirectionCode = data?.codeDirection;
                                            controller.directionModel = data;
                                            if(controller.directionModel == null){
                                              controller.selectedDirectionCode = 0;
                                            }
                                            print('direction: ${controller.directionModel?.direction}, code: ${controller.selectedDirectionCode}');
                                          },
                                          dropdownBuilder: controller.customDropDownDirection,
                                          popupItemBuilder: controller.customPopupItemBuilderDirection,
                                          validator: (u) =>
                                          (controller.direction_obligatoire==1 && controller.directionModel==null) ? "direction is required " : null,
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
                                      visible: controller.service_visible == 1 ? controller.isVisibileService=true : controller.isVisibileService=false,
                                      child: DropdownSearch<ServiceModel>(
                                          showSelectedItems: true,
                                          showClearButton: controller.serviceModel?.service=="" ? false : true,
                                          showSearchBox: true,
                                          isFilteredOnline: true,
                                          compareFn: (i, s) => i?.isEqual(s) ?? false,
                                          dropdownSearchDecoration: InputDecoration(
                                            labelText: "Service ${controller.service_obligatoire==1?'*':''}",
                                            contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                            border: OutlineInputBorder(),
                                          ),
                                          onFind: (String? filter) => getService(filter),
                                          onChanged: (data) {
                                            controller.selectedServiceCode = data?.codeService;
                                            controller.serviceModel = data;
                                            if(controller.serviceModel == null){
                                              controller.selectedServiceCode = 0;
                                            }
                                            print('service: ${controller.serviceModel?.service}, code: ${controller.selectedServiceCode}');
                                          },
                                          dropdownBuilder: controller.customDropDownService,
                                          popupItemBuilder: controller.customPopupItemBuilderService,
                                          validator: (u) =>
                                          (controller.serviceModel==null && controller.service_obligatoire==1) ? "service is required " : null,
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
                                      visible: controller.activity_visible == 1 ? controller.isVisibileActivity=true : controller.isVisibileActivity=false,
                                      child: DropdownSearch<ActivityModel>(
                                          showSelectedItems: true,
                                          showClearButton: controller.activityModel?.domaine=="" ? false : true,
                                          showSearchBox: true,
                                          isFilteredOnline: true,
                                          mode: Mode.DIALOG,
                                          compareFn: (i, s) => i?.isEqual(s) ?? false,
                                          dropdownSearchDecoration: InputDecoration(
                                            labelText: "Activity ${controller.activity_obligatoire==1?'*':''}",
                                            contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                            border: OutlineInputBorder(),
                                          ),
                                          onFind: (String? filter) => getActivity(filter),
                                          onChanged: (data) {
                                            controller.selectedActivityCode = data?.codeDomaine;
                                            controller.activityModel = data;
                                            if(controller.activityModel == null){
                                              controller.selectedActivityCode = 0;
                                            }
                                            print('activity:${controller.activityModel?.domaine}, code activity:${controller.selectedActivityCode}');
                                          },
                                          dropdownBuilder: controller.customDropDownActivity,
                                          popupItemBuilder: controller.customPopupItemBuilderActivity,
                                          validator: (u) =>
                                          (controller.activity_obligatoire==1 && controller.activityModel==null) ? "activity is required " : null,
                                          onBeforeChange: (a, b) {
                                            if (b == null) {
                                              AlertDialog alert = AlertDialog(
                                                title: Text("Are you sure..."),
                                                content: Text("...you want to clear the selection"),
                                                actions: [
                                                  TextButton(
                                                    child: Text("OK"),
                                                    onPressed: () {
                                                      controller.selectedActivityCode = 0;
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
                                      visible: true,
                                      child: TextFormField(
                                        controller: controller.commentaireController,
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                          labelText: 'Commentaire',
                                          hintText: 'commentaire',
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
                                        style: TextStyle(fontSize: 14.0),
                                        minLines: 2,
                                        maxLines: 5,
                                      )
                                  ),
                                  SizedBox(height: 10.0,),
                                  Visibility(
                                      visible: controller.objectif_visible == 1 ? controller.isVisibileObjectif=true : controller.isVisibileObjectif=false,
                                      child: TextFormField(
                                        controller: controller.objectifController,
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                          labelText: 'Objectif',
                                          hintText: 'Objectif',
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
                                        style: TextStyle(fontSize: 14.0),
                                      )
                                  ),
                                 // SizedBox(height: 10.0,),

                                /*  Visibility(
                                    visible: controller.product_visible == 1 ? controller.isVisibileProduct=true : controller.isVisibileProduct=false,
                                    child: DropdownSearch<ProductModel>.multiSelection(
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
                                      compareFn: (item, selectedItem) => item?.codePdt == selectedItem?.codePdt,
                                      showSearchBox: true,

                                      dropdownSearchDecoration: InputDecoration(
                                        labelText: "Product",
                                        contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                        border: OutlineInputBorder(),
                                      ),
                                      autoValidateMode: AutovalidateMode.onUserInteraction,
                                      onFind: (String? filter) => getProduct(filter),
                                      onChanged: (data) {
                                        print(data);
                                        //print('mat: ${data.map((e) => e.mat)}');
                                        //List<String> listString =  controller.productList.addAll(data.map((e) => e.codePdt.toString()));
                                        //print('list product : ${listString}');
                                        data.forEach((element) {
                                          print('produit: ${element.produit}, code: ${element.codePdt}');
                                          List<String> listCodeProduct = [];
                                          listCodeProduct.add(element.codePdt.toString());
                                          controller.productList.addAll(listCodeProduct);
                                          //print('product list : ${listCodeProduct}');
                                        });
                                      },
                                      dropdownBuilder: controller.customDropDownMultiSelectionProduct,
                                      popupItemBuilder: controller.customPopupItemBuilderProduct,
                                      popupSafeArea: PopupSafeAreaProps(top: true, bottom: true),
                                      scrollbarProps: ScrollbarProps(
                                        isAlwaysShown: true,
                                        thickness: 7,
                                      ),
                                    ),
                                  ), */

                                  SizedBox(height: 10.0,),
                                  Visibility(
                                    visible: controller.type_cause_visible == 1 ? controller.isVisibileTypeCause=true : controller.isVisibileTypeCause=false,
                                    child: DropdownSearch<TypeCauseModel>.multiSelection(
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
                                      compareFn: (item, selectedItem) => item?.codetypecause == selectedItem?.codetypecause,
                                      showSearchBox: true,
                                      dropdownSearchDecoration: InputDecoration(
                                        labelText: "Types Causes",
                                        contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                        border: OutlineInputBorder(),
                                      ),
                                      autoValidateMode: AutovalidateMode.onUserInteraction,
                                      /* validator: (u) =>
                                  u == null || u.isEmpty ? "user field is required " : null, */
                                      onFind: (String? filter) => getTypesCause(filter),
                                      onChanged: (data) {
                                        controller.typeCauseList.clear();
                                        controller.listTypeCauseOffline.clear();
                                        controller.listTypeCauseOffline.addAll(data);
                                        data.forEach((element) {
                                          print('type cause: ${element.typecause}, code: ${element.codetypecause}');
                                          List<int?> listCodeTypeCause = [];
                                          listCodeTypeCause.add(element.codetypecause);
                                          controller.typeCauseList.addAll(listCodeTypeCause);
                                        });
                                      },
                                      dropdownBuilder: controller.customDropDownMultiSelectionTypeCause,
                                      popupItemBuilder: controller.customPopupItemBuilderTypeCause,
                                      popupSafeArea: PopupSafeAreaProps(top: true, bottom: true),
                                      scrollbarProps: ScrollbarProps(
                                        isAlwaysShown: true,
                                        thickness: 7,
                                      ),
                                    ),
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
                                  /* ElevatedButton(
                                onPressed: () async {
                                  controller.saveBtn();
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    CustomColors.googleBackground,
                                  ),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Save',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: CustomColors.firebaseWhite,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ),
                              ) */

                                ],
                              )
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
  
  //dropdown search 
//source action
  Future<List<SourceActionModel>> getSources(filter) async {
    try {
      List<SourceActionModel> _sourcesList = await List<SourceActionModel>.empty(growable: true);
      List<SourceActionModel> _sourcesDisplay = await <SourceActionModel>[];
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        var response = await controller.localActionService.readSourceAction();
        response.forEach((data){
          var sourceModel = SourceActionModel();
          sourceModel.codeSouceAct = data['codeSouceAct'];
          sourceModel.sourceAct = data['sourceAct'];
          _sourcesList.add(sourceModel);
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        await ApiServicesCall().getSourceAction().then((resp) async {
          resp.forEach((data) async {
            print('get source actions : ${data} ');
            var model = SourceActionModel();
            model.codeSouceAct = data['codeSouceAct'];
            model.sourceAct = data['sourceAct'];
            _sourcesList.add(model);
          });
        }
            , onError: (err) {
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });
      }

      _sourcesDisplay = _sourcesList.where((u) {
        var name = u.sourceAct!.toLowerCase();
        return name.contains(filter);
      }).toList();
      return _sourcesDisplay;
    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }

  //type action
  Future<List<TypeActionModel>> getTypes(filter) async {
    try {
      List<TypeActionModel> _typesList = await List<TypeActionModel>.empty(growable: true);
      List<TypeActionModel> _typesFilter = await List<TypeActionModel>.empty(growable: true);
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        var response = await controller.localActionService.readTypeAction();
        response.forEach((data){
          var sourceModel = TypeActionModel();
          sourceModel.codetypeAct = data['codetypeAct'];
          sourceModel.typeAct = data['typeAct'];
          sourceModel.actSimpl = data['actSimpl'];
          sourceModel.analyseCause = data['analyseCause'];
          _typesList.add(sourceModel);
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        await ApiServicesCall().getTypeAction({
          "nom": "",
          "lang": ""
        }).then((resp) async {
          resp.forEach((data) async {
            var model = TypeActionModel();
            model.codetypeAct = data['codetypeAct'];
            model.typeAct = data['typeAct'];
            model.actSimpl = data['act_simpl'];
            model.analyseCause = data['analyse_cause'];
            _typesList.add(model);
          });
        }
            , onError: (err) {
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });
      }
      _typesFilter = _typesList.where((u) {
        var query = u.typeAct!.toLowerCase();
        return query.contains(filter);
      }).toList();
      return _typesFilter;

    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }

  //ref audit
  Future<List<AuditActionModel>> getRefAudit(filter) async {
    try {
      List<AuditActionModel> _refAuditList = await List<AuditActionModel>.empty(growable: true);
      List<AuditActionModel> _refAuditFilter = await <AuditActionModel>[];
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        var response = await controller.localActionService.readAuditAction();
        response.forEach((data){
          var model = AuditActionModel();
          model.idaudit = data['idaudit'];
          model.refAudit = data['refAudit'];
          model.interne = data['interne'];
          _refAuditList.add(model);
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        await ApiServicesCall().getAuditAction().then((resp) async {
          resp.forEach((data) async {
            var model = AuditActionModel();
            model.idaudit = data['idaudit'];
            model.refAudit = data['refAudit'];
            model.interne = data['interne'];
            _refAuditList.add(model);
          });
        }
            , onError: (err) {
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });
      }
      _refAuditFilter = _refAuditList.where((u) {
        var name = u.idaudit.toString().toLowerCase();
        return name.contains(filter);
      }).toList();
      return _refAuditFilter;

    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
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
        var sites = await controller.localActionService.readSiteByModule("Action", "Action");
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
          "modul": "action",
          "site": "0",
          "agenda": 0,
          "fiche": "action"
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
        var sites = await controller.localActionService.readProcessusByModule("Action", "Action");
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
          "modul": "action",
          "processus": "0",
          "fiche": "action"
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
        var response = await controller.localActionService.readDirectionByModule("Action", "Action");
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
          "modul": "action",
          "fiche": "action",
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
    if(controller.selectedDirectionCode == null){
      Get.snackbar("No Data", "Please select Direction", colorText: Colors.blue, snackPosition: SnackPosition.BOTTOM);
    }
    try {

      List<ServiceModel> serviceList = await List<ServiceModel>.empty(growable: true);
      List<ServiceModel> serviceFilter = await List<ServiceModel>.empty(growable: true);

      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        var response = await controller.localActionService.readServiceByModuleAndDirection('Action', 'Action', controller.selectedDirectionCode);
        print('response service : $response');
        response.forEach((data){
          var model = ServiceModel();
          model.codeService = data['codeService'];
          model.service = data['service'];
          model.codeDirection = data['codeDirection'];
          serviceList.add(model);
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        await ApiServicesCall().getService(controller.matricule, controller.selectedDirectionCode, 'Action', 'Action')
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
        var response = await controller.localActionService.readActivityByModule("Action", "Action");
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
          "modul": "action",
          "fiche": "action",
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

  //Resp Cloture
  Future<List<RespClotureModel>> getRespCloture(filter) async {
    try {
      if(controller.selectedSiteCode == null || controller.selectedProcessusCode == null){
        Get.snackbar("No Data", "Please select Site and Processus", colorText: Colors.blue, snackPosition: SnackPosition.BOTTOM);
      }
      List<RespClotureModel> respClotureList = await List<RespClotureModel>.empty(growable: true);
      List<RespClotureModel> respClotureFilter = await <RespClotureModel>[];
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        var response = await controller.localActionService.readResponsableClotureParams(controller.selectedSiteCode, controller.selectedProcessusCode);
        //var response = await controller.localActionService.readResponsableCloture();
        response.forEach((data){
          var model = RespClotureModel();
          model.mat = data['mat'];
          model.nompre = data['nompre'];
          model.codeSite = data['codeSite'];
          model.codeProcessus = data['codeProcessus'];
          model.site = data['site'];
          model.processus = data['processus'];
          respClotureList.add(model);
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        await ApiServicesCall().getResponsableCloture({
          "codesite": controller.selectedSiteCode,
          "codeprocessus": controller.selectedProcessusCode
        }).then((resp) async {
          resp.forEach((data) async {
            var model = RespClotureModel();
            model.mat = data['mat'];
            model.nompre = data['nompre'];
            model.codeSite = data['codeSite'];
            model.codeProcessus = data['codeProcessus'];
            model.site = data['site'];
            model.processus = data['processus'];
            respClotureList.add(model);
          });
        }
            , onError: (err) {
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });
      }

      respClotureFilter = respClotureList.where((u) {
        var name = u.nompre.toString().toLowerCase();
        var description = u.mat!.toLowerCase();
        return name.contains(filter) ||
            description.contains(filter);
      }).toList();
      return respClotureFilter;
    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }

  //Employe
  Future<List<EmployeModel>> getEmploye(filter) async {
    try {
      List<EmployeModel> employeList = await List<EmployeModel>.empty(growable: true);
      List<EmployeModel>employeFilter = await List<EmployeModel>.empty(growable: true);
      var response = await controller.localActionService.readEmploye();
      response.forEach((data){
        var model = EmployeModel();
        model.mat = data['mat'];
        model.nompre = data['nompre'];
        employeList.add(model);
      });
      employeFilter = employeList.where((u) {
        var name = u.mat.toString().toLowerCase();
        var description = u.nompre!.toLowerCase();
        return name.contains(filter) ||
            description.contains(filter);
      }).toList();
      return employeFilter;
    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }

  //Product
  Future<List<ProductModel>> getProduct(filter) async {
    try {
      List<ProductModel> productList = await List<ProductModel>.empty(growable: true);
      List<ProductModel> productFilter = await <ProductModel>[];
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        var response = await controller.localActionService.readProduct();
        response.forEach((data){
          var model = ProductModel();
          model.codePdt = data['codePdt'];
          model.produit = data['produit'];
          model.prix = data['prix'];
          model.typeProduit = data['typeProduit'];
          model.codeTypeProduit = data['codeTypeProduit'];
          productList.add(model);
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        await ApiServicesCall().getProduct({
          "codeProduit": "",
          "produit": ""
        }).then((resp) async {
          resp.forEach((data) async {
            var model = ProductModel();
            model.codePdt = data['codePdt'];
            model.produit = data['produit'];
            model.prix = data['prix'];
            model.typeProduit = data['typeProduit'];
            model.codeTypeProduit = data['codeTypeProduit'];
            productList.add(model);
          });
        }
            , onError: (err) {
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });
      }

      productFilter = productList.where((u) {
        var name = u.codePdt.toString().toLowerCase();
        var description = u.produit!.toLowerCase();
        return name.contains(filter) ||
            description.contains(filter);
      }).toList();
      return productFilter;
    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }
  //types cause
  Future<List<TypeCauseModel>> getTypesCause(filter) async {
    try {
      List<TypeCauseModel> typeCauseList = await List<TypeCauseModel>.empty(growable: true);
      List<TypeCauseModel> typeCauseFilter = await <TypeCauseModel>[];
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        //var response = await controller.localActionService.readTypeCauseAction();
        var response = await controller.localActionService.readTypeCauseActionARattacher();
        response.forEach((data){
          var model = TypeCauseModel();
          model.codetypecause = data['codetypecause'];
          model.typecause = data['typecause'];
          typeCauseList.add(model);
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
       // Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        await ApiServicesCall().getTypeCauseAction({
          "act": "",
          "typeC": "",
          "mat": controller.matricule.toString(),
          "prov": ""
        }).then((resp) async {
          resp.forEach((data) async {
            var model = TypeCauseModel();
            model.codetypecause = data['codetypecause'];
            model.typecause = data['typecause'];
            typeCauseList.add(model);
          });
        }
            , onError: (err) {
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });
      }

      typeCauseFilter = typeCauseList.where((u) {
        var name = u.codetypecause.toString().toLowerCase();
        var description = u.typecause!.toLowerCase();
        return name.contains(filter) ||
            description.contains(filter);
      }).toList();
      return typeCauseFilter;
    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }


}