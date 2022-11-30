import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../Models/employe_model.dart';
import '../../../../Models/pnc/traitement_decision_model.dart';
import '../../../../Services/action/local_action_service.dart';
import '../../../../Services/pnc/pnc_service.dart';
import '../../../../Utils/custom_colors.dart';
import '../../../../Utils/shared_preference.dart';
import '../../../../Utils/snack_bar.dart';
import '../remplir_pnc_decision_traitement.dart';

class NewResponsableTraitement extends StatefulWidget {
  TraitementDecisionModel traitementDecisionModel;

  NewResponsableTraitement({Key? key, required this.traitementDecisionModel})
      : super(key: key);

  @override
  State<NewResponsableTraitement> createState() =>
      _NewResponsableTraitementState();
}

class _NewResponsableTraitementState extends State<NewResponsableTraitement> {
  final _addItemFormKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  PNCService pncService = PNCService();
  bool _isProcessing = false;
  final matricule = SharedPreference.getMatricule();

  DateTime dateTime = DateTime.now();
  TextEditingController dateTraitementController = TextEditingController();
  TextEditingController traitementNCController = TextEditingController();

  String? employeMatricule = "";
  int? selectCodeTypeTraitement = 0;

  bool checkFirstResponsable = false;
  String firstResponsable = "0";
  String? language = "";

  @override
  void initState() {
    dateTraitementController.text = DateFormat('yyyy-MM-dd').format(dateTime);
    if (SharedPreference.getLangue() == null) {
      language = "";
    } else {
      language = SharedPreference.getLangue();
    }
    super.initState();
  }

  selectedDate(BuildContext context) async {
    var datePicker = await showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2050));
    if (datePicker != null) {
      setState(() {
        dateTime = datePicker;
        dateTraitementController.text =
            DateFormat('yyyy-MM-dd').format(datePicker);
      });
    }
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
          child: Text("${'new'.tr} ${'responsable'.tr} ${'processing'.tr}"),
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
                              controller: dateTraitementController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              onChanged: (value) {
                                selectedDate(context);
                              },
                              decoration: InputDecoration(
                                  labelText: 'Date ${'processing'.tr}',
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
                              controller: traitementNCController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText: '${'processing'.tr} N.C',
                                hintText: '${'processing'.tr} N.C',
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
                            )),
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
                            labelText: "Employe *",
                            contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                            border: OutlineInputBorder(),
                          ),
                          onFind: (String? filter) => getEmploye(filter),
                          onChanged: (data) {
                            employeMatricule = data?.mat;
                            debugPrint(
                                'employe: ${data?.nompre}, mat: ${employeMatricule}');
                          },
                          dropdownBuilder: customDropDownEmploye,
                          popupItemBuilder: customPopupItemBuilderEmploye,
                          validator: (u) =>
                              u == null ? "Employe ${'is_required'.tr}" : null,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Visibility(
                          visible: true,
                          child: CheckboxListTile(
                            title: Text('${'first'.tr} ${'responsable'.tr}'),
                            value: checkFirstResponsable,
                            onChanged: (bool? value) {
                              setState(() {
                                checkFirstResponsable = value!;
                                if (checkFirstResponsable == true) {
                                  firstResponsable = "1";
                                } else {
                                  firstResponsable = "0";
                                }
                                debugPrint(
                                    'Premier Responsable ${firstResponsable}');
                              });
                            },
                            activeColor: Colors.blue,
                            //secondary: const Icon(Icons.hourglass_empty),
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
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
                                  padding: const EdgeInsets.all(15.0),
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
    if (_addItemFormKey.currentState!.validate()) {
      try {
        setState(() {
          _isProcessing = true;
        });

        await pncService.addResponsableTraitement({
          "nnc": widget.traitementDecisionModel.nnc.toString(),
          "mat": employeMatricule,
          "traitement": traitementNCController.text,
          "delai": dateTraitementController.text,
          "premier": firstResponsable,
          "lang": language
        }).then((resp) async {
          ShowSnackBar.snackBar(
              "Successfully", "Responsable added", Colors.green);
          //Get.back();
          Get.to(RemplirPNCTraitementDecision(
            traitementDecisionModel: widget.traitementDecisionModel,
          ));
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

  //getEmploye
  Future<List<EmployeModel>> getEmploye(filter) async {
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
