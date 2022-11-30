import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualipro_flutter/Services/visite_securite/visite_securite_service.dart';
import '../../../Controllers/visite_securite/visite_securite_controller.dart';
import '../../../Models/visite_securite/action_visite_securite.dart';
import '../../../Route/app_route.dart';
import '../../../Services/visite_securite/local_visite_securite_service.dart';
import '../../../Utils/custom_colors.dart';
import '../../../Utils/shared_preference.dart';
import '../../../Utils/snack_bar.dart';

class ActionVisiteSecuritePage extends StatefulWidget {
  final numFiche;

  const ActionVisiteSecuritePage({Key? key, required this.numFiche})
      : super(key: key);

  @override
  State<ActionVisiteSecuritePage> createState() =>
      _ActionVisiteSecuritePageState();
}

class _ActionVisiteSecuritePageState extends State<ActionVisiteSecuritePage> {
  final matricule = SharedPreference.getMatricule();
  List<ActionVisiteSecurite> listAction =
      List<ActionVisiteSecurite>.empty(growable: true);
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
        final response = await LocalVisiteSecuriteService()
            .readActionVSRattacherByidFiche(widget.numFiche);
        response.forEach((data) async {
          setState(() {
            var model = ActionVisiteSecurite();
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
        await VisiteSecuriteService()
            .getActionsVisiteSecurite(widget.numFiche)
            .then((resp) async {
          //isDataProcessing(false);
          resp.forEach((data) async {
            setState(() {
              var model = ActionVisiteSecurite();
              model.online = 1;
              model.idFiche = data['idFiche'];
              model.nAct = data['nAct'];
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
            'Actions ${'of'.tr} ${'visite_securite'.tr} N°${widget.numFiche}',
            style: TextStyle(color: Colors.black, fontSize: 15),
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
            ActionVisiteSecurite? actionModel = null;

            Future<List<ActionVisiteSecurite>> getAction(filter) async {
              try {
                List<ActionVisiteSecurite> _typeList =
                    await List<ActionVisiteSecurite>.empty(growable: true);
                List<ActionVisiteSecurite> _typeFilter =
                    await List<ActionVisiteSecurite>.empty(growable: true);
                var connection = await Connectivity().checkConnectivity();
                if (connection == ConnectivityResult.none) {
                  //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

                  var response = await LocalVisiteSecuriteService()
                      .readActionVSARattacher(widget.numFiche);
                  response.forEach((data) {
                    var model = ActionVisiteSecurite();
                    model.nAct = data['nAct'];
                    model.act = data['act'];
                    _typeList.add(model);
                  });
                } else if (connection == ConnectivityResult.wifi ||
                    connection == ConnectivityResult.mobile) {
                  //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

                  await VisiteSecuriteService()
                      .getActionsVSARattacher(
                          0, 300, widget.numFiche, 'visite_securite', matricule)
                      .then((resp) async {
                    resp.forEach((data) async {
                      var model = ActionVisiteSecurite();
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
                BuildContext context, ActionVisiteSecurite? item) {
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

            Widget _customPopupItemBuilderAction(BuildContext context,
                ActionVisiteSecurite item, bool isSelected) {
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
                                    fontSize: 20.0),
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
                                    child: DropdownSearch<ActionVisiteSecurite>(
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
                                            'Action: ${selectedAction}, num: ${selectedNAction}');
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
                                              var model =
                                                  ActionVisiteSecurite();
                                              model.online = 0;
                                              model.idFiche = widget.numFiche;
                                              model.nAct = selectedNAction;
                                              model.act = selectedAction;
                                              await LocalVisiteSecuriteService()
                                                  .saveActionVSRattacher(model);
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
                                              await VisiteSecuriteService()
                                                  .saveActionVisiteSecurite({
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
                                                debugPrint(
                                                    'err : ${err.toString()}');
                                                ShowSnackBar.snackBar("Error",
                                                    err.toString(), Colors.red);
                                              });
                                            }
                                          } catch (ex) {
                                            debugPrint(
                                                "Exception" + ex.toString());
                                            ShowSnackBar.snackBar("Exception",
                                                ex.toString(), Colors.red);
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
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ));
            //Get.to(NewTypeCauseIncidentSecurite(numFiche: widget.numFiche));
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

  saveBtn() async {}

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
            await VisiteSecuriteService()
                .deleteActionVisiteSecuriteById(widget.numFiche, id)
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
