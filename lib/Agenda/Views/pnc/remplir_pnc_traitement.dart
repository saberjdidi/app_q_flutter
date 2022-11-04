import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:qualipro_flutter/Models/action/action_realisation_model.dart';

import '../../../Controllers/api_controllers_call.dart';
import '../../../Models/employe_model.dart';
import '../../../Models/pnc/pnc_a_traiter_model.dart';
import '../../../Models/pnc/responsable_traitement_model.dart';
import '../../../Services/action/action_service.dart';
import '../../../Services/action/local_action_service.dart';
import '../../../Services/pnc/pnc_service.dart';
import '../../../Utils/custom_colors.dart';
import '../../../Utils/message.dart';
import '../../../Utils/shared_preference.dart';
import '../../../Utils/snack_bar.dart';
import '../../../Utils/utility_file.dart';
import '../../../Validators/validator.dart';
import 'pnc_traiter_page.dart';

class RemplirPNCTraitement extends StatefulWidget {
  PNCTraiterModel pncTraiterModel;

  RemplirPNCTraitement({Key? key, required this.pncTraiterModel})
      : super(key: key);

  @override
  State<RemplirPNCTraitement> createState() => _RemplirPNCTraitementState();
}

class _RemplirPNCTraitementState extends State<RemplirPNCTraitement> {
  final _addItemFormKey = GlobalKey<FormState>();
  PNCService pncService = PNCService();
  bool _isProcessing = false;
  final matricule = SharedPreference.getMatricule();

  DateTime dateTime = DateTime.now();
  TextEditingController productController = TextEditingController();
  TextEditingController dateSaisieController = TextEditingController();
  TextEditingController dateTraitementController = TextEditingController();
  TextEditingController rapportController = TextEditingController();

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  int quantiy_detect = 0;

  TextEditingController quantityDeclasseController = TextEditingController();
  int quantity_declasse = 0;
  TextEditingController quantityRejeteController = TextEditingController();
  int quantity_rejete = 0;
  TextEditingController quantityAccepteController = TextEditingController();
  int quantity_accepte = 0;
  TextEditingController valeurRejeteController = TextEditingController();
  int valeur_rejete = 0;
  TextEditingController valeurDeclasseController = TextEditingController();
  int valeur_declasse = 0;
  TextEditingController coutTraitementController = TextEditingController();
  int cout_traitement = 0;
  TextEditingController coutTotalController = TextEditingController();
  int cout_total = 0;
  TextEditingController depreciationController = TextEditingController();
  int depreciation = 0;

  String? responsableTraitementMatricule = "";
  int? responsableTraitementId = 0;
  ResponsableTraitementModel? responsableTraitementModel;
  var phaseTraite = 0;
  onChangePhaseTraite(var traite) {
    setState(() {
      phaseTraite = traite;
      print('phase traite : ${phaseTraite}');
    });
  }

  //image picker
  final ImagePicker imagePicker = ImagePicker();
  List<XFile> imageFileList = [];
  List<String> base64List = [];
  String base64String = '';

