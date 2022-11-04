import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as mypath;
import 'package:qualipro_flutter/Agenda/Views/pnc/pnc_corriger_page.dart';
import 'package:qualipro_flutter/Agenda/Views/pnc/pnc_suivre_page.dart';
import 'package:qualipro_flutter/Models/action/action_realisation_model.dart';

import '../../../Controllers/api_controllers_call.dart';
import '../../../Models/activity_model.dart';
import '../../../Models/client_model.dart';
import '../../../Models/direction_model.dart';
import '../../../Models/employe_model.dart';
import '../../../Models/fournisseur_model.dart';
import '../../../Models/pnc/atelier_pnc_model.dart';
import '../../../Models/pnc/gravite_pnc_model.dart';
import '../../../Models/pnc/isps_pnc_model.dart';
import '../../../Models/pnc/pnc_a_corriger_model.dart';
import '../../../Models/pnc/pnc_a_traiter_model.dart';
import '../../../Models/pnc/pnc_details_model.dart';
import '../../../Models/pnc/pnc_suivre_model.dart';
import '../../../Models/pnc/source_pnc_model.dart';
import '../../../Models/pnc/type_pnc_model.dart';
import '../../../Models/processus_model.dart';
import '../../../Models/product_model.dart';
import '../../../Models/service_model.dart';
import '../../../Models/site_model.dart';
import '../../../Services/action/action_service.dart';
import '../../../Services/action/local_action_service.dart';
import '../../../Services/api_services_call.dart';
import '../../../Services/pnc/local_pnc_service.dart';
import '../../../Services/pnc/pnc_service.dart';
import '../../../Utils/custom_colors.dart';
import '../../../Utils/message.dart';
import '../../../Utils/shared_preference.dart';
import '../../../Utils/snack_bar.dart';
import '../../../Utils/utility_file.dart';
import '../../../Validators/validator.dart';
import 'pnc_investigation_approuver_page.dart';
import 'pnc_traiter_page.dart';

class RemplirPNCCorriger extends StatefulWidget {
  PNCCorrigerModel pncModel;

  RemplirPNCCorriger({Key? key, required this.pncModel}) : super(key: key);

  @override
  State<RemplirPNCCorriger> createState() => _RemplirPNCCorrigerState();
}

class _RemplirPNCCorrigerState extends State<RemplirPNCCorriger> {
  final _addItemFormKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  PNCService pncService = PNCService();
  bool _isProcessing = false;
  final matricule = SharedPreference.getMatricule();

  DateTime datePickerDetection = DateTime.now();
  DateTime datePickerLivraison = DateTime.now();
  DateTime datePickerSaisie = DateTime.now();
  DateTime datePickerValidation = DateTime.now();
  TextEditingController  dateDetectionController = TextEditingController();
  TextEditingController  dateLivraisonController = TextEditingController();
  TextEditingController  dateSaisieController = TextEditingController();
  TextEditingController  ncController = TextEditingController();
  TextEditingController  actionPriseController = TextEditingController();
  TextEditingController  numInterneController = TextEditingController();
  TextEditingController  numeroOfController = TextEditingController();
  TextEditingController  numeroLotController = TextEditingController();
  TextEditingController  uniteController = TextEditingController();
  TextEditingController  quantityDetectController = TextEditingController();
  TextEditingController  quantityProductController = TextEditingController();
  TextEditingController  prixProductController = TextEditingController();
  TextEditingController  causeController = TextEditingController();
  TextEditingController motifController = TextEditingController();
  TextEditingController decideurController = TextEditingController();
  TextEditingController  dateValidationController = TextEditingController();

  //product
  ProductModel? productModel = null;
  String? selectedCodeProduct = "";
  String? productNC = "";
  //employe
  EmployeModel? employeModel = null;
  EmployeModel? detectedEmployeModel = null;
  String? origineNCMatricule = "";
  String? origineNCNomPrenom = "";
  String? detectedEmployeMatricule = "";
  String? detectedEmployeNomPrenom = "";
  String? respSuivi = "";
  //type
  TypePNCModel? typePNCModel = null;
  int? selectedCodeType = 0;
  String? typeNC = "";
  //gravite
  GravitePNCModel? graviteModel = null;
  int? selectedCodeGravite = 0;
  String? graviteNC = "";
  //source
  SourcePNCModel? sourcePNCModel = null;
  int? selectedCodeSource = 0;
  String? sourceNC = "";
  //atelier
  AtelierPNCModel? atelierPNCModel = null;
  int? selectedCodeAtelier = 0;
  String? atelierNC = "";
  //fournisseur
  FournisseurModel? fournisseurModel = null;
  String? selectedCodeFournisseur = "";
  String? fournisseurNC = "";
  //isps
  String? isps = "0";
  String? isps_name = "";
  //site
  SiteModel? siteModel = null;
  int? selectedCodeSite = 0;
  String? siteNC = "";
  //processus
  ProcessusModel? processusModel = null;
  int? selectedCodeProcessus = 0;
  String? processusNC = "";
  //direction
  DirectionModel? directionModel = null;
  int? selectedCodeDirection = 0;
  String? directionNC = "";
  //service
  ServiceModel? serviceModel = null;
  int? selectedCodeService = 0;
  String? serviceNC = "";
  //activity
  ActivityModel? activityModel = null;
  int? selectedCodeActivity = 0;
  String? activityNC = "";
  //client
  ClientModel? clientModel = null;
  String? selectedCodeClient = "";
  String? clientNC = "";
  //checkbox product
  bool checkProductBloque = false;
  int? productBloque = 0;
  bool checkProductIsole = false;
  int? productIsole = 0;

