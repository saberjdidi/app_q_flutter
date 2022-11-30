import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualipro_flutter/Services/reunion/local_reunion_service.dart';
import 'package:qualipro_flutter/Services/reunion/reunion_service.dart';
import 'package:qualipro_flutter/Utils/shared_preference.dart';
import 'package:qualipro_flutter/Utils/snack_bar.dart';
import 'package:qualipro_flutter/Widgets/refresh_widget.dart';
import '../../../Models/reunion/action_reunion.dart';
import '../../../Utils/custom_colors.dart';

class DecisionPage extends StatefulWidget {
  final nReunion;
  const DecisionPage({Key? key, required this.nReunion}) : super(key: key);

  @override
  State<DecisionPage> createState() => _DecisionPageState();
}

class _DecisionPageState extends State<DecisionPage> {
  List<ActionReunion> listAction = List<ActionReunion>.empty(growable: true);
  bool isVisibleDeleteButton = true;
  final matricule = SharedPreference.getMatricule();
  final language = SharedPreference.getLangue() ?? "";
  final keyRefresh = GlobalKey<RefreshIndicatorState>();
  ReunionService reunionService = ReunionService();
  LocalReunionService localReunionService = LocalReunionService();

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    try {
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        isVisibleDeleteButton = false;
        final response = await localReunionService
            .readActionReunionBynReunion(widget.nReunion);
        response.forEach((element) {
          setState(() {
            var model = ActionReunion();
            model.online = element['online'];
            model.nReunion = element['nReunion'];
            model.decision = element['decision'];
            model.nAct = element['nAct'];
            model.act = element['act'];
            model.efficacite = element['efficacite'];
            model.tauxRealisation = element['tauxRealisation'];
            model.actSimplif = element['actSimplif'];
            listAction.add(model);
          });
        });
      } else if (connection == ConnectivityResult.mobile ||
          connection == ConnectivityResult.wifi) {
        isVisibleDeleteButton = true;
        await reunionService.getActionReunionRattacher(widget.nReunion).then(
            (response) {
          response.forEach((element) {
            setState(() {
              var model = ActionReunion();
              model.online = 1;
              model.nReunion = element['nReunion'];
              model.decision = element['decision'];
              model.nAct = element['nAct'];
              model.act = element['act'];
              model.efficacite = element['efficacite'];
              model.tauxRealisation = element['tauxRealisation'];
              model.actSimplif = element['act_simplif'];
              listAction.add(model);
            });
          });
        }, onError: (error) {
          ShowSnackBar.snackBar("Error", error.toString(), Colors.red);
        });
      }
    } catch (Exception) {
      ShowSnackBar.snackBar("Exception", Exception.toString(), Colors.red);
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    const Color lightPrimary = Colors.white;
    const Color darkPrimary = Colors.white;
    return Container(
      decoration: const BoxDecoration(
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
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.blue,
            ),
          ),
          title: Text(
            'Decisions ${'of'.tr} ${'reunion'.tr} N°${widget.nReunion}',
            style: TextStyle(color: Colors.black, fontSize: 17),
          ),
          backgroundColor: (lightPrimary),
          elevation: 0,
        ),
        body: SafeArea(
            child: listAction.isNotEmpty
                ? Container(
                    child: RefreshWidget(
                      keyRefresh: keyRefresh,
                      onRefresh: () async {
                        listAction.clear();
                        getData();
                      },
                      child: ListView.builder(
                          itemCount: listAction.length,
                          itemBuilder: (context, index) {
                            return Card(
                              color: Color(0xFFE9EAEE),
                              child: ListTile(
                                leading: Text(
                                  '${listAction[index].nAct}',
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.lightBlue),
                                ),
                                title: Text(
                                  'Decision : ${listAction[index].decision}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Text(
                                        'Efficacite : ${listAction[index].efficacite}',
                                        style: const TextStyle(
                                            color: Color(0xFD233155),
                                            fontSize: 16),
                                      ),
                                    ),
                                    Text(
                                      'Taux real : ${listAction[index].tauxRealisation}',
                                      style: const TextStyle(
                                          color: Color(0xFD233155),
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                                trailing: Visibility(
                                  visible: isVisibleDeleteButton,
                                  child: InkWell(
                                      onTap: () {
                                        deleteActionReunion(
                                            context, listAction[index].nAct);
                                      },
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      )),
                                ),
                              ),
                            );
                          }),
                    ),
                  )
                : Center(
                    child: Text('empty_list'.tr,
                        style: const TextStyle(
                            fontSize: 20.0, fontFamily: 'Brand-Bold')),
                  )),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            final _addItemFormKey = GlobalKey<FormState>();
            int? selectedNAction = 0;
            String? selectedAction = '';
            ActionReunion? actionModel = null;

            Future<List<ActionReunion>> getAction(filter) async {
              try {
                List<ActionReunion> _typeList =
                    await List<ActionReunion>.empty(growable: true);
                List<ActionReunion> _typeFilter =
                    await List<ActionReunion>.empty(growable: true);
                var connection = await Connectivity().checkConnectivity();
                if (connection == ConnectivityResult.none) {
                  var response = await localReunionService
                      .readActionReunionARattacher(widget.nReunion);
                  response.forEach((data) {
                    var model = ActionReunion();
                    model.nAct = data['nAct'];
                    model.act = data['act'];
                    _typeList.add(model);
                  });
                } else if (connection == ConnectivityResult.wifi ||
                    connection == ConnectivityResult.mobile) {
                  await ReunionService()
                      .getActionReunionARattacher(
                          0, 200, widget.nReunion, matricule)
                      .then((resp) async {
                    resp.forEach((data) async {
                      var model = ActionReunion();
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
                BuildContext context, ActionReunion? item) {
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
                BuildContext context, ActionReunion item, bool isSelected) {
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
                                    child: DropdownSearch<ActionReunion>(
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
                                  const SizedBox(
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
                                            final connection =
                                                await Connectivity()
                                                    .checkConnectivity();
                                            if (connection ==
                                                ConnectivityResult.none) {
                                              var model = ActionReunion();
                                              model.online = 0;
                                              model.nReunion = widget.nReunion;
                                              model.nAct = selectedNAction;
                                              model.decision = selectedAction;
                                              model.act = selectedAction;
                                              model.efficacite = 0;
                                              model.tauxRealisation = 0;
                                              model.actSimplif = 0;
                                              await localReunionService
                                                  .saveActionReunion(model);
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
                                                    ConnectivityResult.mobile ||
                                                connection ==
                                                    ConnectivityResult.wifi) {
                                              await reunionService
                                                  .addActionReunion({
                                                "nReunion": widget.nReunion,
                                                "nAct": selectedNAction,
                                                "decision": selectedAction,
                                                "lang": language
                                              }).then((resp) async {
                                                Get.back();
                                                ShowSnackBar.snackBar(
                                                    "Successfully",
                                                    "Action added",
                                                    Colors.green);
                                                //Get.offAll(ActionIncidentEnvironnementPage(numFiche: widget.numFiche));
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

  deleteActionReunion(context, nAct) async {
    AwesomeDialog(
        context: context,
        animType: AnimType.SCALE,
        dialogType: DialogType.ERROR,
        body: Center(
          child: Text(
            '${'delete_item'.tr} ${nAct}',
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
            await reunionService
                .deleteActionReunion(widget.nReunion, nAct)
                .then((response) {
              listAction.removeWhere((element) => element.nAct == nAct);
              setState(() {});
              Navigator.of(context).pop();
            }, onError: (err) {
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
              print('Error : ${err.toString()}');
            });
          },
          child: const Padding(
            padding: EdgeInsets.all(8.0),
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
        )).show();
  }
}
