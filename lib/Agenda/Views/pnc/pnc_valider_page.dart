import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qualipro_flutter/Services/pnc/local_pnc_service.dart';
import 'package:readmore/readmore.dart';
import 'package:searchable_listview/resources/arrays.dart';
import 'package:searchable_listview/searchable_listview.dart';
import '../../../Models/pnc/pnc_a_corriger_model.dart';
import '../../../Services/pnc/pnc_service.dart';
import '../../../Utils/custom_colors.dart';
import '../../../Utils/shared_preference.dart';
import '../../../Utils/snack_bar.dart';
import '../../../Views/home_page.dart';
import 'remplir_pnc_validation.dart';

class PNCValiderPage extends StatefulWidget {

  PNCValiderPage({Key? key}) : super(key: key);

  @override
  State<PNCValiderPage> createState() => _PNCValiderPageState();
}

class _PNCValiderPageState extends State<PNCValiderPage> {

  PNCService localService = PNCService();
  final matricule = SharedPreference.getMatricule();
  List<PNCCorrigerModel> listPNCValider = List<PNCCorrigerModel>.empty(growable: true);

  @override
  void initState() {
    super.initState();
    getPNCAValider();
  }

  void getPNCAValider() async {
    try {
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none) {
       // Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.BOTTOM, duration: Duration(milliseconds: 900));

        var response = await LocalPNCService().readPNCValider();
        response.forEach((data){
          setState(() {
            var model = PNCCorrigerModel();
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
            model.ninterne = data['ninterne'];
            listPNCValider.add(model);

            listPNCValider.forEach((element) {
              print('produit pnc ${element.produit}, id : ${element.nnc}');
            });
          });
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
       // Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.BOTTOM, duration: Duration(milliseconds: 900));
       //rest api
        await PNCService().getPNCAValider(matricule).then((resp) async {
          //isDataProcessing(false);
          resp.forEach((data) async {
            setState(() {
              var model = PNCCorrigerModel();
              model.nnc = data['nnc'];
              //model.motifRefus = data['motif_refus'];
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
              model.ninterne = data['ninterne'];
              listPNCValider.add(model);

              listPNCValider.forEach((element) {
                print('element pnc ${element.motifRefus}, id : ${element.nnc}');
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
          leading: RaisedButton(
            onPressed: (){
              Get.offAll(HomePage());
            },
            elevation: 0.0,
            child: Icon(Icons.arrow_back, color: Colors.blue,),
            color: Colors.white,
          ),
          title: Text(
            'Non Confirmité a Valider : ${listPNCValider.length}',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: (lightPrimary),
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: listPNCValider.isNotEmpty ?
            Container(
              child: SearchableList<PNCCorrigerModel>(
                /* onPaginate: () async {
                            await Future.delayed(const Duration(milliseconds: 1000));
                            setState(() {
                              actors.addAll([
                                Actor(age: 22, name: 'Fathi', lastName: 'Hadawi'),
                                Actor(age: 22, name: 'Hichem', lastName: 'Rostom'),
                                Actor(age: 22, name: 'Kamel', lastName: 'Twati'),
                              ]);
                            });
                          }, */
                initialList: listPNCValider,
                builder: (PNCCorrigerModel item) => PNCItem(pncCorrigerModel: item),
                filter: _filterPNCList,
                emptyWidget: const Center(child: Text('Empty List', style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'Brand-Bold'
                )),),
                onRefresh: () async {},
                onItemSelected: (PNCCorrigerModel item) {},
                searchMode: SearchMode.onEdit,
                inputDecoration: InputDecoration(
                  contentPadding: EdgeInsets.only(right: 5, left: 5),
                  labelText: "Search N.C a valider",
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.blue,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.lightBlue, width: 2)
                  ),
                ),
              ),
             /* ListView.builder(
                itemBuilder: (context, index) {
                  final num_pnc = listPNCValider[index].nnc;

                  return
                    Column(
                    children: [
                      ListTile(
                        title: Expanded(
                          flex: 1,
                          child: ListTile(
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
                                        TextSpan(text: '${listPNCValider[index].dateDetect}'),

                                        //TextSpan(text: '${action.declencheur}'),
                                      ],

                                    ),
                                  ),
                                  Text('${listPNCValider[index].produit}',
                                        style: TextStyle(color: Colors.blueAccent)),

                                ],
                              ),
                            ),
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: ReadMoreText(
                            "${listPNCValider[index].typeNC}",
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
                        ),
                        trailing: Container(
                          padding: EdgeInsets.only(bottom: 1.0, top: 1.0),
                          margin: EdgeInsets.zero,
                          child: Wrap(
                               spacing: 1.0,
                            runSpacing: 1.0,
                            direction: Axis.vertical,
                            children: <Widget>[
                              IconButton(
                                onPressed: () async {
                                  Get.to(RemplirPNCValidation(nnc: listPNCValider[index].nnc,));
                                },
                                icon: Icon(Icons.edit, color: Colors.green,),
                                tooltip: 'pnc validation',
                              ),
                              /*IconButton(
                                onPressed: () async {
                                  //Get.to(IntervenantsPNCValiderPage(idAction: listPNCValider[index].nAct, idSousAction: listPNCValider[index].nSousAct,));
                                },
                                icon: Icon(Icons.remove_red_eye, color: Colors.blue,),
                                tooltip: 'Intervenants',
                              )*/
                            ],
                          ),
                        ),
                        /// this function uses to navigate (move to next screen) User Details page and pass user objects into the User Details page. ///
                        onTap: () {
                          Get.to(RemplirPNCValidation(nnc: listPNCValider[index].nnc,));
                        },
                      ),
                      Divider(
                        thickness: 1.0,
                        color: Colors.blue,
                      ),
                    ],
                  );
                },
                itemCount: listPNCValider.length,
                //itemCount: actionsList.length + 1,
              ), */
            )
                : const Center(child: Text('Empty List', style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'Brand-Bold'
            )),)
        ),
      ),
    );
  }

  List<PNCCorrigerModel> _filterPNCList(String searchTerm) {
    return listPNCValider
        .where(
          (element) =>
          element.nnc.toString().toLowerCase().contains(searchTerm) ||
          element.produit.toString().contains(searchTerm),
    ).toList();
  }
}

