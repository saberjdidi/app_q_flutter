import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:qualipro_flutter/Models/visite_securite/equipe_visite_securite_model.dart';
import 'package:qualipro_flutter/Services/visite_securite/visite_securite_service.dart';
import '../../../Utils/custom_colors.dart';
import '../../../Utils/snack_bar.dart';
import '../../Controllers/visite_securite/new_visite_securite_controller.dart';
import '../../Models/employe_model.dart';
import '../../Models/site_model.dart';
import '../../Models/visite_securite/checklist_model.dart';
import '../../Models/visite_securite/unite_model.dart';
import '../../Models/visite_securite/zone_model.dart';
import '../../Route/app_route.dart';
import '../../Services/api_services_call.dart';
import '../../Services/visite_securite/local_visite_securite_service.dart';
import '../../Widgets/loading_widget.dart';

class NewVisiteSecuritePage extends GetView<NewVisiteSecuriteController> {
  final _contentStyleHeader = const TextStyle(
      color: Color(0xff060f7d), fontSize: 14, fontWeight: FontWeight.w700);
  final _contentStyle = const TextStyle(
      color: Color(0xff0c2d5e), fontSize: 14, fontWeight: FontWeight.normal);

  @override
  Widget build(BuildContext context) {

    final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
    final _filterEditTextController = TextEditingController();

    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        leading: RaisedButton(
          onPressed: () async{
            //Get.back();
            //controller.clearData();
           await LocalVisiteSecuriteService().deleteTableEquipeVisiteSecurite();
           await Get.toNamed(AppRoute.visite_securite);
          },
          elevation: 0.0,
          child: Icon(Icons.arrow_back, color: Colors.white,),
          color: Colors.blue,
        ),
        title: Center(
          child: Text("Ajouter Visite Securite"),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Obx((){
              if(controller.isVisibleVisiteSecurite.value == true){
                return Card(
                  child: SingleChildScrollView(
                    child: Form(
                        key: controller.addItemFormKey,
                        child: Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 10.0,),
                                Visibility(
                                    visible: true,
                                    child: DropdownSearch<CheckListModel>(
                                      showSelectedItems: true,
                                      showClearButton: true,
                                      showSearchBox: true,
                                      isFilteredOnline: true,
                                      compareFn: (i, s) => i?.isEqual(s) ?? false,
                                      dropdownSearchDecoration: InputDecoration(
                                        labelText: "Check-list *",
                                        contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                        border: OutlineInputBorder(),
                                      ),
                                      onFind: (String? filter) => getCheckList(filter),
                                      onChanged: (data) {
                                        controller.checkListModel = data;
                                        controller.selectedIdCheckList = data?.idCheck;
                                        controller.checkList = data?.checklist;
                                        print('CheckList: ${controller.checkListModel?.checklist}, id: ${controller.selectedIdCheckList}');
                                      },
                                      dropdownBuilder: controller.customDropDownCheckList,
                                      popupItemBuilder: controller.customPopupItemBuilderCheckList,
                                    )
                                ),
                                SizedBox(height: 10.0,),
                                Visibility(
                                    visible: true,
                                    child: DropdownSearch<UniteModel>(
                                      showSelectedItems: true,
                                      showClearButton: true,
                                      showSearchBox: true,
                                      isFilteredOnline: true,
                                      compareFn: (i, s) => i?.isEqual(s) ?? false,
                                      dropdownSearchDecoration: InputDecoration(
                                        labelText: "Unite *",
                                        contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                        border: OutlineInputBorder(),
                                      ),
                                      onFind: (String? filter) => getUnite(filter),
                                      onChanged: (data) {
                                        controller.uniteModel = data;
                                        controller.selectedIdUnite = data?.idUnite;
                                        controller.unite = data?.unite;
                                        print('unite: ${controller.unite}, id: ${controller.selectedIdUnite}');
                                      },
                                      dropdownBuilder: controller.customDropDownUnite,
                                      popupItemBuilder: controller.customPopupItemBuilderUnite,

                                    )
                                ),
                                SizedBox(height: 10.0,),
                                Visibility(
                                    visible: true,
                                    child: DropdownSearch<ZoneModel>(
                                      showSelectedItems: true,
                                      showClearButton: true,
                                      showSearchBox: true,
                                      isFilteredOnline: true,
                                      compareFn: (i, s) => i?.isEqual(s) ?? false,
                                      dropdownSearchDecoration: InputDecoration(
                                        labelText: "Zone *",
                                        contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                        border: OutlineInputBorder(),
                                      ),
                                      onFind: (String? filter) => getZone(filter),
                                      onChanged: (data) {
                                        controller.zoneModel = data;
                                        controller.selectedIdZone = data?.idZone;
                                        controller.zone = data?.zone;
                                        print('zone: ${controller.zone}, id: ${controller.selectedIdZone}');
                                      },
                                      dropdownBuilder: controller.customDropDownZone,
                                      popupItemBuilder: controller.customPopupItemBuilderZone,

                                    )
                                ),
                                SizedBox(height: 10.0,),
                                Visibility(
                                  visible: true,
                                  child: TextFormField(
                                    controller: controller.dateVisiteController,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    onChanged: (value){
                                      controller.selectedDate(context);
                                    },
                                    decoration: InputDecoration(
                                        labelText: 'Date Visite',
                                        hintText: 'date',
                                        labelStyle: TextStyle(
                                          fontSize: 14.0,
                                        ),
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 10.0,
                                        ),
                                        suffixIcon: InkWell(
                                          onTap: (){
                                            controller.selectedDate(context);
                                          },
                                          child: Icon(Icons.calendar_today),
                                        ),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.lightBlue, width: 1),
                                            borderRadius: BorderRadius.all(Radius.circular(10))
                                        )
                                    ),
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                ),
                                SizedBox(height: 10.0,),
                                Visibility(
                                    visible:true,
                                    child: DropdownSearch<SiteModel>(
                                      showSelectedItems: true,
                                      showClearButton: controller.siteModel?.site=="" ? false : true,
                                      showSearchBox: true,
                                      isFilteredOnline: true,
                                      compareFn: (i, s) => i?.isEqual(s) ?? false,
                                      dropdownSearchDecoration: InputDecoration(
                                        labelText: "Site ${controller.site_obligatoire.value==1?'*':''}",
                                        contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                        border: OutlineInputBorder(),
                                      ),
                                      onFind: (String? filter) => getSite(filter),
                                      onChanged: (data) {
                                        controller.siteModel = data;
                                        controller.selectedCodeSite = data?.codesite;
                                        controller.siteIncident = data?.site;
                                        print('site: ${controller.siteModel?.site}, code: ${controller.selectedCodeSite}');
                                      },
                                      dropdownBuilder: controller.customDropDownSite,
                                      popupItemBuilder: controller.customPopupItemBuilderSite,
                                      validator: (u) =>
                                      (controller.site_obligatoire.value==1 && controller.siteModel==null) ? "site is required " : null,
                                    )
                                ),
                                SizedBox(height: 10.0,),
                                TextFormField(
                                  controller: controller.situationObserveController,
                                  keyboardType: TextInputType.multiline,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    labelText: 'Situation Observe ',
                                    hintText: 'Situation Observe',
                                    labelStyle: TextStyle(
                                      fontSize: 14.0,
                                    ),
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10.0,
                                    ),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.lightBlue, width: 1),
                                        borderRadius: BorderRadius.all(Radius.circular(10))
                                    ),
                                  ),
                                  style: TextStyle(fontSize: 14.0),
                                ),
                                SizedBox(height: 10.0,),
                                TextFormField(
                                  controller: controller.comportementSurObserveController,
                                  keyboardType: TextInputType.multiline,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    labelText: 'Comportement Sur Observe',
                                    hintText: 'Comportement Sur Observe',
                                    labelStyle: TextStyle(
                                      fontSize: 14.0,
                                    ),
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10.0,
                                    ),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.lightBlue, width: 1),
                                        borderRadius: BorderRadius.all(Radius.circular(10))
                                    ),
                                  ),
                                  style: TextStyle(fontSize: 14.0),
                                  minLines: 2,
                                  maxLines: 5,
                                ),
                                SizedBox(height: 10.0,),
                                TextFormField(
                                  controller: controller.comportementRisqueObserveController,
                                  keyboardType: TextInputType.multiline,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    labelText: 'Comportement a risque observe',
                                    hintText: 'Comportement a risque observe',
                                    labelStyle: TextStyle(
                                      fontSize: 14.0,
                                    ),
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10.0,
                                    ),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.lightBlue, width: 1),
                                        borderRadius: BorderRadius.all(Radius.circular(10))
                                    ),
                                  ),
                                  style: TextStyle(fontSize: 14.0),
                                  minLines: 2,
                                  maxLines: 5,
                                ),
                                SizedBox(height: 10.0,),
                                TextFormField(
                                  controller: controller.correctionImmediateController,
                                  keyboardType: TextInputType.multiline,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    labelText: 'Corrections immédiates',
                                    hintText: 'Corrections immédiates',
                                    labelStyle: TextStyle(
                                      fontSize: 14.0,
                                    ),
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10.0,
                                    ),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.lightBlue, width: 1),
                                        borderRadius: BorderRadius.all(Radius.circular(10))
                                    ),
                                  ),
                                  style: TextStyle(fontSize: 14.0),
                                  minLines: 2,
                                  maxLines: 5,
                                ),
                              /*  SizedBox(height: 15.0,),
                                Visibility(
                                    visible: true,
                                    child: DropdownSearch<EmployeModel>(
                                      showSelectedItems: true,
                                      showClearButton: true,
                                      showSearchBox: true,
                                      isFilteredOnline: true,
                                      compareFn: (i, s) => i?.isEqual(s) ?? false,
                                      dropdownSearchDecoration: InputDecoration(
                                        labelText: "Employe",
                                        contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                        border: OutlineInputBorder(),
                                      ),
                                      onFind: (String? filter) => getEmploye(filter),
                                      onChanged: (data) {
                                        controller.employeModel = data;
                                        controller.listEquipe.add(controller.employeModel);
                                        print('employe : ${controller.employeModel?.nompre}, mat:${controller.employeModel?.mat}');

                                      },
                                      dropdownBuilder: customDropDownDetectedEmploye,
                                      popupItemBuilder: customPopupItemBuilderDetectedEmploye,
                                    )
                                ),
                                SizedBox(height: 5.0,),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Radio(value: 1,
                                          groupValue: controller.etat.value,
                                          onChanged: (value){
                                            controller.onChangeEtat(value);
                                          },
                                          activeColor: Colors.blue,
                                          fillColor: MaterialStateProperty.all(Colors.blue),),
                                        const Text("Responsable Audit", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),)
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Radio(value: 2,
                                          groupValue: controller.etat.value,
                                          onChanged: (value){
                                            controller.onChangeEtat(value);
                                          },
                                          activeColor: Colors.blue,
                                          fillColor: MaterialStateProperty.all(Colors.blue),),
                                        const Text("Auditeur", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),)
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Radio(value: 3,
                                          groupValue: controller.etat.value,
                                          onChanged: (value){
                                            controller.onChangeEtat(value);
                                          },
                                          activeColor: Colors.blue,
                                          fillColor: MaterialStateProperty.all(Colors.blue),),
                                        const Text("Observateur", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),)
                                      ],
                                    ),
                                  ],
                                ),
                                */
                                SizedBox(height: 15.0,),
                                Center(child: Text('Equipe Visite Securite',
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),),),

                                SizedBox(height: 10.0,),
                               GetBuilder<NewVisiteSecuriteController>(builder: (builderController){
                                 return SingleChildScrollView(
                                   scrollDirection: Axis.vertical,
                                   child: SingleChildScrollView(
                                     scrollDirection: Axis.horizontal,
                                     child: DataTable(
                                       sortAscending: true,
                                       sortColumnIndex: 1,
                                       columnSpacing: (MediaQuery.of(context).size.width / 10) * 0.2,
                                       dataRowHeight: 60,
                                       showBottomBorder: false,
                                       columns: [
                                         //DataColumn(label: Text('id', style: _contentStyleHeader), numeric: true),
                                         DataColumn(
                                             label: Text('Nom Prenom', style: _contentStyleHeader)),
                                         DataColumn(
                                             label: Text('Affectation', style: _contentStyleHeader)),
                                         DataColumn(
                                           label: InkWell(
                                             onTap: (){
                                               //Get.to(EquipeVisiteSecuritePage());
                                             },
                                             child: Icon(Icons.add, color: Colors.indigoAccent, size: 30,),
                                           ),)
                                       ],
                                       rows: controller.listEquipeVisiteSecurite==[] ?[] : getRows(controller.listEquipeVisiteSecurite),
                                       /* rows: controller.listEquipeVisiteSecurite.map<DataRow>((element) => DataRow(cells: [
                                          //DataCell(Text(element!.mat.toString(), style: _contentStyle, textAlign: TextAlign.right)),
                                          DataCell(Text('${element!.nompre}',
                                              style: _contentStyle, textAlign: TextAlign.right)),
                                          DataCell(Text('${element.affectation}',
                                              style: _contentStyle, textAlign: TextAlign.right)),
                                          DataCell(Text('')),
                                        ])).toList() */

                                     ),
                                   ),
                                 );
                               }),

                               /* SizedBox(height: 20.0,),
                                SingleChildScrollView(
                                  child: SizedBox(
                                    height: 200,
                                    child: ListView.builder(
                                        padding: const EdgeInsets.all(8),
                                        itemCount: controller.listEquipe.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return Text('${controller.listEquipe[index]?.nompre}');
                                        }
                                    ),
                                  ),
                                ), */

                                SizedBox(height: 20.0,),
                                ConstrainedBox(
                                  constraints: BoxConstraints.tightFor(width: 130, height: 50),
                                  child: ElevatedButton.icon(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                      ),
                                      backgroundColor:
                                      MaterialStateProperty.all(CustomColors.bleuCiel),
                                      padding: MaterialStateProperty.all(EdgeInsets.all(14)),
                                    ),
                                    icon: controller.isDataProcessing.value ? CircularProgressIndicator():Icon(Icons.save),
                                    label: Text(
                                      controller.isDataProcessing.value ? 'Processing' : 'Save',
                                      style: TextStyle(fontSize: 16, color: Colors.white),
                                    ),
                                    onPressed: () {
                                      controller.isDataProcessing.value ? null : controller.saveBtn();
                                    },
                                  ),
                                ),

                              ],
                            )
                        )
                    ),
                  ),
                );
              }
              else{
                return Center(
                  child: LoadingView(),
                );
              }
            }),
          )
      ),
    );
  }

  List<DataRow> getRows(List<EquipeVisiteSecuriteModel> listEquipeInfo) => listEquipeInfo.map((EquipeVisiteSecuriteModel model) {
    final affect = model.affectation;
    String message_affect = '';
    switch (affect) {
      case 1:
        message_affect = "Responsable Audit";
        break;
      case 2:
        message_affect = "Auditeur";
        break;
      case 3:
        message_affect = "Observateur";
        break;
      default:
        message_affect = "";
    }
    return DataRow(cells: [
      DataCell(Text('${model.nompre}', style: _contentStyle, textAlign: TextAlign.right)),
      DataCell(Text('$message_affect', style: _contentStyle, textAlign: TextAlign.right)),
      DataCell(
          InkWell(
              onTap: () async {
                int response = await controller.localVisiteSecuriteService.deleteEmployeOfEquipeVisiteSecurite(model.mat);

                controller.listEquipeVisiteSecurite.removeWhere((element) => element.mat == model.mat);
                /* if(response > 0){
                  //sites.removeWhere((element) => element['id'] == position);
                } */
              },
              child: Icon(Icons.delete, color: Colors.red,)
          )
      )
    ],
    );
  }).toList();

  //dropdown search
 //checklist
  Future<List<CheckListModel>> getCheckList(filter) async {
    try {
      List<CheckListModel> _checkList = await List<CheckListModel>.empty(growable: true);
      List<CheckListModel> _typeFilter = await List<CheckListModel>.empty(growable: true);
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        var response = await controller.localVisiteSecuriteService.readCheckList();
        response.forEach((data){
          var model = CheckListModel();
          model.idCheck = data['idCheck'];
          model.code = data['code'];
          model.checklist = data['checklist'];
          _checkList.add(model);
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        await VisiteSecuriteService().getCheckList().then((resp) async {
          resp.forEach((data) async {
            var model = CheckListModel();
            model.idCheck = data['id_Check'];
            model.code = data['code'];
            model.checklist = data['checklist'];
            _checkList.add(model);
          });
        }
            , onError: (err) {
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });
      }
      _typeFilter = _checkList.where((u) {
        var query = u.checklist!.toLowerCase();
        return query.contains(filter);
      }).toList();
      return _typeFilter;

    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }
  //unite
  Future<List<UniteModel>> getUnite(filter) async {
    try {
      List<UniteModel> _uniteList = await List<UniteModel>.empty(growable: true);
      List<UniteModel> _uniteFilter = await List<UniteModel>.empty(growable: true);
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        var response = await controller.localVisiteSecuriteService.readUniteVisiteSecurite();
        response.forEach((data){
          var model = UniteModel();
          model.idUnite = data['idUnite'];
          model.code = data['code'];
          model.unite = data['unite'];
          _uniteList.add(model);
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        await VisiteSecuriteService().getUniteVisiteSecurite().then((resp) async {
          resp.forEach((data) async {
            var model = UniteModel();
            model.idUnite = data['id_unite'];
            model.code = data['code'];
            model.unite = data['unite'];
            _uniteList.add(model);
          });
        }
            , onError: (err) {
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });
      }
      _uniteFilter = _uniteList.where((u) {
        var query = u.unite!.toLowerCase();
        return query.contains(filter);
      }).toList();
      return _uniteFilter;

    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }
  //zone
  Future<List<ZoneModel>> getZone(filter) async {
    try {
      if(controller.uniteModel == null){
        Get.snackbar("No Data", "Please select Unite", backgroundColor: Colors.white, colorText: Colors.blue, snackPosition: SnackPosition.BOTTOM);

      }
      List<ZoneModel> _zoneList = await List<ZoneModel>.empty(growable: true);
      List<ZoneModel> _zoneFilter = await List<ZoneModel>.empty(growable: true);
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        var response = await controller.localVisiteSecuriteService.readZoneByIdUnite(controller.selectedIdUnite);
        response.forEach((data){
          var model = ZoneModel();
          model.idZone = data['idZone'];
          model.zone = data['zone'];
          _zoneList.add(model);
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        await VisiteSecuriteService().getZoneByUnite(controller.selectedIdUnite).then((resp) async {
          resp.forEach((data) async {
            var model = ZoneModel();
            model.idZone = data['id_Zone'];
            model.zone = data['zone'];
            _zoneList.add(model);
          });
        }
            , onError: (err) {
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });
      }
      _zoneFilter = _zoneList.where((u) {
        var query = u.zone!.toLowerCase();
        return query.contains(filter);
      }).toList();
      return _zoneFilter;

    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }
  //Site
  Future<List<SiteModel>> getSite(filter) async {
    try {
      List<SiteModel> siteList = await List<SiteModel>.empty(growable: true);
      List<SiteModel> siteFilter = await <SiteModel>[];
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        var sites = await controller.localActionService.readSiteByModule("Action", "Action");
        sites.forEach((data){
          var model = SiteModel();
          model.codesite = data['codesite'];
          model.site = data['site'];
          siteList.add(model);
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        await ApiServicesCall().getSite({
          "mat": controller.matricule.toString(),
          "modul": "action",
          "site": "0",
          "agenda": 0,
          "fiche": "action"
        }).then((resp) async {
          resp.forEach((data) async {
            var model = SiteModel();
            model.codesite = data['codesite'];
            model.site = data['site'];
            siteList.add(model);
          });
        }
            , onError: (err) {
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });
      }
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

  //equipe visite securite
  Future<List<EmployeModel>> getEmploye(filter) async {
    try {
      List<EmployeModel> employeList = await List<EmployeModel>.empty(growable: true);
      List<EmployeModel>employeFilter = await List<EmployeModel>.empty(growable: true);
      var response = await controller.localActionService.readEmploye();
      response.forEach((data){
        var model = EmployeModel();
        model.mat = data['mat'];
        model.nompre = data['nompre'];
        employeList.add(model);
      });
      employeFilter = employeList.where((u) {
        var name = u.mat.toString().toLowerCase();
        var description = u.nompre!.toLowerCase();
        return name.contains(filter) ||
            description.contains(filter);
      }).toList();
      return employeFilter;
    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }
 /* Widget customDropDownDetectedEmploye(BuildContext context, EmployeModel? item) {

    if (item == null) {
      return Container();
    }
    else{
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${item?.nompre}', style: TextStyle(color: Colors.black)),
        ),
      );
    }
  }
  Widget customPopupItemBuilderDetectedEmploye(
      BuildContext context, EmployeModel? item, bool isSelected) {
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
        title: Text(item?.nompre ?? ''),
        subtitle: Text(item?.mat.toString() ?? ''),
      ),
    );
  } */
}