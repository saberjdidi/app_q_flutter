import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../Models/audit/auditeur_model.dart';
import '../../../Models/employe_model.dart';
import '../../../Services/action/local_action_service.dart';
import '../../../Services/api_services_call.dart';
import '../../../Services/audit/audit_service.dart';
import '../../../Utils/custom_colors.dart';
import '../../../Utils/shared_preference.dart';
import '../../../Utils/snack_bar.dart';
import '../../../Widgets/refresh_widget.dart';

class AuditeurExternePage extends StatefulWidget {
  final numFiche;
  const AuditeurExternePage({Key? key, required this.numFiche}) : super(key: key);

  @override
  State<AuditeurExternePage> createState() => _AuditeurExternePageState();
}

class _AuditeurExternePageState extends State<AuditeurExternePage> with TickerProviderStateMixin {
  final matricule = SharedPreference.getMatricule();
  List<AuditeurModel> listAuditeurExterne = List<AuditeurModel>.empty(growable: true);
  List<EmployeModel> listEmployeHabilite = List<EmployeModel>.empty(growable: true);

  void getAuditeurExterne() async {
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
        await AuditService().getAuditeurExterne(widget.numFiche).then((resp) async {
          //isDataProcessing(false);
          resp.forEach((data) async {
            setState(() {
              var model = AuditeurModel();
              model.code = data['codeAuditeur'];
              model.mat = data['organisme'];
              model.nompre = data['nomPre'];
              model.affectation = data['affectation'];
              listAuditeurExterne.add(model);
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

  void getEmployeHabiliteAudit() async {
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
        await AuditService().getEmployeHabiliteAudit(widget.numFiche).then((resp) async {
          //isDataProcessing(false);
          resp.forEach((data) async {
            setState(() {
              var model = EmployeModel();
              model.mat = data['mat'];
              model.nompre = data['nompre'];
              listEmployeHabilite.add(model);
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

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    getAuditeurExterne();
    getEmployeHabiliteAudit();

    _tabController = TabController(vsync: this, length: 2);
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
          toolbarHeight: 80,
          leading: Padding(
            padding: const EdgeInsets.only(left: 2),
            child: CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 20,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(Icons.arrow_back),
                color: Colors.white,
                onPressed: () {
                  Get.back();
                  Get.back();
                },
              ),
            ),
          ),
          /*leading: TextButton(
            onPressed: (){
              Get.back();
              //Get.find<AuditController>().listAudit.clear();
              //Get.find<AuditController>().getAuditeurExterne();
              //Get.toNamed(AppRoute.audit);
            },
            child: Icon(Icons.arrow_back, color: Colors.blue,),
          ),
          title: Text(
            'Auditeurs externes N°${widget.numFiche}',
            style: TextStyle(color: Colors.black, fontSize: 16),
          ), */
          backgroundColor: (lightPrimary),
          elevation: 0,
          title: TabBar(
            controller: _tabController,
            tabs: [
              Tab(
                  child: Text('Auditeur Externe', style: TextStyle(color: Colors.indigo),),
                  icon: InkWell(
                      onTap: () async {

                        final _addItemFormKey = GlobalKey<FormState>();
                        int? codeAuditeur = 0;
                        Object? affectation = 'RA';
                        //getAuditeur
                        Future<List<AuditeurModel>> getAuditeur(filter) async {
                          try {
                            List<AuditeurModel> auditeurList = await List<AuditeurModel>.empty(growable: true);
                            List<AuditeurModel> auditeurFilter = await List<AuditeurModel>.empty(growable: true);
                            await AuditService().getAuditeurExterneToAdd(widget.numFiche)
                                .then((response) async {
                              response.forEach((element) {
                                var model = AuditeurModel();
                                model.code = element['codeAuditeur'];
                                model.mat = element['organisme'];
                                model.nompre = element['nomPre'];
                                auditeurList.add(model);
                              });
                            }, onError: (error){
                              if(kDebugMode) print('error : ${error.toString()}');
                              ShowSnackBar.snackBar('Error', error.toString(), Colors.red);
                            });
                            auditeurFilter = auditeurList.where((u) {
                              var name = u.mat.toString().toLowerCase();
                              var description = u.nompre!.toLowerCase();
                              return name.contains(filter) ||
                                  description.contains(filter);
                            }).toList();
                            return auditeurFilter;
                          } catch (exception) {
                            ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
                            return Future.error('service : ${exception.toString()}');
                          }
                        }
                        Widget customDropDownAuditeur(BuildContext context, AuditeurModel? item) {
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
                        Widget customPopupItemBuilderAuditeur(
                            BuildContext context, AuditeurModel item, bool isSelected) {
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
                                    return ListBody(
                                      children: <Widget>[
                                        SizedBox(height: 5.0,),
                                        Center(
                                          child: Text('Auditeur externe', style: TextStyle(
                                              fontWeight: FontWeight.w500, fontFamily: "Brand-Bold",
                                              color: Color(0xFF0769D2), fontSize: 30.0
                                          ),),
                                        ),
                                        SizedBox(height: 15.0,),
                                        Form(
                                          key: _addItemFormKey,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(left: 10, right: 10),
                                                child: DropdownSearch<AuditeurModel>(
                                                  showSelectedItems: true,
                                                  showClearButton: true,
                                                  showSearchBox: true,
                                                  isFilteredOnline: true,
                                                  compareFn: (i, s) => i?.isEqual(s) ?? false,
                                                  dropdownSearchDecoration: InputDecoration(
                                                    labelText: "Auditeur *",
                                                    contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                                    border: OutlineInputBorder(),
                                                  ),
                                                  onFind: (String? filter) => getAuditeur(filter),
                                                  onChanged: (data) {
                                                    codeAuditeur = data?.code;
                                                    print('Auditeur: ${data?.nompre}, code: ${codeAuditeur}');
                                                  },
                                                  dropdownBuilder: customDropDownAuditeur,
                                                  popupItemBuilder: customPopupItemBuilderAuditeur,
                                                  validator: (u) =>
                                                  u == null ? "Auditeur est obligatoire " : null,
                                                ),
                                              ),
                                              SizedBox(height: 10,),
                                              Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Radio(value: 'RA',
                                                        groupValue: affectation,
                                                        onChanged: (value){
                                                          setState(() => affectation = value);
                                                        },
                                                        activeColor: Colors.blue,
                                                        fillColor: MaterialStateProperty.all(Colors.blue),),
                                                      const Text("Responsable Audit", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),)
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Radio(value: 'A',
                                                        groupValue: affectation,
                                                        onChanged: (value){
                                                          setState(() => affectation = value);
                                                        },
                                                        activeColor: Colors.blue,
                                                        fillColor: MaterialStateProperty.all(Colors.blue),),
                                                      const Text("Auditeur", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),)
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Radio(value: 'O',
                                                        groupValue: affectation,
                                                        onChanged: (value){
                                                          setState(() => affectation = value);
                                                        },
                                                        activeColor: Colors.blue,
                                                        fillColor: MaterialStateProperty.all(Colors.blue),),
                                                      const Text("Observateur", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),)
                                                    ],
                                                  )
                                                ],
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
                                                      try {
                                                        await AuditService().saveAuditeurExterne({
                                                          "codeAuditeur": codeAuditeur,
                                                          "refAudit": widget.numFiche,
                                                          "affectation": affectation
                                                        }).then((response){
                                                          Get.back();
                                                          ShowSnackBar.snackBar("Successfully", "Auditeur added", Colors.green);
                                                          //Get.offAll(ActionIncidentSecuritePage(numFiche: widget.numFiche));
                                                          setState(() {
                                                            listAuditeurExterne.clear();
                                                            getAuditeurExterne();
                                                          });
                                                        },
                                                            onError: (error){
                                                              ShowSnackBar.snackBar("error", error.toString(), Colors.red);
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
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            )
                        );
                      },
                      child: Icon(Icons.person_add_alt_1, color: Colors.indigo, size: 30,)
                  )
              ),
              Tab(
                  child: Text('Employe habilite', style: TextStyle(color: Colors.indigo),),
                icon: InkWell(
                  onTap: () async {

                    final _addEmployeHabiliteForm = GlobalKey<FormState>();
                    String? employeHabiliteMatricule = "";

                    Future<List<EmployeModel>> getEmployeHabilite(filter) async {
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
                    Widget _customDropDownEmployeHabilite(BuildContext context, EmployeModel? item) {
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
                    Widget _customPopupItemBuilderEmployeHabilite(
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
                          minChildSize: 0.7,
                          maxChildSize: 0.9,
                          initialChildSize: 0.7,
                          builder: (context, scrollController) => SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                SizedBox(height: 5.0,),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text('Employés habilités à enregistrer constats', style: TextStyle(
                                        fontWeight: FontWeight.w500, fontFamily: "Brand-Bold",
                                        color: Color(0xFF0769D2), fontSize: 20.0
                                    ),),
                                  ),
                                ),
                                SizedBox(height: 15.0,),
                                Form(
                                    key: _addEmployeHabiliteForm,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 10, right: 10),
                                      child: Column(
                                        children: [
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
                                            onFind: (String? filter) => getEmployeHabilite(filter),
                                            onChanged: (data){
                                              employeHabiliteMatricule = data?.mat;
                                              print('employe : ${data?.nompre}; code : $employeHabiliteMatricule');
                                            },
                                            dropdownBuilder: _customDropDownEmployeHabilite,
                                            popupItemBuilder: _customPopupItemBuilderEmployeHabilite,
                                            popupTitle: Center(child: Text('List Employes', style: TextStyle(fontSize: 16),), ),
                                            validator: (data) =>
                                            data==null ? 'Employe est obligatoire' : null,
                                          ),
                                          SizedBox(height: 20,),
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
                                                if(_addEmployeHabiliteForm.currentState!.validate()){
                                                  try {
                                                    await AuditService().addEmployeHabiliteAudit({
                                                      "mat": employeHabiliteMatricule,
                                                      "refAudit": widget.numFiche
                                                    }).then((response){
                                                      Get.back();
                                                      ShowSnackBar.snackBar("Successfully", "employe added", Colors.green);
                                                      //Get.offAll(ActionIncidentSecuritePage(numFiche: widget.numFiche));
                                                      setState(() {
                                                        listEmployeHabilite.clear();
                                                        getEmployeHabiliteAudit();
                                                      });
                                                    },
                                                        onError: (error){
                                                          ShowSnackBar.snackBar("error", error.toString(), Colors.red);
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
                                        ],
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        )
                    );
                  },
                  child: Icon(Icons.add, color: Colors.indigo, size: 30,),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            SafeArea(
              child: listAuditeurExterne.isNotEmpty
                  ? RefreshWidget(
                  keyRefresh: keyRefresh,
                  onRefresh: () async {
                    setState(() {
                      listAuditeurExterne.clear();
                      getAuditeurExterne();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ListView.builder(
                        itemCount: listAuditeurExterne.length,
                        itemBuilder: (context, index) {
                          return Card(
                            color: Color(0xFFE9EAEE),
                            child: ListTile(
                              title: Text(
                                'Organisme : ${listAuditeurExterne[index].mat}',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text('Nom/Prenom : ${listAuditeurExterne[index].nompre}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text('Affectation : ${listAuditeurExterne[index].affectation}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),),
                                  ),
                                ],
                              ),
                              trailing: InkWell(
                                onTap: (){
                                  deleteAuditeurExterne(context, listAuditeurExterne[index].code);
                                },
                                child: Icon(Icons.delete, color: Colors.red,),
                              ),
                            ),
                          );
                        }),
                  )
              )
                  : Center(child: Text('empty_list'.tr, style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'Brand-Bold'
              )),),
            ),

            //employe habilite
            SafeArea(
              child: listEmployeHabilite.isNotEmpty
                  ? RefreshWidget(
                  keyRefresh: keyRefresh,
                  onRefresh: () async {
                    setState(() {
                      listEmployeHabilite.clear();
                      getEmployeHabiliteAudit();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ListView.builder(
                        itemCount: listEmployeHabilite.length,
                        itemBuilder: (context, index) {
                          return Card(
                            color: Color(0xFFE9EAEE),
                            child: ListTile(
                              title: Text(
                                'Matricule : ${listEmployeHabilite[index].mat}',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text('Nom/Prenom : ${listEmployeHabilite[index].nompre}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),),
                                  ),
                                ],
                              ),
                              trailing: InkWell(
                                onTap: (){
                                  deleteEmployeHabiliteAudit(context, listEmployeHabilite[index].mat);
                                },
                                child: Icon(Icons.delete, color: Colors.red,),
                              ),
                            ),
                          );
                        }),
                  )
              )
                  : Center(child: Text('empty_list'.tr, style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'Brand-Bold'
              )),),
            )
          ],
        ),
       /* floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add, color: Colors.white, size: 35,),
          backgroundColor: Colors.blue,
          onPressed: () async {

            final _addItemFormKey = GlobalKey<FormState>();
            int? codeAuditeur = 0;
            Object? affectation = 'RA';
            //getAuditeur
            Future<List<AuditeurModel>> getAuditeur(filter) async {
              try {
                List<AuditeurModel> auditeurList = await List<AuditeurModel>.empty(growable: true);
                List<AuditeurModel> auditeurFilter = await List<AuditeurModel>.empty(growable: true);
                await AuditService().getAuditeurExterneToAdd(widget.numFiche)
                    .then((response) async {
                  response.forEach((element) {
                    var model = AuditeurModel();
                    model.code = element['codeAuditeur'];
                    model.mat = element['organisme'];
                    model.nompre = element['nomPre'];
                    auditeurList.add(model);
                  });
                }, onError: (error){
                  if(kDebugMode) print('error : ${error.toString()}');
                  ShowSnackBar.snackBar('Error', error.toString(), Colors.red);
                });
                auditeurFilter = auditeurList.where((u) {
                  var name = u.mat.toString().toLowerCase();
                  var description = u.nompre!.toLowerCase();
                  return name.contains(filter) ||
                      description.contains(filter);
                }).toList();
                return auditeurFilter;
              } catch (exception) {
                ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
                return Future.error('service : ${exception.toString()}');
              }
            }
            Widget customDropDownAuditeur(BuildContext context, AuditeurModel? item) {
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
            Widget customPopupItemBuilderAuditeur(
                BuildContext context, AuditeurModel item, bool isSelected) {
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
                        return ListBody(
                          children: <Widget>[
                            SizedBox(height: 5.0,),
                            Center(
                              child: Text('Auditeur externe', style: TextStyle(
                                  fontWeight: FontWeight.w500, fontFamily: "Brand-Bold",
                                  color: Color(0xFF0769D2), fontSize: 30.0
                              ),),
                            ),
                            SizedBox(height: 15.0,),
                            Form(
                              key: _addItemFormKey,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10, right: 10),
                                    child: DropdownSearch<AuditeurModel>(
                                      showSelectedItems: true,
                                      showClearButton: true,
                                      showSearchBox: true,
                                      isFilteredOnline: true,
                                      compareFn: (i, s) => i?.isEqual(s) ?? false,
                                      dropdownSearchDecoration: InputDecoration(
                                        labelText: "Auditeur *",
                                        contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                        border: OutlineInputBorder(),
                                      ),
                                      onFind: (String? filter) => getAuditeur(filter),
                                      onChanged: (data) {
                                        codeAuditeur = data?.code;
                                        print('Auditeur: ${data?.nompre}, code: ${codeAuditeur}');
                                      },
                                      dropdownBuilder: customDropDownAuditeur,
                                      popupItemBuilder: customPopupItemBuilderAuditeur,
                                      validator: (u) =>
                                      u == null ? "Auditeur est obligatoire " : null,
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Radio(value: 'RA',
                                            groupValue: affectation,
                                            onChanged: (value){
                                              setState(() => affectation = value);
                                            },
                                            activeColor: Colors.blue,
                                            fillColor: MaterialStateProperty.all(Colors.blue),),
                                          const Text("Responsable Audit", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),)
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Radio(value: 'A',
                                            groupValue: affectation,
                                            onChanged: (value){
                                              setState(() => affectation = value);
                                            },
                                            activeColor: Colors.blue,
                                            fillColor: MaterialStateProperty.all(Colors.blue),),
                                          const Text("Auditeur", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),)
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Radio(value: 'O',
                                            groupValue: affectation,
                                            onChanged: (value){
                                              setState(() => affectation = value);
                                            },
                                            activeColor: Colors.blue,
                                            fillColor: MaterialStateProperty.all(Colors.blue),),
                                          const Text("Observateur", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),)
                                        ],
                                      )
                                    ],
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
                                          try {
                                            await AuditService().saveAuditeurExterne({
                                              "codeAuditeur": codeAuditeur,
                                              "refAudit": widget.numFiche,
                                              "affectation": affectation
                                            }).then((response){
                                              Get.back();
                                              ShowSnackBar.snackBar("Successfully", "Auditeur added", Colors.green);
                                              //Get.offAll(ActionIncidentSecuritePage(numFiche: widget.numFiche));
                                              setState(() {
                                                listAuditeurExterne.clear();
                                                getAuditeurExterne();
                                              });
                                            },
                                                onError: (error){
                                                  ShowSnackBar.snackBar("error", error.toString(), Colors.red);
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
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                )
            );
          },
        ), */
      ),
    );
  }

  void deleteAuditeurExterne(BuildContext context, int? code) {
   AwesomeDialog(
     context: context,
     animType: AnimType.SCALE,
     dialogType: DialogType.QUESTION,
     body: Center(
       child: Text('Are you sure to delete this item ${code}',
       style: TextStyle(fontWeight: FontWeight.normal, fontStyle: FontStyle.normal),),
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

         await AuditService().deleteAuditeurExterne(code, widget.numFiche).then((resp) async {
           ShowSnackBar.snackBar("Successfully", "Auditeur Externe Supprimé", Colors.orangeAccent);
           listAuditeurExterne.removeWhere((element) => element.code == code);
           setState(() {});
           Navigator.of(context).pop();
         }, onError: (err) {
           ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
           print('Error : ${err.toString()}');
         });
       },
       child: Padding(
         padding: const EdgeInsets.all(8.0),
         child: Text('Ok',
           style: TextStyle(
             fontSize: 16,
             fontWeight: FontWeight.bold,
             color: Colors.white,
             letterSpacing: 2,
           ),
         ),
       ),
     ),
       closeIcon: Icon(Icons.close, color: Colors.red,),
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
           child: Text('Cancel',
             style: TextStyle(
               fontSize: 16,
               fontWeight: FontWeight.bold,
               color: Colors.white,
               letterSpacing: 2,
             ),
           ),
         ),
       )
   )..show();
  }

  void deleteEmployeHabiliteAudit(BuildContext context, mat) {
    AwesomeDialog(
        context: context,
        animType: AnimType.SCALE,
        dialogType: DialogType.QUESTION,
        body: Center(
          child: Text('Are you sure to delete this item ${mat}',
            style: TextStyle(fontWeight: FontWeight.normal, fontStyle: FontStyle.normal),),
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

            await AuditService().deleteEmployeHabiliteAudit(widget.numFiche, mat).then((resp) async {
              ShowSnackBar.snackBar("Successfully", "employé habilité Supprimé", Colors.orangeAccent);
              listEmployeHabilite.removeWhere((element) => element.mat == mat);
              setState(() {});
              Navigator.of(context).pop();
            }, onError: (err) {
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
              print('Error : ${err.toString()}');
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Ok',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
          ),
        ),
        closeIcon: Icon(Icons.close, color: Colors.red,),
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
            child: Text('Cancel',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
          ),
        )
    )..show();
  }
}

