import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:qualipro_flutter/Models/incident_securite/cause_typique_model.dart';
import 'package:qualipro_flutter/Services/incident_securite/incident_securite_service.dart';
import 'package:qualipro_flutter/Services/visite_securite/visite_securite_service.dart';
import '../../../Controllers/incident_securite/incident_securite_controller.dart';
import '../../../Controllers/visite_securite/visite_securite_controller.dart';
import '../../../Models/pnc/isps_pnc_model.dart';
import '../../../Models/visite_securite/checklist_critere_model.dart';
import '../../../Route/app_route.dart';
import '../../../Utils/custom_colors.dart';
import '../../../Utils/message.dart';
import '../../../Utils/shared_preference.dart';
import '../../../Utils/snack_bar.dart';
import '../visite_securite_page.dart';

class CheckListCriterePage extends StatefulWidget {
  final numFiche;

 const CheckListCriterePage({Key? key, required this.numFiche}) : super(key: key);

  @override
  State<CheckListCriterePage> createState() => _CheckListCriterePageState();
}

class _CheckListCriterePageState extends State<CheckListCriterePage> {

  bool _isProcessing = false;
  final matricule = SharedPreference.getMatricule();
  List<CheckListCritereModel> listCheckList = List<CheckListCritereModel>.empty(growable: true);
  List<TextEditingController> _controllers = new List.empty(growable: true);
  String? critere = "0";
  int? eval = 0;
  ISPSPNCModel? ispspncModel = null;
  //taux_respect
  int? tauxRespect = 0;
  bool isExtended = false;

