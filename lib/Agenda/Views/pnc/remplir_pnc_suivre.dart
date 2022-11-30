import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:qualipro_flutter/Agenda/Views/pnc/pnc_suivre_page.dart';
import '../../../Controllers/api_controllers_call.dart';
import '../../../Models/pnc/pnc_suivre_model.dart';
import '../../../Services/pnc/pnc_service.dart';
import '../../../Utils/custom_colors.dart';
import '../../../Utils/shared_preference.dart';
import '../../../Utils/snack_bar.dart';
import '../../../Utils/utility_file.dart';
import '../../../Validators/validator.dart';

class RemplirPNCSuivre extends StatefulWidget {
  PNCSuivreModel pncSuivreModel;

  RemplirPNCSuivre({Key? key, required this.pncSuivreModel}) : super(key: key);

  @override
  State<RemplirPNCSuivre> createState() => _RemplirPNCSuivreState();
}

class _RemplirPNCSuivreState extends State<RemplirPNCSuivre> {
  final _addItemFormKey = GlobalKey<FormState>();
  PNCService pncService = PNCService();
  bool _isProcessing = false;
  final matricule = SharedPreference.getMatricule();
  final nom_prenom = SharedPreference.getNomPrenom();

  DateTime dateTime = DateTime.now();
  TextEditingController nomPrenomController = TextEditingController();
  TextEditingController dateSaisieController = TextEditingController();
  TextEditingController dateClotureController = TextEditingController();
  TextEditingController rapportController = TextEditingController();

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  var cloture = 1;
  onChangeCloture(var value) {
    setState(() {
      cloture = value;
      debugPrint('nc cloture : ${cloture}');
    });
  }

  //image picker
  final ImagePicker imagePicker = ImagePicker();
  List<XFile> imageFileList = [];
  List<String> base64List = [];
  String base64String = '';

  @override
  void initState() {
    nomPrenomController.text = nom_prenom.toString();
    dateSaisieController.text = DateFormat('dd-MM-yyyy').format(dateTime);
    dateClotureController.text = DateFormat('dd-MM-yyyy').format(dateTime);
    super.initState();
  }

  selectedDate(BuildContext context) async {
    var datePicker = await showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime.now());
    if (datePicker != null) {
      setState(() {
        dateTime = datePicker;
        dateClotureController.text =
            DateFormat('dd-MM-yyyy').format(datePicker);
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
          child: Text("P.N.C N° ${widget.pncSuivreModel.nnc}"),
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
                        Column(
                          children: [
                            Row(
                              children: [
                                Radio(
                                  value: 0,
                                  groupValue: cloture,
                                  onChanged: (value) {
                                    onChangeCloture(value);
                                  },
                                  activeColor: Colors.blue,
                                  fillColor:
                                      MaterialStateProperty.all(Colors.blue),
                                ),
                                Text(
                                  "N.C. ${'non_cloture'.tr}",
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
                                  groupValue: cloture,
                                  onChanged: (value) {
                                    onChangeCloture(value);
                                  },
                                  activeColor: Colors.blue,
                                  fillColor:
                                      MaterialStateProperty.all(Colors.blue),
                                ),
                                Text(
                                  "N.C. ${'cloture'.tr}",
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
                          controller: nomPrenomController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          validator: (value) =>
                              Validator.validateField(value: value!),
                          decoration: InputDecoration(
                            labelText: 'resp_cloture'.tr,
                            hintText: 'resp_cloture'.tr,
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
                            controller: dateSaisieController,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            validator: (value) =>
                                Validator.validateField(value: value!),
                            onChanged: (value) {
                              selectedDate(context);
                            },
                            decoration: InputDecoration(
                                labelText:
                                    '${'date_saisie'.tr} ${'of'.tr} ${'closing'.tr}',
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
                          child: InkWell(
                            onTap: (){
                              selectedDate(context);
                            },
                            child: TextFormField(
                              enabled: false,
                              controller: dateClotureController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              validator: (value) =>
                                  Validator.validateField(value: value!),
                              onChanged: (value) {
                                selectedDate(context);
                              },
                              decoration: InputDecoration(
                                  labelText: 'Date ${'closing'.tr}',
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
                                labelText: '${'rapport'.tr} ${'closing'.tr}',
                                hintText: 'rapport'.tr,
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

        await pncService.remplirPNCSuivre({
          "nnc": widget.pncSuivreModel.nnc,
          "cloture": cloture,
          "date_clot": dateClotureController.text,
          "date_saisie_clot": dateSaisieController.text,
          "rapport_cloture": rapportController.text
        }).then((resp) async {
          ShowSnackBar.snackBar("Successfully", "PNC Cloture", Colors.green);
          //Get.back();
          Get.to(PNCSuivrePage());
          await ApiControllersCall().getPNCASuivre();
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
            /*
           FlatButton.icon(
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
