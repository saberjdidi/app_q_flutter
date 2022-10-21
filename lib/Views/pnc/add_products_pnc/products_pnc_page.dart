import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:qualipro_flutter/Models/employe_model.dart';
import 'package:qualipro_flutter/Services/pnc/local_pnc_service.dart';
import '../../../../Services/action/action_service.dart';
import '../../../../Services/action/local_action_service.dart';
import '../../../../Utils/shared_preference.dart';
import '../../../../Utils/snack_bar.dart';
import '../../../Controllers/pnc/pnc_controller.dart';
import '../../../Models/pnc/champ_obligatoire_pnc_model.dart';
import '../../../Models/pnc/product_pnc_model.dart';
import '../../../Models/product_model.dart';
import '../../../Route/app_route.dart';
import '../../../Services/api_services_call.dart';
import '../../../Services/pnc/pnc_service.dart';
import '../../../Utils/custom_colors.dart';
import '../../../Utils/message.dart';
import '../type_product_nc/type_product_pnc_page.dart';
import 'new_product_pnc.dart';

class ProductsPNCPage extends StatefulWidget {
  final nnc;

 const ProductsPNCPage({Key? key, required this.nnc}) : super(key: key);

  @override
  State<ProductsPNCPage> createState() => _ProductsPNCPageState();
}

class _ProductsPNCPageState extends State<ProductsPNCPage> {

