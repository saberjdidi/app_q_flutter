import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:qualipro_flutter/Models/employe_model.dart';
import 'package:qualipro_flutter/Models/product_model.dart';
import 'package:readmore/readmore.dart';
import '../../../Services/action/action_service.dart';
import '../../../Services/action/local_action_service.dart';
import '../../../Utils/custom_colors.dart';
import '../../../Utils/shared_preference.dart';
import '../../../Utils/snack_bar.dart';
import '../../Models/type_cause_model.dart';

class TypesCausesActionPage extends StatefulWidget {
  final idAction;

 const TypesCausesActionPage({Key? key, required this.idAction}) : super(key: key);

  @override
  State<TypesCausesActionPage> createState() => _TypesCausesActionPageState();
}

class _TypesCausesActionPageState extends State<TypesCausesActionPage> {

  LocalActionService localService = LocalActionService();
  //ActionService actionService = ActionService();
  final matricule = SharedPreference.getMatricule();
  List<TypeCauseModel> listTypesCauses = List<TypeCauseModel>.empty(growable: true);

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
        var response = await localService.readTypeCauseActionById(widget.idAction);
        response.forEach((data){
          setState(() {
            var model = TypeCauseModel();
            model.online = data['online'];
            model.nAct = data['nAct'];
            model.idTypeCause = data['idTypeCause'];
            model.codetypecause = data['codetypecause'];
            model.typecause = data['typecause'];
            listTypesCauses.add(model);

          });
        });
        isVisibleBtnDelete = false;
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        //rest api
        await ActionService().getTypesCausesOfAction(matricule, widget.idAction, 1)
            .then((resp) async {
          //isDataProcessing(false);
          resp.forEach((data) async {
            setState(() {
              var model = TypeCauseModel();
              model.online = 1;
              model.nAct = data['nact'];
              model.idTypeCause = data['id_tab_act_typecause'];
              model.codetypecause = data['codeTypeCause'];
              model.typecause = data['typeCause'];
              listTypesCauses.add(model);

            });
          });
        }
            , onError: (err) {
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });
        isVisibleBtnDelete = true;
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
              Get.back();
              //Get.offAll(HomePage());
            },
            child: Icon(Icons.arrow_back, color: Colors.blue,),
          ),
          title: Text(
            'Types Causes',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: (lightPrimary),
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: listTypesCauses.isNotEmpty ?
            Container(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  final num_action = widget.idAction;
                  return
                    Column(
                      children: [
                        ListTile(
                          title: Text(
                            ' Action N°${num_action}',
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
                                  TextSpan(text: '${listTypesCauses[index].typecause}'),

                                  //TextSpan(text: '${action.declencheur}'),
                                ],

                              ),
                            ),
                          ),
                          trailing: Visibility(
                            visible: isVisibleBtnDelete,
                            child: InkWell(
                                onTap: (){
                                  deleteTypeCauseAction(context, listTypesCauses[index].idTypeCause);
                                },
                                child: Icon(Icons.delete, color: Colors.red,)
                            ),
                          ),
                        ),
                        Divider(
                          thickness: 1.0,
                          color: Colors.blue,
                        ),
                      ],
                    );
                },
                itemCount: listTypesCauses.length,
                //itemCount: actionsList.length + 1,
              ),
            )
                : const Center(child: Text('Empty List', style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'Brand-Bold'
            )),)
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            //Get.to(NewTypeCausePNC(nnc: widget.nnc));
            final _addItemFormKey = GlobalKey<FormState>();
            int? selectedTypeCode = 0;
            String? typeCause = "";
            TypeCauseModel? typeCauseModel = null;

            //types cause
            Future<List<TypeCauseModel>> getTypesCause(filter) async {
              try {
                List<TypeCauseModel> typeCauseList = await List<TypeCauseModel>.empty(growable: true);
                List<TypeCauseModel> typeCauseFilter = await <TypeCauseModel>[];
                var connection = await Connectivity().checkConnectivity();
                if(connection == ConnectivityResult.none) {
                  //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
                  var response = await LocalActionService().readTypeCauseActionARattacherById(widget.idAction);
                  response.forEach((data){
                    var model = TypeCauseModel();
                    model.codetypecause = data['codetypecause'];
                    model.typecause = data['typecause'];
                    typeCauseList.add(model);
                  });
                }
                else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
                  //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

                  await ActionService().getTypesCauseActionARattacher(matricule, widget.idAction).then((resp) async {
                    resp.forEach((data) async {
                      var model = TypeCauseModel();
                      model.codetypecause = data['codeTypeCause'];
                      model.typecause = data['typeCause'];
                      typeCauseList.add(model);
                    });
                  }
                      , onError: (err) {
                        ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
                      });
                }

                typeCauseFilter = typeCauseList.where((u) {
                  var name = u.codetypecause.toString().toLowerCase();
                  var description = u.typecause!.toLowerCase();
                  return name.contains(filter) ||
                      description.contains(filter);
                }).toList();
                return typeCauseFilter;
              } catch (exception) {
                ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
                return Future.error('service : ${exception.toString()}');
              }
            }
            Widget _customDropDownTypeCause(BuildContext context, TypeCauseModel? item) {
              if (item == null) {
                return Container();
              }
              else{
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
                BuildContext context, TypeCauseModel item, bool isSelected) {
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
                  title: Text(item.typecause ?? ''),
                  //subtitle: Text(item.codetypecause.toString() ?? ''),
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
                    maxChildSize: 0.7,
                    minChildSize: 0.4,
                    builder: (context, scrollController) => SingleChildScrollView(
                      child: ListBody(
                        children: [
                          SizedBox(height: 5.0,),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10, right: 10),
                              child: Center(
                                child: Text('New Type Cause of Action N°${widget.idAction}', style: TextStyle(
                                    fontWeight: FontWeight.w500, fontFamily: "Brand-Bold",
                                    color: Color(0xFF0769D2), fontSize: 17.0
                                ),),
                              ),
                            ),
                          ),
                          Form(
                            key: _addItemFormKey,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5.0),
                              child: Column(
                                children: <Widget>[
                                  SizedBox(height: 15.0,),
                                  Visibility(
                                      visible: true,
                                      child: DropdownSearch<TypeCauseModel>(
                                        showSelectedItems: true,
                                        showClearButton: true,
                                        showSearchBox: true,
                                        isFilteredOnline: true,
                                        compareFn: (i, s) => i?.isEqual(s) ?? false,
                                        dropdownSearchDecoration: InputDecoration(
                                          labelText: "Type Cause *",
                                          contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                          border: OutlineInputBorder(),
                                        ),
                                        onFind: (String? filter) => getTypesCause(filter),
                                        onChanged: (data) {
                                          typeCauseModel = data;
                                          selectedTypeCode = data?.codetypecause;
                                          typeCause = data?.typecause;
                                          print('type cause: ${typeCause}, code: ${selectedTypeCode}');
                                        },
                                        dropdownBuilder: _customDropDownTypeCause,
                                        popupItemBuilder: _customPopupItemBuilderTypeCause,
                                        validator: (u) =>
                                        u == null ? "Type cause is required " : null,
                                      )
                                  ),
                                  SizedBox(height: 20.0,),
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
                                           var connection = await Connectivity().checkConnectivity();
                                            if(connection == ConnectivityResult.none){
                                              int max_type_cause = await LocalActionService().getMaxNumTypeCauseAction();
                                              var model = TypeCauseModel();
                                              model.online = 0;
                                              model.nAct = widget.idAction;
                                              model.idTypeCause = max_type_cause+1;
                                              model.codetypecause = selectedTypeCode;
                                              model.typecause = typeCause;
                                              await LocalActionService().saveTypeCauseAction(model);
                                              Get.back();
                                              setState(() {
                                                listTypesCauses.clear();
                                                getData();
                                              });
                                              ShowSnackBar.snackBar("Successfully", "Type Cause added", Colors.green);
                                            }
                                            else if(connection == ConnectivityResult.mobile || connection == ConnectivityResult.wifi){
                                              await ActionService().saveTypeCauseAction(widget.idAction, selectedTypeCode).then((resp) async {
                                                Get.back();
                                                ShowSnackBar.snackBar("Successfully", "Type Cause added", Colors.green);
                                                setState(() {
                                                  listTypesCauses.clear();
                                                  getData();
                                                });
                                              }, onError: (err) {
                                                if(kDebugMode) print('error : ${err.toString()}');
                                                ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
                                              });
                                            }
                                          }
                                          catch (ex){
                                            print("Exception" + ex.toString());
                                            ShowSnackBar.snackBar("Exception", ex.toString(), Colors.red);
                                            throw Exception("Exception : " + ex.toString());
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 10.0,),
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
                          )
                        ],
                      ),
                    )
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
//delete type cause
  deleteTypeCauseAction(context, position){
    AwesomeDialog(
        context: context,
        animType: AnimType.SCALE,
        dialogType: DialogType.ERROR,
        body: Center(child: Text(
          'Are you sure to delete this item ${position}',
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

            await ActionService().deleteTypeCauseActionById(position).then((resp) async {
              ShowSnackBar.snackBar("Successfully", "Type Cause Deleted", Colors.green);
              listTypesCauses.removeWhere((element) => element.idTypeCause == position);
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