import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualipro_flutter/Models/audit/auditeur_model.dart';
import 'package:qualipro_flutter/Services/audit/local_audit_service.dart';
import 'package:qualipro_flutter/Widgets/refresh_widget.dart';
import '../../../Controllers/api_controllers_call.dart';
import '../../../Services/audit/audit_service.dart';
import '../../../Utils/custom_colors.dart';
import '../../../Utils/shared_preference.dart';
import '../../../Utils/snack_bar.dart';

class AuditeurInternePage extends StatefulWidget {
  final numFiche;

  const AuditeurInternePage({Key? key, required this.numFiche})
      : super(key: key);

  @override
  State<AuditeurInternePage> createState() => _AuditeurInternePageState();
}

class _AuditeurInternePageState extends State<AuditeurInternePage> {
  final matricule = SharedPreference.getMatricule();
  List<AuditeurModel> listAuditeur = List<AuditeurModel>.empty(growable: true);
  bool isVisibleBtnDelete = true;

  void getData() async {
    try {
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        isVisibleBtnDelete = false;
        var response =
            await LocalAuditService().readAuditeurInterne(widget.numFiche);
        response.forEach((data) {
          setState(() {
            var model = AuditeurModel();
            model.refAudit = data['refAudit'];
            model.mat = data['mat'];
            model.nompre = data['nompre'];
            model.affectation = data['affectation'];
            listAuditeur.add(model);
          });
        });
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        isVisibleBtnDelete = true;
        //rest api
        await AuditService().getAuditeurInterne(widget.numFiche).then(
            (resp) async {
          //isDataProcessing(false);
          resp.forEach((data) async {
            setState(() {
              var model = AuditeurModel();
              model.refAudit = data['refAudit'];
              model.mat = data['mat'];
              model.nompre = data['nomPre'];
              model.affectation = data['affectation'];
              listAuditeur.add(model);
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

  @override
  void initState() {
    super.initState();
    getData();
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
            '${'auditeur'.tr}s ${'interne'.tr}s Audit N°${widget.numFiche}',
            style: TextStyle(color: Colors.black, fontSize: 15),
          ),
          backgroundColor: (lightPrimary),
          elevation: 0,
        ),
        body: SafeArea(
          child: listAuditeur.isNotEmpty
              ? RefreshWidget(
                  keyRefresh: keyRefresh,
                  onRefresh: () async {
                    setState(() {
                      listAuditeur.clear();
                      getData();
                    });
                  },
                  child: ListView.builder(
                      itemCount: listAuditeur.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: Color(0xFFE9EAEE),
                          child: ListTile(
                            title: Text(
                              '${'matricule'.tr} : ${listAuditeur[index].mat}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Text(
                                    '${'nom_prenom'.tr} : ${listAuditeur[index].nompre}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(
                                    'Affectation : ${listAuditeur[index].affectation}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                            trailing: Visibility(
                              visible: isVisibleBtnDelete,
                              child: InkWell(
                                onTap: () {
                                  deleteData(context, listAuditeur[index].mat);
                                },
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        );
                      }))
              : Center(
                  child: Text('empty_list'.tr,
                      style:
                          TextStyle(fontSize: 20.0, fontFamily: 'Brand-Bold')),
                ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 35,
          ),
          backgroundColor: Colors.blue,
          onPressed: () async {
            final _addItemFormKey = GlobalKey<FormState>();
            String? employeMatricule = "";
            String? employeNompre = "";
            Object? affectation = 'RA';
            //getAuditeurInterne
            Future<List<AuditeurModel>> getAuditeurInterne(filter) async {
              try {
                List<AuditeurModel> auditeurList =
                    await List<AuditeurModel>.empty(growable: true);
                List<AuditeurModel> auditeurFilter =
                    await List<AuditeurModel>.empty(growable: true);
                var connection = await Connectivity().checkConnectivity();
                if (connection == ConnectivityResult.none) {
                  var response = await LocalAuditService()
                      .readAuditeurInterneARattacher(
                          widget.numFiche.toString());
                  response.forEach((data) {
                    setState(() {
                      var model = AuditeurModel();
                      //model.refAudit = data['refAudit'];
                      model.mat = data['mat'];
                      model.nompre = data['nompre'];
                      auditeurList.add(model);
                    });
                  });
                } else if (connection == ConnectivityResult.wifi ||
                    connection == ConnectivityResult.mobile) {
                  await AuditService()
                      .getAuditeurInterneToAdd(widget.numFiche)
                      .then((response) async {
                    response.forEach((element) {
                      var model = AuditeurModel();
                      model.mat = element['mat'];
                      model.nompre = element['nompre'];
                      auditeurList.add(model);
                    });
                  }, onError: (error) {
                    if (kDebugMode) print('error : ${error.toString()}');
                    ShowSnackBar.snackBar(
                        'Error', error.toString(), Colors.red);
                  });
                }

                auditeurFilter = auditeurList.where((u) {
                  var name = u.mat.toString().toLowerCase();
                  var description = u.nompre!.toLowerCase();
                  return name.contains(filter) || description.contains(filter);
                }).toList();
                return auditeurFilter;
              } catch (exception) {
                ShowSnackBar.snackBar(
                    "Exception", exception.toString(), Colors.red);
                return Future.error('service : ${exception.toString()}');
              }
            }

            Widget customDropDownEmploye(
                BuildContext context, AuditeurModel? item) {
              if (item == null) {
                return Container();
              } else {
                return Container(
                  child: ListTile(
                    contentPadding: EdgeInsets.all(0),
                    title: Text('${item.nompre}',
                        style: TextStyle(color: Colors.black)),
                  ),
                );
              }
            }

            Widget customPopupItemBuilderEmploye(
                BuildContext context, AuditeurModel item, bool isSelected) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                decoration: !isSelected
                    ? null
                    : BoxDecoration(
                        border:
                            Border.all(color: Theme.of(context).primaryColor),
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
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30))),
                builder: (context) => DraggableScrollableSheet(
                      expand: false,
                      initialChildSize: 0.7,
                      maxChildSize: 0.9,
                      minChildSize: 0.4,
                      builder: (context, scrollController) =>
                          SingleChildScrollView(
                        child: StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                            return ListBody(
                              children: <Widget>[
                                SizedBox(
                                  height: 5.0,
                                ),
                                Center(
                                  child: Text(
                                    '${'auditeur'.tr} ${'interne'.tr}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "Brand-Bold",
                                        color: Color(0xFF0769D2),
                                        fontSize: 30.0),
                                  ),
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                Form(
                                  key: _addItemFormKey,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: DropdownSearch<AuditeurModel>(
                                          showSelectedItems: true,
                                          showClearButton: true,
                                          showSearchBox: true,
                                          isFilteredOnline: true,
                                          compareFn: (i, s) =>
                                              i?.isEqual(s) ?? false,
                                          dropdownSearchDecoration:
                                              InputDecoration(
                                            labelText: "${'auditeur'.tr} *",
                                            contentPadding: EdgeInsets.fromLTRB(
                                                12, 12, 0, 0),
                                            border: OutlineInputBorder(),
                                          ),
                                          onFind: (String? filter) =>
                                              getAuditeurInterne(filter),
                                          onChanged: (data) {
                                            employeMatricule = data?.mat;
                                            employeNompre = data?.nompre;
                                            debugPrint(
                                                'Auditeur: ${employeNompre}, mat: ${employeMatricule}');
                                          },
                                          dropdownBuilder:
                                              customDropDownEmploye,
                                          popupItemBuilder:
                                              customPopupItemBuilderEmploye,
                                          validator: (u) => u == null
                                              ? "${'auditeur'.tr} ${'is_required'.tr} "
                                              : null,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              Radio(
                                                value: 'RA',
                                                groupValue: affectation,
                                                onChanged: (value) {
                                                  setState(() =>
                                                      affectation = value);
                                                },
                                                activeColor: Colors.blue,
                                                fillColor:
                                                    MaterialStateProperty.all(
                                                        Colors.blue),
                                              ),
                                              const Text(
                                                "Responsable Audit",
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
                                                value: 'A',
                                                groupValue: affectation,
                                                onChanged: (value) {
                                                  setState(() =>
                                                      affectation = value);
                                                },
                                                activeColor: Colors.blue,
                                                fillColor:
                                                    MaterialStateProperty.all(
                                                        Colors.blue),
                                              ),
                                              const Text(
                                                "Auditeur",
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
                                                value: 'O',
                                                groupValue: affectation,
                                                onChanged: (value) {
                                                  setState(() =>
                                                      affectation = value);
                                                },
                                                activeColor: Colors.blue,
                                                fillColor:
                                                    MaterialStateProperty.all(
                                                        Colors.blue),
                                              ),
                                              const Text(
                                                "Observateur",
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
                                        height: 10,
                                      ),
                                      ConstrainedBox(
                                        constraints: BoxConstraints.tightFor(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.1,
                                            height: 50),
                                        child: ElevatedButton.icon(
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                            ),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    CustomColors
                                                        .googleBackground),
                                            padding: MaterialStateProperty.all(
                                                EdgeInsets.all(14)),
                                          ),
                                          icon: Icon(Icons.save),
                                          label: Text(
                                            'save'.tr,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white),
                                          ),
                                          onPressed: () async {
                                            if (_addItemFormKey.currentState!
                                                .validate()) {
                                              try {
                                                var connection =
                                                    await Connectivity()
                                                        .checkConnectivity();
                                                if (connection ==
                                                    ConnectivityResult.none) {
                                                  var model = AuditeurModel();
                                                  model.online = 0;
                                                  model.refAudit = widget
                                                      .numFiche
                                                      .toString();
                                                  model.mat = employeMatricule;
                                                  model.nompre = employeNompre;
                                                  model.affectation =
                                                      affectation.toString();
                                                  await LocalAuditService()
                                                      .saveAuditeurInterne(
                                                          model);
                                                  Get.back();
                                                  ShowSnackBar.snackBar(
                                                      "Successfully",
                                                      "Auditeur added in DB local",
                                                      Colors.green);
                                                  setState(() {
                                                    listAuditeur.clear();
                                                    getData();
                                                  });
                                                } else if (connection ==
                                                        ConnectivityResult
                                                            .wifi ||
                                                    connection ==
                                                        ConnectivityResult
                                                            .mobile) {
                                                  await AuditService()
                                                      .saveAuditeurInterne({
                                                    "mat": employeMatricule,
                                                    "refAudit": widget.numFiche,
                                                    "affectation": affectation
                                                  }).then((response) async {
                                                    Get.back();
                                                    ShowSnackBar.snackBar(
                                                        "Successfully",
                                                        "Auditeur added",
                                                        Colors.green);
                                                    //Get.offAll(ActionIncidentSecuritePage(numFiche: widget.numFiche));
                                                    setState(() {
                                                      listAuditeur.clear();
                                                      getData();
                                                    });
                                                    await ApiControllersCall()
                                                        .getAuditeurInterne();
                                                  }, onError: (error) {
                                                    ShowSnackBar.snackBar(
                                                        "error",
                                                        error.toString(),
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
                                                    "Error " + ex.toString());
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      ConstrainedBox(
                                        constraints: BoxConstraints.tightFor(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.1,
                                            height: 50),
                                        child: ElevatedButton.icon(
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                            ),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    CustomColors
                                                        .firebaseRedAccent),
                                            padding: MaterialStateProperty.all(
                                                EdgeInsets.all(14)),
                                          ),
                                          icon: Icon(Icons.cancel),
                                          label: Text(
                                            'cancel'.tr,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white),
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
                    ));
          },
        ),
      ),
    );
  }

  void deleteData(BuildContext context, String? mat) {
    AwesomeDialog(
        context: context,
        animType: AnimType.SCALE,
        dialogType: DialogType.ERROR,
        body: Center(
          child: Text(
            '${'delete_item'.tr} ${mat}',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        title: 'delete'.tr,
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
                .deleteAutideurInterne(mat, widget.numFiche)
                .then((resp) async {
              ShowSnackBar.snackBar("Successfully", "Auditeur Interne Deleted",
                  Colors.orangeAccent);
              listAuditeur.removeWhere((element) => element.mat == mat);
              setState(() {});
              await ApiControllersCall().getAuditeurInterne();
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
              'cancel'.tr,
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
