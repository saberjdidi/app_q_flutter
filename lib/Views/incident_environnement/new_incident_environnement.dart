import 'package:connectivity/connectivity.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:qualipro_flutter/Controllers/reunion/new_reunion_controller.dart';
import 'package:qualipro_flutter/Models/lieu_model.dart';
import 'package:qualipro_flutter/Models/reunion/type_reunion_model.dart';
import 'package:qualipro_flutter/Models/type_cause_model.dart';
import 'package:qualipro_flutter/Services/incident_environnement/incident_environnement_service.dart';
import '../../../Models/processus_model.dart';
import '../../../Services/api_services_call.dart';
import '../../../Utils/custom_colors.dart';
import '../../../Utils/snack_bar.dart';
import '../../../Validators/validator.dart';
import '../../Controllers/incident_environnement/new_incident_environnement_controller.dart';
import '../../Models/activity_model.dart';
import '../../Models/category_model.dart';
import '../../Models/direction_model.dart';
import '../../Models/employe_model.dart';
import '../../Models/gravite_model.dart';
import '../../Models/incident_environnement/cout_estime_inc_env_model.dart';
import '../../Models/incident_environnement/source_inc_env_model.dart';
import '../../Models/incident_environnement/type_cause_incident_model.dart';
import '../../Models/incident_environnement/type_consequence_incident_model.dart';
import '../../Models/pnc/isps_pnc_model.dart';
import '../../Models/secteur_model.dart';
import '../../Models/service_model.dart';
import '../../Models/site_model.dart';
import '../../Models/type_consequence_model.dart';
import '../../Models/type_incident_model.dart';
import '../../Services/reunion/reunion_service.dart';
import '../../Widgets/loading_widget.dart';

