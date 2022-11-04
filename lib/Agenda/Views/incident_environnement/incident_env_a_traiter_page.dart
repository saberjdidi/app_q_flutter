import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualipro_flutter/Services/incident_environnement/incident_environnement_service.dart';
import '../../../Models/incident_environnement/incident_env_agenda_model.dart';
import '../../../Services/incident_environnement/local_incident_environnement_service.dart';
import '../../../Services/pnc/pnc_service.dart';
import '../../../Utils/shared_preference.dart';
import '../../../Utils/snack_bar.dart';
import '../../../Views/home_page.dart';
import 'valider_incident_env_traiter.dart';

class IncidentEnvATraiterPage extends StatefulWidget {

  IncidentEnvATraiterPage({Key? key}) : super(key: key);

  @override
  State<IncidentEnvATraiterPage> createState() => _IncidentEnvATraiterPageState();
}

class _IncidentEnvATraiterPageState extends State<IncidentEnvATraiterPage> {

  PNCService localService = PNCService();
  final matricule = SharedPreference.getMatricule();
  List<IncidentEnvAgendaModel> listIncident = List<IncidentEnvAgendaModel>.empty(growable: true);
  List<IncidentEnvAgendaModel> listFiltered = [];
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
      if(connection == ConnectivityResult.none) {
       // Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.BOTTOM, duration: Duration(milliseconds: 900));
        var response = await LocalIncidentEnvironnementService().readIncidentEnvATraiter();
        response.forEach((data){
          setState(() {
            var model = IncidentEnvAgendaModel();
            model.nIncident = data['nIncident'];
            model.incident = data['incident'];
            model.dateDetect = data['dateDetect'];
            listIncident.add(model);
            listFiltered = listIncident;
            listIncident.forEach((element) {
              print('element incident ${element.nIncident} - ${element.incident}');
            });
          });
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
       //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.BOTTOM, duration: Duration(milliseconds: 900));
       //rest api
        await IncidentEnvironnementService().getListIncidentEnvATraiter(matricule).then((resp) async {
          //isDataProcessing(false);
          resp.forEach((data) async {
            setState(() {
              var model = IncidentEnvAgendaModel();
              model.nIncident = data['nIncident'];
              model.incident = data['incident'];
              model.dateDetect = data['date_detect'];
              listIncident.add(model);
              listFiltered = listIncident;
              listIncident.forEach((element) {
                print('element incident ${element.nIncident} - ${element.incident}');
              });
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

  final columns = ['Numéro','Incident','Date', ''];
  int? sortColumnIndex;
  bool isAscending = false;
  final _contentStyleHeader = const TextStyle(
      color: Color(0xff060f7d), fontSize: 15, fontWeight: FontWeight.w700,
  fontFamily: "Brand-Bold");
  final _contentStyle = const TextStyle(
      color: Color(0xff0c2d5e), fontSize: 14, fontWeight: FontWeight.normal,
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
            onPressed: (){
              Get.offAll(HomePage());
            },
            child: Icon(Icons.arrow_back, color: Colors.blue,),
          ),
          title: Text(
            'Incident a Traiter : ${listIncident.length}',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: (lightPrimary),
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: listIncident.isNotEmpty ?
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
                              hintText: 'Search', border: InputBorder.none),
                          onChanged: (value) {
                            setState(() {
                               _searchResult = value;
                               listFiltered = listIncident.where((user) => user.nIncident.toString().contains(_searchResult) || user.incident!.toLowerCase().contains(_searchResult)).toList();
                            });
                          }),
                      trailing: new IconButton(
                        icon: controller.text.trim()=='' ?Text('') :Icon(Icons.cancel),
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

                : const Center(child: Text('Empty List', style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'Brand-Bold'
            )),)
        ),
      ),
    );
  }

  List<DataColumn> getColumns(List<String> columns) => columns.
      map((String column) => DataColumn(
      label: Text(column, style: _contentStyleHeader,),
    onSort: onSort
  ))
      .toList();

  List<DataRow> getRows(List<IncidentEnvAgendaModel> listIncidentInfo) => listIncidentInfo.map((IncidentEnvAgendaModel incidentEnvAgendaModel) {
    return DataRow(cells: [
      DataCell(Text('${incidentEnvAgendaModel.nIncident}', style: _contentStyle, textAlign: TextAlign.right)),
      DataCell(Text('${incidentEnvAgendaModel.incident}', style: _contentStyle, textAlign: TextAlign.right)),
      DataCell(Text('${incidentEnvAgendaModel.dateDetect}', style: _contentStyle, textAlign: TextAlign.right)),
      DataCell(
          InkWell(
              onTap: (){
                Get.to(ValiderIncidentEnvTraiter(model: incidentEnvAgendaModel));
              },
              child: Icon(Icons.edit, color: Color(
                  0xED0A7ADB), size: 30,)
          )
      ),
    ],
    onLongPress: (){
      Get.to(ValiderIncidentEnvTraiter(model: incidentEnvAgendaModel));
    });
    //final cells = [IncidentEnvAgendaModel.nReunion, IncidentEnvAgendaModel.typeReunion, IncidentEnvAgendaModel.datePrev];
    //return DataRow(cells: getCells(cells));
  }).toList();

  List<DataCell> getCells(List<dynamic> cells) =>
      cells.map((data) => DataCell(Text('${data}'))).toList();

  void onSort(int columnIndex, bool ascending) {
    if(columnIndex == 0){
      listIncident.sort((value1, value2)=>
      compareString(ascending, value1.nIncident.toString(), value2.nIncident.toString()));
    } else  if(columnIndex == 1){
      listIncident.sort((value1, value2)=>
          compareString(ascending, value1.incident.toString(), value2.incident.toString()));
    } else  if(columnIndex == 2){
      listIncident.sort((value1, value2)=>
          compareString(ascending, value1.dateDetect.toString(), value2.dateDetect.toString()));
    }
    setState(() {
      this.sortColumnIndex = columnIndex;
      this.isAscending = ascending;
    });
  }
  compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);
}
