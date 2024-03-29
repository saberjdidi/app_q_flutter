import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualipro_flutter/Models/incident_environnement/type_consequence_incident_model.dart';
import 'package:qualipro_flutter/Services/incident_environnement/incident_environnement_service.dart';
import 'package:qualipro_flutter/Views/incident_environnement/type_consequence/type_consequence_incident_env_page.dart';
import '../../../../Utils/custom_colors.dart';
import '../../../../Utils/shared_preference.dart';
import '../../../../Utils/snack_bar.dart';
import '../../../Services/incident_environnement/local_incident_environnement_service.dart';
import '../../../Validators/validator.dart';

class NewTypeConsequenceIncidentEnv extends StatefulWidget {
  final numIncident;

  const NewTypeConsequenceIncidentEnv({Key? key, required this.numIncident})
      : super(key: key);

  @override
  State<NewTypeConsequenceIncidentEnv> createState() =>
      _NewTypeConsequenceIncidentEnvState();
}

class _NewTypeConsequenceIncidentEnvState
    extends State<NewTypeConsequenceIncidentEnv> {
  final _addItemFormKey = GlobalKey<FormState>();
  bool _isProcessing = false;
  final matricule = SharedPreference.getMatricule();

  TextEditingController ncController = TextEditingController();

  int? selectedTypeCode = 0;
  String? typeConseq = "";
  TypeConsequenceIncidentModel? typeConsequenceModel = null;

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
        title: Text(
          "${'new'.tr} Type Consequence",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16.0),
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
                            child: DropdownSearch<TypeConsequenceIncidentModel>(
                              showSelectedItems: true,
                              showClearButton: true,
                              showSearchBox: true,
                              isFilteredOnline: true,
                              compareFn: (i, s) => i?.isEqual(s) ?? false,
                              dropdownSearchDecoration: InputDecoration(
                                labelText: "Type Consequence *",
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
                                        '${'list'.tr} Type Consequences',
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
                              onFind: (String? filter) =>
                                  getTypeConsequence(filter),
                              onChanged: (data) {
                                typeConsequenceModel = data;
                                selectedTypeCode = data?.idConsequence;
                                typeConseq = data?.typeConsequence;
                                debugPrint(
                                    'type consequence: $typeConseq, code: ${selectedTypeCode}');
                              },
                              dropdownBuilder: _customDropDownTypeConsequence,
                              popupItemBuilder:
                                  _customPopupItemBuilderTypeConsequence,
                              validator: (u) => u == null
                                  ? "Type consequence ${'is_required'.tr} "
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
          int max_num = await LocalIncidentEnvironnementService()
              .getMaxNumTypeConsequenceIncidentEnvironnementRattacher();
          int? id_inc_conseq = max_num + 1;
          var model = TypeConsequenceIncidentModel();
          model.online = 0;
          model.idIncidentConseq = id_inc_conseq;
          model.idIncident = widget.numIncident;
          model.idConsequence = selectedTypeCode;
          model.typeConsequence = typeConseq;
          //save data
          await LocalIncidentEnvironnementService()
              .saveTypeConsequenceRattacherIncidentEnv(model);
          Get.to(TypeConsequenceIncidentEnvPage(
            numIncident: widget.numIncident,
          ));
        } else if (connection == ConnectivityResult.wifi ||
            connection == ConnectivityResult.mobile) {
          await IncidentEnvironnementService().saveTypeConseqenceByIncident({
            "idIncident": widget.numIncident,
            "idConsequence": selectedTypeCode
          }).then((resp) async {
            ShowSnackBar.snackBar(
                "Successfully", "Type Consequence added", Colors.green);
            //Get.back();
            Get.to(TypeConsequenceIncidentEnvPage(
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

  //type consequence
  Future<List<TypeConsequenceIncidentModel>> getTypeConsequence(filter) async {
    try {
      List<TypeConsequenceIncidentModel> _typeList =
          await List<TypeConsequenceIncidentModel>.empty(growable: true);
      List<TypeConsequenceIncidentModel> _typeFilter =
          await List<TypeConsequenceIncidentModel>.empty(growable: true);
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        var response = await LocalIncidentEnvironnementService()
            .readTypeConsequenceIncidentEnvARattacher(widget.numIncident);
        response.forEach((data) {
          var model = TypeConsequenceIncidentModel();
          model.idConsequence = data['idTypeConseq'];
          model.typeConsequence = data['typeConseq'];
          _typeList.add(model);
        });
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        await IncidentEnvironnementService()
            .getTypeConsequenceByIncidentARattacher(
                widget.numIncident, matricule)
            .then((resp) async {
          resp.forEach((data) async {
            var model = TypeConsequenceIncidentModel();
            model.idConsequence = data['id_conseq'];
            model.typeConsequence = data['consequence'];
            _typeList.add(model);
          });
        }, onError: (err) {
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
      }
      _typeFilter = _typeList.where((u) {
        var query = u.typeConsequence!.toLowerCase();
        return query.contains(filter);
      }).toList();
      return _typeFilter;
    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }

  Widget _customDropDownTypeConsequence(
      BuildContext context, TypeConsequenceIncidentModel? item) {
    if (item == null) {
      return Container();
    } else {
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${item.typeConsequence}'),
          //subtitle: Text('${item?.codetypecause.toString()}'),
        ),
      );
    }
  }

  Widget _customPopupItemBuilderTypeConsequence(BuildContext context,
      TypeConsequenceIncidentModel item, bool isSelected) {
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
        title: Text(item.typeConsequence ?? ''),
        //subtitle: Text(item.codetypecause.toString() ?? ''),
      ),
    );
  }
}
