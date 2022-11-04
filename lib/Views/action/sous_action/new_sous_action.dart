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
import '../../../Models/processus_model.dart';
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
            onPressed: (){
              Get.back();
              //controller.clearData();
            },
            child: Icon(Icons.arrow_back, color: Colors.white,),
          ),
          title: Center(
            child: Text("Ajouter Sous Action"),
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
                              SizedBox(height: 10.0,),
                              TextFormField(
                                controller: controller.designationController,
                                keyboardType: TextInputType.multiline,
                                textInputAction: TextInputAction.next,
                                validator: (value) => Validator.validateField(
                                    value: value!
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Designation *',
                                  hintText: 'designation',
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
                                controller: controller.risqueController,
                                keyboardType: TextInputType.multiline,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  labelText: 'Risque',
                                  hintText: 'risque',
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
                                controller: controller.delaiRealisationController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                validator: (value) => Validator.validateField(
                                    value: value!
                                ),
                                onChanged: (value){
                                  controller.selectedDateReal(context);
                                },
                                decoration: InputDecoration(
                                    labelText: 'Delai realisation *',
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
                                        controller.selectedDateReal(context);
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
                                controller: controller.delaiSuiviController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                validator: (value) => Validator.validateField(
                                    value: value!
                                ),
                                onChanged: (value){
                                  controller.selectedDateSuivi(context);
                                },
                                decoration: InputDecoration(
                                    labelText: 'Delai Suivi ${controller.delai_suivi_obligatoire==1?'*':''}',
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
                                        controller.selectedDateSuivi(context);
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
                                  visible: true,
                                  child: DropdownSearch<PrioriteModel>(
                                    showSelectedItems: true,
                                    showClearButton: controller.prioriteModel?.priorite=="" ? false : true,
                                    showSearchBox: true,
                                    isFilteredOnline: true,
                                    compareFn: (i, s) => i?.isEqual(s) ?? false,
                                    dropdownSearchDecoration: InputDecoration(
                                      labelText: "Priorite ${controller.priorite_obligatoire==1?'*':''}",
                                      contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                      border: OutlineInputBorder(),
                                    ),
                                    onFind: (String? filter) => getPriorite(filter),
                                    onChanged: (data) {
                                      controller.selectedCodePriorite = data?.codepriorite;
                                      controller.prioriteModel = data;
                                      print('priorite: ${controller.prioriteModel?.priorite}, code: ${controller.selectedCodePriorite}');
                                    },
                                    dropdownBuilder: controller.customDropDownPriorite,
                                    popupItemBuilder: controller.customPopupItemBuilderPriorite,
                                    validator: (u) =>
                                    (controller.priorite_obligatoire==1 && controller.prioriteModel==null) ? "priorite is required " : null,
                                  )
                              ),

                              SizedBox(height: 10.0,),
                              Visibility(
                                  visible: true,
                                  child: DropdownSearch<GraviteModel>(
                                    showSelectedItems: true,
                                    showClearButton: controller.graviteModel?.gravite=="" ? false : true,
                                    showSearchBox: true,
                                    isFilteredOnline: true,
                                    compareFn: (i, s) => i?.isEqual(s) ?? false,
                                    dropdownSearchDecoration: InputDecoration(
                                      labelText: "Gravite ${controller.gravite_obligatoire==1?'*':''}",
                                      contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                      border: OutlineInputBorder(),
                                    ),
                                    onFind: (String? filter) => getGravite(filter),
                                    onChanged: (data) {
                                      controller.selectedCodeGravite = data?.codegravite;
                                      controller.graviteModel = data;
                                      print('gravite: ${controller.graviteModel?.gravite}, code: ${controller.selectedCodeGravite}');
                                    },
                                    dropdownBuilder: controller.customDropDownGravite,
                                    popupItemBuilder: controller.customPopupItemBuilderGravite,
                                    validator: (u) =>
                                    (controller.gravite_obligatoire==1 && controller.graviteModel==null) ? "gravite is required " : null,
                                  )
                              ),

                              SizedBox(height: 10.0,),
                              Visibility(
                                  visible: true,
                                  child: DropdownSearch<EmployeModel>(
                                      showSelectedItems: true,
                                      showClearButton: controller.respRealModel?.nompre=="" ? false : true,
                                      showSearchBox: true,
                                      isFilteredOnline: true,
                                      compareFn: (i, s) => i?.isEqual(s) ?? false,
                                      dropdownSearchDecoration: InputDecoration(
                                        labelText: "Responsable realisation *",
                                        contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                        border: OutlineInputBorder(),
                                      ),
                                      onFind: (String? filter) => getResponsableRealisation(filter),
                                      onChanged: (data) {
                                        controller.selectedResRealCode = data?.mat;
                                        controller.respRealModel = data;
                                        print('resp real : ${controller.respRealModel?.nompre}, mat:${controller.selectedResRealCode}');
                                      },
                                      dropdownBuilder: controller.customDropDownEmploye,
                                      popupItemBuilder: controller.customPopupItemBuilderEmploye,
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
                                        labelText: "Responsable Suivi *",
                                        contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                        border: OutlineInputBorder(),
                                      ),
                                      onFind: (String? filter) => getResponsableSuivi(filter),
                                      onChanged: (data) {
                                        controller.selectedResSuiviCode = data?.mat;
                                        controller.resSuiviModel = data;
                                        print('resp suivi : ${controller.resSuiviModel?.nompre}, mat:${controller.selectedResSuiviCode}');
                                      },
                                      dropdownBuilder: controller.customDropDownRespSuivi,
                                      popupItemBuilder: controller.customPopupItemBuilderEmploye,
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
                                  )
                              ),

                              SizedBox(height: 10.0,),
                              Visibility(
                                  visible: true,
                                  child: DropdownSearch<ProcessusEmployeModel>(
                                      showSelectedItems: true,
                                      showClearButton: controller.processusModel?.processus=="" ? false : true,
                                      showSearchBox: true,
                                      isFilteredOnline: true,
                                      compareFn: (i, s) => i?.isEqual(s) ?? false,
                                      dropdownSearchDecoration: InputDecoration(
                                        labelText: "Processus",
                                        contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                        border: OutlineInputBorder(),
                                      ),
                                      onFind: (String? filter) => getProcessus(filter),
                                      onChanged: (data) {
                                        controller.selectedProcessusCode = data?.codeProcessus;
                                        controller.processusModel = data;
                                        print(controller.processusModel?.processus);
                                        print(controller.selectedProcessusCode);
                                      },
                                      dropdownBuilder: controller.customDropDownProcessus,
                                      popupItemBuilder: controller.customPopupItemBuilderProcessus,
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
                                  )
                              ),

                              SizedBox(height: 10.0,),
                              TextFormField(
                                controller: controller.coutPrevController,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  labelText: 'Cout prev',
                                  hintText: 'cout prev',
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
                                    controller.saveBtn();
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
                                      fontSize: 20,
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
              ),
            )
        ),
    );
  }
  
  //dropdown search
  //priorite
  Future<List<PrioriteModel>> getPriorite(filter) async {
    try {
      List<PrioriteModel> _prioriteList = await List<PrioriteModel>.empty(growable: true);
      List<PrioriteModel> _prioriteFilter = await List<PrioriteModel>.empty(growable: true);
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        var response = await controller.localActionService.readPriorite();
        response.forEach((data){
          var model = PrioriteModel();
          model.codepriorite = data['codepriorite'];
          model.priorite = data['priorite'];
          _prioriteList.add(model);
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        await ApiServicesCall().getPriorite().then((resp) async {
          resp.forEach((data) async {
            var model = PrioriteModel();
            model.codepriorite = data['codepriorite'];
            model.priorite = data['priorite'];
            _prioriteList.add(model);
          });
        }
            , onError: (err) {
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
      List<GraviteModel> _graviteList = await List<GraviteModel>.empty(growable: true);
      List<GraviteModel> _graviteFilter = await List<GraviteModel>.empty(growable: true);
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        var response = await controller.localActionService.readGravite();
        response.forEach((data){
          var model = GraviteModel();
          model.codegravite = data['codegravite'];
          model.gravite = data['gravite'];
          _graviteList.add(model);
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        await ApiServicesCall().getGravite().then((resp) async {
          resp.forEach((data) async {
            var model = GraviteModel();
            model.codegravite = data['codegravite'];
            model.gravite = data['gravite'];
            _graviteList.add(model);
          });
        }
            , onError: (err) {
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
      if(controller.selectedResRealCode == null){
        Get.snackbar("No Data", "Please select Responsable Realisation", colorText: Colors.blue, backgroundColor: Colors.white,  snackPosition: SnackPosition.BOTTOM);
      }
      List<ProcessusEmployeModel> processusList = await List<ProcessusEmployeModel>.empty(growable: true);
      List<ProcessusEmployeModel> processusFilter = await <ProcessusEmployeModel>[];
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        var response = await controller.localActionService.readProcessusByEmploye(controller.selectedResRealCode);
        response.forEach((data){
          var model = ProcessusEmployeModel();
          model.codeProcessus = data['codeProcessus'];
          model.processus = data['processus'];
          model.mat = data['mat'];
          processusList.add(model);
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        await ApiServicesCall().getProcessusByMatricule(controller.selectedResRealCode).then((resp) async {
          resp.forEach((data) async {
            var model = ProcessusEmployeModel();
            model.codeProcessus = data['codeProcessus'];
            model.processus = data['processus'];
            model.mat = data['mat'];
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

  //Resp realisation
  Future<List<EmployeModel>> getResponsableRealisation(filter) async {
    try {
      List<EmployeModel> employeList = await List<EmployeModel>.empty(growable: true);
      List<EmployeModel>employeFilter = await List<EmployeModel>.empty(growable: true);
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        var response = await controller.localActionService.readEmploye();
        response.forEach((data){
          var model = EmployeModel();
          model.mat = data['mat'];
          model.nompre = data['nompre'];
          employeList.add(model);
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
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
        }
            , onError: (err) {
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });
      }
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
  //Resp suivi
  Future<List<EmployeModel>> getResponsableSuivi(filter) async {
    try {
      List<EmployeModel> employeList = await List<EmployeModel>.empty(growable: true);
      List<EmployeModel>employeFilter = await List<EmployeModel>.empty(growable: true);
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        var response = await controller.localActionService.readEmploye();
        response.forEach((data){
          var model = EmployeModel();
          model.mat = data['mat'];
          model.nompre = data['nompre'];
          employeList.add(model);
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
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
        }
            , onError: (err) {
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });
      }
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

}