import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qualipro_flutter/Models/audit_action_model.dart';
import 'package:qualipro_flutter/Models/action/type_action_model.dart';
import 'package:qualipro_flutter/Views/action/action_page.dart';
import '../../Controllers/action/action_controller.dart';
import '../../Models/Domaine_affectation_model.dart';
import '../../Models/action/action_model.dart';
import '../../Models/activity_model.dart';
import '../../Models/direction_model.dart';
import '../../Models/employe_model.dart';
import '../../Models/processus_model.dart';
import '../../Models/resp_cloture_model.dart';
import '../../Models/service_model.dart';
import '../../Models/site_model.dart';
import '../../Models/action/source_action_model.dart';
import '../../Services/action/local_action_service.dart';
import '../../Services/api_services_call.dart';
import '../../Utils/custom_colors.dart';
import '../../Utils/message.dart';
import '../../Utils/shared_preference.dart';
import '../../Utils/snack_bar.dart';
import '../../Validators/validator.dart';
import 'actions_screen.dart';

class AddAction extends StatefulWidget {

  AddAction({Key? key}) : super(key: key);

  @override
  State<AddAction> createState() => _AddActionState();
}

class _AddActionState extends State<AddAction> {

  final _addItemFormKey = GlobalKey<FormState>();
  bool _isProcessing = false;

  LocalActionService actionService = LocalActionService();

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  DateTime dateTime = DateTime.now();
  TextEditingController  declencheurController = TextEditingController();
  TextEditingController  dateController = TextEditingController();
  TextEditingController  dateSaisieController = TextEditingController();
  TextEditingController  actionController = TextEditingController();
  TextEditingController  descriptionController = TextEditingController();
  TextEditingController  causeController = TextEditingController();
  TextEditingController  commentaireController = TextEditingController();
  TextEditingController  refInterneController = TextEditingController();
  TextEditingController  objectifController = TextEditingController();

  final declencheur = SharedPreference.getNomPrenom();
  final matricule = SharedPreference.getMatricule();
  late final currentYear;

  String? selectedEmployeCode = "";
  String? selectedOriginActionMat = "";
  String? selectedRespClotureCode = "";
  String? selectedRefAuditAct = "";
  int? selectedIdAudit = 0;

  //type
  late List<TypeActionModel> _typesList;
  late List<TypeActionModel> _typesFilter;
  int? selectedCodeTypeAct = 0;
  TypeActionModel? _typeActionModel = null;
  //source
  int? selectedCodeSourceAct = 0;
  SourceActionModel? _sourceActionModel = null;
  //site
  late int? site_visible;
  late bool isVisibileSite;
  late int? site_obligatoire;
  int? selectedSiteCode = 0;
  SiteModel? _siteModel = null;
  //processus
  late int? processus_visible;
  late bool isVisibileProcessus;
  late int? processus_obligatoire;
  int? selectedProcessusCode = 0;
  ProcessusModel? _processusModel = null;
  //activity
  late int? activity_visible;
  late bool isVisibileActivity;
  late int? activity_obligatoire;
  int? selectedActivityCode = 0;
  ActivityModel? _activityModel = null;
  //direction
  late int? direction_visible;
  late bool isVisibileDirection;
  late int? direction_obligatoire;
  int? selectedDirectionCode = 0;
  DirectionModel? _directionModel = null;
  //service
  late int? service_visible;
  late bool isVisibileService;
  late int? service_obligatoire;
  int? selectedServiceCode = 0;
  ServiceModel? _serviceModel = null;

  //domaine affectation
  getDomaineAffectation() async{
    List<DomaineAffectationModel> domaineList = await List<DomaineAffectationModel>.empty(growable: true);
    var response = await actionService.readDomaineAffectationByModule("Action", "Action");
    response.forEach((data){
      setState(() {
        var model = DomaineAffectationModel();
        model.id = data['id'];
        model.module = data['module'];
        model.fiche = data['fiche'];
        model.vSite = data['vSite'];
        model.oSite = data['oSite'];
        model.rSite = data['rSite'];
        model.vProcessus = data['vProcessus'];
        model.oProcessus = data['oProcessus'];
        model.rProcessus = data['rProcessus'];
        model.vDomaine = data['vDomaine'];
        model.oDomaine = data['oDomaine'];
        model.rDomaine = data['rDomaine'];
        model.vDirection = data['vDirection'];
        model.oDirection = data['oDirection'];
        model.rDirection = data['rDirection'];
        model.vService = data['vService'];
        model.oService = data['oService'];
        model.rService = data['rService'];
        model.vEmpSite = data['vEmpSite'];
        model.vEmpProcessus = data['vEmpProcessus'];
        model.vEmpDomaine = data['vEmpDomaine'];
        model.vEmpDirection = data['vEmpDirection'];
        model.vEmpService = data['vEmpService'];
        domaineList.add(model);

          //print('fiche: ${model.fiche}, site visible :${model.vSite}, site obligatoire :${model.oSite}');
          site_visible = model.vSite;
          processus_visible = model.vProcessus;
          activity_visible = model.vDomaine;
          direction_visible = model.vDirection;
          service_visible = model.vService;
          //print('visibility site: $site_visible');
          site_obligatoire = model.oSite;
          processus_obligatoire = model.oProcessus;
          activity_obligatoire = model.oDomaine;
          direction_obligatoire = model.oDirection;
          service_obligatoire = model.oService;
      });
    });
  }

