import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Models/action/action_realisation_model.dart';
import '../../../Services/action/action_service.dart';
import '../../../Services/action/local_action_service.dart';
import '../../../Utils/shared_preference.dart';
import '../../../Utils/snack_bar.dart';
import '../../../Views/home_page.dart';
import '../../../Widgets/refresh_widget.dart';
import 'intervenant/intervenant_action_realisation_page.dart';
import 'remplir_action_realisation.dart';

class ActionRealisationPage extends StatefulWidget {
  ActionRealisationPage({Key? key}) : super(key: key);

  @override
  State<ActionRealisationPage> createState() => _ActionRealisationPageState();
}

class _ActionRealisationPageState extends State<ActionRealisationPage> {
  final keyRefresh = GlobalKey<RefreshIndicatorState>();
  LocalActionService localService = LocalActionService();
  final matricule = SharedPreference.getMatricule();
  List<ActionRealisationModel> listActionReal =
      List<ActionRealisationModel>.empty(growable: true);
  List<ActionRealisationModel> listFiltered = [];
  TextEditingController controller = TextEditingController();
  String _searchResult = '';

  //table
  final columns = [
    'N° Action',
    'N° Sous-Action',
    'Action',
    'Taux real',
    'Date',
    ''
  ];
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
  void initState() {
    super.initState();
    getActionsRealisation();
  }

