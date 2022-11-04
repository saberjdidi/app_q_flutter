import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:qualipro_flutter/Models/action/action_realisation_model.dart';

import '../../../Controllers/api_controllers_call.dart';
import '../../../Services/action/action_service.dart';
import '../../../Services/action/local_action_service.dart';
import '../../../Utils/custom_colors.dart';
import '../../../Utils/message.dart';
import '../../../Utils/shared_preference.dart';
import '../../../Utils/snack_bar.dart';
import '../../../Utils/utility_file.dart';
import '../../../Validators/validator.dart';
import 'action_realisation_page.dart';

class RemplirActionRealisation extends StatefulWidget {
  ActionRealisationModel actionRealisation;

  RemplirActionRealisation({Key? key, required this.actionRealisation})
      : super(key: key);

  @override
  State<RemplirActionRealisation> createState() =>
      _RemplirActionRealisationState();
}

class _RemplirActionRealisationState extends State<RemplirActionRealisation> {
  final _addItemFormKey = GlobalKey<FormState>();
  bool _isProcessing = false;
  final matricule = SharedPreference.getMatricule();
  ActionService actionService = ActionService();
  DateTime dateTime = DateTime.now();
  DateTime datePickerDebutReal = DateTime.now();
  DateTime datePickerFinReal = DateTime.now();
  TextEditingController actionController = TextEditingController();
  TextEditingController sousActionController = TextEditingController();
  TextEditingController dateSaisieController = TextEditingController();
  TextEditingController dateRealisationController = TextEditingController();
  TextEditingController dateDebutRealisationController =
      TextEditingController();
  TextEditingController dateFinRealisationController = TextEditingController();
  TextEditingController realisationController = TextEditingController();
  TextEditingController depenseController = TextEditingController();
  TextEditingController commentaireController = TextEditingController();

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  int taux_realisation = 0;
  int cout = 0;

  //image picker
  final ImagePicker imagePicker = ImagePicker();
  List<XFile> imageFileList = [];
  List<String> base64List = [];
  String base64String = '';

  String message = "";
  int project_id = 0;
  late bool date_realisation_visible;
  late bool date_debut_realisation_visible;
  late bool date_fin_realisation_visible;

  @override
  void initState() {
    //dateRealisationController.text =widget.actionRealisation.dateReal.toString();
    dateSaisieController.text = DateFormat('yyyy-MM-dd').format(dateTime);
    dateRealisationController.text = DateFormat('yyyy-MM-dd').format(dateTime);
    dateDebutRealisationController.text =
        DateFormat('yyyy-MM-dd').format(datePickerDebutReal);
    dateFinRealisationController.text =
        DateFormat('yyyy-MM-dd').format(datePickerFinReal);
    actionController.text = widget.actionRealisation.act.toString();
    sousActionController.text = widget.actionRealisation.sousAct.toString();
    realisationController.text =
        widget.actionRealisation.pourcentReal.toString();
    depenseController.text = widget.actionRealisation.depense.toString();
    commentaireController.text =
        widget.actionRealisation.commentaire.toString();
    super.initState();
    getIdProjectOfAction();
  }