  LocalPNCService localPNCService = LocalPNCService();
  final matricule = SharedPreference.getMatricule();
  List<ProductPNCModel> productList = List<ProductPNCModel>.empty(growable: true);
  int paramProduct = 0;
  bool isVisibleNewProduct = true;
  bool isVisibleDeleteButton = true;

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    getProducts();
    parametrageProduct();
    getChampObligatoire();
  }
  Future<void> checkConnectivity() async {
    var connection = await Connectivity().checkConnectivity();
    if (connection == ConnectivityResult.none) {
      //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.BOTTOM, duration: Duration(milliseconds: 900));
      setState(() {
        isVisibleNewProduct = false;
      });
    }
    else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
      //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.BOTTOM, duration: Duration(milliseconds: 900));
    }
  }
  void getProducts() async {
    try {
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
       if(kDebugMode) print('nnc : ${widget.nnc}');
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        var response = await localPNCService.readProductByNNC(widget.nnc);
        response.forEach((data){
          setState(() {
            var model = ProductPNCModel();
            model.nnc = data['nnc'];
            model.idNCProduct = data['idNCProduct'];
            model.codeProduit = data['codeProduit'];
            model.produit = data['produit'];
            model.numOf = data['numOf'];
            model.numLot = data['numLot'];
            model.qdetect = data['qdetect'];
            model.qprod = data['qprod'];
            model.typeProduit = data['typeProduit'];
            model.unite = data['unite'];
            productList.add(model);
            isVisibleDeleteButton = false;
          });
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        await PNCService().getProductsPNC(widget.nnc, matricule).then((resp) async {
          resp.forEach((data) async {
            setState(() {
              var model = ProductPNCModel();
              model.idNCProduct = data['id_tab_nc_produit'];
              model.codeProduit = data['codeProduit'];
              model.produit = data['produit'];
              model.numOf = data['nof'];
              model.numLot = data['lot'];
              model.qdetect = data['qdetect'];
              model.qprod = data['qprod'];
              model.typeProduit = data['typeProduit'];
              model.unite = data['unite'];
              model.typeNC = data['typeNC'];
              productList.add(model);
              isVisibleDeleteButton = true;
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

  parametrageProduct() async {
    var connection = await Connectivity().checkConnectivity();
    if(connection == ConnectivityResult.none){
      paramProduct = SharedPreference.getIsOneProduct()!;
      if(paramProduct == 0){
        setState(() {
          isVisibleNewProduct = true;
        });
      } else {
        setState(() {
          isVisibleNewProduct = false;
        });
      }
      print('parametre Product : ${paramProduct}');
    }
    else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
      await PNCService().parametrageProduct().then((params) async {
        paramProduct = params['seulProduit'];
        if(paramProduct == 0){
          setState(() {
            isVisibleNewProduct = true;
          });
        } else {
          setState(() {
            isVisibleNewProduct = false;
          });
        }
        print('parametre Product : ${paramProduct}');
      }
          , onError: (err) {
            ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
          });
    }

  }

  //champ obligatoire
  int num_of_obligatoire = 0;
  int num_lot_obligatoire = 0;
  int qte_detect_obligatoire = 0;
  int qte_produit_obligatoire = 0;
  int unite_obligatoire = 0;
  getChampObligatoire() async {
    List<ChampObligatoirePNCModel> champObligatoireList = await List<
        ChampObligatoirePNCModel>.empty(growable: true);
    var connection = await Connectivity().checkConnectivity();
    if (connection == ConnectivityResult.none) {
      var response = await LocalPNCService().readChampObligatoirePNC();
      response.forEach((data) {
        setState(() {
          var model = ChampObligatoirePNCModel();
          model.numInterne = data['numInterne'];
          model.unite = data['unite'];
          model.numOf = data['numOf'];
          model.numLot = data['numLot'];
          model.qteDetect = data['qteDetect'];
          model.qteProduite = data['qteProduite'];

          num_of_obligatoire = model.numOf!;
          num_lot_obligatoire = model.numLot!;
          qte_detect_obligatoire = model.qteDetect!;
          qte_produit_obligatoire = model.qteProduite!;
          unite_obligatoire = model.unite!;

          print('champ obligatoire PNC : ${data}');
        });
      });
    }
    else if (connection == ConnectivityResult.wifi ||
        connection == ConnectivityResult.mobile) {
      await ApiServicesCall().getChampObligatoirePNC().then((data) async {
        setState(() {
          var model = ChampObligatoirePNCModel();
          model.numInterne = data['num_interne'];
          model.numOf = data['num_of'];
          model.numLot = data['num_lot'];
          model.qteDetect = data['qte_detect'];
          model.qteProduite = data['qte_produite'];
          model.unite = data['unite'];

          num_of_obligatoire = model.numOf!;
          num_lot_obligatoire = model.numLot!;
          qte_detect_obligatoire = model.qteDetect!;
          qte_produit_obligatoire = model.qteProduite!;
          unite_obligatoire = model.unite!;
          print('champ obligatoire PNC : ${data}');
        });
      }
          , onError: (err) {
            ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
          });
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
        appBar: AppBar(
          centerTitle: true,
          leading: TextButton(
            onPressed: (){
             /* Get.find<PNCController>().listPNC.clear();
              Get.find<PNCController>().getPNC();
              Get.offAllNamed(AppRoute.pnc); */
              Get.back();
            },
            child: Icon(Icons.arrow_back, color: Colors.white,),
          ),
          title: Text(
            'Products of N.C N°${widget.nnc}',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.lightBlue,
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: productList.isNotEmpty ?
            Container(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Column(
                      children: [
                        ListTile(
                          title: Text(
                            'Produit : ${productList[index].produit}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
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
                                      TextSpan(text: 'Code : ${productList[index].codeProduit}'),

                                      //TextSpan(text: '${action.declencheur}'),
                                    ],

                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 3.0),
                                child: Text(
                                  "Numero Of : ${productList[index].numOf}",
                                  style: TextStyle(
                                      color: Color(0xFF3B465E),
                                      fontWeight: FontWeight.bold),

                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 3.0),
                                child: Text(
                                  "Numero Lot : ${productList[index].numLot}",
                                  style: TextStyle(
                                      color: Color(0xFF3B465E),
                                      fontWeight: FontWeight.bold),

                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 3.0),
                                child: Text(
                                  "Qte Produite : ${productList[index].qprod}",
                                  style: TextStyle(
                                      color: Color(0xFF3B465E),
                                      fontWeight: FontWeight.bold),

                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 3.0),
                                child: Text(
                                  "Qte Détectée : ${productList[index].qdetect}",
                                  style: TextStyle(
                                      color: Color(0xFF3B465E),
                                      fontWeight: FontWeight.bold),

                                ),
                              ),
                            ],
                          ),
                          trailing: Wrap(
                            spacing: 1.0,
                            runSpacing: 1.0,
                            direction: Axis.horizontal,
                            children: <Widget>[
                              IconButton(
                                onPressed: () async {
                                  Get.to(TypeProductPNCPage(nnc: widget.nnc, code_product: productList[index].codeProduit, product: productList[index].produit, id_product: productList[index].idNCProduct,));
                                },
                                icon: Icon(Icons.remove_red_eye, color: Colors.blue,),
                                tooltip: 'Types NC',
                              ),
                              Visibility(
                                visible: isVisibleNewProduct && isVisibleDeleteButton,
                                child: IconButton(
                                  onPressed: () async {
                                    deleteProductNC(context, productList[index].idNCProduct);
                                  },
                                  icon: Icon(Icons.delete, color: Colors.red,),
                                  tooltip: 'Delete',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 1.0,
                          color: Colors.blue,
                        ),
                      ],
                    );
                },
                itemCount: productList.length,
                //itemCount: actionsList.length + 1,
              ),
            )
                : Center(
              child: Text('empty_list'.tr,
                  style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'Brand-Bold'
            )),
            )
        ),
        floatingActionButton: Container(
          padding: EdgeInsets.only(bottom: 10.0),
          child: Visibility(
            visible: isVisibleNewProduct,
            child: FloatingActionButton(
              onPressed: (){
                //Get.to(NewProductPNC(nnc: widget.nnc,));
                //new product
                final _addItemFormKey = GlobalKey<FormState>();
                ProductModel? productModel = null;
                String? selectedCodeProduct = "";
                String? selectedProduct = "";
                TextEditingController  uniteController = TextEditingController();
                TextEditingController  numeroOfController = TextEditingController();
                TextEditingController  numeroLotController = TextEditingController();
                TextEditingController  quantityDetectController = TextEditingController();
                TextEditingController  quantityProductController = TextEditingController();
                int quantity_detect = 0;
                int quantity_product = 0;

                bool _dataValidation() {
                  if (productModel == null) {
                    Message.taskErrorOrWarning("Alert", "Product is required");
                    return false;
                  }
                  else if (num_of_obligatoire==1 && numeroOfController.text.trim() == '') {
                    Message.taskErrorOrWarning("Alert", "Numero Of is required");
                    return false;
                  }
                  else if (num_lot_obligatoire==1 && numeroLotController.text.trim() == '') {
                    Message.taskErrorOrWarning("Alert", "Numero Lot is required");
                    return false;
                  }
                  else if (unite_obligatoire==1 && uniteController.text.trim() == '') {
                    Message.taskErrorOrWarning("Alert", "Unite is required");
                    return false;
                  }
                  else if (qte_detect_obligatoire==1 && quantityProductController.text.trim() == '') {
                    Message.taskErrorOrWarning("Alert", "Quantity Detect is required");
                    return false;
                  }
                  else if (qte_produit_obligatoire==1 && quantityProductController.text.trim() == '') {
                    Message.taskErrorOrWarning("Alert", "Quantity Product is required");
                    return false;
                  }

                  if(quantityDetectController.text.trim() == ''){
                    quantity_detect = 0;
                  } else {
                    quantity_detect = int.parse(quantityDetectController.text.toString());
                  }
                  if(quantityProductController.text.trim() == ''){
                    quantity_product = 0;
                  } else {
                    quantity_product = int.parse(quantityProductController.text.toString());
                  }

                   if(quantity_detect > quantity_product ){
                    Message.taskErrorOrWarning("Quantity invalid", "Quantity product must be greater or equal quantity detected ");
                    return false;
                  }
                  return true;
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

                      await PNCService().getProductsPNCARattacher(widget.nnc, matricule).then((resp) async {
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
                Widget _customDropDownProduct(BuildContext context, ProductModel? item) {
                  if (productModel == null) {
                    return Container();
                  }
                  else{
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
                      initialChildSize: 0.9,
                      maxChildSize: 0.9,
                      minChildSize: 0.4,
                      builder: (context, scrollController) => SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            SizedBox(height: 5.0,),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10, right: 10),
                                child: Center(
                                  child: Text('New Product of P.N.C N°${widget.nnc}', style: TextStyle(
                                      fontWeight: FontWeight.w500, fontFamily: "Brand-Bold",
                                      color: Color(0xFF0769D2), fontSize: 20.0
                                  ),),
                                ),
                              ),
                            ),
                            SizedBox(height: 15.0,),
                            SingleChildScrollView(
                              child: Form(
                                key: _addItemFormKey,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5.0),
                                  child: Column(
                                    children: [
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
                                              selectedProduct = data?.produit;
                                              print('product: ${selectedProduct}, code: ${selectedCodeProduct}');
                                            },
                                            dropdownBuilder: _customDropDownProduct,
                                            popupItemBuilder: _customPopupItemBuilderProduct,
                                            validator: (u) =>
                                            u == null ? "Product is required " : null,
                                          )
                                      ),
                                      SizedBox(height: 10,),
                                      Visibility(
                                        visible: true,
                                        child: TextFormField(
                                          controller: numeroOfController,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                              labelText: 'Numero Of ${num_of_obligatoire==1 ?'*' :''}',
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
                                          textInputAction: TextInputAction.done,
                                          decoration: InputDecoration(
                                              labelText: 'Numero Lot ${num_lot_obligatoire==1 ?'*' :''}',
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
                                          textInputAction: TextInputAction.done,
                                          decoration: InputDecoration(
                                              labelText: 'Unite ${unite_obligatoire==1 ?'*' :''}',
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
                                          textInputAction: TextInputAction.done,
                                          decoration: InputDecoration(
                                            labelText: 'Quantity detect ${qte_detect_obligatoire==1 ?'*' :''}',
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
                                          textInputAction: TextInputAction.done,
                                          decoration: InputDecoration(
                                            labelText: 'Quantity Product ${qte_produit_obligatoire==1 ?'*' :''}',
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
                                            if(_dataValidation() && _addItemFormKey.currentState!.validate()){
                                              try {
                                                  var connection = await Connectivity().checkConnectivity();
                                                  if(connection == ConnectivityResult.none){
                                                  int max_product_id = await LocalPNCService().getMaxNumProductPNC();
                                                  var model = ProductPNCModel();
                                                  model.online = 0;
                                                  model.nnc = widget.nnc;
                                                  model.idNCProduct = max_product_id+1;
                                                  model.codeProduit = selectedCodeProduct;
                                                  model.produit = selectedProduct;
                                                  model.numOf = numeroOfController.text;
                                                  model.numLot = numeroLotController.text;
                                                  model.qdetect = quantity_detect;
                                                  model.qprod = quantity_product;
                                                  model.typeProduit = '';
                                                  model.unite = uniteController.text.toString();
                                                  await LocalPNCService().saveProductPNC(model);
                                                  Get.back();
                                                  setState(() {
                                                    productList.clear();
                                                    getProducts();
                                                  });
                                                  ShowSnackBar.snackBar("Successfully", "Product added", Colors.green);
                                                  }
                                                  else if(connection == ConnectivityResult.mobile || connection == ConnectivityResult.wifi){
                                                    await PNCService().addProductNC({
                                                      "nnc": widget.nnc,
                                                      "codeProduit": selectedCodeProduct,
                                                      "qDetect":quantity_detect,
                                                      "unite": uniteController.text.toString(),
                                                      "nof": numeroOfController.text,
                                                      "lot": numeroLotController.text,
                                                      "qProd": quantity_product
                                                    }).then((resp) async {
                                                      Get.back();
                                                      ShowSnackBar.snackBar("Successfully", "Product added", Colors.green);
                                                      setState(() {
                                                        productList.clear();
                                                        getProducts();
                                                      });
                                                    }, onError: (err) {
                                                      if(kDebugMode) print('error : ${err.toString()}');
                                                      ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
                                                    });
                                                  }
                                              }
                                              catch (ex){
                                                print("Exception" + ex.toString());
                                                ShowSnackBar.snackBar("Exception", ex.toString(), Colors.red);
                                                throw Exception("Error " + ex.toString());
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 10.0,),
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
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                );
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 32,),
              backgroundColor: Colors.blue,
            ),
          ),
        ),
      ),
    );
  }

  //delete product
  deleteProductNC(context, position){
    AwesomeDialog(
        context: context,
        animType: AnimType.SCALE,
        dialogType: DialogType.ERROR,
        body: Center(child: Text(
          'Are you sure to delete this item ${position}',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),),
        title: 'Delete',
        btnOk: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              Colors.blue,
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          onPressed: () async {

            await PNCService().deleteProductNCByID(position).then((resp) async {
              ShowSnackBar.snackBar("Successfully", "Product Deleted", Colors.green);
              productList.removeWhere((element) => element.idNCProduct == position);
              setState(() {});
              Navigator.of(context).pop();
            }, onError: (err) {
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
              print('Error : ${err.toString()}');
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Ok',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
          ),
        ),
        closeIcon: Icon(Icons.close, color: Colors.red,),
        btnCancel: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              Colors.redAccent,
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Cancel',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
          ),
        )
    )..show();
  }

}