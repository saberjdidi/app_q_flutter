import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:qualipro_flutter/Agenda/Views/audit/rapport_audit_a_valider_page.dart';
import 'package:qualipro_flutter/Widgets/refresh_widget.dart';

import '../../../Controllers/api_controllers_call.dart';
import '../../../Models/audit/audit_model.dart';
import '../../../Models/audit/constat_audit_model.dart';
import '../../../Services/audit/audit_service.dart';
import '../../../Utils/shared_preference.dart';
import '../../../Utils/snack_bar.dart';
import '../../../Views/audit/constat/constat_audit_page.dart';

class ValiderRapportAuditPage extends StatefulWidget {
  final AuditModel model;
  const ValiderRapportAuditPage({Key? key, required this.model})
      : super(key: key);

  @override
  State<ValiderRapportAuditPage> createState() =>
      _ValiderRapportAuditPageState();
}

class _ValiderRapportAuditPageState extends State<ValiderRapportAuditPage> {
  final _addItemFormKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  final keyRefresh = GlobalKey<RefreshIndicatorState>();
  final matricule = SharedPreference.getMatricule();
  DateTime dateTime = DateTime.now();
  TextEditingController dateDebutPrevueController = TextEditingController();
  TextEditingController dateFinPrevueController = TextEditingController();
  TextEditingController interneController = TextEditingController();
  TextEditingController typeAuditController = TextEditingController();
  TextEditingController dateSaisieDecisionController = TextEditingController();
  TextEditingController dateDebutEffectiveController = TextEditingController();
  TextEditingController dateFinEffectiveController = TextEditingController();
  TextEditingController champsController = TextEditingController();
  int? status = 5;
  String message_status = 'en_cours_de_validation'.tr;

  final _contentStyleHeader = const TextStyle(
      color: Color(0xff060f7d), fontSize: 14, fontWeight: FontWeight.w700);
  final _contentStyle = const TextStyle(
      color: Color(0xff0c2d5e), fontSize: 14, fontWeight: FontWeight.normal);

