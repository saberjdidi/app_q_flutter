import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:qualipro_flutter/Models/audit/audit_model.dart';
import 'package:qualipro_flutter/Services/audit/audit_service.dart';
import 'package:qualipro_flutter/Services/audit/local_audit_service.dart';
import 'package:qualipro_flutter/Services/visite_securite/visite_securite_service.dart';
import 'package:qualipro_flutter/Widgets/refresh_widget.dart';
import '../../../Controllers/api_controllers_call.dart';
import '../../../Controllers/audit/audit_controller.dart';
import '../../../Models/action/type_action_model.dart';
import '../../../Models/audit/auditeur_model.dart';
import '../../../Models/audit/champ_audit_model.dart';
import '../../../Models/audit/constat_audit_model.dart';
import '../../../Models/audit/type_audit_model.dart';
import '../../../Models/employe_model.dart';
import '../../../Models/gravite_model.dart';
import '../../../Services/action/local_action_service.dart';
import '../../../Services/api_services_call.dart';
import '../../../Utils/custom_colors.dart';
import '../../../Utils/shared_preference.dart';
import '../../../Utils/snack_bar.dart';
import '../../../Validators/validator.dart';

class ConstatAuditPage extends StatefulWidget {
  final AuditModel model;

  const ConstatAuditPage({Key? key, required this.model}) : super(key: key);

  @override
  State<ConstatAuditPage> createState() => _ConstatAuditPageState();
}

class _ConstatAuditPageState extends State<ConstatAuditPage> {
  //N° action : <nact> <br/> <a href="/action/listeaction.aspx?orig=mail&act=info&mode=info&nac=<nact>&usr=">Lien action</a>
  //N° action : <nact> <br/> <a href=/ action /listeaction.aspx ? orig = mail & act = info & mode = info & nac =< nact > &usr = >Lien action</a>

  final matricule = SharedPreference.getMatricule();
  List<ConstatAuditModel> listConstat =
      List<ConstatAuditModel>.empty(growable: true);
  List<AuditeurModel> listAuditeurInterne =
      List<AuditeurModel>.empty(growable: true);
  List<EmployeModel> listEmployeHabilite =
      List<EmployeModel>.empty(growable: true);
  int? userExistInAuditeurInterne;
  bool presentAuditeurInterne = false;
  int? userExistInEmployeHabilite;
  bool presentEmployeHabilite = false;
  bool enableButtonDeleteOffline = true;
  int? maxConstatAudit;

  String? mode = '';
  int? validation_constat = 0;
  bool enableValidationConstat = true;

  DateTime dateNow = DateTime.now();
  TextEditingController delaiRealController = TextEditingController();

  bool enableEnvoyerRapport = false;
  bool enableEnvoyerRapportOnline = false;

  @override
  void initState() {
    super.initState();
    getData();
    getAuditeurInterne();
    getEmployeHabilite();
    getMaxConstatAudit();
    delaiRealController.text = DateFormat('yyyy-MM-dd').format(dateNow);
  }

