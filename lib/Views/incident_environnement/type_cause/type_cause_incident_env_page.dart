import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualipro_flutter/Controllers/incident_environnement/incident_environnement_controller.dart';
import 'package:qualipro_flutter/Models/incident_environnement/type_cause_incident_model.dart';
import 'package:qualipro_flutter/Services/incident_environnement/incident_environnement_service.dart';
import 'package:qualipro_flutter/Services/incident_environnement/local_incident_environnement_service.dart';
import '../../../Controllers/api_controllers_call.dart';
import '../../../Route/app_route.dart';
import '../../../Utils/shared_preference.dart';
import '../../../Utils/snack_bar.dart';
import 'new_type_cause_incident_env.dart';

class TypeCauseIncidentEnvPage extends StatefulWidget {
  final numIncident;

  const TypeCauseIncidentEnvPage({Key? key, required this.numIncident})
      : super(key: key);

  @override
  State<TypeCauseIncidentEnvPage> createState() =>
      _TypeCauseIncidentEnvPageState();
}

class _TypeCauseIncidentEnvPageState extends State<TypeCauseIncidentEnvPage> {
  final matricule = SharedPreference.getMatricule();
  List<TypeCauseIncidentModel> listType =
      List<TypeCauseIncidentModel>.empty(growable: true);

  bool isVisibleBtnDelete = true;

  @override
  void initState() {
    super.initState();
    getTypeCause();
  }

  void getTypeCause() async {
    try {
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        isVisibleBtnDelete = false;
        final response = await LocalIncidentEnvironnementService()
            .readTypeCauseRattacherEnvByIncident(widget.numIncident);
        response.forEach((data) {
          setState(() {
            var model = TypeCauseIncidentModel();
            model.online = data['online'];
            model.idIncidentCause = data['idIncidentCause'];
            model.idIncident = data['incident'];
            model.idTypeCause = data['idTypeCause'];
            model.typeCause = data['typeCause'];
            listType.add(model);
          });
        });
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        isVisibleBtnDelete = true;
        //rest api
        await IncidentEnvironnementService()
            .getTypeCauseByIncident(widget.numIncident, matricule, 1)
            .then((resp) async {
          //isDataProcessing(false);
          resp.forEach((data) async {
            setState(() {
              var model = TypeCauseIncidentModel();
              model.online = 1;
              model.idIncidentCause = data['id_incid_cause'];
              model.idIncident = data['idIncident'];
              model.idTypeCause = data['idCause'];
              model.typeCause = data['typeCause'];
              listType.add(model);
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
              Get.find<IncidentEnvironnementController>().listIncident.clear();
              Get.find<IncidentEnvironnementController>().getIncident();
              Get.toNamed(AppRoute.incident_environnement);
              //Get.offAllNamed(AppRoute.reunion);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.blue,
            ),
          ),
          title: Text(
            'Type Cause ${'of'.tr} Incident N°${widget.numIncident}',
            style: TextStyle(color: Colors.black, fontSize: 17),
          ),
          backgroundColor: (lightPrimary),
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: listType.isNotEmpty
                ? Container(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Card(
                          color: Color(0xFFE9EAEE),
                          child: ListTile(
                            leading: Text(
                              '${listType[index].idTypeCause}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.lightBlue),
                            ),
                            title: Text(
                              '${listType[index].typeCause}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            trailing: Visibility(
                              visible: isVisibleBtnDelete,
                              child: InkWell(
                                  onTap: () {
                                    deleteTypeCause(context,
                                        listType[index].idIncidentCause);
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  )),
                            ),
                          ),
                        );
                      },
                      itemCount: listType.length,
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
            Get.to(NewTypeCauseIncidentEnv(numIncident: widget.numIncident));
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
  deleteTypeCause(context, id) {
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
            await IncidentEnvironnementService()
                .deleteTypeCauseIncidentById(id)
                .then((resp) async {
              ShowSnackBar.snackBar(
                  "Successfully", "Type Cause Deleted", Colors.green);
              listType.removeWhere((element) => element.idIncidentCause == id);
              setState(() {});
              await ApiControllersCall().getTypeCauseIncidentEnvRattacher();
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
