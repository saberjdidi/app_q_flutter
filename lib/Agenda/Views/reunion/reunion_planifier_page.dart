import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qualipro_flutter/Services/reunion/reunion_service.dart';
import 'package:readmore/readmore.dart';
import '../../../Models/pnc/pnc_a_corriger_model.dart';
import '../../../Models/pnc/pnc_suivre_model.dart';
import '../../../Models/reunion/reunion_model.dart';
import '../../../Services/pnc/local_pnc_service.dart';
import '../../../Services/pnc/pnc_service.dart';
import '../../../Services/reunion/local_reunion_service.dart';
import '../../../Utils/custom_colors.dart';
import '../../../Utils/shared_preference.dart';
import '../../../Utils/snack_bar.dart';
import '../../../Views/home_page.dart';
import 'confirmer_reunion_informer.dart';
import 'confirmer_reunion_planifier.dart';

class ReunionPlanifierPage extends StatefulWidget {

  ReunionPlanifierPage({Key? key}) : super(key: key);

  @override
  State<ReunionPlanifierPage> createState() => _ReunionPlanifierPageState();
}

class _ReunionPlanifierPageState extends State<ReunionPlanifierPage> {

  PNCService localService = PNCService();
  final matricule = SharedPreference.getMatricule();
  List<ReunionModel> listReunion = List<ReunionModel>.empty(growable: true);
  List<ReunionModel> listFiltered = [];
  TextEditingController controller = TextEditingController();
  String _searchResult = '';

  @override
  void initState() {
    super.initState();
    getReunion();
  }

  void getReunion() async {
    try {
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
       // Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.BOTTOM, duration: Duration(milliseconds: 900));
        var response = await LocalReunionService().readReunionPlanifier();
        response.forEach((data){
          setState(() {
            var model = ReunionModel();
            model.nReunion = data['nReunion'];
            model.typeReunion = data['typeReunion'];
            model.datePrev = data['datePrev'];
            model.ordreJour = data['ordreJour'];
            model.heureDeb = data['heureDeb'];
            model.heureFin = data['heureFin'];
            model.lieu = data['lieu'];
            listReunion.add(model);
            listFiltered = listReunion;
            listReunion.forEach((element) {
              print('element reunion ${element.nReunion}, type : ${element.typeReunion}');
            });
          });
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
       //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.BOTTOM, duration: Duration(milliseconds: 900));
       //rest api
        await ReunionService().getReunionPlanifier(matricule).then((resp) async {
          //isDataProcessing(false);
          resp.forEach((data) async {
            setState(() {
              var model = ReunionModel();
              model.nReunion = data['nReunion'];
              model.typeReunion = data['typeReunion'];
              model.datePrev = data['datePrev'];
              model.ordreJour = data['ordreJour'];
              model.heureDeb = data['heureDeb'];
              model.heureFin = data['heureFin'];
              model.lieu = data['lieu'];
              listReunion.add(model);
              listFiltered = listReunion;
              listReunion.forEach((element) {
                print('element reunion ${element.nReunion}, type : ${element.typeReunion}');
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

  final columns = ['Numéro','Type','Date', 'Heure',''];
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
            'Reunion Planifiée : ${listReunion.length}',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: (lightPrimary),
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: listReunion.isNotEmpty ?
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
                               listFiltered = listReunion.where((user) => user.nReunion.toString().contains(_searchResult) || user.typeReunion!.toLowerCase().contains(_searchResult)).toList();
                            });
                          }),
                      trailing: new IconButton(
                        icon: controller.text.trim()=='' ?Text('') :Icon(Icons.cancel),
                        onPressed: () {
                          setState(() {
                             controller.clear();
                                _searchResult = '';
                                listFiltered = listReunion;
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

  List<DataRow> getRows(List<ReunionModel> listReunionInfo) => listReunionInfo.map((ReunionModel reunionModel) {
    return DataRow(cells: [
      DataCell(InkWell(
          onTap: (){
            Get.to(ConfirmerReunionPlanifier(model: reunionModel));
          },
          child: Text('${reunionModel.nReunion}', style: _contentStyle, textAlign: TextAlign.right))),
      DataCell(Text('${reunionModel.typeReunion}', style: _contentStyle, textAlign: TextAlign.right)),
     /* DataCell(ReadMoreText(
        '${ReunionModel.nnc}',
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
      DataCell(Text('${reunionModel.datePrev}', style: _contentStyle, textAlign: TextAlign.right)),
      DataCell(Text('${reunionModel.heureDeb}', style: _contentStyle, textAlign: TextAlign.right)),
      DataCell(
          InkWell(
              onTap: (){
                Get.to(ConfirmerReunionPlanifier(model: reunionModel));
              },
              child: Icon(Icons.remove_red_eye_outlined, color: Color(
                  0xED0A7ADB),)
          )
      ),
    ],
    onLongPress: (){
      Get.to(ConfirmerReunionPlanifier(model: reunionModel));
    });
    //final cells = [reunionModel.nReunion, reunionModel.typeReunion, reunionModel.datePrev];
    //return DataRow(cells: getCells(cells));
  }).toList();

  List<DataCell> getCells(List<dynamic> cells) =>
      cells.map((data) => DataCell(Text('${data}'))).toList();

  void onSort(int columnIndex, bool ascending) {
    if(columnIndex == 0){
      listReunion.sort((value1, value2)=>
      compareString(ascending, value1.nReunion.toString(), value2.nReunion.toString()));
    } else  if(columnIndex == 1){
      listReunion.sort((value1, value2)=>
          compareString(ascending, value1.typeReunion.toString(), value2.typeReunion.toString()));
    } else  if(columnIndex == 2){
      listReunion.sort((value1, value2)=>
          compareString(ascending, value1.datePrev.toString(), value2.datePrev.toString()));
    }
    setState(() {
      this.sortColumnIndex = columnIndex;
      this.isAscending = ascending;
    });
  }
  compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);
}
