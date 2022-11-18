import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qualipro_flutter/Models/client_model.dart';
import 'package:qualipro_flutter/Models/fournisseur_model.dart';
import 'package:qualipro_flutter/Models/gravite_model.dart';
import 'package:qualipro_flutter/Models/pnc/atelier_pnc_model.dart';
import 'package:qualipro_flutter/Models/pnc/isps_pnc_model.dart';
import 'package:qualipro_flutter/Models/pnc/source_pnc_model.dart';
import 'package:qualipro_flutter/Models/priorite_model.dart';
import '../../Controllers/action/sous_action_controller.dart';
import '../../../Models/employe_model.dart';
import '../../../Models/processus_employe_model.dart';
import '../../../Models/processus_model.dart';
import '../../../Services/api_services_call.dart';
import '../../../Utils/custom_colors.dart';
import '../../../Utils/snack_bar.dart';
import '../../../Validators/validator.dart';
import '../../Controllers/pnc/new_pnc_controller.dart';
import '../../Models/activity_model.dart';
import '../../Models/direction_model.dart';
import '../../Models/image_model.dart';
import '../../Models/pnc/gravite_pnc_model.dart';
import '../../Models/pnc/type_pnc_model.dart';
import '../../Models/product_model.dart';
import '../../Models/service_model.dart';
import '../../Models/site_model.dart';
import '../../Utils/utility_file.dart';
import '../../Widgets/loading_widget.dart';
import 'package:path/path.dart' as mypath;

