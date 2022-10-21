import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:qualipro_flutter/Services/incident_environnement/incident_environnement_service.dart';
import 'package:qualipro_flutter/Services/visite_securite/visite_securite_service.dart';
import '../../../Controllers/incident_environnement/incident_environnement_controller.dart';
import '../../../Controllers/incident_securite/incident_securite_controller.dart';
import '../../../Controllers/visite_securite/visite_securite_controller.dart';
import '../../../Models/action/action_model.dart';
import '../../../Models/type_cause_model.dart';
import '../../../Route/app_route.dart';
import '../../../Services/action/action_service.dart';
import '../../../Services/action/local_action_service.dart';
import '../../../Services/incident_securite/incident_securite_service.dart';
import '../../../Services/incident_securite/local_incident_securite_service.dart';
import '../../../Utils/custom_colors.dart';
import '../../../Utils/shared_preference.dart';
import '../../../Utils/snack_bar.dart';

class ActionIncidentEnvironnementPage extends StatefulWidget {
  final numFiche;

 const ActionIncidentEnvironnementPage({Key? key, required this.numFiche}) : super(key: key);

  @override
  State<ActionIncidentEnvironnementPage> createState() => _ActionIncidentEnvironnementPageState();
}

class _ActionIncidentEnvironnementPageState extends State<ActionIncidentEnvironnementPage> {
  
  final matricule = SharedPreference.getMatricule();
  List<ActionModel> listAction = List<ActionModel>.empty(growable: true);

  @override
  void initState() {
    super.initState();
    getData();
  }
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
        await IncidentEnvironnementService().getActionsIncidentEnvironnement(widget.numFiche).then((resp) async {
          //isDataProcessing(false);
          resp.forEach((data) async {
            setState(() {
              var model = ActionModel();
              model.nAct = data['nAct'];
              model.act = data['act'];
              listAction.add(model);

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
            onPressed: (){
              //Get.back();
              Get.find<IncidentEnvironnementController>().listIncident.clear();
              Get.find<IncidentEnvironnementController>().getIncident();
              Get.toNamed(AppRoute.incident_environnement);
            },
            child: Icon(Icons.arrow_back, color: Colors.blue,),
          ),
          title: Text(
            'Actions of Incident Environnement N°${widget.numFiche}',
            style: TextStyle(color: Colors.black, fontSize: 15),
          ),
          backgroundColor: (lightPrimary),
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: listAction.isNotEmpty ?
            Container(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return
                    Card(
                      color: Color(0xFFE9EAEE),
                      child: ListTile(
                        leading: Text(
                          '${listAction[index].nAct}',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.lightBlue),
                        ),
                        title: Text(
                          '${listAction[index].act}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      /*  subtitle: Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.bodyLarge,
                              children: [
                                TextSpan(text: '${listAction[index].typeCause}'),

                                //TextSpan(text: '${action.declencheur}'),
                              ],

                            ),
                          ),
                        ), */
                        trailing: InkWell(
                            onTap: (){
                              deleteData(context, listAction[index].nAct);
                            },
                            child: Icon(Icons.delete, color: Colors.red,)
                        ),
                      ),
                    );
                },
                itemCount: listAction.length,
                //itemCount: actionsList.length + 1,
              ),
            )
                : Center(child: Text('empty_list'.tr, style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'Brand-Bold'
            )),)
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){

            final _addItemFormKey = GlobalKey<FormState>();
            int? selectedNAction = 0;
            ActionModel? actionModel = null;

            Future<List<ActionModel>> getAction(filter) async {
              try {
                List<ActionModel> _typeList = await List<ActionModel>.empty(growable: true);
                List<ActionModel> _typeFilter = await List<ActionModel>.empty(growable: true);
                var connection = await Connectivity().checkConnectivity();
                if(connection == ConnectivityResult.none) {
                  //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

                  var response = await LocalActionService().readAction();
                  response.forEach((data){
                    var model = ActionModel();
                    model.nAct = data['nAct'];
                    model.act = data['act'];
                    _typeList.add(model);
                  });
                }
                else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
                  //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

                  await ActionService().getActionMethod2({
                    "nact": "",
                    "act": "",
                    "refaud": "",
                    "mat": matricule.toString(),
                    "action_plus0": "",
                    "action_plus1": "",
                    "typeAction": ""
                  }).then((resp) async {
                    resp.forEach((data) async {
                      var model = ActionModel();
                      model.nAct = data['nAct'];
                      model.act = data['act'];
                      _typeList.add(model);
                    });
                  }
                      , onError: (err) {
                        ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
                      });
                }
                _typeFilter = _typeList.where((u) {
                  var query = u.act!.toLowerCase();
                  return query.contains(filter);
                }).toList();
                return _typeFilter;

              } catch (exception) {
                ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
                return Future.error('service : ${exception.toString()}');
              }
            }
            Widget _customDropDownAction(BuildContext context, ActionModel? item) {
              if (item == null) {
                return Container();
              }
              else{
                return Container(
                  child: ListTile(
                    contentPadding: EdgeInsets.all(0),
                    title: Text('${item.act}'),
                  ),
                );
              }
            }
            Widget _customPopupItemBuilderAction(
                BuildContext context,ActionModel item, bool isSelected) {
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
                  title: Text(item.act ?? ''),
                ),
              );
            }
            //bottomSheet
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
                    child: ListBody(
                      children: <Widget>[
                        SizedBox(height: 5.0,),
                        Center(
                          child: Text('Ajouter Action', style: TextStyle(
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
                                child: DropdownSearch<ActionModel>(
                                  showSelectedItems: true,
                                  showClearButton: true,
                                  showSearchBox: true,
                                  isFilteredOnline: true,
                                  compareFn: (i, s) => i?.isEqual(s) ?? false,
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText: "Action *",
                                    contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                    border: OutlineInputBorder(),
                                  ),
                                  onFind: (String? filter) => getAction(filter),
                                  onChanged: (data) {
                                    actionModel = data;
                                    selectedNAction = data?.nAct;
                                    print('Action: ${actionModel?.act}, num: ${selectedNAction}');
                                  },
                                  dropdownBuilder: _customDropDownAction,
                                  popupItemBuilder: _customPopupItemBuilderAction,
                                  validator: (u) =>
                                  u == null ? "Action est obligatoire " : null,
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
                                        await IncidentEnvironnementService().saveActionIncidentEnvironnement({
                                          "idFiche": widget.numFiche,
                                          "idAct": selectedNAction
                                        }).then((resp) async {
                                          Get.back();
                                          ShowSnackBar.snackBar("Successfully", "Action added", Colors.green);
                                          //Get.offAll(ActionIncidentEnvironnementPage(numFiche: widget.numFiche));
                                          setState(() {
                                            listAction.clear();
                                            getData();
                                          });
                                        }, onError: (err) {
                                          print('err : ${err.toString()}');
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
                          ),
                        ),
                      ],
                    ),
                  ),
                )
            );

          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 32,),
          backgroundColor: Colors.blue,
        ),
      ),
    );
  }
  //delete item
  deleteData(context, id){
    AwesomeDialog(
        context: context,
        animType: AnimType.SCALE,
        dialogType: DialogType.ERROR,
        body: Center(child: Text(
          'Are you sure to delete this item ${id}',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),),
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

            await IncidentEnvironnementService().deleteActionIncidentEnvironnementId(widget.numFiche, id).then((resp) async {
              ShowSnackBar.snackBar("Successfully", "Action Deleted", Colors.orangeAccent);
              listAction.removeWhere((element) => element.nAct == id);
              setState(() {
                listAction.clear();
                getData();
              });
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