import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:qualipro_flutter/Models/incident_securite/incident_securite_agenda_model.dart';
import 'package:qualipro_flutter/Services/incident_securite/incident_securite_service.dart';
import '../../../Controllers/api_controllers_call.dart';
import '../../../Models/employe_model.dart';
import '../../../Services/action/local_action_service.dart';
import '../../../Utils/custom_colors.dart';
import '../../../Utils/shared_preference.dart';
import '../../../Utils/snack_bar.dart';
import '../../../Validators/validator.dart';
import 'decision_traitement_incident_securite_page.dart';

class ValiderIncidentSecuriteDecisionTraitement extends StatefulWidget {
  IncidentSecuriteAgendaModel model;

  ValiderIncidentSecuriteDecisionTraitement({Key? key, required this.model})
      : super(key: key);

  @override
  State<ValiderIncidentSecuriteDecisionTraitement> createState() =>
      _ValiderIncidentSecuriteDecisionTraitementState();
}

class _ValiderIncidentSecuriteDecisionTraitementState
    extends State<ValiderIncidentSecuriteDecisionTraitement> {
  final _addItemFormKey = GlobalKey<FormState>();
  bool _isProcessing = false;
  final matricule = SharedPreference.getMatricule();
  final decideur = SharedPreference.getNomPrenom();

  DateTime dateTime = DateTime.now();
  TextEditingController causeController = TextEditingController();
  TextEditingController traitementController = TextEditingController();
  TextEditingController delaiTraitementController = TextEditingController();
  TextEditingController decideurController = TextEditingController();

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  String? respTraitementMatricule = "";
  String? respClotureMatricule = "";

  @override
  void initState() {
    delaiTraitementController.text = DateFormat('dd/MM/yyyy').format(dateTime);
    decideurController.text = decideur.toString();
    super.initState();
  }

  selectedDate(BuildContext context) async {
    var datePicker = await showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2030));
    if (datePicker != null) {
      setState(() {
        dateTime = datePicker;
        delaiTraitementController.text =
            DateFormat('dd/MM/yyyy').format(datePicker);
      });
    }
  }

  bool _dataValidation() {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        leading: TextButton(
          onPressed: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Center(
          child: Text(
            "Incident N° ${widget.model.ref}",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: SingleChildScrollView(
            child: Form(
                key: _addItemFormKey,
                child: Padding(
                    padding: EdgeInsets.all(25.0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 8.0,
                        ),
                        TextFormField(
                          enabled: false,
                          controller: decideurController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'decideur'.tr,
                            hintText: 'decideur'.tr,
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
                              selectedDate(context);
                            },
                            child: TextFormField(
                              enabled: false,
                              controller: delaiTraitementController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              validator: (value) =>
                                  Validator.validateField(value: value!),
                              onChanged: (value) {
                                selectedDate(context);
                              },
                              decoration: InputDecoration(
                                  labelText: '${'delai_traitement'.tr} *',
                                  hintText: 'delai_traitement'.tr,
                                  labelStyle: TextStyle(
                                    fontSize: 14.0,
                                  ),
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10.0,
                                  ),
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      selectedDate(context);
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
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          controller: causeController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          validator: (value) =>
                              Validator.validateField(value: value!),
                          decoration: InputDecoration(
                            labelText: 'Cause Incident *',
                            hintText: 'cause',
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
                          controller: traitementController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          validator: (value) =>
                              Validator.validateField(value: value!),
                          decoration: InputDecoration(
                            labelText: '${'processing'.tr} Incident *',
                            hintText: 'processing'.tr,
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
                        DropdownSearch<EmployeModel>(
                          showSelectedItems: true,
                          showClearButton: true,
                          showSearchBox: true,
                          isFilteredOnline: true,
                          compareFn: (i, s) => i?.isEqual(s) ?? false,
                          dropdownSearchDecoration: InputDecoration(
                            labelText:
                                "${'responsable'.tr} ${'processing'.tr} *",
                            contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                            border: OutlineInputBorder(),
                          ),
                          onFind: (String? filter) =>
                              getResponsableTraitement(filter),
                          onChanged: (data) {
                            respTraitementMatricule = data?.mat;
                            debugPrint(
                                'resp traitement: ${data?.nompre}, code: ${respTraitementMatricule}');
                          },
                          dropdownBuilder: customDropDownResponsableTraitement,
                          popupItemBuilder:
                              customPopupItemBuilderResponsableTraitement,
                          validator: (u) => u == null
                              ? "${'responsable'.tr} ${'processing'.tr} ${'is_required'.tr}"
                              : null,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        DropdownSearch<EmployeModel>(
                          showSelectedItems: true,
                          showClearButton: true,
                          showSearchBox: true,
                          isFilteredOnline: true,
                          compareFn: (i, s) => i?.isEqual(s) ?? false,
                          dropdownSearchDecoration: InputDecoration(
                            labelText: "${'resp_cloture'.tr} *",
                            contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                            border: OutlineInputBorder(),
                          ),
                          onFind: (String? filter) =>
                              getResponsableCloture(filter),
                          onChanged: (data) {
                            respClotureMatricule = data?.mat;
                            debugPrint(
                                'resp cloture: ${data?.nompre}, code: ${respClotureMatricule}');
                          },
                          dropdownBuilder: customDropDownResponsableCloture,
                          popupItemBuilder:
                              customPopupItemBuilderResponsableCloture,
                          validator: (u) => u == null
                              ? "${'resp_cloture'.tr} ${'is_required'.tr}"
                              : null,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        _isProcessing
                            ? Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    CustomColors.firebaseOrange,
                                  ),
                                ),
                              )
                            : ElevatedButton(
                                onPressed: () async {
                                  saveBtn();
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
                                  child: Text(
                                    'save'.tr,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: CustomColors.firebaseWhite,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ),
                              )
                      ],
                    ))),
          ),
        ),
      )),
    );
  }

  Future saveBtn() async {
    if (_dataValidation() && _addItemFormKey.currentState!.validate()) {
      try {
        setState(() {
          _isProcessing = true;
        });
        await IncidentSecuriteService()
            .validerIncidentSecuriteDecisionTraitement({
          "numInc": widget.model.ref,
          "respTraitement": respTraitementMatricule,
          "respCloture": respClotureMatricule,
          "cause": causeController.text,
          "traitement": traitementController.text,
          "delaiTraitement": delaiTraitementController.text,
          "mat": matricule.toString()
        }).then((resp) async {
          ShowSnackBar.snackBar(
              "Successfully", "Incident validate", Colors.green);
          //Get.back();
          Get.to(DecisionTraitementIncidentSecuritePage());
          await ApiControllersCall().getIncidentSecuriteDecisionTraitement();
        }, onError: (err) {
          setState(() {
            _isProcessing = false;
          });
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
      } catch (ex) {
        setState(() {
          _isProcessing = false;
        });
        AwesomeDialog(
          context: context,
          animType: AnimType.SCALE,
          dialogType: DialogType.ERROR,
          body: Center(
            child: Text(
              ex.toString(),
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          title: 'Error',
          btnCancel: Text('Cancel'),
          btnOkOnPress: () {
            Navigator.of(context).pop();
          },
        )..show();
        print("throwing new error " + ex.toString());
        throw Exception("Error " + ex.toString());
      } finally {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  //resp traitement
  Future<List<EmployeModel>> getResponsableTraitement(filter) async {
    try {
      List<EmployeModel> employeList =
          await List<EmployeModel>.empty(growable: true);
      List<EmployeModel> employeFilter =
          await List<EmployeModel>.empty(growable: true);
      var response = await LocalActionService().readEmploye();
      response.forEach((data) {
        var model = EmployeModel();
        model.mat = data['mat'];
        model.nompre = data['nompre'];
        employeList.add(model);
      });
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

  Widget customDropDownResponsableTraitement(
      BuildContext context, EmployeModel? item) {
    if (item == null) {
      return Container();
    } else {
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${item.nompre}', style: TextStyle(color: Colors.black)),
        ),
      );
    }
  }

  Widget customPopupItemBuilderResponsableTraitement(
      BuildContext context, EmployeModel item, bool isSelected) {
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
        title: Text(item.nompre ?? ''),
        //subtitle: Text(item.mat.toString() ?? ''),
      ),
    );
  }

  //resp cloture
  Future<List<EmployeModel>> getResponsableCloture(filter) async {
    try {
      List<EmployeModel> employeList =
          await List<EmployeModel>.empty(growable: true);
      List<EmployeModel> employeFilter =
          await List<EmployeModel>.empty(growable: true);
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        Get.defaultDialog(
            title: 'mode_offline'.tr,
            backgroundColor: Colors.white,
            titleStyle: TextStyle(color: Colors.black),
            middleTextStyle: TextStyle(color: Colors.white),
            textCancel: "Back",
            onCancel: () {
              Get.back();
            },
            confirmTextColor: Colors.white,
            buttonColor: Colors.blue,
            barrierDismissible: false,
            radius: 20,
            content: Center(
              child: Column(
                children: <Widget>[
                  Lottie.asset('assets/images/empty_list.json',
                      width: 150, height: 150),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('no_internet'.tr,
                        style: TextStyle(color: Colors.blueGrey, fontSize: 20)),
                  ),
                ],
              ),
            ));
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        await IncidentSecuriteService()
            .getResponsableCloture(
                widget.model.idSite, widget.model.idProcessus)
            .then((resp) async {
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

  Widget customDropDownResponsableCloture(
      BuildContext context, EmployeModel? item) {
    if (item == null) {
      return Container();
    } else {
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${item.nompre}', style: TextStyle(color: Colors.black)),
        ),
      );
    }
  }

  Widget customPopupItemBuilderResponsableCloture(
      BuildContext context, EmployeModel item, bool isSelected) {
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
        title: Text(item.nompre ?? ''),
        //subtitle: Text(item.mat.toString() ?? ''),
      ),
    );
  }
}
