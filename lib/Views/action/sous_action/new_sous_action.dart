import 'package:connectivity/connectivity.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:qualipro_flutter/Models/gravite_model.dart';
import 'package:qualipro_flutter/Models/priorite_model.dart';
import '../../../Controllers/action/sous_action_controller.dart';
import '../../../Models/employe_model.dart';
import '../../../Models/processus_employe_model.dart';
import '../../../Services/api_services_call.dart';
import '../../../Utils/custom_colors.dart';
import '../../../Utils/snack_bar.dart';
import '../../../Validators/validator.dart';

class NewSousActionPage extends GetView<SousActionController> {
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
          child: Text("${'new'.tr} Sous Action"),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
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
                            labelText: '${'designation'.tr} *',
                            hintText: 'designation'.tr,
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
                        InkWell(
                          onTap: () {
                            controller.selectedDateReal(context);
                          },
                          child: TextFormField(
                            enabled: false,
                            controller: controller.delaiRealisationController,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            validator: (value) =>
                                Validator.validateField(value: value!),
                            onChanged: (value) {
                              controller.selectedDateReal(context);
                            },
                            decoration: InputDecoration(
                                labelText: '${'delai_real'.tr} *',
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
                                    controller.selectedDateReal(context);
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
                        SizedBox(
                          height: 10.0,
                        ),
                        InkWell(
                          onTap: () {
                            controller.selectedDateSuivi(context);
                          },
                          child: TextFormField(
                            enabled: false,
                            controller: controller.delaiSuiviController,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            validator: (value) =>
                                Validator.validateField(value: value!),
                            onChanged: (value) {
                              controller.selectedDateSuivi(context);
                            },
                            decoration: InputDecoration(
                                labelText:
                                    '${'delai_suivi'.tr} ${controller.delai_suivi_obligatoire.value == 1 ? '*' : ''}',
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
                                    controller.selectedDateSuivi(context);
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
                        Visibility(
                          visible:
                              controller.priorite_visible == 1 ? true : false,
                          child: SizedBox(
                            height: 10.0,
                          ),
                        ),
                        Visibility(
                            visible:
                                controller.priorite_visible == 1 ? true : false,
                            child: DropdownSearch<PrioriteModel>(
                              showSelectedItems: true,
                              showClearButton:
                                  controller.prioriteModel?.priorite == ""
                                      ? false
                                      : true,
                              showSearchBox: true,
                              isFilteredOnline: true,
                              compareFn: (i, s) => i?.isEqual(s) ?? false,
                              dropdownSearchDecoration: InputDecoration(
                                labelText:
                                    "${'priority'.tr} ${controller.priorite_obligatoire.value == 1 ? '*' : ''}",
                                contentPadding:
                                    EdgeInsets.fromLTRB(12, 12, 0, 0),
                                border: OutlineInputBorder(),
                              ),
                              onFind: (String? filter) => getPriorite(filter),
                              onChanged: (data) {
                                controller.selectedCodePriorite =
                                    data?.codepriorite;
                                controller.prioriteModel = data;
                                debugPrint(
                                    'priorite: ${controller.prioriteModel?.priorite}, code: ${controller.selectedCodePriorite}');
                              },
                              dropdownBuilder:
                                  controller.customDropDownPriorite,
                              popupItemBuilder:
                                  controller.customPopupItemBuilderPriorite,
                              validator: (u) =>
                                  (controller.priorite_obligatoire.value == 1 &&
                                          controller.prioriteModel == null)
                                      ? "${'priority'.tr} ${'is_required'.tr} "
                                      : null,
                              popupTitle: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        '${'list'.tr} ${'priority'.tr}',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        icon: Icon(
                                          Icons.close,
                                          color: Colors.red,
                                        ))
                                  ],
                                ),
                              ),
                            )),
                        Visibility(
                          visible:
                              controller.gravite_visible == 1 ? true : false,
                          child: SizedBox(
                            height: 10.0,
                          ),
                        ),
                        Visibility(
                            visible:
                                controller.gravite_visible == 1 ? true : false,
                            child: DropdownSearch<GraviteModel>(
                              showSelectedItems: true,
                              showClearButton:
                                  controller.graviteModel?.gravite == ""
                                      ? false
                                      : true,
                              showSearchBox: true,
                              isFilteredOnline: true,
                              compareFn: (i, s) => i?.isEqual(s) ?? false,
                              dropdownSearchDecoration: InputDecoration(
                                labelText:
                                    "${'gravity'.tr} ${controller.gravite_obligatoire.value == 1 ? '*' : ''}",
                                contentPadding:
                                    EdgeInsets.fromLTRB(12, 12, 0, 0),
                                border: OutlineInputBorder(),
                              ),
                              onFind: (String? filter) => getGravite(filter),
                              onChanged: (data) {
                                controller.selectedCodeGravite =
                                    data?.codegravite;
                                controller.graviteModel = data;
                                debugPrint(
                                    'gravite: ${controller.graviteModel?.gravite}, code: ${controller.selectedCodeGravite}');
                              },
                              dropdownBuilder: controller.customDropDownGravite,
                              popupItemBuilder:
                                  controller.customPopupItemBuilderGravite,
                              validator: (u) =>
                                  (controller.gravite_obligatoire.value == 1 &&
                                          controller.graviteModel == null)
                                      ? "${'gravity'.tr} ${'is_required'.tr} "
                                      : null,
                              popupTitle: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        '${'list'.tr} ${'gravity'.tr}',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        icon: Icon(
                                          Icons.close,
                                          color: Colors.red,
                                        ))
                                  ],
                                ),
                              ),
                            )),
                        SizedBox(
                          height: 10.0,
                        ),
                        Visibility(
                            visible: true,
                            child: DropdownSearch<EmployeModel>(
                              showSelectedItems: true,
                              showClearButton:
                                  controller.respRealModel?.nompre == ""
                                      ? false
                                      : true,
                              showSearchBox: true,
                              isFilteredOnline: true,
                              compareFn: (i, s) => i?.isEqual(s) ?? false,
                              dropdownSearchDecoration: InputDecoration(
                                labelText: "${'resp_real'.tr} *",
                                contentPadding:
                                    EdgeInsets.fromLTRB(12, 12, 0, 0),
                                border: OutlineInputBorder(),
                              ),
                              onFind: (String? filter) =>
                                  getResponsableRealisation(filter),
                              onChanged: (data) {
                                controller.selectedResRealCode = data?.mat;
                                controller.respRealModel = data;
                                debugPrint(
                                    'resp real : ${controller.respRealModel?.nompre}, mat:${controller.selectedResRealCode}');
                              },
                              dropdownBuilder: controller.customDropDownEmploye,
                              popupItemBuilder:
                                  controller.customPopupItemBuilderEmploye,
                              popupTitle: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        '${'list'.tr} ${'resp_real'.tr}',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        icon: Icon(
                                          Icons.close,
                                          color: Colors.red,
                                        ))
                                  ],
                                ),
                              ),
                              /*  onBeforeChange: (a, b) {
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
                                      } */
                            )),
                        SizedBox(
                          height: 10.0,
                        ),
                        Visibility(
                            visible: true,
                            child: DropdownSearch<EmployeModel>(
                              showSelectedItems: true,
                              showClearButton:
                                  controller.resSuiviModel?.nompre == ""
                                      ? false
                                      : true,
                              showSearchBox: true,
                              isFilteredOnline: true,
                              compareFn: (i, s) => i?.isEqual(s) ?? false,
                              dropdownSearchDecoration: InputDecoration(
                                labelText: "${'resp_suivi'.tr} *",
                                contentPadding:
                                    EdgeInsets.fromLTRB(12, 12, 0, 0),
                                border: OutlineInputBorder(),
                              ),
                              onFind: (String? filter) =>
                                  getResponsableSuivi(filter),
                              onChanged: (data) {
                                controller.selectedResSuiviCode = data?.mat;
                                controller.resSuiviModel = data;
                                debugPrint(
                                    'resp suivi : ${controller.resSuiviModel?.nompre}, mat:${controller.selectedResSuiviCode}');
                              },
                              dropdownBuilder:
                                  controller.customDropDownRespSuivi,
                              popupItemBuilder:
                                  controller.customPopupItemBuilderEmploye,
                              popupTitle: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        '${'list'.tr} ${'resp_suivi'.tr}',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        icon: Icon(
                                          Icons.close,
                                          color: Colors.red,
                                        ))
                                  ],
                                ),
                              ),
                              /* onBeforeChange: (a, b) {
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
                                      } */
                            )),
                        SizedBox(
                          height: 10.0,
                        ),
                        Visibility(
                            visible: true,
                            child: DropdownSearch<ProcessusEmployeModel>(
                              showSelectedItems: true,
                              showClearButton:
                                  controller.processusModel?.processus == ""
                                      ? false
                                      : true,
                              showSearchBox: true,
                              isFilteredOnline: true,
                              compareFn: (i, s) => i?.isEqual(s) ?? false,
                              dropdownSearchDecoration: InputDecoration(
                                labelText: "Processus",
                                contentPadding:
                                    EdgeInsets.fromLTRB(12, 12, 0, 0),
                                border: OutlineInputBorder(),
                              ),
                              onFind: (String? filter) => getProcessus(filter),
                              onChanged: (data) {
                                controller.selectedProcessusCode =
                                    data?.codeProcessus;
                                controller.processusModel = data;
                                print(controller.processusModel?.processus);
                                print(controller.selectedProcessusCode);
                              },
                              dropdownBuilder:
                                  controller.customDropDownProcessus,
                              popupItemBuilder:
                                  controller.customPopupItemBuilderProcessus,
                              popupTitle: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        '${'list'.tr} Processus',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        icon: Icon(
                                          Icons.close,
                                          color: Colors.red,
                                        ))
                                  ],
                                ),
                              ),
                              /* onBeforeChange: (a, b) {
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
                                      } */
                            )),
                        Visibility(
                          visible:
                              controller.cout_prev_visible == 1 ? true : false,
                          child: SizedBox(
                            height: 10.0,
                          ),
                        ),
                        Visibility(
                          visible:
                              controller.cout_prev_visible == 1 ? true : false,
                          child: TextFormField(
                            controller: controller.coutPrevController,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: '${'cout'.tr} prev',
                              hintText: '${'cout'.tr} prev',
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
                        ),
                        Visibility(
                          visible: controller.risque == 1 ? true : false,
                          child: SizedBox(
                            height: 10.0,
                          ),
                        ),
                        Visibility(
                          visible: controller.risque == 1 ? true : false,
                          child: TextFormField(
                            controller: controller.risqueController,
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: 'Risques',
                              hintText: 'risques',
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
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints.tightFor(
                              width: Get.width * 0.5, height: 50),
                          child: ElevatedButton.icon(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all(
                                  CustomColors.googleBackground),
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.all(14)),
                            ),
                            icon: controller.isDataProcessing.value
                                ? CircularProgressIndicator()
                                : Icon(Icons.save),
                            label: Text(
                              controller.isDataProcessing.value
                                  ? 'processing'.tr
                                  : 'save'.tr,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            onPressed: () {
                              controller.saveBtn();
                            },
                          ),
                        ),
                      ],
                    ))),
          ),
        ),
      )),
    );
  }

  //dropdown search
  //priorite
  Future<List<PrioriteModel>> getPriorite(filter) async {
    try {
      List<PrioriteModel> _prioriteList =
          await List<PrioriteModel>.empty(growable: true);
      List<PrioriteModel> _prioriteFilter =
          await List<PrioriteModel>.empty(growable: true);
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        var response = await controller.localActionService.readPriorite();
        response.forEach((data) {
          var model = PrioriteModel();
          model.codepriorite = data['codepriorite'];
          model.priorite = data['priorite'];
          _prioriteList.add(model);
        });
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        await ApiServicesCall().getPriorite().then((resp) async {
          resp.forEach((data) async {
            var model = PrioriteModel();
            model.codepriorite = data['codepriorite'];
            model.priorite = data['priorite'];
            _prioriteList.add(model);
          });
        }, onError: (err) {
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
      }
      _prioriteFilter = _prioriteList.where((u) {
        var query = u.priorite!.toLowerCase();
        return query.contains(filter);
      }).toList();
      return _prioriteFilter;
    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }

//gravite
  Future<List<GraviteModel>> getGravite(filter) async {
    try {
      List<GraviteModel> _graviteList =
          await List<GraviteModel>.empty(growable: true);
      List<GraviteModel> _graviteFilter =
          await List<GraviteModel>.empty(growable: true);
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        var response = await controller.localActionService.readGravite();
        response.forEach((data) {
          var model = GraviteModel();
          model.codegravite = data['codegravite'];
          model.gravite = data['gravite'];
          _graviteList.add(model);
        });
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        await ApiServicesCall().getGravite().then((resp) async {
          resp.forEach((data) async {
            var model = GraviteModel();
            model.codegravite = data['codegravite'];
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

  //Processus
  Future<List<ProcessusEmployeModel>> getProcessus(filter) async {
    try {
      if (controller.selectedResRealCode == null ||
          controller.selectedResRealCode == "") {
        Get.snackbar('warning'.tr, 'select_responsable_realisation'.tr,
            colorText: Colors.blue,
            backgroundColor: Colors.white,
            snackPosition: SnackPosition.BOTTOM);
      }
      List<ProcessusEmployeModel> processusList =
          await List<ProcessusEmployeModel>.empty(growable: true);
      List<ProcessusEmployeModel> processusFilter =
          await <ProcessusEmployeModel>[];
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        var response = await controller.localActionService
            .readProcessusByEmploye(controller.selectedResRealCode);
        response.forEach((data) {
          var model = ProcessusEmployeModel();
          model.codeProcessus = data['codeProcessus'];
          model.processus = data['processus'];
          model.mat = data['mat'];
          processusList.add(model);
        });
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        await ApiServicesCall()
            .getProcessusByMatricule(controller.selectedResRealCode)
            .then((resp) async {
          resp.forEach((data) async {
            var model = ProcessusEmployeModel();
            model.codeProcessus = data['codeProcessus'];
            model.processus = data['processus'];
            model.mat = data['mat'];
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

  //Resp realisation
  Future<List<EmployeModel>> getResponsableRealisation(filter) async {
    try {
      List<EmployeModel> employeList =
          await List<EmployeModel>.empty(growable: true);
      List<EmployeModel> employeFilter =
          await List<EmployeModel>.empty(growable: true);
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        var response = await controller.localActionService.readEmploye();
        response.forEach((data) {
          var model = EmployeModel();
          model.mat = data['mat'];
          model.nompre = data['nompre'];
          employeList.add(model);
        });
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        await ApiServicesCall().getResponsableRealisation({
          "mat": controller.matricule,
          "act": controller.id_action.toString(),
          "sact": "",
          "lang": ""
        }).then((resp) async {
          resp.forEach((data) async {
            var model = EmployeModel();
            model.mat = data['mat'];
            model.nompre = data['nompre'];
            employeList.add(model);
          });
        }, onError: (err) {
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
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

  //Resp suivi
  Future<List<EmployeModel>> getResponsableSuivi(filter) async {
    try {
      List<EmployeModel> employeList =
          await List<EmployeModel>.empty(growable: true);
      List<EmployeModel> employeFilter =
          await List<EmployeModel>.empty(growable: true);
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        var response = await controller.localActionService.readEmploye();
        response.forEach((data) {
          var model = EmployeModel();
          model.mat = data['mat'];
          model.nompre = data['nompre'];
          employeList.add(model);
        });
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        await ApiServicesCall().getResponsableSuivi({
          "act": controller.id_action.toString(),
          "sact": "",
          "mat": controller.matricule,
          "lang": ""
        }).then((resp) async {
          resp.forEach((data) async {
            var model = EmployeModel();
            model.mat = data['mat'];
            model.nompre = data['nompre'];
            employeList.add(model);
          });
        }, onError: (err) {
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
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
}