  //get constats & audit details
  List<ConstatAuditModel> listConstat =
      List<ConstatAuditModel>.empty(growable: true);
  String? mode = '';
  int? validation_constat = 0;
  void getAuditDetails() async {
    try {
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        Get.defaultDialog(
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
            ));
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        await AuditService().getAuditByRefAudit(widget.model.refAudit).then(
            (value) async {
          setState(() {
            var model = AuditModel();
            model.refAudit = value['refAudit'];
            model.audit = value['audit'];
            model.etat = value['etat'];
            model.validation = value['validation'];
            model.idAudit = value['idaudit'];
            model.dateDebPrev = value['dateDebPrev'];
            model.dateFinPrev = value['dateFinPrev'];
            model.typeA = value['typeA'];
            model.interne = value['interne'];
            model.dateDeb = value['dateDeb'];
            model.dateFin = value['dateFin'];

            dateDebutPrevueController.text = value['dateDebPrev'];
            dateFinPrevueController.text = value['dateFinPrev'];
            typeAuditController.text = value['typeA'];
            interneController.text = value['interne'];
            DateTime dateDebEff = DateTime.parse(value['dateDeb']);
            DateTime dateFinEff = DateTime.parse(value['dateFin']);
            dateDebutEffectiveController.text =
                DateFormat('dd/MM/yyyy').format(dateDebEff);
            //dateFinEffectiveController.text = DateFormat('dd/MM/yyyy').format(dateFinEff);
            status = value['etat'];
            switch (status) {
              case 1:
                message_status = 'non_encore_realise'.tr;
                break;
              case 2:
                message_status = 'realise'.tr;
                break;
              case 3:
                message_status = 'reporte'.tr;
                break;
              case 4:
                message_status = 'annule'.tr;
                break;
              case 5:
                message_status = 'en_cours_de_validation'.tr;
                break;
              case 6:
                message_status = 'en_cours_elaboration'.tr;
                break;
              default:
                message_status = "";
            }
            //get constat
            AuditService()
                .getConstatAudit(widget.model.refAudit, '%24_act_prov')
                .then((resp) async {
              //isDataProcessing(false);
              resp.forEach((data) async {
                setState(() {
                  var model = ConstatAuditModel();
                  model.refAudit = data['refAudit'];
                  model.nact = data['nact'];
                  model.ngravite = data['ngravite'];
                  model.codeTypeE = data['codeTypeE'];
                  model.gravite = data['gravite'];
                  model.typeE = data['typeE'];
                  model.mat = data['mat'];
                  model.nomPre = data['nomPre'];
                  model.idEcart = data['id_Ecart'];
                  model.descPb = data['descPb'];
                  model.act = data['act'];
                  model.typeAct = data['typeAct'];
                  model.sourceAct = data['sourceAct'];
                  model.codeChamp = data['codeChamp'];
                  model.champ = data['champ'];
                  if (data['delaiReal'] == null) {
                    model.delaiReal = "";
                  } else {
                    model.delaiReal = data['delaiReal'];
                  }
                  listConstat.add(model);
                  /* listConstat.forEach((element) {
                     print('constat : ${element.champ}, type : ${element.typeE}');
                   }); */
                });
              });
            }, onError: (err) {
              ShowSnackBar.snackBar(
                  "Error Constat", err.toString(), Colors.red);
            });
          });
        }, onError: (error) {
          ShowSnackBar.snackBar(
              "Error audit details", error.toString(), Colors.red);
        });
      }
    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      //isDataProcessing(false);
    }
  }

  @override
  void initState() {
    super.initState();
    getAuditDetails();
    champsController.text = widget.model.champ.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        leading: TextButton(
          onPressed: () {
            Get.back();
            //Get.to(PNCTraitementDecisionPage());
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          //color: Colors.blue,
        ),
        title: Center(
          child: Text(
            "${'file'.tr} Audit N° ${widget.model.idAudit}",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Card(
          child: SingleChildScrollView(
            child: Form(
              key: _addItemFormKey,
              child: Column(
                children: <Widget>[
                  Card(
                    color: Color(0xDFB7F81A),
                    margin: EdgeInsets.all(5),
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Center(
                        child: Text(
                          message_status,
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    enabled: false,
                    controller: dateDebutPrevueController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'date_debut_prevue'.tr,
                      hintText: 'date_debut_prevue'.tr,
                      labelStyle: TextStyle(
                        fontSize: 14.0,
                      ),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 10.0,
                      ),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.lightBlue, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    style: TextStyle(fontSize: 14.0),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    enabled: false,
                    controller: dateFinPrevueController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'date_fin_prevue'.tr,
                      hintText: 'date_fin_prevue'.tr,
                      labelStyle: TextStyle(
                        fontSize: 14.0,
                      ),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 10.0,
                      ),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.lightBlue, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    style: TextStyle(fontSize: 14.0),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    enabled: false,
                    controller: typeAuditController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Type Audit',
                      hintText: 'type',
                      labelStyle: TextStyle(
                        fontSize: 14.0,
                      ),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 10.0,
                      ),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.lightBlue, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    style: TextStyle(fontSize: 14.0),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    enabled: false,
                    controller: champsController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'champ_audit'.tr,
                      hintText: 'champ_audit'.tr,
                      labelStyle: TextStyle(
                        fontSize: 14.0,
                      ),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 10.0,
                      ),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.lightBlue, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    style: TextStyle(fontSize: 14.0),
                    minLines: 2,
                    maxLines: 5,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    enabled: false,
                    controller: interneController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'interne'.tr,
                      hintText: 'interne'.tr,
                      labelStyle: TextStyle(
                        fontSize: 14.0,
                      ),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 10.0,
                      ),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.lightBlue, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    style: TextStyle(fontSize: 14.0),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    enabled: false,
                    controller: dateDebutEffectiveController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Date ${'debut'.tr} Effective',
                      hintText: 'Date ${'debut'.tr} Effective',
                      labelStyle: TextStyle(
                        fontSize: 14.0,
                      ),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 10.0,
                      ),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.lightBlue, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    style: TextStyle(fontSize: 14.0),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    enabled: false,
                    controller: dateFinEffectiveController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Date ${'fin'.tr} Effective',
                      hintText: 'Date ${'fin'.tr} Effective',
                      labelStyle: TextStyle(
                        fontSize: 14.0,
                      ),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 10.0,
                      ),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.lightBlue, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    style: TextStyle(fontSize: 14.0),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                        width: MediaQuery.of(context).size.width / 1.6,
                        height: 50),
                    child: ElevatedButton.icon(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all(Color(0xDF0E6323)),
                        padding: MaterialStateProperty.all(EdgeInsets.all(14)),
                      ),
                      icon: Icon(Icons.send),
                      label: Text(
                        '${'valider'.tr} ${'rapport'.tr}',
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                      onPressed: () {
                        validerRapport();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Center(
                    child: Text(
                      'list_constat_a_valider'.tr,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                          sortAscending: true,
                          sortColumnIndex: 1,
                          dataRowHeight: 40,
                          border: TableBorder.all(
                              color: Color(0xDFAEF4F6),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          columnSpacing:
                              (MediaQuery.of(context).size.width / 10) * 0.2,
                          showBottomBorder: false,
                          columns: [
                            DataColumn(
                                label: Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 5.0),
                                      child: InkWell(
                                        onTap: () {
                                          Get.to(ConstatAuditPage(
                                              model: widget.model));
                                        },
                                        child: Icon(
                                          Icons.remove_red_eye,
                                          color: Colors.indigoAccent,
                                          size: 40,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 10.0),
                                      child: InkWell(
                                        onTap: () {
                                          listConstat.clear();
                                          getAuditDetails();
                                        },
                                        child: Icon(
                                          Icons.refresh,
                                          color: Colors.lightGreen,
                                          size: 40,
                                        ),
                                      ),
                                    ),
                                    Text('object'.tr,
                                        style: _contentStyleHeader),
                                  ],
                                ),
                                numeric: true),
                            DataColumn(
                                label: Text('description',
                                    style: _contentStyleHeader),
                                numeric: true),
                            DataColumn(
                                label: Text('champ_audit'.tr,
                                    style: _contentStyleHeader)),
                          ],
                          rows: listConstat
                              .map<DataRow>((element) => DataRow(cells: [
                                    DataCell(Container(
                                        width:
                                            (MediaQuery.of(context).size.width /
                                                    10) *
                                                3,
                                        child: Text(element.act.toString(),
                                            style: _contentStyle,
                                            textAlign: TextAlign.right))),
                                    DataCell(Container(
                                        width:
                                            (MediaQuery.of(context).size.width /
                                                    10) *
                                                3,
                                        child: Text(element.descPb.toString(),
                                            style: TextStyle(
                                                color: Color(0xffe31119),
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal),
                                            textAlign: TextAlign.right))),
                                    DataCell(Container(
                                        width:
                                            (MediaQuery.of(context).size.width /
                                                    10) *
                                                3,
                                        child: Text('${element.champ}',
                                            style: _contentStyle,
                                            textAlign: TextAlign.right))),
                                  ]))
                              .toList()),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }

  Future validerRapport() async {
    if (_addItemFormKey.currentState!.validate()) {
      try {
        //valider rapport
        await AuditService().validerRapportAudit(widget.model.refAudit).then(
            (response) async {
          //valider action prov
          await AuditService().validerAuditActionProv({
            "refaudit": widget.model.refAudit,
            "mat": matricule
          }).then((respActPrev) {
            if (kDebugMode) print('action prov valider');
          }, onError: (error) {
            ShowSnackBar.snackBar(
                'Error valid action prov', error.toString(), Colors.red);
          });
          await ApiControllersCall().getRapportAuditsAValider();
          ShowSnackBar.snackBar(
              "Successfully", "rapport valider", Colors.green);
          //Get.back();
          Get.to(RapportAuditAValiderPage());
        }, onError: (error) {
          ShowSnackBar.snackBar(
              'Error valid rapport', error.toString(), Colors.red);
        });
      } catch (exception) {
        AwesomeDialog(
          context: context,
          animType: AnimType.SCALE,
          dialogType: DialogType.ERROR,
          body: Center(
            child: Text(
              exception.toString(),
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          title: 'Error',
          btnCancel: Text('Cancel'),
          btnOkOnPress: () {
            Navigator.of(context).pop();
          },
        )..show();
        print("throwing new error " + exception.toString());
        throw Exception("Error " + exception.toString());
      }
    }
  }
}