  @override
  void initState() {
    productController.text = widget.pncTraiterModel.produit.toString();
    dateSaisieController.text = DateFormat('yyyy-MM-dd').format(dateTime);
    dateTraitementController.text = DateFormat('yyyy-MM-dd').format(dateTime);
    quantityDeclasseController.text = "0";
    quantityAccepteController.text = quantity_accepte.toString();
    quantityRejeteController.text = quantity_rejete.toString();
    coutTraitementController.text = cout_traitement.toString();
    coutTotalController.text = cout_total.toString();
    valeurDeclasseController.text = valeur_declasse.toString();
    valeurRejeteController.text = valeur_rejete.toString();
    depreciationController.text = depreciation.toString();
    quantiy_detect = widget.pncTraiterModel.qteDetect!;
    print('quantity detect : $quantiy_detect');
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
        dateTraitementController.text =
            DateFormat('yyyy-MM-dd').format(datePicker);
      });
    }
  }

  bool _dataValidation() {
    quantity_rejete = int.parse(quantityRejeteController.text.toString());
    quantity_accepte = int.parse(quantityAccepteController.text.toString());
    quantity_declasse = int.parse(quantityDeclasseController.text.toString());
    valeur_rejete = int.parse(valeurRejeteController.text.toString());
    valeur_declasse = int.parse(valeurDeclasseController.text.toString());
    cout_traitement = int.parse(coutTraitementController.text.toString());
    cout_total = int.parse(coutTotalController.text.toString());
    depreciation = int.parse(depreciationController.text.toString());

    if (responsableTraitementModel == null && responsableTraitementId == 0) {
      Message.taskErrorOrWarning(
          "Alert", "Veuillez selectionner responsable de traitement");
      return false;
    }
    if (depreciation > 100) {
      Message.taskErrorOrWarning(
          "Alert", "Veuillez saisir donnée inférieur ou égal à 100");
      return false;
    }
    if ((quantity_accepte + quantity_declasse + quantity_rejete) >
        quantiy_detect) {
      Message.taskErrorOrWarning("Alert",
          "La somme des quantités ne doit pas dépasser la quantité détectée");
      return false;
    }
    if (quantityDeclasseController.text.trim() == '') {
      Message.taskErrorOrWarning("Alert", "Quantite declassée est obligatoire");
      return false;
    } else if (quantityAccepteController.text.trim() == '') {
      Message.taskErrorOrWarning("Alert", "Quantite acceptée est obligatoire");
      return false;
    } else if (quantityRejeteController.text.trim() == '') {
      Message.taskErrorOrWarning("Alert", "Quantite rejetée est obligatoire");
      return false;
    }
    /* if(quantityDeclasseController.text.trim()==''){
      quantity_declasse = 0;
    } else {
      quantity_declasse = int.parse(quantityDeclasseController.text.toString());
    } */
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
          child: Text("PNC N° ${widget.pncTraiterModel.nnc}"),
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
                        DropdownSearch<ResponsableTraitementModel>(
                          showSelectedItems: true,
                          showClearButton: true,
                          showSearchBox: true,
                          isFilteredOnline: true,
                          compareFn: (i, s) => i?.isEqual(s) ?? false,
                          dropdownSearchDecoration: InputDecoration(
                            labelText: "Responsable Traitement *",
                            contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                            border: OutlineInputBorder(),
                          ),
                          onFind: (String? filter) =>
                              getResponsableTraitement(filter),
                          onChanged: (data) {
                            responsableTraitementId = data?.id_resptrait;
                            responsableTraitementModel = data;
                            //responsableTraitementMatricule = data?.mat;
                            print(
                                'resp traitement: ${data?.nompre}, id: ${responsableTraitementId}');
                          },
                          dropdownBuilder: customDropDownEmploye,
                          popupItemBuilder: customPopupItemBuilderEmploye,
                          validator: (u) =>
                              u == null ? "Responsable is required " : null,
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
                                  groupValue: phaseTraite,
                                  onChanged: (value) {
                                    onChangePhaseTraite(value);
                                  },
                                  activeColor: Colors.blue,
                                  fillColor:
                                      MaterialStateProperty.all(Colors.blue),
                                ),
                                const Text(
                                  "Phase non traitée",
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
                                  groupValue: phaseTraite,
                                  onChanged: (value) {
                                    onChangePhaseTraite(value);
                                  },
                                  activeColor: Colors.blue,
                                  fillColor:
                                      MaterialStateProperty.all(Colors.blue),
                                ),
                                const Text(
                                  "Phase traitée",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                )
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          enabled: false,
                          controller: productController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          validator: (value) =>
                              Validator.validateField(value: value!),
                          decoration: InputDecoration(
                            labelText: 'Product',
                            hintText: 'product',
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
                          controller: quantityDeclasseController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          validator: (value) =>
                              Validator.validateField(value: value!),
                          decoration: InputDecoration(
                            labelText: 'Quantity declassée',
                            hintText: 'Quantity declassée',
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
                        Row(
                          children: [
                            Flexible(
                              fit: FlexFit.loose,
                              child: TextFormField(
                                controller: quantityAccepteController,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                validator: (value) =>
                                    Validator.validateField(value: value!),
                                decoration: InputDecoration(
                                  labelText: 'Quantite acceptée',
                                  hintText: 'Quantite declassée',
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
                              width: 10.0,
                            ),
                            Flexible(
                              fit: FlexFit.tight,
                              child: TextFormField(
                                controller: quantityRejeteController,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                validator: (value) =>
                                    Validator.validateField(value: value!),
                                decoration: InputDecoration(
                                  labelText: 'Quantity rejete',
                                  hintText: 'Quantity rejete',
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
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: TextFormField(
                                controller: valeurDeclasseController,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                validator: (value) =>
                                    Validator.validateField(value: value!),
                                decoration: InputDecoration(
                                  labelText: 'valeur declassée',
                                  hintText: 'valeur declassée',
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
                              width: 10.0,
                            ),
                            Flexible(
                                child: TextFormField(
                              controller: valeurRejeteController,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              validator: (value) =>
                                  Validator.validateField(value: value!),
                              decoration: InputDecoration(
                                labelText: 'valeur rejete',
                                hintText: 'valeur rejete',
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
                            )),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: TextFormField(
                                controller: coutTraitementController,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                validator: (value) =>
                                    Validator.validateField(value: value!),
                                decoration: InputDecoration(
                                  labelText: 'Cout Traitement',
                                  hintText: 'cout traitement',
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
                              width: 10.0,
                            ),
                            Flexible(
                              child: TextFormField(
                                controller: coutTotalController,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                validator: (value) =>
                                    Validator.validateField(value: value!),
                                decoration: InputDecoration(
                                  labelText: 'Cout Total',
                                  hintText: 'cout total',
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
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          controller: depreciationController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'Depriciation',
                            hintText: 'Depriciation',
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
                            suffixIcon: Container(
                              padding: EdgeInsets.all(12.0),
                              child: Text(
                                '%',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                            ),
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
                            controller: dateSaisieController,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            validator: (value) =>
                                Validator.validateField(value: value!),
                            onChanged: (value) {
                              selectedDate(context);
                            },
                            decoration: InputDecoration(
                                labelText: 'Date Saisie Traitement',
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
                        Visibility(
                          visible: true,
                          child: TextFormField(
                            controller: dateTraitementController,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            validator: (value) =>
                                Validator.validateField(value: value!),
                            onChanged: (value) {
                              selectedDate(context);
                            },
                            decoration: InputDecoration(
                                labelText: 'Date Traitement',
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
                        Visibility(
                            visible: true,
                            child: TextFormField(
                              controller: rapportController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText: 'Rapport de traitement',
                                hintText: 'Rapport de traitement',
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
                              validator: (value) =>
                                  Validator.validateField(value: value!),
                              style: TextStyle(fontSize: 14.0),
                              minLines: 2,
                              maxLines: 5,
                            )),
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
                                    'Save',
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

        await pncService
            .getProductsOfPNCTraiter(widget.pncTraiterModel.nnc)
            .then((resp) async {
          resp.forEach((data) async {
            await pncService.remplirPNCTraitement1({
              "nnc": widget.pncTraiterModel.nnc,
              "pdt": data['id_tab_nc_produit'].toString(),
              "valRej": valeur_rejete,
              "ctr": cout_traitement,
              "ctt": cout_total,
              "qteRej": quantity_rejete,
              "mat": matricule.toString(),
              "qteDec": quantity_declasse,
              "depreciation": depreciation,
              "valDec": valeur_declasse,
              "qteAcc": quantity_accepte
            }).then((resp) async {
              //ShowSnackBar.snackBar("Successfully", "PNC validate", Colors.green);
              //Get.to(PNCTraiterPage());
            }, onError: (err) {
              setState(() {
                _isProcessing = false;
              });
              //ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
              print('error : ${err.toString()}');
            });
          });
        }, onError: (err) {
          setState(() {
            _isProcessing = false;
          });
          //ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
          print('error : ${err.toString()}');
        });

        //save pnc traitement
        await pncService.remplirPNCTraitement2({
          "id": responsableTraitementId.toString(),
          "traite": phaseTraite.toString(),
          "date_t": dateTraitementController.text,
          "date_st": dateSaisieController.text,
          "rapport": rapportController.text
        }).then((resp) async {
          ShowSnackBar.snackBar(
              "Successfully",
              "PNC of ${responsableTraitementModel?.nompre} Traitee",
              Colors.green);
          //Get.back();
          Get.to(PNCTraiterPage());
          await ApiControllersCall().getPNCATraiter();
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

  //responsable traitement
  Future<List<ResponsableTraitementModel>> getResponsableTraitement(
      filter) async {
    try {
      List<ResponsableTraitementModel> employeList =
          await List<ResponsableTraitementModel>.empty(growable: true);
      List<ResponsableTraitementModel> employeFilter =
          await List<ResponsableTraitementModel>.empty(growable: true);

      await PNCService()
          .getResponsableTraitementByNNC(widget.pncTraiterModel.nnc)
          .then((resp) async {
        resp.forEach((data) async {
          var model = ResponsableTraitementModel();
          model.id_resptrait = data['id_resptrait'];
          model.id_nc = data['id_nc'];
          model.resptrait = data['resptrait'];
          model.nompre = data['nompre'];
          model.premier_resp = data['premier_resp'];
          model.traite_str = data['traite_str'];
          model.date_trait = data['date_trait'];
          model.rapport_trait = data['rapport_trait'];
          model.premier_resp_int = data['premier_resp_int'];
          employeList.add(model);
        });
      }, onError: (err) {
        ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
      });

      employeFilter = employeList.where((u) {
        var name = u.resptrait.toString().toLowerCase();
        var description = u.nompre!.toLowerCase();
        return name.contains(filter) || description.contains(filter);
      }).toList();
      return employeFilter;
    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }

  Widget customDropDownEmploye(
      BuildContext context, ResponsableTraitementModel? item) {
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
      BuildContext context, ResponsableTraitementModel item, bool isSelected) {
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

  Widget builImagePicker() {
    return imageFileList.length == 0
        ? Container()
        : Container(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            //width: 170,
            height: 170,
            child: Expanded(
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
            )),
          );
  }

  List<Widget> generateImagesTile() {
    return imageFileList
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
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Choose Photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            ConstrainedBox(
              constraints: BoxConstraints.tightFor(
                  width: MediaQuery.of(context).size.width / 1.1, height: 50),
              child: ElevatedButton.icon(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(Color(0xFD18A3A8)),
                  padding: MaterialStateProperty.all(EdgeInsets.all(14)),
                ),
                icon: Icon(Icons.image),
                label: Text(
                  'Camera',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                onPressed: () {
                  if (imageFileList.length >= 5) {
                    AwesomeDialog(
                      context: context,
                      animType: AnimType.SCALE,
                      dialogType: DialogType.ERROR,
                      body: Center(
                        child: Text(
                          "You can choose 5 images maximum",
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      title: 'Cancel',
                      btnOkOnPress: () {
                        Navigator.of(context).pop();
                      },
                    )..show();
                    return;
                  }
                  takePhoto(ImageSource.camera);
                },
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            ConstrainedBox(
              constraints: BoxConstraints.tightFor(
                  width: MediaQuery.of(context).size.width / 1.1, height: 50),
              child: ElevatedButton.icon(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(Color(0xFD147FAA)),
                  padding: MaterialStateProperty.all(EdgeInsets.all(14)),
                ),
                icon: Icon(Icons.image),
                label: Text(
                  'Gallery',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                onPressed: () {
                  if (imageFileList.length >= 5) {
                    AwesomeDialog(
                      context: context,
                      animType: AnimType.SCALE,
                      dialogType: DialogType.ERROR,
                      body: Center(
                        child: Text(
                          "You can choose 5 images maximum",
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      title: 'Cancel',
                      btnOkOnPress: () {
                        Navigator.of(context).pop();
                      },
                    )..show();
                    return;
                  }
                  selectImages();
                },
              ),
            ),
            /* FlatButton.icon(
              icon: Icon(Icons.camera),
              onPressed: () {
                if(imageFileList.length >= 5){
                  AwesomeDialog(
                    context: context,
                    animType: AnimType.SCALE,
                    dialogType: DialogType.ERROR,
                    body: Center(child: Text(
                      "You can choose 5 images maximum",
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),),
                    title: 'Cancel',
                    btnOkOnPress: () {
                      Navigator.of(context).pop();
                    },
                  )..show();
                  return;
                }
                takePhoto(ImageSource.camera);
              },
              label: Text("Camera"),
            ),
            SizedBox(width : 20.0,),
            FlatButton.icon(
              icon: Icon(Icons.image),
              onPressed: () {
                if(imageFileList.length >= 5){
                  AwesomeDialog(
                    context: context,
                    animType: AnimType.SCALE,
                    dialogType: DialogType.ERROR,
                    body: Center(child: Text(
                      "You can choose 5 images maximum",
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),),
                    title: 'Cancel',
                    btnOkOnPress: () {
                      Navigator.of(context).pop();
                    },
                  )..show();
                  return;
                }
                selectImages();
              },
              label: Text("Gallery"),
            ), */
          ])
        ],
      ),
    );
  }

  void selectImages() async {
    try {
      //multi image picker
      final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
      if (selectedImages!.isNotEmpty) {
        imageFileList.addAll(selectedImages);
        //print('images list ${imageFileList}');
        for (var i = 0; i < selectedImages.length; i++) {
          final byteData = await selectedImages[i].readAsBytes();
          base64String = base64Encode(byteData);
          //print('base64String ${base64String}');
          base64List.add(base64String);
          print('list from gallery ${base64List}');
        }
      }
      setState(() {});
      Navigator.of(context).pop();
    } catch (error) {
      debugPrint(error.toString());
      AwesomeDialog(
        context: context,
        animType: AnimType.SCALE,
        dialogType: DialogType.ERROR,
        body: Center(
          child: Text(
            error.toString(),
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        title: 'Error',
        btnCancel: Text('Cancel'),
        btnOkOnPress: () {
          Navigator.of(context).pop();
        },
      )..show();
    }
  }

  takePhoto(ImageSource imageType) async {
    try {
      final photo = await ImagePicker().pickImage(source: imageType);
      if (photo == null) return;
      final tempImage = File(photo.path);
      imageFileList.add(photo);
      setState(() {
        //pickedImage = tempImage;
        base64String = UtilityFile.base64String(tempImage.readAsBytesSync());
        base64List.add(base64String);
        print('list from camera ${base64List}');
      });

      Navigator.of(context).pop();
    } catch (error) {
      debugPrint(error.toString());
      AwesomeDialog(
        context: context,
        animType: AnimType.SCALE,
        dialogType: DialogType.ERROR,
        body: Center(
          child: Text(
            error.toString(),
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        title: 'Error',
        btnCancel: Text('Cancel'),
        btnOkOnPress: () {
          Navigator.of(context).pop();
        },
      )..show();
    }
  }
}