  Future getPNCByNNC() async {
    try {
      await PNCService().getPNCByNNC(widget.pncModel.nnc).then((resp) async {
        setState(() {
          var model = PNCDetailsModel();
          model.respInvestig = resp['nc'];
          model.actionIm = resp['actionIm'];
          model.dateDetect = resp['dateDetect'];
          model.dateLiv = resp['dateLiv'];
          model.dateSaisie = resp['dateSaisie'];
          model.ninterne = resp['ninterne'];
          model.numOf = resp['numOf'];
          model.nLot = resp['nLot'];
          model.unite = resp['unite'];
          model.qteDetect = resp['qteDetect'].toInt();
          model.qteprod = resp['qteprod'].toInt();
          model.prix = resp['prix'].toInt();
          model.causeNC = resp['causeNC'];
          model.decideur = resp['decideur'];
          model.motifRefus = resp['motif_refus'];

          ncController.text = model.respInvestig.toString();
          actionPriseController.text = model.actionIm.toString();
          causeController.text = model.causeNC.toString();
          dateDetectionController.text = DateFormat('yyyy-MM-dd').format(DateTime.parse(model.dateDetect.toString()));
          dateLivraisonController.text = DateFormat('yyyy-MM-dd').format(DateTime.parse(model.dateLiv.toString()));
          dateSaisieController.text = DateFormat('yyyy-MM-dd').format(DateTime.parse(model.dateSaisie.toString()));
          dateValidationController.text = DateFormat('yyyy-MM-dd').format(datePickerValidation);
          numInterneController.text = model.ninterne.toString();
          numeroOfController.text = model.numOf.toString();
          numeroLotController.text = model.nLot.toString();
          uniteController.text = model.unite.toString();
          quantityDetectController.text = model.qteDetect.toString();
          quantityProductController.text = model.qteprod.toString();
          prixProductController.text = model.prix.toString();
          motifController.text = model.motifRefus.toString();
          decideurController.text = model.decideur.toString();
          //product
          model.produit = resp['produit'];
          model.codePdt = resp['codePdt'];
          selectedCodeProduct = model.codePdt;
          print('selectedCodeProduct : $selectedCodeProduct');
          productNC = model.produit;
          //detectby
          model.ndetecpar = resp['ndetecpar'];
          model.recep = resp['recep'];
          detectedEmployeMatricule = model.recep;
          print('detectedEmployeMatricule : $detectedEmployeMatricule');
          detectedEmployeNomPrenom = model.ndetecpar;
          //origine nc
          model.matOrigine = resp['matOrigine'];
          model.nomMatorigine = resp['nomMatorigine'];
          origineNCMatricule = model.matOrigine;
          print('origineNCMatricule : $origineNCMatricule');
          origineNCNomPrenom = model.nomMatorigine;
          //resp suivi
          model.repSuivi = resp['repSuivi'];
          respSuivi = model.repSuivi;
          //Type NC
          model.typeNC = resp['typeNC'];
          model.codeTypeNC = resp['codeTypeNC'];
          selectedCodeType = model.codeTypeNC;
          print('selectedCodeType : $selectedCodeType');
          typeNC = model.typeNC;
          //gravite NC
          model.gravite = resp['gravite'];
          model.ngravite = resp['ngravite'];
          selectedCodeGravite = model.ngravite;
          print('selectedCodeGravite : $selectedCodeGravite');
          graviteNC = model.gravite;
          //source NC
          model.sourceNC = resp['sourceNC'];
          model.codeSourceNC = resp['codeSourceNC'];
          selectedCodeSource = model.codeSourceNC;
          print('selectedCodeSource : $selectedCodeSource');
          sourceNC = model.sourceNC;
          //atelier NC
          model.atelierNC = resp['atelierNC'];
          model.atelier = resp['atelier'];
          selectedCodeAtelier = model.atelier;
          print('selectedCodeAtelier : $selectedCodeAtelier');
          atelierNC = model.atelierNC;
          //fournisseur NC
          model.raisonSociale = resp['raisonSociale'];
          model.frs = resp['frs'];
          selectedCodeFournisseur = model.frs;
          print('selectedCodeFournisseur : $selectedCodeFournisseur');
          fournisseurNC = model.raisonSociale;
          //site NC
          model.site = resp['site'];
          model.codeSite = resp['codeSite'];
          selectedCodeSite = model.codeSite;
          print('selectedCodeSite : $selectedCodeSite');
          siteNC = model.site;
          //processus NC
          model.processus = resp['processus'];
          model.idProcess = resp['id_process'];
          selectedCodeProcessus = model.idProcess;
          print('selectedCodeProcessus : $selectedCodeProcessus');
          processusNC = model.processus;
          //direction NC
          model.direction = resp['direction'];
          model.idDirection = resp['id_direction'];
          selectedCodeDirection = model.idDirection;
          print('selectedCodeDirection : $selectedCodeDirection');
          directionNC = model.direction;
          //service NC
          model.service = resp['service'];
          model.idService = resp['id_service'];
          selectedCodeService = model.idService;
          print('selectedCodeService : $selectedCodeService');
          serviceNC = model.service;
          //activity NC
          model.domaine = resp['domaine'];
          model.idDomaine = resp['id_domaine'];
          selectedCodeActivity = model.idDomaine;
          print('selectedCodeActivity : $selectedCodeActivity');
          activityNC = model.domaine;
          //activity NC
          model.nomClt = resp['nomClt'];
          model.idClient = resp['id_client'];
          selectedCodeClient = model.idClient;
          print('selectedCodeClient : $selectedCodeClient');
          clientNC = model.nomClt;
          //isps
          model.isps = resp['isps'];
          isps = model.isps.toString();
          if(isps == "1"){
            isps_name = "OUI";
          }
          else if(isps == "2"){
            isps_name = "NON";
          }
          else if(isps == "3"){
            isps_name = "Non Applicable";
          }
          else {
            isps_name = "";
          }
          //checkbox
          model.bloque = resp['bloque'].toInt();
          productBloque = model.bloque;
          if(productBloque == 1){
            checkProductBloque = true;
          }
          else {
            checkProductBloque = false;
          }
          model.isole = resp['isole'].toInt();
          productIsole = model.isole;
          if(productIsole == 1){
            checkProductIsole = true;
          }
          else {
            checkProductIsole = false;
          }

        });
      }
          , onError: (err) {
            ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
          });

    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    }
  }

  @override
  void initState(){
    getPNCByNNC();
    dateLivraisonController.text = DateFormat('yyyy-MM-dd').format(datePickerLivraison);
    dateSaisieController.text = DateFormat('yyyy-MM-dd').format(datePickerSaisie);
    super.initState();
  }

