import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:qualipro_flutter/Controllers/reunion/new_reunion_controller.dart';
import 'package:qualipro_flutter/Models/reunion/type_reunion_model.dart';
import '../../../Models/processus_model.dart';
import '../../../Services/api_services_call.dart';
import '../../../Utils/custom_colors.dart';
import '../../../Utils/snack_bar.dart';
import '../../../Validators/validator.dart';
import '../../Models/activity_model.dart';
import '../../Models/direction_model.dart';
import '../../Models/service_model.dart';
import '../../Models/site_model.dart';
import '../../Services/reunion/reunion_service.dart';
import '../../Widgets/loading_widget.dart';

class NewReunionPage extends GetView<NewReunionController> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

    List<Step> getSteps() => [
          Step(
              state: controller.currentStep.value > 0
                  ? StepState.complete
                  : StepState.indexed,
              isActive: controller.currentStep.value >= 0,
              title: Text('Enregistrement'),
              content: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10.0,
                  ),
                  Visibility(
                      visible: true,
                      child: DropdownSearch<TypeReunionModel>(
                        showSelectedItems: true,
                        showClearButton: true,
                        showSearchBox: true,
                        isFilteredOnline: true,
                        compareFn: (i, s) => i?.isEqual(s) ?? false,
                        dropdownSearchDecoration: InputDecoration(
                          labelText: "Type Reunion *",
                          contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                          border: OutlineInputBorder(),
                        ),
                        onFind: (String? filter) => getTypeReunion(filter),
                        onChanged: (data) {
                          controller.typeReunionModel = data;
                          controller.selectedCodeType = data?.codeTypeR;
                          if (controller.typeReunionModel == null) {
                            controller.selectedCodeType = 0;
                          }
                          print(
                              'typeReunion: ${controller.typeReunionModel?.typeReunion}, code: ${controller.selectedCodeType}');
                        },
                        dropdownBuilder: controller.customDropDownType,
                        popupItemBuilder: controller.customPopupItemBuilderType,
                        validator: (u) =>
                            u == null ? "type is required " : null,
                      )),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    controller: controller.orderController,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.next,
                    /* validator: (value) => Validator.validateField(
                                        value: value!
                                    ), */
                    decoration: InputDecoration(
                      labelText: 'Ordre du jour',
                      hintText: 'Ordre du jour',
                      labelStyle: TextStyle(
                        fontSize: 14.0,
                      ),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 10.0,
                      ),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.lightBlue, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    style: TextStyle(fontSize: 14.0),
                    minLines: 2,
                    maxLines: 5,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    controller: controller.lieuController,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Lieu',
                      hintText: 'lieu',
                      labelStyle: TextStyle(
                        fontSize: 14.0,
                      ),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 10.0,
                      ),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.lightBlue, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    style: TextStyle(fontSize: 14.0),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Visibility(
                    visible: true,
                    child: InkWell(
                      onTap: () {
                        controller.selectedDatePrevue(context);
                      },
                      child: TextFormField(
                        controller: controller.datePrevueController,
                        enabled: false,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        validator: (value) =>
                            Validator.validateField(value: value!),
                        onChanged: (value) {
                          controller.selectedDatePrevue(context);
                        },
                        decoration: InputDecoration(
                            labelText: 'Date Prévue *',
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
                                controller.selectedDatePrevue(context);
                              },
                              child: Icon(Icons.calendar_today),
                            ),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.lightBlue, width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)))),
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
                        controller.selectedTimeDebut(context);
                      },
                      child: TextFormField(
                        controller: controller.heureDebutController,
                        enabled: false,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        onChanged: (value) {
                          controller.selectedTimeDebut(context);
                        },
                        decoration: InputDecoration(
                            labelText: 'Heure Debut Reunion',
                            hintText: 'time',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 10.0,
                            ),
                            suffixIcon: InkWell(
                              onTap: () {
                                controller.selectedTimeDebut(context);
                              },
                              child: Icon(Icons.timer),
                            ),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.lightBlue, width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)))),
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
                        controller.selectedTimeFin(context);
                      },
                      child: TextFormField(
                        controller: controller.heureFinController,
                        enabled: false,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        onChanged: (value) {
                          controller.selectedTimeFin(context);
                        },
                        decoration: InputDecoration(
                            labelText: 'Heure Fin Reunion',
                            hintText: 'time',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 10.0,
                            ),
                            suffixIcon: InkWell(
                              onTap: () {
                                controller.selectedTimeFin(context);
                              },
                              child: Icon(Icons.timer),
                            ),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.lightBlue, width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)))),
                        style: TextStyle(fontSize: 14.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    enabled: false,
                    controller: controller.dureeReunionController,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Durée Reunion',
                      hintText: 'durée',
                      labelStyle: TextStyle(
                        fontSize: 14.0,
                      ),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 10.0,
                      ),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.lightBlue, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    style: TextStyle(fontSize: 14.0),
                  ),
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
                            controller.siteModel?.site == "" ? false : true,
                        showSearchBox: true,
                        isFilteredOnline: true,
                        compareFn: (i, s) => i?.isEqual(s) ?? false,
                        dropdownSearchDecoration: InputDecoration(
                          labelText:
                              "Site ${controller.site_obligatoire.value == 1 ? '*' : ''}",
                          contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                          border: OutlineInputBorder(),
                        ),
                        onFind: (String? filter) => getSite(filter),
                        onChanged: (data) {
                          controller.siteModel = data;
                          controller.selectedCodeSite = data?.codesite;
                          if (controller.siteModel == null) {
                            controller.selectedCodeSite = 0;
                          }
                          print(
                              'site: ${controller.siteModel?.site}, code: ${controller.selectedCodeSite}');
                        },
                        dropdownBuilder: controller.customDropDownSite,
                        popupItemBuilder: controller.customPopupItemBuilderSite,
                        validator: (u) =>
                            (controller.site_obligatoire.value == 1 &&
                                    controller.siteModel == null)
                                ? "site is required "
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
                          contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                          border: OutlineInputBorder(),
                        ),
                        onFind: (String? filter) => getProcessus(filter),
                        onChanged: (data) {
                          controller.processusModel = data;
                          controller.selectedCodeProcessus =
                              data?.codeProcessus;
                          if (controller.processusModel == null) {
                            controller.selectedCodeProcessus = 0;
                          }
                          print(
                              'processus: ${controller.processusModel?.processus}, code: ${controller.selectedCodeProcessus}');
                        },
                        dropdownBuilder: controller.customDropDownProcessus,
                        popupItemBuilder:
                            controller.customPopupItemBuilderProcessus,
                        validator: (u) =>
                            (controller.processus_obligatoire.value == 1 &&
                                    controller.processusModel == null)
                                ? "processus is required "
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
                              controller.directionModel?.direction == ""
                                  ? false
                                  : true,
                          showSearchBox: true,
                          isFilteredOnline: true,
                          compareFn: (i, s) => i?.isEqual(s) ?? false,
                          dropdownSearchDecoration: InputDecoration(
                            labelText:
                                "Direction ${controller.direction_obligatoire.value == 1 ? '*' : ''}",
                            contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                            border: OutlineInputBorder(),
                          ),
                          onFind: (String? filter) => getDirection(filter),
                          onChanged: (data) {
                            controller.selectedCodeDirection =
                                data?.codeDirection;
                            controller.directionModel = data;
                            if (controller.directionModel == null) {
                              controller.selectedCodeDirection = 0;
                            }
                            print(
                                'direction: ${controller.directionModel?.direction}, code: ${controller.selectedCodeDirection}');
                          },
                          dropdownBuilder: controller.customDropDownDirection,
                          popupItemBuilder:
                              controller.customPopupItemBuilderDirection,
                          validator: (u) =>
                              (controller.direction_obligatoire.value == 1 &&
                                      controller.directionModel == null)
                                  ? "direction is required "
                                  : null,
                          onBeforeChange: (a, b) {
                            if (b == null) {
                              AlertDialog alert = AlertDialog(
                                title: Text("Are you sure..."),
                                content:
                                    Text("...you want to clear the selection"),
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
                            contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                            border: OutlineInputBorder(),
                          ),
                          onFind: (String? filter) => getService(filter),
                          onChanged: (data) {
                            controller.selectedCodeService = data?.codeService;
                            controller.serviceModel = data;
                            if (controller.serviceModel == null) {
                              controller.selectedCodeService = 0;
                            }
                            print(
                                'service: ${controller.serviceModel?.service}, code: ${controller.selectedCodeService}');
                          },
                          dropdownBuilder: controller.customDropDownService,
                          popupItemBuilder:
                              controller.customPopupItemBuilderService,
                          validator: (u) => (controller.serviceModel == null &&
                                  controller.service_obligatoire.value == 1)
                              ? "service is required "
                              : null,
                          //u == null ? "service is required " : null,
                          onBeforeChange: (a, b) {
                            if (b == null) {
                              AlertDialog alert = AlertDialog(
                                title: Text("Are you sure..."),
                                content:
                                    Text("...you want to clear the selection"),
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
                                "Activity ${controller.activity_obligatoire.value == 1 ? '*' : ''}",
                            contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                            border: OutlineInputBorder(),
                          ),
                          onFind: (String? filter) => getActivity(filter),
                          onChanged: (data) {
                            controller.selectedCodeActivity = data?.codeDomaine;
                            controller.activityModel = data;
                            if (controller.activityModel == null) {
                              controller.selectedCodeActivity = 0;
                            }
                            print(
                                'activity:${controller.activityModel?.domaine}, code:${controller.selectedCodeActivity}');
                          },
                          dropdownBuilder: controller.customDropDownActivity,
                          popupItemBuilder:
                              controller.customPopupItemBuilderActivity,
                          validator: (u) =>
                              (controller.activity_obligatoire.value == 1 &&
                                      controller.activityModel == null)
                                  ? "activity is required "
                                  : null,
                          onBeforeChange: (a, b) {
                            if (b == null) {
                              AlertDialog alert = AlertDialog(
                                title: Text("Are you sure..."),
                                content:
                                    Text("...you want to clear the selection"),
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
                          })),
                  /*  SizedBox(
                    height: 20.0,
                  ),
                  ConstrainedBox(
                    constraints:
                        BoxConstraints.tightFor(width: 130, height: 50),
                    child: ElevatedButton.icon(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(
                            CustomColors.googleBackground),
                        padding: MaterialStateProperty.all(EdgeInsets.all(14)),
                      ),
                      icon: controller.isDataProcessing.value
                          ? CircularProgressIndicator()
                          : Icon(Icons.save),
                      label: Text(
                        controller.isDataProcessing.value
                            ? 'Processing'
                            : 'Save',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      onPressed: () {
                        controller.isDataProcessing.value
                            ? null
                            : controller.saveBtn();
                      },
                    ),
                  ), */
                ],
              )),
          Step(
              state: controller.currentStep.value > 1
                  ? StepState.complete
                  : StepState.indexed,
              isActive: controller.currentStep.value >= 1,
              title: Text('Réalisation'),
              content: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10.0,
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Radio(
                            value: 0,
                            groupValue: controller.etat.value,
                            onChanged: (value) {
                              controller.onChangeEtat(value);
                            },
                            activeColor: Colors.blue,
                            fillColor: MaterialStateProperty.all(Colors.blue),
                          ),
                          const Text(
                            "Non encore réalisée",
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
                            groupValue: controller.etat.value,
                            onChanged: (value) {
                              controller.onChangeEtat(value);
                            },
                            activeColor: Colors.blue,
                            fillColor: MaterialStateProperty.all(Colors.blue),
                          ),
                          const Text(
                            "Réalisée",
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
                            value: 3,
                            groupValue: controller.etat.value,
                            onChanged: (value) {
                              controller.onChangeEtat(value);
                            },
                            activeColor: Colors.blue,
                            fillColor: MaterialStateProperty.all(Colors.blue),
                          ),
                          const Text(
                            "Reportée",
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
                            value: 2,
                            groupValue: controller.etat.value,
                            onChanged: (value) {
                              controller.onChangeEtat(value);
                            },
                            activeColor: Colors.blue,
                            fillColor: MaterialStateProperty.all(Colors.blue),
                          ),
                          const Text(
                            "Annulée",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Visibility(
                    visible: true,
                    child: TextFormField(
                      controller: controller.dateRealisationController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      validator: (value) =>
                          Validator.validateField(value: value!),
                      onChanged: (value) {
                        controller.selectedDateRealisation(context);
                      },
                      decoration: InputDecoration(
                          labelText: 'Date Realisation *',
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
                              controller.selectedDateRealisation(context);
                            },
                            child: Icon(Icons.calendar_today),
                          ),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.lightBlue, width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    controller: controller.dureeRealController,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Durée Réalisée',
                      hintText: 'durée',
                      labelStyle: TextStyle(
                        fontSize: 14.0,
                      ),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 10.0,
                      ),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.lightBlue, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    style: TextStyle(fontSize: 14.0),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    controller: controller.commentaireController,
                    keyboardType: TextInputType.multiline,
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
                          borderSide:
                              BorderSide(color: Colors.lightBlue, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    style: TextStyle(fontSize: 14.0),
                    minLines: 3,
                    maxLines: 5,
                  ),
                ],
              )),
          Step(
              isActive: controller.currentStep.value >= 2,
              title: Text('Complete'),
              content: Container())
        ];

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
          child: Text("Ajouter Reunion"),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Obx(() {
          if (controller.isVisibleNewPNC.value == true) {
            return Card(
              child: Form(
                key: controller.addItemFormKey,
                child: Theme(
                  data: Theme.of(context).copyWith(
                      colorScheme:
                          ColorScheme.light(primary: Color(0xFD19A4B6))),
                  child: Stepper(
                    type: StepperType.vertical,
                    steps: getSteps(),
                    currentStep: controller.currentStep.value,
                    onStepContinue: () {
                      final isLastStep =
                          controller.currentStep.value == getSteps().length - 1;
                      if (isLastStep) {
                        print('complete');
                      } else {
                        controller.currentStep.value += 1;
                      }
                    },
                    onStepTapped: (step) => controller.currentStep.value = step,
                    onStepCancel: () {
                      controller.currentStep.value == 0
                          ? null
                          : controller.currentStep.value -= 1;
                    },
                    controlsBuilder: (context, ControlsDetails details) {
                      final isLastStep =
                          controller.currentStep.value == getSteps().length - 1;
                      return Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Row(
                          children: [
                            if (controller.currentStep.value != 0)
                              ElevatedButton(
                                  onPressed: details.onStepCancel,
                                  child: Text('PREVIOUS')),
                            const SizedBox(
                              width: 12,
                            ),
                            isLastStep
                                ? ConstrainedBox(
                                    constraints: BoxConstraints.tightFor(
                                        width: 130, height: 50),
                                    child: ElevatedButton.icon(
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        padding: MaterialStateProperty.all(
                                            EdgeInsets.all(14)),
                                      ),
                                      icon: controller.isDataProcessing.value
                                          ? CircularProgressIndicator()
                                          : Icon(Icons.save),
                                      label: Text(
                                        controller.isDataProcessing.value
                                            ? 'Processing'
                                            : 'Save',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                      onPressed: () {
                                        controller.isDataProcessing.value
                                            ? null
                                            : controller.saveBtn();
                                      },
                                    ),
                                  )
                                : ElevatedButton(
                                    onPressed: details.onStepContinue,
                                    child: Text('NEXT')),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                /* Column(
                          children: <Widget>[
                            SizedBox(
                              height: 10.0,
                            ),
                            Visibility(
                                visible: true,
                                child: DropdownSearch<TypeReunionModel>(
                                  showSelectedItems: true,
                                  showClearButton: true,
                                  showSearchBox: true,
                                  isFilteredOnline: true,
                                  compareFn: (i, s) => i?.isEqual(s) ?? false,
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText: "Type Reunion *",
                                    contentPadding:
                                        EdgeInsets.fromLTRB(12, 12, 0, 0),
                                    border: OutlineInputBorder(),
                                  ),
                                  onFind: (String? filter) =>
                                      getTypeReunion(filter),
                                  onChanged: (data) {
                                    controller.typeReunionModel = data;
                                    controller.selectedCodeType =
                                        data?.codeTypeR;
                                    if (controller.typeReunionModel == null) {
                                      controller.selectedCodeType = 0;
                                    }
                                    print(
                                        'typeReunion: ${controller.typeReunionModel?.typeReunion}, code: ${controller.selectedCodeType}');
                                  },
                                  dropdownBuilder:
                                      controller.customDropDownType,
                                  popupItemBuilder:
                                      controller.customPopupItemBuilderType,
                                  validator: (u) =>
                                      u == null ? "type is required " : null,
                                )),
                            SizedBox(
                              height: 10.0,
                            ),
                            TextFormField(
                              controller: controller.orderController,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.next,
                              /* validator: (value) => Validator.validateField(
                                        value: value!
                                    ), */
                              decoration: InputDecoration(
                                labelText: 'Ordre du jour',
                                hintText: 'Ordre du jour',
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
                              controller: controller.lieuController,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText: 'Lieu',
                                hintText: 'lieu',
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
                              visible: true,
                              child: InkWell(
                                onTap: () {
                                  controller.selectedDatePrevue(context);
                                },
                                child: TextFormField(
                                  controller: controller.datePrevueController,
                                  enabled: false,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  validator: (value) =>
                                      Validator.validateField(value: value!),
                                  onChanged: (value) {
                                    controller.selectedDatePrevue(context);
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'Date Prévue *',
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
                                              .selectedDatePrevue(context);
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
                                  controller.selectedTimeDebut(context);
                                },
                                child: TextFormField(
                                  controller: controller.heureDebutController,
                                  enabled: false,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  onChanged: (value) {
                                    controller.selectedTimeDebut(context);
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'Heure Debut Reunion',
                                      hintText: 'time',
                                      labelStyle: TextStyle(
                                        fontSize: 14.0,
                                      ),
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 10.0,
                                      ),
                                      suffixIcon: InkWell(
                                        onTap: () {
                                          controller.selectedTimeDebut(context);
                                        },
                                        child: Icon(Icons.timer),
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
                                  controller.selectedTimeFin(context);
                                },
                                child: TextFormField(
                                  controller: controller.heureFinController,
                                  enabled: false,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  onChanged: (value) {
                                    controller.selectedTimeFin(context);
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'Heure Fin Reunion',
                                      hintText: 'time',
                                      labelStyle: TextStyle(
                                        fontSize: 14.0,
                                      ),
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 10.0,
                                      ),
                                      suffixIcon: InkWell(
                                        onTap: () {
                                          controller.selectedTimeFin(context);
                                        },
                                        child: Icon(Icons.timer),
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
                            TextFormField(
                              enabled: false,
                              controller: controller.dureeReunionController,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText: 'Durée Reunion',
                                hintText: 'durée',
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
                                    if (controller.siteModel == null) {
                                      controller.selectedCodeSite = 0;
                                    }
                                    print(
                                        'site: ${controller.siteModel?.site}, code: ${controller.selectedCodeSite}');
                                  },
                                  dropdownBuilder:
                                      controller.customDropDownSite,
                                  popupItemBuilder:
                                      controller.customPopupItemBuilderSite,
                                  validator: (u) =>
                                      (controller.site_obligatoire.value == 1 &&
                                              controller.siteModel == null)
                                          ? "site is required "
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
                                    print(
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
                                          ? "processus is required "
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
                                      print(
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
                                        ? "direction is required "
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
                                      print(
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
                                            ? "service is required "
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
                                          "Activity ${controller.activity_obligatoire.value == 1 ? '*' : ''}",
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
                                      print(
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
                                        ? "activity is required "
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
                            Divider(
                              thickness: 4,
                              color: Color(0xFF333432),
                            ),
                            Center(
                              child: Text(
                                'Realisation',
                                style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF0769D2),
                                    fontFamily: "Signatra"),
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
                                      groupValue: controller.etat.value,
                                      onChanged: (value) {
                                        controller.onChangeEtat(value);
                                      },
                                      activeColor: Colors.blue,
                                      fillColor: MaterialStateProperty.all(
                                          Colors.blue),
                                    ),
                                    const Text(
                                      "Non encore réalisée",
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
                                      groupValue: controller.etat.value,
                                      onChanged: (value) {
                                        controller.onChangeEtat(value);
                                      },
                                      activeColor: Colors.blue,
                                      fillColor: MaterialStateProperty.all(
                                          Colors.blue),
                                    ),
                                    const Text(
                                      "Réalisée",
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
                                      value: 3,
                                      groupValue: controller.etat.value,
                                      onChanged: (value) {
                                        controller.onChangeEtat(value);
                                      },
                                      activeColor: Colors.blue,
                                      fillColor: MaterialStateProperty.all(
                                          Colors.blue),
                                    ),
                                    const Text(
                                      "Reportée",
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
                                      value: 2,
                                      groupValue: controller.etat.value,
                                      onChanged: (value) {
                                        controller.onChangeEtat(value);
                                      },
                                      activeColor: Colors.blue,
                                      fillColor: MaterialStateProperty.all(
                                          Colors.blue),
                                    ),
                                    const Text(
                                      "Annulée",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Visibility(
                              visible: true,
                              child: TextFormField(
                                controller:
                                    controller.dateRealisationController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                validator: (value) =>
                                    Validator.validateField(value: value!),
                                onChanged: (value) {
                                  controller.selectedDateRealisation(context);
                                },
                                decoration: InputDecoration(
                                    labelText: 'Date Realisation *',
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
                                            .selectedDateRealisation(context);
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
                            TextFormField(
                              controller: controller.dureeRealController,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText: 'Durée Réalisée',
                                hintText: 'durée',
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
                            TextFormField(
                              controller: controller.commentaireController,
                              keyboardType: TextInputType.multiline,
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
                              height: 20.0,
                            ),
                            ConstrainedBox(
                              constraints: BoxConstraints.tightFor(
                                  width: 130, height: 50),
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
                                      ? 'Processing'
                                      : 'Save',
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
                        ) */
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
  Future<List<TypeReunionModel>> getTypeReunion(filter) async {
    try {
      List<TypeReunionModel> _typeList =
          await List<TypeReunionModel>.empty(growable: true);
      List<TypeReunionModel> _typeFilter =
          await List<TypeReunionModel>.empty(growable: true);
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        var response = await controller.localReunionService.readTypeReunion();
        response.forEach((data) {
          var model = TypeReunionModel();
          model.codeTypeR = data['codeTypeR'];
          model.typeReunion = data['typeReunion'];
          _typeList.add(model);
        });
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        await ReunionService().getTypeReunion().then((resp) async {
          resp.forEach((data) async {
            var model = TypeReunionModel();
            model.codeTypeR = data['codeTypeR'];
            model.typeReunion = data['type_Reunion'];
            _typeList.add(model);
          });
        }, onError: (err) {
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
      }
      _typeFilter = _typeList.where((u) {
        var query = u.typeReunion!.toLowerCase();
        return query.contains(filter);
      }).toList();
      return _typeFilter;
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
        var sites = await controller.localActionService
            .readSiteByModule("Réunion", "Réunion");
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
          "modul": "Réunion",
          "site": "0",
          "agenda": 0,
          "fiche": "Réunion"
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
            .readProcessusByModule("Réunion", "Réunion");
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
          "modul": "Réunion",
          "processus": "0",
          "fiche": "Réunion"
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
            .readDirectionByModule("Réunion", "Réunion");
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
          "modul": "Réunion",
          "fiche": "Réunion",
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
                'Réunion', 'Réunion', controller.selectedCodeDirection);
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
                'Réunion', 'Réunion')
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
            .readActivityByModule("Réunion", "Réunion");
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
          "modul": "Réunion",
          "fiche": "Réunion",
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
}
