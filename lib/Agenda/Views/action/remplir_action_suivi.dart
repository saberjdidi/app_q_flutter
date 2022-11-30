import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:qualipro_flutter/Agenda/Views/action/action_suivi_page.dart';
import '../../../Controllers/api_controllers_call.dart';
import '../../../Models/action/action_suivi_model.dart';
import '../../../Models/image_model.dart';
import '../../../Services/action/action_service.dart';
import '../../../Utils/custom_colors.dart';
import '../../../Utils/message.dart';
import '../../../Utils/shared_preference.dart';
import '../../../Utils/snack_bar.dart';
import '../../../Utils/utility_file.dart';
import '../../../Validators/validator.dart';
import 'update_taux_realisation.dart';
import 'package:path/path.dart' as mypath;

class RemplirActionSuivi extends StatefulWidget {
  ActionSuiviModel actionsuivi;

  RemplirActionSuivi({Key? key, required this.actionsuivi}) : super(key: key);

  @override
  State<RemplirActionSuivi> createState() => _RemplirActionSuiviState();
}

class _RemplirActionSuiviState extends State<RemplirActionSuivi> {
  final _addItemFormKey = GlobalKey<FormState>();
  bool _isProcessing = false;
  final matricule = SharedPreference.getMatricule();

  ActionService actionService = ActionService();
  DateTime dateTime = DateTime.now();
  TextEditingController actionController = TextEditingController();
  TextEditingController sousActionController = TextEditingController();
  TextEditingController dateSuiviController = TextEditingController();
  TextEditingController pourcentSuivieController = TextEditingController();
  TextEditingController pourcentRealController = TextEditingController();
  TextEditingController rapportEffController = TextEditingController();

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  int taux_suivi = 0;

  //image picker
  final ImagePicker imagePicker = ImagePicker();
  List<XFile> imageFileList = [];
  List<ImageModel> base64List = [];
  //String base64String = '';
  //random data
  var _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  @override
  void initState() {
    //dateSuiviController.text =widget.actionRealisation.dateReal.toString();
    dateSuiviController.text = DateFormat('yyyy-MM-dd').format(dateTime);
    actionController.text = widget.actionsuivi.act.toString();
    sousActionController.text = widget.actionsuivi.sousAct.toString();
    pourcentSuivieController.text =
        widget.actionsuivi.pourcentSuivie.toString();
    pourcentRealController.text = widget.actionsuivi.pourcentReal.toString();
    rapportEffController.text = widget.actionsuivi.rapportEff.toString();
    super.initState();
  }

