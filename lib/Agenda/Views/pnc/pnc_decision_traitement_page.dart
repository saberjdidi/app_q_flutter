import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualipro_flutter/Widgets/refresh_widget.dart';
import 'package:readmore/readmore.dart';
import '../../../Models/pnc/traitement_decision_model.dart';
import '../../../Services/pnc/local_pnc_service.dart';
import '../../../Services/pnc/pnc_service.dart';
import '../../../Utils/custom_colors.dart';
import '../../../Utils/shared_preference.dart';
import '../../../Utils/snack_bar.dart';
import '../../../Views/home_page.dart';
import 'remplir_pnc_decision_traitement.dart';

class PNCTraitementDecisionPage extends StatefulWidget {

  PNCTraitementDecisionPage({Key? key}) : super(key: key);

  @override
  State<PNCTraitementDecisionPage> createState() => _PNCTraitementDecisionPageState();
}

class _PNCTraitementDecisionPageState extends State<PNCTraitementDecisionPage> {

  PNCService localService = PNCService();
  final matricule = SharedPreference.getMatricule();
  final keyRefresh = GlobalKey<RefreshIndicatorState>();
  List<TraitementDecisionModel> listPNCDecision = List<TraitementDecisionModel>.empty(growable: true);
  List<TraitementDecisionModel> listFiltered = [];
  TextEditingController controller = TextEditingController();
  String _searchResult = '';

  @override
  void initState() {
    super.initState();
    getPNCTraitementDecision();
  }

  void getPNCTraitementDecision() async {
    try {
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.BOTTOM, duration: Duration(milliseconds: 900));
        var response = await LocalPNCService().readPNCDecision();
        response.forEach((data){
          setState(() {
            var model = TraitementDecisionModel();
            model.nnc = data['nnc'];
            model.dateDetect = data['dateDetect'];
            model.produit = data['produit'];
            model.typeNC = data['typeNC'];
            model.qteDetect = data['qteDetect'];
            model.codepdt = data['codepdt'];
            model.nlot = data['nlot'];
            model.ind = data['ind'];
            model.nc = data['nc'];
            model.nomClt = data['nomClt'];
            model.commentaire = data['commentaire'];
            listPNCDecision.add(model);
            listFiltered = listPNCDecision;
            listPNCDecision.forEach((element) {
              print('element pnc ${element.nc}, id : ${element.nnc}');
            });
          });
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.BOTTOM, duration: Duration(milliseconds: 900));
       //rest api
        await PNCService().getPNCTraitementDecision(matricule).then((resp) async {
          //isDataProcessing(false);
          resp.forEach((data) async {
            setState(() {
              var model = TraitementDecisionModel();
              model.nnc = data['nnc'];
              model.dateDetect = data['dateDetect'];
              model.produit = data['produit'];
              model.typeNC = data['typeNC'];
              model.qteDetect = data['qteDetect'];
              model.codepdt = data['codepdt'];
              model.nlot = data['nlot'];
              model.ind = data['ind'];
              model.nc = data['nc'];
              model.nomClt = data['nomClt'];
              model.commentaire = data['commentaire'];
              listPNCDecision.add(model);
              listFiltered = listPNCDecision;
              listPNCDecision.forEach((element) {
                print('element pnc ${element.nc}, id : ${element.nnc}');
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
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          leading: TextButton(
            onPressed: (){
              Get.offAll(HomePage());
            },
            child: Icon(Icons.arrow_back, color: Colors.blue,),
          ),
          title: Text(
            'Decision de Traitement : ${listPNCDecision.length}',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: (lightPrimary),
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: listPNCDecision.isNotEmpty ?
            RefreshWidget(
              keyRefresh: keyRefresh,
              onRefresh: () async {
                controller.clear();
                listPNCDecision.clear();
                getPNCTraitementDecision();
              },
              child: Column(
                children: <Widget>[
                  Card(
                    //margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: InkWell(
                            onTap: (){
                              setState(() {
                                controller.clear();
                                _searchResult = '';
                                listFiltered = listPNCDecision;
                              });
                            },
                            child: controller.text.trim()=='' ?Text('') :Icon(Icons.cancel),
                          ),
                          hintText: 'Search',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: Colors.blue)
                          )
                      ),
                      onChanged: (value){
                        setState(() {
                          _searchResult = value;
                          listFiltered = listPNCDecision.where((user) =>
                          user.nnc.toString().contains(_searchResult)
                              || user.nc!.toLowerCase().contains(_searchResult)
                              || user.typeNC!.toLowerCase().contains(_searchResult)
                          ).toList();
                        });
                      },
                    ),
                  ),
                  Flexible(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        final num_pnc = listFiltered[index].nnc;

                        return Column(
                          children: [
                            ListTile(
                              title: Text(
                                'PNC N°${num_pnc}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        style: Theme.of(context).textTheme.bodyLarge,
                                        children: [
                                          WidgetSpan(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                              child: Icon(Icons.calendar_today),
                                            ),
                                          ),
                                          TextSpan(text: '${listFiltered[index].dateDetect}'),

                                          //TextSpan(text: '${action.declencheur}'),
                                        ],

                                      ),
                                    ),
                                    ReadMoreText(
                                      "${listFiltered[index].nc}",
                                      style: TextStyle(
                                          color: Color(0xFF1C4F8E),
                                          fontWeight: FontWeight.bold),
                                      trimLines: 3,
                                      colorClickableText: CustomColors.bleuCiel,
                                      trimMode: TrimMode.Line,
                                      trimCollapsedText: '>>>',
                                      trimExpandedText: '<<<',
                                      moreStyle: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: CustomColors.bleuCiel),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 3, bottom: 3),
                                      child: Text('Produit : ${listFiltered[index].produit}',
                                          style: TextStyle(color: Colors.blueAccent)),
                                    ),
                                    ReadMoreText(
                                      "Type : ${listFiltered[index].typeNC}",
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
                                    )
                                  ],
                                ),
                              ),
                              trailing: IconButton(
                                onPressed: () async {
                                  Get.to(RemplirPNCTraitementDecision(traitementDecisionModel: listFiltered[index]));
                                },
                                icon: Icon(Icons.edit, color: Colors.green,),
                                tooltip: 'pnc decision',
                              ),
                            ),
                            Divider(
                              thickness: 1.0,
                              color: Colors.blue,
                            ),
                          ],
                        );
                      },
                      itemCount: listFiltered.length,
                    ),
                  ),
                ],
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

}