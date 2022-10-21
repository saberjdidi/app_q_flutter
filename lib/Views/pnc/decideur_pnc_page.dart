import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualipro_flutter/Models/employe_model.dart';
import 'package:qualipro_flutter/Services/pnc/pnc_service.dart';
import '../../../../Services/action/action_service.dart';
import '../../../../Services/action/local_action_service.dart';
import '../../../../Utils/shared_preference.dart';
import '../../../../Utils/snack_bar.dart';
import '../../../Models/product_model.dart';
import '../../../Services/api_services_call.dart';
import '../../Models/processus_model.dart';
import '../../Models/site_model.dart';
import '../../Utils/custom_colors.dart';
import '../../Utils/message.dart';

class DecideurPNCPage extends StatefulWidget {

 const DecideurPNCPage({Key? key}) : super(key: key);

  @override
  State<DecideurPNCPage> createState() => _DecideurPNCPageState();
}

class _DecideurPNCPageState extends State<DecideurPNCPage> {
  final _addItemFormKey = GlobalKey<FormState>();
  LocalActionService localService = LocalActionService();
  //ActionService actionService = ActionService();
  final matricule = SharedPreference.getMatricule();
  List<EmployeModel> listDecideur = List<EmployeModel>.empty(growable: true);

  //site
  SiteModel? siteModel = null;
  int? selectedCodeSite = 0;
  //processus
  ProcessusModel? processusModel = null;
  int? selectedCodeProcessus = 0;

