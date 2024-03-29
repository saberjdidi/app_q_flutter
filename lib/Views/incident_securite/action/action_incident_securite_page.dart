import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualipro_flutter/Services/visite_securite/visite_securite_service.dart';
import '../../../Models/incident_securite/action_inc_sec.dart';
import '../../../Services/incident_securite/incident_securite_service.dart';
import '../../../Services/incident_securite/local_incident_securite_service.dart';
import '../../../Utils/custom_colors.dart';
import '../../../Utils/shared_preference.dart';
import '../../../Utils/snack_bar.dart';

class ActionIncidentSecuritePage extends StatefulWidget {
  final numFiche;

  const ActionIncidentSecuritePage({Key? key, required this.numFiche})
      : super(key: key);

  @override
  State<ActionIncidentSecuritePage> createState() =>
      _ActionIncidentSecuritePageState();
}

class _ActionIncidentSecuritePageState
    extends State<ActionIncidentSecuritePage> {
  final matricule = SharedPreference.getMatricule();
  List<ActionIncSec> listAction = List<ActionIncSec>.empty(growable: true);
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
        /* Get.defaultDialog(
            title: 'mode_offline'.tr,
            backgroundColor: Colors.white,
            titleStyle: TextStyle(color: Colors.black),
            middleTextStyle: TextStyle(color: Colors.white),
            textCancel: "Back",
            onCancel: () {
              Get.back();
            },
            confirmTextColor: Colors.white,
            buttonColor: Colors.blue,
            barrierDismissible: false,
            radius: 20,
            content: Center(
              child: Column(
                children: <Widget>[
                  Lottie.asset('assets/images/empty_list.json',
                      width: 150, height: 150),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('no_internet'.tr,
                        style: TextStyle(color: Colors.blueGrey, fontSize: 20)),
                  ),
                ],
              ),
            )); */
        final response = await LocalIncidentSecuriteService()
            .readActionIncSecRattacherByidFiche(widget.numFiche);
        response.forEach((data) async {
          setState(() {
            var model = ActionIncSec();
            model.online = data['online'];
            model.idFiche = data['idFiche'];
            model.nAct = data['nAct'];
            model.act = data['act'];
            listAction.add(model);
          });
        });
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        isVisibleBtnDelete = true;
        //rest api
        await IncidentSecuriteService()
            .getActionsIncidentSecurite(widget.numFiche, '1')
            .then((resp) async {
          //isDataProcessing(false);
          resp.forEach((data) async {
            setState(() {
              var model = ActionIncSec();
              model.online = 1;
              model.idFiche = data['ref'];
              model.nAct = data['nact'];
              model.act = data['act'];
              listAction.add(model);
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
              Get.back();
              //Get.find<IncidentSecuriteController>().listIncident.clear();
              // Get.find<IncidentSecuriteController>().getIncident();
              // Get.toNamed(AppRoute.incident_securite);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.blue,
            ),
          ),
          title: Text(
            'Actions Incident Securite N°${widget.numFiche}',
            style: TextStyle(color: Colors.black, fontSize: 17),
          ),
          backgroundColor: (lightPrimary),
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: listAction.isNotEmpty
                ? Container(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Card(
                          color: Color(0xFFE9EAEE),
                          child: ListTile(
                            leading: Text(
                              '${listAction[index].nAct}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.lightBlue),
                            ),
                            title: Text(
                              '${listAction[index].act}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            trailing: Visibility(
                              visible: isVisibleBtnDelete,
                              child: InkWell(
                                  onTap: () {
                                    deleteData(context, listAction[index].nAct);
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  )),
                            ),
                          ),
                        );
                      },
                      itemCount: listAction.length,
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
            final _addItemFormKey = GlobalKey<FormState>();
            int? selectedNAction = 0;
            String? selectedAction = '';
            ActionIncSec? actionModel = null;

            Future<List<ActionIncSec>> getAction(filter) async {
              try {
                List<ActionIncSec> _typeList =
                    await List<ActionIncSec>.empty(growable: true);
                List<ActionIncSec> _typeFilter =
                    await List<ActionIncSec>.empty(growable: true);
                var connection = await Connectivity().checkConnectivity();
                if (connection == ConnectivityResult.none) {
                  //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

                  var response = await LocalIncidentSecuriteService()
                      .readActionIncSecARattacher(widget.numFiche);
                  response.forEach((data) {
                    var model = ActionIncSec();
                    model.nAct = data['nAct'];
                    model.act = data['act'];
                    _typeList.add(model);
                  });
                } else if (connection == ConnectivityResult.wifi ||
                    connection == ConnectivityResult.mobile) {
                  await VisiteSecuriteService()
                      .getActionsVSARattacher(0, 300, widget.numFiche,
                          'incident_securite', matricule)
                      .then((resp) async {
                    resp.forEach((data) async {
                      var model = ActionIncSec();
                      model.nAct = data['nAct'];
                      model.act = data['act'];
                      _typeList.add(model);
                    });
                  }, onError: (err) {
                    ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
                  });
                }
                _typeFilter = _typeList.where((u) {
                  var query = u.act!.toLowerCase();
                  return query.contains(filter);
                }).toList();
                return _typeFilter;
              } catch (exception) {
                ShowSnackBar.snackBar(
                    "Exception", exception.toString(), Colors.red);
                return Future.error('service : ${exception.toString()}');
              }
            }

            Widget _customDropDownAction(
                BuildContext context, ActionIncSec? item) {
              if (item == null) {
                return Container();
              } else {
                return Container(
                  child: ListTile(
                    contentPadding: EdgeInsets.all(0),
                    title: Text('${item.act}'),
                  ),
                );
              }
            }

            Widget _customPopupItemBuilderAction(
                BuildContext context, ActionIncSec item, bool isSelected) {
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
                  title: Text(item.act ?? ''),
                  subtitle: Text('${item.nAct.toString()}'),
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
                        child: ListBody(
                          children: <Widget>[
                            SizedBox(
                              height: 5.0,
                            ),
                            Center(
                              child: Text(
                                '${'new'.tr} Action',
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
                                    child: DropdownSearch<ActionIncSec>(
                                      showSelectedItems: true,
                                      showClearButton: true,
                                      showSearchBox: true,
                                      isFilteredOnline: true,
                                      compareFn: (i, s) =>
                                          i?.isEqual(s) ?? false,
                                      dropdownSearchDecoration: InputDecoration(
                                        labelText: "Action *",
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
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Text(
                                                '${'list'.tr} Actions',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                          getAction(filter),
                                      onChanged: (data) {
                                        actionModel = data;
                                        selectedNAction = data?.nAct;
                                        selectedAction = data?.act;
                                        debugPrint(
                                            'Action: $selectedAction, num: ${selectedNAction}');
                                      },
                                      dropdownBuilder: _customDropDownAction,
                                      popupItemBuilder:
                                          _customPopupItemBuilderAction,
                                      validator: (u) => u == null
                                          ? "Action ${'is_required'.tr}"
                                          : null,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ConstrainedBox(
                                    constraints: BoxConstraints.tightFor(
                                        width:
                                            MediaQuery.of(context).size.width /
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
                                                CustomColors.firebaseRedAccent),
                                        padding: MaterialStateProperty.all(
                                            EdgeInsets.all(14)),
                                      ),
                                      icon: Icon(Icons.cancel),
                                      label: Text(
                                        'cancel'.tr,
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white),
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
                                        width:
                                            MediaQuery.of(context).size.width /
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
                                                CustomColors.googleBackground),
                                        padding: MaterialStateProperty.all(
                                            EdgeInsets.all(14)),
                                      ),
                                      icon: Icon(Icons.save),
                                      label: Text(
                                        'save'.tr,
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white),
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
                                              var model = ActionIncSec();
                                              model.online = 0;
                                              model.idFiche = widget.numFiche;
                                              model.nAct = selectedNAction;
                                              model.act = selectedAction;
                                              await LocalIncidentSecuriteService()
                                                  .saveActionIncSecRattacher(
                                                      model);
                                              Get.back();
                                              setState(() {
                                                listAction.clear();
                                                getData();
                                              });
                                              ShowSnackBar.snackBar(
                                                  "Successfully",
                                                  "Action added",
                                                  Colors.green);
                                            } else if (connection ==
                                                    ConnectivityResult.wifi ||
                                                connection ==
                                                    ConnectivityResult.mobile) {
                                              await IncidentSecuriteService()
                                                  .saveActionIncidentSecurite({
                                                "idFiche": widget.numFiche,
                                                "idAct": selectedNAction
                                              }).then((resp) async {
                                                Get.back();
                                                ShowSnackBar.snackBar(
                                                    "Successfully",
                                                    "Action added",
                                                    Colors.green);
                                                //Get.offAll(ActionIncidentSecuritePage(numFiche: widget.numFiche));
                                                setState(() {
                                                  listAction.clear();
                                                  getData();
                                                });
                                              }, onError: (err) {
                                                print(
                                                    'err : ${err.toString()}');
                                                ShowSnackBar.snackBar("Error",
                                                    err.toString(), Colors.red);
                                              });
                                            }
                                          } catch (ex) {
                                            print("Exception" + ex.toString());
                                            ShowSnackBar.snackBar("Exception",
                                                ex.toString(), Colors.red);
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
  deleteData(context, id) {
    AwesomeDialog(
        context: context,
        animType: AnimType.SCALE,
        dialogType: DialogType.ERROR,
        body: Center(
          child: Text(
            '${'delete_item'.tr} ${id}',
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
            await IncidentSecuriteService()
                .deleteActionIncidentSecuriteById(widget.numFiche, id)
                .then((resp) async {
              ShowSnackBar.snackBar(
                  "Successfully", "Action Deleted", Colors.orangeAccent);
              listAction.removeWhere((element) => element.nAct == id);
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
              'cancel',
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
