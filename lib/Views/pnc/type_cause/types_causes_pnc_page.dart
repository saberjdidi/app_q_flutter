import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualipro_flutter/Services/pnc/local_pnc_service.dart';
import 'package:qualipro_flutter/Services/pnc/pnc_service.dart';
import '../../../Models/pnc/type_cause_pnc_model.dart';
import '../../../Services/action/local_action_service.dart';
import '../../../Utils/custom_colors.dart';
import '../../../Utils/shared_preference.dart';
import '../../../Utils/snack_bar.dart';

class TypesCausesPNCPage extends StatefulWidget {
  final nnc;

  const TypesCausesPNCPage({Key? key, required this.nnc}) : super(key: key);

  @override
  State<TypesCausesPNCPage> createState() => _TypesCausesPNCPageState();
}

class _TypesCausesPNCPageState extends State<TypesCausesPNCPage> {
  LocalActionService localService = LocalActionService();
  //ActionService actionService = ActionService();
  final matricule = SharedPreference.getMatricule();
  List<TypeCausePNCModel> listTypesCauses =
      List<TypeCausePNCModel>.empty(growable: true);
  bool isVisibleDeleteButton = true;

  @override
  void initState() {
    super.initState();
    getTypeCauses();
  }

  void getTypeCauses() async {
    try {
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        var response = await LocalPNCService().readTypeCauseByNNC(widget.nnc);
        response.forEach((data) {
          setState(() {
            var model = TypeCausePNCModel();
            model.idTypeCause = data['idTypeCause'];
            model.codetypecause = data['codetypecause'];
            model.typecause = data['typecause'];
            listTypesCauses.add(model);
            isVisibleDeleteButton = false;
          });
        });
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //rest api
        await PNCService().getTypesCausesOfPNC(widget.nnc).then((resp) async {
          //isDataProcessing(false);
          resp.forEach((data) async {
            setState(() {
              var model = TypeCausePNCModel();
              model.idTypeCause = data['id_tab_pnc_typeCause'];
              model.codetypecause = data['codeTypeCause'];
              model.typecause = data['typeCause'];
              listTypesCauses.add(model);
              isVisibleDeleteButton = true;
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
              // Get.find<PNCController>().listPNC.clear();
              // Get.find<PNCController>().getPNC();
              //Get.offAllNamed(AppRoute.pnc);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.blue,
            ),
          ),
          title: Text(
            'Types Causes ${'of'.tr} P.N.C N°${widget.nnc}',
            style: TextStyle(color: Colors.black, fontSize: 15),
          ),
          backgroundColor: (lightPrimary),
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: listTypesCauses.isNotEmpty
                ? Container(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        final num_nc = widget.nnc;
                        return Card(
                          color: Color(0xFFE9EAEE),
                          child: ListTile(
                            title: Text(
                              ' PNC N°${num_nc}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: RichText(
                                text: TextSpan(
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  children: [
                                    /* WidgetSpan(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                          child: Icon(Icons.amp_stories),
                                        ),
                                      ), */
                                    TextSpan(
                                        text:
                                            '${listTypesCauses[index].typecause}'),

                                    //TextSpan(text: '${action.declencheur}'),
                                  ],
                                ),
                              ),
                            ),
                            trailing: Visibility(
                              visible: isVisibleDeleteButton,
                              child: InkWell(
                                  onTap: () {
                                    deleteTypeCausePNC(context,
                                        listTypesCauses[index].idTypeCause);
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  )),
                            ),
                          ),
                        );
                      },
                      itemCount: listTypesCauses.length,
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
            //Get.to(NewTypeCausePNC(nnc: widget.nnc));
            final _addItemFormKey = GlobalKey<FormState>();
            int? selectedTypeCode = 0;
            String? typeCause = "";
            TypeCausePNCModel? typeCauseModel = null;

            //types cause
            Future<List<TypeCausePNCModel>> getTypesCause(filter) async {
              try {
                List<TypeCausePNCModel> typeCauseList =
                    await List<TypeCausePNCModel>.empty(growable: true);
                List<TypeCausePNCModel> typeCauseFilter =
                    await <TypeCausePNCModel>[];
                var connection = await Connectivity().checkConnectivity();
                if (connection == ConnectivityResult.none) {
                  //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
                  var response = await LocalPNCService()
                      .readTypeCausePNCARattacher(widget.nnc);
                  response.forEach((data) {
                    var model = TypeCausePNCModel();
                    model.codetypecause = data['codetypecause'];
                    model.typecause = data['typecause'];
                    typeCauseList.add(model);
                  });
                } else if (connection == ConnectivityResult.wifi ||
                    connection == ConnectivityResult.mobile) {
                  //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

                  await PNCService().getTypesCausesToAdded(widget.nnc).then(
                      (resp) async {
                    resp.forEach((data) async {
                      var model = TypeCausePNCModel();
                      model.codetypecause = data['codeTypeCause'];
                      model.typecause = data['typeCause'];
                      typeCauseList.add(model);
                    });
                  }, onError: (err) {
                    ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
                  });
                }

                typeCauseFilter = typeCauseList.where((u) {
                  var name = u.codetypecause.toString().toLowerCase();
                  var description = u.typecause!.toLowerCase();
                  return name.contains(filter) || description.contains(filter);
                }).toList();
                return typeCauseFilter;
              } catch (exception) {
                ShowSnackBar.snackBar(
                    "Exception", exception.toString(), Colors.red);
                return Future.error('service : ${exception.toString()}');
              }
            }

            Widget _customDropDownTypeCause(
                BuildContext context, TypeCausePNCModel? item) {
              if (item == null) {
                return Container();
              } else {
                return Container(
                  child: ListTile(
                    contentPadding: EdgeInsets.all(0),
                    title: Text('${item.typecause}'),
                    //subtitle: Text('${item?.codetypecause.toString()}'),
                  ),
                );
              }
            }

            Widget _customPopupItemBuilderTypeCause(
                BuildContext context, TypeCausePNCModel item, bool isSelected) {
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
                  title: Text(item.typecause ?? ''),
                  //subtitle: Text(item.codetypecause.toString() ?? ''),
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
                    maxChildSize: 0.7,
                    minChildSize: 0.4,
                    builder: (context, scrollController) =>
                        SingleChildScrollView(
                          child: ListBody(
                            children: [
                              SizedBox(
                                height: 5.0,
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: Center(
                                    child: Text(
                                      '${'new'.tr} Type Cause ${'of'.tr} P.N.C N°${widget.nnc}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "Brand-Bold",
                                          color: Color(0xFF0769D2),
                                          fontSize: 17.0),
                                    ),
                                  ),
                                ),
                              ),
                              Form(
                                key: _addItemFormKey,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, bottom: 5.0),
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 15.0,
                                      ),
                                      Visibility(
                                          visible: true,
                                          child:
                                              DropdownSearch<TypeCausePNCModel>(
                                            showSelectedItems: true,
                                            showClearButton: true,
                                            showSearchBox: true,
                                            isFilteredOnline: true,
                                            compareFn: (i, s) =>
                                                i?.isEqual(s) ?? false,
                                            dropdownSearchDecoration:
                                                InputDecoration(
                                              labelText: "Type Cause *",
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      12, 12, 0, 0),
                                              border: OutlineInputBorder(),
                                            ),
                                            popupTitle: Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                    child: Text(
                                                      '${'list'.tr} Type Cause',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  IconButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      icon: Icon(
                                                        Icons.close,
                                                        color: Colors.red,
                                                      ))
                                                ],
                                              ),
                                            ),
                                            onFind: (String? filter) =>
                                                getTypesCause(filter),
                                            onChanged: (data) {
                                              typeCauseModel = data;
                                              selectedTypeCode =
                                                  data?.codetypecause;
                                              typeCause = data?.typecause;
                                              debugPrint(
                                                  'type cause: ${typeCause}, code: ${selectedTypeCode}');
                                            },
                                            dropdownBuilder:
                                                _customDropDownTypeCause,
                                            popupItemBuilder:
                                                _customPopupItemBuilderTypeCause,
                                            validator: (u) => u == null
                                                ? "Type cause ${'is_required'.tr} "
                                                : null,
                                          )),
                                      SizedBox(
                                        height: 20.0,
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
                                                  int max_type_cause =
                                                      await LocalPNCService()
                                                          .getMaxNumTypeCausePNC();
                                                  var model =
                                                      TypeCausePNCModel();
                                                  model.online = 0;
                                                  model.nnc = widget.nnc;
                                                  model.idTypeCause =
                                                      max_type_cause + 1;
                                                  model.codetypecause =
                                                      selectedTypeCode;
                                                  model.typecause = typeCause;
                                                  await LocalPNCService()
                                                      .saveTypeCausePNC(model);
                                                  Get.back();
                                                  setState(() {
                                                    listTypesCauses.clear();
                                                    getTypeCauses();
                                                  });
                                                  ShowSnackBar.snackBar(
                                                      "Successfully",
                                                      "Type Cause added",
                                                      Colors.green);
                                                } else if (connection ==
                                                        ConnectivityResult
                                                            .mobile ||
                                                    connection ==
                                                        ConnectivityResult
                                                            .wifi) {
                                                  await PNCService()
                                                      .addTypeCauseByNNC({
                                                    "nnc": widget.nnc,
                                                    "codetypecause":
                                                        selectedTypeCode
                                                  }).then((resp) async {
                                                    Get.back();
                                                    ShowSnackBar.snackBar(
                                                        "Successfully",
                                                        "Type Cause added",
                                                        Colors.green);
                                                    setState(() {
                                                      listTypesCauses.clear();
                                                      getTypeCauses();
                                                    });
                                                  }, onError: (err) {
                                                    if (kDebugMode)
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
                                                throw Exception("Exception : " +
                                                    ex.toString());
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.0,
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
                              )
                            ],
                          ),
                        )));
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

//delete type cause
  deleteTypeCausePNC(context, position) {
    AwesomeDialog(
        context: context,
        animType: AnimType.SCALE,
        dialogType: DialogType.ERROR,
        body: Center(
          child: Text(
            '${'delete_item'.tr} ${position}',
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
            await PNCService().deleteTypeCausePNCByID(position).then(
                (resp) async {
              ShowSnackBar.snackBar(
                  "Successfully", "Type Cause Deleted", Colors.green);
              listTypesCauses
                  .removeWhere((element) => element.idTypeCause == position);
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
