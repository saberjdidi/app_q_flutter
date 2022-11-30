import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualipro_flutter/Services/incident_securite/incident_securite_service.dart';
import 'package:qualipro_flutter/Services/incident_securite/local_incident_securite_service.dart';
import '../../../Models/incident_securite/incident_securite_agenda_model.dart';
import '../../../Utils/shared_preference.dart';
import '../../../Utils/snack_bar.dart';
import '../../../Views/home_page.dart';
import 'valider_incident_securite_decision_traitement.dart';

class DecisionTraitementIncidentSecuritePage extends StatefulWidget {
  DecisionTraitementIncidentSecuritePage({Key? key}) : super(key: key);

  @override
  State<DecisionTraitementIncidentSecuritePage> createState() =>
      _DecisionTraitementIncidentSecuritePageState();
}

class _DecisionTraitementIncidentSecuritePageState
    extends State<DecisionTraitementIncidentSecuritePage> {
  final matricule = SharedPreference.getMatricule();
  List<IncidentSecuriteAgendaModel> listIncident =
      List<IncidentSecuriteAgendaModel>.empty(growable: true);
  List<IncidentSecuriteAgendaModel> listFiltered = [];
  TextEditingController controller = TextEditingController();
  String _searchResult = '';

  @override
  void initState() {
    super.initState();
    getIncident();
  }

  void getIncident() async {
    try {
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        // Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.BOTTOM, duration: Duration(milliseconds: 900));
        var response = await LocalIncidentSecuriteService()
            .readIncidentSecuriteDecisionTraitement();
        response.forEach((data) {
          setState(() {
            var model = IncidentSecuriteAgendaModel();
            model.ref = data['ref'];
            model.designation = data['designation'];
            model.dateInc = data['dateInc'];
            listIncident.add(model);
            listFiltered = listIncident;
          });
        });
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.BOTTOM, duration: Duration(milliseconds: 900));
        //rest api
        await IncidentSecuriteService()
            .getListIncidentSecuriteDecisionTraitement(matricule)
            .then((response) async {
          //isDataProcessing(false);
          response.forEach((data) async {
            setState(() {
              var model = IncidentSecuriteAgendaModel();
              model.ref = data['ref'];
              model.designation = data['designation'];
              model.dateInc = data['date_inc'];
              model.idSite = data['idSite'];
              model.idProcessus = data['idProcessus'];
              listIncident.add(model);
              listFiltered = listIncident;
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

  final columns = ['number'.tr, 'Incident', 'Date', ''];
  int? sortColumnIndex;
  bool isAscending = false;
  final _contentStyleHeader = const TextStyle(
      color: Color(0xff060f7d),
      fontSize: 15,
      fontWeight: FontWeight.w700,
      fontFamily: "Brand-Bold");
  final _contentStyle = const TextStyle(
      color: Color(0xff0c2d5e),
      fontSize: 14,
      fontWeight: FontWeight.normal,
      fontFamily: "Brand-Regular");

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
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          leading: TextButton(
            onPressed: () {
              Get.offAll(HomePage());
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.blue,
            ),
          ),
          title: Text(
            '${'decision_de_traitement'.tr} : ${listIncident.length}',
            style: TextStyle(color: Colors.black, fontSize: 15),
          ),
          backgroundColor: (lightPrimary),
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: listIncident.isNotEmpty
                ?
                //datatable
                SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        Card(
                          child: new ListTile(
                            leading: new Icon(Icons.search),
                            title: new TextField(
                                controller: controller,
                                decoration: new InputDecoration(
                                    hintText: 'search'.tr,
                                    border: InputBorder.none),
                                onChanged: (value) {
                                  setState(() {
                                    _searchResult = value;
                                    listFiltered = listIncident
                                        .where((user) =>
                                            user.ref
                                                .toString()
                                                .contains(_searchResult) ||
                                            user.designation!
                                                .toLowerCase()
                                                .contains(_searchResult))
                                        .toList();
                                  });
                                }),
                            trailing: new IconButton(
                              icon: controller.text.trim() == ''
                                  ? Text('')
                                  : Icon(Icons.cancel),
                              onPressed: () {
                                setState(() {
                                  controller.clear();
                                  _searchResult = '';
                                  listFiltered = listIncident;
                                });
                              },
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            sortAscending: isAscending,
                            sortColumnIndex: sortColumnIndex,
                            columns: getColumns(columns),
                            rows: getRows(listFiltered),
                            columnSpacing: 10,
                          ),
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: Text('empty_list'.tr,
                        style: TextStyle(
                            fontSize: 20.0, fontFamily: 'Brand-Bold')),
                  )),
      ),
    );
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
          label: Text(
            column,
            style: _contentStyleHeader,
          ),
          onSort: onSort))
      .toList();

  List<DataRow> getRows(List<IncidentSecuriteAgendaModel> listIncidentInfo) =>
      listIncidentInfo
          .map((IncidentSecuriteAgendaModel incidentSecuriteAgendaModel) {
        return DataRow(
            cells: [
              DataCell(InkWell(
                onTap: () {
                  Get.to(ValiderIncidentSecuriteDecisionTraitement(
                      model: incidentSecuriteAgendaModel));
                },
                child: Text('${incidentSecuriteAgendaModel.ref}',
                    style: _contentStyle, textAlign: TextAlign.right),
              )),
              DataCell(Text('${incidentSecuriteAgendaModel.designation}',
                  style: _contentStyle, textAlign: TextAlign.right)),
              DataCell(Text('${incidentSecuriteAgendaModel.dateInc}',
                  style: _contentStyle, textAlign: TextAlign.right)),
              DataCell(InkWell(
                  onTap: () {
                    Get.to(ValiderIncidentSecuriteDecisionTraitement(
                        model: incidentSecuriteAgendaModel));
                  },
                  child: Icon(
                    Icons.edit,
                    color: Color(0xED0A7ADB),
                    size: 30,
                  ))),
            ],
            onLongPress: () {
              Get.to(ValiderIncidentSecuriteDecisionTraitement(
                  model: incidentSecuriteAgendaModel));
            });
        //final cells = [IncidentSecuriteAgendaModel.nReunion, IncidentSecuriteAgendaModel.typeReunion, IncidentSecuriteAgendaModel.datePrev];
        //return DataRow(cells: getCells(cells));
      }).toList();

  List<DataCell> getCells(List<dynamic> cells) =>
      cells.map((data) => DataCell(Text('${data}'))).toList();

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      listIncident.sort((value1, value2) => compareString(
          ascending, value1.ref.toString(), value2.ref.toString()));
    } else if (columnIndex == 1) {
      listIncident.sort((value1, value2) => compareString(ascending,
          value1.designation.toString(), value2.designation.toString()));
    } else if (columnIndex == 2) {
      listIncident.sort((value1, value2) => compareString(
          ascending, value1.dateInc.toString(), value2.dateInc.toString()));
    }
    setState(() {
      this.sortColumnIndex = columnIndex;
      this.isAscending = ascending;
    });
  }

  compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);
}
