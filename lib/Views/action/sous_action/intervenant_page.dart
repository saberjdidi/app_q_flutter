import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualipro_flutter/Models/employe_model.dart';
import '../../../Services/action/action_service.dart';
import '../../../Services/action/local_action_service.dart';
import '../../../Utils/shared_preference.dart';
import '../../../Utils/snack_bar.dart';

class IntervenantsPage extends StatefulWidget {
  final idAction;
  final idSousAction;

 const IntervenantsPage({Key? key, required this.idAction, required this.idSousAction}) : super(key: key);

  @override
  State<IntervenantsPage> createState() => _IntervenantsPageState();
}

class _IntervenantsPageState extends State<IntervenantsPage> {

  LocalActionService localService = LocalActionService();
  //ActionService actionService = ActionService();
  final matricule = SharedPreference.getMatricule();
  List<EmployeModel> listEmploye = List<EmployeModel>.empty(growable: true);

  @override
  void initState() {
    super.initState();
    //checkConnectivity();
    getIntervenants();
  }
  Future<void> checkConnectivity() async {
    var connection = await Connectivity().checkConnectivity();
    if (connection == ConnectivityResult.none) {
      Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
    }
    else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
      Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
    }
  }
  void getIntervenants() async {
    try {
        //rest api
        await ActionService().getIntervenant(widget.idAction, widget.idSousAction).then((resp) async {
          //isDataProcessing(false);
          resp.forEach((data) async {
            setState(() {
              var model = EmployeModel();
              model.nompre = data['nompre'];
              model.mat = data['mat'];
              listEmploye.add(model);

              listEmploye.forEach((element) {
                print('element nomprenom ${element.nompre}, mat: ${element.mat}');
              });
            });
          });
        }
            , onError: (err) {
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });

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
            'Intervenants',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: (lightPrimary),
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: listEmploye.isNotEmpty ?
            Container(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  final num_action = widget.idAction;
                  final num_sous_action = widget.idSousAction;
                  return
                    Column(
                      children: [
                        ListTile(
                          title: Text(
                            ' Action: ${num_action}   \n Sous Action: ${num_sous_action}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: RichText(
                              text: TextSpan(
                                style: Theme.of(context).textTheme.bodyLarge,
                                children: [
                                  WidgetSpan(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                      child: Icon(Icons.person),
                                    ),
                                  ),
                                  TextSpan(text: '${listEmploye[index].nompre}'),

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
                itemCount: listEmploye.length,
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

}