  void getActionsRealisation() async {
    try {
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        var response = await localService.readActionRealisation();
        response.forEach((data) {
          setState(() {
            var model = ActionRealisationModel();
            model.nomPrenom = data['nomPrenom'];
            model.nAct = data['nAct'];
            model.act = data['act'];
            model.nSousAct = data['nSousAct'];
            model.sousAct = data['sousAct'];
            model.respReal = data['respReal'];
            model.delaiReal = data['delaiReal'];
            model.delaiSuivi = data['delaiSuivi'];
            model.dateReal = data['dateReal'];
            model.dateSuivi = data['dateSuivi'];
            model.pourcentReal = data['pourcentReal'];
            model.depense = data['depense'];
            model.commentaire = data['commentaire'];
            model.cloture = data['cloture'];
            model.priorite = data['priorite'];
            model.gravite = data['gravite'];
            listActionReal.add(model);
            listFiltered = listActionReal;
          });
        });
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        //rest api
        await ActionService().getActionRealisation({
          "mat": matricule.toString(),
          "nact": 0,
          "nsousact": 0,
          "realise": 0,
          "retard": 0,
          "filtre_sous_act": "",
          "filtre_nact": ""
        }).then((resp) async {
          //isDataProcessing(false);
          resp.forEach((data) async {
            setState(() {
              var model = ActionRealisationModel();
              model.nomPrenom = data['nompre'];
              model.causemodif = data['causemodif'];
              model.nAct = data['nAct'];
              model.nSousAct = data['nSousAct'];
              model.respReal = data['respReal'];
              model.act = data['act'];
              model.sousAct = data['sousAct'];
              model.delaiReal = data['delaiReal'];
              model.delaiSuivi = data['delaiSuivi'];
              model.dateReal = data['dateReal'];
              model.dateSuivi = data['dateSuivi'];
              model.coutPrev = data['coutPrev'];
              model.pourcentReal = data['pourcentReal'];
              model.depense = data['depense'];
              model.rapportEff = data['rapportEff'];
              model.pourcentSuivie = data['pourcentSuivie'];
              model.commentaire = data['commentaire'];
              model.cloture = data['cloture'];
              model.designation = data['designation'];
              model.dateSaisieReal = data['date_Saisie_Real'];
              model.ind = data['ind'];
              model.priorite = data['priorite'];
              model.gravite = data['gravite'];
              model.returnRespS = data['returnRespS'];
              listActionReal.add(model);
              listFiltered = listActionReal;
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
            '${'action_a_realiser'.tr} : ${listActionReal.length}',
            style: TextStyle(color: Colors.black, fontSize: 15),
          ),
          backgroundColor: (lightPrimary),
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: listActionReal.isNotEmpty
                ? RefreshWidget(
                    keyRefresh: keyRefresh,
                    onRefresh: () async {
                      controller.clear();
                      listActionReal.clear();
                      getActionsRealisation();
                    },
                    child: Column(
                      children: <Widget>[
                        Card(
                          //margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
                          child: TextField(
                            controller: controller,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.search),
                                suffixIcon: InkWell(
                                  onTap: () {
                                    setState(() {
                                      controller.clear();
                                      _searchResult = '';
                                      listFiltered = listActionReal;
                                    });
                                  },
                                  child: controller.text.trim() == ''
                                      ? Text('')
                                      : Icon(Icons.cancel),
                                ),
                                hintText: 'search'.tr,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide:
                                        const BorderSide(color: Colors.blue))),
                            onChanged: (value) {
                              setState(() {
                                _searchResult = value;
                                listFiltered = listActionReal
                                    .where((user) =>
                                        user.nAct
                                            .toString()
                                            .contains(_searchResult) ||
                                        user.act!
                                            .toLowerCase()
                                            .contains(_searchResult))
                                    .toList();
                              });
                            },
                          ),
                        ),
                        Flexible(
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              final num_action = listFiltered[index].nAct;
                              final num_sous_action =
                                  listFiltered[index].nSousAct;
                              return Card(
                                color: Color(0xFFFCF9F9),
                                child: ListTile(
                                  title: Text(
                                    ' Action: ${num_action}   \n Sous Action: ${num_sous_action}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 5.0,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 5, bottom: 5),
                                          child: Text(
                                              'Designation : ${listFiltered[index].act}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF415271))),
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                            children: [
                                              WidgetSpan(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 2.0),
                                                  child: Icon(
                                                      Icons.calendar_today),
                                                ),
                                              ),
                                              TextSpan(
                                                  text:
                                                      '${listFiltered[index].delaiReal}'),

                                              //TextSpan(text: '${action.declencheur}'),
                                            ],
                                          ),
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                            children: [
                                              WidgetSpan(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 2.0),
                                                  child: Icon(Icons.person),
                                                ),
                                              ),
                                              TextSpan(
                                                  text:
                                                      '${listFiltered[index].nomPrenom}'),

                                              //TextSpan(text: '${action.declencheur}'),
                                            ],
                                          ),
                                        ),
                                        Text(
                                            '${'taux_realisation'.tr} : ${listFiltered[index].pourcentReal}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFF5D6893))),
                                      ],
                                    ),
                                  ),
                                  trailing: Container(
                                    padding:
                                        EdgeInsets.only(bottom: 1.0, top: 1.0),
                                    margin: EdgeInsets.zero,
                                    child: Wrap(
                                      spacing: 1.0,
                                      runSpacing: 1.0,
                                      direction: Axis.vertical,
                                      children: <Widget>[
                                        IconButton(
                                          onPressed: () async {
                                            /* Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (context) => RemplirActionRealisation(
                                    actionRealisation: listFiltered[index],
                                  ))); */
                                            Get.to(RemplirActionRealisation(
                                                actionRealisation:
                                                    listFiltered[index]));
                                          },
                                          icon: Icon(
                                            Icons.edit,
                                            color: Colors.green,
                                          ),
                                          tooltip: 'modifier action',
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            Get.to(
                                                IntervenantsActionRealisationPage(
                                              idAction:
                                                  listFiltered[index].nAct,
                                              idSousAction:
                                                  listFiltered[index].nSousAct,
                                            ));
                                          },
                                          icon: Icon(
                                            Icons.remove_red_eye,
                                            color: Colors.blue,
                                          ),
                                          tooltip: 'Intervenants',
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: listFiltered.length,
                            //itemCount: actionsList.length + 1,
                          ),
                        )
                      ],
                    ),
                    /* child: SingleChildScrollView(
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
                                listFiltered = listActionReal.where((user) => user.nAct.toString().contains(_searchResult) || user.act!.toLowerCase().contains(_searchResult)).toList();
                              });
                            }),
                        trailing: new IconButton(
                          icon: controller.text.trim()=='' ?Text('') :Icon(Icons.cancel),
                          onPressed: () {
                            setState(() {
                              controller.clear();
                              _searchResult = '';
                              listFiltered = listActionReal;
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
                        columnSpacing: (MediaQuery.of(context).size.width / 100) * 0.2,
                        dataRowHeight: 50,
                      ),
                    ),
                  ],
                ),
              ), */
                  )
                : Center(
                    child: Text('empty_list'.tr,
                        style: TextStyle(
                            fontSize: 20.0, fontFamily: 'Brand-Bold')),
                  )),
      ),
    );
  }

  //table
  /* List<DataColumn> getColumns(List<String> columns) => columns.
  map((String column) => DataColumn(
      label: Container(
          width: (MediaQuery.of(context).size.width / 10) * 3,
          child: Text(column, style: _contentStyleHeader,)),
      onSort: onSort
  ))
      .toList();

  List<DataRow> getRows(List<ActionRealisationModel> listInfo) => listInfo.map((ActionRealisationModel model) {
    return DataRow(cells: [
      DataCell(Container(
          width: (MediaQuery.of(context).size.width / 10) * 0.9,
          child: Text('${model.nAct}', style: _contentStyle, textAlign: TextAlign.right))),
      DataCell(Container(
          width: (MediaQuery.of(context).size.width / 10) * 0.9,
          child: Text('${model.nSousAct}', style: _contentStyle, textAlign: TextAlign.right))),
      DataCell(Container(
          width: (MediaQuery.of(context).size.width / 10) * 2,
          child: Text('${model.act}', style: _contentStyle, textAlign: TextAlign.right))),
      DataCell(Container(
          width: (MediaQuery.of(context).size.width / 10) * 0.5,
          child: Text('${model.pourcentReal}', style: _contentStyle, textAlign: TextAlign.right))),
      DataCell(Container(
          width: (MediaQuery.of(context).size.width / 10) * 2.2,
          child: Text('${model.dateReal}', style: _contentStyle, textAlign: TextAlign.right))),
      DataCell(
          Column(
            children: [
              InkWell(
                  onTap: (){
                    Get.to(RemplirActionRealisation(actionRealisation: model));
                  },
                  child: Icon(Icons.edit, color: Color(
                      0xED0A7ADB), size: 25,)
              ),
              InkWell(
                  onTap: (){
                    Get.to(IntervenantsActionRealisationPage(idAction: model.nAct, idSousAction: model.nSousAct,));
                  },
                  child: Icon(Icons.remove_red_eye, color: Color(
                      0xED15B892), size: 25,)
              ),
            ],
          )
      ),
    ],
        onLongPress: (){
          Get.to(RemplirActionRealisation(actionRealisation: model));
        });
    //final cells = [IncidentEnvAgendaModel.nReunion, IncidentEnvAgendaModel.typeReunion, IncidentEnvAgendaModel.datePrev];
    //return DataRow(cells: getCells(cells));
  }).toList();

  List<DataCell> getCells(List<dynamic> cells) =>
      cells.map((data) => DataCell(Text('${data}'))).toList();

  void onSort(int columnIndex, bool ascending) {
    if(columnIndex == 0){
      listActionReal.sort((value1, value2)=>
          compareString(ascending, value1.nAct.toString(), value2.nAct.toString()));
    } else  if(columnIndex == 1){
      listActionReal.sort((value1, value2)=>
          compareString(ascending, value1.act.toString(), value2.act.toString()));
    } else  if(columnIndex == 2){
      listActionReal.sort((value1, value2)=>
          compareString(ascending, value1.dateReal.toString(), value2.dateReal.toString()));
    }
    setState(() {
      this.sortColumnIndex = columnIndex;
      this.isAscending = ascending;
    });
  }
  compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);
  */
}