class PNCItem extends StatelessWidget {
  final PNCCorrigerModel pncCorrigerModel;

  const PNCItem({
    Key? key,
    required this.pncCorrigerModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Card(
        shadowColor: Color(0xFF07F6F6),
        color: Color(0xFFEDF1F1),
        child: ListTile(
          title: Text(
            'PNC N°${pncCorrigerModel.nnc}',
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
                      TextSpan(text: '${pncCorrigerModel.dateDetect}'),

                      //TextSpan(text: '${action.declencheur}'),
                    ],

                  ),
                ),
                Text('${pncCorrigerModel.produit}',
                    style: TextStyle(color: Colors.blueAccent)),
                ReadMoreText(
                  "${pncCorrigerModel.typeNC}",
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
          trailing: Container(
            padding: EdgeInsets.only(bottom: 1.0, top: 1.0),
            margin: EdgeInsets.zero,
            child: Wrap(
              spacing: 1.0,
              runSpacing: 1.0,
              direction: Axis.vertical,
              children: <Widget>[
                IconButton(
                  onPressed: () async {
                    Get.to(RemplirPNCValidation(nnc: pncCorrigerModel.nnc,));
                  },
                  icon: Icon(Icons.edit, color: Colors.green,),
                  tooltip: 'pnc validation',
                ),
                /*IconButton(
                                  onPressed: () async {
                                    //Get.to(IntervenantsPNCValiderPage(idAction: listPNCValider[index].nAct, idSousAction: listPNCValider[index].nSousAct,));
                                  },
                                  icon: Icon(Icons.remove_red_eye, color: Colors.blue,),
                                  tooltip: 'Intervenants',
                                )*/
              ],
            ),
          ),
          /// this function uses to navigate (move to next screen) User Details page and pass user objects into the User Details page. ///
          onTap: () {
            Get.to(RemplirPNCValidation(nnc: pncCorrigerModel.nnc,));
          },
        ),
      ),
    );
  }
}