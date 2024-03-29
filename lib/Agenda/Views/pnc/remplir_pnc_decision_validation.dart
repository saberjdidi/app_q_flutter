import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qualipro_flutter/Services/pnc/pnc_service.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../../../Controllers/api_controllers_call.dart';
import '../../../Models/pnc/pnc_validation_decision_model.dart';
import '../../../Utils/custom_colors.dart';
import '../../../Utils/shared_preference.dart';
import '../../../Utils/snack_bar.dart';
import '../../../Validators/validator.dart';
import 'pnc_valider_decision_traitement_page.dart';

class RemplirPNCDecisionValidation extends StatefulWidget {
  PNCValidationTraitementModel pncModel;

  RemplirPNCDecisionValidation({Key? key, required this.pncModel})
      : super(key: key);

  @override
  State<RemplirPNCDecisionValidation> createState() =>
      _RemplirPNCDecisionValidationState();
}

class _RemplirPNCDecisionValidationState
    extends State<RemplirPNCDecisionValidation> {
  final _addItemFormKey = GlobalKey<FormState>();
  PNCService pncService = PNCService();
  bool _isProcessing = false;
  final matricule = SharedPreference.getMatricule();
  final validor = SharedPreference.getNomPrenom();

  DateTime dateTime = DateTime.now();
  TextEditingController commentaireController = TextEditingController();
  TextEditingController dateValidationController = TextEditingController();
  TextEditingController validatorController = TextEditingController();

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  int valide = 1;

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
          child: Text("P.N.C N° ${widget.pncModel.nnc}"),
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
                            [Colors.red]
                          ],
                          activeFgColor: Colors.white,
                          inactiveFgColor: Colors.white,
                          totalSwitches: 2,
                          labels: ['valider'.tr, 'refuser'.tr],
                          /* icons: [
                                  FontAwesomeIcons.mars,
                                  FontAwesomeIcons.venus,
                                  FontAwesomeIcons.transgender
                                ],
                              iconSize: 25, */
                          onToggle: (index) {
                            if (index == 0) {
                              valide = 1;
                              print('valide : $valide');
                            } else if (index == 1) {
                              valide = 0;
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
                            labelText: '${'responsable'.tr} Validation',
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
                                labelText: 'Date',
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
                          controller: commentaireController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          validator: (value) =>
                              Validator.validateField(value: value!),
                          decoration: InputDecoration(
                            labelText: 'comment'.tr,
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
        await pncService.validDecisionTraitementPNC({
          "nnc": widget.pncModel.nnc,
          "val": valide,
          "mat": matricule.toString(),
          "commentaire": commentaireController.text,
          "codePdt": ""
        }).then((resp) async {
          ShowSnackBar.snackBar("Successfully", "PNC validate", Colors.green);
          //Get.back();
          Get.to(PNCValiderDecisionTraitementPage());
          await ApiControllersCall().getPNCDecisionTraitementAValidater();
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
}
