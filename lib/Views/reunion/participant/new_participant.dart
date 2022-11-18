import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualipro_flutter/Models/employe_model.dart';
import 'package:qualipro_flutter/Services/reunion/reunion_service.dart';
import 'package:qualipro_flutter/Views/reunion/participant/participant_page.dart';
import '../../../../Utils/custom_colors.dart';
import '../../../../Utils/shared_preference.dart';
import '../../../../Utils/snack_bar.dart';
import '../../../Controllers/api_controllers_call.dart';
import '../../../Models/reunion/participant_reunion_model.dart';
import '../../../Services/reunion/local_reunion_service.dart';
import '../../../Validators/validator.dart';

class NewParticipant extends StatefulWidget {
  final nReunion;

  const NewParticipant({Key? key, required this.nReunion}) : super(key: key);

  @override
  State<NewParticipant> createState() => _NewParticipantState();
}

class _NewParticipantState extends State<NewParticipant> {
  final _addItemFormKey = GlobalKey<FormState>();
  final _addItemFormKey2 = GlobalKey<FormState>();
  bool _isProcessing = false;
  final matricule = SharedPreference.getMatricule();

  TextEditingController nReunionController = TextEditingController();
  TextEditingController nomPrenomController = TextEditingController();
  TextEditingController mailController = TextEditingController();

