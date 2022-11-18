import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as mypath;

import '../../../Controllers/api_controllers_call.dart';
import '../../../Models/employe_model.dart';
import '../../../Models/pnc/responsable_traitement_model.dart';
import '../../../Models/pnc/traitement_decision_model.dart';
import '../../../Models/pnc/type_traitement_model.dart';
import '../../../Services/action/local_action_service.dart';
import '../../../Services/pnc/pnc_service.dart';
import '../../../Utils/custom_colors.dart';
import '../../../Utils/message.dart';
import '../../../Utils/shared_preference.dart';
import '../../../Utils/snack_bar.dart';
import '../../../Validators/validator.dart';
import 'pnc_decision_traitement_page.dart';
import 'remplir_pnc_investigation_a_effectuer.dart';
import 'responsable_traitement/new_responsable_traitement.dart';

class RemplirPNCTraitementDecision extends StatefulWidget {
  TraitementDecisionModel traitementDecisionModel;

  RemplirPNCTraitementDecision(
      {Key? key, required this.traitementDecisionModel})
      : super(key: key);

  @override
  State<RemplirPNCTraitementDecision> createState() =>
      _RemplirPNCTraitementDecisionState();
}

class _RemplirPNCTraitementDecisionState
    extends State<RemplirPNCTraitementDecision> {
  final _addItemFormKey = GlobalKey<FormState>();
  final _addItemFormKeyResponsableTraitement = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  PNCService pncService = PNCService();
  bool _isProcessing = false;
  final matricule = SharedPreference.getMatricule();

  DateTime dateTime = DateTime.now();
  TextEditingController dateSaisieDecisionController = TextEditingController();
  TextEditingController causeNCController = TextEditingController();

  EmployeModel? responsableSuiviModel = null;
  String? responsableSuiviMatricule = "";
  int? selectCodeTypeTraitement = 0;

  bool checkWithInvestigation = false;
  int withInvestigation = 0;

  //resp traitement
  final _contentStyleHeader = const TextStyle(
      color: Color(0xff060f7d), fontSize: 14, fontWeight: FontWeight.w700);
  final _contentStyle = const TextStyle(
      color: Color(0xff0c2d5e), fontSize: 14, fontWeight: FontWeight.normal);

  List<ResponsableTraitementModel> respTraitementList =
      List<ResponsableTraitementModel>.empty(growable: true);
  void getResponsableTraitement() async {
    try {
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        Get.snackbar("No Connection", "Mode Offline",
            colorText: Colors.blue,
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(milliseconds: 900));
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.BOTTOM, duration: Duration(milliseconds: 900));
        //rest api
        //getResponsableTraitementByNNC(153)
        await PNCService()
            .getResponsableTraitementByNNC(widget.traitementDecisionModel.nnc)
            .then((resp) async {
          //isDataProcessing(false);
          resp.forEach((data) async {
            setState(() {
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
              respTraitementList.add(model);

              respTraitementList.forEach((element) {
                print(
                    'element resp traitement ${element.nompre}, resptrait : ${element.resptrait}');
              });
            });
          });
        }, onError: (err) {
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
      }
    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      //isDataProcessing(false);
    }
  }

  bool _dataValidation() {
    if (respTraitementList.isEmpty || respTraitementList == []) {
      Message.taskErrorOrWarning(
          "Alert", "Veuillez Ajouter au moins responsable de traitement");
      return false;
    } else if (responsableSuiviModel == null) {
      Message.taskErrorOrWarning("Alert", "Responsable Suivi is required");
      return false;
    }
    return true;
  }

  @override
  void initState() {
    dateSaisieDecisionController.text =
        DateFormat('yyyy-MM-dd').format(dateTime);
    super.initState();
    getResponsableTraitement();
    print('list resp : $respTraitementList');
    //add reponsable traitement
    dateTraitementController.text = DateFormat('yyyy-MM-dd').format(dateTime);
    if (SharedPreference.getLangue() == null) {
      language = "";
    } else {
      language = SharedPreference.getLangue();
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
            //Get.to(PNCTraitementDecisionPage());
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          //color: Colors.blue,
        ),
        title: Center(
          child: Text("PNC N° ${widget.traitementDecisionModel.nnc}"),
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
                          child: CheckboxListTile(
                            title: const Text('Nécessite Investigation'),
                            value: checkWithInvestigation,
                            onChanged: (bool? value) {
                              setState(() {
                                checkWithInvestigation = value!;
                                if (checkWithInvestigation == true) {
                                  withInvestigation = 1;
                                  Get.to(
                                      RemplirPNCInvestigationAEffectuer(
                                          nnc: widget
                                              .traitementDecisionModel.nnc),
                                      //Get.to(RemplirPNCInvestigationApprouver(nnc: widget.traitementDecisionModel.nnc),
                                      arguments: {
                                        "necessite_investigation": 1
                                      });
                                } else {
                                  withInvestigation = 0;
                                }
                                //print('avec investigation ${withInvestigation}');
                              });
                            },
                            activeColor: Colors.blue,
                            //secondary: const Icon(Icons.hourglass_empty),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Visibility(
                          visible: true,
                          child: TextFormField(
                            enabled: false,
                            controller: dateSaisieDecisionController,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            validator: (value) =>
                                Validator.validateField(value: value!),
                            decoration: InputDecoration(
                                labelText: 'Date Saisie Decision',
                                hintText: 'date',
                                labelStyle: TextStyle(
                                  fontSize: 14.0,
                                ),
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10.0,
                                ),
                                suffixIcon: InkWell(
                                  onTap: () {},
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
                              controller: causeNCController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText: 'Cause NC',
                                hintText: 'Cause NC',
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
                        DropdownSearch<TypeTraitementModel>(
                          showSelectedItems: true,
                          showClearButton: true,
                          showSearchBox: true,
                          isFilteredOnline: true,
                          compareFn: (i, s) => i?.isEqual(s) ?? false,
                          dropdownSearchDecoration: InputDecoration(
                            labelText: "Type Traitement",
                            contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                            border: OutlineInputBorder(),
                          ),
                          onFind: (String? filter) => getTypeTraitement(filter),
                          onChanged: (data) {
                            selectCodeTypeTraitement = data?.codeTypeT;
                            print(
                                'type traitement: ${data?.typeT}, mat: ${selectCodeTypeTraitement}');
                          },
                          dropdownBuilder: customDropDownTypeTraitement,
                          popupItemBuilder:
                              customPopupItemBuilderTypeTraitement,
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
                            labelText: "Responsable Suivi *",
                            contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                            border: OutlineInputBorder(),
                          ),
                          onFind: (String? filter) =>
                              getResponsableSuivi(filter),
                          onChanged: (data) {
                            responsableSuiviModel = data;
                            responsableSuiviMatricule = data?.mat;
                            print(
                                'responsable suivi: ${data?.nompre}, mat: ${responsableSuiviMatricule}');
                          },
                          dropdownBuilder: customDropDownResponsableSuivi,
                          popupItemBuilder:
                              customPopupItemBuilderResponsableSuivi,
                          validator: (u) => u == null
                              ? "Responsable suivi is required "
                              : null,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Center(
                          child: Text(
                            'responsable Traitement',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                                sortAscending: true,
                                sortColumnIndex: 1,
                                dataRowHeight: 40,
                                showBottomBorder: false,
                                columns: [
                                  DataColumn(
                                      label: Text('id',
                                          style: _contentStyleHeader),
                                      numeric: true),
                                  DataColumn(
                                      label: Text('Nom Prenom',
                                          style: _contentStyleHeader)),
                                  DataColumn(
                                    label: InkWell(
                                      onTap: () {
                                        //Get.to(NewResponsableTraitement(traitementDecisionModel: widget.traitementDecisionModel));
                                        addResponsableTraitement(context);
                                        /* DateTime dateTime = DateTime.now();
                                            TextEditingController  dateTraitementController = TextEditingController();
                                            TextEditingController  traitementNCController = TextEditingController();
                                            String? employeMatricule = "";
                                            int? selectCodeTypeTraitement = 0;
                                            bool checkFirstResponsable = false;
                                            String firstResponsable = "0";
                                            String? language ="";
                                            dateTraitementController.text = DateFormat('yyyy-MM-dd').format(dateTime);
                                            if(SharedPreference.getLangue() == null){
                                              language = "";
                                            }else {
                                              language = SharedPreference.getLangue();
                                            }
                                            selectedDate(BuildContext context) async {
                                              var datePicker = await showDatePicker(
                                                  context: context,
                                                  initialDate: dateTime,
                                                  firstDate: DateTime(2000),
                                                  lastDate: DateTime(2050)
                                              );
                                              if(datePicker != null){
                                                setState(() {
                                                  dateTime = datePicker;
                                                  dateTraitementController.text = DateFormat('yyyy-MM-dd').format(datePicker);
                                                });
                                              }
                                            }
                                            //getEmploye
                                            Future<List<EmployeModel>> getEmploye(filter) async {
                                              try {
                                                List<EmployeModel> employeList = await List<EmployeModel>.empty(growable: true);
                                                List<EmployeModel>employeFilter = await List<EmployeModel>.empty(growable: true);
                                                var response = await LocalActionService().readEmploye();
                                                response.forEach((data){
                                                  var model = EmployeModel();
                                                  model.mat = data['mat'];
                                                  model.nompre = data['nompre'];
                                                  employeList.add(model);
                                                });
                                                employeFilter = employeList.where((u) {
                                                  var name = u.mat.toString().toLowerCase();
                                                  var description = u.nompre!.toLowerCase();
                                                  return name.contains(filter) ||
                                                      description.contains(filter);
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
                                              }
                                              else{
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
                                            //popup to add responsable traitement
                                            showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,
                                                shape: const RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.vertical(
                                                        top: Radius.circular(30)
                                                    )
                                                ),
                                                builder: (context) => DraggableScrollableSheet(
                                                  expand: false,
                                                  initialChildSize: 0.7,
                                                  maxChildSize: 0.9,
                                                  minChildSize: 0.4,
                                                  builder: (context, scrollController) => SingleChildScrollView(
                                                    child: StatefulBuilder(
                                                      builder: (BuildContext context, StateSetter setState) {
                                                        return Padding(
                                                          padding: const EdgeInsets.only(right: 5, left: 5),
                                                          child: ListBody(
                                                            children: <Widget>[
                                                              SizedBox(height: 5.0,),
                                                              Center(
                                                                child: Text('New Responsable Traitement', style: TextStyle(
                                                                    fontWeight: FontWeight.w500, fontFamily: "Brand-Bold",
                                                                    color: Color(0xFF0769D2), fontSize: 20.0
                                                                ),),
                                                              ),
                                                              SizedBox(height: 15.0,),
                                                              Form(
                                                                key: _addItemFormKey,
                                                                child: Column(
                                                                  children: [
                                                                    Visibility(
                                                                      visible: true,
                                                                      child: TextFormField(
                                                                        controller: dateTraitementController,
                                                                        keyboardType: TextInputType.text,
                                                                        textInputAction: TextInputAction.next,
                                                                        onChanged: (value){
                                                                          selectedDate(context);
                                                                        },
                                                                        decoration: InputDecoration(
                                                                            labelText: 'Delai Traitement',
                                                                            hintText: 'date',
                                                                            labelStyle: TextStyle(
                                                                              fontSize: 14.0,
                                                                            ),
                                                                            hintStyle: TextStyle(
                                                                              color: Colors.grey,
                                                                              fontSize: 10.0,
                                                                            ),
                                                                            suffixIcon: InkWell(
                                                                              onTap: (){
                                                                                selectedDate(context);
                                                                              },
                                                                              child: Icon(Icons.calendar_today),
                                                                            ),
                                                                            border: OutlineInputBorder(
                                                                                borderSide: BorderSide(color: Colors.lightBlue, width: 1),
                                                                                borderRadius: BorderRadius.all(Radius.circular(10))
                                                                            )
                                                                        ),
                                                                        style: TextStyle(fontSize: 14.0),
                                                                      ),
                                                                    ),
                                                                    SizedBox(height: 10.0,),
                                                                    Visibility(
                                                                        visible: true,
                                                                        child: TextFormField(
                                                                          controller: traitementNCController,
                                                                          keyboardType: TextInputType.text,
                                                                          textInputAction: TextInputAction.next,
                                                                          decoration: InputDecoration(
                                                                            labelText: 'Traitement NC',
                                                                            hintText: 'Traitement NC',
                                                                            labelStyle: TextStyle(
                                                                              fontSize: 14.0,
                                                                            ),
                                                                            hintStyle: TextStyle(
                                                                              color: Colors.grey,
                                                                              fontSize: 10.0,
                                                                            ),
                                                                            border: OutlineInputBorder(
                                                                                borderSide: BorderSide(color: Colors.lightBlue, width: 1),
                                                                                borderRadius: BorderRadius.all(Radius.circular(10))
                                                                            ),
                                                                          ),
                                                                          style: TextStyle(fontSize: 14.0),
                                                                          minLines: 2,
                                                                          maxLines: 5,
                                                                        )
                                                                    ),
                                                                    SizedBox(height: 10.0,),
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
                                                                        print('employe: ${data?.nompre}, mat: ${employeMatricule}');
                                                                      },
                                                                      dropdownBuilder: customDropDownEmploye,
                                                                      popupItemBuilder: customPopupItemBuilderEmploye,
                                                                      validator: (u) =>
                                                                      u == null ? "Employe is required " : null,
                                                                    ),
                                                                    SizedBox(height: 10.0,),
                                                                    Visibility(
                                                                      visible: true,
                                                                      child: CheckboxListTile(
                                                                        title: const Text('Premier Responsable'),
                                                                        value: checkFirstResponsable,
                                                                        onChanged: (bool? value) {
                                                                          setState(() {
                                                                            checkFirstResponsable = value!;
                                                                            if(checkFirstResponsable == true){
                                                                              firstResponsable = "1";
                                                                            }
                                                                            else {
                                                                              firstResponsable = "0";
                                                                            }
                                                                            print('Premier Responsable ${firstResponsable}');
                                                                          });

                                                                        },
                                                                        activeColor: Colors.blue,
                                                                        //secondary: const Icon(Icons.hourglass_empty),
                                                                      ),
                                                                    ),
                                                                    SizedBox(height: 10,),
                                                                    ConstrainedBox(
                                                                      constraints: BoxConstraints.tightFor(width: MediaQuery.of(context).size.width / 1.1, height: 50),
                                                                      child: ElevatedButton.icon(
                                                                        style: ButtonStyle(
                                                                          shape: MaterialStateProperty.all(
                                                                            RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(30),
                                                                            ),
                                                                          ),
                                                                          backgroundColor:
                                                                          MaterialStateProperty.all(CustomColors.firebaseRedAccent),
                                                                          padding: MaterialStateProperty.all(EdgeInsets.all(14)),
                                                                        ),
                                                                        icon: Icon(Icons.cancel),
                                                                        label: Text(
                                                                          'Cancel',
                                                                          style: TextStyle(fontSize: 16, color: Colors.white),
                                                                        ),
                                                                        onPressed: () {
                                                                          Get.back();
                                                                        },
                                                                      ),
                                                                    ),
                                                                    SizedBox(height: 10,),
                                                                    ConstrainedBox(
                                                                      constraints: BoxConstraints.tightFor(width: MediaQuery.of(context).size.width / 1.1, height: 50),
                                                                      child: ElevatedButton.icon(
                                                                        style: ButtonStyle(
                                                                          shape: MaterialStateProperty.all(
                                                                            RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(30),
                                                                            ),
                                                                          ),
                                                                          backgroundColor:
                                                                          MaterialStateProperty.all(CustomColors.googleBackground),
                                                                          padding: MaterialStateProperty.all(EdgeInsets.all(14)),
                                                                        ),
                                                                        icon: Icon(Icons.save),
                                                                        label: Text(
                                                                          'Save',
                                                                          style: TextStyle(fontSize: 16, color: Colors.white),
                                                                        ),
                                                                        onPressed: () async {
                                                                          if(_addItemFormKey.currentState!.validate()){
                                                                           /* try {
                                                                              var model = EquipeVisiteSecuriteModel();
                                                                              model.affectation = int.parse(traite.toString());
                                                                              model.mat = employeMatricule;
                                                                              model.nompre = employeNompre;
                                                                              await localVisiteSecuriteService.saveEquipeVisiteSecurite(model);
                                                                              Get.back();
                                                                              ShowSnackBar.snackBar("Successfully", "added to Equipe", Colors.green);
                                                                              //await Get.offAll(EquipeVisiteSecPage(numFiche: widget.numFiche));
                                                                              setState(() {
                                                                                listEquipeVisiteSecurite.clear();
                                                                                listEquipeSave.clear();
                                                                                getEquipeVisiteSecurite();
                                                                              });
                                                                            }
                                                                            catch (ex){
                                                                              print("Exception" + ex.toString());
                                                                              ShowSnackBar.snackBar("Exception", ex.toString(), Colors.red);
                                                                              throw Exception("Error " + ex.toString());
                                                                            } */
                                                                          }
                                                                        },
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                )
                                            ); */
                                      },
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.indigoAccent,
                                        size: 30,
                                      ),
                                    ),
                                  )
                                ],
                                rows: respTraitementList
                                    .map<DataRow>((element) => DataRow(cells: [
                                          DataCell(Text(
                                              element.id_resptrait.toString(),
                                              style: _contentStyle,
                                              textAlign: TextAlign.right)),
                                          DataCell(Text('${element.nompre}',
                                              style: _contentStyle,
                                              textAlign: TextAlign.right)),
                                          DataCell(InkWell(
                                              onTap: () {
                                                deleteResponsableTraitement(
                                                    context,
                                                    element.id_resptrait);
                                              },
                                              child: Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ))),
                                        ]))
                                    .toList()
                                /*rows: [
                                    DataRow(
                                      cells: [
                                        DataCell(Text('1',
                                            style: _contentStyle, textAlign: TextAlign.right)),
                                        DataCell(Text('Fancy Product', style: _contentStyle)),
                                        DataCell(Text(r'$ 199.99',
                                            style: _contentStyle, textAlign: TextAlign.right))
                                      ],
                                    ),
                                    DataRow(
                                      cells: [
                                        DataCell(Text('2',
                                            style: _contentStyle, textAlign: TextAlign.right)),
                                        DataCell(Text('Another Product', style: _contentStyle)),
                                        DataCell(Text(r'$ 79.00',
                                            style: _contentStyle, textAlign: TextAlign.right))
                                      ],
                                    ),
                                    DataRow(
                                      cells: [
                                        DataCell(Text('3',
                                            style: _contentStyle, textAlign: TextAlign.right)),
                                        DataCell(Text('Really Cool Stuff', style: _contentStyle)),
                                        DataCell(Text(r'$ 9.99',
                                            style: _contentStyle, textAlign: TextAlign.right))
                                      ],
                                    ),
                                    DataRow(
                                      cells: [
                                        DataCell(Text('4',
                                            style: _contentStyle, textAlign: TextAlign.right)),
                                        DataCell(
                                            Text('Last Product goes here', style: _contentStyle)),
                                        DataCell(Text(r'$ 19.99',
                                            style: _contentStyle, textAlign: TextAlign.right))
                                      ],
                                    ),
                                  ], */
                                ),
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

        await pncService.validerPNCTraitementDecision({
          "nnc": widget.traitementDecisionModel.nnc,
          "matRepSuivi": responsableSuiviMatricule,
          "codeTypeTraitement": selectCodeTypeTraitement.toString(),
          "causeNC": causeNCController.text
        }).then((resp) async {
          ShowSnackBar.snackBar(
              "Successfully", "Decision Traitement success", Colors.green);
          //Get.back();
          Get.to(PNCTraitementDecisionPage());
          await ApiControllersCall().getPNCDecision();
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

  //getResponsableSuivi
  Future<List<EmployeModel>> getResponsableSuivi(filter) async {
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

  Widget customDropDownResponsableSuivi(
      BuildContext context, EmployeModel? item) {
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

  Widget customPopupItemBuilderResponsableSuivi(
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

  //Type Traitement
  Future<List<TypeTraitementModel>> getTypeTraitement(filter) async {
    try {
      List<TypeTraitementModel> typeList =
          await List<TypeTraitementModel>.empty(growable: true);
      List<TypeTraitementModel> typeFilter =
          await List<TypeTraitementModel>.empty(growable: true);

      await PNCService().getTypeTraitement().then((resp) async {
        resp.forEach((data) async {
          var model = TypeTraitementModel();
          model.codeTypeT = data['codeTypeT'];
          model.typeT = data['typeT'];
          model.valid = data['valid'];
          typeList.add(model);
        });
      }, onError: (err) {
        ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
      });

      typeFilter = typeList.where((u) {
        var name = u.codeTypeT.toString().toLowerCase();
        var description = u.typeT!.toLowerCase();
        return name.contains(filter) || description.contains(filter);
      }).toList();
      return typeFilter;
    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }

  Widget customDropDownTypeTraitement(
      BuildContext context, TypeTraitementModel? item) {
    if (item == null) {
      return Container();
    } else {
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${item.typeT}', style: TextStyle(color: Colors.black)),
        ),
      );
    }
  }

  Widget customPopupItemBuilderTypeTraitement(
      BuildContext context, TypeTraitementModel item, bool isSelected) {
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
        title: Text(item.typeT ?? ''),
        //subtitle: Text(item.mat.toString() ?? ''),
      ),
    );
  }

  //add responsable traitement
  TextEditingController dateTraitementController = TextEditingController();
  TextEditingController traitementNCController = TextEditingController();
  String? employeMatricule = "";
  bool checkFirstResponsable = false;
  String firstResponsable = "0";
  String? language = "";

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

  addResponsableTraitement(context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          actionsAlignment: MainAxisAlignment.center,
          insetPadding: EdgeInsets.all(10),
          title: const Center(
            child: Text(
              'New Responsable Traitement',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontFamily: "Brand-Bold",
                  color: Color(0xFF0769D2),
                  fontSize: 16.0),
            ),
          ),
          titlePadding: EdgeInsets.only(top: 2.0, bottom: 5.0),
          content: SingleChildScrollView(child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Form(
                key: _addItemFormKeyResponsableTraitement,
                child: ListBody(
                  children: <Widget>[
                    Visibility(
                      visible: true,
                      child: TextFormField(
                        controller: dateTraitementController,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        onChanged: (value) {
                          selectedDate(context);
                        },
                        decoration: InputDecoration(
                            labelText: 'Delai Traitement *',
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
                          controller: traitementNCController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'Traitement N.C *',
                            hintText: 'Traitement NC',
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
                    DropdownSearch<EmployeModel>(
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
                      onFind: (String? filter) => getEmploye(filter),
                      onChanged: (data) {
                        employeMatricule = data?.mat;
                        print(
                            'Responsable Traitement: ${data?.nompre}, mat: ${employeMatricule}');
                      },
                      dropdownBuilder: customDropDownEmploye,
                      popupItemBuilder: customPopupItemBuilderEmploye,
                      validator: (u) => u == null
                          ? "Responsable Traitementl is required "
                          : null,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Visibility(
                      visible: true,
                      child: CheckboxListTile(
                        title: const Text('Premier Responsable'),
                        value: checkFirstResponsable,
                        onChanged: (bool? value) {
                          setState(() {
                            checkFirstResponsable = value!;
                            if (checkFirstResponsable == true) {
                              firstResponsable = "1";
                            } else {
                              firstResponsable = "0";
                            }
                            print('Premier Responsable ${firstResponsable}');
                          });
                        },
                        activeColor: Colors.blue,
                        //secondary: const Icon(Icons.hourglass_empty),
                      ),
                    ),
                  ],
                ),
              );
            },
          )),
          contentPadding: EdgeInsets.only(right: 5.0, left: 5.0, top: 5.0),
          actionsPadding: EdgeInsets.all(1.0),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              onPressed: () async {
                //Get.find<ActionController>().listAction.clear();
                //Get.find<ActionController>().getActions();
                //Get.back();
                if (_addItemFormKeyResponsableTraitement.currentState!
                    .validate()) {
                  try {
                    await pncService.addResponsableTraitement({
                      "nnc": widget.traitementDecisionModel.nnc.toString(),
                      "mat": employeMatricule,
                      "traitement": traitementNCController.text,
                      "delai": dateTraitementController.text,
                      "premier": firstResponsable,
                      "lang": language
                    }).then((resp) async {
                      Get.back();
                      respTraitementList.clear();
                      getResponsableTraitement();
                      traitementNCController.text = '';
                      ShowSnackBar.snackBar(
                          "Successfully", "Responsable added", Colors.green);
                    }, onError: (err) {
                      if (kDebugMode) {
                        print('error : ${err.toString()}');
                      }
                      ShowSnackBar.snackBar(
                          "Error", err.toString(), Colors.red);
                    });
                  } catch (ex) {
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
                  }
                }
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
                padding: const EdgeInsets.all(5.0),
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
        );
      },
    );
  }

  //delete responsable traitement
  deleteResponsableTraitement(context, position) {
    AwesomeDialog(
        context: context,
        animType: AnimType.SCALE,
        dialogType: DialogType.ERROR,
        body: Center(
          child: Text(
            'Are you sure to delete this item ${position}',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        title: 'Delete',
        btnOk: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              Colors.blue,
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          onPressed: () async {
            await pncService.deleteResponsableTraitementByID(position).then(
                (resp) async {
              ShowSnackBar.snackBar("Successfully",
                  "Responsable Traitement Deleted", Colors.green);
              respTraitementList
                  .removeWhere((element) => element.id_resptrait == position);
              setState(() {});
              Navigator.of(context).pop();
            }, onError: (err) {
              setState(() {
                _isProcessing = false;
              });
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Ok',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
          ),
        ),
        closeIcon: Icon(
          Icons.close,
          color: Colors.red,
        ),
        btnCancel: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              Colors.redAccent,
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
          ),
        ))
      ..show();
  }
}
