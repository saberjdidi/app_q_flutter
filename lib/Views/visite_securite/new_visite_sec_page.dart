import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qualipro_flutter/Models/visite_securite/visite_securite_model.dart';
import 'package:qualipro_flutter/Views/visite_securite/visite_securite_page.dart';
import '../../../Models/employe_model.dart';
import '../../../Services/action/local_action_service.dart';
import '../../../Utils/custom_colors.dart';
import '../../../Utils/message.dart';
import '../../../Utils/shared_preference.dart';
import '../../../Utils/snack_bar.dart';
import '../../Controllers/visite_securite/visite_securite_controller.dart';
import '../../Models/champ_cache_model.dart';
import '../../Models/incident_securite/champ_obligatore_incident_securite_model.dart';
import '../../Models/site_model.dart';
import '../../Models/visite_securite/checklist_model.dart';
import '../../Models/visite_securite/equipe_model.dart';
import '../../Models/visite_securite/equipe_visite_securite_model.dart';
import '../../Models/visite_securite/unite_model.dart';
import '../../Models/visite_securite/zone_model.dart';
import '../../Services/api_services_call.dart';
import '../../Services/incident_securite/incident_securite_service.dart';
import '../../Services/incident_securite/local_incident_securite_service.dart';
import '../../Services/visite_securite/local_visite_securite_service.dart';
import '../../Services/visite_securite/visite_securite_service.dart';

class NewVisiteSecuPage extends StatefulWidget {

  NewVisiteSecuPage({Key? key}) : super(key: key);

  @override
  State<NewVisiteSecuPage> createState() => _NewVisiteSecuPageState();
}

class _NewVisiteSecuPageState extends State<NewVisiteSecuPage> {
  final _addItemFormKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  bool _isProcessing = false;
  final matricule = SharedPreference.getMatricule();
  LocalVisiteSecuriteService localVisiteSecuriteService = LocalVisiteSecuriteService();
  LocalActionService localActionService = LocalActionService();

  DateTime datePickerVisite = DateTime.now();
  TextEditingController  dateVisiteController = TextEditingController();
  TextEditingController  situationObserveController = TextEditingController();
  TextEditingController  comportementSurObserveController = TextEditingController();
  TextEditingController  comportementRisqueObserveController = TextEditingController();
  TextEditingController  correctionImmediateController = TextEditingController();
  TextEditingController autreSujectController = TextEditingController();

  //CheckList
  CheckListModel? checkListModel = null;
  int? selectedIdCheckList = 0;
  String? checkList = "";
  //site
  int? site_visible = 1;
  int? site_obligatoire = 1;
  SiteModel? siteModel = null;
  int? selectedCodeSite = 0;
  String? site = "";
  //unite
  UniteModel? uniteModel = null;
  int? selectedIdUnite = 0;
  String? unite = "";
  //zone
  ZoneModel? zoneModel = null;
  int? selectedIdZone = 0;
  String? zone = "";
  //equipe
  List<EquipeVisiteSecuriteModel> listEquipeVisiteSecurite = List<EquipeVisiteSecuriteModel>.empty(growable: true);
  List<EquipeModel> listEquipeSave = List<EquipeModel>.empty(growable: true);
  EmployeModel? employeModel = null;

  //resp traitement
  final _contentStyleHeader = const TextStyle(
      color: Color(0xff060f7d), fontSize: 14, fontWeight: FontWeight.w700);
  final _contentStyle = const TextStyle(
      color: Color(0xff0c2d5e), fontSize: 14, fontWeight: FontWeight.normal);


  @override
  void initState(){
    super.initState();
    dateVisiteController.text = DateFormat('dd/MM/yyyy').format(datePickerVisite);
    getChampVisible();
    getChampObligatoire();
    getEquipeVisiteSecurite();
  }