  @override
  void initState() {
    super.initState();
    //checkConnectivity();
    //getDecideurs();
  }
  Future<void> checkConnectivity() async {
    var connection = await Connectivity().checkConnectivity();
    if (connection == ConnectivityResult.none) {
      Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
    }
    else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
      Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
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
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(190.0),
          child: SingleChildScrollView(
            child: Form(
              key: _addItemFormKey,
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  children: [
                    SizedBox(height: 4.0,),
                    DropdownSearch<SiteModel>(
                      showSelectedItems: true,
                      showClearButton: false,
                      showSearchBox: true,
                      isFilteredOnline: true,
                      compareFn: (i, s) => i?.isEqual(s) ?? false,
                      dropdownSearchDecoration: InputDecoration(
                        labelText: "Site",
                        contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                        border: OutlineInputBorder(),
                      ),
                      onFind: (String? filter) => getSite(filter),
                      onChanged: (data) {
                        siteModel = data;
                        selectedCodeSite = data?.codesite;
                        print('site : ${siteModel?.site}, code : $selectedCodeSite');
                      },
                      dropdownBuilder: customDropDownSite,
                      popupItemBuilder: customPopupItemBuilderSite,
                    ),
                    SizedBox(height: 5.0,),
                    DropdownSearch<ProcessusModel>(
                      showSelectedItems: true,
                      showClearButton: false,
                      showSearchBox: true,
                      isFilteredOnline: true,
                      compareFn: (i, s) => i?.isEqual(s) ?? false,
                      dropdownSearchDecoration: InputDecoration(
                        labelText: "Processus",
                        contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                        border: OutlineInputBorder(),
                      ),
                      onFind: (String? filter) => getProcessus(filter),
                      onChanged: (data) {
                        processusModel = data;
                        selectedCodeProcessus = data?.codeProcessus;
                        print('processus : ${processusModel?.processus}, code : $selectedCodeProcessus');
                      },
                      dropdownBuilder: customDropDownProcessus,
                      popupItemBuilder: customPopupItemBuilderProcessus,
                    ),
                    SizedBox(height: 1.0,),
                    ElevatedButton(
                      onPressed: () async {
                        searchBtn();
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
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Search',
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
                ),
              ),
            ),

          ),
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(

            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                    child: listDecideur.isNotEmpty ?
                    ListView.builder(
                        itemBuilder: (context, index) {
                          //return Text('${listDecideur[index].nompre}', style: TextStyle(color: Colors.black),);
                          return Card(
                            child: ListTile(
                              title: Text(
                                ' ${listDecideur[index].nompre}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: RichText(
                                  text: TextSpan(
                                    style: Theme.of(context).textTheme.bodyLarge,
                                    children: [
                                      /*  WidgetSpan(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                              child: Icon(Icons.person),
                                            ),
                                          ),*/
                                      TextSpan(text: '${listDecideur[index].mat}'),

                                      //TextSpan(text: '${action.declencheur}'),
                                    ],

                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: listDecideur.length,
                        //itemCount: actionsList.length + 1,
                      )
                        : const Center(child: Text('Empty List', style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'Brand-Bold'
                    )),),
                  )

            )
        ),
      ),
    );
  }

  bool _dataValidation() {
    if (siteModel == null) {
      Message.taskErrorOrWarning("Warning", "Select Site");
      return false;
    }
    else if (processusModel == null) {
      Message.taskErrorOrWarning("Warning", "Select Process");
      return false;
    }
    return true;
  }
  void getDecideurs() async {
    try {
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

          await PNCService().getDecideurPNC(selectedCodeSite, selectedCodeProcessus).then((resp) async {
            resp.forEach((data) async {
              setState(() {
                var model = EmployeModel();
                model.nompre = data['nompre'];
                model.mat = data['mat'];
                listDecideur.add(model);
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

  Future searchBtn() async {
    if(_dataValidation() && _addItemFormKey.currentState!.validate()){
      try {
        listDecideur.clear();
        getDecideurs();
      }
      catch (ex){
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
    }
  }

  //Site
  Future<List<SiteModel>> getSite(filter) async {
    try {
      List<SiteModel> siteList = await List<SiteModel>.empty(growable: true);
      List<SiteModel> siteFilter = await <SiteModel>[];
      var sites = await LocalActionService().readSite();
      sites.forEach((data){
        var siteModel = SiteModel();
        siteModel.codesite = data['codesite'];
        siteModel.site = data['site'];
        siteList.add(siteModel);
      });
      siteFilter = siteList.where((u) {
        var name = u.codesite.toString().toLowerCase();
        var description = u.site!.toLowerCase();
        return name.contains(filter) ||
            description.contains(filter);
      }).toList();
      return siteFilter;
    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }
  Widget customDropDownSite(BuildContext context, SiteModel? item) {
    if (siteModel == null) {
      return Container();
    }
    else{
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${siteModel?.site}', style: TextStyle(color: Colors.black),),
        ),
      );
    }
  }
  Widget customPopupItemBuilderSite(
      BuildContext context, siteModel, bool isSelected) {
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
        title: Text(siteModel?.site ?? ''),
        subtitle: Text(siteModel?.codesite.toString() ?? ''),
      ),
    );
  }
  //Processus
  Future<List<ProcessusModel>> getProcessus(filter) async {
    try {
      List<ProcessusModel> processusList = await List<ProcessusModel>.empty(growable: true);
      List<ProcessusModel> processusFilter = await <ProcessusModel>[];
      var response = await LocalActionService().readProcessus();
      response.forEach((data){
        var model = ProcessusModel();
        model.codeProcessus = data['codeProcessus'];
        model.processus = data['processus'];
        processusList.add(model);
      });
      processusFilter = processusList.where((u) {
        var name = u.codeProcessus.toString().toLowerCase();
        var description = u.processus!.toLowerCase();
        return name.contains(filter) ||
            description.contains(filter);
      }).toList();
      return processusFilter;
    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }
  Widget customDropDownProcessus(BuildContext context, ProcessusModel? item) {
    if (processusModel == null) {
      return Container();
    }
    else{
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${processusModel?.processus}', style: TextStyle(color: Colors.black),),
        ),
      );
    }
  }
  Widget customPopupItemBuilderProcessus(
      BuildContext context, processusModel, bool isSelected) {
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
        title: Text(processusModel?.processus ?? ''),
        subtitle: Text(processusModel?.codeProcessus.toString() ?? ''),
      ),
    );
  }

}