import 'package:connectivity/connectivity.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:qualipro_flutter/Models/audit/audit_model.dart';
import 'package:qualipro_flutter/Models/audit/critere_checklist_audit_model.dart';
import 'package:qualipro_flutter/Services/audit/audit_service.dart';
import '../../../Models/action/type_action_model.dart';
import '../../../Models/audit/auditeur_model.dart';
import '../../../Models/audit/champ_audit_model.dart';
import '../../../Models/audit/check_list_model.dart';
import '../../../Models/audit/type_audit_model.dart';
import '../../../Models/employe_model.dart';
import '../../../Models/gravite_model.dart';
import '../../../Models/pnc/isps_pnc_model.dart';
import '../../../Services/action/local_action_service.dart';
import '../../../Services/api_services_call.dart';
import '../../../Services/audit/local_audit_service.dart';
import '../../../Utils/custom_colors.dart';
import '../../../Utils/shared_preference.dart';
import '../../../Utils/snack_bar.dart';
import '../../../Validators/validator.dart';

class CritereCheckListPage extends StatefulWidget {
  final CheckListModel modelCheckList;
  final AuditModel modelAudit;
  const CritereCheckListPage({Key? key,  required this.modelCheckList, required this.modelAudit}) : super(key: key);

  @override
  State<CritereCheckListPage> createState() => _CritereCheckListPageState();
}

class _CritereCheckListPageState extends State<CritereCheckListPage> {
  final matricule = SharedPreference.getMatricule();
  bool isProcessing = false;
  List<CritereChecklistAuditModel> listCritereChecklist = List<CritereChecklistAuditModel>.empty(growable: true);
  List<TextEditingController> controllersCritere = List.empty(growable: true);
  List<TextEditingController> controllersCommentaire = List.empty(growable: true);
  String? critere = "0";
  int? eval = 0;
  ISPSPNCModel? evaluationModel = null;
  bool isExtended = false;
  int? validation_constat = 0;
  bool enableValidationConstat = true;
  int? idCritere = 0;