  @override
  void initState() {
    super.initState();
    getData();
    getTauxRespect();
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
        await VisiteSecuriteService().getCheckListCritere(widget.numFiche).then((resp) async {
          //isDataProcessing(false);
          resp.forEach((data) async {
            setState(() {
              var model = CheckListCritereModel();
              model.id = data['id'];
              model.idReg = data['id_Reg'];
              model.lib = data['lib'];
              model.eval = data['eval'];
              model.commentaire = data['commentaire'];
              listCheckList.add(model);

              for(var i=0; i<listCheckList.length; i++){
                _controllers.add(new TextEditingController());
                _controllers[i].text = listCheckList[i].commentaire.toString();
                //eval = listCheckList[i].eval;
              }
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
  void getTauxRespect() async {
    try {
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        tauxRespect = 0;
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        //rest api
        await VisiteSecuriteService().getTauxRespect(widget.numFiche).then((response) async {
          //isDataProcessing(false);
            setState(() {
              tauxRespect = response['taux'];
              print('taux: $tauxRespect');
            });
        }
            , onError: (err) {
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });
      }
    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      print('exception : ${exception.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color lightPrimary = Color(0xFFEEEDED);
    const Color darkPrimary = Color(0xFFDEDDDD);
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
          toolbarHeight: 70,
          leading: TextButton(
            onPressed: (){
              //Get.back();
              Get.find<VisiteSecuriteController>().listVisiteSecurite.clear();
              Get.find<VisiteSecuriteController>().getData();
              Get.toNamed(AppRoute.visite_securite);
            },
            child: Icon(Icons.arrow_back, color: Colors.blue, size: 40,),
          ),
          title: Column(
            children: [
              Text(
                'Check-list N°${widget.numFiche}',
                style: TextStyle(color: Colors.blue, fontSize: 18),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text('Taux Respect : ${tauxRespect} %', style: TextStyle(
                  color: Colors.blue, fontSize: 18
                ),),
              )
            ],
          ),
          backgroundColor: (lightPrimary),
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: listCheckList.isNotEmpty ?

               ListView.builder(
                  itemBuilder: (context, index) {

                    //_controllers.add(new TextEditingController());
                    //_controllers[index].text = listCheckList[index].commentaire.toString();
                    eval = listCheckList[index].eval;

                    return Card(
                      color: Color(0xFFFFFFFF),
                      child: ListTile(
                        /*leading: Text(
                          '${listCheckList[index].idReg}',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.lightBlue),
                        ), */
                        title: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${listCheckList[index].lib}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        subtitle: Column(
                          children: [
                            DropdownSearch<ISPSPNCModel>(
                              showSelectedItems: true,
                              showClearButton: true,
                              showSearchBox: false,
                              isFilteredOnline: true,
                              mode: Mode.DIALOG,
                              compareFn: (i, s) => i?.isEqual(s) ?? false,
                              dropdownSearchDecoration: InputDecoration(
                                labelText: "Respect",
                                contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                border: OutlineInputBorder(),
                              ),
                              onFind: (String? filter) => getRespect(filter),
                              onChanged: (data) {
                                  critere = data?.value;
                                  listCheckList[index].eval = int.parse(critere.toString());
                                  ispspncModel = data;
                                  print('critere value :${critere}');

                              },
                              dropdownBuilder: _customDropDownRespect,
                              popupItemBuilder: _customPopupItemBuilderRespect,

                            ),
                           /* DropdownButton<String>(
                                items: ispsList.map((item) =>
                                 DropdownMenuItem<String>(
                                   value: item.value,
                                     child: Text('${item.name}', style: TextStyle(color: Colors.black),)
                                 )
                                ).toList(),
                                value: affect,
                                onChanged: (item)=> setState(()=> affect = item )
                            ), */
                            SizedBox(height: 10,),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: TextFormField(
                                controller: _controllers[index],
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                //initialValue: listCheckList[index].commentaire,
                                decoration: InputDecoration(
                                    labelText: 'Commentaire',
                                    hintText: 'Commentaire',
                                    labelStyle: TextStyle(
                                      fontSize: 14.0,
                                    ),
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10.0,
                                    ),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.lightBlue, width: 1),
                                        borderRadius: BorderRadius.all(Radius.circular(10))
                                    )
                                ),
                                style: TextStyle(fontSize: 14.0),
                              ),
                            ),
                          ],
                        ),
                        /* trailing: InkWell(
                            onTap: (){
                             // deleteData(context, listCheckList[index].idCauseTypique);
                              showDialog<void>(
                                context: context,
                                barrierDismissible: false, // user must tap button!
                                builder: (BuildContext context) {
                                  TextEditingController editCommentaireController = TextEditingController();
                                  editCommentaireController.text = listCheckList[index].commentaire.toString();
                                  bool _dataValidation() {
                                    if(editCommentaireController.text.trim()=='' && critere=="2"){
                                      Message.taskErrorOrWarning("Warning", "Commentaire est obligatoire");
                                      return false;
                                    }
                                    return true;
                                  }
                                  return AlertDialog(
                                    scrollable: true,
                                    title: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: const Center(
                                        child: Text('Check-list', style: TextStyle(
                                            fontWeight: FontWeight.w500, fontFamily: "Signatra",
                                            color: Color(0xFF0769D2), fontSize: 30.0
                                        ),),
                                      ),
                                    ),
                                    titlePadding: EdgeInsets.only(top: 2.0),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          TextFormField(
                                            controller: editCommentaireController,
                                            keyboardType: TextInputType.text,
                                            textInputAction: TextInputAction.next,
                                            decoration: InputDecoration(
                                                labelText: 'Commentaire',
                                                hintText: 'Commentaire',
                                                labelStyle: TextStyle(
                                                  fontSize: 14.0,
                                                ),
                                                hintStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 10.0,
                                                ),
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.lightBlue, width: 1),
                                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                                )
                                            ),
                                            style: TextStyle(fontSize: 14.0),
                                          ),
                                          SizedBox(height: 10.0,),
                                          DropdownSearch<ISPSPNCModel>(
                                            showSelectedItems: true,
                                            showClearButton: true,
                                            showSearchBox: false,
                                            isFilteredOnline: true,
                                            mode: Mode.DIALOG,
                                            compareFn: (i, s) => i?.isEqual(s) ?? false,
                                            dropdownSearchDecoration: InputDecoration(
                                              labelText: "Respect",
                                              contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                              border: OutlineInputBorder(),
                                            ),
                                            onFind: (String? filter) => getRespect(filter),
                                            onChanged: (data) {
                                              setState(() {
                                                critere = data?.value;
                                                print('critere value :${critere}');
                                              });
                                            },
                                            dropdownBuilder: _customDropDownRespect,
                                            popupItemBuilder: _customPopupItemBuilderRespect,

                                          ),
                                        ],
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.only(right: 5.0, left: 5.0),
                                    actionsPadding: EdgeInsets.all(1.0),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Cancel'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                            //Get.back();
                                            //Navigator.of(context).pop(controller.listEquipe);
                                          if(_dataValidation()){
                                            try {
                                              await VisiteSecuriteService().saveCheckListCritere({
                                                "id": listCheckList[index].id,
                                                "eval": int.parse(critere.toString()),
                                                "commentaire": editCommentaireController.text
                                              }).then((resp) async {
                                                //ShowSnackBar.snackBar("Successfully", "Type Cause added", Colors.green);
                                                Get.offAll(CheckListCriterePage(numFiche: widget.numFiche));
                                                //Get.to(CheckListCriterePage(numFiche: widget.numFiche));
                                                //Get.back();
                                              }, onError: (err) {
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
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(
                                            CustomColors.googleBackground,
                                          ),
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text('Save',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: CustomColors.firebaseWhite,
                                              letterSpacing: 2,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                            child: Icon(Icons.edit, color: Color(0xFF1A67D9))
                        ), */
                      ),
                    );
                  },
                  itemCount: listCheckList.length,
                  //itemCount: actionsList.length + 1,
                )

                : Center(child: Text('empty_list'.tr, style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'Brand-Bold'
            )),)
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async{
           //saveBtn();
            for (var i = 0; i < listCheckList.length; i++) {
              print('checklist : ${listCheckList[i].id}-${listCheckList[i].lib} -eval:${listCheckList[i].eval} - comment:${_controllers[i].text}');
              if(_controllers[i].text.trim()=='' && listCheckList[i].eval==2){
                Message.taskErrorOrWarning("Warning", "Commentaire est obligatoire");
                return;
              }
              else if(listCheckList[i].eval==0){
                Message.taskErrorOrWarning("Warning", "Le champs d'évaluation est obligatoire pour toute la liste");
                return;
              }
            }
            for (var i = 0; i < listCheckList.length; i++) {
             if(kDebugMode) print('checklist : ${listCheckList[i].id}-${listCheckList[i].lib} -eval:${listCheckList[i].eval} - comment:${_controllers[i].text}');
             await VisiteSecuriteService().saveCheckListCritere({
                "id": listCheckList[i].id,
                "eval": listCheckList[i].eval,
                "commentaire": _controllers[i].text
              }).then((resp) {
                Get.to(VisiteSecuritePage());
                //ShowSnackBar.snackBar("Successfully", "${listCheckList[i].lib} Added ", Colors.green);
                //Get.find<VisiteSecuriteController>().listVisiteSecurite.clear();
                //Get.find<VisiteSecuriteController>().getData();
              }, onError: (err) {
                setState(()  {
                  _isProcessing = false;
                });
                print('Error : ${err.toString()}');
                ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
              });
            }
          },
            label: AnimatedSwitcher(
              duration: Duration(seconds: 1),
              transitionBuilder: (Widget child, Animation<double> animation) =>
                  FadeTransition(
                    opacity: animation,
                    child: SizeTransition(child:
                    child,
                      sizeFactor: animation,
                      axis: Axis.horizontal,
                    ),
                  ) ,
              child: isExtended?
              Icon(Icons.arrow_forward):
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: Icon(Icons.add),
                  ),
                  Text("Save")
                ],
              ),
            ),
        ),
      ),
    );
  }
