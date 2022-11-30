import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qualipro_flutter/Services/pnc/pnc_service.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../../../Controllers/api_controllers_call.dart';
import '../../../Models/employe_model.dart';
import '../../../Utils/custom_colors.dart';
import '../../../Utils/shared_preference.dart';
import '../../../Utils/snack_bar.dart';
import '../../../Validators/validator.dart';
import 'pnc_valider_page.dart';

class RemplirPNCValidation extends StatefulWidget {
  final nnc;

  RemplirPNCValidation({Key? key, required this.nnc}) : super(key: key);

  @override
  State<RemplirPNCValidation> createState() => _RemplirPNCValidationState();
}

class _RemplirPNCValidationState extends State<RemplirPNCValidation> {
  final _addItemFormKey = GlobalKey<FormState>();
  PNCService pncService = PNCService();
  bool _isProcessing = false;
  final matricule = SharedPreference.getMatricule();
  final validor = SharedPreference.getNomPrenom();

  DateTime dateTime = DateTime.now();
  TextEditingController motifController = TextEditingController();
  TextEditingController dateValidationController = TextEditingController();
  TextEditingController validatorController = TextEditingController();

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  String valide = "1";
  String? decideurMatricule = "";

  @override
  void initState() {
    dateValidationController.text = DateFormat('yyyy-MM-dd').format(dateTime);
    validatorController.text = validor.toString();
    super.initState();
  }

  selectedDate(BuildContext context) async {
    var datePicker = await showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(2000),
        lastDate: dateTime);
    if (datePicker != null) {
      setState(() {
        dateTime = datePicker;
        dateValidationController.text =
            DateFormat('yyyy-MM-dd').format(datePicker);
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
          child: Text("P.N.C N° ${widget.nnc}"),
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
                        ToggleSwitch(
                          minWidth: 90.0,
                          minHeight: 60.0,
                          fontSize: 16.0,
                          cornerRadius: 30,
                          initialLabelIndex: 0,
                          activeBgColors: [
                            [Colors.green],
                            [Colors.red],
                            [Colors.blue]
                          ],
                          activeFgColor: Colors.white,
                          inactiveFgColor: Colors.white,
                          totalSwitches: 3,
                          labels: ['valider'.tr, 'refuser'.tr, 'corriger'.tr],
                          /* icons: [
                                  FontAwesomeIcons.mars,
                                  FontAwesomeIcons.venus,
                                  FontAwesomeIcons.transgender
                                ],
                              iconSize: 25, */
                          onToggle: (index) {
                            if (index == 0) {
                              valide = "1";
                              print('valide : $valide');
                            } else if (index == 1) {
                              valide = "2";
                              print('valide : $valide');
                            } else if (index == 2) {
                              valide = "3";
                              print('valide : $valide');
                            }
                          },
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        TextFormField(
                          enabled: false,
                          controller: validatorController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'Validateur'.tr,
                            hintText: 'Validateur'.tr,
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
                          child: TextFormField(
                            enabled: false,
                            controller: dateValidationController,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            validator: (value) =>
                                Validator.validateField(value: value!),
                            onChanged: (value) {
                              selectedDate(context);
                            },
                            decoration: InputDecoration(
                                labelText: 'Date Validation *',
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
                                    selectedDate(context);
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
                        TextFormField(
                          controller: motifController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          validator: (value) =>
                              Validator.validateField(value: value!),
                          decoration: InputDecoration(
                            labelText: '${'comment'.tr} *',
                            hintText: 'comment'.tr,
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
                            labelText: "${'decideur'.tr} *",
                            contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                            border: OutlineInputBorder(),
                          ),
                          onFind: (String? filter) => getDecideur(filter),
                          onChanged: (data) {
                            decideurMatricule = data?.mat;
                            debugPrint(
                                'decideur: ${data?.nompre}, code: ${decideurMatricule}');
                          },
                          dropdownBuilder: customDropDownEmploye,
                          popupItemBuilder: customPopupItemBuilderEmploye,
                          validator: (u) => u == null
                              ? "${'decideur'.tr} ${'is_required'}"
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
        await pncService.updatePNCValidation({
          "nc": widget.nnc.toString(),
          "valide": valide,
          "validateur": matricule.toString(),
          "motif": motifController.text,
          "decideur": decideurMatricule,
          "date_validation": dateValidationController.text
        }).then((resp) async {
          ShowSnackBar.snackBar("Successfully", "PNC validate", Colors.green);
          //Get.back();
          Get.to(PNCValiderPage());
          await ApiControllersCall().getPNCAValider();
        }, onError: (err) {
          _isProcessing = false;
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
      } catch (ex) {
        _isProcessing = false;
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
        _isProcessing = false;
      }
    }
  }

  //decideur
  Future<List<EmployeModel>> getDecideur(filter) async {
    try {
      List<EmployeModel> employeList =
          await List<EmployeModel>.empty(growable: true);
      List<EmployeModel> employeFilter =
          await List<EmployeModel>.empty(growable: true);

      await PNCService().getDecideurByNNC(widget.nnc).then((resp) async {
        resp.forEach((data) async {
          var model = EmployeModel();
          model.nompre = data['nompre'];
          model.mat = data['mat'];
          employeList.add(model);
        });
      }, onError: (err) {
        ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
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

  Widget customDropDownEmploye(BuildContext context, EmployeModel? item) {
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

  Widget customPopupItemBuilderEmploye(
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