  selectedDateDetection(BuildContext context) async {
    datePickerDetection = (await showDatePicker(
        context: context,
        initialDate: datePickerDetection,
        firstDate: DateTime(2021),
        lastDate: DateTime(2100)
      //lastDate: DateTime.now()
    ))!;
    if (datePickerDetection != null) {
      dateDetectionController.text =
          DateFormat('yyyy-MM-dd').format(datePickerDetection);
      //dateDetectionController.text = DateFormat.yMMMMd().format(datePickerDetection);
    }
  }
  selectedDateLivraison(BuildContext context) async {
    datePickerLivraison = (await showDatePicker(
        context: context,
        initialDate: datePickerLivraison,
        firstDate: DateTime(2021),
        lastDate: DateTime(2100)
      //lastDate: DateTime.now()
    ))!;
    if (datePickerLivraison != null) {
      dateLivraisonController.text = DateFormat('yyyy-MM-dd').format(datePickerLivraison);
    }
  }
  selectedDateValidation(BuildContext context) async {
    datePickerValidation = (await showDatePicker(
        context: context,
        initialDate: datePickerValidation,
        firstDate: DateTime(2021),
        lastDate: DateTime(2100)
      //lastDate: DateTime.now()
    ))!;
    if (datePickerValidation != null) {
      dateValidationController.text =
          DateFormat('yyyy-MM-dd').format(datePickerValidation);
      //dateDetectionController.text = DateFormat.yMMMMd().format(datePickerDetection);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        leading: TextButton(
          onPressed: (){
            Get.back();
          },
          child: Icon(Icons.arrow_back, color: Colors.white,),
        ),
        title: Center(
          child: Text("PNC A Corriger N° ${widget.pncModel.nnc}"),
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
                            SizedBox(height: 10.0,),
                      TextFormField(
                        controller: ncController,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.next,
                        validator: (value) => Validator.validateField(
                            value: value!
                        ),
                        decoration: InputDecoration(
                          labelText: 'Non Conformité *',
                          hintText: 'Non Conformité',
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
                              controller: actionPriseController,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText: 'Action immédiate prise',
                                hintText: 'action',
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
                              controller: causeController,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText: 'Cause NC',
                                hintText: 'Cause NC',
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
                              visible: true,
                              child: TextFormField(
                                controller: dateDetectionController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                validator: (value) => Validator.validateField(
                                    value: value!
                                ),
                                onChanged: (value){
                                  selectedDateDetection(context);
                                },
                                decoration: InputDecoration(
                                    labelText: 'Date Detection *',
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
                                        selectedDateDetection(context);
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
                                controller: dateLivraisonController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                onChanged: (value){
                                  selectedDateLivraison(context);
                                },
                                decoration: InputDecoration(
                                    labelText: 'Date Livraison',
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
                                        selectedDateLivraison(context);
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
                                enabled: false,
                                controller: dateSaisieController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                validator: (value) => Validator.validateField(
                                    value: value!
                                ),
                                onChanged: (value){
                                  selectedDateDetection(context);
                                },
                                decoration: InputDecoration(
                                    labelText: 'Date Saisie',
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
                                        selectedDateDetection(context);
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
                                controller: numInterneController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                    labelText: 'Ref. interne',
                                    hintText: 'Ref. interne',
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
                                child: DropdownSearch<ProductModel>(
                                  showSelectedItems: true,
                                  showClearButton: true,
                                  showSearchBox: true,
                                  isFilteredOnline: true,
                                  compareFn: (i, s) => i?.isEqual(s) ?? false,
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText: "${'product'.tr} *",
                                    contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                    border: OutlineInputBorder(),
                                  ),
                                  onFind: (String? filter) => getProduct(filter),
                                  onChanged: (data) {
                                    productModel = data;
                                    selectedCodeProduct = data?.codePdt;
                                    print('product: ${productModel?.produit}, code: ${selectedCodeProduct}');
                                  },
                                  dropdownBuilder: customDropDownProduct,
                                  popupItemBuilder: customPopupItemBuilderProduct,
                                )
                            ),
                            SizedBox(height: 10.0,),
                            Visibility(
                              visible: true,
                              child: TextFormField(
                                controller: numeroOfController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                    labelText: 'Numero Of ',
                                    hintText: 'num of',
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
                                controller: numeroLotController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                    labelText: 'Numero Lot',
                                    hintText: 'num lot',
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
                                controller: uniteController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                    labelText: 'Unite',
                                    hintText: 'unite',
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
                                controller: quantityDetectController,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  labelText: 'Quantity detect',
                                  hintText: 'quantity',
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
                            ),
                            SizedBox(height: 10.0,),
                            Visibility(
                              visible: true,
                              child: TextFormField(
                                controller: quantityProductController,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  labelText: 'Quantity Product',
                                  hintText: 'quantity',
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
                            ),
                            SizedBox(height: 10.0,),
                            Visibility(
                              visible: true,
                              child: TextFormField(
                                controller: prixProductController,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  labelText: 'Prix',
                                  hintText: 'prix',
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
                                    detectedEmployeModel = data;
                                    detectedEmployeMatricule = data?.mat;
                                    print('detected by : ${detectedEmployeModel?.nompre}, mat:${detectedEmployeMatricule}');
                                  },
                                  dropdownBuilder: customDropDownDetectEmploye,
                                  popupItemBuilder: customPopupItemBuilderDetectedEmploye,
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
                                      labelText: "A l'origine de N.C ",
                                      contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                      border: OutlineInputBorder(),
                                    ),
                                    onFind: (String? filter) => getEmploye(filter),
                                    onChanged: (data) {
                                      employeModel = data;
                                      origineNCMatricule = data?.mat;
                                      print('origine de nc : ${employeModel?.nompre}, mat:${origineNCMatricule}');
                                    },
                                    dropdownBuilder: customDropDownEmploye,
                                    popupItemBuilder: customPopupItemBuilderEmploye,
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
                                visible: true,
                                child: DropdownSearch<TypePNCModel>(
                                  showSelectedItems: true,
                                  showClearButton: true,
                                  showSearchBox: true,
                                  isFilteredOnline: true,
                                  compareFn: (i, s) => i?.isEqual(s) ?? false,
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText: "Type NC *",
                                    contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                    border: OutlineInputBorder(),
                                  ),
                                  onFind: (String? filter) => getTypePNC(filter),
                                  onChanged: (data) {
                                    typePNCModel = data;
                                    selectedCodeType = data?.codeTypeNC;
                                    print('typeNC: ${typePNCModel?.typeNC}, code: ${selectedCodeType}');
                                  },
                                  dropdownBuilder: customDropDownType,
                                  popupItemBuilder: customPopupItemBuilderType,
                                )
                            ),
                            SizedBox(height: 10.0,),
                            Visibility(
                                visible: true,
                                child: DropdownSearch<GravitePNCModel>(
                                  showSelectedItems: true,
                                  showClearButton: true,
                                  showSearchBox: true,
                                  isFilteredOnline: true,
                                  compareFn: (i, s) => i?.isEqual(s) ?? false,
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText: "Gravite",
                                    contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                    border: OutlineInputBorder(),
                                  ),
                                  onFind: (String? filter) => getGravitePNC(filter),
                                  onChanged: (data) {
                                    graviteModel = data;
                                    selectedCodeGravite = data?.nGravite;
                                    print('gravite: ${graviteModel?.gravite}, code: ${selectedCodeGravite}');
                                  },
                                  dropdownBuilder: customDropDownGravite,
                                  popupItemBuilder: customPopupItemBuilderGravite,
                                )
                            ),
                            SizedBox(height: 10.0,),
                            Visibility(
                                visible: true,
                                child: DropdownSearch<SourcePNCModel>(
                                  showSelectedItems: true,
                                  showClearButton: true,
                                  showSearchBox: true,
                                  isFilteredOnline: true,
                                  compareFn: (i, s) => i?.isEqual(s) ?? false,
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText: "Source NC ",
                                    contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                    border: OutlineInputBorder(),
                                  ),
                                  onFind: (String? filter) => getSource(filter),
                                  onChanged: (data) {
                                    sourcePNCModel = data;
                                    selectedCodeSource = data?.codeSourceNC;
                                    print('source nc: ${sourcePNCModel?.sourceNC}, code: ${selectedCodeSource}');
                                  },
                                  dropdownBuilder: customDropDownSource,
                                  popupItemBuilder: customPopupItemBuilderSource,
                                )
                            ),
                            SizedBox(height: 10.0,),
                            Visibility(
                                visible: true,
                                child: DropdownSearch<AtelierPNCModel>(
                                  showSelectedItems: true,
                                  showClearButton: true,
                                  showSearchBox: true,
                                  isFilteredOnline: true,
                                  compareFn: (i, s) => i?.isEqual(s) ?? false,
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText: "Atelier",
                                    contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                    border: OutlineInputBorder(),
                                  ),
                                  onFind: (String? filter) => getAtelier(filter),
                                  onChanged: (data) {
                                    atelierPNCModel = data;
                                    selectedCodeAtelier = data?.codeAtelier;
                                    print('atelier: ${atelierPNCModel?.atelier}, code: ${selectedCodeAtelier}');
                                  },
                                  dropdownBuilder: customDropDownAtelier,
                                  popupItemBuilder: customPopupItemBuilderAtelier
                                )
                            ),
                            SizedBox(height: 10.0,),
                            Visibility(
                                visible: true,
                                child: DropdownSearch<FournisseurModel>(
                                  showSelectedItems: true,
                                  showClearButton: true,
                                  showSearchBox: true,
                                  isFilteredOnline: true,
                                  compareFn: (i, s) => i?.isEqual(s) ?? false,
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText: "Fournisseur",
                                    contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                    border: OutlineInputBorder(),
                                  ),
                                  onFind: (String? filter) => getFournisseur(filter),
                                  onChanged: (data) {
                                    fournisseurModel = data;
                                    selectedCodeFournisseur = data?.codeFr;
                                    print('fournisseur: ${fournisseurModel?.activite}, code: ${selectedCodeFournisseur}');
                                  },
                                  dropdownBuilder: customDropDownFournisseur,
                                  popupItemBuilder: customPopupItemBuilderFournisseur,
                                )
                            ),
                            SizedBox(height: 10.0,),
                            Visibility(
                                visible:true,
                                child: DropdownSearch<SiteModel>(
                                  showSelectedItems: true,
                                  showClearButton: true,
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
                                    print('site: ${siteModel?.site}, code: ${selectedCodeSite}');
                                  },
                                  dropdownBuilder: customDropDownSite,
                                  popupItemBuilder: customPopupItemBuilderSite,
                                )
                            ),
                            SizedBox(height: 10.0,),
                            Visibility(
                                visible: true,
                                child: DropdownSearch<ProcessusModel>(
                                  showSelectedItems: true,
                                  showClearButton: true,
                                  showSearchBox: true,
                                  isFilteredOnline: true,
                                  compareFn: (i, s) => i?.isEqual(s) ?? false,
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText: "Processus ",
                                    contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                    border: OutlineInputBorder(),
                                  ),
                                  onFind: (String? filter) => getProcessus(filter),
                                  onChanged: (data) {
                                    processusModel = data;
                                    selectedCodeProcessus = data?.codeProcessus;
                                    print('processus: ${processusModel?.processus}, code: ${selectedCodeProcessus}');
                                  },
                                  dropdownBuilder: customDropDownProcessus,
                                  popupItemBuilder: customPopupItemBuilderProcessus,

                                )
                            ),
                            SizedBox(height: 10.0,),
                            Visibility(
                                visible: true,
                                child: DropdownSearch<DirectionModel>(
                                    showSelectedItems: true,
                                    showClearButton: true,
                                    showSearchBox: true,
                                    isFilteredOnline: true,
                                    compareFn: (i, s) => i?.isEqual(s) ?? false,
                                    dropdownSearchDecoration: InputDecoration(
                                      labelText: "Direction ",
                                      contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                      border: OutlineInputBorder(),
                                    ),
                                    onFind: (String? filter) => getDirection(filter),
                                    onChanged: (data) {
                                      selectedCodeDirection = data?.codeDirection;
                                      directionModel = data;
                                      print('direction: ${directionModel?.direction}, code: ${selectedCodeDirection}');
                                    },
                                    dropdownBuilder: customDropDownDirection,
                                    popupItemBuilder: customPopupItemBuilderDirection,
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
                                visible: true,
                                child: DropdownSearch<ServiceModel>(
                                    showSelectedItems: true,
                                    showClearButton: true,
                                    showSearchBox: true,
                                    isFilteredOnline: true,
                                    compareFn: (i, s) => i?.isEqual(s) ?? false,
                                    dropdownSearchDecoration: InputDecoration(
                                      labelText: "Service",
                                      contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                      border: OutlineInputBorder(),
                                    ),
                                    onFind: (String? filter) => getService(filter),
                                    onChanged: (data) {
                                      selectedCodeService = data?.codeService;
                                      serviceModel = data;
                                      print('service: ${serviceModel?.service}, code: ${selectedCodeService}');
                                    },
                                    dropdownBuilder: customDropDownService,
                                    popupItemBuilder: customPopupItemBuilderService,
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
                                visible: true,
                                child: DropdownSearch<ActivityModel>(
                                    showSelectedItems: true,
                                    showClearButton: true,
                                    showSearchBox: true,
                                    isFilteredOnline: true,
                                    mode: Mode.DIALOG,
                                    compareFn: (i, s) => i?.isEqual(s) ?? false,
                                    dropdownSearchDecoration: InputDecoration(
                                      labelText: "Activity",
                                      contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                      border: OutlineInputBorder(),
                                    ),
                                    onFind: (String? filter) => getActivity(filter),
                                    onChanged: (data) {
                                      selectedCodeActivity = data?.codeDomaine;
                                      activityModel = data;
                                      print('activity:${activityModel?.domaine}, code:${selectedCodeActivity}');
                                    },
                                    dropdownBuilder: customDropDownActivity,
                                    popupItemBuilder: customPopupItemBuilderActivity,
                                    onBeforeChange: (a, b) {
                                      if (b == null) {
                                        AlertDialog alert = AlertDialog(
                                          title: Text("Are you sure..."),
                                          content: Text("...you want to clear the selection"),
                                          actions: [
                                            TextButton(
                                              child: Text("OK"),
                                              onPressed: () {
                                                selectedCodeActivity = 0;
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
                                    setState(() {
                                      isps = data?.value;
                                      print('isps value :${isps}');
                                    });
                                  },
                                  dropdownBuilder: _customDropDownISPS,
                                  popupItemBuilder: _customPopupItemBuilderISPS,

                                )
                            ),
                            SizedBox(height: 10.0,),
                            Visibility(
                                visible: true,
                                child: DropdownSearch<ClientModel>(
                                  showSelectedItems: true,
                                  showClearButton: true,
                                  showSearchBox: true,
                                  isFilteredOnline: true,
                                  compareFn: (i, s) => i?.isEqual(s) ?? false,
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText: "Client",
                                    contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                    border: OutlineInputBorder(),
                                  ),
                                  onFind: (String? filter) => getClient(filter),
                                  onChanged: (data) {
                                    clientModel = data;
                                    selectedCodeClient = data?.codeclt;
                                    print('client: ${clientModel?.nomClient}, code: ${selectedCodeClient}');
                                  },
                                  dropdownBuilder: customDropDownClient,
                                  popupItemBuilder: customPopupItemBuilderClient,
                                )
                            ),
                            SizedBox(height: 10.0,),
                            Visibility(
                              visible: true,
                              child: CheckboxListTile(
                                title: const Text('Produit bloqué'),
                                value: checkProductBloque,
                                onChanged: (bool? value) {
                                  setState(() {
                                    checkProductBloque = value!;
                                    if(checkProductBloque == true){
                                      productBloque = 1;
                                    }
                                    else {
                                      productBloque = 0;
                                    }
                                    print('product bloque ${productBloque}');
                                  });
                                },
                                activeColor: Colors.blue,
                                //secondary: const Icon(Icons.hourglass_empty),
                              ),
                            ),
                            SizedBox(height: 10.0,),
                            Visibility(
                              visible: true,
                              child: CheckboxListTile(
                                title: const Text('Produit isolé'),
                                value: checkProductIsole,
                                onChanged: (bool? value) {
                                  setState(() {
                                    checkProductIsole = value!;
                                    if(checkProductIsole == true){
                                      productIsole = 1;
                                    }
                                    else {
                                      productIsole = 0;
                                    }
                                    print('product isole ${productIsole}');
                                  });
                                },
                                activeColor: Colors.blue,
                                //secondary: const Icon(Icons.hourglass_empty),
                              ),
                            ),
                            SizedBox(height: 10.0,),
                            Visibility(
                              visible: true,
                              child: TextFormField(
                                enabled: false,
                                controller: motifController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                    labelText: 'Motif',
                                    hintText: 'motif',
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
                                enabled: false,
                                controller: decideurController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                    labelText: 'Decideur',
                                    hintText: 'Decideur',
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
                                enabled: false,
                                controller: dateValidationController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                validator: (value) => Validator.validateField(
                                    value: value!
                                ),
                                onChanged: (value){
                                  selectedDateValidation(context);
                                },
                                decoration: InputDecoration(
                                    labelText: 'Date Validation *',
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
                                        selectedDateValidation(context);
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
                            SizedBox(height: 20.0,),
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
                            ElevatedButton(
                              onPressed: () async {
                                saveBtn();
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
                                padding: const EdgeInsets.all(15.0),
                                child: Text('Save',
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
                        )
                    )
                ),
              ),
            ),
          )
      ),
    );
  }

  Future saveBtn() async {
    if(_addItemFormKey.currentState!.validate()){
      try {
        setState(()  {
          _isProcessing = true;
        });

        await pncService.remplirPNCACorriger({
          "nnc": widget.pncModel.nnc,
          "codePdt": selectedCodeProduct,
          "codeTypeNC": selectedCodeType,
          "dateDetect": dateDetectionController.text,
          "nc": ncController.text,
          "recep": detectedEmployeMatricule,
          "qteDetect": int.parse(quantityDetectController.text),
          "unite": uniteController.text,
          "traitement": "",
          "respTrait": "",
          "numOf": numeroOfController.text,
          "delaiTrait": DateFormat('yyyy-MM-dd').format(datePickerDetection),
          "matOrigine": origineNCMatricule,
          "ngravite": selectedCodeGravite,
          "repSuivi": respSuivi,
          "cloturee": 0,
          "codeSite": selectedCodeSite,
          "codeSourceNC": selectedCodeSource,
          "codeTypeT": 79,
          "nLot": numeroLotController.text,
          "nAct": 0,
          "dateClot": DateFormat('yyyy-MM-dd').format(datePickerDetection),
          "rapportClot": "",
          "bloque": productBloque,
          "isole": productIsole,
          "numCession": "",
          "numEnvoi": "",
          "dateSaisie": dateSaisieController.text,
          "matEnreg": matricule.toString(),
          "qtConforme": 0,
          "qtNonConforme": 0,
          "prix": int.parse(prixProductController.text),
          "dateLiv": dateLivraisonController.text,
          "atelier": selectedCodeAtelier,
          "qteprod": int.parse(quantityProductController.text),
          "ninterne": numInterneController.text,
          "saisieClot": DateFormat('yyyy-MM-dd').format(datePickerDetection),
          "det_type": 0,
          "decid": matricule.toString(),
          "avec_retour": 0,
          "processus": selectedCodeProcessus.toString(),
          "domaine": selectedCodeActivity.toString(),
          "direction": selectedCodeDirection.toString(),
          "service": selectedCodeService.toString(),
          "id_client": selectedCodeClient,
          "actionIm": actionPriseController.text,
          "causeNC": causeController.text,
          "isps": isps
        }).then((resp) async {
          ShowSnackBar.snackBar("Successfully", "PNC Corriger", Colors.green);
          //Get.back();
          Get.to(PNCCorrigerPage());
          await ApiControllersCall().getPNCACorriger();
        }, onError: (err) {
          setState(()  {
            _isProcessing = false;
          });
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });

        await pncService.updatePncValidationCorriger({
          "nc": widget.pncModel.nnc,
          "validateur": matricule.toString(),
          "motif": motifController.text,
          "decideur": decideurController.text,
          "dateValidation": dateValidationController.text
        }).then((resp) async {
          //ShowSnackBar.snackBar("Successfully", "PNC Corriger", Colors.green);
        }, onError: (err) {
          setState(()  {
            _isProcessing = false;
          });
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
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

  //Product
  Future<List<ProductModel>> getProduct(filter) async {
    try {
      List<ProductModel> productList = await List<ProductModel>.empty(growable: true);
      List<ProductModel> productFilter = await <ProductModel>[];
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        var response = await LocalActionService().readProduct();
        response.forEach((data){
          var model = ProductModel();
          model.codePdt = data['codePdt'];
          model.produit = data['produit'];
          model.prix = data['prix'];
          model.typeProduit = data['typeProduit'];
          model.codeTypeProduit = data['codeTypeProduit'];
          productList.add(model);
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        await ApiServicesCall().getProduct({
          "codeProduit": "",
          "produit": ""
        }).then((resp) async {
          resp.forEach((data) async {
            var model = ProductModel();
            model.codePdt = data['codePdt'];
            model.produit = data['produit'];
            model.prix = data['prix'];
            model.typeProduit = data['typeProduit'];
            model.codeTypeProduit = data['codeTypeProduit'];
            productList.add(model);
          });
        }
            , onError: (err) {
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });
      }

      productFilter = productList.where((u) {
        var name = u.codePdt.toString().toLowerCase();
        var description = u.produit!.toLowerCase();
        return name.contains(filter) ||
            description.contains(filter);
      }).toList();
      return productFilter;
    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }
  Widget customDropDownProduct(BuildContext context, ProductModel? item) {
    if (item == null) {
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${productNC}'),
        ),
      );
    }
    else{
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${item.produit}'),
          //subtitle: Text('${item?.codePdt}'),
        ),
      );
    }
  }
  Widget customPopupItemBuilderProduct(
      BuildContext context, ProductModel? item, bool isSelected) {
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
        title: Text(item?.produit ?? ''),
        subtitle: Text(item?.codePdt.toString() ?? ''),
      ),
    );
  }
  //Employe
  Future<List<EmployeModel>> getEmploye(filter) async {
    try {
      List<EmployeModel> employeList = await List<EmployeModel>.empty(growable: true);
      List<EmployeModel>employeFilter = await List<EmployeModel>.empty(growable: true);
      var response = await LocalActionService().readEmploye();
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
  Widget customDropDownDetectEmploye(BuildContext context, EmployeModel? item) {

    if (item == null) {
      return Container(
          child: ListTile(
            contentPadding: EdgeInsets.all(0),
            title: Text('${detectedEmployeNomPrenom}', style: TextStyle(color: Colors.black)),
          )
      );
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
  }
  Widget customDropDownEmploye(BuildContext context, EmployeModel? item) {

    if (item == null) {
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${origineNCNomPrenom}', style: TextStyle(color: Colors.black)),
        ),
      );
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
  }
  //typenc
  Future<List<TypePNCModel>> getTypePNC(filter) async {
    try {
      List<TypePNCModel> _typeList = await List<TypePNCModel>.empty(growable: true);
      List<TypePNCModel> _typeFilter = await List<TypePNCModel>.empty(growable: true);
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        var response = await LocalPNCService().readTypePNC();
        response.forEach((data){
          var model = TypePNCModel();
          model.codeTypeNC = data['codeTypeNC'];
          model.typeNC = data['typeNC'];
          model.color = data['color'];
          _typeList.add(model);
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        await ApiServicesCall().getTypePNC().then((resp) async {
          resp.forEach((data) async {
            var model = TypePNCModel();
            model.codeTypeNC = data['codeTypeNC'];
            model.typeNC = data['typeNC'];
            model.color = data['color'];
            _typeList.add(model);
          });
        }
            , onError: (err) {
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });
      }
      _typeFilter = _typeList.where((u) {
        var query = u.typeNC!.toLowerCase();
        return query.contains(filter);
      }).toList();
      return _typeFilter;

    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }
  Widget customDropDownType(BuildContext context, TypePNCModel? item) {
    if (item == null) {
      return Container(
          child: ListTile(
            contentPadding: EdgeInsets.all(0),
            title: Text('${typeNC}', style: TextStyle(color: Colors.black)),
          )
      );
    }
    else{
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${item.typeNC}'),
        ),
      );
    }
  }
  Widget customPopupItemBuilderType(
      BuildContext context, TypePNCModel? item, bool isSelected) {
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
        title: Text(item?.typeNC ?? ''),
        subtitle: Text(item?.codeTypeNC.toString() ?? ''),
      ),
    );
  }
  //ISPS
  Future<List<ISPSPNCModel>> getISPS(filter) async {
    try {
      List<ISPSPNCModel> ispsList = [
        ISPSPNCModel(value: "0", name: ""),
        ISPSPNCModel(value: "1", name: "OUI"),
        ISPSPNCModel(value: "2", name: "NON"),
        ISPSPNCModel(value: "3", name: "Non Applicable"),
      ];

      return ispsList;
    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }
  Widget _customDropDownISPS(BuildContext context, ISPSPNCModel? item) {
    if (item == null) {
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${isps_name}'),
        ),
      );
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
  //gravite
  Future<List<GravitePNCModel>> getGravitePNC(filter) async {
    try {
      List<GravitePNCModel> _graviteList = await List<GravitePNCModel>.empty(growable: true);
      List<GravitePNCModel> _graviteFilter = await List<GravitePNCModel>.empty(growable: true);
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        var response = await LocalPNCService().readGravitePNC();
        response.forEach((data){
          var model = GravitePNCModel();
          model.nGravite = data['nGravite'];
          model.gravite = data['gravite'];
          _graviteList.add(model);
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        await ApiServicesCall().getGravitePNC().then((resp) async {
          resp.forEach((data) async {
            var model = GravitePNCModel();
            model.nGravite = data['nGravite'];
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
  Widget customDropDownGravite(BuildContext context, GravitePNCModel? item) {
    if (item == null) {
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${graviteNC}'),
        ),
      );
    }
    else{
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${item.gravite}'),
        ),
      );
    }
  }
  Widget customPopupItemBuilderGravite(
      BuildContext context, GravitePNCModel? item, bool isSelected) {
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
        title: Text(item?.gravite ?? ''),
        subtitle: Text(item?.nGravite.toString() ?? ''),
      ),
    );
  }
  //source
  Future<List<SourcePNCModel>> getSource(filter) async {
    try {
      List<SourcePNCModel> sourceList = await List<SourcePNCModel>.empty(growable: true);
      List<SourcePNCModel> sourceFilter = await <SourcePNCModel>[];
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        var response = await LocalPNCService().readSourcePNC();
        response.forEach((data){
          var model = SourcePNCModel();
          model.codeSourceNC = data['codeSourceNC'];
          model.sourceNC = data['sourceNC'];
          sourceList.add(model);
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        await ApiServicesCall().getSourcePNC().then((resp) async {
          resp.forEach((data) async {
            var model = SourcePNCModel();
            model.codeSourceNC = data['codeSourceNC'];
            model.sourceNC = data['sourceNC'];
            sourceList.add(model);
          });
        }
            , onError: (err) {
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });
      }

      sourceFilter = sourceList.where((u) {
        var name = u.codeSourceNC.toString().toLowerCase();
        var description = u.sourceNC!.toLowerCase();
        return name.contains(filter) ||
            description.contains(filter);
      }).toList();
      return sourceFilter;
    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }
  Widget customDropDownSource(BuildContext context, SourcePNCModel? item) {
    if (item == null) {
      return Container(
          child: ListTile(
            contentPadding: EdgeInsets.all(0),
            title: Text('${sourceNC}'),
          )
      );
    }
    else{
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${item.sourceNC}'),
        ),
      );
    }
  }
  Widget customPopupItemBuilderSource(
      BuildContext context, SourcePNCModel? item, bool isSelected) {
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
        title: Text(item?.sourceNC ?? ''),
        subtitle: Text(item?.codeSourceNC.toString() ?? ''),
      ),
    );
  }
  //atelier
  Future<List<AtelierPNCModel>> getAtelier(filter) async {
    try {
      List<AtelierPNCModel> _atelierList = await List<AtelierPNCModel>.empty(growable: true);
      List<AtelierPNCModel> _atelierFilter = await List<AtelierPNCModel>.empty(growable: true);
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        var response = await LocalPNCService().readAtelierPNC();
        response.forEach((data){
          var model = AtelierPNCModel();
          model.codeAtelier = data['codeAtelier'];
          model.atelier = data['atelier'];
          _atelierList.add(model);
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        await ApiServicesCall().getAtelierPNC().then((resp) async {
          resp.forEach((data) async {
            var model = AtelierPNCModel();
            model.codeAtelier = data['codeAtelier'];
            model.atelier = data['atelier'];
            _atelierList.add(model);
          });
        }
            , onError: (err) {
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });
      }
      _atelierFilter = _atelierList.where((u) {
        var query = u.atelier!.toLowerCase();
        return query.contains(filter);
      }).toList();
      return _atelierFilter;

    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }
  Widget customDropDownAtelier(BuildContext context, AtelierPNCModel? item) {
    if (item == null) {
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${atelierNC}'),
        ),
      );
    }
    else{
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${item.atelier}'),
        ),
      );
    }
  }
  Widget customPopupItemBuilderAtelier(
      BuildContext context, AtelierPNCModel? item, bool isSelected) {
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
        title: Text(item?.atelier ?? ''),
        subtitle: Text(item?.codeAtelier.toString() ?? ''),
      ),
    );
  }
  //fournisseur
  Future<List<FournisseurModel>> getFournisseur(filter) async {
    try {
      List<FournisseurModel> fournisseurList = await List<FournisseurModel>.empty(growable: true);
      List<FournisseurModel> fournisseurFilter = await <FournisseurModel>[];
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        var response = await LocalPNCService().readFournisseur();
        response.forEach((data){
          var model = FournisseurModel();
          model.raisonSociale = data['raisonSociale'];
          model.activite = data['activite'];
          model.codeFr = data['codeFr'];
          fournisseurList.add(model);
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        await ApiServicesCall().getFournisseurs(matricule).then((resp) async {
          resp.forEach((data) async {
            var model = FournisseurModel();
            model.raisonSociale = data['raisonSociale'];
            model.activite = data['activite'];
            model.codeFr = data['codeFr'];
            fournisseurList.add(model);
          });
        }
            , onError: (err) {
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });
      }

      fournisseurFilter = fournisseurList.where((u) {
        var name = u.activite.toString().toLowerCase();
        var description = u.codeFr!.toLowerCase();
        return name.contains(filter) ||
            description.contains(filter);
      }).toList();
      return fournisseurFilter;
    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }
  Widget customDropDownFournisseur(BuildContext context, FournisseurModel? item) {
    if (item == null) {
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${fournisseurNC}'),
        ),
      );
    }
    else{
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${item.raisonSociale}'),
        ),
      );
    }
  }
  Widget customPopupItemBuilderFournisseur(
      BuildContext context, FournisseurModel? item, bool isSelected) {
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
        title: Text(item?.raisonSociale ?? ''),
        subtitle: Text(item?.codeFr.toString() ?? ''),
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
        var sites = await LocalActionService().readSiteByModule("PNC", "PNC");
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
          "mat": matricule.toString(),
          "modul": "PNC",
          "site": "0",
          "agenda": 0,
          "fiche": "PNC"
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
  Widget customDropDownSite(BuildContext context, SiteModel? item) {
    if (item == null) {
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${siteNC}', style: TextStyle(color: Colors.black),),
        ),
      );
    }
    else{
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${item.site}', style: TextStyle(color: Colors.black),),
        ),
      );
    }
  }
  Widget customPopupItemBuilderSite(
      BuildContext context, SiteModel? item, bool isSelected) {
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
        title: Text(item?.site ?? ''),
        subtitle: Text(item?.codesite.toString() ?? ''),
      ),
    );
  }
  //Processus
  Future<List<ProcessusModel>> getProcessus(filter) async {
    try {
      List<ProcessusModel> processusList = await List<ProcessusModel>.empty(growable: true);
      List<ProcessusModel> processusFilter = await <ProcessusModel>[];
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        var sites = await LocalActionService().readProcessusByModule("PNC", "PNC");
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
          "mat": matricule.toString(),
          "modul": "PNC",
          "processus": "0",
          "fiche": "PNC"
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
  Widget customDropDownProcessus(BuildContext context, ProcessusModel? item) {
    if (item == null) {
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${processusNC}', style: TextStyle(color: Colors.black),),
        ),
      );
    }
    else{
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${item.processus}', style: TextStyle(color: Colors.black),),
        ),
      );
    }
  }
  Widget customPopupItemBuilderProcessus(
      BuildContext context, ProcessusModel? item, bool isSelected) {
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
        title: Text(item?.processus ?? ''),
        subtitle: Text(item?.codeProcessus.toString() ?? ''),
      ),
    );
  }
  //Direction
  Future<List<DirectionModel>> getDirection(filter) async {
    try {
      List<DirectionModel> directionList = await List<DirectionModel>.empty(growable: true);
      List<DirectionModel> directionFilter = await <DirectionModel>[];
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        var response = await LocalActionService().readDirectionByModule("PNC", "PNC");
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
          "mat": matricule.toString(),
          "modul": "PNC",
          "fiche": "PNC",
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
  Widget customDropDownDirection(BuildContext context, DirectionModel? item) {
    if (item == null) {
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${directionNC}', style: TextStyle(color: Colors.black),),
        ),
      );
    }
    else{
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${item.direction}', style: TextStyle(color: Colors.black),),
        ),
      );
    }
  }
  Widget customPopupItemBuilderDirection(
      BuildContext context, DirectionModel? item, bool isSelected) {
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
        title: Text(item?.direction ?? ''),
        subtitle: Text(item?.codeDirection.toString() ?? ''),
      ),
    );
  }
  //Service
  Future<List<ServiceModel>> getService(filter) async {
    try {
      List<ServiceModel> serviceList = await List<ServiceModel>.empty(growable: true);
      List<ServiceModel> serviceFilter = await List<ServiceModel>.empty(growable: true);

      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        var response = await LocalActionService().readServiceByModuleAndDirection('PNC', 'PNC', selectedCodeDirection);
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
        await ApiServicesCall().getService(matricule, selectedCodeDirection, 'PNC', 'PNC')
            .then((resp) async {
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
  Widget customDropDownService(BuildContext context, ServiceModel? item) {
    if (item == null) {
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${serviceNC}', style: TextStyle(color: Colors.black),),
        ),
      );
    }
    else{
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${item.service}', style: TextStyle(color: Colors.black),),
        ),
      );
    }
  }
  Widget customPopupItemBuilderService(
      BuildContext context, ServiceModel? item, bool isSelected) {
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
        title: Text(item?.service ?? ''),
        subtitle: Text(item?.codeService.toString() ?? ''),
      ),
    );
  }
  //Activity
  Future<List<ActivityModel>> getActivity(filter) async {
    try {
      List<ActivityModel> activityList = await List<ActivityModel>.empty(growable: true);
      List<ActivityModel> activityFilter = await <ActivityModel>[];

      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        var response = await LocalActionService().readActivityByModule("PNC", "PNC");
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
          "mat": matricule.toString(),
          "modul": "PNC",
          "fiche": "PNC",
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
  Widget customDropDownActivity(BuildContext context, ActivityModel? item) {
    if (item == null) {
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${activityNC}'),
        ),
      );
    }
    else{
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${item.domaine}'),
        ),
      );
    }
  }
  Widget customPopupItemBuilderActivity(
      BuildContext context, ActivityModel? item, bool isSelected) {
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
        title: Text(item?.domaine ?? ''),
        subtitle: Text(item?.codeDomaine.toString() ?? ''),
      ),
    );
  }
  //client
  Future<List<ClientModel>> getClient(filter) async {
    try {
      List<ClientModel> clientList = await List<ClientModel>.empty(growable: true);
      List<ClientModel> clientFilter = await <ClientModel>[];
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        var response = await LocalPNCService().readClient();
        response.forEach((data){
          var model = ClientModel();
          model.codeclt = data['codeclt'];
          model.nomClient = data['nomClient'];
          clientList.add(model);
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        await ApiServicesCall().getClients().then((resp) async {
          resp.forEach((data) async {
            var model = ClientModel();
            model.codeclt = data['codeclt'];
            model.nomClient = data['nomClient'];
            clientList.add(model);
          });
        }
            , onError: (err) {
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });
      }

      clientFilter = clientList.where((u) {
        var name = u.codeclt.toString().toLowerCase();
        var description = u.nomClient!.toLowerCase();
        return name.contains(filter) ||
            description.contains(filter);
      }).toList();
      return clientFilter;
    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }
  Widget customDropDownClient(BuildContext context, ClientModel? item) {
    if (item == null) {
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${clientNC}'),
        ),
      );
    }
    else{
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${item.nomClient}'),
          //subtitle: Text('${item?.codeclt}'),
        ),
      );
    }
  }
  Widget customPopupItemBuilderClient(
      BuildContext context, ClientModel? item, bool isSelected) {
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
        title: Text(item?.nomClient ?? ''),
        subtitle: Text(item?.codeclt.toString() ?? ''),
      ),
    );
  }
}
