import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:qualipro_flutter/Services/incident_securite/incident_securite_service.dart';
import 'package:qualipro_flutter/Services/visite_securite/visite_securite_service.dart';
import '../../../Controllers/api_controllers_call.dart';
import '../../../Controllers/incident_securite/incident_securite_controller.dart';
import '../../../Controllers/visite_securite/visite_securite_controller.dart';
import '../../../Models/employe_model.dart';
import '../../../Models/visite_securite/equipe_visite_securite_model.dart';
import '../../../Route/app_route.dart';
import '../../../Services/visite_securite/local_visite_securite_service.dart';
import '../../../Utils/custom_colors.dart';
import '../../../Utils/shared_preference.dart';
import '../../../Utils/snack_bar.dart';

class EquipeVisiteSecPage extends StatefulWidget {
  final numFiche;

  const EquipeVisiteSecPage({Key? key, required this.numFiche})
      : super(key: key);

  @override
  State<EquipeVisiteSecPage> createState() => _EquipeVisiteSecPageState();
}

class _EquipeVisiteSecPageState extends State<EquipeVisiteSecPage> {
  final matricule = SharedPreference.getMatricule();
  List<EquipeVisiteSecuriteModel> listEquipe =
      List<EquipeVisiteSecuriteModel>.empty(growable: true);
  bool isVisibleBtnDelete = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    try {
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        isVisibleBtnDelete = false;
        var response = await LocalVisiteSecuriteService()
            .readEquipeVisiteSecuriteOfflineByIdFiche(widget.numFiche);
        response.forEach((data) {
          setState(() {
            var model = EquipeVisiteSecuriteModel();
            model.online = data['online'];
            model.id = data['idFiche'];
            model.mat = data['mat'];
            model.nompre = data['nompre'];
            model.affectation = data['affectation'];
            listEquipe.add(model);
          });
        });
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        isVisibleBtnDelete = true;
        //rest api
        await VisiteSecuriteService()
            .getEquipeVisiteSecurite(widget.numFiche)
            .then((response) async {
          //isDataProcessing(false);
          response.forEach((data) async {
            setState(() {
              var model = EquipeVisiteSecuriteModel();
              model.online = 1;
              model.id = data['id_Fiche'];
              model.mat = data['resp'];
              model.nompre = data['nomPre'];
              model.affectation = data['affectation'];
              listEquipe.add(model);
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
  Widget build(BuildContext context) {
    const Color lightPrimary = Colors.white;
    const Color darkPrimary = Colors.white;

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
              //Get.back();
              Get.find<VisiteSecuriteController>().listVisiteSecurite.clear();
              Get.find<VisiteSecuriteController>().getData();
              Get.toNamed(AppRoute.visite_securite);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.blue,
            ),
          ),
          title: Text(
            'Equipe Visite Securite N°${widget.numFiche}',
            style: TextStyle(color: Colors.black, fontSize: 15),
          ),
          backgroundColor: (lightPrimary),
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: listEquipe.isNotEmpty
                ? Container(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        final affectation = listEquipe[index].affectation;
                        String? message_evaluation = '';
                        switch (affectation) {
                          case 1:
                            message_evaluation = "Observateur";
                            break;
                          case 2:
                            message_evaluation = "Auditeur";
                            break;
                          case 3:
                            message_evaluation = "Responsable Audit";
                            break;
                          default:
                            message_evaluation = "";
                        }

                        return Card(
                          color: Color(0xFFE9EAEE),
                          child: ListTile(
                            leading: Text(
                              '${listEquipe[index].mat} ${listEquipe[index].online == 1 ? '' : '*'}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.lightBlue),
                            ),
                            title: Text(
                              '${listEquipe[index].nompre}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: RichText(
                                text: TextSpan(
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  children: [
                                    TextSpan(text: '$message_evaluation'),
                                    //TextSpan(text: '${action.declencheur}'),
                                  ],
                                ),
                              ),
                            ),
                            trailing: Visibility(
                              visible: isVisibleBtnDelete,
                              child: InkWell(
                                  onTap: () async {
                                    deleteData(context, listEquipe[index].mat);
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  )),
                            ),
                          ),
                        );
                      },
                      itemCount: listEquipe.length,
                      //itemCount: actionsList.length + 1,
                    ),
                  )
                : Center(
                    child: Text('empty_list'.tr,
                        style: TextStyle(
                            fontSize: 20.0, fontFamily: 'Brand-Bold')),
                  )),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            //Get.to(NewCauseTypiqueIncidentSecurite(numFiche: widget.numFiche));
            final _addItemFormKey = GlobalKey<FormState>();
            String? employeMatricule = "";
            String? employeNompre = "";
            Object? affectation = 3;
            //getEmploye
            Future<List<EmployeModel>> getEmploye(filter) async {
              try {
                List<EmployeModel> employeList =
                    await List<EmployeModel>.empty(growable: true);
                List<EmployeModel> employeFilter =
                    await List<EmployeModel>.empty(growable: true);
                var response = await LocalVisiteSecuriteService()
                    .readEmployeEquipeVisiteSecuriteOffline(widget.numFiche);
                //var response = await LocalActionService().readEmploye();
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
                ShowSnackBar.snackBar(
                    "Exception", exception.toString(), Colors.red);
                return Future.error('service : ${exception.toString()}');
              }
            }

            Widget customDropDownEmploye(
                BuildContext context, EmployeModel? item) {
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
                BuildContext context, EmployeModel item, bool isSelected) {
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

            //bottomSheet
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
                                    'Equipe Visite Securite',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "Signatra",
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
                                        child: DropdownSearch<EmployeModel>(
                                          showSelectedItems: true,
                                          showClearButton: true,
                                          showSearchBox: true,
                                          isFilteredOnline: true,
                                          compareFn: (i, s) =>
                                              i?.isEqual(s) ?? false,
                                          dropdownSearchDecoration:
                                              InputDecoration(
                                            labelText: "Employe *",
                                            contentPadding: EdgeInsets.fromLTRB(
                                                12, 12, 0, 0),
                                            border: OutlineInputBorder(),
                                          ),
                                          onFind: (String? filter) =>
                                              getEmploye(filter),
                                          onChanged: (data) {
                                            employeMatricule = data?.mat;
                                            employeNompre = data?.nompre;
                                            print(
                                                'employe: ${employeNompre}, mat: ${employeMatricule}');
                                          },
                                          dropdownBuilder:
                                              customDropDownEmploye,
                                          popupItemBuilder:
                                              customPopupItemBuilderEmploye,
                                          validator: (u) => u == null
                                              ? "Employe is required "
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
                                                value: 3,
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
                                                value: 2,
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
                                                value: 1,
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
                                                        .firebaseRedAccent),
                                            padding: MaterialStateProperty.all(
                                                EdgeInsets.all(14)),
                                          ),
                                          icon: Icon(Icons.cancel),
                                          label: Text(
                                            'Cancel',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white),
                                          ),
                                          onPressed: () {
                                            Get.back();
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
                                                        .googleBackground),
                                            padding: MaterialStateProperty.all(
                                                EdgeInsets.all(14)),
                                          ),
                                          icon: Icon(Icons.save),
                                          label: Text(
                                            'Save',
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
                                                  var model =
                                                      EquipeVisiteSecuriteModel();
                                                  model.online = 0;
                                                  model.id = widget.numFiche;
                                                  model.affectation = int.parse(
                                                      affectation.toString());
                                                  model.mat = employeMatricule;
                                                  model.nompre = employeNompre;
                                                  await LocalVisiteSecuriteService()
                                                      .saveEquipeVisiteSecuriteOffline(
                                                          model);
                                                  Get.back();
                                                  ShowSnackBar.snackBar(
                                                      "Successfully",
                                                      "added to Equipe",
                                                      Colors.green);
                                                  //await Get.offAll(EquipeVisiteSecPage(numFiche: widget.numFiche));
                                                  setState(() {
                                                    listEquipe.clear();
                                                    getData();
                                                  });
                                                } else if (connection ==
                                                        ConnectivityResult
                                                            .wifi ||
                                                    connection ==
                                                        ConnectivityResult
                                                            .mobile) {
                                                  await VisiteSecuriteService()
                                                      .saveEquipeVisiteSecurite({
                                                    "idFiche": widget.numFiche,
                                                    "respMat": employeMatricule,
                                                    "affectation": affectation
                                                  }).then((resp) async {
                                                    Get.back();
                                                    ShowSnackBar.snackBar(
                                                        "Successfully",
                                                        "added to Equipe",
                                                        Colors.green);
                                                    //await Get.offAll(EquipeVisiteSecPage(numFiche: widget.numFiche));
                                                    setState(() {
                                                      listEquipe.clear();
                                                      getData();
                                                    });
                                                    await ApiControllersCall()
                                                        .getEquipeVisiteSecuriteFromAPI();
                                                  }, onError: (err) {
                                                    print(
                                                        'err : ${err.toString()}');
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
                                                    "Error " + ex.toString());
                                              }
                                            }
                                          },
                                        ),
                                      )
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
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 32,
          ),
          backgroundColor: Colors.blue,
        ),
      ),
    );
  }

  //delete item
  deleteData(context, mat) {
    AwesomeDialog(
        context: context,
        animType: AnimType.SCALE,
        dialogType: DialogType.ERROR,
        body: Center(
          child: Text(
            'Are you sure to delete this item ${mat}',
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
            await VisiteSecuriteService()
                .deleteEquipeVisiteSecuriteById(widget.numFiche, mat)
                .then((resp) async {
              ShowSnackBar.snackBar(
                  "Successfully", "${mat} Deleted", Colors.orangeAccent);
              listEquipe.removeWhere((element) => element.mat == mat);
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
}