  selectedDate(BuildContext context) async {
    var datePicker = await showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2025));
    if (datePicker != null) {
      setState(() {
        dateTime = datePicker;
        dateSuiviController.text = DateFormat('yyyy-MM-dd').format(datePicker);
      });
    }
  }

  bool _dataValidation() {
    taux_suivi = int.parse(pourcentSuivieController.text.toString());

    if (widget.actionsuivi.pourcentReal! == 0) {
      //if (widget.actionsuivi.pourcentReal! < 100) {
      Message.taskErrorOrWarning(
          'warning'.tr, "taux realisation doit etre egal 100");
      AwesomeDialog(
          context: context,
          animType: AnimType.SCALE,
          dialogType: DialogType.ERROR,
          body: Center(
            child: Text(
              'voulez_modifier_taux_realisation'.tr,
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          title: 'taux_realisation'.tr,
          btnCancel: TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.red),
            ),
          ),
          btnOkOnPress: () {
            //Navigator.of(context).pop();
            Get.to(UpdateTauxRealisation(actionsuivi: widget.actionsuivi));
          }).show();
      return false;
    } else if (rapportEffController.text.trim() == '') {
      Message.taskErrorOrWarning(
          'warning'.tr, "${'rapport'.tr} eff ${'is_required'.tr}");
      return false;
    } else if (taux_suivi > 100) {
      Message.taskErrorOrWarning(
          'warning'.tr, 'saisir_donne_inferieur_ou_égal_100'.tr);
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
        title: Text(
          "Action N° ${widget.actionsuivi.nAct}",
          textAlign: TextAlign.center,
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
                          enabled: false,
                          controller: pourcentRealController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'taux_realisation'.tr,
                            hintText: 'taux_realisation'.tr,
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
                          controller: pourcentSuivieController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'taux_efficacite'.tr,
                            hintText: 'taux_efficacite'.tr,
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
                        InkWell(
                          onTap: () {
                            selectedDate(context);
                          },
                          child: TextFormField(
                            enabled: false,
                            controller: dateSuiviController,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            validator: (value) =>
                                Validator.validateField(value: value!),
                            onChanged: (value) {
                              selectedDate(context);
                            },
                            decoration: InputDecoration(
                                labelText: 'Date ${'suivi'.tr}',
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
                              controller: rapportEffController,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText: '${'rapport'.tr} Eff *',
                                hintText: '${'rapport'.tr} eff',
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
                              maxLines: 5,
                              minLines: 2,
                            )),
                        SizedBox(
                          height: 10.0,
                        ),
                        MaterialButton(
                            color: Colors.blue,
                            child: Text("${'upload'.tr} Images",
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
                        /*  Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Swiper(
                                    itemCount: imageFileList.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Image.file(File(imageFileList[index].path), fit: BoxFit.cover);
                                    },
                                    //pagination: new SwiperPagination(),
                                    //control: new SwiperControl(),
                                    itemHeight: 500.0,
                                  ),
                                )
                            ), */
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
            /*  FlatButton.icon(
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
          debugPrint('byte image from gallery :$byteData');
          setState(() {
            var modelImage = ImageModel();
            modelImage.image = base64Encode(byteData);
            modelImage.fileName =
                '${getRandomString(5)}_($matricule)_${selectedImages[i].name}';
            base64List.add(modelImage);
            debugPrint('list from gallery ${base64List}');
          });
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
        // base64String = UtilityFile.base64String(tempImage.readAsBytesSync());
        var modelImage = ImageModel();
        modelImage.image =
            UtilityFile.base64String(tempImage.readAsBytesSync());
        modelImage.fileName =
            '${getRandomString(5)}_($matricule)_${mypath.basename(tempImage.path)}';
        base64List.add(modelImage);
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

  Future saveBtn() async {
    if (_dataValidation() && _addItemFormKey.currentState!.validate()) {
      try {
        setState(() {
          _isProcessing = true;
        });
        taux_suivi = int.parse(pourcentSuivieController.text.toString());

        await actionService.saveActionSuivi({
          "nAct": widget.actionsuivi.nAct,
          "nSousAct": widget.actionsuivi.nSousAct,
          "pourcentSuivie": pourcentSuivieController.text.toString(),
          "mat": matricule.toString(),
          "rapportEff": rapportEffController.text.trim(),
          "dateSuivie": dateSuiviController.text
        }).then((resp) async {
          ShowSnackBar.snackBar(
              "Action Successfully", "Action suivi updated", Colors.green);
          //Get.back();
          Get.to(ActionSuiviPage());
          await ApiControllersCall().getActionsSuivi();
        }, onError: (err) {
          _isProcessing = false;
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });

        //upload images
        base64List.forEach((element) async {
          //print('base64 image: ${element}');
          await actionService.uploadImageSousAction({
            "nact": widget.actionsuivi.nAct.toString(),
            "nsousact": widget.actionsuivi.nSousAct.toString(),
            "base64photo": element.image.toString(),
            "nomp": "",
            "objp": element.fileName.toString(),
            "mat": matricule.toString()
          }).then((resp) async {
            //ShowSnackBar.snackBar("Action Successfully", "images uploaded", Colors.green);
            //Get.back();
            Get.to(ActionSuiviPage());
          }, onError: (err) {
            _isProcessing = false;
            ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
          });
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
}