  void getAuditeurInterne() async {
    try {
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        var response = await LocalAuditService()
            .readAuditeurInterne(widget.model.refAudit);
        response.forEach((data) {
          setState(() {
            var model = AuditeurModel();
            model.refAudit = data['refAudit'];
            model.mat = data['mat'];
            model.nompre = data['nompre'];
            model.affectation = data['affectation'];
            listAuditeurInterne.add(model);
            if (matricule == data['mat']) {
              setState(() {
                presentAuditeurInterne = true;
                if (kDebugMode)
                  print(
                      '$matricule is present in the list AuditeurInterne : $presentAuditeurInterne');
              });
            }
          });
        });
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //rest api
        await AuditService().getAuditeurInterne(widget.model.refAudit).then(
            (response) async {
          //isDataProcessing(false);
          response.forEach((data) async {
            setState(() {
              var model = AuditeurModel();
              model.mat = data['mat'];
              model.nompre = data['nomPre'];
              model.affectation = data['affectation'];
              listAuditeurInterne.add(model);

              if (matricule == data['mat']) {
                setState(() {
                  presentAuditeurInterne = true;
                  if (kDebugMode)
                    print(
                        '$matricule is present in the list AuditeurInterne : $presentAuditeurInterne');
                });
              }
            });
          });
        }, onError: (err) {
          ShowSnackBar.snackBar(
              "Error Auditeur interne", err.toString(), Colors.red);
        });
      }
    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      //isDataProcessing(false);
    }
  }

  void getEmployeHabilite() async {
    try {
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        final response = await LocalAuditService()
            .readEmployeHabiliteAudit(widget.model.refAudit);
        response.forEach((element) {
          setState(() {
            var employe = new EmployeModel();
            employe.mat = element['mat'];
            employe.nompre = element['nompre'];
            listEmployeHabilite.add(employe);

            if (matricule == element['mat']) {
              setState(() {
                presentEmployeHabilite = true;
                if (kDebugMode)
                  print(
                      '$matricule is present in the list EmployeHabilite : $presentEmployeHabilite');
              });
            }
          });
        });
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //rest api
        await AuditService()
            .getEmployeHabiliteAudit(widget.model.refAudit)
            .then((response) async {
          response.forEach((element) {
            setState(() {
              var employe = new EmployeModel();
              employe.mat = element['mat'];
              employe.nompre = element['nompre'];
              listEmployeHabilite.add(employe);

              if (matricule == element['mat']) {
                setState(() {
                  presentEmployeHabilite = true;
                  if (kDebugMode)
                    print(
                        '$matricule is present in the list EmployeHabilite : $presentEmployeHabilite');
                });
              }

              /* if(listEmployeHabilite.contains(matricule)){
                setState(() {
                  userExistInEmployeHabilite = 1;
                  if(kDebugMode) print('userExist In EmployeHabilite 1 : $userExistInEmployeHabilite; matricule : $matricule');
                });
              }*/
            });
          });
        }, onError: (error) {
          ShowSnackBar.snackBar(
              'Error employe habilité', error.toString(), Colors.red);
        });
      }
    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      //isDataProcessing(false);
    }
  }

  void getData() async {
    try {
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        enableEnvoyerRapportOnline = false;
        enableButtonDeleteOffline = false;
        final response = await LocalAuditService()
            .readConstatAuditByRefAudit(widget.model.refAudit);
        response.forEach((data) {
          setState(() {
            validation_constat = widget.model.validation;
            if (kDebugMode) print('validation constat : $validation_constat');
            //enable/disable add constat use validation
            if (validation_constat == 3) {
              enableValidationConstat = false;
              enableEnvoyerRapport = false;
            } else if (validation_constat == 1) {
              enableValidationConstat = true;
              enableEnvoyerRapport = true;
            } else {
              enableValidationConstat = true;
              enableEnvoyerRapport = false;
            }
            var model = ConstatAuditModel();
            model.online = data['online'];
            model.refAudit = data['refAudit'];
            model.nact = data['nact'];
            model.idCrit = data['idCrit'];
            model.ngravite = data['ngravite'];
            model.codeTypeE = data['codeTypeE'];
            model.gravite = data['gravite'];
            model.typeE = data['typeE'];
            model.mat = data['mat'];
            model.nomPre = data['nomPre'];
            model.prov = data['prov'];
            model.idEcart = data['idEcart'];
            model.pr = data['pr'];
            model.ps = data['ps'];
            model.descPb = data['descPb'];
            model.act = data['act'];
            model.typeAct = data['typeAct'];
            model.sourceAct = data['sourceAct'];
            model.codeChamp = data['codeChamp'];
            model.champ = data['champ'];
            model.delaiReal = data['delaiReal'];
            listConstat.add(model);
          });
        });
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        enableButtonDeleteOffline = true;
        enableEnvoyerRapportOnline = true;
        await AuditService().getAuditByRefAudit(widget.model.refAudit).then(
            (value) async {
          var model = AuditModel();
          model.refAudit = value['refAudit'];
          model.audit = value['audit'];
          model.etat = value['etat'];
          model.validation = value['validation'];
          model.idAudit = value['idaudit'];

          if (kDebugMode)
            print(
                'audit details : ${model.refAudit} - ${model.audit} - etat: ${model.etat} - validation: ${model.validation}');
          setState(() {
            validation_constat = value['validation'];
            //enable/disable add constat use validation
            if (validation_constat == 3) {
              enableValidationConstat = false;
              enableEnvoyerRapport = false;
            } else if (validation_constat == 1) {
              enableValidationConstat = true;
              enableEnvoyerRapport = true;
            } else {
              enableValidationConstat = true;
              enableEnvoyerRapport = false;
            }
          });

          if (validation_constat == 1 || validation_constat == 2) {
            setState(() {
              mode = '%24_act_prov';
            });
          } else {
            setState(() {
              mode = '%24_act';
            });
          }

          //get constat
          await AuditService()
              .getConstatAudit(widget.model.refAudit, mode)
              .then((resp) async {
            //isDataProcessing(false);
            resp.forEach((data) async {
              setState(() {
                var model = ConstatAuditModel();
                model.refAudit = data['refAudit'];
                model.nact = data['nact'];
                model.ngravite = data['ngravite'];
                model.codeTypeE = data['codeTypeE'];
                model.gravite = data['gravite'];
                model.typeE = data['typeE'];
                model.mat = data['mat'];
                model.nomPre = data['nomPre'];
                model.idEcart = data['id_Ecart'];
                model.descPb = data['descPb'];
                model.act = data['act'];
                model.typeAct = data['typeAct'];
                model.sourceAct = data['sourceAct'];
                model.codeChamp = data['codeChamp'];
                model.champ = data['champ'];
                if (data['delaiReal'] == null) {
                  model.delaiReal = "";
                } else {
                  model.delaiReal = data['delaiReal'];
                }
                listConstat.add(model);
              });
            });
          }, onError: (err) {
            ShowSnackBar.snackBar("Error Constat", err.toString(), Colors.red);
          });
        }, onError: (error) {
          ShowSnackBar.snackBar(
              "Error audit details", error.toString(), Colors.red);
        });
      }
    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      //isDataProcessing(false);
    }
  }

  void getMaxConstatAudit() async {
    try {
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        int? max_audit_offline =
            await LocalAuditService().getMaxNumConstatAudit();
        setState(() {
          maxConstatAudit = max_audit_offline! + 1;
          print('maxConstatAudit : $maxConstatAudit');
        });
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        await AuditService().getMaxConstatAudit().then((response) {
          setState(() {
            int? max_audit_online = response['maxActAudit'];
            maxConstatAudit = max_audit_online! + 1;
            if (kDebugMode) print('maxConstatAudit : $maxConstatAudit');
          });
        }, onError: (error) {
          ShowSnackBar.snackBar(
              'Error Max Constat : ', error.toString(), Colors.redAccent);
        });
      }
    } catch (Exception) {
      if (kDebugMode) print('Exception : ${Exception.toString()}');
      ShowSnackBar.snackBar(
          "Exception Max Constat", Exception.toString(), Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color lightPrimary = Colors.white;
    const Color darkPrimary = Colors.white;
    final keyRefresh = GlobalKey<RefreshIndicatorState>();
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            lightPrimary,
            darkPrimary,
          ])),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: TextButton(
            onPressed: () {
              Get.back();
              //Get.find<AuditController>().listAudit.clear();
              //Get.find<AuditController>().getData();
              //Get.toNamed(AppRoute.audit);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.blue,
            ),
          ),
          title: Text(
            (validation_constat == 1 || validation_constat == 2)
                ? 'Constats ${'a_valider'.tr} Ref°${widget.model.refAudit}'
                : 'Constats Ref°${widget.model.refAudit}',
            style: TextStyle(color: Colors.black, fontSize: 15),
          ),
          backgroundColor: (lightPrimary),
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: listConstat.isNotEmpty
                ? RefreshWidget(
                    keyRefresh: keyRefresh,
                    onRefresh: () async {
                      setState(() {
                        listConstat.clear();
                        getData();
                      });
                    },
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Card(
                          color: Color(0xFFE9EAEE),
                          child: ListTile(
                            /* leading: Text(
                          '${listConstat[index].refAudit}',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.lightBlue),
                        ), */
                            title: Text(
                              '${'object'.tr} : ${listConstat[index].act} ${listConstat[index].online == 0 ? '*' : ''}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(
                                      'Description : ${listConstat[index].descPb}',
                                      style: TextStyle(
                                          color: (validation_constat == 1 ||
                                                  validation_constat == 2)
                                              ? Colors.red
                                              : Colors.blue,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                      '${'champ_audit'.tr} : ${listConstat[index].champ}',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                      '${'person_concerne'.tr} : ${listConstat[index].nomPre}',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                      'Type : ${listConstat[index].typeE}',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Text(
                                    '${'gravity'.tr} : ${listConstat[index].gravite}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            trailing: Visibility(
                              visible: (presentAuditeurInterne ||
                                      presentEmployeHabilite) &&
                                  enableValidationConstat &&
                                  enableButtonDeleteOffline,
                              child: InkWell(
                                  onTap: () {
                                    deleteData(
                                        context,
                                        listConstat[index].idEcart,
                                        listConstat[index].nact);
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  )),
                            ),
                          ),
                        );
                      },
                      itemCount: listConstat.length,
                      //itemCount: actionsList.length + 1,
                    ),
                  )
                : Center(
                    child: Text('empty_list'.tr,
                        style: TextStyle(
                            fontSize: 20.0, fontFamily: 'Brand-Bold')),
                  )),
        floatingActionButton: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Visibility(
              visible: (presentAuditeurInterne || presentEmployeHabilite) &&
                  enableEnvoyerRapport &&
                  enableEnvoyerRapportOnline,
              child: ConstrainedBox(
                constraints: BoxConstraints.tightFor(
                    width: MediaQuery.of(context).size.width / 1.8, height: 50),
                child: ElevatedButton.icon(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xDF0E6323)),
                    padding: MaterialStateProperty.all(EdgeInsets.all(14)),
                  ),
                  icon: Icon(Icons.send),
                  label: Text(
                    '${'send'.tr} ${'rapport'.tr}',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                  onPressed: () {
                    envoyerRapport();
                  },
                ),
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Visibility(
              visible: (presentAuditeurInterne || presentEmployeHabilite) &&
                  enableValidationConstat,
              child: FloatingActionButton(
                onPressed: () {
                  //----------------------Add Constat-----------------------------
                  final _addItemFormKey = GlobalKey<FormState>();
                  ChampAuditModel? champAuditModel = null;
                  int? selectedChampAuditCode = 0;
                  String? selectedChampAudit = '';
                  TypeAuditModel? constatAuditModel = null;
                  int? selectedTypeConstat = 0;
                  String? typeConstat = "";
                  GraviteModel? graviteModel = null;
                  int? selectedNGravite = 0;
                  String? gravite = "";
                  EmployeModel? employeModel = null;
                  String? selectedMatriculeEmploye = "";
                  String? selectedNompreEmploye = "";
                  int? selectedCodeTypeAct = 0;
                  TypeActionModel? typeActionModel = null;

                  TextEditingController objectController =
                      TextEditingController();
                  TextEditingController descriptionController =
                      TextEditingController();
                  bool isVisibleEmploye = false;
                  bool isVisiblePersonneConcerne = true;

                  selectedDateReal(BuildContext context) async {
                    dateNow = (await showDatePicker(
                        context: context,
                        initialDate: dateNow,
                        firstDate: DateTime(2021),
                        lastDate: DateTime(2100)
                        //lastDate: DateTime.now()
                        ))!;
                    if (dateNow != null) {
                      delaiRealController.text =
                          DateFormat('yyyy-MM-dd').format(dateNow);
                    }
                  }

                  //type constat
                  Future<List<TypeAuditModel>> getTypeConstat(filter) async {
                    try {
                      List<TypeAuditModel> _typeList =
                          await List<TypeAuditModel>.empty(growable: true);
                      List<TypeAuditModel> _typeFilter =
                          await List<TypeAuditModel>.empty(growable: true);
                      var connection = await Connectivity().checkConnectivity();
                      if (connection == ConnectivityResult.none) {
                        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

                        var response =
                            await LocalAuditService().readTypeConstatAudit();
                        response.forEach((data) {
                          var model = TypeAuditModel();
                          model.codeType = data['codeType'];
                          model.type = data['type'];
                          _typeList.add(model);
                        });
                      } else if (connection == ConnectivityResult.wifi ||
                          connection == ConnectivityResult.mobile) {
                        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

                        await AuditService().getTypeConstatAudit().then(
                            (resp) async {
                          resp.forEach((data) async {
                            var model = TypeAuditModel();
                            model.codeType = data['codeTypeE'];
                            model.type = data['typeE'];
                            _typeList.add(model);
                          });
                        }, onError: (err) {
                          ShowSnackBar.snackBar(
                              "Error", err.toString(), Colors.red);
                        });
                      }
                      _typeFilter = _typeList.where((u) {
                        var query = u.type!.toLowerCase();
                        return query.contains(filter);
                      }).toList();
                      return _typeFilter;
                    } catch (exception) {
                      ShowSnackBar.snackBar(
                          "Exception", exception.toString(), Colors.red);
                      return Future.error('service : ${exception.toString()}');
                    }
                  }

                  Widget _customDropDownTypeConstat(
                      BuildContext context, TypeAuditModel? item) {
                    if (item == null) {
                      return Container();
                    } else {
                      return Container(
                        child: ListTile(
                          contentPadding: EdgeInsets.all(0),
                          title: Text('${item.type}'),
                        ),
                      );
                    }
                  }

                  Widget _customPopupItemBuilderTypeConstat(
                      BuildContext context,
                      TypeAuditModel item,
                      bool isSelected) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      decoration: !isSelected
                          ? null
                          : BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context).primaryColor),
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
                      List<GraviteModel> _list =
                          await List<GraviteModel>.empty(growable: true);
                      List<GraviteModel> _filter =
                          await List<GraviteModel>.empty(growable: true);
                      var connection = await Connectivity().checkConnectivity();
                      if (connection == ConnectivityResult.none) {
                        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
                        var response =
                            await LocalAuditService().readGraviteAudit();
                        response.forEach((data) {
                          var model = GraviteModel();
                          model.codegravite = data['codegravite'];
                          model.gravite = data['gravite'];
                          _list.add(model);
                        });
                      } else if (connection == ConnectivityResult.wifi ||
                          connection == ConnectivityResult.mobile) {
                        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

                        await AuditService().getGraviteAudit().then(
                            (resp) async {
                          resp.forEach((data) async {
                            var model = GraviteModel();
                            model.codegravite = data['nGravite'];
                            model.gravite = data['gravite'];
                            _list.add(model);
                          });
                        }, onError: (err) {
                          ShowSnackBar.snackBar(
                              "Error", err.toString(), Colors.red);
                        });
                      }
                      _filter = _list.where((u) {
                        var query = u.gravite!.toLowerCase();
                        return query.contains(filter);
                      }).toList();
                      return _filter;
                    } catch (exception) {
                      ShowSnackBar.snackBar(
                          "Exception", exception.toString(), Colors.red);
                      return Future.error('service : ${exception.toString()}');
                    }
                  }

                  Widget _customDropDownGravite(
                      BuildContext context, GraviteModel? item) {
                    if (item == null) {
                      return Container();
                    } else {
                      return Container(
                        child: ListTile(
                          contentPadding: EdgeInsets.all(0),
                          title: Text('${item.gravite}'),
                        ),
                      );
                    }
                  }

                  Widget _customPopupItemBuilderGravite(BuildContext context,
                      GraviteModel item, bool isSelected) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      decoration: !isSelected
                          ? null
                          : BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context).primaryColor),
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
                      List<EmployeModel> employeList =
                          await List<EmployeModel>.empty(growable: true);
                      List<EmployeModel> employeFilter =
                          await List<EmployeModel>.empty(growable: true);

                      var connection = await Connectivity().checkConnectivity();
                      if (connection == ConnectivityResult.none) {
                        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
                        var response = await LocalActionService().readEmploye();
                        response.forEach((data) {
                          var model = EmployeModel();
                          model.mat = data['mat'];
                          model.nompre = data['nompre'];
                          employeList.add(model);
                        });
                      } else if (connection == ConnectivityResult.wifi ||
                          connection == ConnectivityResult.mobile) {
                        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
                        await AuditService()
                            .getPersonConstatAudit(widget.model.refAudit,
                                '') //getPersonConstatAudit(widget.numFiche, matricule)
                            .then((response) async {
                          response.forEach((data) async {
                            var model = EmployeModel();
                            model.mat = data['mat'];
                            model.nompre = data['nompre'];
                            employeList.add(model);
                          });
                        }, onError: (err) {
                          ShowSnackBar.snackBar(
                              "Error", err.toString(), Colors.red);
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
                      ShowSnackBar.snackBar(
                          "Exception", exception.toString(), Colors.red);
                      return Future.error('service : ${exception.toString()}');
                    }
                  }

                  Future<List<EmployeModel>> getEmploye(filter) async {
                    try {
                      List<EmployeModel> employeList =
                          await List<EmployeModel>.empty(growable: true);
                      List<EmployeModel> employeFilter =
                          await List<EmployeModel>.empty(growable: true);

                      var connection = await Connectivity().checkConnectivity();
                      if (connection == ConnectivityResult.none) {
                        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
                        var response = await LocalActionService().readEmploye();
                        response.forEach((data) {
                          var model = EmployeModel();
                          model.mat = data['mat'];
                          model.nompre = data['nompre'];
                          employeList.add(model);
                        });
                      } else if (connection == ConnectivityResult.wifi ||
                          connection == ConnectivityResult.mobile) {
                        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
                        await ApiServicesCall()
                            .getEmploye({"act": "", "lang": ""}).then(
                                (response) async {
                          response.forEach((data) async {
                            var model = EmployeModel();
                            model.mat = data['mat'];
                            model.nompre = data['nompre'];
                            employeList.add(model);
                          });
                        }, onError: (err) {
                          ShowSnackBar.snackBar(
                              "Error", err.toString(), Colors.red);
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
                      ShowSnackBar.snackBar(
                          "Exception", exception.toString(), Colors.red);
                      return Future.error('service : ${exception.toString()}');
                    }
                  }

                  Widget _customDropDownEmploye(
                      BuildContext context, EmployeModel? item) {
                    if (item == null) {
                      return Container();
                    } else {
                      return Container(
                        child: ListTile(
                          contentPadding: EdgeInsets.all(0),
                          title: Text('${item.nompre}'),
                        ),
                      );
                    }
                  }

                  Widget _customPopupItemBuilderEmploye(BuildContext context,
                      EmployeModel item, bool isSelected) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      decoration: !isSelected
                          ? null
                          : BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context).primaryColor),
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
                  Future<List<ChampAuditModel>> getChampAuditByFiche(
                      filter) async {
                    try {
                      List<ChampAuditModel> listType =
                          await List<ChampAuditModel>.empty(growable: true);
                      List<ChampAuditModel> filterType =
                          await List<ChampAuditModel>.empty(growable: true);
                      var connection = await Connectivity().checkConnectivity();
                      if (connection == ConnectivityResult.none) {
                        //var response = await LocalAuditService().readChampAuditConstatByRefAudit(widget.model.refAudit);
                        var response = await LocalAuditService()
                            .readChampAuditOfConstat(
                                widget.model.refAudit.toString());
                        response.forEach((element) {
                          print('element champ audit : ${element['champ']}');
                          var model = ChampAuditModel();
                          model.codeChamp = element['codeChamp'];
                          model.champ = element['champ'];
                          model.criticite = element['criticite'];
                          //model.refAudit = element['refAudit'];
                          listType.add(model);
                        });
                      } else if (connection == ConnectivityResult.mobile ||
                          connection == ConnectivityResult.wifi) {
                        await AuditService()
                            .getChampAuditByFiche(widget.model.refAudit)
                            .then((resp) async {
                          resp.forEach((element) async {
                            var model = ChampAuditModel();
                            model.codeChamp = element['codeChamp'];
                            model.champ = element['champ'];
                            model.criticite = element['criticite'];
                            listType.add(model);
                          });
                        }, onError: (err) {
                          ShowSnackBar.snackBar(
                              "Error type audit", err.toString(), Colors.red);
                        });
                      }

                      filterType = listType.where((u) {
                        var code = u.codeChamp.toString().toLowerCase();
                        var description = u.champ!.toLowerCase();
                        return code.contains(filter) ||
                            description.contains(filter);
                      }).toList();
                      return filterType;
                    } catch (Exception) {
                      if (kDebugMode) {
                        print('exception type audit : ${Exception.toString()}');
                      }
                      ShowSnackBar.snackBar("Exception type audit",
                          Exception.toString(), Colors.red);
                      return Future.error('service : ${Exception.toString()}');
                    }
                  }

                  Widget _customDropDownChampAudit(
                      BuildContext context, ChampAuditModel? item) {
                    if (item == null) {
                      return Container();
                    } else {
                      return Container(
                        child: ListTile(
                          contentPadding: EdgeInsets.all(0),
                          title: Text('${item.champ}'),
                        ),
                      );
                    }
                  }

                  Widget _customPopupItemBuilderChampAudit(BuildContext context,
                      ChampAuditModel item, bool isSelected) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      decoration: !isSelected
                          ? null
                          : BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context).primaryColor),
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
                      List<TypeActionModel> _typesList =
                          await List<TypeActionModel>.empty(growable: true);
                      List<TypeActionModel> _typesFilter =
                          await List<TypeActionModel>.empty(growable: true);
                      var connection = await Connectivity().checkConnectivity();
                      if (connection == ConnectivityResult.none) {
                        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
                        var response =
                            await LocalActionService().readTypeAction();
                        response.forEach((data) {
                          var sourceModel = TypeActionModel();
                          sourceModel.codetypeAct = data['codetypeAct'];
                          sourceModel.typeAct = data['typeAct'];
                          sourceModel.actSimpl = data['actSimpl'];
                          sourceModel.analyseCause = data['analyseCause'];
                          _typesList.add(sourceModel);
                        });
                      } else if (connection == ConnectivityResult.wifi ||
                          connection == ConnectivityResult.mobile) {
                        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
                        await ApiServicesCall()
                            .getTypeAction({"nom": "", "lang": ""}).then(
                                (resp) async {
                          resp.forEach((data) async {
                            var model = TypeActionModel();
                            model.codetypeAct = data['codetypeAct'];
                            model.typeAct = data['typeAct'];
                            model.actSimpl = data['act_simpl'];
                            model.analyseCause = data['analyse_cause'];
                            _typesList.add(model);
                          });
                        }, onError: (err) {
                          ShowSnackBar.snackBar(
                              "Error", err.toString(), Colors.red);
                        });
                      }
                      _typesFilter = _typesList.where((u) {
                        var query = u.typeAct!.toLowerCase();
                        return query.contains(filter);
                      }).toList();
                      return _typesFilter;
                    } catch (exception) {
                      ShowSnackBar.snackBar(
                          "Exception", exception.toString(), Colors.red);
                      return Future.error('service : ${exception.toString()}');
                    }
                  }

                  Widget _customDropDownType(
                      BuildContext context, TypeActionModel? item) {
                    if (item == null) {
                      return Container();
                    } else {
                      return Container(
                        child: ListTile(
                          contentPadding: EdgeInsets.all(0),
                          title: Text(
                            '${item.typeAct}',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      );
                    }
                  }

                  Widget _customPopupItemBuilderType(BuildContext context,
                      TypeActionModel? item, bool isSelected) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      decoration: !isSelected
                          ? null
                          : BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context).primaryColor),
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

                  //bottomSheet
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(30))),
                      builder: (context) => DraggableScrollableSheet(
                            expand: false,
                            initialChildSize: 0.9,
                            maxChildSize: 0.9,
                            minChildSize: 0.6,
                            builder: (context, scrollController) =>
                                SingleChildScrollView(
                              child: StatefulBuilder(
                                builder: (BuildContext context,
                                    StateSetter setState) {
                                  return ListBody(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Center(
                                        child: Text(
                                          '${'new'.tr} Constat',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF0769D2),
                                              fontSize: 20.0),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
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
                                                  keyboardType:
                                                      TextInputType.text,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  decoration: InputDecoration(
                                                      labelText:
                                                          '${'object'.tr} Constat *',
                                                      hintText:
                                                          '${'object'.tr}',
                                                      labelStyle: TextStyle(
                                                        fontSize: 14.0,
                                                      ),
                                                      hintStyle: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 10.0,
                                                      ),
                                                      border: OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Colors
                                                                  .lightBlue,
                                                              width: 1),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)))),
                                                  validator: (value) =>
                                                      Validator.validateField(
                                                          value: value!),
                                                  style:
                                                      TextStyle(fontSize: 14.0),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              Visibility(
                                                visible: true,
                                                child: TextFormField(
                                                  controller:
                                                      descriptionController,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  decoration: InputDecoration(
                                                      labelText:
                                                          'Description constat *',
                                                      hintText: 'Description',
                                                      labelStyle: TextStyle(
                                                        fontSize: 14.0,
                                                      ),
                                                      hintStyle: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 10.0,
                                                      ),
                                                      border: OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Colors
                                                                  .lightBlue,
                                                              width: 1),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)))),
                                                  validator: (value) =>
                                                      Validator.validateField(
                                                          value: value!),
                                                  style:
                                                      TextStyle(fontSize: 14.0),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              DropdownSearch<ChampAuditModel>(
                                                showSelectedItems: true,
                                                showClearButton: true,
                                                showSearchBox: true,
                                                isFilteredOnline: true,
                                                compareFn: (i, s) =>
                                                    i?.isEqual(s) ?? false,
                                                dropdownSearchDecoration:
                                                    InputDecoration(
                                                  labelText:
                                                      "${'champ_audit'.tr} *",
                                                  contentPadding:
                                                      EdgeInsets.fromLTRB(
                                                          12, 12, 0, 0),
                                                  border: OutlineInputBorder(),
                                                ),
                                                onFind: (String? filter) =>
                                                    getChampAuditByFiche(
                                                        filter),
                                                onChanged: (data) {
                                                  champAuditModel = data;
                                                  selectedChampAuditCode =
                                                      data?.codeChamp;
                                                  selectedChampAudit =
                                                      data?.champ;
                                                  debugPrint(
                                                      'champ audit: ${selectedChampAudit}, code : ${selectedChampAuditCode}');
                                                },
                                                dropdownBuilder:
                                                    _customDropDownChampAudit,
                                                popupItemBuilder:
                                                    _customPopupItemBuilderChampAudit,
                                                validator: (u) => u == null
                                                    ? "${'champ_audit'.tr} ${'is_required'.tr} "
                                                    : null,
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Visibility(
                                                  visible: true,
                                                  child: DropdownSearch<
                                                      TypeActionModel>(
                                                    showSelectedItems: true,
                                                    showClearButton: true,
                                                    showSearchBox: true,
                                                    isFilteredOnline: true,
                                                    compareFn: (i, s) =>
                                                        i?.isEqual(s) ?? false,
                                                    dropdownSearchDecoration:
                                                        InputDecoration(
                                                      labelText:
                                                          "${'type_action_recommended'.tr} *",
                                                      contentPadding:
                                                          EdgeInsets.fromLTRB(
                                                              12, 12, 0, 0),
                                                      border:
                                                          OutlineInputBorder(),
                                                    ),
                                                    onFind: (String? filter) =>
                                                        getTypeAction(filter),
                                                    onChanged: (data) {
                                                      selectedCodeTypeAct =
                                                          data?.codetypeAct;
                                                      typeActionModel = data;
                                                      if (typeActionModel ==
                                                          null) {
                                                        selectedCodeTypeAct = 0;
                                                      }
                                                      debugPrint(
                                                          'type action: ${typeActionModel?.typeAct}, code: ${selectedCodeTypeAct}');
                                                    },
                                                    dropdownBuilder:
                                                        _customDropDownType,
                                                    popupItemBuilder:
                                                        _customPopupItemBuilderType,
                                                    validator: (u) => u == null
                                                        ? "${'type_action_recommended'.tr} ${'is_required'.tr} "
                                                        : null,
                                                  )),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              DropdownSearch<TypeAuditModel>(
                                                showSelectedItems: true,
                                                showClearButton: true,
                                                showSearchBox: true,
                                                isFilteredOnline: true,
                                                compareFn: (i, s) =>
                                                    i?.isEqual(s) ?? false,
                                                dropdownSearchDecoration:
                                                    InputDecoration(
                                                  labelText: "Type constat *",
                                                  contentPadding:
                                                      EdgeInsets.fromLTRB(
                                                          12, 12, 0, 0),
                                                  border: OutlineInputBorder(),
                                                ),
                                                onFind: (String? filter) =>
                                                    getTypeConstat(filter),
                                                onChanged: (data) {
                                                  constatAuditModel = data;
                                                  selectedTypeConstat =
                                                      data?.codeType;
                                                  typeConstat = data?.type;
                                                  debugPrint(
                                                      'type constat: ${typeConstat}, num: ${selectedTypeConstat}');
                                                },
                                                dropdownBuilder:
                                                    _customDropDownTypeConstat,
                                                popupItemBuilder:
                                                    _customPopupItemBuilderTypeConstat,
                                                validator: (u) => u == null
                                                    ? "type ${'is_required'.tr} "
                                                    : null,
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              DropdownSearch<GraviteModel>(
                                                showSelectedItems: true,
                                                showClearButton: true,
                                                showSearchBox: true,
                                                isFilteredOnline: true,
                                                compareFn: (i, s) =>
                                                    i?.isEqual(s) ?? false,
                                                dropdownSearchDecoration:
                                                    InputDecoration(
                                                  labelText:
                                                      "${'gravity'.tr} *",
                                                  contentPadding:
                                                      EdgeInsets.fromLTRB(
                                                          12, 12, 0, 0),
                                                  border: OutlineInputBorder(),
                                                ),
                                                onFind: (String? filter) =>
                                                    getGravite(filter),
                                                onChanged: (data) {
                                                  graviteModel = data;
                                                  selectedNGravite =
                                                      data?.codegravite;
                                                  gravite = data?.gravite;
                                                  debugPrint(
                                                      'gravite: ${gravite}, num: ${selectedNGravite}');
                                                },
                                                dropdownBuilder:
                                                    _customDropDownGravite,
                                                popupItemBuilder:
                                                    _customPopupItemBuilderGravite,
                                                validator: (u) => u == null
                                                    ? "${'gravity'.tr} ${'is_required'.tr} "
                                                    : null,
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Visibility(
                                                visible:
                                                    isVisiblePersonneConcerne,
                                                child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Row(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: Get.width / 1.4,
                                                        child: DropdownSearch<
                                                            EmployeModel>(
                                                          showSelectedItems:
                                                              true,
                                                          showClearButton: true,
                                                          showSearchBox: true,
                                                          isFilteredOnline:
                                                              true,
                                                          compareFn: (i, s) =>
                                                              i?.isEqual(s) ??
                                                              false,
                                                          dropdownSearchDecoration:
                                                              InputDecoration(
                                                            labelText:
                                                                "${'person_concerne'.tr} *",
                                                            contentPadding:
                                                                EdgeInsets
                                                                    .fromLTRB(
                                                                        12,
                                                                        12,
                                                                        0,
                                                                        0),
                                                            border:
                                                                OutlineInputBorder(),
                                                          ),
                                                          onFind: (String?
                                                                  filter) =>
                                                              getPersonneConcerne(
                                                                  filter),
                                                          onChanged: (data) {
                                                            employeModel = data;
                                                            selectedMatriculeEmploye =
                                                                data?.mat;
                                                            selectedNompreEmploye =
                                                                data?.nompre;
                                                            debugPrint(
                                                                'personne concernée: ${selectedNompreEmploye}, mat: ${selectedMatriculeEmploye}');
                                                          },
                                                          dropdownBuilder:
                                                              _customDropDownEmploye,
                                                          popupItemBuilder:
                                                              _customPopupItemBuilderEmploye,
                                                          validator: (u) => u ==
                                                                  null
                                                              ? "${'person_concerne'.tr} ${'is_required'.tr}"
                                                              : null,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      TextButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              isVisibleEmploye =
                                                                  true;
                                                              isVisiblePersonneConcerne =
                                                                  false;
                                                            });
                                                          },
                                                          child: Icon(
                                                            Icons
                                                                .person_add_alt_1,
                                                            size: 30,
                                                            color: Colors.blue,
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Visibility(
                                                visible: isVisibleEmploye,
                                                child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Row(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: Get.width / 1.4,
                                                        child: DropdownSearch<
                                                            EmployeModel>(
                                                          showSelectedItems:
                                                              true,
                                                          showClearButton: true,
                                                          showSearchBox: true,
                                                          isFilteredOnline:
                                                              true,
                                                          compareFn: (i, s) =>
                                                              i?.isEqual(s) ??
                                                              false,
                                                          dropdownSearchDecoration:
                                                              InputDecoration(
                                                            labelText:
                                                                "Employe",
                                                            contentPadding:
                                                                EdgeInsets
                                                                    .fromLTRB(
                                                                        12,
                                                                        12,
                                                                        0,
                                                                        0),
                                                            border:
                                                                OutlineInputBorder(),
                                                          ),
                                                          onFind: (String?
                                                                  filter) =>
                                                              getEmploye(
                                                                  filter),
                                                          onChanged: (data) {
                                                            employeModel = data;
                                                            selectedMatriculeEmploye =
                                                                data?.mat;
                                                            selectedNompreEmploye =
                                                                data?.nompre;
                                                            debugPrint(
                                                                'personne concernée: ${selectedNompreEmploye}, mat: ${selectedMatriculeEmploye}');
                                                          },
                                                          dropdownBuilder:
                                                              _customDropDownEmploye,
                                                          popupItemBuilder:
                                                              _customPopupItemBuilderEmploye,
                                                          validator: (u) => u ==
                                                                  null
                                                              ? "Employe ${'is_required'.tr} "
                                                              : null,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      TextButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              isVisibleEmploye =
                                                                  false;
                                                              isVisiblePersonneConcerne =
                                                                  true;
                                                            });
                                                          },
                                                          child: Icon(
                                                              Icons
                                                                  .west_outlined,
                                                              size: 30,
                                                              color: Color(
                                                                  0xFF1A6E84)))
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  selectedDateReal(context);
                                                },
                                                child: TextFormField(
                                                  enabled: false,
                                                  controller:
                                                      delaiRealController,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  onChanged: (value) {
                                                    selectedDateReal(context);
                                                  },
                                                  decoration: InputDecoration(
                                                      labelText:
                                                          'delai_real'.tr,
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
                                                          selectedDateReal(
                                                              context);
                                                        },
                                                        child: Icon(Icons
                                                            .calendar_today),
                                                      ),
                                                      border: OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Colors
                                                                  .lightBlue,
                                                              width: 1),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)))),
                                                  style:
                                                      TextStyle(fontSize: 14.0),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  ConstrainedBox(
                                                    constraints:
                                                        BoxConstraints.tightFor(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2.2,
                                                            height: 50),
                                                    child: ElevatedButton.icon(
                                                      style: ButtonStyle(
                                                        shape:
                                                            MaterialStateProperty
                                                                .all(
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30),
                                                          ),
                                                        ),
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(CustomColors
                                                                    .firebaseRedAccent),
                                                        padding:
                                                            MaterialStateProperty
                                                                .all(EdgeInsets
                                                                    .all(10)),
                                                      ),
                                                      icon: Icon(Icons.cancel),
                                                      label: Text(
                                                        'cancel'.tr,
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      onPressed: () {
                                                        Get.back();
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  ConstrainedBox(
                                                    constraints:
                                                        BoxConstraints.tightFor(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2.2,
                                                            height: 50),
                                                    child: ElevatedButton.icon(
                                                      style: ButtonStyle(
                                                        shape:
                                                            MaterialStateProperty
                                                                .all(
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30),
                                                          ),
                                                        ),
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(CustomColors
                                                                    .googleBackground),
                                                        padding:
                                                            MaterialStateProperty
                                                                .all(EdgeInsets
                                                                    .all(10)),
                                                      ),
                                                      icon: Icon(Icons.save),
                                                      label: Text(
                                                        'save'.tr,
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      onPressed: () async {
                                                        if (_addItemFormKey
                                                            .currentState!
                                                            .validate()) {
                                                          try {
                                                            var connection =
                                                                await Connectivity()
                                                                    .checkConnectivity();
                                                            if (connection ==
                                                                ConnectivityResult
                                                                    .none) {
                                                              var model =
                                                                  ConstatAuditModel();
                                                              model.online = 0;
                                                              model.refAudit =
                                                                  widget.model
                                                                      .refAudit;
                                                              model.idAudit =
                                                                  widget.model
                                                                      .idAudit;
                                                              model.nact = 0;
                                                              model.idCrit = 0;
                                                              model.ngravite =
                                                                  selectedNGravite;
                                                              model.codeTypeE =
                                                                  selectedTypeConstat;
                                                              model.gravite =
                                                                  gravite;
                                                              model.typeE =
                                                                  typeConstat;
                                                              model.mat =
                                                                  selectedMatriculeEmploye;
                                                              model.nomPre =
                                                                  selectedNompreEmploye;
                                                              model.prov = 0;
                                                              model.idEcart =
                                                                  maxConstatAudit;
                                                              model.pr = 0;
                                                              model.ps = 0;
                                                              model.descPb =
                                                                  descriptionController
                                                                      .text;
                                                              model.act =
                                                                  objectController
                                                                      .text;
                                                              model.typeAct =
                                                                  selectedCodeTypeAct;
                                                              model.sourceAct =
                                                                  0;
                                                              model.codeChamp =
                                                                  selectedChampAuditCode;
                                                              model.champ =
                                                                  selectedChampAudit;
                                                              model.delaiReal =
                                                                  delaiRealController
                                                                      .text;
                                                              await LocalAuditService()
                                                                  .saveConstatAudit(
                                                                      model);
                                                              if (kDebugMode)
                                                                print(
                                                                    'constat audit : ${model.refAudit} - id:${model.idEcart} - ${model.act}');
                                                              Get.back();
                                                              setState(() {
                                                                listConstat
                                                                    .clear();
                                                                getData();
                                                                getMaxConstatAudit();
                                                              });
                                                              ShowSnackBar.snackBar(
                                                                  "Successfully",
                                                                  "Constat added",
                                                                  Colors.green);
                                                            } else if (connection ==
                                                                    ConnectivityResult
                                                                        .wifi ||
                                                                connection ==
                                                                    ConnectivityResult
                                                                        .mobile) {
                                                              await AuditService()
                                                                  .saveConstatAudit({
                                                                "refAud": widget
                                                                    .model
                                                                    .refAudit,
                                                                "objetConstat":
                                                                    objectController
                                                                        .text,
                                                                "descConstat":
                                                                    descriptionController
                                                                        .text,
                                                                "typeConst":
                                                                    selectedCodeTypeAct,
                                                                "matConcerne":
                                                                    selectedMatriculeEmploye,
                                                                "typeEcart":
                                                                    selectedTypeConstat,
                                                                "graviteConstat":
                                                                    selectedNGravite,
                                                                "mat": matricule
                                                                    .toString(),
                                                                "id":
                                                                    maxConstatAudit,
                                                                "numAct": 0,
                                                                "mode": "Ajout",
                                                                "codeChamp":
                                                                    selectedChampAuditCode,
                                                                "idCritere": 0,
                                                                "dealiReal":
                                                                    delaiRealController
                                                                        .text
                                                              }).then((resp) async {
                                                                Get.back();
                                                                ShowSnackBar.snackBar(
                                                                    "Successfully",
                                                                    "Constat added",
                                                                    Colors
                                                                        .green);
                                                                //Get.offAll(ActionIncidentSecuritePage(numFiche: widget.numFiche));
                                                                setState(() {
                                                                  listConstat
                                                                      .clear();
                                                                  getData();
                                                                  getMaxConstatAudit();
                                                                });
                                                                await ApiControllersCall()
                                                                    .getConstatsActionProv();
                                                                await ApiControllersCall()
                                                                    .getConstatsAction();
                                                                await ApiControllersCall()
                                                                    .getAuditeurInterne();
                                                                await ApiControllersCall()
                                                                    .getChampAuditByRefAudit();
                                                              }, onError: (err) {
                                                                print(
                                                                    'error : ${err.toString()}');
                                                                ShowSnackBar.snackBar(
                                                                    "Error",
                                                                    err.toString(),
                                                                    Colors.red);
                                                              });
                                                            }
                                                          } catch (ex) {
                                                            print("Exception" +
                                                                ex.toString());
                                                            ShowSnackBar.snackBar(
                                                                "Exception",
                                                                ex.toString(),
                                                                Colors.red);
                                                            throw Exception(
                                                                "Error " +
                                                                    ex.toString());
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
                            ),
                          ));
                },
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 32,
                ),
                backgroundColor: Colors.blue,
              ),
            )
          ],
        ),
      ),
    );
  }

  //delete item
  deleteData(context, idEcart, nAct) {
    AwesomeDialog(
        context: context,
        animType: AnimType.SCALE,
        dialogType: DialogType.QUESTION,
        body: Center(
          child: Text(
            'Are you sure to delete this item ${idEcart}',
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
            await AuditService()
                .deleteConstatAudit(idEcart, nAct, widget.model.refAudit)
                .then((resp) async {
              ShowSnackBar.snackBar(
                  "Successfully", "Constat Deleted ", Colors.orangeAccent);
              listConstat.removeWhere((element) => element.idEcart == idEcart);
              setState(() {});
              Navigator.of(context).pop();
            }, onError: (err) {
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
              print('Error : ${err.toString()}');
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

  Future<void> envoyerRapport() async {
    try {
      await AuditService().envoyerRapportAudit(widget.model.refAudit).then(
          (response) {
        ShowSnackBar.snackBar("Successfully", "rapport envoyer", Colors.green);
        listConstat.clear();
        getData();
      }, onError: (error) {
        ShowSnackBar.snackBar('Error', error.toString(), Colors.red);
      });

      await AuditService().verifierRapportAuditParMode({
        "refAudit": widget.model.refAudit,
        "mat": matricule.toString(),
        "codeChamp": widget.model.codeTypeA.toString(),
        "mode": "verif_resp_valid"
      }).then((value) async {
        // ShowSnackBar.snackBar("Successfully", "verif resp validation", Colors.green);
      }, onError: (error) {
        ShowSnackBar.snackBar("error inserting employes validation : ",
            error.toString(), Colors.red);
      });
    } catch (exception) {
      ShowSnackBar.snackBar('Exception', exception.toString(), Colors.red);
    }
  }
}
