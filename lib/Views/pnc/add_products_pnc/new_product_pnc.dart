import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Services/action/local_action_service.dart';
import '../../../../Utils/custom_colors.dart';
import '../../../../Utils/shared_preference.dart';
import '../../../../Utils/snack_bar.dart';
import '../../../Models/pnc/champ_obligatoire_pnc_model.dart';
import '../../../Models/product_model.dart';
import '../../../Services/api_services_call.dart';
import '../../../Services/pnc/local_pnc_service.dart';
import '../../../Services/pnc/pnc_service.dart';
import '../../../Utils/message.dart';
import 'products_pnc_page.dart';

class NewProductPNC extends StatefulWidget {
  final nnc;
  const NewProductPNC({Key? key, this.nnc}) : super(key: key);

  @override
  State<NewProductPNC> createState() => _NewProductPNCState();
}

class _NewProductPNCState extends State<NewProductPNC> {
  final _addItemFormKey = GlobalKey<FormState>();
  bool _isProcessing = false;
  final matricule = SharedPreference.getMatricule();
  LocalPNCService localPNCService = LocalPNCService();
  PNCService pncService = PNCService();
//product
  ProductModel? productModel = null;
  String? selectedCodeProduct = "";
  TextEditingController uniteController = TextEditingController();
  TextEditingController numeroOfController = TextEditingController();
  TextEditingController numeroLotController = TextEditingController();
  TextEditingController quantityDetectController = TextEditingController();
  TextEditingController quantityProductController = TextEditingController();
  int quantity_detect = 0;
  int quantity_product = 0;

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    getChampObligatoire();
  }

  //champ obligatoire
  int? num_of_obligatoire = 1;
  int? num_lot_obligatoire = 1;
  int? qte_detect_obligatoire = 1;
  int? qte_produit_obligatoire = 1;
  int? unite_obligatoire = 1;
  getChampObligatoire() async {
    List<ChampObligatoirePNCModel> champObligatoireList =
        await List<ChampObligatoirePNCModel>.empty(growable: true);
    var connection = await Connectivity().checkConnectivity();
    if (connection == ConnectivityResult.none) {
      var response = await localPNCService.readChampObligatoirePNC();
      response.forEach((data) {
        setState(() {
          var model = ChampObligatoirePNCModel();
          model.numInterne = data['numInterne'];
          model.enregistre = data['enregistre'];
          model.dateLivr = data['dateLivr'];
          model.numOf = data['numOf'];
          model.numLot = data['numLot'];
          model.fournisseur = data['fournisseur'];
          model.qteDetect = data['qteDetect'];
          model.qteProduite = data['qteProduite'];
          model.unite = data['unite'];
          model.gravite = data['gravite'];
          model.source = data['source'];
          model.atelier = data['atelier'];
          model.origine = data['origine'];
          model.nonConf = data['nonConf'];
          model.traitNc = data['traitNc'];
          model.typeTrait = data['typeTrait'];
          model.respTrait = data['respTrait'];
          model.delaiTrait = data['delaiTrait'];
          model.respSuivi = data['respSuivi'];
          model.datTrait = data['datTrait'];
          model.coutTrait = data['coutTrait'];
          model.quantite = data['quantite'];
          model.valeur = data['valeur'];
          model.rapTrait = data['rapTrait'];
          model.datClo = data['datClo'];
          model.rapClo = data['rapClo'];
          model.pourcTypenc = data['pourcTypenc'];
          model.detectPar = data['detectPar'];

          num_of_obligatoire = model.numOf;
          num_lot_obligatoire = model.numLot;
          qte_detect_obligatoire = model.qteDetect;
          qte_produit_obligatoire = model.qteProduite;
          unite_obligatoire = model.unite;

          debugPrint('champ obligatoire PNC : ${data}');
        });
      });
    } else if (connection == ConnectivityResult.wifi ||
        connection == ConnectivityResult.mobile) {
      await ApiServicesCall().getChampObligatoirePNC().then((data) async {
        setState(() {
          var model = ChampObligatoirePNCModel();
          model.numInterne = data['num_interne'];
          model.enregistre = data['enregistre'];
          model.dateLivr = data['date_livr'];
          model.numOf = data['num_of'];
          model.numLot = data['num_lot'];
          model.fournisseur = data['fournisseur'];
          model.qteDetect = data['qte_detect'];
          model.qteProduite = data['qte_produite'];
          model.unite = data['unite'];
          model.gravite = data['gravite'];
          model.source = data['source'];
          model.atelier = data['atelier'];
          model.origine = data['origine'];
          model.nonConf = data['non_conf'];
          model.traitNc = data['trait_nc'];
          model.typeTrait = data['type_trait'];
          model.respTrait = data['resp_trait'];
          model.delaiTrait = data['delai_trait'];
          model.respSuivi = data['resp_suivi'];
          model.datTrait = data['dat_trait'];
          model.coutTrait = data['cout_trait'];
          model.quantite = data['quantite'];
          model.valeur = data['valeur'];
          model.rapTrait = data['rap_trait'];
          model.datClo = data['dat_clo'];
          model.rapClo = data['rap_clo'];
          model.pourcTypenc = data['pourc_typenc'];
          model.detectPar = data['detect_par'];

          num_of_obligatoire = model.numOf;
          num_lot_obligatoire = model.numLot;
          qte_detect_obligatoire = model.qteDetect;
          qte_produit_obligatoire = model.qteProduite;
          unite_obligatoire = model.unite;
          print('champ obligatoire PNC : ${data}');
        });
      }, onError: (err) {
        ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
      });
    }
  }

  bool _dataValidation() {
    if (num_of_obligatoire == 1 && numeroOfController.text.trim() == '') {
      Message.taskErrorOrWarning("Numero Of", "Numero Of is required");
      return false;
    } else if (num_lot_obligatoire == 1 &&
        numeroLotController.text.trim() == '') {
      Message.taskErrorOrWarning("Numero Lot", "Numero Lot is required");
      return false;
    } else if (unite_obligatoire == 1 && uniteController.text.trim() == '') {
      Message.taskErrorOrWarning("Unite", "Unite is required");
      return false;
    } else if (qte_detect_obligatoire == 1 &&
        quantityProductController.text.trim() == '') {
      Message.taskErrorOrWarning(
          "Quantity Detect", "Quantity Detect is required");
      return false;
    } else if (qte_produit_obligatoire == 1 &&
        quantityProductController.text.trim() == '') {
      Message.taskErrorOrWarning(
          "Quantity Product", "Quantity Product is required");
      return false;
    }

    quantity_detect = int.parse(quantityDetectController.text.toString());
    quantity_product = int.parse(quantityProductController.text.toString());
    if (quantityDetectController.text.trim() == '') {
      quantity_detect = 0;
    } else if (quantityProductController.text.trim() == '') {
      quantity_product = 0;
    } else if (quantity_detect > quantity_product) {
      Message.taskErrorOrWarning("Quantity invalid",
          "Quantity product must be greater or equal quantity detected ");
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        leading: TextButton(
          onPressed: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Text(
          "New Product of P.N.C N°${widget.nnc}",
          textAlign: TextAlign.center,
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
                        SizedBox(
                          height: 8.0,
                        ),
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
                                contentPadding:
                                    EdgeInsets.fromLTRB(12, 12, 0, 0),
                                border: OutlineInputBorder(),
                              ),
                              onFind: (String? filter) => getProduct(filter),
                              onChanged: (data) {
                                productModel = data;
                                selectedCodeProduct = data?.codePdt;
                                print(
                                    'product: ${productModel?.produit}, code: ${selectedCodeProduct}');
                              },
                              dropdownBuilder: _customDropDownProduct,
                              popupItemBuilder: _customPopupItemBuilderProduct,
                              validator: (u) =>
                                  u == null ? "Product is required " : null,
                            )),
                        SizedBox(
                          height: 10.0,
                        ),
                        Visibility(
                          visible: true,
                          child: TextFormField(
                            controller: numeroOfController,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                labelText:
                                    'Numero Of ${num_of_obligatoire == 1 ? '*' : ''}',
                                hintText: 'num of',
                                labelStyle: TextStyle(
                                  fontSize: 14.0,
                                ),
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10.0,
                                ),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.lightBlue, width: 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)))),
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Visibility(
                          visible: true,
                          child: TextFormField(
                            controller: numeroLotController,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                labelText:
                                    'Numero Lot ${num_lot_obligatoire == 1 ? '*' : ''}',
                                hintText: 'num lot',
                                labelStyle: TextStyle(
                                  fontSize: 14.0,
                                ),
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10.0,
                                ),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.lightBlue, width: 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)))),
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Visibility(
                          visible: true,
                          child: TextFormField(
                            controller: uniteController,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                labelText:
                                    'Unite ${unite_obligatoire == 1 ? '*' : ''}',
                                hintText: 'unite',
                                labelStyle: TextStyle(
                                  fontSize: 14.0,
                                ),
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10.0,
                                ),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.lightBlue, width: 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)))),
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Visibility(
                          visible: true,
                          child: TextFormField(
                            controller: quantityDetectController,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText:
                                  'Quantity detect ${qte_detect_obligatoire == 1 ? '*' : ''}',
                              hintText: 'quantity',
                              labelStyle: TextStyle(
                                fontSize: 14.0,
                              ),
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 10.0,
                              ),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.lightBlue, width: 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            ),
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Visibility(
                          visible: true,
                          child: TextFormField(
                            controller: quantityProductController,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText:
                                  'Quantity Product ${qte_produit_obligatoire == 1 ? '*' : ''}',
                              hintText: 'quantity',
                              labelStyle: TextStyle(
                                fontSize: 14.0,
                              ),
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 10.0,
                              ),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.lightBlue, width: 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            ),
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        _isProcessing
                            ? Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    CustomColors.firebaseOrange,
                                  ),
                                ),
                              )
                            : ElevatedButton(
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
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Save',
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
                    ))),
          ),
        ),
      )),
    );
  }

  Future saveBtn() async {
    if (_dataValidation() && _addItemFormKey.currentState!.validate()) {
      try {
        setState(() {
          _isProcessing = true;
        });
        await pncService.addProductNC({
          "nnc": widget.nnc,
          "codeProduit": selectedCodeProduct,
          "qDetect": quantity_detect,
          "unite": uniteController.text.toString(),
          "nof": numeroOfController.text,
          "lot": numeroLotController.text,
          "qProd": quantity_product
        }).then((resp) async {
          ShowSnackBar.snackBar("Successfully", "Product added", Colors.green);
          //Get.back();
          Get.offAll(ProductsPNCPage(nnc: widget.nnc));
        }, onError: (err) {
          _isProcessing = false;
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
      } catch (ex) {
        _isProcessing = false;
        AwesomeDialog(
          context: context,
          animType: AnimType.SCALE,
          dialogType: DialogType.ERROR,
          body: Center(
            child: Text(
              ex.toString(),
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          title: 'Error',
          btnCancel: Text('Cancel'),
          btnOkOnPress: () {
            Navigator.of(context).pop();
          },
        )..show();
        print("throwing new error " + ex.toString());
        throw Exception("Error " + ex.toString());
      } finally {
        _isProcessing = false;
      }
    }
  }

  //Product
  Future<List<ProductModel>> getProduct(filter) async {
    try {
      List<ProductModel> productList =
          await List<ProductModel>.empty(growable: true);
      List<ProductModel> productFilter = await <ProductModel>[];
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        var response = await LocalActionService().readProduct();
        response.forEach((data) {
          var model = ProductModel();
          model.codePdt = data['codePdt'];
          model.produit = data['produit'];
          model.prix = data['prix'];
          model.typeProduit = data['typeProduit'];
          model.codeTypeProduit = data['codeTypeProduit'];
          productList.add(model);
        });
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        await ApiServicesCall()
            .getProduct({"codeProduit": "", "produit": ""}).then((resp) async {
          resp.forEach((data) async {
            var model = ProductModel();
            model.codePdt = data['codePdt'];
            model.produit = data['produit'];
            model.prix = data['prix'];
            model.typeProduit = data['typeProduit'];
            model.codeTypeProduit = data['codeTypeProduit'];
            productList.add(model);
          });
        }, onError: (err) {
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
      }

      productFilter = productList.where((u) {
        var name = u.codePdt.toString().toLowerCase();
        var description = u.produit!.toLowerCase();
        return name.contains(filter) || description.contains(filter);
      }).toList();
      return productFilter;
    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }

  Widget _customDropDownProduct(BuildContext context, ProductModel? item) {
    if (productModel == null) {
      return Container();
    } else {
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${productModel?.produit}'),
          subtitle: Text('${productModel?.codePdt}'),
        ),
      );
    }
  }

  Widget _customPopupItemBuilderProduct(
      BuildContext context, productModel, bool isSelected) {
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
        title: Text(productModel?.produit ?? ''),
        subtitle: Text(productModel?.codePdt.toString() ?? ''),
      ),
    );
  }
}