  bool _dataValidation(){
    if(actionController.text.trim()==''){
      Message.taskErrorOrWarning("Action", "action is required");
      return false;
    }
    else if(dateController.text.trim()==''){
      Message.taskErrorOrWarning("Date", "Date is required");
      return false;
    }
    else if(_typeActionModel == null){
      Message.taskErrorOrWarning("Type Action", "Type is required");
      return false;
    }
    else if(_sourceActionModel == null){
      Message.taskErrorOrWarning("Source Action", "Source is required");
      return false;
    }
    else if(site_visible == 1 && site_obligatoire == 1 && _siteModel == null){
      Message.taskErrorOrWarning("Site", "Site is required");
      return false;
    }
    else if(processus_visible == 1 && processus_obligatoire == 1 && _processusModel == null){
      Message.taskErrorOrWarning("Processus", "Processus is required");
      return false;
    }
    else if(direction_visible == 1 && direction_obligatoire == 1 && _directionModel == null){
      Message.taskErrorOrWarning("Direction", "Direction is required");
      return false;
    }
    else if(service_visible == 1 && service_obligatoire == 1 && _serviceModel == null){
      Message.taskErrorOrWarning("Service", "Service is required");
      return false;
    }
    else if(activity_visible == 1 && activity_obligatoire == 1 && _activityModel == null){
      Message.taskErrorOrWarning("Activity", "Activity is required");
      return false;
    }
    return true;
  }

  @override
  void initState(){
    dateController.text = DateFormat('yyyy-MM-dd').format(dateTime);
    dateSaisieController.text = DateFormat('yyyy-MM-dd').format(dateTime);
    declencheurController.text = declencheur.toString();

    getDomaineAffectation();

    super.initState();
  }