/*
  bool _dataValidation() {
    for (var i = 0; i < listCheckList.length; i++) {
      if(_controllers[i].text.trim()=='' && listCheckList[i].eval==2){
        Message.taskErrorOrWarning("Warning", "Commentaire est obligatoire");
        return false;
      }
    }

    return true;
  }
  Future saveBtn() async {
    if(_dataValidation()){
      try {
        setState(() {
          _isProcessing = true;
        });
        var connection = await Connectivity().checkConnectivity();
        if (connection == ConnectivityResult.none) {
          Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.BOTTOM, duration: Duration(milliseconds: 500));
        }
        else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
          for (var i = 0; i < listCheckList.length; i++) {
            print('checklist : ${listCheckList[i].id}-${listCheckList[i].lib} -eval:${listCheckList[i].eval} - comment:${_controllers[i].text}');
            await VisiteSecuriteService().saveCheckListCritere({
              "id": listCheckList[i].id,
              "eval": listCheckList[i].eval,
              "commentaire": _controllers[i].text
            }).then((resp) {
              Get.back();
              //Get.to(VisiteSecuritePage());
              //ShowSnackBar.snackBar("Successfully", "CheckList Added ", Colors.green);
              Get.find<VisiteSecuriteController>().listVisiteSecurite.clear();
              Get.find<VisiteSecuriteController>().getData();
            }, onError: (err) {
              setState(()  {
                _isProcessing = false;
              });
              print('Error : ${err.toString()}');
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });
          }

        }

      }
      catch (ex){
        setState(()  {
          _isProcessing = false;
        });
        AwesomeDialog(
          context: context,
          animType: AnimType.SCALE,
          dialogType: DialogType.ERROR,
          body: Center(child: Text(
            ex.toString(),
            style: TextStyle(fontStyle: FontStyle.italic),
          ),),
          title: 'Error',
          btnCancel: Text('Cancel'),
          btnOkOnPress: () {
            Navigator.of(context).pop();
          },
        )..show();
        print("throwing new error " + ex.toString());
        throw Exception("Error " + ex.toString());
      }
      finally{
        setState(()  {
          _isProcessing = false;
        });
      }
    }
  }
  */

  //Critere
  Future<List<ISPSPNCModel>> getRespect(filter) async {
    try {
      List<ISPSPNCModel> ispsList = [
        ISPSPNCModel(value: "0", name: ""),
        ISPSPNCModel(value: "1", name: "Respecté"),
        ISPSPNCModel(value: "2", name: "Non Respecté"),
        ISPSPNCModel(value: "3", name: "Non Observé"),
      ];

      return ispsList;
    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }
  Widget _customDropDownRespect(BuildContext context, ISPSPNCModel? item) {
    if (item == null) {
      String? message_evaluation = '';
      switch (eval) {
        case 0:
          message_evaluation = "";
          break;
        case 1:
          message_evaluation = "Respecté";
          break;
        case 2:
          message_evaluation = "Non respecté";
          break;
        case 3:
          message_evaluation = "Non observé";
          break;
        default:
          message_evaluation = "";
      }
      return Container(
        child: Text('${message_evaluation}', style: TextStyle(color: Colors.black),),
      );
    }
    return Container(
      child: (item.name == null)
          ? ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text("No item selected"),
      )
          : ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text('${item.name}'),
      ),
    );
  }
  Widget _customPopupItemBuilderRespect(
      BuildContext context, ISPSPNCModel? item, bool isSelected) {
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
        title: Text(item?.name ?? ''),
        //subtitle: Text(item?.value.toString() ?? ''),
      ),
    );
  }
}