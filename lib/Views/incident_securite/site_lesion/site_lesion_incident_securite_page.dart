import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualipro_flutter/Models/incident_securite/site_lesion_model.dart';
import 'package:qualipro_flutter/Services/incident_securite/incident_securite_service.dart';
import 'package:qualipro_flutter/Services/incident_securite/local_incident_securite_service.dart';
import '../../../Controllers/api_controllers_call.dart';
import '../../../Controllers/incident_securite/incident_securite_controller.dart';
import '../../../Route/app_route.dart';
import '../../../Utils/shared_preference.dart';
import '../../../Utils/snack_bar.dart';
import 'new_site_lesion_incident_securite.dart';

class SiteLesionIncidentSecuritePage extends StatefulWidget {
  final numIncident;

  const SiteLesionIncidentSecuritePage({Key? key, required this.numIncident})
      : super(key: key);

  @override
  State<SiteLesionIncidentSecuritePage> createState() =>
      _SiteLesionIncidentSecuritePageState();
}

class _SiteLesionIncidentSecuritePageState
    extends State<SiteLesionIncidentSecuritePage> {
  final matricule = SharedPreference.getMatricule();
  List<SiteLesionModel> listSiteLesion =
      List<SiteLesionModel>.empty(growable: true);

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
        final response = await LocalIncidentSecuriteService()
            .readSiteLesionIncSecRattacher(widget.numIncident);
        response.forEach((data) {
          setState(() {
            var model = SiteLesionModel();
            model.online = data['online'];
            model.idIncident = data['incident'];
            model.idIncCodeSiteLesion = data['idIncCodeSiteLesion'];
            model.codeSiteLesion = data['codeSiteLesion'];
            model.siteLesion = data['siteLesion'];
            listSiteLesion.add(model);
          });
        });
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        isVisibleBtnDelete = true;
        //rest api
        await IncidentSecuriteService()
            .getSiteLesionIncSecRattacher(widget.numIncident, matricule, 1)
            .then((resp) async {
          //isDataProcessing(false);
          resp.forEach((data) async {
            setState(() {
              var model = SiteLesionModel();
              model.online = 1;
              model.idIncident = data['id_incident'];
              model.idIncCodeSiteLesion = data['id_inc_siteLesion'];
              model.codeSiteLesion = data['code_siteDeLesion'];
              model.siteLesion = data['siteDeLesion'];
              listSiteLesion.add(model);
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
              //Get.offAllNamed(AppRoute.reunion);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.blue,
            ),
          ),
          title: Text(
            'Site Lesion Incident N°${widget.numIncident}',
            style: TextStyle(color: Colors.black, fontSize: 17),
          ),
          backgroundColor: (lightPrimary),
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: listSiteLesion.isNotEmpty
                ? Container(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Card(
                          color: Color(0xFFE9EAEE),
                          child: ListTile(
                            leading: Text(
                              '${listSiteLesion[index].codeSiteLesion}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.lightBlue),
                            ),
                            title: Text(
                              '${listSiteLesion[index].siteLesion}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            /*  subtitle: Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.bodyLarge,
                              children: [
                                TextSpan(text: '${listSiteLesion[index].typeCause}'),

                                //TextSpan(text: '${action.declencheur}'),
                              ],

                            ),
                          ),
                        ), */
                            trailing: Visibility(
                              visible: isVisibleBtnDelete,
                              child: InkWell(
                                  onTap: () {
                                    deleteData(context,
                                        listSiteLesion[index].codeSiteLesion);
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  )),
                            ),
                          ),
                        );
                      },
                      itemCount: listSiteLesion.length,
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
            Get.to(
                NewSiteLesionIncidentSecurite(numIncident: widget.numIncident));
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
                .deleteSiteLesionIncidentById(widget.numIncident, id)
                .then((resp) async {
              ShowSnackBar.snackBar(
                  "Successfully", "Site Lesion Deleted", Colors.green);
              listSiteLesion
                  .removeWhere((element) => element.codeSiteLesion == id);
              setState(() {});
              await ApiControllersCall().getSiteLesionIncSecRattacher();
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
        )).show();
  }
}
