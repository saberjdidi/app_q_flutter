import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualipro_flutter/Models/employe_model.dart';
import '../../../../Services/action/action_service.dart';
import '../../../../Services/action/local_action_service.dart';
import '../../../../Utils/shared_preference.dart';
import '../../../../Utils/snack_bar.dart';
import '../../../Models/product_model.dart';
import '../../../Services/api_services_call.dart';
import '../../../Services/static_data.dart';
import 'new_product.dart';

class ProductsPage extends StatefulWidget {

 const ProductsPage({Key? key}) : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {

  LocalActionService localService = LocalActionService();
  //ActionService actionService = ActionService();
  final matricule = SharedPreference.getMatricule();
  List<ProductModel> productList = List<ProductModel>.empty(growable: true);

  @override
  void initState() {
    super.initState();
    //checkConnectivity();
    getProducts();
  }
  Future<void> checkConnectivity() async {
    var connection = await Connectivity().checkConnectivity();
    if (connection == ConnectivityResult.none) {
      //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
    }
    else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
      //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
    }
  }
  void getProducts() async {
    try {
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        var response = await localService.readProduct();
        response.forEach((data){
          setState(() {
            var model = ProductModel();
            model.codePdt = data['codePdt'];
            model.produit = data['produit'];
            model.prix = data['prix'];
            model.typeProduit = data['typeProduit'];
            model.codeTypeProduit = data['codeTypeProduit'];
            productList.add(model);
          });
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        /* //static data
         setState(() {
           productList.addAll(listProducts);
         }); */
        await ApiServicesCall().getProduct({
          "codeProduit": "",
          "produit": ""
        }).then((resp) async {
          resp.forEach((data) async {
            setState(() {
              var model = ProductModel();
              model.codePdt = data['codePdt'];
              model.produit = data['produit'];
              model.prix = data['prix'];
              model.typeProduit = data['typeProduit'];
              model.codeTypeProduit = data['codeTypeProduit'];
              productList.add(model);
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
          title: Text(
            'Products',
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
                  return
                    Column(
                      children: [
                        ListTile(
                          title: Text(
                            ' ${productList[index].produit}',
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
                                  TextSpan(text: '${productList[index].codePdt}'),

                                  //TextSpan(text: '${action.declencheur}'),
                                ],

                              ),
                            ),
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
                : const Center(child: Text('Empty List', style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'Brand-Bold'
            )),)
        ),
        floatingActionButton: Container(
          padding: EdgeInsets.only(bottom: 30.0),
          child: FloatingActionButton.small(
            onPressed: (){
              Get.to(NewProduct());
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