class NewPNCPage extends GetView<NewPNCController> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        leading: TextButton(
          onPressed: () {
            Get.back();
            //controller.clearData();
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Center(
          child: Text("${'new'.tr} PNC"),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Obx(() {
          if (controller.isVisibleNewPNC.value == true) {
            return Card(
              child: SingleChildScrollView(
                child: Form(
                    key: controller.addItemFormKey,
                    child: Padding(
                        padding: EdgeInsets.all(25.0),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 10.0,
                            ),
                            TextFormField(
                              controller: controller.designationController,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.next,
                              validator: (value) =>
                                  Validator.validateField(value: value!),
                              decoration: InputDecoration(
                                labelText: '${'non_conformite'.tr} *',
                                hintText: '${'non_conformite'.tr}',
                                labelStyle: TextStyle(
                                  fontSize: 14.0,
                                ),
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10.0,
                                ),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.lightBlue, width: 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                              ),
                              style: TextStyle(fontSize: 14.0),
                              minLines: 2,
                              maxLines: 5,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            TextFormField(
                              controller: controller.actionPriseController,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText: 'action_immediate_prise'.tr,
                                hintText: 'action',
                                labelStyle: TextStyle(
                                  fontSize: 14.0,
                                ),
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10.0,
                                ),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.lightBlue, width: 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                              ),
                              style: TextStyle(fontSize: 14.0),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Visibility(
                                visible: controller.detected_by_visible == 1
                                    ? controller.isVisibileDetectedBy = true
                                    : controller.isVisibileDetectedBy = false,
                                child: DropdownSearch<EmployeModel>(
                                  showSelectedItems: true,
                                  showClearButton: true,
                                  showSearchBox: true,
                                  isFilteredOnline: true,
                                  compareFn: (i, s) => i?.isEqual(s) ?? false,
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText: "${'detected'.tr} ${'by'.tr}",
                                    contentPadding:
                                        EdgeInsets.fromLTRB(12, 12, 0, 0),
                                    border: OutlineInputBorder(),
                                  ),
                                  onFind: (String? filter) =>
                                      getEmploye(filter),
                                  onChanged: (data) {
                                    controller.detectedEmployeModel = data;
                                    controller.detectedEmployeMatricule =
                                        data?.mat;
                                    if (controller.detectedEmployeModel ==
                                        null) {
                                      controller.detectedEmployeMatricule = "";
                                    }
                                    debugPrint(
                                        'detected by : ${controller.detectedEmployeModel?.nompre}, mat:${controller.detectedEmployeMatricule}');
                                  },
                                  dropdownBuilder:
                                      controller.customDropDownDetectedEmploye,
                                  popupItemBuilder: controller
                                      .customPopupItemBuilderDetectedEmploye,
                                )),
                            SizedBox(
                              height: 10.0,
                            ),
                            Visibility(
                              visible: true,
                              child: InkWell(
                                onTap: () {
                                  controller.selectedDateDetection(context);
                                },
                                child: TextFormField(
                                  enabled: false,
                                  controller:
                                      controller.dateDetectionController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  validator: (value) =>
                                      Validator.validateField(value: value!),
                                  onChanged: (value) {
                                    controller.selectedDateDetection(context);
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'Date Detection *',
                                      hintText: 'date',
                                      labelStyle: TextStyle(
                                        fontSize: 14.0,
                                      ),
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 10.0,
                                      ),
                                      suffixIcon: InkWell(
                                        onTap: () {
                                          controller
                                              .selectedDateDetection(context);
                                        },
                                        child: Icon(Icons.calendar_today),
                                      ),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.lightBlue,
                                              width: 1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)))),
                                  style: TextStyle(fontSize: 14.0),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Visibility(
                              visible: true,
                              child: InkWell(
                                onTap: () {
                                  controller.selectedDateLivraison(context);
                                },
                                child: TextFormField(
                                  enabled: false,
                                  controller:
                                      controller.dateLivraisonController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  onChanged: (value) {
                                    controller.selectedDateLivraison(context);
                                  },
                                  decoration: InputDecoration(
                                      labelText:
                                          'Date ${'delivery'.tr} ${controller.date_liv_obligatoire == 1 ? '*' : ''}',
                                      hintText: 'date',
                                      labelStyle: TextStyle(
                                        fontSize: 14.0,
                                      ),
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 10.0,
                                      ),
                                      suffixIcon: InkWell(
                                        onTap: () {
                                          controller
                                              .selectedDateLivraison(context);
                                        },
                                        child: Icon(Icons.calendar_today),
                                      ),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.lightBlue,
                                              width: 1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)))),
                                  style: TextStyle(fontSize: 14.0),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Visibility(
                              visible: true,
                              child: TextFormField(
                                enabled: false,
                                controller: controller.dateSaisieController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                validator: (value) =>
                                    Validator.validateField(value: value!),
                                onChanged: (value) {
                                  controller.selectedDateDetection(context);
                                },
                                decoration: InputDecoration(
                                    labelText: 'date_saisie'.tr,
                                    hintText: 'date',
                                    labelStyle: TextStyle(
                                      fontSize: 14.0,
                                    ),
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10.0,
                                    ),
                                    suffixIcon: InkWell(
                                      onTap: () {
                                        controller
                                            .selectedDateDetection(context);
                                      },
                                      child: Icon(Icons.calendar_today),
                                    ),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.lightBlue, width: 1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)))),
                                style: TextStyle(fontSize: 14.0),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Visibility(
                                visible: controller.type_nc_visible == 1
                                    ? controller.isVisibileTypeNC = true
                                    : controller.isVisibileTypeNC = false,
                                child: DropdownSearch<TypePNCModel>(
                                  showSelectedItems: true,
                                  showClearButton: true,
                                  showSearchBox: true,
                                  isFilteredOnline: true,
                                  compareFn: (i, s) => i?.isEqual(s) ?? false,
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText: "Type NC *",
                                    contentPadding:
                                        EdgeInsets.fromLTRB(12, 12, 0, 0),
                                    border: OutlineInputBorder(),
                                  ),
                                  onFind: (String? filter) =>
                                      getTypePNC(filter),
                                  onChanged: (data) {
                                    controller.typePNCModel = data;
                                    controller.selectedCodeType =
                                        data?.codeTypeNC;
                                    controller.selectedTypeNc = data?.typeNC;
                                    if (controller.typePNCModel == null) {
                                      controller.selectedCodeType = 0;
                                      controller.selectedTypeNc = "";
                                    }
                                    debugPrint(
                                        'typeNC: ${controller.selectedTypeNc}, code: ${controller.selectedCodeType}');
                                  },
                                  dropdownBuilder:
                                      controller.customDropDownType,
                                  popupItemBuilder:
                                      controller.customPopupItemBuilderType,
                                  validator: (u) => u == null
                                      ? "type ${'is_required'.tr} "
                                      : null,
                                )),
                            SizedBox(
                              height: 10.0,
                            ),
                            Visibility(
                                visible: true,
                                child: DropdownSearch<GravitePNCModel>(
                                  showSelectedItems: true,
                                  showClearButton: true,
                                  showSearchBox: true,
                                  isFilteredOnline: true,
                                  compareFn: (i, s) => i?.isEqual(s) ?? false,
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText:
                                        "${'gravity'.tr} ${controller.gravite_obligatoire == 1 ? '*' : ''}",
                                    contentPadding:
                                        EdgeInsets.fromLTRB(12, 12, 0, 0),
                                    border: OutlineInputBorder(),
                                  ),
                                  onFind: (String? filter) =>
                                      getGravitePNC(filter),
                                  onChanged: (data) {
                                    controller.graviteModel = data;
                                    controller.selectedCodeGravite =
                                        data?.nGravite;
                                    if (controller.graviteModel == null) {
                                      controller.selectedCodeGravite = 0;
                                    }
                                    debugPrint(
                                        'gravite: ${controller.graviteModel?.gravite}, code: ${controller.selectedCodeGravite}');
                                  },
                                  dropdownBuilder:
                                      controller.customDropDownGravite,
                                  popupItemBuilder:
                                      controller.customPopupItemBuilderGravite,
                                  validator: (u) => (controller
                                                  .gravite_obligatoire ==
                                              1 &&
                                          controller.graviteModel == null)
                                      ? "${'gravity'.tr} ${'is_required'.tr} "
                                      : null,
                                )),
                            SizedBox(
                              height: 10.0,
                            ),
                            Visibility(
                                visible: true,
                                child: DropdownSearch<SourcePNCModel>(
                                  showSelectedItems: true,
                                  showClearButton: true,
                                  showSearchBox: true,
                                  isFilteredOnline: true,
                                  compareFn: (i, s) => i?.isEqual(s) ?? false,
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText:
                                        "Source NC ${controller.source_obligatoire == 1 ? '*' : ''}",
                                    contentPadding:
                                        EdgeInsets.fromLTRB(12, 12, 0, 0),
                                    border: OutlineInputBorder(),
                                  ),
                                  onFind: (String? filter) => getSource(filter),
                                  onChanged: (data) {
                                    controller.sourcePNCModel = data;
                                    controller.selectedCodeSource =
                                        data?.codeSourceNC;
                                    if (controller.sourcePNCModel == null) {
                                      controller.selectedCodeSource = 0;
                                    }
                                    debugPrint(
                                        'source nc: ${controller.sourcePNCModel?.sourceNC}, code: ${controller.selectedCodeSource}');
                                  },
                                  dropdownBuilder:
                                      controller.customDropDownSource,
                                  popupItemBuilder:
                                      controller.customPopupItemBuilderSource,
                                  validator: (u) =>
                                      (controller.source_obligatoire == 1 &&
                                              controller.sourcePNCModel == null)
                                          ? "Source ${'is_required'.tr} "
                                          : null,
                                )),
                            SizedBox(
                              height: 10.0,
                            ),
                            Visibility(
                                visible: controller.atelier_visible == 1
                                    ? controller.isVisibileAtelier = true
                                    : controller.isVisibileAtelier = false,
                                child: DropdownSearch<AtelierPNCModel>(
                                  showSelectedItems: true,
                                  showClearButton: true,
                                  showSearchBox: true,
                                  isFilteredOnline: true,
                                  compareFn: (i, s) => i?.isEqual(s) ?? false,
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText:
                                        "${'atelier'.tr} ${controller.atelier_obligatoire == 1 ? '*' : ''}",
                                    contentPadding:
                                        EdgeInsets.fromLTRB(12, 12, 0, 0),
                                    border: OutlineInputBorder(),
                                  ),
                                  onFind: (String? filter) =>
                                      getAtelier(filter),
                                  onChanged: (data) {
                                    controller.atelierPNCModel = data;
                                    controller.selectedCodeAtelier =
                                        data?.codeAtelier;
                                    if (controller.atelierPNCModel == null) {
                                      controller.selectedCodeAtelier = 0;
                                    }
                                    debugPrint(
                                        'atelier: ${controller.atelierPNCModel?.atelier}, code: ${controller.selectedCodeAtelier}');
                                  },
                                  dropdownBuilder:
                                      controller.customDropDownAtelier,
                                  popupItemBuilder:
                                      controller.customPopupItemBuilderAtelier,
                                  validator: (u) => (controller
                                                  .atelier_obligatoire ==
                                              1 &&
                                          controller.atelierPNCModel == null)
                                      ? "${'atelier'.tr} ${'is_required'.tr} "
                                      : null,
                                )),
                            SizedBox(
                              height: 10.0,
                            ),
                            Visibility(
                                visible: true,
                                child: DropdownSearch<ProductModel>(
                                  showSelectedItems: true,
                                  showClearButton: true,
                                  showSearchBox: true,
                                  isFilteredOnline: true,
                                  compareFn: (i, s) => i?.isEqual(s) ?? false,
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText: "${'product'.tr} *",
                                    contentPadding:
                                        EdgeInsets.fromLTRB(12, 12, 0, 0),
                                    border: OutlineInputBorder(),
                                  ),
                                  onFind: (String? filter) =>
                                      getProduct(filter),
                                  onChanged: (data) {
                                    controller.productModel = data;
                                    controller.selectedCodeProduct =
                                        data?.codePdt;
                                    controller.selectedProduct = data?.produit;
                                    if (controller.productModel == null) {
                                      controller.selectedCodeProduct = "";
                                      controller.selectedProduct = "";
                                    }
                                    debugPrint(
                                        'product: ${controller.selectedProduct}, code: ${controller.selectedCodeProduct}');
                                  },
                                  dropdownBuilder:
                                      controller.customDropDownProduct,
                                  popupItemBuilder:
                                      controller.customPopupItemBuilderProduct,
                                  validator: (u) => u == null
                                      ? "${'product'.tr} ${'is_required'.tr} "
                                      : null,
                                )),
                            SizedBox(
                              height: 10.0,
                            ),
                            Visibility(
                                visible: controller.fournisseur_visible == 1
                                    ? controller.isVisibileFournisseur = true
                                    : controller.isVisibileFournisseur = false,
                                child: DropdownSearch<FournisseurModel>(
                                  showSelectedItems: true,
                                  showClearButton: true,
                                  showSearchBox: true,
                                  isFilteredOnline: true,
                                  compareFn: (i, s) => i?.isEqual(s) ?? false,
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText:
                                        "${'fournisseur'.tr} ${controller.fournisseur_obligatoire == 1 ? '*' : ''}",
                                    contentPadding:
                                        EdgeInsets.fromLTRB(12, 12, 0, 0),
                                    border: OutlineInputBorder(),
                                  ),
                                  onFind: (String? filter) =>
                                      getFournisseur(filter),
                                  onChanged: (data) {
                                    controller.fournisseurModel = data;
                                    controller.selectedCodeFournisseur =
                                        data?.codeFr;
                                    controller.selectedFournisseur =
                                        data?.raisonSociale;
                                    if (controller.fournisseurModel == null) {
                                      controller.selectedCodeFournisseur = "";
                                      controller.selectedFournisseur = "";
                                    }
                                    debugPrint(
                                        'fournisseur: ${controller.fournisseurModel?.activite}, code: ${controller.selectedCodeFournisseur}');
                                  },
                                  dropdownBuilder:
                                      controller.customDropDownFournisseur,
                                  popupItemBuilder: controller
                                      .customPopupItemBuilderFournisseur,
                                  validator: (u) => (controller
                                                  .fournisseur_obligatoire ==
                                              1 &&
                                          controller.fournisseurModel == null)
                                      ? "${'fournisseur'.tr} ${'is_required'.tr} "
                                      : null,
                                )),
                            SizedBox(
                              height: 10.0,
                            ),
                            Visibility(
                                visible: controller.site_visible.value == 1
                                    ? controller.isVisibileSite = true
                                    : controller.isVisibileSite = false,
                                child: DropdownSearch<SiteModel>(
                                  showSelectedItems: true,
                                  showClearButton:
                                      controller.siteModel?.site == ""
                                          ? false
                                          : true,
                                  showSearchBox: true,
                                  isFilteredOnline: true,
                                  compareFn: (i, s) => i?.isEqual(s) ?? false,
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText:
                                        "Site ${controller.site_obligatoire.value == 1 ? '*' : ''}",
                                    contentPadding:
                                        EdgeInsets.fromLTRB(12, 12, 0, 0),
                                    border: OutlineInputBorder(),
                                  ),
                                  onFind: (String? filter) => getSite(filter),
                                  onChanged: (data) {
                                    controller.siteModel = data;
                                    controller.selectedCodeSite =
                                        data?.codesite;
                                    controller.selectedSite = data?.site;
                                    if (controller.siteModel == null) {
                                      controller.selectedCodeSite = 0;
                                      controller.selectedSite = "";
                                    }
                                    debugPrint(
                                        'site: ${controller.selectedSite}, code: ${controller.selectedCodeSite}');
                                  },
                                  dropdownBuilder:
                                      controller.customDropDownSite,
                                  popupItemBuilder:
                                      controller.customPopupItemBuilderSite,
                                  validator: (u) =>
                                      (controller.site_obligatoire.value == 1 &&
                                              controller.siteModel == null)
                                          ? "site ${'is_required'.tr} "
                                          : null,
                                )),
                            SizedBox(
                              height: 10.0,
                            ),
                            Visibility(
                                visible: controller.processus_visible.value == 1
                                    ? controller.isVisibileProcessus = true
                                    : controller.isVisibileProcessus = false,
                                child: DropdownSearch<ProcessusModel>(
                                  showSelectedItems: true,
                                  showClearButton:
                                      controller.processusModel?.processus == ""
                                          ? false
                                          : true,
                                  showSearchBox: true,
                                  isFilteredOnline: true,
                                  compareFn: (i, s) => i?.isEqual(s) ?? false,
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText:
                                        "Processus ${controller.processus_obligatoire.value == 1 ? '*' : ''}",
                                    contentPadding:
                                        EdgeInsets.fromLTRB(12, 12, 0, 0),
                                    border: OutlineInputBorder(),
                                  ),
                                  onFind: (String? filter) =>
                                      getProcessus(filter),
                                  onChanged: (data) {
                                    controller.processusModel = data;
                                    controller.selectedCodeProcessus =
                                        data?.codeProcessus;
                                    if (controller.processusModel == null) {
                                      controller.selectedCodeProcessus = 0;
                                    }
                                    debugPrint(
                                        'processus: ${controller.processusModel?.processus}, code: ${controller.selectedCodeProcessus}');
                                  },
                                  dropdownBuilder:
                                      controller.customDropDownProcessus,
                                  popupItemBuilder: controller
                                      .customPopupItemBuilderProcessus,
                                  validator: (u) =>
                                      (controller.processus_obligatoire.value ==
                                                  1 &&
                                              controller.processusModel == null)
                                          ? "processus ${'is_required'.tr} "
                                          : null,
                                )),
                            SizedBox(
                              height: 10.0,
                            ),
                            Visibility(
                                visible: controller.direction_visible.value == 1
                                    ? controller.isVisibileDirection = true
                                    : controller.isVisibileDirection = false,
                                child: DropdownSearch<DirectionModel>(
                                    showSelectedItems: true,
                                    showClearButton:
                                        controller.directionModel?.direction ==
                                                ""
                                            ? false
                                            : true,
                                    showSearchBox: true,
                                    isFilteredOnline: true,
                                    compareFn: (i, s) => i?.isEqual(s) ?? false,
                                    dropdownSearchDecoration: InputDecoration(
                                      labelText:
                                          "Direction ${controller.direction_obligatoire.value == 1 ? '*' : ''}",
                                      contentPadding:
                                          EdgeInsets.fromLTRB(12, 12, 0, 0),
                                      border: OutlineInputBorder(),
                                    ),
                                    onFind: (String? filter) =>
                                        getDirection(filter),
                                    onChanged: (data) {
                                      controller.selectedCodeDirection =
                                          data?.codeDirection;
                                      controller.directionModel = data;
                                      if (controller.directionModel == null) {
                                        controller.selectedCodeDirection = 0;
                                      }
                                      debugPrint(
                                          'direction: ${controller.directionModel?.direction}, code: ${controller.selectedCodeDirection}');
                                    },
                                    dropdownBuilder:
                                        controller.customDropDownDirection,
                                    popupItemBuilder: controller
                                        .customPopupItemBuilderDirection,
                                    validator: (u) => (controller
                                                    .direction_obligatoire
                                                    .value ==
                                                1 &&
                                            controller.directionModel == null)
                                        ? "direction ${'is_required'.tr} "
                                        : null,
                                    onBeforeChange: (a, b) {
                                      if (b == null) {
                                        AlertDialog alert = AlertDialog(
                                          title: Text("Are you sure..."),
                                          content: Text(
                                              "...you want to clear the selection"),
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
                                                Navigator.of(context)
                                                    .pop(false);
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
                                    })),
                            SizedBox(
                              height: 10.0,
                            ),
                            Visibility(
                                visible: controller.service_visible.value == 1
                                    ? controller.isVisibileService = true
                                    : controller.isVisibileService = false,
                                child: DropdownSearch<ServiceModel>(
                                    showSelectedItems: true,
                                    showClearButton:
                                        controller.serviceModel?.service == ""
                                            ? false
                                            : true,
                                    showSearchBox: true,
                                    isFilteredOnline: true,
                                    compareFn: (i, s) => i?.isEqual(s) ?? false,
                                    dropdownSearchDecoration: InputDecoration(
                                      labelText:
                                          "Service ${controller.service_obligatoire.value == 1 ? '*' : ''}",
                                      contentPadding:
                                          EdgeInsets.fromLTRB(12, 12, 0, 0),
                                      border: OutlineInputBorder(),
                                    ),
                                    onFind: (String? filter) =>
                                        getService(filter),
                                    onChanged: (data) {
                                      controller.selectedCodeService =
                                          data?.codeService;
                                      controller.serviceModel = data;
                                      if (controller.serviceModel == null) {
                                        controller.selectedCodeService = 0;
                                      }
                                      debugPrint(
                                          'service: ${controller.serviceModel?.service}, code: ${controller.selectedCodeService}');
                                    },
                                    dropdownBuilder:
                                        controller.customDropDownService,
                                    popupItemBuilder: controller
                                        .customPopupItemBuilderService,
                                    validator: (u) =>
                                        (controller.serviceModel == null &&
                                                controller.service_obligatoire
                                                        .value ==
                                                    1)
                                            ? "service ${'is_required'.tr} "
                                            : null,
                                    //u == null ? "service is required " : null,
                                    onBeforeChange: (a, b) {
                                      if (b == null) {
                                        AlertDialog alert = AlertDialog(
                                          title: Text("Are you sure..."),
                                          content: Text(
                                              "...you want to clear the selection"),
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
                                                Navigator.of(context)
                                                    .pop(false);
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
                                    })),
                            SizedBox(
                              height: 10.0,
                            ),
                            Visibility(
                                visible: controller.activity_visible.value == 1
                                    ? controller.isVisibileActivity = true
                                    : controller.isVisibileActivity = false,
                                child: DropdownSearch<ActivityModel>(
                                    showSelectedItems: true,
                                    showClearButton:
                                        controller.activityModel?.domaine == ""
                                            ? false
                                            : true,
                                    showSearchBox: true,
                                    isFilteredOnline: true,
                                    mode: Mode.DIALOG,
                                    compareFn: (i, s) => i?.isEqual(s) ?? false,
                                    dropdownSearchDecoration: InputDecoration(
                                      labelText:
                                          "${'activity'.tr} ${controller.activity_obligatoire.value == 1 ? '*' : ''}",
                                      contentPadding:
                                          EdgeInsets.fromLTRB(12, 12, 0, 0),
                                      border: OutlineInputBorder(),
                                    ),
                                    onFind: (String? filter) =>
                                        getActivity(filter),
                                    onChanged: (data) {
                                      controller.selectedCodeActivity =
                                          data?.codeDomaine;
                                      controller.activityModel = data;
                                      if (controller.activityModel == null) {
                                        controller.selectedCodeActivity = 0;
                                      }
                                      debugPrint(
                                          'activity:${controller.activityModel?.domaine}, code:${controller.selectedCodeActivity}');
                                    },
                                    dropdownBuilder:
                                        controller.customDropDownActivity,
                                    popupItemBuilder: controller
                                        .customPopupItemBuilderActivity,
                                    validator: (u) => (controller
                                                    .activity_obligatoire
                                                    .value ==
                                                1 &&
                                            controller.activityModel == null)
                                        ? "${'activity'.tr} ${'is_required'.tr} "
                                        : null,
                                    onBeforeChange: (a, b) {
                                      if (b == null) {
                                        AlertDialog alert = AlertDialog(
                                          title: Text("Are you sure..."),
                                          content: Text(
                                              "...you want to clear the selection"),
                                          actions: [
                                            TextButton(
                                              child: Text("OK"),
                                              onPressed: () {
                                                controller
                                                    .selectedCodeActivity = 0;
                                                Navigator.of(context).pop(true);
                                              },
                                            ),
                                            TextButton(
                                              child: Text("Cancel"),
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(false);
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
                                    })),
                            SizedBox(
                              height: 10.0,
                            ),
                            Visibility(
                                visible: controller.origine_nc_visible == 1
                                    ? controller.isVisibileOrigineNC = true
                                    : controller.isVisibileOrigineNC = false,
                                child: DropdownSearch<EmployeModel>(
                                    showSelectedItems: true,
                                    showClearButton: true,
                                    showSearchBox: true,
                                    isFilteredOnline: true,
                                    compareFn: (i, s) => i?.isEqual(s) ?? false,
                                    dropdownSearchDecoration: InputDecoration(
                                      labelText:
                                          "${'origine_pnc'.tr} ${controller.origine_nc_obligatoire == 1 ? '*' : ''}",
                                      contentPadding:
                                          EdgeInsets.fromLTRB(12, 12, 0, 0),
                                      border: OutlineInputBorder(),
                                    ),
                                    onFind: (String? filter) =>
                                        getEmploye(filter),
                                    onChanged: (data) {
                                      controller.employeModel = data;
                                      controller.origineNCMatricule = data?.mat;
                                      if (controller.employeModel == null) {
                                        controller.origineNCMatricule = "";
                                      }
                                      debugPrint(
                                          'origine de nc : ${controller.employeModel?.nompre}, mat:${controller.origineNCMatricule}');
                                    },
                                    dropdownBuilder:
                                        controller.customDropDownEmploye,
                                    popupItemBuilder: controller
                                        .customPopupItemBuilderEmploye,
                                    onBeforeChange: (a, b) {
                                      if (b == null) {
                                        AlertDialog alert = AlertDialog(
                                          title: Text("Are you sure..."),
                                          content: Text(
                                              "...you want to clear the selection"),
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
                                                Navigator.of(context)
                                                    .pop(false);
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
                                    })),
                            SizedBox(
                              height: 10.0,
                            ),
                            Visibility(
                                visible: controller.isps_visible == 1
                                    ? controller.isVisibileISPS = true
                                    : controller.isVisibileISPS = false,
                                child: DropdownSearch<ISPSPNCModel>(
                                  showSelectedItems: true,
                                  showClearButton: true,
                                  showSearchBox: false,
                                  isFilteredOnline: true,
                                  mode: Mode.DIALOG,
                                  compareFn: (i, s) => i?.isEqual(s) ?? false,
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText: "ISPS",
                                    contentPadding:
                                        EdgeInsets.fromLTRB(12, 12, 0, 0),
                                    border: OutlineInputBorder(),
                                  ),
                                  onFind: (String? filter) => getISPS(filter),
                                  onChanged: (data) {
                                    controller.isps = data?.value;
                                    debugPrint(
                                        'isps value :${controller.isps}');
                                  },
                                  dropdownBuilder: _customDropDownISPS,
                                  popupItemBuilder: _customPopupItemBuilderISPS,
                                )),
                            SizedBox(
                              height: 10.0,
                            ),
                            Visibility(
                              visible: controller.num_interne_visible == 1
                                  ? controller.isVisibileNumInterne = true
                                  : controller.isVisibileNumInterne = false,
                              child: TextFormField(
                                controller: controller.numInterneController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                    labelText:
                                        '${'ref_interne'.tr} ${controller.num_interne_obligatoire == 1 ? '*' : ''}',
                                    hintText: 'ref_interne'.tr,
                                    labelStyle: TextStyle(
                                      fontSize: 14.0,
                                    ),
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10.0,
                                    ),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.lightBlue, width: 1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)))),
                                style: TextStyle(fontSize: 14.0),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Visibility(
                              visible: true,
                              child: TextFormField(
                                controller: controller.numeroOfController,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                    labelText:
                                        'Numero Of ${controller.num_of_obligatoire == 1 ? '*' : ''}',
                                    hintText: 'num of',
                                    labelStyle: TextStyle(
                                      fontSize: 14.0,
                                    ),
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10.0,
                                    ),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.lightBlue, width: 1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)))),
                                style: TextStyle(fontSize: 14.0),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Visibility(
                              visible: true,
                              child: TextFormField(
                                controller: controller.numeroLotController,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                    labelText:
                                        'Numero Lot ${controller.num_lot_obligatoire == 1 ? '*' : ''}',
                                    hintText: 'num lot',
                                    labelStyle: TextStyle(
                                      fontSize: 14.0,
                                    ),
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10.0,
                                    ),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.lightBlue, width: 1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)))),
                                style: TextStyle(fontSize: 14.0),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Visibility(
                              visible: controller.unite_visible == 1
                                  ? controller.isVisibileUnite = true
                                  : controller.isVisibileUnite = false,
                              child: TextFormField(
                                controller: controller.uniteController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                    labelText:
                                        '${'unite'.tr} ${controller.unite_obligatoire == 1 ? '*' : ''}',
                                    hintText: 'unite'.tr,
                                    labelStyle: TextStyle(
                                      fontSize: 14.0,
                                    ),
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10.0,
                                    ),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.lightBlue, width: 1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)))),
                                style: TextStyle(fontSize: 14.0),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Visibility(
                              visible: true,
                              child: TextFormField(
                                controller: controller.quantityDetectController,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  labelText:
                                      '${'quantity'.tr} ${'detect'.tr} ${controller.qte_detect_obligatoire == 1 ? '*' : ''}',
                                  hintText: 'quantity'.tr,
                                  labelStyle: TextStyle(
                                    fontSize: 14.0,
                                  ),
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10.0,
                                  ),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.lightBlue, width: 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                ),
                                style: TextStyle(fontSize: 14.0),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Visibility(
                              visible: true,
                              child: TextFormField(
                                controller:
                                    controller.quantityProductController,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  labelText:
                                      '${'quantity'.tr} ${'product'.tr} ${controller.qte_produit_obligatoire == 1 ? '*' : ''}',
                                  hintText: 'quantity'.tr,
                                  labelStyle: TextStyle(
                                    fontSize: 14.0,
                                  ),
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10.0,
                                  ),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.lightBlue, width: 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                ),
                                style: TextStyle(fontSize: 14.0),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Visibility(
                              visible: controller.isVisiblePercentagePNC.value,
                              child: TextFormField(
                                controller: controller.pourcentageController,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  labelText: '${'pourcentage'.tr} *',
                                  hintText: 'pourcentage'.tr,
                                  labelStyle: TextStyle(
                                    fontSize: 14.0,
                                  ),
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10.0,
                                  ),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.lightBlue, width: 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  suffixIcon: Container(
                                    padding: EdgeInsets.all(12.0),
                                    child: Text(
                                      '%',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                validator: (value) =>
                                    Validator.validateField(value: value!),
                                style: TextStyle(fontSize: 14.0),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Radio(
                                      value: 0,
                                      groupValue: controller.pncDetected.value,
                                      onChanged: (value) {
                                        controller.onChangePNCDetected(value);
                                      },
                                      activeColor: Colors.blue,
                                      fillColor: MaterialStateProperty.all(
                                          Colors.blue),
                                    ),
                                    Text(
                                      "PNC ${'detect'.tr} ${'interne'.tr}",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Radio(
                                      value: 1,
                                      groupValue: controller.pncDetected.value,
                                      onChanged: (value) {
                                        controller.onChangePNCDetected(value);
                                      },
                                      activeColor: Colors.blue,
                                      fillColor: MaterialStateProperty.all(
                                          Colors.blue),
                                    ),
                                    Text(
                                      "PNC ${'detect'.tr} ${'by'.tr} ${'client'.tr}",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    )
                                  ],
                                )
                              ],
                            ),
                            Visibility(
                                visible: controller.isVisibleCLient.value,
                                child: SizedBox(
                                  height: 10.0,
                                )),
                            Visibility(
                                visible: controller.isVisibleCLient.value,
                                child: DropdownSearch<ClientModel>(
                                  showSelectedItems: true,
                                  showClearButton: true,
                                  showSearchBox: true,
                                  isFilteredOnline: true,
                                  compareFn: (i, s) => i?.isEqual(s) ?? false,
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText: 'client'.tr,
                                    contentPadding:
                                        EdgeInsets.fromLTRB(12, 12, 0, 0),
                                    border: OutlineInputBorder(),
                                  ),
                                  onFind: (String? filter) => getClient(filter),
                                  onChanged: (data) {
                                    controller.clientModel = data;
                                    controller.selectedCodeClient =
                                        data?.codeclt;
                                    if (controller.clientModel == null) {
                                      controller.selectedCodeClient = "";
                                    }
                                    print(
                                        'client: ${controller.clientModel?.nomClient}, code: ${controller.selectedCodeClient}');
                                  },
                                  dropdownBuilder:
                                      controller.customDropDownClient,
                                  popupItemBuilder:
                                      controller.customPopupItemBuilderClient,
                                )),
                            SizedBox(
                              height: 10.0,
                            ),
                            Visibility(
                              visible: controller.product_bloque_visible == 1
                                  ? controller.isVisibileProductBloque = true
                                  : controller.isVisibileProductBloque = false,
                              child: CheckboxListTile(
                                title: Text('${'product'.tr} ${'bloque'.tr}'),
                                value: controller.checkProductBloque.value,
                                onChanged: (bool? value) {
                                  controller.checkProductBloque.value = value!;
                                  if (controller.checkProductBloque.value ==
                                      true) {
                                    controller.productBloque.value = 1;
                                  } else {
                                    controller.productBloque.value = 0;
                                  }
                                  debugPrint(
                                      'product bloque ${controller.productBloque.value}');
                                },
                                activeColor: Colors.blue,
                                //secondary: const Icon(Icons.hourglass_empty),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Visibility(
                              visible: controller.product_isole_visible == 1
                                  ? controller.isVisibileProductIsole = true
                                  : controller.isVisibileProductIsole = false,
                              child: CheckboxListTile(
                                title: Text('${'product'.tr} ${'isole'.tr}'),
                                value: controller.checkProductIsole.value,
                                onChanged: (bool? value) {
                                  controller.checkProductIsole.value = value!;
                                  if (controller.checkProductIsole.value ==
                                      true) {
                                    controller.productIsole.value = 1;
                                  } else {
                                    controller.productIsole.value = 0;
                                  }
                                  debugPrint(
                                      'product isole ${controller.productIsole.value}');
                                },
                                activeColor: Colors.blue,
                                //secondary: const Icon(Icons.hourglass_empty),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            MaterialButton(
                                color: Colors.blue,
                                child: Text("${'upload'.tr} Images",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: ((builder) => bottomSheet()),
                                  );
                                }),
                            builImagePicker(),
                            SizedBox(
                              height: 20.0,
                            ),
                            ConstrainedBox(
                              constraints: BoxConstraints.tightFor(
                                  width: Get.width * 0.6, height: 50),
                              child: ElevatedButton.icon(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  backgroundColor: MaterialStateProperty.all(
                                      CustomColors.googleBackground),
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.all(14)),
                                ),
                                icon: controller.isDataProcessing.value
                                    ? CircularProgressIndicator()
                                    : Icon(Icons.save),
                                label: Text(
                                  controller.isDataProcessing.value
                                      ? 'processing'.tr
                                      : 'save'.tr,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                                onPressed: () {
                                  controller.isDataProcessing.value
                                      ? null
                                      : controller.saveBtn();
                                },
                              ),
                            ),
                          ],
                        ))),
              ),
            );
          } else {
            return Center(
              child: LoadingView(),
            );
          }
        }),
      )),
    );
  }

  //dropdown search