  selectedDate(BuildContext context) async {
    var datePicker = await showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime.now()
        //lastDate: DateTime.now()
    );
    if(datePicker != null){
      setState(() {
        dateTime = datePicker;
        dateController.text = DateFormat('yyyy-MM-dd').format(datePicker);
        //dateController.text = DateFormat.yMMMMd().format(datePicker);
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        leading: TextButton(
          onPressed: (){
            Get.back();
          },
          child: Icon(Icons.arrow_back, color: Colors.white,),
        ),
        title: Center(
          child: Text("Ajouter Action"),
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
                            SizedBox(height: 8.0,),
                            TextFormField(
                              enabled: false,
                              controller: declencheurController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              validator: (value) => Validator.validateField(
                                  value: value!
                              ),
                              decoration: InputDecoration(
                                  labelText: 'Declencheur',
                                  hintText: 'declencheur',
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
                            ),
                            SizedBox(height: 10.0,),
                            TextFormField(
                              controller: actionController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              validator: (value) => Validator.validateField(
                                  value: value!
                              ),
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
                                      borderSide: BorderSide(color: Colors.lightBlue, width: 1),
                                      borderRadius: BorderRadius.all(Radius.circular(10))
                                  ),
                                  /*suffixIcon: InkWell(
                                    onTap: (){
                                      actionController.clear();
                                    },
                                    child: Icon(Icons.close),
                                  ) */
                              ),
                              style: TextStyle(fontSize: 14.0),
                            ),
                            SizedBox(height: 10.0,),
                            TextFormField(
                              controller: descriptionController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  labelText: 'Description',
                                  hintText: 'description',
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
                            ),
                            SizedBox(height: 10.0,),
                            TextFormField(
                              controller: causeController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  labelText: 'Cause',
                                  hintText: 'cause',
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
                                )
                              ),
                              style: TextStyle(fontSize: 14.0),
                            ),
                            SizedBox(height: 10.0,),
                            TextFormField(
                              controller: refInterneController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  labelText: 'Ref. interne',
                                  hintText: 'Ref. interne',
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
                                  )
                              ),
                              style: TextStyle(fontSize: 14.0),
                            ),
                            SizedBox(height: 10.0,),
                            TextFormField(
                              controller: dateController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              validator: (value) => Validator.validateField(
                                  value: value!
                              ),
                              onChanged: (value){
                                selectedDate(context);
                              },
                              decoration: InputDecoration(
                                  labelText: 'Date creation',
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
                            SizedBox(height: 10.0,),
                            TextFormField(
                              enabled: false,
                              controller: dateSaisieController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              validator: (value) => Validator.validateField(
                                  value: value!
                              ),
                              onChanged: (value){
                                selectedDate(context);
                              },
                              decoration: InputDecoration(
                                  labelText: 'Date saisie',
                                  hintText: 'date saisie',
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
                            SizedBox(height: 10.0,),
                            Visibility(
                                visible: true,
                                child: DropdownSearch<TypeActionModel>(
                                  showSelectedItems: true,
                                  showClearButton: true,
                                  showSearchBox: true,
                                  isFilteredOnline: true,
                                  compareFn: (i, s) => i?.isEqual(s) ?? false,
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText: "Type *",
                                    contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                    border: OutlineInputBorder(),
                                  ),
                                  onFind: (String? filter) => getTypes(filter),
                                  onChanged: (data) {
                                    selectedCodeTypeAct = data?.codetypeAct;
                                    _typeActionModel = data;
                                    print('type action: ${_typeActionModel?.typeAct}, code: $selectedCodeTypeAct');
                                  },
                                  dropdownBuilder: _customDropDownType,
                                  popupItemBuilder: _customPopupItemBuilderType,
                                  validator: (u) =>
                                  u == null ? "type is required " : null,
                                )
                            ),

                            SizedBox(height: 10.0,),
                            Visibility(
                              visible: true,
                                child: DropdownSearch<SourceActionModel>(
                                  showSelectedItems: true,
                                  showClearButton: true,
                                  showSearchBox: true,
                                  isFilteredOnline: true,
                                  compareFn: (i, s) => i?.isEqual(s) ?? false,
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText: "Source *",
                                    contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                    border: OutlineInputBorder(),
                                  ),
                                  onFind: (String? filter) => getSources(filter),
                                  onChanged: (data) {
                                    selectedCodeSourceAct = data?.codeSouceAct;
                                    _sourceActionModel =data;
                                    print('source action :${_sourceActionModel?.sourceAct}, code :$selectedCodeSourceAct');
                                  },
                                  dropdownBuilder: _customDropDownSource,
                                  popupItemBuilder: _customPopupItemBuilderSource,
                                  validator: (u) =>
                                  u == null ? "source is required " : null,
                                )
                            ),

                            SizedBox(height: 10.0,),
                            Visibility(
                                visible: true,
                                child: DropdownSearch<AuditActionModel>(
                                  showSelectedItems: true,
                                  showClearButton: true,
                                  showSearchBox: true,
                                  isFilteredOnline: true,
                                  compareFn: (i, s) => i?.isEqual(s) ?? false,
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText: "Ref Audit",
                                    contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                    border: OutlineInputBorder(),
                                  ),
                                  onFind: (String? filter) => getRefAudit(filter),
                                  onChanged: (data) {
                                    selectedRefAuditAct = data?.refAudit;
                                    selectedIdAudit = data?.idaudit;
                                    print(selectedRefAuditAct);
                                    print(selectedIdAudit);
                                  },
                                  dropdownBuilder: _customDropDownRefAudit,
                                  popupItemBuilder: _customPopupItemBuilderRefAudit,
                                )
                            ),
                            SizedBox(height: 10.0,),
                            Visibility(
                                visible:site_visible == 1 ? isVisibileSite=true : isVisibileSite=false,
                                child: DropdownSearch<SiteModel>(
                                showSelectedItems: true,
                                showClearButton: true,
                                showSearchBox: true,
                                isFilteredOnline: true,
                                compareFn: (i, s) => i?.isEqual(s) ?? false,
                                dropdownSearchDecoration: InputDecoration(
                                  labelText: "Site ${site_obligatoire==1?'*':''}",
                                  contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                  border: OutlineInputBorder(),
                                ),
                                onFind: (String? filter) => getSite(filter),
                                onChanged: (data) {
                                  _siteModel = data;
                                  print(_siteModel?.site);
                                  selectedSiteCode = data?.codesite;
                                  print(selectedSiteCode);
                                },
                                dropdownBuilder: _customDropDownSite,
                                popupItemBuilder: _customPopupItemBuilderSite,
                                validator: (u) =>
                                (site_obligatoire==1 && _siteModel==null) ? "site is required " : null,
                                onBeforeChange: (a, b) {
                                  if (b == null) {
                                    AlertDialog alert = AlertDialog(
                                      title: Text("Are you sure..."),
                                      content: Text("...you want to clear the selection"),
                                      actions: [
                                        TextButton(
                                          child: Text("OK"),
                                          onPressed: () {
                                            Navigator.of(context).pop(true);
                                          },
                                        ),
                                        TextButton(
                                          child: Text("Cancel"),
                                          onPressed: () {
                                            Navigator.of(context).pop(false);
                                          },
                                        ),
                                      ],
                                    );

                                    return showDialog<bool>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          selectedSiteCode = 0;
                                          print('clear site : ${selectedSiteCode}');
                                          return alert;
                                        });
                                  }

                                  return Future.value(true);
                                }
                            )
                            ),
                            SizedBox(height: 10.0,),
                            Visibility(
                                visible: processus_visible == 1 ? isVisibileProcessus=true : isVisibileProcessus=false,
                                child: DropdownSearch<ProcessusModel>(
                                    showSelectedItems: true,
                                    showClearButton: true,
                                    showSearchBox: true,
                                    isFilteredOnline: true,
                                    compareFn: (i, s) => i?.isEqual(s) ?? false,
                                    dropdownSearchDecoration: InputDecoration(
                                      labelText: "Processus ${processus_obligatoire==1?'*':''}",
                                      contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                      border: OutlineInputBorder(),
                                    ),
                                    onFind: (String? filter) => getProcessus(filter),
                                    onChanged: (data) {
                                      selectedProcessusCode = data?.codeProcessus;
                                      _processusModel = data;
                                      print(_processusModel?.processus);
                                      print(selectedProcessusCode);
                                    },
                                    dropdownBuilder: _customDropDownProcessus,
                                    popupItemBuilder: _customPopupItemBuilderProcessus,
                                    validator: (u) =>
                                    (processus_obligatoire==1 && _processusModel==null) ? "processus is required " : null,
                                    onBeforeChange: (a, b) {
                                      if (b == null) {
                                        AlertDialog alert = AlertDialog(
                                          title: Text("Are you sure..."),
                                          content: Text("...you want to clear the selection"),
                                          actions: [
                                            TextButton(
                                              child: Text("OK"),
                                              onPressed: () {
                                                selectedProcessusCode = 0;
                                                Navigator.of(context).pop(true);
                                              },
                                            ),
                                            TextButton(
                                              child: Text("Cancel"),
                                              onPressed: () {
                                                Navigator.of(context).pop(false);
                                              },
                                            ),
                                          ],
                                        );

                                        return showDialog<bool>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return alert;
                                            });
                                      }

                                      return Future.value(true);
                                    }
                                )
                            ),
                            SizedBox(height: 10.0,),
                            Visibility(
                                visible: true,
                                child: DropdownSearch<RespClotureModel>(
                                    showSelectedItems: true,
                                    showClearButton: true,
                                    showSearchBox: true,
                                    isFilteredOnline: true,
                                    compareFn: (i, s) => i?.isEqual(s) ?? false,
                                    dropdownSearchDecoration: InputDecoration(
                                      labelText: "Responsable Cloture",
                                      contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                      border: OutlineInputBorder(),
                                    ),
                                    onFind: (String? filter) => getRespCloture(filter),
                                    onChanged: (data) {
                                      selectedRespClotureCode = data?.mat;
                                      //selectedSiteDescription = data!.site;
                                      print(selectedRespClotureCode);
                                    },
                                    dropdownBuilder: _customDropDownRespCloture,
                                    popupItemBuilder: _customPopupItemBuilderRespCloture,
                                    onBeforeChange: (a, b) {
                                      if (b == null) {
                                        AlertDialog alert = AlertDialog(
                                          title: Text("Are you sure..."),
                                          content: Text("...you want to clear the selection"),
                                          actions: [
                                            TextButton(
                                              child: Text("OK"),
                                              onPressed: () {
                                                Navigator.of(context).pop(true);
                                              },
                                            ),
                                            TextButton(
                                              child: Text("Cancel"),
                                              onPressed: () {
                                                Navigator.of(context).pop(false);
                                              },
                                            ),
                                          ],
                                        );
                                        return showDialog<bool>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return alert;
                                            });
                                      }
                                      return Future.value(true);
                                    }
                                )
                            ),
                            SizedBox(height: 10.0,),
                            Visibility(
                                visible: true,
                                child: DropdownSearch<EmployeModel>(
                                    showSelectedItems: true,
                                    showClearButton: true,
                                    showSearchBox: true,
                                    isFilteredOnline: true,
                                    compareFn: (i, s) => i?.isEqual(s) ?? false,
                                    dropdownSearchDecoration: InputDecoration(
                                      labelText: "Responsable Suivi",
                                      contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                      border: OutlineInputBorder(),
                                    ),
                                    onFind: (String? filter) => getEmploye(filter),
                                    onChanged: (data) {
                                      selectedEmployeCode = data?.mat;
                                      print(selectedEmployeCode);
                                    },
                                    dropdownBuilder: _customDropDownEmploye,
                                    popupItemBuilder: _customPopupItemBuilderEmploye,
                                    onBeforeChange: (a, b) {
                                      if (b == null) {
                                        AlertDialog alert = AlertDialog(
                                          title: Text("Are you sure..."),
                                          content: Text("...you want to clear the selection"),
                                          actions: [
                                            TextButton(
                                              child: Text("OK"),
                                              onPressed: () {
                                                Navigator.of(context).pop(true);
                                              },
                                            ),
                                            TextButton(
                                              child: Text("Cancel"),
                                              onPressed: () {
                                                Navigator.of(context).pop(false);
                                              },
                                            ),
                                          ],
                                        );
                                        return showDialog<bool>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return alert;
                                            });
                                      }
                                      return Future.value(true);
                                    }
                                )
                            ),
                            SizedBox(height: 10.0,),
                            Visibility(
                                visible: true,
                                child: DropdownSearch<EmployeModel>(
                                    showSelectedItems: true,
                                    showClearButton: true,
                                    showSearchBox: true,
                                    isFilteredOnline: true,
                                    compareFn: (i, s) => i?.isEqual(s) ?? false,
                                    dropdownSearchDecoration: InputDecoration(
                                      labelText: "A l'origine de l'action",
                                      contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                      border: OutlineInputBorder(),
                                    ),
                                    onFind: (String? filter) => getEmploye(filter),
                                    onChanged: (data) {
                                      selectedOriginActionMat = data?.mat;
                                      print(selectedOriginActionMat);
                                    },
                                    dropdownBuilder: _customDropDownEmploye,
                                    popupItemBuilder: _customPopupItemBuilderEmploye,
                                    onBeforeChange: (a, b) {
                                      if (b == null) {
                                        AlertDialog alert = AlertDialog(
                                          title: Text("Are you sure..."),
                                          content: Text("...you want to clear the selection"),
                                          actions: [
                                            TextButton(
                                              child: Text("OK"),
                                              onPressed: () {
                                                Navigator.of(context).pop(true);
                                              },
                                            ),
                                            TextButton(
                                              child: Text("Cancel"),
                                              onPressed: () {
                                                Navigator.of(context).pop(false);
                                              },
                                            ),
                                          ],
                                        );
                                        return showDialog<bool>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return alert;
                                            });
                                      }
                                      return Future.value(true);
                                    }
                                )
                            ),
                            SizedBox(height: 10.0,),
                            Visibility(
                                visible: direction_visible == 1 ? isVisibileDirection=true : isVisibileDirection=false,
                                child: DropdownSearch<DirectionModel>(
                                    showSelectedItems: true,
                                    showClearButton: true,
                                    showSearchBox: true,
                                    isFilteredOnline: true,
                                    compareFn: (i, s) => i?.isEqual(s) ?? false,
                                    dropdownSearchDecoration: InputDecoration(
                                      labelText: "Direction ${direction_obligatoire==1?'*':''}",
                                      contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                      border: OutlineInputBorder(),
                                    ),
                                    onFind: (String? filter) => getDirection(filter),
                                    onChanged: (data) {
                                      selectedDirectionCode = data?.codeDirection;
                                      _directionModel = data;
                                      print('direction: ${_directionModel?.direction}, direction code: $selectedDirectionCode');
                                    },
                                    dropdownBuilder: _customDropDownDirection,
                                    popupItemBuilder: _customPopupItemBuilderDirection,
                                    validator: (u) =>
                                    (direction_obligatoire==1 && _directionModel==null) ? "direction is required " : null,
                                    onBeforeChange: (a, b) {
                                      if (b == null) {
                                        AlertDialog alert = AlertDialog(
                                          title: Text("Are you sure..."),
                                          content: Text("...you want to clear the selection"),
                                          actions: [
                                            TextButton(
                                              child: Text("OK"),
                                              onPressed: () {
                                                Navigator.of(context).pop(true);
                                              },
                                            ),
                                            TextButton(
                                              child: Text("Cancel"),
                                              onPressed: () {
                                                Navigator.of(context).pop(false);
                                              },
                                            ),
                                          ],
                                        );
                                        return showDialog<bool>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return alert;
                                            });
                                      }
                                      return Future.value(true);
                                    }
                                )
                            ),
                            SizedBox(height: 10.0,),
                            Visibility(
                                visible: service_visible == 1 ? isVisibileService=true : isVisibileService=false,
                                child: DropdownSearch<ServiceModel>(
                                    showSelectedItems: true,
                                    showClearButton: true,
                                    showSearchBox: true,
                                    isFilteredOnline: true,
                                    compareFn: (i, s) => i?.isEqual(s) ?? false,
                                    dropdownSearchDecoration: InputDecoration(
                                      labelText: "Service ${service_obligatoire==1?'*':''}",
                                      contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                      border: OutlineInputBorder(),
                                    ),
                                    onFind: (String? filter) => getService(filter),
                                    onChanged: (data) {
                                      selectedServiceCode = data?.codeService;
                                      _serviceModel = data;
                                      print('service: ${_serviceModel?.service}, code: $selectedServiceCode');
                                    },
                                    dropdownBuilder: _customDropDownService,
                                    popupItemBuilder: _customPopupItemBuilderService,
                                    validator: (u) =>
                                    (_serviceModel==null && service_obligatoire==1) ? "service is required " : null,
                                    //u == null ? "service is required " : null,
                                    onBeforeChange: (a, b) {
                                      if (b == null) {
                                        AlertDialog alert = AlertDialog(
                                          title: Text("Are you sure..."),
                                          content: Text("...you want to clear the selection"),
                                          actions: [
                                            TextButton(
                                              child: Text("OK"),
                                              onPressed: () {
                                                Navigator.of(context).pop(true);
                                              },
                                            ),
                                            TextButton(
                                              child: Text("Cancel"),
                                              onPressed: () {
                                                Navigator.of(context).pop(false);
                                              },
                                            ),
                                          ],
                                        );
                                        return showDialog<bool>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return alert;
                                            });
                                      }
                                      return Future.value(true);
                                    }
                                )
                            ),
                            SizedBox(height: 10.0,),
                            Visibility(
                                visible: activity_visible == 1 ? isVisibileActivity=true : isVisibileActivity=false,
                                child: DropdownSearch<ActivityModel>(
                                    showSelectedItems: true,
                                    showClearButton: true,
                                    showSearchBox: true,
                                    isFilteredOnline: true,
                                    compareFn: (i, s) => i?.isEqual(s) ?? false,
                                    dropdownSearchDecoration: InputDecoration(
                                      labelText: "Activity ${activity_obligatoire==1?'*':''}",
                                      contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                      border: OutlineInputBorder(),
                                    ),
                                    onFind: (String? filter) => getActivity(filter),
                                    onChanged: (data) {
                                      selectedActivityCode = data?.codeDomaine;
                                      _activityModel = data;
                                      print('activity:${_activityModel?.domaine}, code activity:$selectedActivityCode');
                                    },
                                    dropdownBuilder: _customDropDownActivity,
                                    popupItemBuilder: _customPopupItemBuilderActivity,
                                    validator: (u) =>
                                    (activity_obligatoire==1 && _activityModel==null) ? "activity is required " : null,
                                    onBeforeChange: (a, b) {
                                      if (b == null) {
                                        AlertDialog alert = AlertDialog(
                                          title: Text("Are you sure..."),
                                          content: Text("...you want to clear the selection"),
                                          actions: [
                                            TextButton(
                                              child: Text("OK"),
                                              onPressed: () {
                                                selectedActivityCode = 0;
                                                Navigator.of(context).pop(true);
                                              },
                                            ),
                                            TextButton(
                                              child: Text("Cancel"),
                                              onPressed: () {
                                                Navigator.of(context).pop(false);
                                              },
                                            ),
                                          ],
                                        );
                                        return showDialog<bool>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return alert;
                                            });
                                      }
                                      return Future.value(true);
                                    }
                                )
                            ),
                            SizedBox(height: 10.0,),
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
                                        borderSide: BorderSide(color: Colors.lightBlue, width: 1),
                                        borderRadius: BorderRadius.all(Radius.circular(10))
                                    ),
                                  ),
                                  style: TextStyle(fontSize: 14.0),
                                )
                            ),
                            SizedBox(height: 10.0,),
                            Visibility(
                                visible: true,
                                child: TextFormField(
                                  controller: objectifController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    labelText: 'Objectif',
                                    hintText: 'Objectif',
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
                                )
                            ),
                            SizedBox(height: 20.0,),
                            _isProcessing
                                ? Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  CustomColors.firebaseOrange,
                                ),
                              ),
                            )
                                :
                            ElevatedButton(
                              onPressed: () async {
                                saveAction();
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
                                child: Text('Save',
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
                        )
                    )
                ),
              ),
            ),
          )
      ),
    );
  }

  Future saveAction() async {
    if(_dataValidation() && _addItemFormKey.currentState!.validate()){
        try {
          setState(() {
            _isProcessing = true;
          });

          var connection = await Connectivity().checkConnectivity();
         /* if(connection == ConnectivityResult.none){
            var model = ActionModel();
            //model.nAct = data['nAct'];
            model.site = selectedSiteDescription;
            model.sourceAct = selectedSourceAct;
            model.typeAct = selectedTypeAct;
            model.date = dateController.text;
            model.cloture = 0;
            model.act = actionController.text.trim();
            model.tauxEff = 0;
            model.tauxRea = 0;
            model.nomOrigine = selectedOriginActionMat;
            model.respClot = 0;
            model.fSimp = 0;
            model.idAudit = selectedIdAudit;
            model.actionPlus0 = "";
            model.actionPlus1 = "";
            model.isd = 0;
            model.datsuivPrv = dateSaisieController.text;
            //save data in local db
            await actionService.saveAction(model);
            print('Insert action table : $model');
          }*/
          saveActionData(
              actionController.text.trim(),
              dateController.text,
              dateSaisieController.text,
              descriptionController.text.trim(),
              causeController.text.trim(),
              commentaireController.text.trim(),
              refInterneController.text.trim(),
              objectifController.text.trim(),
          );

        }
        catch (ex){
          _isProcessing = false;
          AwesomeDialog(
            context: context,
            animType: AnimType.SCALE,
            dialogType: DialogType.ERROR,
            body: Center(child: Text(
              ex.toString(),
              style: TextStyle(fontStyle: FontStyle.italic),
            ),),
            title: 'Error',
            btnCancel: Text('Cancel'),
            btnOkOnPress: () {
              Navigator.of(context).pop();
            },
          )..show();
          print("throwing new error " + ex.toString());
          throw Exception("Error " + ex.toString());
        }
        finally{
          _isProcessing = false;
        }
    }
  }
  void saveActionData(
      String action, String date, String date_saisie, String description, String cause, String commentaire,
      String refInterne, String objectif
      ) {
    currentYear = DateFormat.y().format(dateTime);
    Get.find<ActionController>().saveAction(
        {
          "action": action,
          "typea": selectedCodeTypeAct,
          "codesource": selectedCodeSourceAct,
          "refAudit": selectedRefAuditAct,
          "descpb": description,
          "cause": cause,
          "datepa": date,
          "cloture": 0,
          "codesite": selectedSiteCode,
          "matdeclencheur": matricule.toString(),
          "commentaire": commentaire,
          "respsuivi": selectedEmployeCode,
          "nfiche": 0,
          "imodule": 0,
          "datesaisie": date_saisie,
          "mat_origine": selectedOriginActionMat,
          "objectif": objectif,
          "respclot": selectedRespClotureCode,
          "annee": currentYear,
          "ref_interne": refInterne,
          "direction": selectedDirectionCode,
          "metier": 0,
          "theme": 0,
          "process": selectedProcessusCode,
          "domaine": selectedActivityCode,
          "service": selectedServiceCode
        }
    );
    Get.back();
  }

  //source action
  Widget _customDropDownSource(BuildContext context, SourceActionModel? item) {
    if (item == null) {
      return Container();
    }

    return Container(
      child: (item.codeSouceAct == null)
          ? ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text("No item selected"),
      )
          : ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text('${item.sourceAct}'),
      ),
    );
  }
  Widget _customPopupItemBuilderSource(
      BuildContext context, SourceActionModel? item, bool isSelected) {
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
        title: Text(item?.sourceAct ?? ''),
        //subtitle: Text(item?.TypeAct ?? ''),
      ),
    );
  }
  Future<List<SourceActionModel>> getSources(filter) async {
    try {
      List<SourceActionModel> _sourcesList = await List<SourceActionModel>.empty(growable: true);
      List<SourceActionModel> _sourcesDisplay = await <SourceActionModel>[];
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        var response = await actionService.readSourceAction();
        response.forEach((data){
          setState(() {
            var sourceModel = SourceActionModel();
            sourceModel.codeSouceAct = data['codeSouceAct'];
            sourceModel.sourceAct = data['sourceAct'];
            _sourcesList.add(sourceModel);
          });
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        await ApiServicesCall().getSourceAction().then((resp) async {
          resp.forEach((data) async {
            print('get source actions : ${data} ');
            var model = SourceActionModel();
            model.codeSouceAct = data['codeSouceAct'];
            model.sourceAct = data['sourceAct'];
            _sourcesList.add(model);
          });
        }
            , onError: (err) {
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });
      }

      _sourcesDisplay = _sourcesList.where((u) {
        var name = u.sourceAct!.toLowerCase();
        return name.contains(filter);
      }).toList();
      return _sourcesDisplay;
    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }

  //type action
  Widget _customDropDownType(BuildContext context, TypeActionModel? item) {
    if (item == null) {
      return Container();
    }

    return Container(
      child: (item.codetypeAct == null)
          ? ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text("No item selected"),
      )
          : ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text('${item.typeAct}'),
      ),
    );
  }
  Widget _customPopupItemBuilderType(
      BuildContext context, TypeActionModel? item, bool isSelected) {
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
        title: Text(item?.typeAct ?? ''),
        //subtitle: Text(item?.TypeAct ?? ''),
      ),
    );
  }
  Future<List<TypeActionModel>> getTypes(filter) async {
    try {
      _typesList = await List<TypeActionModel>.empty(growable: true);
      _typesFilter = await List<TypeActionModel>.empty(growable: true);
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        var response = await actionService.readTypeAction();
        response.forEach((data){
          setState(() {
            var sourceModel = TypeActionModel();
            sourceModel.codetypeAct = data['codetypeAct'];
            sourceModel.typeAct = data['typeAct'];
            sourceModel.actSimpl = data['actSimpl'];
            sourceModel.analyseCause = data['analyseCause'];
            _typesList.add(sourceModel);
          });
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        await ApiServicesCall().getTypeAction({
          "nom": "",
          "lang": ""
        }).then((resp) async {
          resp.forEach((data) async {
            var model = TypeActionModel();
            model.codetypeAct = data['codetypeAct'];
            model.typeAct = data['typeAct'];
            model.actSimpl = data['act_simpl'];
            model.analyseCause = data['analyse_cause'];
            _typesList.add(model);
          });
        }
            , onError: (err) {
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });
      }
      _typesFilter = _typesList.where((u) {
        var query = u.typeAct!.toLowerCase();
        return query.contains(filter);
      }).toList();
      return _typesFilter;

    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }

  //ref audit
  Widget _customDropDownRefAudit(BuildContext context, AuditActionModel? item) {
    if (item == null) {
      return Container();
    }

    return Container(
      child: (item.idaudit == null)
          ? ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text("No item selected"),
      )
          : ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text('${item.idaudit}'),
      ),
    );
  }
  Widget _customPopupItemBuilderRefAudit(
      BuildContext context, AuditActionModel? item, bool isSelected) {
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
        title: Text(item?.refAudit ?? ''),
        //subtitle: Text(item?.TypeAct ?? ''),
      ),
    );
  }
  Future<List<AuditActionModel>> getRefAudit(filter) async {
    try {
      List<AuditActionModel> _refAuditList = await List<AuditActionModel>.empty(growable: true);
      List<AuditActionModel> _refAuditFilter = await <AuditActionModel>[];
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        var response = await actionService.readAuditAction();
        response.forEach((data){
          setState(() {
            var model = AuditActionModel();
            model.idaudit = data['idaudit'];
            model.refAudit = data['refAudit'];
            model.interne = data['interne'];
            _refAuditList.add(model);

          });
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        await ApiServicesCall().getAuditAction().then((resp) async {
          resp.forEach((data) async {
            var model = AuditActionModel();
            model.idaudit = data['idaudit'];
            model.refAudit = data['refAudit'];
            model.interne = data['interne'];
            _refAuditList.add(model);
          });
        }
            , onError: (err) {
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });
      }
      _refAuditFilter = _refAuditList.where((u) {
        var name = u.idaudit.toString().toLowerCase();
        return name.contains(filter);
      }).toList();
      return _refAuditFilter;

    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }

  //Site
  Widget _customDropDownSite(BuildContext context, SiteModel? item) {
    if (item == null) {
      return Container();
    }

    return Container(
      child: (item.codesite == null)
          ? ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text("No item selected"),
      )
          : ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text('${item.site}'),
        //subtitle: Text('${item.codesite}',),
      ),
    );
  }
  Widget _customPopupItemBuilderSite(
      BuildContext context, SiteModel? item, bool isSelected) {
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
        title: Text(item?.site ?? ''),
        subtitle: Text(item?.codesite.toString() ?? ''),
      ),
    );
  }
  Future<List<SiteModel>> getSite(filter) async {
    try {
      List<SiteModel> siteList = await List<SiteModel>.empty(growable: true);
      List<SiteModel> siteFilter = await <SiteModel>[];
      var sites = await actionService.readSite();
      sites.forEach((data){
        setState(() {
          var siteModel = SiteModel();
          siteModel.codesite = data['codesite'];
          siteModel.site = data['site'];
          siteList.add(siteModel);
        });
      });
      siteFilter = siteList.where((u) {
        var name = u.codesite.toString().toLowerCase();
        var description = u.site!.toLowerCase();
        return name.contains(filter) ||
            description.contains(filter);
      }).toList();
      return siteFilter;
  } catch (exception) {
  ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
  return Future.error('service : ${exception.toString()}');
  }
  }

  //Processus
  Widget _customDropDownProcessus(BuildContext context, ProcessusModel? item) {
    if (item == null) {
      return Container();
    }
    return Container(
      child: (item.codeProcessus == null)
          ? ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text("No item selected"),
      )
          : ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text('${item.processus}'),
      ),
    );
  }
  Widget _customPopupItemBuilderProcessus(
      BuildContext context, ProcessusModel? item, bool isSelected) {
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
        title: Text(item?.processus ?? ''),
        subtitle: Text(item?.codeProcessus.toString() ?? ''),
      ),
    );
  }
  Future<List<ProcessusModel>> getProcessus(filter) async {
    try {
      List<ProcessusModel> processusList = await List<ProcessusModel>.empty(growable: true);
      List<ProcessusModel> processusFilter = await <ProcessusModel>[];
      var response = await actionService.readProcessus();
      response.forEach((data){
        setState(() {
          var model = ProcessusModel();
          model.codeProcessus = data['codeProcessus'];
          model.processus = data['processus'];
          processusList.add(model);
        });
      });
      processusFilter = processusList.where((u) {
        var name = u.codeProcessus.toString().toLowerCase();
        var description = u.processus!.toLowerCase();
        return name.contains(filter) ||
            description.contains(filter);
      }).toList();
      return processusFilter;
  } catch (exception) {
  ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
  return Future.error('service : ${exception.toString()}');
  }
  }

  //Direction
  Widget _customDropDownDirection(BuildContext context, DirectionModel? item) {
    if (item == null) {
      return Container();
    }
    return Container(
      child: (item.codeDirection == null)
          ? ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text("No item selected"),
      )
          : ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text('${item.direction}'),
      ),
    );
  }
  Widget _customPopupItemBuilderDirection(
      BuildContext context, DirectionModel? item, bool isSelected) {
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
        title: Text(item?.direction ?? ''),
        subtitle: Text(item?.codeDirection.toString() ?? ''),
      ),
    );
  }
  Future<List<DirectionModel>> getDirection(filter) async {
    try {
      List<DirectionModel> directionList = await List<DirectionModel>.empty(growable: true);
      List<DirectionModel> directionFilter = await <DirectionModel>[];
      var response = await actionService.readDirection();
      response.forEach((data){
        setState(() {
          var model = DirectionModel();
          model.codeDirection = data['codeDirection'];
          model.direction = data['direction'];
          directionList.add(model);
        });
      });
      directionFilter = directionList.where((u) {
        var name = u.codeDirection.toString().toLowerCase();
        var description = u.direction!.toLowerCase();
        return name.contains(filter) ||
            description.contains(filter);
      }).toList();
      return directionFilter;
  } catch (exception) {
  ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
  return Future.error('service : ${exception.toString()}');
  }
  }

  //Service
  Widget _customDropDownService(BuildContext context, ServiceModel? item) {
    if (item == null) {
      return Container();
    }
    return Container(
      child: (item.codeService == null)
          ? ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text("No item selected"),
      )
          : ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text('${item.service}'),
      ),
    );
  }
  Widget _customPopupItemBuilderService(
      BuildContext context, ServiceModel? item, bool isSelected) {
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
        title: Text(item?.service ?? ''),
        subtitle: Text(item?.codeService.toString() ?? ''),
      ),
    );
  }
  Future<List<ServiceModel>> getService(filter) async {
    if(selectedDirectionCode == null){
      Get.snackbar("No Data", "Please select Direction", colorText: Colors.blue, snackPosition: SnackPosition.BOTTOM);
    }
    try {

      List<ServiceModel> serviceList = await List<ServiceModel>.empty(growable: true);
      List<ServiceModel> serviceFilter = await List<ServiceModel>.empty(growable: true);

      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        var response = await actionService.readServiceByModuleAndDirection('Action', 'Action', selectedDirectionCode);
        print('response service : $response');
        response.forEach((data){
          setState(() {
            var model = ServiceModel();
            model.codeService = data['codeService'];
            model.service = data['service'];
            model.codeDirection = data['codeDirection'];
            model.direction = data['direction'];
            serviceList.add(model);

          });
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
      await ApiServicesCall().getService(matricule, selectedDirectionCode, 'Action', 'Action').then((resp) async {
        resp.forEach((data) async {
          print('get service : ${data} ');
          var model = ServiceModel();
          model.codeService = data['code_service'];
          model.service = data['service'];
          serviceList.add(model);
        });
      }
          , onError: (err) {
            ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
          });
    }
       serviceFilter = await serviceList.where((u) {
         serviceFilter = List<ServiceModel>.empty(growable: true);
        var query = u.service!.toLowerCase();
        return query.contains(filter);
      }).toList();
      return serviceFilter;
      /* return serviceList.where((element) {
        final query = element.service!.toLowerCase();
        return query.contains(filter);
      }).toList();*/
  } catch (exception) {
  ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
  return Future.error('service : ${exception.toString()}');
  }
  }

  //Activity
  Widget _customDropDownActivity(BuildContext context, ActivityModel? item) {
    if (item == null) {
      return Container();
    }
    return Container(
      child: (item.codeDomaine == null)
          ? ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text("No item selected"),
      )
          : ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text('${item.domaine}'),
      ),
    );
  }
  Widget _customPopupItemBuilderActivity(
      BuildContext context, ActivityModel? item, bool isSelected) {
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
        title: Text(item?.domaine ?? ''),
        subtitle: Text(item?.codeDomaine.toString() ?? ''),
      ),
    );
  }
  Future<List<ActivityModel>> getActivity(filter) async {
    try {
      List<ActivityModel> activityList = await List<ActivityModel>.empty(growable: true);
      List<ActivityModel> activityFilter = await <ActivityModel>[];
      var response = await actionService.readActivity();
      response.forEach((data){
        setState(() {
          var model = ActivityModel();
          model.codeDomaine = data['codeDomaine'];
          model.domaine = data['domaine'];
          activityList.add(model);
        });
      });
      activityFilter = activityList.where((u) {
        var name = u.codeDomaine.toString().toLowerCase();
        var description = u.domaine!.toLowerCase();
        return name.contains(filter) ||
            description.contains(filter);
      }).toList();
      return activityFilter;
  } catch (exception) {
  ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
  return Future.error('service : ${exception.toString()}');
  }
  }

  //Resp Cloture
  Widget _customDropDownRespCloture(BuildContext context, RespClotureModel? item) {
    if (item == null) {
      return Container();
    }
    return Container(
      child: (item.mat == null)
          ? ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text("No item selected"),
      )
          : ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text('${item.nompre}'),
      ),
    );
  }
  Widget _customPopupItemBuilderRespCloture(
      BuildContext context, RespClotureModel? item, bool isSelected) {
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
        title: Text(item?.nompre ?? ''),
        subtitle: Column(
          children: [
            Text(item?.site.toString() ?? ''),
            Text(item?.processus.toString() ?? '')
          ],
        ),
      ),
    );
  }
  Future<List<RespClotureModel>> getRespCloture(filter) async {
    try {
        if(selectedSiteCode == null || selectedProcessusCode == null){
          Get.snackbar("No Data", "Please select Site and Processus", colorText: Colors.blue, snackPosition: SnackPosition.BOTTOM);
        }
        List<RespClotureModel> respClotureList = await List<RespClotureModel>.empty(growable: true);
        List<RespClotureModel> respClotureFilter = await <RespClotureModel>[];
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
          Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
          var response = await actionService.readResponsableClotureParams(selectedSiteCode, selectedProcessusCode);
          //var response = await actionService.readResponsableCloture();
          response.forEach((data){
            setState(() {
              var model = RespClotureModel();
              model.mat = data['mat'];
              model.nompre = data['nompre'];
              model.codeSite = data['codeSite'];
              model.codeProcessus = data['codeProcessus'];
              model.site = data['site'];
              model.processus = data['processus'];
              respClotureList.add(model);
            });
          });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

          await ApiServicesCall().getResponsableCloture({
            "codesite": selectedSiteCode,
            "codeprocessus": selectedProcessusCode
          }).then((resp) async {
            resp.forEach((data) async {
              var model = RespClotureModel();
              model.mat = data['mat'];
              model.nompre = data['nompre'];
              model.codeSite = data['codeSite'];
              model.codeProcessus = data['codeProcessus'];
              model.site = data['site'];
              model.processus = data['processus'];
              respClotureList.add(model);
            });
          }
            , onError: (err) {
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });
      }

      respClotureFilter = respClotureList.where((u) {
        var name = u.nompre.toString().toLowerCase();
        var description = u.mat!.toLowerCase();
        return name.contains(filter) ||
            description.contains(filter);
      }).toList();
      return respClotureFilter;
    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }

  //Employe
  Widget _customDropDownEmploye(BuildContext context, EmployeModel? item) {
    if (item == null) {
      return Container();
    }
    return Container(
      child: (item.mat == null)
          ? ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text("No item selected"),
      )
          : ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text('${item.nompre}'),
      ),
    );
  }
  Widget _customPopupItemBuilderEmploye(
      BuildContext context, EmployeModel? item, bool isSelected) {
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
        title: Text(item?.nompre ?? ''),
        subtitle: Text(item?.mat.toString() ?? ''),
      ),
    );
  }
  Future<List<EmployeModel>> getEmploye(filter) async {
    try {
      List<EmployeModel> employeList = await List<EmployeModel>.empty(growable: true);
      List<EmployeModel>employeFilter = await List<EmployeModel>.empty(growable: true);
      var response = await actionService.readEmploye();
      response.forEach((data){
        setState(() {
          var model = EmployeModel();
          model.mat = data['mat'];
          model.nompre = data['nompre'];
          employeList.add(model);
        });
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
 
}