  String? selectMatEmploye = "";
  String? selectNompreEmploye = "";
  EmployeModel? employeModel = null;
  bool isVisibleEmployeExterne = true;

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    nReunionController.text = widget.nReunion.toString();
    super.initState();
    checkConnectivity();
  }

  Future<void> checkConnectivity() async {
    var connection = await Connectivity().checkConnectivity();
    if (connection == ConnectivityResult.none) {
      setState(() {
        isVisibleEmployeExterne = false;
      });
    } else if (connection == ConnectivityResult.mobile ||
        connection == ConnectivityResult.wifi) {
      setState(() {
        isVisibleEmployeExterne = true;
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
        title: Text(
          "${'new'.tr} Participant",
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Card(
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
                              controller: nReunionController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              validator: (value) =>
                                  Validator.validateField(value: value!),
                              decoration: InputDecoration(
                                  labelText: '${'reunion'.tr} N°',
                                  hintText: 'numero',
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
                                          Radius.circular(10)))),
                              style: TextStyle(fontSize: 14.0),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Visibility(
                                visible: true,
                                child: DropdownSearch<EmployeModel>(
                                  showSelectedItems: true,
                                  showClearButton: true,
                                  showSearchBox: true,
                                  isFilteredOnline: true,
                                  compareFn: (i, s) => i?.isEqual(s) ?? false,
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText: "Employe *",
                                    contentPadding:
                                        EdgeInsets.fromLTRB(12, 12, 0, 0),
                                    border: OutlineInputBorder(),
                                  ),
                                  onFind: (String? filter) =>
                                      getEmploye(filter),
                                  onChanged: (data) {
                                    employeModel = data;
                                    selectMatEmploye = data?.mat;
                                    selectNompreEmploye = data?.nompre;
                                    debugPrint(
                                        'employe: ${selectNompreEmploye}, code: ${selectMatEmploye}');
                                  },
                                  dropdownBuilder: _customDropDownEmploye,
                                  popupItemBuilder:
                                      _customPopupItemBuilderEmploye,
                                  validator: (u) => u == null
                                      ? "Employe ${'is_required'.tr}"
                                      : null,
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
                                      saveParticipant();
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        CustomColors.googleBackground,
                                      ),
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
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
              SizedBox(
                height: 20,
              ),
              Visibility(
                visible: isVisibleEmployeExterne,
                child: Card(
                  child: Form(
                      key: _addItemFormKey2,
                      child: Padding(
                          padding: EdgeInsets.all(25.0),
                          child: Column(
                            children: <Widget>[
                              Center(
                                child: Text(
                                  '${'new'.tr} ${'invite'.tr}',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF0B0EA3)),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                enabled: true,
                                controller: nomPrenomController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                validator: (value) =>
                                    Validator.validateField(value: value!),
                                decoration: InputDecoration(
                                    labelText: 'nom_prenom'.tr,
                                    hintText: 'nom_prenom'.tr,
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
                                            Radius.circular(10)))),
                                style: TextStyle(fontSize: 14.0),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              TextFormField(
                                enabled: true,
                                controller: mailController,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                validator: (value) =>
                                    Validator.validateField(value: value!),
                                decoration: InputDecoration(
                                    labelText: 'Email',
                                    hintText: 'email',
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
                                            Radius.circular(10)))),
                                style: TextStyle(fontSize: 14.0),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              _isProcessing
                                  ? Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          CustomColors.firebaseOrange,
                                        ),
                                      ),
                                    )
                                  : ElevatedButton(
                                      onPressed: () async {
                                        saveParticipantExterne();
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                          CustomColors.googleBackground,
                                        ),
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
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
              )
            ],
          ),
        ),
      )),
    );
  }

  Future saveParticipant() async {
    if (_addItemFormKey.currentState!.validate()) {
      try {
        var connection = await Connectivity().checkConnectivity();
        if (connection == ConnectivityResult.none) {
          var model = ParticipantReunionModel();
          model.online = 0;
          model.nompre = selectNompreEmploye;
          model.mat = selectMatEmploye;
          model.aparticipe = 0;
          model.comment = "";
          model.confirm = 0;
          model.nReunion = widget.nReunion;
          await LocalReunionService().saveParticipantReunion(model);
          Get.to(ParticipantPage(
            nReunion: widget.nReunion,
          ));
          ShowSnackBar.snackBar(
              "Successfully", "Participant added in db local", Colors.green);
        } else if (connection == ConnectivityResult.wifi ||
            connection == ConnectivityResult.mobile) {
          await ReunionService().addParticipant({
            "numReunion": widget.nReunion,
            "matParticipant": selectMatEmploye
          }).then((resp) async {
            ShowSnackBar.snackBar(
                "Successfully", "Participant added", Colors.green);
            await ApiControllersCall().getParticipantsReunion();
            //Get.back();
            Get.to(ParticipantPage(
              nReunion: widget.nReunion,
            ));
          }, onError: (err) {
            setState(() {
              _isProcessing = false;
            });
            ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
          });
        }
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

  Future saveParticipantExterne() async {
    if (_addItemFormKey2.currentState!.validate()) {
      try {
        setState(() {
          _isProcessing = true;
        });
        await ReunionService().addParticipantExterne({
          "numReunion": widget.nReunion,
          "employeNom": nomPrenomController.text,
          "mail": mailController.text
        }).then((resp) async {
          ShowSnackBar.snackBar(
              "Successfully", "Participant Externe added", Colors.green);
          //Get.back();
          Get.to(ParticipantPage(
            nReunion: widget.nReunion,
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

  //employe
  Future<List<EmployeModel>> getEmploye(filter) async {
    try {
      List<EmployeModel> employeList =
          await List<EmployeModel>.empty(growable: true);
      List<EmployeModel> employeFilter =
          await List<EmployeModel>.empty(growable: true);
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        var response = await LocalReunionService()
            .readEmployeParticipantReunion(widget.nReunion);
        response.forEach((data) {
          var model = EmployeModel();
          model.mat = data['mat'];
          model.nompre = data['nompre'];
          employeList.add(model);
        });
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        await ReunionService()
            .getParticipantsARattacher(widget.nReunion, 300)
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

  Widget _customDropDownEmploye(BuildContext context, EmployeModel? item) {
    if (item == null) {
      return Container();
    } else {
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${item.nompre}'),
          //subtitle: Text('${item?.codetypecause.toString()}'),
        ),
      );
    }
  }

  Widget _customPopupItemBuilderEmploye(
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
        //subtitle: Text(item.codetypecause.toString() ?? ''),
      ),
    );
  }
}