//typenc
  Future<List<TypePNCModel>> getTypePNC(filter) async {
    try {
      List<TypePNCModel> _typeList =
          await List<TypePNCModel>.empty(growable: true);
      List<TypePNCModel> _typeFilter =
          await List<TypePNCModel>.empty(growable: true);
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        var response = await controller.localPNCService.readTypePNC();
        response.forEach((data) {
          var model = TypePNCModel();
          model.codeTypeNC = data['codeTypeNC'];
          model.typeNC = data['typeNC'];
          model.color = data['color'];
          _typeList.add(model);
        });
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        await ApiServicesCall().getTypePNC().then((resp) async {
          resp.forEach((data) async {
            var model = TypePNCModel();
            model.codeTypeNC = data['codeTypeNC'];
            model.typeNC = data['typeNC'];
            model.color = data['color'];
            _typeList.add(model);
          });
        }, onError: (err) {
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
      }
      _typeFilter = _typeList.where((u) {
        var query = u.typeNC!.toLowerCase();
        return query.contains(filter);
      }).toList();
      return _typeFilter;
    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }

  //gravite
  Future<List<GravitePNCModel>> getGravitePNC(filter) async {
    try {
      List<GravitePNCModel> _graviteList =
          await List<GravitePNCModel>.empty(growable: true);
      List<GravitePNCModel> _graviteFilter =
          await List<GravitePNCModel>.empty(growable: true);
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        var response = await controller.localPNCService.readGravitePNC();
        response.forEach((data) {
          var model = GravitePNCModel();
          model.nGravite = data['nGravite'];
          model.gravite = data['gravite'];
          _graviteList.add(model);
        });
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        await ApiServicesCall().getGravitePNC().then((resp) async {
          resp.forEach((data) async {
            var model = GravitePNCModel();
            model.nGravite = data['nGravite'];
            model.gravite = data['gravite'];
            _graviteList.add(model);
          });
        }, onError: (err) {
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
      }
      _graviteFilter = _graviteList.where((u) {
        var query = u.gravite!.toLowerCase();
        return query.contains(filter);
      }).toList();
      return _graviteFilter;
    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }

  //Product
  Future<List<ProductModel>> getProduct(filter) async {
    try {
      List<ProductModel> productList =
          await List<ProductModel>.empty(growable: true);
      List<ProductModel> productFilter = await <ProductModel>[];
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        var response = await controller.localActionService.readProduct();
        response.forEach((data) {
          var model = ProductModel();
          model.codePdt = data['codePdt'];
          model.produit = data['produit'];
          model.prix = data['prix'];
          model.typeProduit = data['typeProduit'];
          model.codeTypeProduit = data['codeTypeProduit'];
          productList.add(model);
        });
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        await ApiServicesCall()
            .getProduct({"codeProduit": "", "produit": ""}).then((resp) async {
          resp.forEach((data) async {
            var model = ProductModel();
            model.codePdt = data['codePdt'];
            model.produit = data['produit'];
            model.prix = data['prix'];
            model.typeProduit = data['typeProduit'];
            model.codeTypeProduit = data['codeTypeProduit'];
            productList.add(model);
          });
        }, onError: (err) {
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
      }

      productFilter = productList.where((u) {
        var name = u.codePdt.toString().toLowerCase();
        var description = u.produit!.toLowerCase();
        return name.contains(filter) || description.contains(filter);
      }).toList();
      return productFilter;
    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }

  //fournisseur
  Future<List<FournisseurModel>> getFournisseur(filter) async {
    try {
      List<FournisseurModel> fournisseurList =
          await List<FournisseurModel>.empty(growable: true);
      List<FournisseurModel> fournisseurFilter = await <FournisseurModel>[];
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        var response = await controller.localPNCService.readFournisseur();
        response.forEach((data) {
          var model = FournisseurModel();
          model.raisonSociale = data['raisonSociale'];
          model.activite = data['activite'];
          model.codeFr = data['codeFr'];
          fournisseurList.add(model);
        });
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        await ApiServicesCall().getFournisseurs(controller.matricule).then(
            (resp) async {
          resp.forEach((data) async {
            var model = FournisseurModel();
            model.raisonSociale = data['raisonSociale'];
            model.activite = data['activite'];
            model.codeFr = data['codeFr'];
            fournisseurList.add(model);
          });
        }, onError: (err) {
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
      }

      fournisseurFilter = fournisseurList.where((u) {
        var name = u.activite.toString().toLowerCase();
        var description = u.codeFr!.toLowerCase();
        return name.contains(filter) || description.contains(filter);
      }).toList();
      return fournisseurFilter;
    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }

  //client
  Future<List<ClientModel>> getClient(filter) async {
    try {
      List<ClientModel> clientList =
          await List<ClientModel>.empty(growable: true);
      List<ClientModel> clientFilter = await <ClientModel>[];
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        var response = await controller.localPNCService.readClient();
        response.forEach((data) {
          var model = ClientModel();
          model.codeclt = data['codeclt'];
          model.nomClient = data['nomClient'];
          clientList.add(model);
        });
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        await ApiServicesCall().getClients().then((resp) async {
          resp.forEach((data) async {
            var model = ClientModel();
            model.codeclt = data['codeclt'];
            model.nomClient = data['nomClient'];
            clientList.add(model);
          });
        }, onError: (err) {
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
      }

      clientFilter = clientList.where((u) {
        var name = u.codeclt.toString().toLowerCase();
        var description = u.nomClient!.toLowerCase();
        return name.contains(filter) || description.contains(filter);
      }).toList();
      return clientFilter;
    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }

  //source
  Future<List<SourcePNCModel>> getSource(filter) async {
    try {
      List<SourcePNCModel> sourceList =
          await List<SourcePNCModel>.empty(growable: true);
      List<SourcePNCModel> sourceFilter = await <SourcePNCModel>[];
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        var response = await controller.localPNCService.readSourcePNC();
        response.forEach((data) {
          var model = SourcePNCModel();
          model.codeSourceNC = data['codeSourceNC'];
          model.sourceNC = data['sourceNC'];
          sourceList.add(model);
        });
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        await ApiServicesCall().getSourcePNC().then((resp) async {
          resp.forEach((data) async {
            var model = SourcePNCModel();
            model.codeSourceNC = data['codeSourceNC'];
            model.sourceNC = data['sourceNC'];
            sourceList.add(model);
          });
        }, onError: (err) {
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
      }

      sourceFilter = sourceList.where((u) {
        var name = u.codeSourceNC.toString().toLowerCase();
        var description = u.sourceNC!.toLowerCase();
        return name.contains(filter) || description.contains(filter);
      }).toList();
      return sourceFilter;
    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }

//atelier
  Future<List<AtelierPNCModel>> getAtelier(filter) async {
    try {
      List<AtelierPNCModel> _atelierList =
          await List<AtelierPNCModel>.empty(growable: true);
      List<AtelierPNCModel> _atelierFilter =
          await List<AtelierPNCModel>.empty(growable: true);
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        var response = await controller.localPNCService.readAtelierPNC();
        response.forEach((data) {
          var model = AtelierPNCModel();
          model.codeAtelier = data['codeAtelier'];
          model.atelier = data['atelier'];
          _atelierList.add(model);
        });
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        await ApiServicesCall().getAtelierPNC().then((resp) async {
          resp.forEach((data) async {
            var model = AtelierPNCModel();
            model.codeAtelier = data['codeAtelier'];
            model.atelier = data['atelier'];
            _atelierList.add(model);
          });
        }, onError: (err) {
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
      }
      _atelierFilter = _atelierList.where((u) {
        var query = u.atelier!.toLowerCase();
        return query.contains(filter);
      }).toList();
      return _atelierFilter;
    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }

  //origne d n.c
//Employe
  Future<List<EmployeModel>> getEmploye(filter) async {
    try {
      List<EmployeModel> employeList =
          await List<EmployeModel>.empty(growable: true);
      List<EmployeModel> employeFilter =
          await List<EmployeModel>.empty(growable: true);
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        var response = await controller.localActionService.readEmploye();
        response.forEach((data) {
          var model = EmployeModel();
          model.mat = data['mat'];
          model.nompre = data['nompre'];
          employeList.add(model);
        });
      } else if (connection == ConnectivityResult.mobile ||
          connection == ConnectivityResult.wifi) {
        await ApiServicesCall().getEmploye({"act": "", "lang": ""}).then(
            (response) async {
          response.forEach((data) async {
            //print('get employe : ${data} ');
            var model = EmployeModel();
            model.mat = data['mat'];
            model.nompre = data['nompre'];
            employeList.add(model);
          });
        }, onError: (err) {
          ShowSnackBar.snackBar("Error Employe", err.toString(), Colors.red);
        });
      }

      employeFilter = employeList.where((u) {
        var name = u.mat.toString().toLowerCase();
        var description = u.nompre!.toLowerCase();
        return name.contains(filter) || description.contains(filter);
      }).toList();
      return employeFilter;
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
      if (connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        var sites =
            await controller.localActionService.readSiteByModule("PNC", "PNC");
        sites.forEach((data) {
          var model = SiteModel();
          model.codesite = data['codesite'];
          model.site = data['site'];
          siteList.add(model);
        });
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        await ApiServicesCall().getSite({
          "mat": controller.matricule.toString(),
          "modul": "PNC",
          "site": "0",
          "agenda": 0,
          "fiche": "PNC"
        }).then((resp) async {
          resp.forEach((data) async {
            var model = SiteModel();
            model.codesite = data['codesite'];
            model.site = data['site'];
            siteList.add(model);
          });
        }, onError: (err) {
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
      }
      siteFilter = siteList.where((u) {
        var name = u.codesite.toString().toLowerCase();
        var description = u.site!.toLowerCase();
        return name.contains(filter) || description.contains(filter);
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
      List<ProcessusModel> processusList =
          await List<ProcessusModel>.empty(growable: true);
      List<ProcessusModel> processusFilter = await <ProcessusModel>[];
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        var sites = await controller.localActionService
            .readProcessusByModule("PNC", "PNC");
        sites.forEach((data) {
          var model = ProcessusModel();
          model.codeProcessus = data['codeProcessus'];
          model.processus = data['processus'];
          processusList.add(model);
        });
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        await ApiServicesCall().getProcessus({
          "mat": controller.matricule.toString(),
          "modul": "PNC",
          "processus": "0",
          "fiche": "PNC"
        }).then((resp) async {
          resp.forEach((data) async {
            //print('get processus : ${data} ');
            var model = ProcessusModel();
            model.codeProcessus = data['codeProcessus'];
            model.processus = data['processus'];
            processusList.add(model);
          });
        }, onError: (err) {
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
      }
      processusFilter = processusList.where((u) {
        var name = u.codeProcessus.toString().toLowerCase();
        var description = u.processus!.toLowerCase();
        return name.contains(filter) || description.contains(filter);
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
      List<DirectionModel> directionList =
          await List<DirectionModel>.empty(growable: true);
      List<DirectionModel> directionFilter = await <DirectionModel>[];
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        var response = await controller.localActionService
            .readDirectionByModule("PNC", "PNC");
        response.forEach((data) {
          var model = DirectionModel();
          model.codeDirection = data['codeDirection'];
          model.direction = data['direction'];
          directionList.add(model);
        });
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        await ApiServicesCall().getDirection({
          "mat": controller.matricule.toString(),
          "modul": "PNC",
          "fiche": "PNC",
          "direction": 0
        }).then((resp) async {
          resp.forEach((data) async {
            //print('get direction : ${data} ');
            var model = DirectionModel();
            model.codeDirection = data['code_direction'];
            model.direction = data['direction'];
            directionList.add(model);
          });
        }, onError: (err) {
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
      }
      directionFilter = directionList.where((u) {
        var name = u.codeDirection.toString().toLowerCase();
        var description = u.direction!.toLowerCase();
        return name.contains(filter) || description.contains(filter);
      }).toList();
      return directionFilter;
    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }

  //Service
  Future<List<ServiceModel>> getService(filter) async {
    if (controller.directionModel == null) {
      Get.snackbar("No Data", "Please select Direction",
          colorText: Colors.blue, snackPosition: SnackPosition.BOTTOM);
    }
    try {
      List<ServiceModel> serviceList =
          await List<ServiceModel>.empty(growable: true);
      List<ServiceModel> serviceFilter =
          await List<ServiceModel>.empty(growable: true);

      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        var response = await controller.localActionService
            .readServiceByModuleAndDirection(
                'PNC', 'PNC', controller.selectedCodeDirection);
        print('response service : $response');
        response.forEach((data) {
          var model = ServiceModel();
          model.codeService = data['codeService'];
          model.service = data['service'];
          model.codeDirection = data['codeDirection'];
          model.direction = data['direction'];
          serviceList.add(model);
        });
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        await ApiServicesCall()
            .getService(controller.matricule, controller.selectedCodeDirection,
                'PNC', 'PNC')
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
        }, onError: (err) {
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
      List<ActivityModel> activityList =
          await List<ActivityModel>.empty(growable: true);
      List<ActivityModel> activityFilter = await <ActivityModel>[];
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        var response = await controller.localActionService
            .readActivityByModule("PNC", "PNC");
        response.forEach((data) {
          var model = ActivityModel();
          model.codeDomaine = data['codeDomaine'];
          model.domaine = data['domaine'];
          activityList.add(model);
        });
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        await ApiServicesCall().getActivity({
          "mat": controller.matricule.toString(),
          "modul": "PNC",
          "fiche": "PNC",
          "domaine": ""
        }).then((resp) async {
          resp.forEach((data) async {
            //print('get activity : ${data} ');
            var model = ActivityModel();
            model.codeDomaine = data['code_domaine'];
            model.domaine = data['domaine'];
            activityList.add(model);
          });
        }, onError: (err) {
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
      }
      activityFilter = activityList.where((u) {
        var name = u.codeDomaine.toString().toLowerCase();
        var description = u.domaine!.toLowerCase();
        return name.contains(filter) || description.contains(filter);
      }).toList();
      return activityFilter;
    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }

  //ISPS
  Future<List<ISPSPNCModel>> getISPS(filter) async {
    try {
      List<ISPSPNCModel> ispsList = [
        ISPSPNCModel(value: "0", name: ""),
        ISPSPNCModel(value: "1", name: "OUI"),
        ISPSPNCModel(value: "2", name: "NON"),
        ISPSPNCModel(value: "3", name: "Non applicable"),
      ];

      return ispsList;
    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }

  //ISPS
  Widget _customDropDownISPS(BuildContext context, ISPSPNCModel? item) {
    if (item == null) {
      return Container();
    }
    return Container(
      child: (item.name == null)
          ? ListTile(
              contentPadding: EdgeInsets.all(0),
              title: Text("No item selected"),
            )
          : ListTile(
              contentPadding: EdgeInsets.all(0),
              title: Text('${item.name}'),
            ),
    );
  }

  Widget _customPopupItemBuilderISPS(
      BuildContext context, ISPSPNCModel? item, bool isSelected) {
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
        title: Text(item?.name ?? ''),
        //subtitle: Text(item?.value.toString() ?? ''),
      ),
    );
  }

  //upload image
  Widget builImagePicker() {
    return controller.imageFileList.length == 0
        ? Container()
        : controller.imageFileList.length == 1
            ? Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                width: Get.width * 0.7,
                height: 170,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    child: Image.file(File(controller.imageFileList.first.path),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              )
            : Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                //width: 170,
                height: 170,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ImageSlideshow(
                    children: generateImagesTile(),
                    autoPlayInterval: 3000,
                    isLoop: true,
                    width: double.infinity,
                    height: 200,
                    initialPage: 0,
                    indicatorColor: Colors.blue,
                    indicatorBackgroundColor: Colors.grey,
                  ),
                ),
              );
  }

  List<Widget> generateImagesTile() {
    return controller.imageFileList
        .map((element) => ClipRRect(
              child: Image.file(File(element.path), fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(10.0),
            ))
        .toList();
  }

  //2.Create BottomSheet
  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: Get.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "${'choose'.tr} Photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            ConstrainedBox(
              constraints:
                  BoxConstraints.tightFor(width: Get.width / 2.5, height: 50),
              child: ElevatedButton.icon(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(Color(0xFD18A3A8)),
                  padding: MaterialStateProperty.all(EdgeInsets.all(14)),
                ),
                icon: Icon(Icons.camera),
                label: Text(
                  'Camera',
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
                onPressed: () {
                  if (controller.imageFileList.length >= 5) {
                    ShowSnackBar.snackBar('warning'.tr,
                        'choose_max_5_images'.tr, Colors.yellow.shade800);
                    return;
                  }
                  takePhoto(ImageSource.camera);
                },
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            ConstrainedBox(
              constraints:
                  BoxConstraints.tightFor(width: Get.width / 2.5, height: 50),
              child: ElevatedButton.icon(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(Color(0xFD147FAA)),
                  padding: MaterialStateProperty.all(EdgeInsets.all(14)),
                ),
                icon: Icon(Icons.image),
                label: Text(
                  'Gallery',
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
                onPressed: () {
                  if (controller.imageFileList.length >= 5) {
                    ShowSnackBar.snackBar('warning'.tr,
                        'choose_max_5_images'.tr, Colors.yellow.shade800);
                    return;
                  }
                  selectImages();
                },
              ),
            ),
          ])
        ],
      ),
    );
  }

  void selectImages() async {
    try {
      //multi image picker
      final List<XFile>? selectedImages =
          await controller.imagePicker.pickMultiImage();
      if (selectedImages!.isNotEmpty) {
        controller.imageFileList.addAll(selectedImages);
        //print('images list ${imageFileList}');
        for (var i = 0; i < selectedImages.length; i++) {
          final byteData = await selectedImages[i].readAsBytes();

          debugPrint('byteData : $byteData');

          print(controller.getRandomString(5));

          var modelImage = ImageModel();
          modelImage.image = base64Encode(byteData);
          modelImage.fileName =
              '${controller.getRandomString(5)}_(${controller.matricule})_${selectedImages[i].name}';
          //modelImage.fileName = mypath.basename(selectedImages[i].path);
          controller.base64List.add(modelImage);
          debugPrint('image base64 ${modelImage.image}');
          debugPrint('fileName : ${modelImage.fileName}');
          debugPrint('list from gallery ${controller.base64List}');
        }
      }
      Get.back();
    } catch (error) {
      debugPrint(error.toString());
      ShowSnackBar.snackBar('Error', error.toString(), Colors.red);
    }
  }

  takePhoto(ImageSource imageType) async {
    try {
      final photo = await ImagePicker().pickImage(source: imageType);
      if (photo == null) return;
      final tempImage = File(photo.path);
      controller.imageFileList.add(photo);

      var modelImage = ImageModel();
      modelImage.image = UtilityFile.base64String(tempImage.readAsBytesSync());
      //modelImage.fileName = mypath.basename(tempImage.path);
      modelImage.fileName =
          '${controller.getRandomString(5)}_(${controller.matricule})_${mypath.basename(tempImage.path)}';
      controller.base64List.add(modelImage);
      debugPrint('image base64 ${modelImage.image}');
      debugPrint('fileName ${modelImage.fileName}');
      debugPrint('list from camera ${controller.base64List}');

      //Navigator.of(context).pop();
      Get.back();
    } catch (error) {
      debugPrint(error.toString());
      ShowSnackBar.snackBar('Error', error.toString(), Colors.red);
    }
  }
}
