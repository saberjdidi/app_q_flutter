import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualipro_flutter/Models/incident_environnement/type_cause_incident_model.dart';
import 'package:qualipro_flutter/Services/incident_securite/incident_securite_service.dart';
import '../../../Controllers/api_controllers_call.dart';
import '../../../Controllers/incident_securite/incident_securite_controller.dart';
import '../../../Route/app_route.dart';
import '../../../Services/incident_securite/local_incident_securite_service.dart';
import '../../../Utils/shared_preference.dart';
import '../../../Utils/snack_bar.dart';
import 'new_type_cause_incident_securite.dart';

class TypeCauseIncidentSecuritePage extends StatefulWidget {
  final numIncident;

  const TypeCauseIncidentSecuritePage({Key? key, required this.numIncident})
      : super(key: key);

  @override
  State<TypeCauseIncidentSecuritePage> createState() =>
      _TypeCauseIncidentSecuritePageState();
}

class _TypeCauseIncidentSecuritePageState
    extends State<TypeCauseIncidentSecuritePage> {
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
        final response = await LocalIncidentSecuriteService()
            .readTypeCauseIncSecRattacher(widget.numIncident);
        response.forEach((data) {
          setState(() {
            var model = TypeCauseIncidentModel();
            model.online = data['online'];
            model.idIncident = data['incident'];
            model.idIncidentCause = data['idTypeCause'];
            model.idTypeCause = data['idIncidentCause'];
            model.typeCause = data['typeCause'];
            listType.add(model);
          });
        });
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        isVisibleBtnDelete = true;
        //rest api
        await IncidentSecuriteService()
            .getTypeCauseIncSecRattacher(widget.numIncident, matricule, 1)
            .then((resp) async {
          //isDataProcessing(false);
          resp.forEach((data) async {
            setState(() {
              var model = TypeCauseIncidentModel();
              model.online = 1;
              model.idIncident = data['id_incident'];
              model.idIncidentCause = data['id_incid_cause'];
              model.idTypeCause = data['id_cause'];
              model.typeCause = data['cause'];
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
              Get.find<IncidentSecuriteController>().listIncident.clear();
              Get.find<IncidentSecuriteController>().getIncident();
              Get.toNamed(AppRoute.incident_securite);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.blue,
            ),
          ),
          title: Text(
            'Type Cause Incident N°${widget.numIncident}',
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
                                    deleteTypeCause(
                                        context, listType[index].idTypeCause);
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
                    ),
                  )
                : Center(
                    child: Text('empty_list'.tr,
                        style: TextStyle(
                            fontSize: 20.0, fontFamily: 'Brand-Bold')),
                  )),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.to(
                NewTypeCauseIncidentSecurite(numIncident: widget.numIncident));
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
            await IncidentSecuriteService()
                .deleteTypeCauseIncidentById(widget.numIncident, id)
                .then((resp) async {
              listType.removeWhere((element) => element.idTypeCause == id);
              setState(() {});
              await ApiControllersCall().getTypeCauseIncidentSecRattacher();
              Navigator.of(context).pop();
              ShowSnackBar.snackBar(
                  "Successfully", "Type Cause Deleted", Colors.green);
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