  void getData() async {
    try {
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        Get.defaultDialog(
            title: 'mode_offline'.tr,
            backgroundColor: Colors.white,
            titleStyle: TextStyle(color: Colors.black),
            middleTextStyle: TextStyle(color: Colors.white),
            textCancel: "Back",
            onCancel: (){
              Get.back();
            },
            confirmTextColor: Colors.white,
            buttonColor: Colors.blue,
            barrierDismissible: false,
            radius: 20,
            content: Center(
              child: Column(
                children: <Widget>[
                  Lottie.asset('assets/images/empty_list.json', width: 150, height: 150),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('no_internet'.tr,
                        style: TextStyle(color: Colors.blueGrey, fontSize: 20)),
                  ),
                ],
              ),
            )
        );
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        //rest api
        await AuditService().getCritereOfCheckList(widget.modelAudit.refAudit, widget.modelCheckList.codeChamp).then((resp) async {
          //isDataProcessing(false);
          resp.forEach((data) async {
            setState(() {
              var model = CritereChecklistAuditModel();
              model.idCrit = data['id_crit'];
              model.critere = data['critere'];
              model.evaluation = data['evaluation'];
              model.commentaire = data['commentaire'];
              listCritereChecklist.add(model);
              for(var i=0; i<listCritereChecklist.length; i++) {
                controllersCommentaire.add(new TextEditingController());
                controllersCommentaire[i].text = listCritereChecklist[i].commentaire.toString();
                idCritere = listCritereChecklist[i].idCrit;
                print('id critere : $idCritere');
              }
            });
          });
        }
            , onError: (err) {
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });
      }
    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    }
    finally {
      //isDataProcessing(false);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
    getAuditeurInterne();
    getEmployeHabilite();
    getAuditByRefAudit();
    getMaxConstatAudit();
  }

  List<AuditeurModel> listAuditeurInterne = List<AuditeurModel>.empty(growable: true);
  List<EmployeModel> listEmployeHabilite = List<EmployeModel>.empty(growable: true);
  bool presentAuditeurInterne = false;
  bool presentEmployeHabilite = false;
  void getAuditeurInterne() async {
    try {
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        Get.defaultDialog(
            title: 'mode_offline'.tr,
            backgroundColor: Colors.white,
            titleStyle: TextStyle(color: Colors.black),
            middleTextStyle: TextStyle(color: Colors.white),
            textCancel: "Back",
            onCancel: (){
              Get.back();
            },
            confirmTextColor: Colors.white,
            buttonColor: Colors.blue,
            barrierDismissible: false,
            radius: 20,
            content: Center(
              child: Column(
                children: <Widget>[
                  Lottie.asset('assets/images/empty_list.json', width: 150, height: 150),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('no_internet'.tr,
                        style: TextStyle(color: Colors.blueGrey, fontSize: 20)),
                  ),
                ],
              ),
            )
        );
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        //rest api
        await AuditService().getAuditeurInterne(widget.modelAudit.refAudit).then((response) async {
          //isDataProcessing(false);
          response.forEach((data) async {
            setState(() {
              var model = AuditeurModel();
              model.mat = data['mat'];
              model.nompre = data['nomPre'];
              model.affectation = data['affectation'];
              listAuditeurInterne.add(model);

              if(matricule == data['mat']) {
                setState(() {
                  presentEmployeHabilite = true;
                  if(kDebugMode) print('$matricule is present in the list AuditeurInterne : $presentEmployeHabilite');
                });
              }
            });
          });
        }
            , onError: (err) {
              ShowSnackBar.snackBar("Error Auditeur interne", err.toString(), Colors.red);
            });
      }
    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    }
    finally {
      //isDataProcessing(false);
    }
  }
  void getEmployeHabilite() async {
    try {
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        Get.defaultDialog(
            title: 'mode_offline'.tr,
            backgroundColor: Colors.white,
            titleStyle: TextStyle(color: Colors.black),
            middleTextStyle: TextStyle(color: Colors.white),
            textCancel: "Back",
            onCancel: (){
              Get.back();
            },
            confirmTextColor: Colors.white,
            buttonColor: Colors.blue,
            barrierDismissible: false,
            radius: 20,
            content: Center(
              child: Column(
                children: <Widget>[
                  Lottie.asset('assets/images/empty_list.json', width: 150, height: 150),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('no_internet'.tr,
                        style: TextStyle(color: Colors.blueGrey, fontSize: 20)),
                  ),
                ],
              ),
            )
        );
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        //rest api
        await AuditService().getEmployeHabiliteAudit(widget.modelAudit.refAudit).then((response) async {
          response.forEach((element) {
            setState(() {
              var employe = new EmployeModel();
              employe.mat = element['mat'];
              employe.nompre = element['nompre'];
              listEmployeHabilite.add(employe);

              if(matricule == element['mat']) {
                setState(() {
                  presentEmployeHabilite = true;
                  if(kDebugMode) print('$matricule is present in the list EmployeHabilite : $presentEmployeHabilite');
                });
              }
            });
          });
        },
            onError: (error){
              ShowSnackBar.snackBar('Error employe habilité', error.toString(), Colors.red);
            });
      }
    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    }
    finally {
      //isDataProcessing(false);
    }
  }

  Future<void> getAuditByRefAudit() async {
    try {
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        Get.defaultDialog(
            title: 'mode_offline'.tr,
            backgroundColor: Colors.white,
            titleStyle: TextStyle(color: Colors.black),
            middleTextStyle: TextStyle(color: Colors.white),
            textCancel: "Back",
            onCancel: (){
              Get.back();
            },
            confirmTextColor: Colors.white,
            buttonColor: Colors.blue,
            barrierDismissible: false,
            radius: 20,
            content: Center(
              child: Column(
                children: <Widget>[
                  Lottie.asset('assets/images/empty_list.json', width: 150, height: 150),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('no_internet'.tr,
                        style: TextStyle(color: Colors.blueGrey, fontSize: 20)),
                  ),
                ],
              ),
            )
        );
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        await AuditService().getAuditByRefAudit(widget.modelAudit.refAudit)
            .then((value) async {
          var model = AuditModel();
          model.refAudit = value['refAudit'];
          model.audit = value['audit'];
          model.etat = value['etat'];
          model.validation = value['validation'];
          model.idAudit = value['idaudit'];

          if(kDebugMode) print('audit details : ${model.refAudit} - ${model.audit} - etat: ${model.etat} - validation: ${model.validation}');
          setState(() {
            validation_constat = value['validation'];
            //enable/disable critere checklist
            if(validation_constat == 3){
              enableValidationConstat = false;
            }
            else {
              enableValidationConstat = true;
            }
          });
        },
        onError: (error){
          ShowSnackBar.snackBar('Error Audit Details', error.toString(), Colors.red);
        }
        );
       }
    }
    catch(exception){
      ShowSnackBar.snackBar('Exception Audit Details', exception.toString(), Colors.red);
    }
  }

  int? maxConstatAudit;
  void getMaxConstatAudit() async {
    try {
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none){
        ShowSnackBar.snackBar('Mode Offline', 'No Internet Connection', Colors.red);
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile){
        await AuditService().getMaxConstatAudit().then((response){
          setState(() {
            maxConstatAudit = response['maxActAudit'];
            if(kDebugMode) print('maxConstatAudit : $maxConstatAudit');
          });
        },
            onError: (error){
              ShowSnackBar.snackBar('Error Max Constat : ', error.toString(), Colors.redAccent);
            });
      }
    }
    catch(Exception){
      ShowSnackBar.snackBar("Exception Max Constat", Exception.toString(), Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Champ : ${widget.modelCheckList.champ}', style: TextStyle(color: Colors.blue, fontSize: 15),),
      leading: TextButton(
        onPressed: (){
          Get.back();
        },
        child: Icon(Icons.arrow_back, color: Colors.blue, size: 40,),
      ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: listCritereChecklist.isNotEmpty
        ? ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: 3.0),
            shrinkWrap: true,
          itemCount: listCritereChecklist.length,
            itemBuilder: (context, index){

            controllersCritere.add(new TextEditingController());
            controllersCritere[index].text = listCritereChecklist[index].critere.toString();
            //controllersCommentaire.add(new TextEditingController());
            //controllersCommentaire[index].text = listCritereChecklist[index].commentaire.toString();
            eval = listCritereChecklist[index].evaluation;

               return Card(
                 elevation: 5.0,
                 color: Color(0xFEFEFEFE),
                 shadowColor: Color(0xFFDEF1EF),
                 child: ListTile(
                   title: TextFormField(
                     enabled: (presentAuditeurInterne || presentEmployeHabilite) && enableValidationConstat,
                     controller: controllersCritere[index],
                     keyboardType: TextInputType.text,
                     textInputAction: TextInputAction.next,
                     //initialValue: listCheckList[index].commentaire,
                     decoration: InputDecoration(
                         labelText: 'Critère',
                         hintText: 'Critère',
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
                     minLines: 2,
                     maxLines: 7,
                   ),
                   subtitle: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: <Widget>[
                       Padding(
                         padding: const EdgeInsets.only(top: 10, bottom: 10),
                         child: DropdownSearch<ISPSPNCModel>(
                           enabled: (presentAuditeurInterne || presentEmployeHabilite) && enableValidationConstat,
                           showSelectedItems: true,
                           showClearButton: true,
                           showSearchBox: false,
                           isFilteredOnline: true,
                           mode: Mode.DIALOG,
                           compareFn: (i, s) => i?.isEqual(s) ?? false,
                           dropdownSearchDecoration: InputDecoration(
                             labelText: "Respect",
                             contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                             border: OutlineInputBorder(),
                           ),
                           onFind: (String? filter) => getRespect(filter),
                           onChanged: (data) {
                             evaluationModel = data;
                             critere = data?.value;
                             listCritereChecklist[index].evaluation = int.parse(critere.toString());
                             print('critere value :${critere}');
                          /*   setState(() {
                               evaluationModel = data;
                               critere = data?.value;
                               listCritereChecklist[index].evaluation = int.parse(critere.toString());
                               print('critere value :${critere}');
                             }); */
                           },
                           dropdownBuilder: _customDropDownRespect,
                           popupItemBuilder: _customPopupItemBuilderRespect,

                         ),
                       ),
                       TextFormField(
                         enabled: (presentAuditeurInterne || presentEmployeHabilite) && enableValidationConstat,
                         controller: controllersCommentaire[index],
                         keyboardType: TextInputType.text,
                         textInputAction: TextInputAction.next,
                         //initialValue: listCheckList[index].commentaire,
                         decoration: InputDecoration(
                             labelText: 'Commentaire',
                             hintText: 'Commentaire',
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
                         minLines: 2,
                         maxLines: 5,
                       )
                     ],
                   ),
                   trailing: Visibility(
                     visible: (presentAuditeurInterne || presentEmployeHabilite) && enableValidationConstat,
                     child: Tooltip(
                       message: 'Ajouter Constat',
                       child: IconButton(
                         onPressed: (){
                           //----------------------Add Constat-----------------------------
                           final _addItemFormKey = GlobalKey<FormState>();
                           //ChampAuditModel? champAuditModel = null;
                           //int? selectedChampAuditCode = 0;
                           TypeAuditModel? constatAuditModel = null;
                           int? selectedTypeConstat = 0;
                           GraviteModel? graviteModel = null;
                           int? selectedNGravite = 0;
                           EmployeModel? employeModel = null;
                           String? selectedMatriculeEmploye = "";
                           int? selectedCodeTypeAct = 0;
                           TypeActionModel? typeActionModel = null;

                           TextEditingController objectController = TextEditingController();
                           TextEditingController  descriptionController = TextEditingController();
                           bool isVisibleEmploye = false;
                           bool isVisiblePersonneConcerne = true;
                           DateTime dateNow = DateTime.now();
                           TextEditingController  delaiRealController = TextEditingController();
                           objectController.text = controllersCritere[index].text;
                           delaiRealController.text = DateFormat('yyyy-MM-dd').format(dateNow);

                           selectedDateReal(BuildContext context) async {
                             dateNow = (await showDatePicker(
                                 context: context,
                                 initialDate: dateNow,
                                 firstDate: DateTime(2021),
                                 lastDate: DateTime(2100)
                               //lastDate: DateTime.now()
                             ))!;
                             if(dateNow != null){
                               delaiRealController.text = DateFormat('yyyy-MM-dd').format(dateNow);
                             }
                           }
                           //type constat
                           Future<List<TypeAuditModel>> getTypeConstat(filter) async {
                             try {
                               List<TypeAuditModel> _typeList = await List<TypeAuditModel>.empty(growable: true);
                               List<TypeAuditModel> _typeFilter = await List<TypeAuditModel>.empty(growable: true);
                               var connection = await Connectivity().checkConnectivity();
                               if(connection == ConnectivityResult.none) {
                                 //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

                                 var response = await LocalAuditService().readTypeConstatAudit();
                                 response.forEach((data){
                                   var model = TypeAuditModel();
                                   model.codeType = data['codeType'];
                                   model.type = data['type'];
                                   _typeList.add(model);
                                 });
                               }
                               else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
                                 //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

                                 await AuditService().getTypeConstatAudit().then((resp) async {
                                   resp.forEach((data) async {
                                     var model = TypeAuditModel();
                                     model.codeType = data['codeTypeE'];
                                     model.type = data['typeE'];
                                     _typeList.add(model);
                                   });
                                 }
                                     , onError: (err) {
                                       ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
                                     });
                               }
                               _typeFilter = _typeList.where((u) {
                                 var query = u.type!.toLowerCase();
                                 return query.contains(filter);
                               }).toList();
                               return _typeFilter;

                             } catch (exception) {
                               ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
                               return Future.error('service : ${exception.toString()}');
                             }
                           }
                           Widget _customDropDownTypeConstat(BuildContext context, TypeAuditModel? item) {
                             if (item == null) {
                               return Container();
                             }
                             else{
                               return Container(
                                 child: ListTile(
                                   contentPadding: EdgeInsets.all(0),
                                   title: Text('${item.type}'),
                                 ),
                               );
                             }
                           }
                           Widget _customPopupItemBuilderTypeConstat(
                               BuildContext context,TypeAuditModel item, bool isSelected) {
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
                                 title: Text(item.type ?? ''),
                               ),
                             );
                           }
                           //gravite
                           Future<List<GraviteModel>> getGravite(filter) async {
                             try {
                               List<GraviteModel> _list = await List<GraviteModel>.empty(growable: true);
                               List<GraviteModel> _filter = await List<GraviteModel>.empty(growable: true);
                               var connection = await Connectivity().checkConnectivity();
                               if(connection == ConnectivityResult.none) {
                                 //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
                                 var response = await LocalAuditService().readGraviteAudit();
                                 response.forEach((data){
                                   var model = GraviteModel();
                                   model.codegravite = data['codegravite'];
                                   model.gravite = data['gravite'];
                                   _list.add(model);
                                 });
                               }
                               else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
                                 //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

                                 await AuditService().getGraviteAudit().then((resp) async {
                                   resp.forEach((data) async {
                                     var model = GraviteModel();
                                     model.codegravite = data['nGravite'];
                                     model.gravite = data['gravite'];
                                     _list.add(model);
                                   });
                                 }
                                     , onError: (err) {
                                       ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
                                     });
                               }
                               _filter = _list.where((u) {
                                 var query = u.gravite!.toLowerCase();
                                 return query.contains(filter);
                               }).toList();
                               return _filter;

                             } catch (exception) {
                               ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
                               return Future.error('service : ${exception.toString()}');
                             }
                           }
                           Widget _customDropDownGravite(BuildContext context, GraviteModel? item) {
                             if (item == null) {
                               return Container();
                             }
                             else{
                               return Container(
                                 child: ListTile(
                                   contentPadding: EdgeInsets.all(0),
                                   title: Text('${item.gravite}'),
                                 ),
                               );
                             }
                           }
                           Widget _customPopupItemBuilderGravite(
                               BuildContext context,GraviteModel item, bool isSelected) {
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
                                 title: Text(item.gravite ?? ''),
                               ),
                             );
                           }
                           //Employe
                           Future<List<EmployeModel>> getPersonneConcerne(filter) async {
                             try {
                               List<EmployeModel> employeList = await List<EmployeModel>.empty(growable: true);
                               List<EmployeModel>employeFilter = await List<EmployeModel>.empty(growable: true);

                               var connection = await Connectivity().checkConnectivity();
                               if(connection == ConnectivityResult.none) {
                                 //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
                                 var response = await LocalActionService().readEmploye();
                                 response.forEach((data){
                                   var model = EmployeModel();
                                   model.mat = data['mat'];
                                   model.nompre = data['nompre'];
                                   employeList.add(model);
                                 });
                               }
                               else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
                                 //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
                                 await AuditService().getPersonConstatAudit(widget.modelAudit.refAudit, '') //getPersonConstatAudit(widget.numFiche, matricule)
                                     .then((response) async {
                                   response.forEach((data) async {
                                     var model = EmployeModel();
                                     model.mat = data['mat'];
                                     model.nompre = data['nompre'];
                                     employeList.add(model);
                                   });
                                 }
                                     , onError: (err) {
                                       ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
                                     });
                               }
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
                           Future<List<EmployeModel>> getEmploye(filter) async {
                             try {
                               List<EmployeModel> employeList = await List<EmployeModel>.empty(growable: true);
                               List<EmployeModel>employeFilter = await List<EmployeModel>.empty(growable: true);

                               var connection = await Connectivity().checkConnectivity();
                               if(connection == ConnectivityResult.none) {
                                 //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
                                 var response = await LocalActionService().readEmploye();
                                 response.forEach((data){
                                   var model = EmployeModel();
                                   model.mat = data['mat'];
                                   model.nompre = data['nompre'];
                                   employeList.add(model);
                                 });
                               }
                               else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
                                 //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
                                 await ApiServicesCall().getEmploye({
                                   "act": "",
                                   "lang": ""
                                 }).then((response) async {
                                   response.forEach((data) async {
                                     var model = EmployeModel();
                                     model.mat = data['mat'];
                                     model.nompre = data['nompre'];
                                     employeList.add(model);
                                   });
                                 }
                                     , onError: (err) {
                                       ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
                                     });
                               }
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
                           Widget _customDropDownEmploye(BuildContext context, EmployeModel? item) {
                             if (item == null) {
                               return Container();
                             }
                             else{
                               return Container(
                                 child: ListTile(
                                   contentPadding: EdgeInsets.all(0),
                                   title: Text('${item.nompre}'),
                                 ),
                               );
                             }
                           }
                           Widget _customPopupItemBuilderEmploye(
                               BuildContext context,EmployeModel item, bool isSelected) {
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
                               ),
                             );
                           }
                           //champ audit
                           Future<List<ChampAuditModel>> getChampAuditByFiche(filter) async {
                             try {
                               List<ChampAuditModel> listType = await List<ChampAuditModel>.empty(growable: true);
                               List<ChampAuditModel> filterType = await List<ChampAuditModel>.empty(growable: true);
                               var connection = await Connectivity().checkConnectivity();
                               if(connection == ConnectivityResult.none){
                                 Get.snackbar("Mode Offline", "No Internet Connexion");
                               }
                               else if(connection == ConnectivityResult.mobile || connection == ConnectivityResult.wifi){
                                 await AuditService().getChampAuditByFiche(widget.modelAudit.refAudit).then((resp) async {
                                   resp.forEach((element) async {
                                     var model = ChampAuditModel();
                                     model.codeChamp = element['codeChamp'];
                                     model.champ = element['champ'];
                                     model.criticite = element['criticite'];
                                     listType.add(model);
                                   });
                                 }
                                     , onError: (err) {
                                       ShowSnackBar.snackBar("Error type audit", err.toString(), Colors.red);
                                     });
                               }
                               filterType = listType.where((u) {
                                 var code = u.codeChamp.toString().toLowerCase();
                                 var description = u.champ!.toLowerCase();
                                 return code.contains(filter) ||
                                     description.contains(filter);
                               }).toList();
                               return filterType;
                             }
                             catch(Exception) {
                               if(kDebugMode){
                                 print('exception type audit : ${Exception.toString()}');
                               }
                               ShowSnackBar.snackBar("Exception type audit", Exception.toString(), Colors.red);
                               return Future.error('service : ${Exception.toString()}');
                             }
                           }
                           Widget _customDropDownChampAudit(BuildContext context, ChampAuditModel? item) {
                             if (item == null) {
                               return Container(
                                 child: ListTile(
                                   contentPadding: EdgeInsets.all(0),
                                   title: Text('${widget.modelCheckList.champ}'),
                                 ),
                               );
                             }
                             else{
                               return Container(
                                 child: ListTile(
                                   contentPadding: EdgeInsets.all(0),
                                   title: Text('${item.champ}'),
                                 ),
                               );
                             }
                           }
                           Widget _customPopupItemBuilderChampAudit(
                               BuildContext context,ChampAuditModel item, bool isSelected) {
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
                                 title: Text(item.champ ?? ''),
                               ),
                             );
                           }
                           //type action
                           Future<List<TypeActionModel>> getTypeAction(filter) async {
                             try {
                               List<TypeActionModel> _typesList = await List<TypeActionModel>.empty(growable: true);
                               List<TypeActionModel> _typesFilter = await List<TypeActionModel>.empty(growable: true);
                               var connection = await Connectivity().checkConnectivity();
                               if(connection == ConnectivityResult.none) {
                                 //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
                                 var response = await LocalActionService().readTypeAction();
                                 response.forEach((data){
                                   var sourceModel = TypeActionModel();
                                   sourceModel.codetypeAct = data['codetypeAct'];
                                   sourceModel.typeAct = data['typeAct'];
                                   sourceModel.actSimpl = data['actSimpl'];
                                   sourceModel.analyseCause = data['analyseCause'];
                                   _typesList.add(sourceModel);
                                 });
                               }
                               else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
                                 //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
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
                           Widget _customDropDownType(BuildContext context, TypeActionModel? item) {
                             if (item == null) {
                               return Container();
                             }
                             else{
                               return Container(
                                 child: ListTile(
                                   contentPadding: EdgeInsets.all(0),
                                   title: Text('${item.typeAct}', style: TextStyle(color: Colors.black),),
                                 ),
                               );
                             }
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
                                 initialChildSize: 0.9,
                                 maxChildSize: 0.9,
                                 minChildSize: 0.6,
                                 builder: (context, scrollController) => SingleChildScrollView(
                                   child: StatefulBuilder(
                                     builder: (BuildContext context, StateSetter setState){
                                       return ListBody(
                                         children: <Widget>[
                                           SizedBox(height: 5.0,),
                                           const Center(
                                             child: Text('Ajouter Constat', style: TextStyle(
                                                 fontWeight: FontWeight.w500,
                                                 color: Color(0xFF0769D2), fontSize: 30.0
                                             ),),
                                           ),
                                           SizedBox(height: 10.0,),
                                           Form(
                                             key: _addItemFormKey,
                                             child: Padding(
                                               padding: const EdgeInsets.all(10.0),
                                               child: Column(
                                                 children: [
                                                   Visibility(
                                                     visible: true,
                                                     child: TextFormField(
                                                       controller: objectController,
                                                       keyboardType: TextInputType.text,
                                                       textInputAction: TextInputAction.next,
                                                       decoration: InputDecoration(
                                                           labelText: 'Objet du constat *',
                                                           hintText: 'objet',
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
                                                       validator: (value) => Validator.validateField(
                                                           value: value!
                                                       ),
                                                       style: TextStyle(fontSize: 14.0),
                                                     ),
                                                   ),
                                                   SizedBox(height: 10.0,),
                                                   Visibility(
                                                     visible: true,
                                                     child: TextFormField(
                                                       controller: descriptionController,
                                                       keyboardType: TextInputType.text,
                                                       textInputAction: TextInputAction.next,
                                                       decoration: InputDecoration(
                                                           labelText: 'Description du constat *',
                                                           hintText: 'Description',
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
                                                       validator: (value) => Validator.validateField(
                                                           value: value!
                                                       ),
                                                       style: TextStyle(fontSize: 14.0),
                                                     ),
                                                   ),
                                                   SizedBox(height: 10.0,),
                                                   DropdownSearch<ChampAuditModel>(
                                                     enabled: false,
                                                     showSelectedItems: true,
                                                     showClearButton: true,
                                                     showSearchBox: true,
                                                     isFilteredOnline: true,
                                                     compareFn: (i, s) => i?.isEqual(s) ?? false,
                                                     dropdownSearchDecoration: InputDecoration(
                                                       labelText: "Champ d'audit *",
                                                       contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                                       border: OutlineInputBorder(),
                                                     ),
                                                     onFind: (String? filter) => getChampAuditByFiche(filter),
                                                     onChanged: (data) {
                                                       //champAuditModel = data;
                                                       //selectedChampAuditCode = data?.codeChamp;
                                                      // print('champ audit: ${champAuditModel?.champ}, code : ${selectedChampAuditCode}');
                                                     },
                                                     dropdownBuilder: _customDropDownChampAudit,
                                                     popupItemBuilder: _customPopupItemBuilderChampAudit,
                                                   ),
                                                   SizedBox(height: 10,),
                                                   Visibility(
                                                       visible: true,
                                                       child: DropdownSearch<TypeActionModel>(
                                                         showSelectedItems: true,
                                                         showClearButton: true,
                                                         showSearchBox: true,
                                                         isFilteredOnline: true,
                                                         compareFn: (i, s) => i?.isEqual(s) ?? false,
                                                         dropdownSearchDecoration: InputDecoration(
                                                           labelText: "Type d'action recommandée *",
                                                           contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                                           border: OutlineInputBorder(),
                                                         ),
                                                         onFind: (String? filter) => getTypeAction(filter),
                                                         onChanged: (data) {
                                                           selectedCodeTypeAct = data?.codetypeAct;
                                                           typeActionModel = data;
                                                           if(typeActionModel == null){
                                                             selectedCodeTypeAct = 0;
                                                           }
                                                           print('type action: ${typeActionModel?.typeAct}, code: ${selectedCodeTypeAct}');
                                                         },
                                                         dropdownBuilder: _customDropDownType,
                                                         popupItemBuilder: _customPopupItemBuilderType,
                                                         validator: (u) =>
                                                         u == null ? "type d'action est obligatoire " : null,
                                                       )
                                                   ),
                                                   SizedBox(height: 10,),
                                                   DropdownSearch<TypeAuditModel>(
                                                     showSelectedItems: true,
                                                     showClearButton: true,
                                                     showSearchBox: true,
                                                     isFilteredOnline: true,
                                                     compareFn: (i, s) => i?.isEqual(s) ?? false,
                                                     dropdownSearchDecoration: InputDecoration(
                                                       labelText: "Type constat *",
                                                       contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                                       border: OutlineInputBorder(),
                                                     ),
                                                     onFind: (String? filter) => getTypeConstat(filter),
                                                     onChanged: (data) {

                                                       constatAuditModel = data;
                                                       selectedTypeConstat = data?.codeType;
                                                       print('type constat: ${constatAuditModel?.type}, num: ${selectedTypeConstat}');

                                                     },
                                                     dropdownBuilder: _customDropDownTypeConstat,
                                                     popupItemBuilder: _customPopupItemBuilderTypeConstat,
                                                     validator: (u) =>
                                                     u == null ? "type est obligatoire " : null,
                                                   ),
                                                   SizedBox(height: 10,),
                                                   DropdownSearch<GraviteModel>(
                                                     showSelectedItems: true,
                                                     showClearButton: true,
                                                     showSearchBox: true,
                                                     isFilteredOnline: true,
                                                     compareFn: (i, s) => i?.isEqual(s) ?? false,
                                                     dropdownSearchDecoration: InputDecoration(
                                                       labelText: "Gravite *",
                                                       contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                                       border: OutlineInputBorder(),
                                                     ),
                                                     onFind: (String? filter) => getGravite(filter),
                                                     onChanged: (data) {
                                                       graviteModel = data;
                                                       selectedNGravite = data?.codegravite;
                                                       print('gravite: ${graviteModel?.gravite}, num: ${selectedNGravite}');
                                                     },
                                                     dropdownBuilder: _customDropDownGravite,
                                                     popupItemBuilder: _customPopupItemBuilderGravite,
                                                     validator: (u) =>
                                                     u == null ? "Gravite est obligatoire " : null,
                                                   ),
                                                   SizedBox(height: 10,),
                                                   Visibility(
                                                     visible: isVisiblePersonneConcerne,
                                                     child: SingleChildScrollView(
                                                       scrollDirection: Axis.horizontal,
                                                       child: Row(
                                                         children: <Widget>[
                                                           SizedBox(
                                                             width: Get.width /1.4,
                                                             child: DropdownSearch<EmployeModel>(
                                                               showSelectedItems: true,
                                                               showClearButton: true,
                                                               showSearchBox: true,
                                                               isFilteredOnline: true,
                                                               compareFn: (i, s) => i?.isEqual(s) ?? false,
                                                               dropdownSearchDecoration: InputDecoration(
                                                                 labelText: "Personne concernée *",
                                                                 contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                                                 border: OutlineInputBorder(),
                                                               ),
                                                               onFind: (String? filter) => getPersonneConcerne(filter),
                                                               onChanged: (data) {

                                                                 employeModel = data;
                                                                 selectedMatriculeEmploye = data?.mat;
                                                                 print('personne concernée: ${employeModel?.nompre}, mat: ${selectedMatriculeEmploye}');

                                                               },
                                                               dropdownBuilder: _customDropDownEmploye,
                                                               popupItemBuilder: _customPopupItemBuilderEmploye,
                                                               validator: (u) =>
                                                               u == null ? "Personne concernée est obligatoire " : null,
                                                             ),
                                                           ),
                                                           SizedBox(width: 5,),
                                                           TextButton(onPressed: (){
                                                             setState(() {
                                                               isVisibleEmploye = true;
                                                               isVisiblePersonneConcerne = false;
                                                             });
                                                           },
                                                               child: Icon(Icons.person_add_alt_1, size: 30, color: Colors.blue,)
                                                           )
                                                         ],
                                                       ),
                                                     ),
                                                   ),
                                                   Visibility(
                                                     visible: isVisibleEmploye,
                                                     child: SingleChildScrollView(
                                                       scrollDirection: Axis.horizontal,
                                                       child: Row(
                                                         children: <Widget>[
                                                           SizedBox(
                                                             width: Get.width /1.4,
                                                             child: DropdownSearch<EmployeModel>(
                                                               showSelectedItems: true,
                                                               showClearButton: true,
                                                               showSearchBox: true,
                                                               isFilteredOnline: true,
                                                               compareFn: (i, s) => i?.isEqual(s) ?? false,
                                                               dropdownSearchDecoration: InputDecoration(
                                                                 labelText: "Employe",
                                                                 contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                                                 border: OutlineInputBorder(),
                                                               ),
                                                               onFind: (String? filter) => getEmploye(filter),
                                                               onChanged: (data) {

                                                                 employeModel = data;
                                                                 selectedMatriculeEmploye = data?.mat;
                                                                 print('personne concernée: ${employeModel?.nompre}, mat: ${selectedMatriculeEmploye}');

                                                               },
                                                               dropdownBuilder: _customDropDownEmploye,
                                                               popupItemBuilder: _customPopupItemBuilderEmploye,
                                                               validator: (u) =>
                                                               u == null ? "Personne concernée est obligatoire " : null,
                                                             ),
                                                           ),
                                                           SizedBox(width: 5,),
                                                           TextButton(onPressed: (){
                                                             setState(() {
                                                               isVisibleEmploye = false;
                                                               isVisiblePersonneConcerne = true;
                                                             });
                                                           },
                                                               child: Icon(Icons.west_outlined, size: 30, color: Color(
                                                                   0xFF1A6E84))
                                                           )
                                                         ],
                                                       ),
                                                     ),
                                                   ),
                                                   SizedBox(height: 10,),
                                                   TextFormField(
                                                     controller: delaiRealController,
                                                     keyboardType: TextInputType.text,
                                                     textInputAction: TextInputAction.next,
                                                     onChanged: (value){
                                                       selectedDateReal(context);
                                                     },
                                                     decoration: InputDecoration(
                                                         labelText: 'Delai realisation',
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
                                                             selectedDateReal(context);
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
                                                   SizedBox(height: 10,),
                                                   Row(
                                                     mainAxisAlignment: MainAxisAlignment.center,
                                                     children: [
                                                       ConstrainedBox(
                                                         constraints: BoxConstraints.tightFor(width: MediaQuery.of(context).size.width / 3, height: 50),
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
                                                       SizedBox(width: 10,),
                                                       ConstrainedBox(
                                                         constraints: BoxConstraints.tightFor(width: MediaQuery.of(context).size.width / 3, height: 50),
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
                                                               try {
                                                                 await AuditService().saveConstatAudit(
                                                                     {
                                                                       "refAud": widget.modelAudit.refAudit,
                                                                       "objetConstat": objectController.text,
                                                                       "descConstat": descriptionController.text,
                                                                       "typeConst": selectedCodeTypeAct,
                                                                       "matConcerne": selectedMatriculeEmploye,
                                                                       "typeEcart": selectedTypeConstat,
                                                                       "graviteConstat": selectedNGravite,
                                                                       "mat": matricule.toString(),
                                                                       "id": maxConstatAudit! + 1,
                                                                       "numAct": 0,
                                                                       "mode": "Ajout",
                                                                       "codeChamp": widget.modelCheckList.codeChamp,
                                                                       "idCritere": idCritere,
                                                                       "dealiReal": delaiRealController.text
                                                                     }
                                                                 ).then((resp) async {
                                                                   Get.back();
                                                                   ShowSnackBar.snackBar("Successfully", "Constat added", Colors.green);
                                                                   //Get.offAll(ActionIncidentSecuritePage(numFiche: widget.numFiche));

                                                                 }, onError: (err) {
                                                                   print('error : ${err.toString()}');
                                                                   ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
                                                                 });
                                                               }
                                                               catch (ex){
                                                                 print("Exception" + ex.toString());
                                                                 ShowSnackBar.snackBar("Exception", ex.toString(), Colors.red);
                                                                 throw Exception("Error " + ex.toString());
                                                               }
                                                             }
                                                           },
                                                         ),
                                                       )
                                                     ],
                                                   )

                                                 ],
                                               ),
                                             ),
                                           ),
                                         ],
                                       );
                                     },
                                   ),
                                 )
                             )
                           );
                         },
                         icon: Icon(Icons.my_library_add, color: Color(0xAE1243D5)),
                         iconSize: 30,
                         //tooltip: 'Ajouter Constat',
                       ),
                     ),
                   ),
                 ),
               );
            }
        )
        : Center(child: Text('empty_list'.tr, style: TextStyle(
      fontSize: 20.0,
          fontFamily: 'Brand-Bold'
      )),)
      ),
      floatingActionButton: FloatingActionButton.extended(

          onPressed: (presentAuditeurInterne || presentEmployeHabilite) && enableValidationConstat
            ? () async {
                 try {
                   for (var i=0; i< listCritereChecklist.length; i++){
                     print('checklist : ${listCritereChecklist[i].idCrit}-${listCritereChecklist[i].critere} -eval:${listCritereChecklist[i].evaluation} - comment:${controllersCommentaire[i].text}');
                     await AuditService().evaluerCritereOfCheckList({
                       "refAudit": widget.modelAudit.refAudit,
                       "idChamp": widget.modelCheckList.codeChamp,
                       "idCritere": listCritereChecklist[i].idCrit,
                       "evaluation": listCritereChecklist[i].evaluation,
                       "commentaire": controllersCommentaire[i].text
                     })
                         .then((response){
                       setState(() {
                         isProcessing = true;
                       });
                       //ShowSnackBar.snackBar("Successfully", "${listCritereChecklist[i].critere} Added ", Colors.green);
                     },
                         onError: (error){
                           setState(() {
                             isProcessing = false;
                           });
                           ShowSnackBar.snackBar('Error', error.toString(), Colors.red);
                         });
                   }
                 }
                 catch(exception){
                   ShowSnackBar.snackBar('exception', exception.toString(), Colors.red);
                 }
                 finally {
                   setState(() {
                     isProcessing = false;
                   });
                 }
          }
          : null,
          label: AnimatedSwitcher(
            duration: Duration(seconds: 1),
            transitionBuilder: (Widget child, Animation<double> animation) =>
                FadeTransition(
                  opacity: animation,
                  child: SizeTransition(child: child,
                    sizeFactor: animation,
                    axis: Axis.horizontal,
                  ),
                ) ,
            child: isExtended?
            Icon(Icons.arrow_forward):
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: isProcessing ? CircularProgressIndicator(color: Colors.white) : Icon(Icons.add, color: Colors.white,),
                ),
                Text(isProcessing ?"Processing" :"Valider", style: TextStyle(color: Colors.white),)
              ],
            ),
          )
      ),
    );
  }

  //evaluation
  Future<List<ISPSPNCModel>> getRespect(filter) async {
    try {
      List<ISPSPNCModel> evalList = [
        ISPSPNCModel(value: "0", name: "Non évalué"),
        ISPSPNCModel(value: "1", name: "CONFORME"),
        ISPSPNCModel(value: "2", name: "NON CONFORME")
      ];

      return evalList;
    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }
  Widget _customDropDownRespect(BuildContext context, ISPSPNCModel? item) {
    if (item == null) {
      String? message_evaluation = 'Non évalué';
      switch (eval) {
        case 0:
          message_evaluation = "Non évalué";
          break;
        case 1:
          message_evaluation = "CONFORME";
          break;
        case 2:
          message_evaluation = "NON CONFORME";
          break;
        default:
          message_evaluation = "";
      }
      return Container(
        child: Text('${message_evaluation}', style: TextStyle(color: Colors.black),),
      );
    }
    return Container(
      child: (item.name == null)
          ? ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text("No item selected"),
      )
          : ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text('${item.name}'),
      ),
    );
  }
  Widget _customPopupItemBuilderRespect(
      BuildContext context, ISPSPNCModel? item, bool isSelected) {
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
        title: Text(item?.name ?? ''),
        //subtitle: Text(item?.value.toString() ?? ''),
      ),
    );
  }
}