  //champ visible
  getChampVisible() async {
    try {
      List<ChampCacheModel> listChampCache = await List<ChampCacheModel>.empty(
          growable: true);
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        var response = await localActionService.readChampCacheByModule(
            "Sécurité\\Maîtrise des risques", "Fiche visite sécurité");
        response.forEach((data) {
          setState(() {
            var model = ChampCacheModel();
            model.id = data['id'];
            model.module = data['module'];
            model.fiche = data['fiche'];
            model.listOrder = data['listOrder'];
            model.nomParam = data['nomParam'];
            model.visible = data['visible'];
            print('module : ${model.module}, nom_param:${model.nomParam}, visible:${model.visible}');
            listChampCache.add(model);

            if (model.nomParam == "Site" && model.module == "Sécurité\\Maîtrise des risques" && model.fiche == "Fiche visite sécurité") {
              site_visible = model.visible;
              print('site visible : $site_visible');
            }
          });

        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        await ApiServicesCall().getChampCache({
          "module": "Sécurité\\Maîtrise des risques",
          "fiche": "Fiche visite sécurité"
        }).then((resp) async {
          resp.forEach((data) async {
            //print('get champ obligatoire : ${data} ');
            setState(() {
              var model = ChampCacheModel();
              model.id = data['id'];
              model.module = data['module'];
              model.fiche = data['fiche'];
              model.listOrder = data['list_order'];
              model.nomParam = data['nom_param'];
              model.visible = data['visible'];
              print('module : ${model.module}, nom_param:${model.nomParam}, visible:${model.visible}');
              listChampCache.add(model);

              if (model.nomParam == "Site" && model.module == "Sécurité\\Maîtrise des risques" && model.fiche == "Fiche visite sécurité") {
                site_visible = model.visible;
                print('site visible : $site_visible');
              }
            });

          });
        }
            , onError: (err) {
              print('error : ${err.toString()}');
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });
      }
    }
    catch (exception) {
      print('exception : ${exception.toString()}');
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    }
  }
  //champ obligatoire
  int date_visite_obligatoire = 0;
  int comportement_sur_observe_obligatoire = 0;
  int comportement_risque_observe_obligatoire = 0;
  int correction_immediate_obligatoire = 0;
  getChampObligatoire() async {
    var connection = await Connectivity().checkConnectivity();
    if (connection == ConnectivityResult.none) {
      var response = await LocalIncidentSecuriteService().readChampObligatoireIncidentSecurite();
      response.forEach((data) {
        setState(() {
          var model = ChampObligatoireIncidentSecuriteModel();
          model.dateVisite = data['dateVisite'];
          model.comportementsObserve = data['comportementsObserve'];
          model.comportementRisquesObserves = data['comportementRisquesObserves'];
          model.correctionsImmediates = data['correctionsImmediates'];

          date_visite_obligatoire = model.dateVisite!;
          comportement_sur_observe_obligatoire = model.comportementsObserve!;
          comportement_risque_observe_obligatoire = model.comportementRisquesObserves!;
          correction_immediate_obligatoire = model.correctionsImmediates!;
          print('champ obligatoire incident : ${data}');
        });
      });
    }
    else if (connection == ConnectivityResult.wifi ||
        connection == ConnectivityResult.mobile) {
      await IncidentSecuriteService().getChampObligatoireIncidentSecurite().then((data) async {
        setState(() {
          var model = ChampObligatoireIncidentSecuriteModel();
          model.dateVisite = data['date_visite'];
          model.comportementsObserve = data['comportements_observe'];
          model.comportementRisquesObserves = data['comportement_risques_observes'];
          model.correctionsImmediates = data['corrections_immediates'];

          date_visite_obligatoire = model.dateVisite!;
          comportement_sur_observe_obligatoire = model.comportementsObserve!;
          comportement_risque_observe_obligatoire = model.comportementRisquesObserves!;
          correction_immediate_obligatoire = model.correctionsImmediates!;
          print('champ obligatoire incident : ${data}');
        });
      }
          , onError: (err) {
            ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
          });
    }
  }

  Future getEquipeVisiteSecurite() async {
    //keyRefresh.currentState?.show();
    //await Future.delayed(Duration(milliseconds: 4000));

    var response = await LocalVisiteSecuriteService().readEquipeVisiteSecurite();
    response.forEach((data){
      setState(() {
        var model = EquipeVisiteSecuriteModel();
        model.id = data['id'];
        model.affectation = data['affectation'];
        model.mat = data['mat'];
        model.nompre = data['nompre'];
        listEquipeVisiteSecurite.add(model);
        var modelToSave = EquipeModel();
        modelToSave.mat = data['mat'];
        modelToSave.affectation = data['affectation'];
        listEquipeSave.add(modelToSave);
        print('length equipe : ${listEquipeVisiteSecurite.length}');

      });

    });
  }

  bool _dataValidation() {
    if((listEquipeVisiteSecurite==[] && listEquipeSave==[]) || (listEquipeVisiteSecurite.isEmpty && listEquipeSave.isEmpty)){
    Message.taskErrorOrWarning("Warning", "Ajouter responsable");
    return false;
    }
    else if (checkListModel == null) {
      Message.taskErrorOrWarning("Warning", "CheckList is required");
      return false;
    }
    else if (uniteModel == null) {
      Message.taskErrorOrWarning("Warning", "Unite is required");
      return false;
    }
    else if (zoneModel == null) {
      Message.taskErrorOrWarning("Warning", "Zone is required");
      return false;
    }
    else if (dateVisiteController.text.trim() == '' && date_visite_obligatoire == 1 ) {
    Message.taskErrorOrWarning("Warning", "Date is required");
    return false;
    }
    else if (comportementSurObserveController.text.trim() == '' && comportement_sur_observe_obligatoire == 1 ) {
      Message.taskErrorOrWarning("Warning", "Comportement Observe est obligatoire");
      return false;
    }
    else if (comportementRisqueObserveController.text.trim() == '' && comportement_risque_observe_obligatoire == 1 ) {
      Message.taskErrorOrWarning("Warning", "Comportement risque Observe est obligatoire");
      return false;
    }
    else if (correctionImmediateController.text.trim() == '' && correction_immediate_obligatoire == 1 ) {
      Message.taskErrorOrWarning("Warning", "Corrections Immediates est obligatoire");
      return false;
    }
    return true;
  }

  selectedDate(BuildContext context) async {
    datePickerVisite = (await showDatePicker(
        context: context,
        initialDate: datePickerVisite,
        firstDate: DateTime(2021),
        lastDate: DateTime(2050)
      //lastDate: DateTime.now()
    ))!;
    if (datePickerVisite != null) {
      dateVisiteController.text = DateFormat('dd/MM/yyyy').format(datePickerVisite);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        leading: RaisedButton(
          onPressed: (){
            localVisiteSecuriteService.deleteTableEquipeVisiteSecurite();
            Get.to(VisiteSecuritePage());
            //Get.back();
          },
          elevation: 0.0,
          child: Icon(Icons.arrow_back, color: Colors.white,),
          color: Colors.blue,
        ),
        title: Center(
          child: Text("New Visite Securite"),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: SingleChildScrollView(
                child: Form(
                    key: _addItemFormKey,
                    child: Padding(
                        padding: EdgeInsets.all(25.0),
                        child: Column(
                          children: <Widget>[

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
                                    setState(() {
                                      checkListModel = data;
                                      selectedIdCheckList = data?.idCheck;
                                      checkList = data?.checklist;
                                      if(checkListModel == null){
                                        selectedIdCheckList = 0;
                                        checkList = "";
                                      }
                                      print('CheckList: ${checkListModel?.checklist}, id: ${selectedIdCheckList}');
                                    });
                                  },
                                  dropdownBuilder: customDropDownCheckList,
                                  popupItemBuilder: customPopupItemBuilderCheckList,
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
                                    setState(() {
                                      uniteModel = data;
                                      selectedIdUnite = data?.idUnite;
                                      unite = data?.unite;
                                      if(uniteModel == null){
                                        selectedIdUnite = 0;
                                        unite = "";
                                      }
                                      print('unite: ${unite}, id: ${selectedIdUnite}');
                                    });

                                  },
                                  dropdownBuilder: customDropDownUnite,
                                  popupItemBuilder: customPopupItemBuilderUnite,

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
                                    zoneModel = data;
                                    selectedIdZone = data?.idZone;
                                    zone = data?.zone;
                                    if(zoneModel == null){
                                      selectedIdZone = 0;
                                      zone = "";
                                    }
                                    print('zone: ${zone}, id: ${selectedIdZone}');
                                  },
                                  dropdownBuilder: customDropDownZone,
                                  popupItemBuilder: customPopupItemBuilderZone,

                                )
                            ),
                            SizedBox(height: 10.0,),
                            Visibility(
                              visible: true,
                              child: TextFormField(
                                controller: dateVisiteController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                onChanged: (value){
                                  selectedDate(context);
                                },
                                decoration: InputDecoration(
                                    labelText: 'Date Visite ${date_visite_obligatoire==1?'*':''}',
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
                                        selectedDate(context);
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
                                visible:site_visible==1 ?true :false,
                                child: DropdownSearch<SiteModel>(
                                  showSelectedItems: true,
                                  showClearButton: siteModel?.site=="" ? false : true,
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
                                    setState(() {
                                      siteModel = data;
                                      selectedCodeSite = data?.codesite;
                                      site = data?.site;
                                      if(siteModel == null){
                                        selectedCodeSite = 0;
                                        site = "";
                                      }
                                      print('site: ${siteModel?.site}, code: ${selectedCodeSite}');
                                    });
                                  },
                                  dropdownBuilder: customDropDownSite,
                                  popupItemBuilder: customPopupItemBuilderSite,
                                )
                            ),
                            SizedBox(height: 10.0,),
                            TextFormField(
                              controller: situationObserveController,
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
                              controller: comportementSurObserveController,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText: 'Comportement Sur Observe ${comportement_sur_observe_obligatoire==1?'*':''}',
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
                              controller: comportementRisqueObserveController,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText: 'Comportement a risque observe ${comportement_risque_observe_obligatoire==1?'*':''}',
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
                              controller: correctionImmediateController,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText: 'Corrections immédiates ${correction_immediate_obligatoire==1?'*':''}',
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
                            SizedBox(height: 10.0,),
                            TextFormField(
                              controller: autreSujectController,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText: 'Autres sujets',
                                hintText: 'Autres sujets',
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
                            Center(child: Text('Equipe Visite Securite',
                              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),),),
                            SingleChildScrollView(
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
                                          final _addItemFormKey = GlobalKey<FormState>();
                                          String? employeMatricule = "";
                                          String? employeNompre = "";
                                          Object? traite = 3;
                                          //getEmploye
                                          Future<List<EmployeModel>> getEmploye(filter) async {
                                            try {
                                              List<EmployeModel> employeList = await List<EmployeModel>.empty(growable: true);
                                              List<EmployeModel>employeFilter = await List<EmployeModel>.empty(growable: true);
                                              var response = await LocalVisiteSecuriteService().readEmployeEquipeVisiteSecurite();
                                              //var response = await LocalActionService().readEmploye();
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
                                          Widget customDropDownEmploye(BuildContext context, EmployeModel? item) {
                                            if (item == null) {
                                              return Container();
                                            }
                                            else{
                                              return Container(
                                                child: ListTile(
                                                  contentPadding: EdgeInsets.all(0),
                                                  title: Text('${item.nompre}', style: TextStyle(color: Colors.black)),
                                                ),
                                              );
                                            }
                                          }
                                          Widget customPopupItemBuilderEmploye(
                                              BuildContext context, EmployeModel item, bool isSelected) {
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
                                                title: Text(item.nompre ?? ''),
                                                //subtitle: Text(item.mat.toString() ?? ''),
                                              ),
                                            );
                                          }

                                          //bottomSheet
                                          showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              shape: const RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.vertical(
                                                      top: Radius.circular(30)
                                                  )
                                              ),
                                              builder: (context) => DraggableScrollableSheet(
                                                expand: false,
                                                initialChildSize: 0.7,
                                                maxChildSize: 0.9,
                                                minChildSize: 0.4,
                                                builder: (context, scrollController) => SingleChildScrollView(
                                                  child: StatefulBuilder(
                                                    builder: (BuildContext context, StateSetter setState) {
                                                      return ListBody(
                                                        children: <Widget>[
                                                          SizedBox(height: 5.0,),
                                                          Center(
                                                            child: Text('Equipe Visite Securite', style: TextStyle(
                                                                fontWeight: FontWeight.w500, fontFamily: "Brand-Bold",
                                                                color: Color(0xFF0769D2), fontSize: 30.0
                                                            ),),
                                                          ),
                                                          SizedBox(height: 15.0,),
                                                          Form(
                                                            key: _addItemFormKey,
                                                            child: Column(
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets.only(left: 10, right: 10),
                                                                  child: DropdownSearch<EmployeModel>(
                                                                    showSelectedItems: true,
                                                                    showClearButton: true,
                                                                    showSearchBox: true,
                                                                    isFilteredOnline: true,
                                                                    compareFn: (i, s) => i?.isEqual(s) ?? false,
                                                                    dropdownSearchDecoration: InputDecoration(
                                                                      labelText: "Employe *",
                                                                      contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                                                      border: OutlineInputBorder(),
                                                                    ),
                                                                    onFind: (String? filter) => getEmploye(filter),
                                                                    onChanged: (data) {
                                                                      employeMatricule = data?.mat;
                                                                      employeNompre = data?.nompre;
                                                                      print('employe: ${employeNompre}, mat: ${employeMatricule}');
                                                                    },
                                                                    dropdownBuilder: customDropDownEmploye,
                                                                    popupItemBuilder: customPopupItemBuilderEmploye,
                                                                    validator: (u) =>
                                                                    u == null ? "Employe is required " : null,
                                                                  ),
                                                                ),
                                                                SizedBox(height: 10,),
                                                                Column(
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Radio(value: 3,
                                                                          groupValue: traite,
                                                                          onChanged: (value){
                                                                            setState(() => traite = value);
                                                                          },
                                                                          activeColor: Colors.blue,
                                                                          fillColor: MaterialStateProperty.all(Colors.blue),),
                                                                        const Text("Responsable Audit", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),)
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Radio(value: 2,
                                                                          groupValue: traite,
                                                                          onChanged: (value){
                                                                            setState(() => traite = value);
                                                                          },
                                                                          activeColor: Colors.blue,
                                                                          fillColor: MaterialStateProperty.all(Colors.blue),),
                                                                        const Text("Auditeur", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),)
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Radio(value: 1,
                                                                          groupValue: traite,
                                                                          onChanged: (value){
                                                                            setState(() => traite = value);
                                                                          },
                                                                          activeColor: Colors.blue,
                                                                          fillColor: MaterialStateProperty.all(Colors.blue),),
                                                                        const Text("Observateur", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),)
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                                SizedBox(height: 10,),
                                                                ConstrainedBox(
                                                                  constraints: BoxConstraints.tightFor(width: MediaQuery.of(context).size.width / 1.1, height: 50),
                                                                  child: ElevatedButton.icon(
                                                                    style: ButtonStyle(
                                                                      shape: MaterialStateProperty.all(
                                                                        RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(30),
                                                                        ),
                                                                      ),
                                                                      backgroundColor:
                                                                      MaterialStateProperty.all(CustomColors.firebaseRedAccent),
                                                                      padding: MaterialStateProperty.all(EdgeInsets.all(14)),
                                                                    ),
                                                                    icon: Icon(Icons.cancel),
                                                                    label: Text(
                                                                      'Cancel',
                                                                      style: TextStyle(fontSize: 16, color: Colors.white),
                                                                    ),
                                                                    onPressed: () {
                                                                      Get.back();
                                                                    },
                                                                  ),
                                                                ),
                                                                SizedBox(height: 10,),
                                                                ConstrainedBox(
                                                                  constraints: BoxConstraints.tightFor(width: MediaQuery.of(context).size.width / 1.1, height: 50),
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
                                                                    icon: Icon(Icons.save),
                                                                    label: Text(
                                                                      'Save',
                                                                      style: TextStyle(fontSize: 16, color: Colors.white),
                                                                    ),
                                                                    onPressed: () async {
                                                                      if(_addItemFormKey.currentState!.validate()){
                                                                        try {
                                                                          var model = EquipeVisiteSecuriteModel();
                                                                          model.affectation = int.parse(traite.toString());
                                                                          model.mat = employeMatricule;
                                                                          model.nompre = employeNompre;
                                                                          await localVisiteSecuriteService.saveEquipeVisiteSecurite(model);
                                                                          Get.back();
                                                                          ShowSnackBar.snackBar("Successfully", "added to Equipe", Colors.green);
                                                                          //await Get.offAll(EquipeVisiteSecPage(numFiche: widget.numFiche));
                                                                          setState(() {
                                                                            listEquipeVisiteSecurite.clear();
                                                                            listEquipeSave.clear();
                                                                            getEquipeVisiteSecurite();
                                                                          });
                                                                        }
                                                                        catch (ex){
                                                                          print("Exception" + ex.toString());
                                                                          ShowSnackBar.snackBar("Exception", ex.toString(), Colors.red);
                                                                          throw Exception("Error " + ex.toString());
                                                                        }
                                                                      }
                                                                    },
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                ),
                                              )
                                          );
                                        },
                                        child: Icon(Icons.add, color: Colors.indigoAccent, size: 30,),
                                      ),)
                                  ],
                                  rows: listEquipeVisiteSecurite==[] ?[] : getRows(listEquipeVisiteSecurite),
                                  /* rows: listEquipeVisiteSecurite.map<DataRow>((element) => DataRow(cells: [
                                          //DataCell(Text(element!.mat.toString(), style: _contentStyle, textAlign: TextAlign.right)),
                                          DataCell(Text('${element!.nompre}',
                                              style: _contentStyle, textAlign: TextAlign.right)),
                                          DataCell(Text('${element.affectation}',
                                              style: _contentStyle, textAlign: TextAlign.right)),
                                          DataCell(Text('')),
                                        ])).toList() */

                                ),
                              ),
                            ),
                            SizedBox(height: 15.0,),
                            _isProcessing
                                ? Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  CustomColors.firebaseOrange,
                                ),
                              ),
                            )
                                :
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
                                icon: Icon(Icons.save),
                                label: Text(
                                  'Save',
                                  style: TextStyle(fontSize: 16, color: Colors.white),
                                ),
                                onPressed: () {
                                  saveBtn();
                                },
                              ),
                            )
                          ],
                        )
                    )
                ),
              ),
            ),
          )
      ),
    );
  }

  List<DataRow> getRows(List<EquipeVisiteSecuriteModel> listEquipeInfo) => listEquipeInfo.map((EquipeVisiteSecuriteModel model) {
    final affect = model.affectation;
    String message_affect = '';
    switch (affect) {
      case 1:
        message_affect = "Observateur";
        break;
      case 2:
        message_affect = "Auditeur";
        break;
      case 3:
        message_affect = "Responsable Audit";
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
                await localVisiteSecuriteService.deleteEmployeOfEquipeVisiteSecurite(model.id);
                ///print('response delete : $response');
                setState(() {
                  listEquipeVisiteSecurite.removeWhere((element) => element.id == model.id);
                  listEquipeSave.removeWhere((element) => element.mat == model.mat);
                  print('new list equipe to save : ${listEquipeSave.length}');
                   /*if(response > 0){
                     listEquipeVisiteSecurite.removeWhere((element) => element.id == model.id);
                   } */
                });
              },
              child: Icon(Icons.delete, color: Colors.red,)
          )
      )
    ],
    );
  }).toList();

  Future saveBtn() async {
    if(_dataValidation() && _addItemFormKey.currentState!.validate()){
      try {
        setState(() {
          _isProcessing = true;
        });
        var connection = await Connectivity().checkConnectivity();
        if (connection == ConnectivityResult.none) {
          final dateVisite = DateFormat('yyyy-MM-dd').format(datePickerVisite);
          int max_num_visite_sec = await localVisiteSecuriteService.getMaxNumVisiteSecurite();
          var model = VisiteSecuriteModel();
          model.online = 0;
          model.id = max_num_visite_sec+1;
          model.site = site;
          model.dateVisite = '${dateVisite}T00:00:00';
          model.unite = unite;
          model.zone = zone;
          model.checkList = checkList;
          model.idCheckList = selectedIdCheckList;
          model.idUnite = selectedIdUnite;
          model.idZone = selectedIdZone;
          model.codeSite = selectedCodeSite;
          model.situationObserve = situationObserveController.text;
          model.comportementSurObserve = comportementSurObserveController.text;
          model.comportementRisqueObserve = comportementRisqueObserveController.text;
          model.correctionImmediate = correctionImmediateController.text;
          model.autres = autreSujectController.text;
          //save data sync
          await localVisiteSecuriteService.saveVisiteSecuriteSync(model);
          listEquipeSave.forEach((element) async {
            var modelEquipe = EquipeModel();
            modelEquipe.id = max_num_visite_sec+1;
            modelEquipe.mat = element.mat;
            modelEquipe.affectation = element.affectation;
            //temp equipe of vs
            await localVisiteSecuriteService.saveEquipeVisiteSecuriteEmploye(modelEquipe);

            debugPrint('equipe to save : ${modelEquipe.id}-${modelEquipe.mat}-${modelEquipe.affectation}');
          });
          listEquipeVisiteSecurite.forEach((element) async {
            //save equipe vs
            var modelEquipeVisiteSecurite = EquipeVisiteSecuriteModel();
            modelEquipeVisiteSecurite.online = 3;
            modelEquipeVisiteSecurite.id = max_num_visite_sec+1;
            modelEquipeVisiteSecurite.affectation = element.affectation;
            modelEquipeVisiteSecurite.mat = element.mat;
            modelEquipeVisiteSecurite.nompre = element.nompre;
            await localVisiteSecuriteService.saveEquipeVisiteSecuriteOffline(modelEquipeVisiteSecurite);
            debugPrint('equipe visite securite : ${modelEquipeVisiteSecurite.id}-${modelEquipeVisiteSecurite.mat}-${modelEquipeVisiteSecurite.nompre}-${modelEquipeVisiteSecurite.affectation}');
          });
          await LocalVisiteSecuriteService().deleteTableEquipeVisiteSecurite();
          Get.to(VisiteSecuritePage());
          ShowSnackBar.snackBar("Successfully", "Visite Securite Added ", Colors.green);
          Get.find<VisiteSecuriteController>().listVisiteSecurite.clear();
          Get.find<VisiteSecuriteController>().getData();

        }
        else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
          await VisiteSecuriteService().saveVisiteSecurite(
              {
                "idSite": selectedCodeSite,
                "dateVisite": dateVisiteController.text,
                "idUnite": selectedIdUnite,
                "idZone": selectedIdZone,
                "comportementObserve": comportementSurObserveController.text,
                "comportementRisque": comportementRisqueObserveController.text,
                "correctImmediate": correctionImmediateController.text,
                "autres": autreSujectController.text,
                "idCHK": selectedIdCheckList,
                "stObserve": situationObserveController.text,
                "equipes": listEquipeSave
              }
          ).then((resp) {
            //Get.back();
            LocalVisiteSecuriteService().deleteTableEquipeVisiteSecurite();
            Get.to(VisiteSecuritePage());
            ShowSnackBar.snackBar("Successfully", "Visite Securite Added ", Colors.green);
            Get.find<VisiteSecuriteController>().listVisiteSecurite.clear();
            Get.find<VisiteSecuriteController>().getData();
          }, onError: (err) {
            setState(()  {
              _isProcessing = false;
            });
            print('Error : ${err.toString()}');
            ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
          });
        }

      }
      catch (ex){
        setState(()  {
          _isProcessing = false;
        });
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
      finally{
        setState(()  {
          _isProcessing = false;
        });
      }
    }
  }

  //dropdown search
  //checklist
  Future<List<CheckListModel>> getCheckList(filter) async {
    try {
      List<CheckListModel> _checkList = await List<CheckListModel>.empty(growable: true);
      List<CheckListModel> _typeFilter = await List<CheckListModel>.empty(growable: true);
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        var response = await localVisiteSecuriteService.readCheckList();
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
  Widget customDropDownCheckList(BuildContext context, CheckListModel? item) {
    if (checkListModel == null) {
      return Container();
    }
    else{
      return Container(

        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${checkListModel?.checklist}', style: TextStyle(color: Colors.black),),
        ),
      );
    }
  }
  Widget customPopupItemBuilderCheckList(
      BuildContext context, checkListModel, bool isSelected) {
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
        title: Text(checkListModel?.checklist ?? ''),
        subtitle: Text(checkListModel?.code.toString() ?? ''),
      ),
    );
  }
  //unite
  Future<List<UniteModel>> getUnite(filter) async {
    try {
      List<UniteModel> _uniteList = await List<UniteModel>.empty(growable: true);
      List<UniteModel> _uniteFilter = await List<UniteModel>.empty(growable: true);
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        var response = await localVisiteSecuriteService.readUniteVisiteSecurite();
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
  Widget customDropDownUnite(BuildContext context, UniteModel? item) {
    if (uniteModel == null) {
      return Container();
    }
    else{
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${uniteModel?.unite}', style: TextStyle(color: Colors.black),),
        ),
      );
    }
  }
  Widget customPopupItemBuilderUnite(
      BuildContext context, uniteModel, bool isSelected) {
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
        title: Text(uniteModel?.unite ?? ''),
        subtitle: Text(uniteModel?.code.toString() ?? ''),
      ),
    );
  }
  //zone
  Future<List<ZoneModel>> getZone(filter) async {
    try {
      if(uniteModel == null){
        Get.snackbar("No Data", "Please select Unite", backgroundColor: Colors.white, colorText: Colors.blue, snackPosition: SnackPosition.BOTTOM);

      }
      List<ZoneModel> _zoneList = await List<ZoneModel>.empty(growable: true);
      List<ZoneModel> _zoneFilter = await List<ZoneModel>.empty(growable: true);
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        var response = await localVisiteSecuriteService.readZoneByIdUnite(selectedIdUnite);
        response.forEach((data){
          var model = ZoneModel();
          model.idZone = data['idZone'];
          model.zone = data['zone'];
          _zoneList.add(model);
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        await VisiteSecuriteService().getZoneByUnite(selectedIdUnite).then((resp) async {
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
  Widget customDropDownZone(BuildContext context, ZoneModel? item) {
    if (zoneModel == null) {
      return Container();
    }
    else{
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${zoneModel?.zone}', style: TextStyle(color: Colors.black),),
        ),
      );
    }
  }
  Widget customPopupItemBuilderZone(
      BuildContext context, zoneModel, bool isSelected) {
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
        title: Text(zoneModel?.zone ?? ''),
        subtitle: Text(zoneModel?.idZone.toString() ?? ''),
      ),
    );
  }
  //Site
  Future<List<SiteModel>> getSite(filter) async {
    try {
      List<SiteModel> siteList = await List<SiteModel>.empty(growable: true);
      List<SiteModel> siteFilter = await <SiteModel>[];
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        var response = await localVisiteSecuriteService.readSiteVisiteSecurite();
        response.forEach((data){
          var model = SiteModel();
          model.codesite = data['codesite'];
          model.site = data['site'];
          siteList.add(model);
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        await VisiteSecuriteService().getSiteVisiteSecurite(matricule).then((resp) async {
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
  //equipe visite securite
  Future<List<EmployeModel>> getEmploye(filter) async {
    try {
      List<EmployeModel> employeList = await List<EmployeModel>.empty(growable: true);
      List<EmployeModel>employeFilter = await List<EmployeModel>.empty(growable: true);
      var response = await localActionService.readEmploye();
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