  Future getIdProjectOfAction() async {
    await actionService
        .getIdProjectOfAction(widget.actionRealisation.nAct)
        .then((resp) async {
      setState(() {
        message = resp['message'];
        project_id = resp['projetId'];
        print('message project id : $message');
        /* if(message == "existe"){
        date_debut_realisation_visible = true;
        date_fin_realisation_visible = true;
        date_realisation_visible = false;
        ShowSnackBar.snackBar("exist", "message exist", Colors.green);
      }
      else {
        date_debut_realisation_visible = false;
        date_fin_realisation_visible = false;
        date_realisation_visible = true;
      } */
      });
    }, onError: (err) {
      ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
    });
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
        dateRealisationController.text =
            DateFormat('yyyy-MM-dd').format(datePicker);
      });
    }
  }

  selectedDateDebutReal(BuildContext context) async {
    datePickerDebutReal = (await showDatePicker(
        context: context,
        initialDate: datePickerDebutReal,
        firstDate: DateTime(2021),
        lastDate: DateTime(2100)
        //lastDate: DateTime.now()
        ))!;
    if (datePickerDebutReal != null) {
      dateDebutRealisationController.text =
          DateFormat('yyyy-MM-dd').format(datePickerDebutReal);
    }
  }

  selectedDateFinReal(BuildContext context) async {
    datePickerFinReal = (await showDatePicker(
        context: context,
        initialDate: datePickerFinReal,
        firstDate: DateTime(2021),
        lastDate: DateTime(2100)
        //firstDate: datePickerDebutReal,
        //lastDate: DateTime.now()
        ))!;
    if (datePickerFinReal != null) {
      dateFinRealisationController.text =
          DateFormat('yyyy-MM-dd').format(datePickerFinReal);
    }
  }

  bool _dataValidation() {
    taux_realisation = int.parse(realisationController.text.toString());
    if (taux_realisation > 100) {
      Message.taskErrorOrWarning(
          "Taux Realisation", "Veuillez saisir donnée inférieur ou égal à 100");
      return false;
    } else if (datePickerFinReal.isBefore(datePickerDebutReal)) {
      AwesomeDialog(
        context: context,
        animType: AnimType.SCALE,
        dialogType: DialogType.ERROR,
        body: Center(
          child: Text(
            'Date Fin doit être supérieur au Date Debut',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        title: 'Error',
        btnOkOnPress: () {
          //Navigator.of(context).pop();
        },
      )..show();
      _isProcessing = false;
      return false;
    }
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
          child: Text("Action N° ${widget.actionRealisation.nAct}"),
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
                          controller: actionController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          validator: (value) =>
                              Validator.validateField(value: value!),
                          decoration: InputDecoration(
                            labelText: 'Action',
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
                        TextFormField(
                          enabled: false,
                          controller: sousActionController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          validator: (value) =>
                              Validator.validateField(value: value!),
                          decoration: InputDecoration(
                            labelText: 'Sous Action',
                            hintText: 'sous action',
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
                          controller: realisationController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'Taux Realisation',
                            hintText: 'realisation',
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
                        TextFormField(
                          controller: depenseController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'Cout',
                            hintText: 'cout',
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
                                labelText: 'Date Saisie',
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
                          visible: message == "Objet n'existe pas"
                              ? date_realisation_visible = true
                              : date_realisation_visible = false,
                          child: TextFormField(
                            controller: dateRealisationController,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            validator: (value) =>
                                Validator.validateField(value: value!),
                            onChanged: (value) {
                              selectedDate(context);
                            },
                            decoration: InputDecoration(
                                labelText: 'Date realisation',
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
                        Visibility(
                          visible: message == "existe"
                              ? date_debut_realisation_visible = true
                              : date_debut_realisation_visible = false,
                          child: TextFormField(
                            controller: dateDebutRealisationController,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            validator: (value) =>
                                Validator.validateField(value: value!),
                            onChanged: (value) {
                              selectedDateDebutReal(context);
                            },
                            decoration: InputDecoration(
                                labelText: 'Date Debut realisation',
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
                                    selectedDateDebutReal(context);
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
                          visible: message == "existe"
                              ? date_fin_realisation_visible = true
                              : date_fin_realisation_visible = false,
                          child: TextFormField(
                            controller: dateFinRealisationController,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            validator: (value) =>
                                Validator.validateField(value: value!),
                            onChanged: (value) {
                              selectedDateFinReal(context);
                            },
                            decoration: InputDecoration(
                                labelText: 'Date Fin realisation',
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
                                    selectedDateFinReal(context);
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
                              controller: commentaireController,
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
                          height: 10.0,
                        ),
                        MaterialButton(
                            color: Colors.blue,
                            child: const Text("Upload Images",
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
        taux_realisation = int.parse(realisationController.text.toString());
        cout = int.parse(depenseController.text.toString());

        if (message == "existe") {
          print('message : $message');
          await actionService.saveActionRealisationOfProject({
            "nAct": widget.actionRealisation.nAct,
            "nSousAct": widget.actionRealisation.nSousAct,
            "pourcentReal": taux_realisation,
            "depense": cout,
            "commentaire": commentaireController.text,
            "dateSaisieRealisation": dateSaisieController.text,
            "dateDebut": dateDebutRealisationController.text,
            "dateFin": dateFinRealisationController.text
          }).then((resp) async {
            ShowSnackBar.snackBar(
                "Action Realisation", "Action added", Colors.green);
            //Get.back();
            Get.to(ActionRealisationPage());
            //await ApiControllersCall().getActionsRealisation();
          }, onError: (err) {
            _isProcessing = false;
            ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
          });
        } else {
          print('message : $message');
          await actionService.saveActionRealisation({
            "nAct": widget.actionRealisation.nAct,
            "nSousAct": widget.actionRealisation.nSousAct,
            "pourcentReal": taux_realisation,
            "depense": cout,
            "commentaire": commentaireController.text,
            "dateReal": dateRealisationController.text,
            "dateSaisieRealisation": dateSaisieController.text
          }).then((resp) async {
            ShowSnackBar.snackBar(
                "Action Realisation", "Action added", Colors.green);
            Get.to(ActionRealisationPage());
          }, onError: (err) {
            _isProcessing = false;
            ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
          });
        }
        //2d method
        /*  await actionService.saveActionRealisation2(commentaireController.text, taux_realisation, cout, widget.actionRealisation.nSousAct, widget.actionRealisation.nAct).then((resp) async {
          ShowSnackBar.snackBar("Action Realisation", "Action added", Colors.green);
          //Get.back();
          Get.to(ActionRealisationPage());

        }, onError: (err) {
          _isProcessing = false;
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });*/

        //upload images
        base64List.forEach((element) async {
          //print('base64 image: ${element}');
          await actionService.uploadImageSousAction({
            "nact": widget.actionRealisation.nAct.toString(),
            "nsousact": widget.actionRealisation.nSousAct.toString(),
            "base64photo": element.toString(),
            "nomp": "",
            "objp": "",
            "mat": matricule.toString()
          }).then((resp) async {
            //ShowSnackBar.snackBar("Action Successfully", "images uploaded", Colors.green);
            //Get.to(ActionRealisationPage());
          }, onError: (err) {
            _isProcessing = false;
            ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
          });
        });

        await ApiControllersCall().getActionsRealisation();
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

  Widget builImagePicker() {
    return imageFileList.length == 0
        ? Container()
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
                  width: MediaQuery.of(context).size.width / 3, height: 50),
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
                  width: MediaQuery.of(context).size.width / 3, height: 50),
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
              label: Text("Camera"),
            ),
            SizedBox(
              width: 20.0,
            ),
            FlatButton.icon(
              icon: Icon(Icons.image),
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
