import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualipro_flutter/Services/incident_environnement/incident_environnement_service.dart';
import 'package:qualipro_flutter/Views/incident_environnement/type_cause/type_cause_incident_env_page.dart';
import '../../../../Utils/custom_colors.dart';
import '../../../../Utils/shared_preference.dart';
import '../../../../Utils/snack_bar.dart';
import '../../../Models/incident_environnement/type_cause_incident_model.dart';
import '../../../Models/type_cause_model.dart';
import '../../../Services/incident_environnement/local_incident_environnement_service.dart';
import '../../../Validators/validator.dart';

class NewTypeCauseIncidentEnv extends StatefulWidget {
  final numIncident;

  const NewTypeCauseIncidentEnv({Key? key, required this.numIncident})
      : super(key: key);

  @override
  State<NewTypeCauseIncidentEnv> createState() =>
      _NewTypeCauseIncidentEnvState();
}

class _NewTypeCauseIncidentEnvState extends State<NewTypeCauseIncidentEnv> {
  final _addItemFormKey = GlobalKey<FormState>();
  bool _isProcessing = false;
  final matricule = SharedPreference.getMatricule();

  TextEditingController ncController = TextEditingController();

  int? selectedTypeCode = 0;
  String? typeCause = '';
  TypeCauseModel? typeCauseModel = null;

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    ncController.text = widget.numIncident.toString();
    super.initState();
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
        title: Text("${'new'.tr} Type Cause",
            textAlign: TextAlign.center, style: TextStyle(fontSize: 15.0)),
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
                          controller: ncController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          validator: (value) =>
                              Validator.validateField(value: value!),
                          decoration: InputDecoration(
                              labelText: 'Incident N°',
                              hintText: 'incident',
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
                                      BorderRadius.all(Radius.circular(10)))),
                          style: TextStyle(fontSize: 14.0),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Visibility(
                            visible: true,
                            child: DropdownSearch<TypeCauseModel>(
                              showSelectedItems: true,
                              showClearButton: true,
                              showSearchBox: true,
                              isFilteredOnline: true,
                              compareFn: (i, s) => i?.isEqual(s) ?? false,
                              dropdownSearchDecoration: InputDecoration(
                                labelText: "Type Cause *",
                                contentPadding:
                                    EdgeInsets.fromLTRB(12, 12, 0, 0),
                                border: OutlineInputBorder(),
                              ),
                              popupTitle: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        '${'list'.tr} Types Causes',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        icon: Icon(
                                          Icons.close,
                                          color: Colors.red,
                                        ))
                                  ],
                                ),
                              ),
                              onFind: (String? filter) => getTypesCause(filter),
                              onChanged: (data) {
                                typeCauseModel = data;
                                selectedTypeCode = data?.idTypeCause;
                                typeCause = data?.typecause;
                                debugPrint(
                                    'type cause: $typeCause, code: ${selectedTypeCode}');
                              },
                              dropdownBuilder: _customDropDownTypeCause,
                              popupItemBuilder:
                                  _customPopupItemBuilderTypeCause,
                              validator: (u) => u == null
                                  ? "Type cause ${'is_required'.tr}"
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
        var connection = await Connectivity().checkConnectivity();
        if (connection == ConnectivityResult.none) {
          int max_id_inc_env = await LocalIncidentEnvironnementService()
              .getMaxNumTypeCauseIncidentEnvironnementRattacher();
          int? id_incident_cause = max_id_inc_env + 1;
          var model = TypeCauseIncidentModel();
          model.online = 0;
          model.idIncidentCause = id_incident_cause;
          model.idIncident = widget.numIncident;
          model.idTypeCause = selectedTypeCode;
          model.typeCause = typeCause;
          //save data
          await LocalIncidentEnvironnementService()
              .saveTypeCauseRattacherIncidentEnv(model);
          Get.to(TypeCauseIncidentEnvPage(numIncident: widget.numIncident));
        } else if (connection == ConnectivityResult.wifi ||
            connection == ConnectivityResult.mobile) {
          await IncidentEnvironnementService().saveTypeCauseByIncident({
            "idIncident": widget.numIncident,
            "idCause": selectedTypeCode
          }).then((resp) async {
            ShowSnackBar.snackBar(
                "Successfully", "Type Cause added", Colors.green);
            //Get.back();
            Get.to(TypeCauseIncidentEnvPage(
              numIncident: widget.numIncident,
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

  //types cause
  Future<List<TypeCauseModel>> getTypesCause(filter) async {
    try {
      List<TypeCauseModel> _typeList =
          await List<TypeCauseModel>.empty(growable: true);
      List<TypeCauseModel> _typeFilter =
          await List<TypeCauseModel>.empty(growable: true);
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        var response = await LocalIncidentEnvironnementService()
            .readTypeCauseIncidentEnvARattacher(widget.numIncident);
        response.forEach((data) {
          var model = TypeCauseModel();
          model.idTypeCause = data['idTypeCause'];
          model.typecause = data['typeCause'];
          _typeList.add(model);
        });
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        await IncidentEnvironnementService()
            .getTypeCauseOfIncidentARattacher(widget.numIncident, matricule, 1)
            .then((resp) async {
          resp.forEach((data) async {
            var model = TypeCauseModel();
            model.idTypeCause = data['id_type_cause'];
            model.typecause = data['type_cause'];
            _typeList.add(model);
          });
        }, onError: (err) {
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
      }
      _typeFilter = _typeList.where((u) {
        var query = u.typecause!.toLowerCase();
        return query.contains(filter);
      }).toList();
      return _typeFilter;
    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }

  Widget _customDropDownTypeCause(BuildContext context, TypeCauseModel? item) {
    if (item == null) {
      return Container();
    } else {
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${item.typecause}'),
          //subtitle: Text('${item?.codetypecause.toString()}'),
        ),
      );
    }
  }

  Widget _customPopupItemBuilderTypeCause(
      BuildContext context, TypeCauseModel item, bool isSelected) {
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
        title: Text(item.typecause ?? ''),
        //subtitle: Text(item.codetypecause.toString() ?? ''),
      ),
    );
  }
}
