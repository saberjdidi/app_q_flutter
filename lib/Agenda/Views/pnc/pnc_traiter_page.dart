import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qualipro_flutter/Widgets/refresh_widget.dart';
import 'package:readmore/readmore.dart';
import '../../../Models/pnc/pnc_a_traiter_model.dart';
import '../../../Services/pnc/local_pnc_service.dart';
import '../../../Services/pnc/pnc_service.dart';
import '../../../Utils/custom_colors.dart';
import '../../../Utils/shared_preference.dart';
import '../../../Utils/snack_bar.dart';
import '../../../Views/home_page.dart';
import 'remplir_pnc_traitement.dart';

class PNCTraiterPage extends StatefulWidget {

  PNCTraiterPage({Key? key}) : super(key: key);

  @override
  State<PNCTraiterPage> createState() => _PNCTraiterPageState();
}

class _PNCTraiterPageState extends State<PNCTraiterPage> {

  PNCService localService = PNCService();
  final matricule = SharedPreference.getMatricule();
  final keyRefresh = GlobalKey<RefreshIndicatorState>();
  List<PNCTraiterModel> listPNCTraiter = List<PNCTraiterModel>.empty(growable: true);
  List<PNCTraiterModel> listFiltered = [];
  TextEditingController controller = TextEditingController();
  String _searchResult = '';

  @override
  void initState() {
    super.initState();
    getPNCATraiter();
  }

  void getPNCATraiter() async {
    try {
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.BOTTOM, duration: Duration(milliseconds: 900));
        var response = await LocalPNCService().readPNCATraiter();
        response.forEach((data){
          setState(() {
            var model = PNCTraiterModel();
            model.nnc = data['nnc'];
            model.dateDetect = data['dateDetect'];
            model.produit = data['produit'];
            model.typeNC = data['typeNC'];
            model.qteDetect = data['qteDetect'];
            model.codepdt = data['codepdt'];
            model.nlot = data['nlot'];
            model.ind = data['ind'];
            model.traitee = data['traitee'];
            model.dateT = data['dateT'];
            model.dateST = data['dateST'];
            model.nc = data['nc'];
            model.nomClt = data['nomClt'];
            model.traitement = data['traitement'];
            model.typeT = data['typeT'];
            listPNCTraiter.add(model);
            listFiltered = listPNCTraiter;
            listPNCTraiter.forEach((element) {
              print('element pnc ${element.nc}, id : ${element.nnc}');
            });
          });
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.BOTTOM, duration: Duration(milliseconds: 900));
       //rest api
        await PNCService().getPNCATraiter({
          "mat": matricule.toString(),
          "nc": "",
          "nnc": ""
        }).then((resp) async {
          //isDataProcessing(false);
          resp.forEach((data) async {
            setState(() {
              var model = PNCTraiterModel();
              model.nnc = data['nnc'];
              model.dateDetect = data['dateDetect'];
              model.produit = data['produit'];
              model.typeNC = data['typeNC'];
              model.qteDetect = data['qteDetect'];
              model.codepdt = data['codepdt'];
              model.nlot = data['nlot'];
              model.ind = data['ind'];
              model.traitee = data['traitee'];
              model.dateT = data['dateT'];
              model.dateST = data['dateST'];
              model.nc = data['nc'];
              model.nomClt = data['nomClt'];
              model.traitement = data['traitement'];
              model.typeT = data['typeT'];
              listPNCTraiter.add(model);
              listFiltered = listPNCTraiter;
              listPNCTraiter.forEach((element) {
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
            'Non Confirmité a Traiter ${listPNCTraiter.length}',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: (lightPrimary),
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: listPNCTraiter.isNotEmpty ?
            RefreshWidget(
              keyRefresh: keyRefresh,
              onRefresh: () async {
                controller.clear();
                listPNCTraiter.clear();
                getPNCATraiter();
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
                                listFiltered = listPNCTraiter;
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
                          listFiltered = listPNCTraiter.where((user) =>
                          user.nnc.toString().contains(_searchResult)
                              || user.nc!.toLowerCase().contains(_searchResult)
                              || user.produit!.toLowerCase().contains(_searchResult)
                          ).toList();
                        });
                      },
                    ),
                  ),
                  Flexible(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        final num_pnc = listFiltered[index].nnc;
                        DateTime date = DateTime.parse(listFiltered[index].dateDetect.toString());
                        final date_detect = DateFormat('dd/MM/yyyy').format(date);
                        return
                          Column(
                          children: [
                            ListTile(
                              title: Text(
                                ' PNC N°${num_pnc}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: RichText(
                                        text: TextSpan(
                                          style: Theme.of(context).textTheme.bodyLarge,
                                          children: [
                                            WidgetSpan(
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                                child: Icon(Icons.calendar_today),
                                              ),
                                            ),
                                            TextSpan(text: '${date_detect}'),

                                            //TextSpan(text: '${action.declencheur}'),
                                          ],

                                        ),
                                      ),
                                    ),

                                    RichText(
                                      textAlign: TextAlign.start,
                                      text: TextSpan(
                                        style: Theme.of(context).textTheme.bodyLarge,
                                        children: [
                                          TextSpan(text: 'Designation : ${listFiltered[index].nc}'),
                                        ],

                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                                      child: Text('Produit : ${listFiltered[index].produit}',
                                          style: TextStyle(color: Colors.blueAccent)),
                                    ),
                                    ReadMoreText(
                                      "${listFiltered[index].traitement}",
                                      style: TextStyle(
                                          color: Color(0xFF3B465E),
                                          fontWeight: FontWeight.bold),
                                      trimLines: 3,
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
                                  Get.to(RemplirPNCTraitement(pncTraiterModel: listFiltered[index],));
                                },
                                icon: Icon(Icons.edit, color: Colors.green,),
                                tooltip: 'pnc traitement',
                              ),
                              onTap: () {
                                Get.to(RemplirPNCTraitement(pncTraiterModel: listFiltered[index],));
                              },
                            ),
                            Divider(
                              thickness: 1.0,
                              color: Colors.blue,
                            ),
                          ],
                        );
                      },
                      itemCount: listFiltered.length,
                      //itemCount: actionsList.length + 1,
                    ),
                  ),
                ],
              ),
            )
                : Center(child: Text('empty_list'.tr, style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'Brand-Bold'
            )),)
        ),
      ),
    );
  }

}