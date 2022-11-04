import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:qualipro_flutter/Models/employe_model.dart';
import 'package:qualipro_flutter/Models/product_model.dart';
import 'package:readmore/readmore.dart';
import '../../../Services/action/action_service.dart';
import '../../../Services/action/local_action_service.dart';
import '../../../Utils/custom_colors.dart';
import '../../../Utils/shared_preference.dart';
import '../../../Utils/snack_bar.dart';

class ProductsActionPage extends StatefulWidget {
  final idAction;

 const ProductsActionPage({Key? key, required this.idAction}) : super(key: key);

  @override
  State<ProductsActionPage> createState() => _ProductsActionPageState();
}

class _ProductsActionPageState extends State<ProductsActionPage> {

  LocalActionService localService = LocalActionService();
  //ActionService actionService = ActionService();
  final matricule = SharedPreference.getMatricule();
  List<ProductModel> listProduct = List<ProductModel>.empty(growable: true);

  @override
  void initState() {
    super.initState();
    getProducts();
  }
  void getProducts() async {
    try {
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        Get.defaultDialog(
            title: 'mode_offline'.tr,
            backgroundColor: Colors.white,
            titleStyle: TextStyle(color: Colors.black),
            middleTextStyle: TextStyle(color: Colors.white),
            textCancel: "Back",
            onCancel: (){
              Get.back();
            },
            confirmTextColor: Colors.white,
            buttonColor: Colors.blue,
            barrierDismissible: false,
            radius: 20,
            content: Center(
              child: Column(
                children: <Widget>[
                  Lottie.asset('assets/images/empty_list.json', width: 150, height: 150),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('no_internet'.tr,
                        style: TextStyle(color: Colors.blueGrey, fontSize: 20)),
                  ),
                ],
              ),
            )
        );
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        //rest api
        await ActionService()
            .getProductsOfAction(matricule, widget.idAction)
            .then((resp) async {
          //isDataProcessing(false);
          resp.forEach((data) async {
            setState(() {
              var model = ProductModel();
              model.id = data['id'];
              model.produit = data['produit'];
              model.codePdt = data['codeProduit'];
              listProduct.add(model);

              listProduct.forEach((element) {
                print('element produit ${element.produit}, codePdt: ${element
                    .codePdt}');
              });
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
              //Get.offAll(HomePage());
            },
            child: Icon(Icons.arrow_back, color: Colors.blue,),
          ),
          title: Text(
            'Products',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: (lightPrimary),
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: listProduct.isNotEmpty ?
            Container(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  final num_action = widget.idAction;
                  return
                    Column(
                      children: [
                        ListTile(
                          title: Expanded(
                            flex: 1,
                            child: ListTile(
                              title: Text(
                                ' Action N°${num_action}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: RichText(
                                  text: TextSpan(
                                    style: Theme.of(context).textTheme.bodyLarge,
                                    children: [
                                     /* WidgetSpan(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                          child: Icon(Icons.amp_stories),
                                        ),
                                      ), */
                                      TextSpan(text: '${listProduct[index].produit}'),

                                      //TextSpan(text: '${action.declencheur}'),
                                    ],

                                  ),
                                ),
                              ),
                              trailing: InkWell(
                                  onTap: (){
                                    deleteProductAction(context, listProduct[index].id);
                                  },
                                  child: Icon(Icons.delete, color: Colors.red,)
                              ),
                            ),
                          ),
                        /*  subtitle: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            /* child: Text('${listProduct[index].act}',
                              style:
                              TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),*/
                            child: ReadMoreText(
                              "${listProduct[index].mat}",
                              style: TextStyle(
                                  color: Color(0xFF3B465E),
                                  fontWeight: FontWeight.bold),
                              trimLines: 2,
                              colorClickableText: CustomColors.bleuCiel,
                              trimMode: TrimMode.Line,
                              trimCollapsedText: 'more',
                              trimExpandedText: 'less',
                              moreStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: CustomColors.bleuCiel),
                            ),
                          ), */
                        ),
                        Divider(
                          thickness: 1.0,
                          color: Colors.blue,
                        ),
                      ],
                    );
                },
                itemCount: listProduct.length,
                //itemCount: actionsList.length + 1,
              ),
            )
                : const Center(child: Text('Empty List', style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'Brand-Bold'
            )),)
        ),
      ),
    );
  }
//delete product
  deleteProductAction(context, position){
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

            await ActionService().deleteProductActionById(position).then((resp) async {
              ShowSnackBar.snackBar("Successfully", "Product Deleted", Colors.green);
              listProduct.removeWhere((element) => element.id == position);
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