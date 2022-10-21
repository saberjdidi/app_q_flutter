import 'package:connectivity/connectivity.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:qualipro_flutter/Services/pnc/local_pnc_service.dart';
import '../../../../Utils/shared_preference.dart';
import '../../../../Utils/snack_bar.dart';
import '../../../Models/pnc/type_pnc_model.dart';
import '../../../Services/api_services_call.dart';
import '../../../Services/pnc/pnc_service.dart';
import '../../../Utils/custom_colors.dart';
import '../../../Validators/validator.dart';
import '../add_products_pnc/products_pnc_page.dart';

class TypeProductPNCPage extends StatefulWidget {
  final nnc;
  final code_product;
  final product;
  final id_product;

 const TypeProductPNCPage({Key? key, required this.nnc, required this.code_product, required this.product, required this.id_product}) : super(key: key);

  @override
  State<TypeProductPNCPage> createState() => _TypeProductPNCPageState();
}

class _TypeProductPNCPageState extends State<TypeProductPNCPage> {

  LocalPNCService localService = LocalPNCService();
  final matricule = SharedPreference.getMatricule();
  List<TypePNCModel> listType = List<TypePNCModel>.empty(growable: true);

  @override
  void initState() {
    super.initState();
    //checkConnectivity();
    getTypes();
  }
  Future<void> checkConnectivity() async {
    var connection = await Connectivity().checkConnectivity();
    if (connection == ConnectivityResult.none) {
      Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.BOTTOM, duration: Duration(milliseconds: 900));
    }
    else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
      Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.BOTTOM, duration: Duration(milliseconds: 900));
    }
  }
  void getTypes() async {
    try {
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
       /* var response = await localService.readProduct();
        response.forEach((data){
          setState(() {
            var model = ProductModel();
            model.codePdt = data['codePdt'];
            model.produit = data['produit'];
            model.prix = data['prix'];
            model.typeProduit = data['typeProduit'];
            model.codeTypeProduit = data['codeTypeProduit'];
            listType.add(model);
          });
        }); */
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        await PNCService().getTypeProductNC(widget.nnc, widget.code_product).then((resp) async {
          resp.forEach((data) async {
            setState(() {
              var model = TypePNCModel();
              model.codeTypeNC = data['codeTypeNC'];
              model.typeNC = data['typeNC'];
              model.color = data['color'];
              listType.add(model);
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
              Get.back();
              //Get.offAll(ProductsPNCPage(nnc: widget.nnc,));
            },
            child: Icon(Icons.arrow_back, color: Colors.white,),
          ),
          title: Text(
            'Type of PNC N°${widget.nnc}',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.lightBlue,
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: listType.isNotEmpty ?
            Container(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  Color color = HexColor(listType[index].color.toString());
                  return
                    Card(
                      margin: EdgeInsets.all(2.0),
                        child: ListTile(
                              tileColor: color,
                              title: Text(
                                'Product : ${widget.product}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text('Type : ${listType[index].typeNC}',
                                style: TextStyle(color: Colors.black, fontSize: 17),),
                              ),
                            ),
                    );
                },
                itemCount: listType.length,
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
          padding: EdgeInsets.only(bottom: 5.0),
          child: FloatingActionButton(
            onPressed: (){
              //Get.to(NewTypeProductNC(nnc: widget.nnc, code_product: widget.code_product, product: widget.product, id_product: widget.id_product,));

              final _addItemFormKey = GlobalKey<FormState>();
              TypePNCModel? typePNCModel = null;
              int? selectedCodeType = 0;
              TextEditingController  pourcentageController = TextEditingController();
              TextEditingController  productController = TextEditingController();
              int pourcentage = 0;
              //Type
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
              //bottom sheet
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
                        child: ListBody(
                          children: <Widget>[
                            SizedBox(height: 5.0,),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                                child: Center(
                                  child: Text('New Type of P.N.C N°${widget.nnc}', style: TextStyle(
                                      fontWeight: FontWeight.w500, fontFamily: "Brand-Bold",
                                      color: Color(0xFF0769D2), fontSize: 20.0
                                  ),),
                                ),
                              ),
                            ),
                            SizedBox(height: 15.0,),
                            Form(
                                key: _addItemFormKey,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5.0),
                                  child: Column(
                                    children: [
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
                                            pourcentage = int.parse(pourcentageController.text.toString());
                                            if(_addItemFormKey.currentState!.validate()){
                                              try {
                                                await PNCService().addTypeProductNC({
                                                  "nnc": widget.nnc,
                                                  "id_produit": widget.id_product,
                                                  "type": selectedCodeType,
                                                  "pourcentage": pourcentage,
                                                }).then((resp) async {
                                                  Get.back();
                                                  ShowSnackBar.snackBar("Successfully", "Type added", Colors.green);
                                                  setState(() {
                                                    listType.clear();
                                                    getTypes();
                                                  });
                                                }, onError: (err) {
                                                  if(kDebugMode) print('error : ${err.toString()}');
                                                  ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
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
                                ))
                          ],
                        ),
                      )
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
    );
  }

}