class NewIncidentEnvironnementPage extends GetView<NewIncidentEnvironnementController> {
  @override
  Widget build(BuildContext context) {

    final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
    final _filterEditTextController = TextEditingController();

    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        leading: RaisedButton(
          onPressed: (){
            Get.back();
            //controller.clearData();
          },
          elevation: 0.0,
          child: Icon(Icons.arrow_back, color: Colors.white,),
          color: Colors.blue,
        ),
        title: Center(
          child: Text("Ajouter Incident"),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Obx((){
              if(controller.isVisibleNewIncident.value == true){
                return Card(
                  child: SingleChildScrollView(
                    child: Form(
                        key: controller.addItemFormKey,
                        child: Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 10.0,),
                                TextFormField(
                                  controller: controller.designationController,
                                  keyboardType: TextInputType.multiline,
                                  textInputAction: TextInputAction.next,
                                  validator: (value) =>
                                  (controller.designation_incident_obligatoire.value==1 && controller.designationController=='') ? "Designation is required " : null,
                                  decoration: InputDecoration(
                                    labelText: 'Designation ${controller.designation_incident_obligatoire.value==1?'*':''}',
                                    hintText: 'designation',
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
                                Visibility(
                                    visible: controller.type_incident_visible == 1 ? controller.isVisibileTypeIncident=true : controller.isVisibileTypeIncident=false,
                                    child: DropdownSearch<TypeIncidentModel>(
                                      showSelectedItems: true,
                                      showClearButton: true,
                                      showSearchBox: true,
                                      isFilteredOnline: true,
                                      compareFn: (i, s) => i?.isEqual(s) ?? false,
                                      dropdownSearchDecoration: InputDecoration(
                                        labelText: "Type Incident ${controller.type_incident_obligatoire.value==1?'*':''}",
                                        contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                        border: OutlineInputBorder(),
                                      ),
                                      onFind: (String? filter) => getTypeIncident(filter),
                                      onChanged: (data) {
                                        controller.typeIncidentModel = data;
                                        controller.selectedCodeTypeIncident = data?.idType;
                                        controller.typeIncident = data?.typeIncident;
                                        if(controller.typeIncident == null){
                                          controller.selectedCodeTypeIncident = 0;
                                          controller.typeIncident = "";
                                        }
                                        print('type incident: ${controller.typeIncidentModel?.typeIncident}, code: ${controller.selectedCodeTypeIncident}');
                                      },
                                      dropdownBuilder: controller.customDropDownType,
                                      popupItemBuilder: controller.customPopupItemBuilderType,
                                      validator: (u) =>
                                      (controller.type_incident_obligatoire.value==1 && controller.typeIncidentModel==null) ? "Type incident is required " : null,
                                    )
                                ),
                                SizedBox(height: 10.0,),
                                Visibility(
                                    visible: true,
                                    child: DropdownSearch<CategoryModel>(
                                      showSelectedItems: true,
                                      showClearButton: true,
                                      showSearchBox: true,
                                      isFilteredOnline: true,
                                      compareFn: (i, s) => i?.isEqual(s) ?? false,
                                      dropdownSearchDecoration: InputDecoration(
                                        labelText: "Categorie Incident ${controller.category_obligatoire.value==1?'*':''}",
                                        contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                        border: OutlineInputBorder(),
                                      ),
                                      onFind: (String? filter) => getCategoryIncident(filter),
                                      onChanged: (data) {
                                        controller.categoryModel = data;
                                        controller.selectedCodeCategory = data?.idCategorie;
                                        controller.categoryIncident = data?.categorie;
                                        if(controller.categoryModel == null){
                                          controller.selectedCodeCategory = 0;
                                          controller.categoryIncident = "";
                                        }
                                        print('category incident: ${controller.categoryModel?.categorie}, code: ${controller.selectedCodeCategory}');
                                      },
                                      dropdownBuilder: controller.customDropDownCategory,
                                      popupItemBuilder: controller.customPopupItemBuilderCategory,
                                      validator: (u) =>
                                      (controller.category_obligatoire.value==1 && controller.categoryModel==null) ? "Category is required " : null,
                                    )
                                ),
                                SizedBox(height: 10.0,),
                                Visibility(
                                    visible: controller.lieu_visible == 1 ? controller.isVisibileLieu=true : controller.isVisibileLieu=false,
                                    child: DropdownSearch<LieuModel>(
                                      showSelectedItems: true,
                                      showClearButton: true,
                                      showSearchBox: true,
                                      isFilteredOnline: true,
                                      compareFn: (i, s) => i?.isEqual(s) ?? false,
                                      dropdownSearchDecoration: InputDecoration(
                                        labelText: "Lieu ${controller.lieu_obligatoire.value==1?'*':''}",
                                        contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                        border: OutlineInputBorder(),
                                      ),
                                      onFind: (String? filter) => getLieu(filter),
                                      onChanged: (data) {
                                        controller.lieuModel = data;
                                        controller.selectedCodeLieu = data?.code;
                                        controller.lieuIncident = data?.lieu;
                                        if(controller.lieuModel == null){
                                          controller.selectedCodeLieu = "";
                                          controller.lieuIncident = "";
                                        }
                                        print('lieu incident: ${controller.lieuModel?.lieu}, code: ${controller.selectedCodeLieu}');
                                      },
                                      dropdownBuilder: controller.customDropDownLieu,
                                      popupItemBuilder: controller.customPopupItemBuilderLieu,
                                      validator: (u) =>
                                      (controller.lieu_obligatoire.value==1 && controller.lieuModel==null) ? "Lieu is required " : null,
                                    )
                                ),
                                SizedBox(height: 10.0,),
                                Visibility(
                                  visible: true,
                                  child: TextFormField(
                                    controller: controller.dateIncidentController,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    validator: (value) =>
                                    (controller.date_incident_obligatoire.value==1 && controller.dateIncidentController=='') ? "Date is required " : null,
                                    onChanged: (value){
                                      controller.selectedDateIncident(context);
                                    },
                                    decoration: InputDecoration(
                                        labelText: 'Date Incident ${controller.date_incident_obligatoire.value==1?'*':''}',
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
                                            controller.selectedDateIncident(context);
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
                                  visible: controller.date_entre_visible == 1 ? controller.isVisibileDateEntre=true : controller.isVisibileDateEntre=false,
                                  child: TextFormField(
                                    controller: controller.dateEntreController,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    onChanged: (value){
                                      controller.selectedDateEntre(context);
                                    },
                                    decoration: InputDecoration(
                                        labelText: 'Date Entrée',
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
                                            controller.selectedDateEntre(context);
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
                                  visible: true,
                                  child: TextFormField(
                                    controller: controller.heureIncidentController,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    onChanged: (value){
                                      controller.selectedTimeDebut(context);
                                    },
                                    decoration: InputDecoration(
                                        labelText: 'Heure incident',
                                        hintText: 'time',
                                        labelStyle: TextStyle(
                                          fontSize: 14.0,
                                        ),
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 10.0,
                                        ),
                                        suffixIcon: InkWell(
                                          onTap: (){
                                            controller.selectedTimeDebut(context);
                                          },
                                          child: Icon(Icons.timer),
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
                                  visible: true,
                                  child: TextFormField(
                                    controller: controller.numInterneController,
                                    keyboardType: TextInputType.multiline,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                        labelText: 'N° interne ',
                                        hintText: 'N° interne',
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
                                        )
                                    ),
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                ),
                                SizedBox(height: 10.0,),
                                Visibility(
                                  visible: true,
                                  child: TextFormField(
                                    controller: controller.quantityRejController,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                        labelText: 'Quantité rejetée env',
                                        hintText: 'Quantité rejetée env',
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
                                        )
                                    ),
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                ),
                                SizedBox(height: 10.0,),
                                Visibility(
                                    visible: true,
                                    child: DropdownSearch<SecteurModel>(
                                      showSelectedItems: true,
                                      showClearButton: true,
                                      showSearchBox: true,
                                      isFilteredOnline: true,
                                      compareFn: (i, s) => i?.isEqual(s) ?? false,
                                      dropdownSearchDecoration: InputDecoration(
                                        labelText: "Secteur",
                                        contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                        border: OutlineInputBorder(),
                                      ),
                                      onFind: (String? filter) => getSecteur(filter),
                                      onChanged: (data) {
                                        controller.secteurModel = data;
                                        controller.selectedCodeSecteur = data?.codeSecteur;
                                        controller.secteurIncident = data?.secteur;
                                        if(controller.secteurModel == null){
                                          controller.selectedCodeSecteur = "";
                                          controller.secteurIncident = "";
                                        }
                                        print('secteur incident: ${controller.secteurModel?.secteur}, code: ${controller.selectedCodeSecteur}');
                                      },
                                      dropdownBuilder: controller.customDropDownSecteur,
                                      popupItemBuilder: controller.customPopupItemBuilderSecteur,
                                    )
                                ),
                                SizedBox(height: 10.0,),
                                Visibility(
                                    visible: controller.source_visible == 1 ? controller.isVisibileSource=true : controller.isVisibileSource=false,
                                    child: DropdownSearch<SourceIncidentEnvModel>(
                                      showSelectedItems: true,
                                      showClearButton: true,
                                      showSearchBox: true,
                                      isFilteredOnline: true,
                                      compareFn: (i, s) => i?.isEqual(s) ?? false,
                                      dropdownSearchDecoration: InputDecoration(
                                        labelText: "Source",
                                        contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                        border: OutlineInputBorder(),
                                      ),
                                      onFind: (String? filter) => getSource(filter),
                                      onChanged: (data) {
                                        controller.sourceModel = data;
                                        controller.selectedCodeSource = data?.idSource;
                                        controller.sourceIncident = data?.source;
                                        if(controller.sourceModel == null){
                                          controller.selectedCodeSource = 0;
                                          controller.sourceIncident = "";
                                        }
                                        print('source incident: ${controller.sourceModel?.source}, code: ${controller.selectedCodeSource}');
                                      },
                                      dropdownBuilder: controller.customDropDownSource,
                                      popupItemBuilder: controller.customPopupItemBuilderSource,
                                    )
                                ),
                                SizedBox(height: 10.0,),
                                Visibility(
                                    visible: true,
                                    child: DropdownSearch<GraviteModel>(
                                      showSelectedItems: true,
                                      showClearButton: true,
                                      showSearchBox: true,
                                      isFilteredOnline: true,
                                      compareFn: (i, s) => i?.isEqual(s) ?? false,
                                      dropdownSearchDecoration: InputDecoration(
                                        labelText: "Gravite ${controller.gravite_obligatoire.value==1?'*':''}",
                                        contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                        border: OutlineInputBorder(),
                                      ),
                                      onFind: (String? filter) => getGravite(filter),
                                      onChanged: (data) {
                                        controller.graviteModel = data;
                                        controller.selectedCodeGravite = data?.codegravite;
                                        controller.graviteIncident = data?.gravite;
                                        if(controller.graviteModel == null){
                                          controller.selectedCodeGravite = 0;
                                          controller.graviteIncident = "";
                                        }
                                        print('gravite incident: ${controller.graviteModel?.gravite}, code: ${controller.selectedCodeGravite}');
                                      },
                                      dropdownBuilder: controller.customDropDownGravite,
                                      popupItemBuilder: controller.customPopupItemBuilderGravite,
                                      validator: (u) =>
                                      (controller.gravite_obligatoire.value==1 && controller.graviteModel==null) ? "Gravite is required " : null,
                                    )
                                ),
                                SizedBox(height: 10.0,),
                                Visibility(
                                    visible: controller.cout_esteme_visible == 1 ? controller.isVisibileCoutEsteme=true : controller.isVisibileCoutEsteme=false,
                                    child: DropdownSearch<CoutEstimeIncidentEnvModel>(
                                      showSelectedItems: true,
                                      showClearButton: true,
                                      showSearchBox: true,
                                      isFilteredOnline: true,
                                      compareFn: (i, s) => i?.isEqual(s) ?? false,
                                      dropdownSearchDecoration: InputDecoration(
                                        labelText: "Cout estimé",
                                        contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                        border: OutlineInputBorder(),
                                      ),
                                      onFind: (String? filter) => getCoutEstime(filter),
                                      onChanged: (data) {
                                        controller.coutEstemeModel = data;
                                        controller.selectedCodeCoutEsteme = data?.idCout;
                                        controller.coutEstemeIncident = data?.cout;
                                        if(controller.coutEstemeModel == null){
                                          controller.selectedCodeCoutEsteme = 0;
                                          controller.coutEstemeIncident = "";
                                        }
                                        print('cout esteme incident: ${controller.coutEstemeModel?.cout}, code: ${controller.selectedCodeCoutEsteme}');
                                      },
                                      dropdownBuilder: controller.customDropDownCoutEsteme,
                                      popupItemBuilder: controller.customPopupItemBuilderCoutEsteme,
                                    )
                                ),
                                SizedBox(height: 10.0,),
                                Visibility(
                                    visible: true,
                                    child: DropdownSearch<EmployeModel>(
                                      showSelectedItems: true,
                                      showClearButton: true,
                                      showSearchBox: true,
                                      isFilteredOnline: true,
                                      compareFn: (i, s) => i?.isEqual(s) ?? false,
                                      dropdownSearchDecoration: InputDecoration(
                                        labelText: "Détectée par",
                                        contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                        border: OutlineInputBorder(),
                                      ),
                                      onFind: (String? filter) => getEmploye(filter),
                                      onChanged: (data) {
                                        controller.detectedEmployeModel = data;
                                        controller.detectedEmployeMatricule = data?.mat;
                                        if(controller.detectedEmployeModel == null){
                                          controller.detectedEmployeMatricule = "";
                                        }
                                        print('detected by : ${controller.detectedEmployeModel?.nompre}, mat:${controller.detectedEmployeMatricule}');
                                      },
                                      dropdownBuilder: controller.customDropDownDetectedEmploye,
                                      popupItemBuilder: controller.customPopupItemBuilderDetectedEmploye,
                                    )
                                ),
                                SizedBox(height: 10.0,),
                                Visibility(
                                    visible: controller.origine_employe_visible == 1 ? controller.isVisibileOrigineEmploye=true : controller.isVisibileOrigineEmploye=false,
                                    child: DropdownSearch<EmployeModel>(
                                        showSelectedItems: true,
                                        showClearButton: true,
                                        showSearchBox: true,
                                        isFilteredOnline: true,
                                        compareFn: (i, s) => i?.isEqual(s) ?? false,
                                        dropdownSearchDecoration: InputDecoration(
                                          labelText: "A l'origine",
                                          contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                          border: OutlineInputBorder(),
                                        ),
                                        onFind: (String? filter) => getEmploye(filter),
                                        onChanged: (data) {
                                          controller.employeModel = data;
                                          controller.origineEmployeMatricule = data?.mat;
                                          if(controller.employeModel == null){
                                            controller.origineEmployeMatricule = "";
                                          }
                                          print('origine de incident : ${controller.employeModel?.nompre}, mat:${controller.origineEmployeMatricule}');
                                        },
                                        dropdownBuilder: controller.customDropDownEmploye,
                                        popupItemBuilder: controller.customPopupItemBuilderEmploye,
                                        onBeforeChange: (a, b) {
                                          if (b == null) {
                                            AlertDialog alert = AlertDialog(
                                              title: Text("Are you sure..."),
                                              content: Text("...you want to clear the selection"),
                                              actions: [
                                                TextButton(
                                                  child: Text("OK"),
                                                  onPressed: () {
                                                    Navigator.of(context).pop(true);
                                                  },
                                                ),
                                                TextButton(
                                                  child: Text("Cancel"),
                                                  onPressed: () {
                                                    Navigator.of(context).pop(false);
                                                  },
                                                ),
                                              ],
                                            );
                                            return showDialog<bool>(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return alert;
                                                });
                                          }
                                          return Future.value(true);
                                        }
                                    )
                                ),
                                SizedBox(height: 10.0,),
                                Visibility(
                                    visible:controller.site_visible.value == 1 ? controller.isVisibileSite=true : controller.isVisibileSite=false,
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
                                        if(controller.siteModel == null){
                                          controller.selectedCodeSite = 0;
                                          controller.siteIncident = "";
                                        }
                                        print('site: ${controller.siteModel?.site}, code: ${controller.selectedCodeSite}');
                                      },
                                      dropdownBuilder: controller.customDropDownSite,
                                      popupItemBuilder: controller.customPopupItemBuilderSite,
                                      validator: (u) =>
                                      (controller.site_obligatoire.value==1 && controller.siteModel==null) ? "site is required " : null,
                                    )
                                ),
                                SizedBox(height: 10.0,),
                                Visibility(
                                    visible: controller.processus_visible.value == 1 ? controller.isVisibileProcessus=true : controller.isVisibileProcessus=false,
                                    child: DropdownSearch<ProcessusModel>(
                                      showSelectedItems: true,
                                      showClearButton: controller.processusModel?.processus=="" ? false : true,
                                      showSearchBox: true,
                                      isFilteredOnline: true,
                                      compareFn: (i, s) => i?.isEqual(s) ?? false,
                                      dropdownSearchDecoration: InputDecoration(
                                        labelText: "Processus ${controller.processus_obligatoire.value==1?'*':''}",
                                        contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                        border: OutlineInputBorder(),
                                      ),
                                      onFind: (String? filter) => getProcessus(filter),
                                      onChanged: (data) {
                                        controller.processusModel = data;
                                        controller.selectedCodeProcessus = data?.codeProcessus;
                                        controller.processusIncident = data?.processus;
                                        if(controller.processusModel == null){
                                          controller.selectedCodeProcessus = 0;
                                          controller.processusIncident = "";
                                        }
                                        print('processus: ${controller.processusModel?.processus}, code: ${controller.selectedCodeProcessus}');
                                      },
                                      dropdownBuilder: controller.customDropDownProcessus,
                                      popupItemBuilder: controller.customPopupItemBuilderProcessus,
                                      validator: (u) =>
                                      (controller.processus_obligatoire.value==1 && controller.processusModel==null) ? "processus is required " : null,

                                    )
                                ),
                                SizedBox(height: 10.0,),
                                Visibility(
                                    visible: controller.direction_visible.value == 1 ? controller.isVisibileDirection=true : controller.isVisibileDirection=false,
                                    child: DropdownSearch<DirectionModel>(
                                        showSelectedItems: true,
                                        showClearButton: controller.directionModel?.direction=="" ? false : true,
                                        showSearchBox: true,
                                        isFilteredOnline: true,
                                        compareFn: (i, s) => i?.isEqual(s) ?? false,
                                        dropdownSearchDecoration: InputDecoration(
                                          labelText: "Direction ${controller.direction_obligatoire.value==1?'*':''}",
                                          contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                          border: OutlineInputBorder(),
                                        ),
                                        onFind: (String? filter) => getDirection(filter),
                                        onChanged: (data) {
                                          controller.selectedCodeDirection = data?.codeDirection;
                                          controller.directionIncident = data?.direction;
                                          controller.directionModel = data;
                                          if(controller.directionModel == null){
                                            controller.selectedCodeDirection = 0;
                                            controller.directionIncident = "";
                                          }
                                          print('direction: ${controller.directionModel?.direction}, code: ${controller.selectedCodeDirection}');
                                        },
                                        dropdownBuilder: controller.customDropDownDirection,
                                        popupItemBuilder: controller.customPopupItemBuilderDirection,
                                        validator: (u) =>
                                        (controller.direction_obligatoire.value==1 && controller.directionModel==null) ? "direction is required " : null,
                                        onBeforeChange: (a, b) {
                                          if (b == null) {
                                            AlertDialog alert = AlertDialog(
                                              title: Text("Are you sure..."),
                                              content: Text("...you want to clear the selection"),
                                              actions: [
                                                TextButton(
                                                  child: Text("OK"),
                                                  onPressed: () {
                                                    Navigator.of(context).pop(true);
                                                  },
                                                ),
                                                TextButton(
                                                  child: Text("Cancel"),
                                                  onPressed: () {
                                                    Navigator.of(context).pop(false);
                                                  },
                                                ),
                                              ],
                                            );
                                            return showDialog<bool>(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return alert;
                                                });
                                          }
                                          return Future.value(true);
                                        }
                                    )
                                ),
                                SizedBox(height: 10.0,),
                                Visibility(
                                    visible: controller.service_visible.value == 1 ? controller.isVisibileService=true : controller.isVisibileService=false,
                                    child: DropdownSearch<ServiceModel>(
                                        showSelectedItems: true,
                                        showClearButton: controller.serviceModel?.service=="" ? false : true,
                                        showSearchBox: true,
                                        isFilteredOnline: true,
                                        compareFn: (i, s) => i?.isEqual(s) ?? false,
                                        dropdownSearchDecoration: InputDecoration(
                                          labelText: "Service ${controller.service_obligatoire.value==1?'*':''}",
                                          contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                          border: OutlineInputBorder(),
                                        ),
                                        onFind: (String? filter) => getService(filter),
                                        onChanged: (data) {
                                          controller.selectedCodeService = data?.codeService;
                                          controller.serviceIncident = data?.service;
                                          controller.serviceModel = data;
                                          if(controller.serviceModel == null){
                                            controller.selectedCodeService = 0;
                                            controller.serviceIncident = "";
                                          }
                                          print('service: ${controller.serviceModel?.service}, code: ${controller.selectedCodeService}');
                                        },
                                        dropdownBuilder: controller.customDropDownService,
                                        popupItemBuilder: controller.customPopupItemBuilderService,
                                        validator: (u) =>
                                        (controller.serviceModel==null && controller.service_obligatoire.value==1) ? "service is required " : null,
                                        //u == null ? "service is required " : null,
                                        onBeforeChange: (a, b) {
                                          if (b == null) {
                                            AlertDialog alert = AlertDialog(
                                              title: Text("Are you sure..."),
                                              content: Text("...you want to clear the selection"),
                                              actions: [
                                                TextButton(
                                                  child: Text("OK"),
                                                  onPressed: () {
                                                    Navigator.of(context).pop(true);
                                                  },
                                                ),
                                                TextButton(
                                                  child: Text("Cancel"),
                                                  onPressed: () {
                                                    Navigator.of(context).pop(false);
                                                  },
                                                ),
                                              ],
                                            );
                                            return showDialog<bool>(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return alert;
                                                });
                                          }
                                          return Future.value(true);
                                        }
                                    )
                                ),
                                SizedBox(height: 10.0,),
                                Visibility(
                                    visible: controller.activity_visible.value == 1 ? controller.isVisibileActivity=true : controller.isVisibileActivity=false,
                                    child: DropdownSearch<ActivityModel>(
                                        showSelectedItems: true,
                                        showClearButton: controller.activityModel?.domaine=="" ? false : true,
                                        showSearchBox: true,
                                        isFilteredOnline: true,
                                        mode: Mode.DIALOG,
                                        compareFn: (i, s) => i?.isEqual(s) ?? false,
                                        dropdownSearchDecoration: InputDecoration(
                                          labelText: "Activity ${controller.activity_obligatoire.value==1?'*':''}",
                                          contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                          border: OutlineInputBorder(),
                                        ),
                                        onFind: (String? filter) => getActivity(filter),
                                        onChanged: (data) {
                                          controller.selectedCodeActivity = data?.codeDomaine;
                                          controller.activityIncident = data?.domaine;
                                          controller.activityModel = data;
                                          if(controller.activityModel == null){
                                            controller.selectedCodeActivity = 0;
                                            controller.activityIncident = "";
                                          }
                                          print('activity:${controller.activityModel?.domaine}, code:${controller.selectedCodeActivity}');
                                        },
                                        dropdownBuilder: controller.customDropDownActivity,
                                        popupItemBuilder: controller.customPopupItemBuilderActivity,
                                        validator: (u) =>
                                        (controller.activity_obligatoire.value==1 && controller.activityModel==null) ? "activity is required " : null,
                                        onBeforeChange: (a, b) {
                                          if (b == null) {
                                            AlertDialog alert = AlertDialog(
                                              title: Text("Are you sure..."),
                                              content: Text("...you want to clear the selection"),
                                              actions: [
                                                TextButton(
                                                  child: Text("OK"),
                                                  onPressed: () {
                                                    controller.selectedCodeActivity = 0;
                                                    Navigator.of(context).pop(true);
                                                  },
                                                ),
                                                TextButton(
                                                  child: Text("Cancel"),
                                                  onPressed: () {
                                                    Navigator.of(context).pop(false);
                                                  },
                                                ),
                                              ],
                                            );
                                            return showDialog<bool>(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return alert;
                                                });
                                          }
                                          return Future.value(true);
                                        }
                                    )
                                ),

                                SizedBox(height: 10.0,),
                                Visibility(
                                  visible: true,
                                  child: DropdownSearch<TypeCauseIncidentModel>.multiSelection(
                                    searchFieldProps: TextFieldProps(
                                      controller: _filterEditTextController,
                                      decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                          icon: Icon(Icons.clear),
                                          onPressed: () {
                                            _filterEditTextController.clear();
                                          },
                                        ),
                                      ),
                                    ),
                                    mode: Mode.DIALOG,
                                    isFilteredOnline: true,
                                    showClearButton: false,
                                    showSelectedItems: true,
                                    compareFn: (item, selectedItem) => item?.idTypeCause == selectedItem?.idTypeCause,
                                    showSearchBox: true,
                                    /* dropdownSearchDecoration: InputDecoration(
                                    labelText: 'User *',
                                    filled: true,
                                    fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                                  ), */
                                    dropdownSearchDecoration: InputDecoration(
                                      labelText: "Type Cause ${controller.type_cause_obligatoire.value==1?'*':''}",
                                      contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                      border: OutlineInputBorder(),
                                    ),
                                    autoValidateMode: AutovalidateMode.onUserInteraction,
                                    /* validator: (u) =>
                                  u == null || u.isEmpty ? "user field is required " : null, */
                                    onFind: (String? filter) => getTypeCause(filter),
                                    onChanged: (data) {
                                      //print(data);
                                      controller.typeCauseList.clear();
                                      controller.listTypeCauseIncident.clear();
                                      controller.listTypeCauseIncident.addAll(data);
                                      data.forEach((element) {
                                        print('type cause: ${element.typeCause}, code: ${element.idTypeCause}');
                                        List<int> listIdTypeCause = [];
                                        listIdTypeCause.add(element.idTypeCause!);
                                        controller.typeCauseList.addAll(listIdTypeCause);
                                        //print('product list : ${listCodeProduct}');
                                      });
                                    },
                                    dropdownBuilder: controller.customDropDownMultiSelectionTypeCause,
                                    popupItemBuilder: controller.customPopupItemBuilderTypeCause,
                                    popupSafeArea: PopupSafeAreaProps(top: true, bottom: true),
                                    scrollbarProps: ScrollbarProps(
                                      isAlwaysShown: true,
                                      thickness: 7,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.0,),
                                Visibility(
                                  visible: true,
                                  child: DropdownSearch<TypeConsequenceIncidentModel>.multiSelection(
                                    searchFieldProps: TextFieldProps(
                                      controller: _filterEditTextController,
                                      decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                          icon: Icon(Icons.clear),
                                          onPressed: () {
                                            _filterEditTextController.clear();
                                          },
                                        ),
                                      ),
                                    ),
                                    mode: Mode.DIALOG,
                                    isFilteredOnline: true,
                                    showClearButton: false,
                                    showSelectedItems: true,
                                    compareFn: (item, selectedItem) => item?.idConsequence == selectedItem?.idConsequence,
                                    showSearchBox: true,
                                    /* dropdownSearchDecoration: InputDecoration(
                                    labelText: 'User *',
                                    filled: true,
                                    fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                                  ), */
                                    dropdownSearchDecoration: InputDecoration(
                                      labelText: "Type Consequence ${controller.type_consequence_obligatoire.value==1?'*':''}",
                                      contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                      border: OutlineInputBorder(),
                                    ),
                                    autoValidateMode: AutovalidateMode.onUserInteraction,
                                    /* validator: (u) =>
                                  u == null || u.isEmpty ? "user field is required " : null, */
                                    onFind: (String? filter) => getTypeConsequence(filter),
                                    onChanged: (data) {
                                      print(data);
                                      controller.typeConsequenceList.clear();
                                      controller.listTypeConsequenceIncident.clear();
                                      controller.listTypeConsequenceIncident.addAll(data);
                                      data.forEach((element) {
                                        print('type consequence: ${element.typeConsequence}, code: ${element.idConsequence}');
                                        List<int> listIdConsequence = [];
                                        listIdConsequence.add(element.idConsequence!);
                                        controller.typeConsequenceList.addAll(listIdConsequence);
                                        //print('product list : ${listCodeProduct}');
                                      });
                                    },
                                    dropdownBuilder: controller.customDropDownMultiSelectionTypeConsequence,
                                    popupItemBuilder: controller.customPopupItemBuilderTypeConsequence,
                                    popupSafeArea: PopupSafeAreaProps(top: true, bottom: true),
                                    scrollbarProps: ScrollbarProps(
                                      isAlwaysShown: true,
                                      thickness: 7,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.0,),
                                //Spacer(flex: 1,),
                                Visibility(
                                    visible: controller.isps_visible == 1 ? controller.isVisibileISPS=true : controller.isVisibileISPS=false,
                                    child: DropdownSearch<ISPSPNCModel>(
                                      showSelectedItems: true,
                                      showClearButton: true,
                                      showSearchBox: false,
                                      isFilteredOnline: true,
                                      mode: Mode.DIALOG,
                                      compareFn: (i, s) => i?.isEqual(s) ?? false,
                                      dropdownSearchDecoration: InputDecoration(
                                        labelText: "ISPS",
                                        contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                        border: OutlineInputBorder(),
                                      ),
                                      onFind: (String? filter) => getISPS(filter),
                                      onChanged: (data) {
                                        controller.isps = data?.value;
                                        print('isps value :${controller.isps}');
                                      },
                                      dropdownBuilder: _customDropDownISPS,
                                      popupItemBuilder: _customPopupItemBuilderISPS,

                                    )
                                ),
                                SizedBox(height: 10.0,),
                                TextFormField(
                                  controller: controller.descriptionIncidentController,
                                  keyboardType: TextInputType.multiline,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    labelText: 'Description incident ${controller.description_incident_obligatoire.value==1?'*':''}',
                                    hintText: 'Description incident',
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
                                  validator: (value) =>
                                  (controller.description_incident_obligatoire.value==1 && controller.descriptionIncidentController=='') ? "Description incident is required " : null,
                                  style: TextStyle(fontSize: 14.0),
                                  minLines: 2,
                                  maxLines: 5,
                                ),
                                SizedBox(height: 10.0,),
                                TextFormField(
                                  controller: controller.descriptionCauseController,
                                  keyboardType: TextInputType.multiline,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    labelText: 'Description Cause ${controller.description_cause_obligatoire.value==1?'*':''}',
                                    hintText: 'Description cause',
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
                                  validator: (value) =>
                                  (controller.description_cause_obligatoire.value==1 && controller.descriptionCauseController=='') ? "Description Cause is required " : null,
                                  style: TextStyle(fontSize: 14.0),
                                  minLines: 2,
                                  maxLines: 5,
                                ),
                                SizedBox(height: 10.0,),
                                TextFormField(
                                  controller: controller.descriptionConsequenceController,
                                  keyboardType: TextInputType.multiline,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    labelText: 'Description Consequence',
                                    hintText: 'Description consequence',
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
                                  controller: controller.actionImmediateController,
                                  keyboardType: TextInputType.multiline,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    labelText: 'Actions immédiates ${controller.action_immediate_obligatoire.value==1?'*':''}',
                                    hintText: 'Actions immédiates',
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
                                  validator: (value) =>
                                    (controller.action_immediate_obligatoire.value==1 && controller.actionImmediateController=='') ? "Actions immediates is required " : null,
                                  style: TextStyle(fontSize: 14.0),
                                  minLines: 2,
                                  maxLines: 5,
                                ),

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
                                      MaterialStateProperty.all(CustomColors.googleBackground),
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

  //dropdown search
 //type incident
  Future<List<TypeIncidentModel>> getTypeIncident(filter) async {
    try {
      List<TypeIncidentModel> _typeList = await List<TypeIncidentModel>.empty(growable: true);
      List<TypeIncidentModel> _typeFilter = await List<TypeIncidentModel>.empty(growable: true);
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        var response = await controller.localIncidentEnvironnementService.readTypeIncidentEnv();
        response.forEach((data){
          var model = TypeIncidentModel();
          model.idType = data['idType'];
          model.typeIncident = data['typeIncident'];
          _typeList.add(model);
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        await IncidentEnvironnementService().getTypeIncidentEnv().then((resp) async {
          resp.forEach((data) async {
            var model = TypeIncidentModel();
            model.idType = data['idType'];
            model.typeIncident = data['type_Incident_Env'];
            _typeList.add(model);
          });
        }
            , onError: (err) {
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });
      }
      _typeFilter = _typeList.where((u) {
        var query = u.typeIncident!.toLowerCase();
        return query.contains(filter);
      }).toList();
      return _typeFilter;

    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }
  //category incident
  Future<List<CategoryModel>> getCategoryIncident(filter) async {
    try {
      List<CategoryModel> _categoryList = await List<CategoryModel>.empty(growable: true);
      List<CategoryModel> _categoryFilter = await List<CategoryModel>.empty(growable: true);
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        var response = await controller.localIncidentEnvironnementService.readCategoryIncidentEnv();
        response.forEach((data){
          var model = CategoryModel();
          model.idCategorie = data['idCategorie'];
          model.categorie = data['categorie'];
          _categoryList.add(model);
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        await IncidentEnvironnementService().getCategoryIncidentEnv().then((resp) async {
          resp.forEach((data) async {
            var model = CategoryModel();
            model.idCategorie = data['idCategorie'];
            model.categorie = data['categorie'];
            _categoryList.add(model);
          });
        }
            , onError: (err) {
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });
      }
      _categoryFilter = _categoryList.where((u) {
        var query = u.categorie!.toLowerCase();
        return query.contains(filter);
      }).toList();
      return _categoryFilter;

    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }
  //lieu incident
  Future<List<LieuModel>> getLieu(filter) async {
    try {
      List<LieuModel> _lieuList = await List<LieuModel>.empty(growable: true);
      List<LieuModel> _lieuFilter = await List<LieuModel>.empty(growable: true);
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        var response = await controller.localIncidentEnvironnementService.readLieuIncidentEnv();
        response.forEach((data){
          var model = LieuModel();
          model.code = data['code'];
          model.lieu = data['lieu'];
          _lieuList.add(model);
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        await IncidentEnvironnementService().getLieuIncidentEnv(controller.matricule).then((resp) async {
          resp.forEach((data) async {
            var model = LieuModel();
            model.code = data['code'];
            model.lieu = data['lieu'];
            _lieuList.add(model);
          });
        }
            , onError: (err) {
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });
      }
      _lieuFilter = _lieuList.where((u) {
        var query = u.lieu!.toLowerCase();
        return query.contains(filter);
      }).toList();
      return _lieuFilter;

    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }
  //secteur incident
  Future<List<SecteurModel>> getSecteur(filter) async {
    try {
      List<SecteurModel> _secteurList = await List<SecteurModel>.empty(growable: true);
      List<SecteurModel> _secteurFilter = await List<SecteurModel>.empty(growable: true);
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        var response = await controller.localIncidentEnvironnementService.readSecteurIncidentEnv();
        response.forEach((data){
          var model = SecteurModel();
          model.codeSecteur = data['codeSecteur'];
          model.secteur = data['secteur'];
          _secteurList.add(model);
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        await IncidentEnvironnementService().getSecteurIncidentEnv().then((resp) async {
          resp.forEach((data) async {
            var model = SecteurModel();
            model.codeSecteur = data['code'];
            model.secteur = data['secteur'];
            _secteurList.add(model);
          });
        }
            , onError: (err) {
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });
      }
      _secteurFilter = _secteurList.where((u) {
        var query = u.secteur!.toLowerCase();
        return query.contains(filter);
      }).toList();
      return _secteurFilter;

    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }
  //source incident
  Future<List<SourceIncidentEnvModel>> getSource(filter) async {
    try {
      List<SourceIncidentEnvModel> _sourceList = await List<SourceIncidentEnvModel>.empty(growable: true);
      List<SourceIncidentEnvModel> _sourceFilter = await List<SourceIncidentEnvModel>.empty(growable: true);
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        var response = await controller.localIncidentEnvironnementService.readSourceIncidentEnv();
        response.forEach((data){
          var model = SourceIncidentEnvModel();
          model.idSource = data['idSource'];
          model.source = data['source'];
          _sourceList.add(model);
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        await IncidentEnvironnementService().getSourceIncidentEnv().then((resp) async {
          resp.forEach((data) async {
            var model = SourceIncidentEnvModel();
            model.idSource = data['id_Source'];
            model.source = data['source'];
            _sourceList.add(model);
          });
        }
            , onError: (err) {
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });
      }
      _sourceFilter = _sourceList.where((u) {
        var query = u.source!.toLowerCase();
        return query.contains(filter);
      }).toList();
      return _sourceFilter;

    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }
  //gravite incident
  Future<List<GraviteModel>> getGravite(filter) async {
    try {
      List<GraviteModel> _graviteList = await List<GraviteModel>.empty(growable: true);
      List<GraviteModel> _graviteFilter = await List<GraviteModel>.empty(growable: true);
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        var response = await controller.localIncidentEnvironnementService.readGraviteIncidentEnv();
        response.forEach((data){
          var model = GraviteModel();
          model.codegravite = data['codegravite'];
          model.gravite = data['gravite'];
          _graviteList.add(model);
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        await IncidentEnvironnementService().getGraviteIncidentEnv().then((resp) async {
          resp.forEach((data) async {
            var model = GraviteModel();
            model.codegravite = data['code'];
            model.gravite = data['gravite'];
            _graviteList.add(model);
          });
        }
            , onError: (err) {
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });
      }
      _graviteFilter = _graviteList.where((u) {
        var query = u.gravite!.toLowerCase();
        return query.contains(filter);
      }).toList();
      return _graviteFilter;

    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }
  //cout estime incident
  Future<List<CoutEstimeIncidentEnvModel>> getCoutEstime(filter) async {
    try {
      List<CoutEstimeIncidentEnvModel> _coutList = await List<CoutEstimeIncidentEnvModel>.empty(growable: true);
      List<CoutEstimeIncidentEnvModel> _coutFilter = await List<CoutEstimeIncidentEnvModel>.empty(growable: true);
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        var response = await controller.localIncidentEnvironnementService.readCoutEstimeIncidentEnv();
        response.forEach((data){
          var model = CoutEstimeIncidentEnvModel();
          model.idCout = data['idCout'];
          model.cout = data['cout'];
          _coutList.add(model);
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        await IncidentEnvironnementService().getCoutEstimeIncidentEnv().then((resp) async {
          resp.forEach((data) async {
            var model = CoutEstimeIncidentEnvModel();
            model.idCout = data['id_cout'];
            model.cout = data['cout'];
            _coutList.add(model);
          });
        }
            , onError: (err) {
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });
      }
      _coutFilter = _coutList.where((u) {
        var query = u.cout!.toLowerCase();
        return query.contains(filter);
      }).toList();
      return _coutFilter;

    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }
  //type cause
  Future<List<TypeCauseIncidentModel>> getTypeCause(filter) async {
    try {
      List<TypeCauseIncidentModel> _typeList = await List<TypeCauseIncidentModel>.empty(growable: true);
      List<TypeCauseIncidentModel> _typeFilter = await List<TypeCauseIncidentModel>.empty(growable: true);
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        var response = await controller.localIncidentEnvironnementService.readTypeCauseIncidentEnv();
        response.forEach((data){
          var model = TypeCauseIncidentModel();
          model.idTypeCause = data['idTypeCause'];
          model.typeCause = data['typeCause'];
          _typeList.add(model);
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        await IncidentEnvironnementService().getTypeCauseIncidentEnv().then((resp) async {
          resp.forEach((data) async {
            var model = TypeCauseIncidentModel();
            model.idTypeCause = data['idTypeCause'];
            model.typeCause = data['typeCause'];
            _typeList.add(model);
          });
        }
            , onError: (err) {
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });
      }
      _typeFilter = _typeList.where((u) {
        var query = u.typeCause!.toLowerCase();
        return query.contains(filter);
      }).toList();
      return _typeFilter;

    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }
  //type consequence
  Future<List<TypeConsequenceIncidentModel>> getTypeConsequence(filter) async {
    try {
      List<TypeConsequenceIncidentModel> _typeList = await List<TypeConsequenceIncidentModel>.empty(growable: true);
      List<TypeConsequenceIncidentModel> _typeFilter = await List<TypeConsequenceIncidentModel>.empty(growable: true);
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        var response = await controller.localIncidentEnvironnementService.readTypeConsequenceIncidentEnv();
        response.forEach((data){
          var model = TypeConsequenceIncidentModel();
          model.idConsequence = data['idTypeConseq'];
          model.typeConsequence = data['typeConseq'];
          _typeList.add(model);
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        await IncidentEnvironnementService().getTypeConsequenceIncidentEnv().then((resp) async {
          resp.forEach((data) async {
            var model = TypeConsequenceIncidentModel();
            model.idConsequence = data['idTypeConseq'];
            model.typeConsequence = data['typeConseq'];
            _typeList.add(model);
          });
        }
            , onError: (err) {
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });
      }
      _typeFilter = _typeList.where((u) {
        var query = u.typeConsequence!.toLowerCase();
        return query.contains(filter);
      }).toList();
      return _typeFilter;

    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }
  //Employe
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
  //Site
  Future<List<SiteModel>> getSite(filter) async {
    try {
      List<SiteModel> siteList = await List<SiteModel>.empty(growable: true);
      List<SiteModel> siteFilter = await <SiteModel>[];
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        var sites = await controller.localActionService.readSiteByModule("Environnement", "Incident");
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
          "modul": "Environnement",
          "site": "0",
          "agenda": 0,
          "fiche": "Incident"
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
  //Processus
  Future<List<ProcessusModel>> getProcessus(filter) async {
    try {
      List<ProcessusModel> processusList = await List<ProcessusModel>.empty(growable: true);
      List<ProcessusModel> processusFilter = await <ProcessusModel>[];
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        var sites = await controller.localActionService.readProcessusByModule("Environnement", "Incident");
        sites.forEach((data){
          var model = ProcessusModel();
          model.codeProcessus = data['codeProcessus'];
          model.processus = data['processus'];
          processusList.add(model);
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        await ApiServicesCall().getProcessus({
          "mat": controller.matricule.toString(),
          "modul": "Environnement",
          "processus": "0",
          "fiche": "Incident"
        }).then((resp) async {
          resp.forEach((data) async {
            //print('get processus : ${data} ');
            var model = ProcessusModel();
            model.codeProcessus = data['codeProcessus'];
            model.processus = data['processus'];
            processusList.add(model);
          });
        }
            , onError: (err) {
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });
      }
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
  //Direction
  Future<List<DirectionModel>> getDirection(filter) async {
    try {
      List<DirectionModel> directionList = await List<DirectionModel>.empty(growable: true);
      List<DirectionModel> directionFilter = await <DirectionModel>[];
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        var response = await controller.localActionService.readDirectionByModule("Environnement", "Incident");
        response.forEach((data){
          var model = DirectionModel();
          model.codeDirection = data['codeDirection'];
          model.direction = data['direction'];
          directionList.add(model);
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        await ApiServicesCall().getDirection({
          "mat": controller.matricule.toString(),
          "modul": "Environnement",
          "fiche": "Incident",
          "direction": 0
        }).then((resp) async {
          resp.forEach((data) async {
            //print('get direction : ${data} ');
            var model = DirectionModel();
            model.codeDirection = data['code_direction'];
            model.direction = data['direction'];
            directionList.add(model);
          });
        }
            , onError: (err) {
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });
      }
      directionFilter = directionList.where((u) {
        var name = u.codeDirection.toString().toLowerCase();
        var description = u.direction!.toLowerCase();
        return name.contains(filter) ||
            description.contains(filter);
      }).toList();
      return directionFilter;
    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }
  //Service
  Future<List<ServiceModel>> getService(filter) async {
    if(controller.directionModel == null){
      Get.snackbar("No Data", "Please select Direction", colorText: Colors.blue, snackPosition: SnackPosition.BOTTOM);
    }
    try {

      List<ServiceModel> serviceList = await List<ServiceModel>.empty(growable: true);
      List<ServiceModel> serviceFilter = await List<ServiceModel>.empty(growable: true);

      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        var response = await controller.localActionService.readServiceByModuleAndDirection('Environnement', 'Incident', controller.selectedCodeDirection);
        print('response service : $response');
        response.forEach((data){
          var model = ServiceModel();
          model.codeService = data['codeService'];
          model.service = data['service'];
          model.codeDirection = data['codeDirection'];
          model.direction = data['direction'];
          serviceList.add(model);
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        await ApiServicesCall().getService(controller.matricule, controller.selectedCodeDirection, 'Environnement', 'Incident').then((resp) async {
          resp.forEach((data) async {
            print('get service : ${data} ');
            var model = ServiceModel();
            model.codeService = data['codeService'];
            model.service = data['service'];
            model.codeDirection = data['idDirection'];
            model.module = data['module'];
            model.fiche = data['fiche'];
            serviceList.add(model);
          });
        }
            , onError: (err) {
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });
      }
      serviceFilter = await serviceList.where((u) {
        serviceFilter = List<ServiceModel>.empty(growable: true);
        var query = u.service!.toLowerCase();
        return query.contains(filter);
      }).toList();
      return serviceFilter;
      /* return serviceList.where((element) {
        final query = element.service!.toLowerCase();
        return query.contains(filter);
      }).toList();*/
    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }
  //Activity
  Future<List<ActivityModel>> getActivity(filter) async {
    try {
      List<ActivityModel> activityList = await List<ActivityModel>.empty(growable: true);
      List<ActivityModel> activityFilter = await <ActivityModel>[];
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        var response = await controller.localActionService.readActivityByModule("Environnement", "Incident");
        response.forEach((data){
          var model = ActivityModel();
          model.codeDomaine = data['codeDomaine'];
          model.domaine = data['domaine'];
          activityList.add(model);
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        await ApiServicesCall().getActivity({
          "mat": controller.matricule.toString(),
          "modul": "Environnement",
          "fiche": "Incident",
          "domaine": ""
        }).then((resp) async {
          resp.forEach((data) async {
            //print('get activity : ${data} ');
            var model = ActivityModel();
            model.codeDomaine = data['code_domaine'];
            model.domaine = data['domaine'];
            activityList.add(model);
          });
        }
            , onError: (err) {
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });
      }
      activityFilter = activityList.where((u) {
        var name = u.codeDomaine.toString().toLowerCase();
        var description = u.domaine!.toLowerCase();
        return name.contains(filter) ||
            description.contains(filter);
      }).toList();
      return activityFilter;
    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }
  //ISPS
  Future<List<ISPSPNCModel>> getISPS(filter) async {
    try {
      List<ISPSPNCModel> ispsList = [
        ISPSPNCModel(value: "0", name: ""),
        ISPSPNCModel(value: "1", name: "OUI"),
        ISPSPNCModel(value: "2", name: "NON"),
        ISPSPNCModel(value: "3", name: "Non applicable"),
      ];

      return ispsList;
    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }
  //ISPS
  Widget _customDropDownISPS(BuildContext context, ISPSPNCModel? item) {
    if (item == null) {
      return Container();
    }
    return Container(
      child: (item.name == null)
          ? ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text("No item selected"),
      )
          : ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text('${item.name}'),
      ),
    );
  }
  Widget _customPopupItemBuilderISPS(
      BuildContext context, ISPSPNCModel? item, bool isSelected) {
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
        title: Text(item?.name ?? ''),
        //subtitle: Text(item?.value.toString() ?? ''),
      ),
    );
  }
}