import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import '../../../Models/pnc/pnc_a_corriger_model.dart';
import '../../../Models/pnc/pnc_suivre_model.dart';
import '../../../Services/pnc/local_pnc_service.dart';
import '../../../Services/pnc/pnc_service.dart';
import '../../../Utils/custom_colors.dart';
import '../../../Utils/shared_preference.dart';
import '../../../Utils/snack_bar.dart';
import '../../../Views/home_page.dart';
import 'remplir_pnc_suivre.dart';

class PNCSuivrePage extends StatefulWidget {

  PNCSuivrePage({Key? key}) : super(key: key);

  @override
  State<PNCSuivrePage> createState() => _PNCSuivrePageState();
}

class _PNCSuivrePageState extends State<PNCSuivrePage> {

  PNCService localService = PNCService();
  final matricule = SharedPreference.getMatricule();
  List<PNCSuivreModel> listPNCSuivre = List<PNCSuivreModel>.empty(growable: true);
  List<PNCSuivreModel> listFiltered = [];
  TextEditingController controller = TextEditingController();
  String _searchResult = '';

  @override
  void initState() {
    super.initState();
    getPNCASuivre();
  }

  void getPNCASuivre() async {
    try {
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
       // Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.BOTTOM, duration: Duration(milliseconds: 900));
        var response = await LocalPNCService().readPNCASuivre();
        response.forEach((data){
          setState(() {
            var model = PNCSuivreModel();
            model.nnc = data['nnc'];
            model.dateDetect = data['dateDetect'];
            model.produit = data['produit'];
            model.typeNC = data['typeNC'];
            model.qteDetect = data['qteDetect'];
            model.codepdt = data['codepdt'];
            model.delaiTrait = data['delaiTrait'];
            model.nlot = data['nlot'];
            model.ind = data['ind'];
            model.traitee = data['traitee'];
            model.nc = data['nc'];
            model.nomClt = data['nomClt'];
            listPNCSuivre.add(model);
            listFiltered = listPNCSuivre;
            listPNCSuivre.forEach((element) {
              print('element pnc ${element.nc}, id : ${element.nnc}');
            });
          });
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
       //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.BOTTOM, duration: Duration(milliseconds: 900));
       //rest api
        await PNCService().getPNCASuivre(matricule).then((resp) async {
          //isDataProcessing(false);
          resp.forEach((data) async {
            setState(() {
              var model = PNCSuivreModel();
              model.nnc = data['nnc'];
              model.dateDetect = data['dateDetect'];
              model.produit = data['produit'];
              model.typeNC = data['typeNC'];
              model.qteDetect = data['qteDetect'];
              model.codepdt = data['codepdt'];
              model.delaiTrait = data['delaiTrait'];
              model.nlot = data['nlot'];
              model.ind = data['ind'];
              model.traitee = data['traitee'];
              model.nc = data['nc'];
              model.nomClt = data['nomClt'];
              listPNCSuivre.add(model);
              listFiltered = listPNCSuivre;
              listPNCSuivre.forEach((element) {
                print('element pnc ${element.nc}, id : ${element.nnc}');
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

  final columns = ['Numéro','n.c','date', 'produit',''];
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
          leading: RaisedButton(
            onPressed: (){
              Get.offAll(HomePage());
            },
            elevation: 0.0,
            child: Icon(Icons.arrow_back, color: Colors.blue,),
            color: Colors.white,
          ),
          title: Text(
            'Non Confirmité a Suivre ${listPNCSuivre.length}',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: (lightPrimary),
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: listPNCSuivre.isNotEmpty ?
          /*  Container(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  final num_pnc = listPNCSuivre[index].nnc;

                  return
                    Column(
                    children: [
                      ListTile(
                        title: Expanded(
                          flex: 1,
                          child: ListTile(
                            title: Text(
                              'PNC N°${num_pnc}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style: Theme.of(context).textTheme.bodyLarge,
                                      children: [
                                        WidgetSpan(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                            child: Icon(Icons.calendar_today),
                                          ),
                                        ),
                                        TextSpan(text: '${listPNCSuivre[index].dateDetect}'),

                                        //TextSpan(text: '${action.declencheur}'),
                                      ],

                                    ),
                                  ),

                                  RichText(
                                      textAlign: TextAlign.start,
                                      text: TextSpan(
                                        style: Theme.of(context).textTheme.bodyLarge,
                                        children: [
                                          TextSpan(text: '${listPNCSuivre[index].nc}'),
                                        ],

                                      ),
                                    ),
                                  Text('${listPNCSuivre[index].produit}',
                                        style: TextStyle(color: Colors.blueAccent)),
                                ],
                              ),
                            ),
                            trailing: IconButton(
                              onPressed: () async {
                                Get.to(RemplirPNCSuivre(pncSuivreModel: listPNCSuivre[index],));
                              },
                              icon: Icon(Icons.edit, color: Colors.green,),
                              tooltip: 'pnc a suivre',
                            ),
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: ReadMoreText(
                            "${listPNCSuivre[index].typeNC}",
                            style: TextStyle(
                                color: Color(0xFF3B465E),
                                fontWeight: FontWeight.bold),
                            trimLines: 3,
                            colorClickableText: CustomColors.bleuCiel,
                            trimMode: TrimMode.Line,
                            trimCollapsedText: 'more',
                            trimExpandedText: 'less',
                            moreStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: CustomColors.bleuCiel),
                          )
                        ),
                        /*trailing: Container(
                          padding: EdgeInsets.only(bottom: 1.0, top: 1.0),
                          margin: EdgeInsets.zero,
                          child: Wrap(
                               spacing: 1.0,
                            runSpacing: 1.0,
                            direction: Axis.vertical,
                            children: <Widget>[
                              IconButton(
                                onPressed: () async {

                                },
                                icon: Icon(Icons.edit, color: Colors.green,),
                                tooltip: 'modifier pnc',
                              ),
                              IconButton(
                                onPressed: () async {
                                  //Get.to(IntervenantsPNCSuivrePage(idAction: listPNCSuivre[index].nAct, idSousAction: listPNCSuivre[index].nSousAct,));
                                },
                                icon: Icon(Icons.remove_red_eye, color: Colors.blue,),
                                tooltip: 'Intervenants',
                              )
                            ],
                          ),
                        ), */
                        /// this function uses to navigate (move to next screen) User Details page and pass user objects into the User Details page. ///
                        onTap: () {
                          //Get.to(IntervenantsPage(idAction: listPNCSuivre[index].nAct, idSousAction: listPNCSuivre[index].nSousAct,));
                          //Get.to(RemplirActionRealisation(actionRealisation: listPNCSuivre[index]));
                        },
                      ),
                      Divider(
                        thickness: 1.0,
                        color: Colors.blue,
                      ),
                    ],
                  );
                },
                itemCount: listPNCSuivre.length,
                //itemCount: actionsList.length + 1,
              ),
            )
            */
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
                               listFiltered = listPNCSuivre.where((user) =>
                                      user.nnc.toString().contains(_searchResult)
                                   || user.nc.toString().contains(_searchResult)
                                   || user.produit.toString().contains(_searchResult)
                               ).toList();
                            });
                          }),
                      trailing: new IconButton(
                        icon: controller.text.trim()=='' ?Text('') :Icon(Icons.cancel),
                        onPressed: () {
                          setState(() {
                             controller.clear();
                                _searchResult = '';
                                listFiltered = listPNCSuivre;
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

  List<DataRow> getRows(List<PNCSuivreModel> listPNC) => listPNC.map((PNCSuivreModel pncSuivreModel) {
    final cells = [pncSuivreModel.nnc, pncSuivreModel.dateDetect, pncSuivreModel.produit];
    return DataRow(cells: [
      DataCell(InkWell(
          onTap: (){
            Get.to(RemplirPNCSuivre(pncSuivreModel: pncSuivreModel,));
          },
          child: Text('${pncSuivreModel.nnc}', style: _contentStyle, textAlign: TextAlign.right)
          )),
      DataCell(Text('${pncSuivreModel.nc}', style: _contentStyle, textAlign: TextAlign.right)),
     /* DataCell(ReadMoreText(
        '${pncSuivreModel.nnc}',
        style: _contentStyle,
        trimLines: 3,
        colorClickableText: CustomColors.bleuCiel,
        trimMode: TrimMode.Line,
        trimCollapsedText: 'more',
        trimExpandedText: 'less',
        moreStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: CustomColors.bleuCiel),
      )), */
      DataCell(Text('${pncSuivreModel.dateDetect}', style: _contentStyle, textAlign: TextAlign.right)),
      DataCell(Text('${pncSuivreModel.produit}', style: _contentStyle, textAlign: TextAlign.right)),
      DataCell(
          InkWell(
              onTap: (){
                Get.to(RemplirPNCSuivre(pncSuivreModel: pncSuivreModel,));
              },
              child: Icon(Icons.edit, color: Color(0xFF0C8273),)
          )
      ),
    ],
    onLongPress: (){
      Get.to(RemplirPNCSuivre(pncSuivreModel: pncSuivreModel,));
    });
    //return DataRow(cells: getCells(cells));
  }).toList();

  List<DataCell> getCells(List<dynamic> cells) =>
      cells.map((data) => DataCell(Text('${data}'))).toList();

  void onSort(int columnIndex, bool ascending) {
    if(columnIndex == 0){
      listPNCSuivre.sort((pnc1, pnc2)=>
      compareString(ascending, pnc1.nnc.toString(), pnc2.nnc.toString()));
    } else  if(columnIndex == 1){
      listPNCSuivre.sort((pnc1, pnc2)=>
          compareString(ascending, pnc1.dateDetect.toString(), pnc2.dateDetect.toString()));
    } else  if(columnIndex == 2){
      listPNCSuivre.sort((pnc1, pnc2)=>
          compareString(ascending, pnc1.produit.toString(), pnc2.produit.toString()));
    }
    setState(() {
      this.sortColumnIndex = columnIndex;
      this.isAscending = ascending;
    });
  }
  compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);
}
