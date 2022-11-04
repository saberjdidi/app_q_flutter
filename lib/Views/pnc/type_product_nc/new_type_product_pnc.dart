import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Utils/custom_colors.dart';
import '../../../../Utils/shared_preference.dart';
import '../../../../Utils/snack_bar.dart';
import '../../../Models/pnc/type_pnc_model.dart';
import '../../../Services/api_services_call.dart';
import '../../../Services/pnc/local_pnc_service.dart';
import '../../../Services/pnc/pnc_service.dart';
import '../../../Utils/message.dart';
import '../../../Validators/validator.dart';
import 'type_product_pnc_page.dart';

class NewTypeProductNC extends StatefulWidget {
  final nnc;
  final code_product;
  final product;
  final id_product;
  const NewTypeProductNC({Key? key, required this.nnc, required this.code_product, required this.product, required this.id_product}) : super(key: key);

  @override
  State<NewTypeProductNC> createState() => _NewTypeProductNCState();
}

class _NewTypeProductNCState extends State<NewTypeProductNC> {
  final _addItemFormKey = GlobalKey<FormState>();
  bool _isProcessing = false;
  final matricule = SharedPreference.getMatricule();
  LocalPNCService localPNCService = LocalPNCService();
  PNCService pncService = PNCService();

  TypePNCModel? typePNCModel = null;
  int? selectedCodeType = 0;
  TextEditingController  pourcentageController = TextEditingController();
  TextEditingController  productController = TextEditingController();
  int pourcentage = 0;

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  @override
  void initState(){
    super.initState();
    //productController = widget.product;
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
        title: Text("New Type of P.N.C N°${widget.nnc}",textAlign: TextAlign.center,),
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
                            SizedBox(height: 8.0,),
                           /* Visibility(
                              visible: true,
                              child: TextFormField(
                                enabled: false,
                                controller: productController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                    labelText: 'product'.tr,
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
                            SizedBox(height: 10.0,), */
                            Visibility(
                                visible: true,
                                child: DropdownSearch<TypePNCModel>(
                                  showSelectedItems: true,
                                  showClearButton: true,
                                  showSearchBox: true,
                                  isFilteredOnline: true,
                                  compareFn: (i, s) => i?.isEqual(s) ?? false,
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText: "Type *",
                                    contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                    border: OutlineInputBorder(),
                                  ),
                                  onFind: (String? filter) => getTypePNC(filter),
                                  onChanged: (data) {
                                    typePNCModel = data;
                                    selectedCodeType = data?.codeTypeNC;
                                    print('type: ${typePNCModel?.typeNC}, code: ${selectedCodeType}');
                                  },
                                  dropdownBuilder: _customDropDownType,
                                  popupItemBuilder: _customPopupItemBuilderType,
                                  validator: (u) =>
                                  u == null ? "Type is required " : null,
                                )
                            ),
                            SizedBox(height: 10.0,),
                            Visibility(
                              visible: true,
                              child: TextFormField(
                                controller: pourcentageController,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  labelText: 'Pourcentage *',
                                  hintText: 'Pourcentage',
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
                                  suffixIcon: Container(
                                    padding: EdgeInsets.all(12.0),
                                    child: Text('%', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                                  ),
                                ),
                                validator: (value) => Validator.validateField(
                                    value: value!
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
                                padding: const EdgeInsets.all(8.0),
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

  bool _dataValidation(){
    pourcentage = int.parse(pourcentageController.text.toString());
    if(pourcentage > 100){
      Message.taskErrorOrWarning("Pourcentage", "Veuillez saisir donnée inférieur ou égal à 100");
      return false;
    }
    return true;
  }

  Future saveBtn() async {
    pourcentage = int.parse(pourcentageController.text.toString());
    if(_dataValidation() && _addItemFormKey.currentState!.validate()){
      try {
        setState(()  {
          _isProcessing = true;
        });
        await pncService.addTypeProductNC({
          "nnc": widget.nnc,
          "id_produit": widget.id_product,
          "type": selectedCodeType,
          "pourcentage": pourcentage,
        }).then((resp) async {
          ShowSnackBar.snackBar("Successfully", "Type added", Colors.green);
          //Get.back();
          Get.offAll(TypeProductPNCPage(nnc: widget.nnc, code_product: widget.code_product, product: widget.product, id_product: widget.id_product,));
        }, onError: (err) {
          _isProcessing = false;
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
      }
      catch (ex){
        _isProcessing = false;
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
        _isProcessing = false;
      }
    }
  }

  //Type
  Future<List<TypePNCModel>> getTypePNC(filter) async {
    try {
      List<TypePNCModel> _typeList = await List<TypePNCModel>.empty(growable: true);
      List<TypePNCModel> _typeFilter = await List<TypePNCModel>.empty(growable: true);
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        var response = await localPNCService.readTypePNC();
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
  Widget _customDropDownType(BuildContext context, TypePNCModel? item) {
    if (typePNCModel == null) {
      return Container();
    }
    else{
      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('${typePNCModel?.typeNC}'),
          subtitle: Text('${typePNCModel?.codeTypeNC}'),
        ),
      );
    }
  }
  Widget _customPopupItemBuilderType(
      BuildContext context, typePNCModel, bool isSelected) {
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
        title: Text(typePNCModel?.typeNC ?? ''),
        subtitle: Text(typePNCModel?.codeTypeNC.toString() ?? ''),
      ),
    );
  }
}
