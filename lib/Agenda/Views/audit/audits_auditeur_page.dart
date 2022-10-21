import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualipro_flutter/Models/audit/audit_model.dart';
import 'package:qualipro_flutter/Services/audit/audit_service.dart';
import 'package:qualipro_flutter/Utils/snack_bar.dart';
import '../../../Controllers/api_controllers_call.dart';
import '../../../Services/audit/local_audit_service.dart';
import '../../../Utils/custom_colors.dart';
import '../../../Utils/message.dart';
import '../../../Utils/shared_preference.dart';
import '../../../Widgets/refresh_widget.dart';

class AuditsAuditeurPage extends StatefulWidget {
  const AuditsAuditeurPage({Key? key}) : super(key: key);

  @override
  State<AuditsAuditeurPage> createState() => _AuditsAuditeurPageState();
}

class _AuditsAuditeurPageState extends State<AuditsAuditeurPage> {
  final keyRefresh = GlobalKey<RefreshIndicatorState>();
  final matricule = SharedPreference.getMatricule();
  List<AuditModel> listAudit = List<AuditModel>.empty(growable: true);
  List<AuditModel> filterAudit = [];
  TextEditingController controller = TextEditingController();
  String _searchResult = '';

  getData() async {
    try {
      var connection = await Connectivity().checkConnectivity();
      if(connection == ConnectivityResult.none){
        var response =  await LocalAuditService().readAuditAuditeur();
        response.forEach((element){
          setState(() {
            var model = new AuditModel();
            model.idAudit = element['idAudit'];
            model.refAudit = element['refAudit'];
            model.champ = element['champ'];
            model.dateDebPrev = element['dateDebPrev'];
            model.interne = element['interne'];
            listAudit.add(model);
            filterAudit = listAudit;
          });
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile){
        await AuditService().getAuditsEnTantQueAuditeur()
            .then((response){
             response.forEach((element) {
               setState(() {
                 var model = new AuditModel();
                 model.idAudit = element['idAudit'];
                 model.refAudit = element['refAudit'];
                 model.champ = element['champ'];
                 model.dateDebPrev = element['dateDebPrev'];
                 model.interne = element['interne'];
                 listAudit.add(model);
                 filterAudit = listAudit;
               });
             });
        },
            onError: (error){
              if(kDebugMode) print('error : ${error.toString()}');
              ShowSnackBar.snackBar('Error', error.toString(), Colors.redAccent);
            });
      }
    }
    catch(Exception) {
      ShowSnackBar.snackBar('Exception', Exception.toString(), Colors.redAccent);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
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
              Get.back();
            },
            child: Icon(Icons.arrow_back, color: Colors.blue,),
          ),
          title: Text(
            'Audit en tant que Auditeur : ${listAudit.length}',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: (lightPrimary),
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: listAudit.isNotEmpty ?
            RefreshWidget(
              keyRefresh: keyRefresh,
              onRefresh: () async {
                controller.clear();
                listAudit.clear();
                getData();
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
                                filterAudit = listAudit;
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
                          filterAudit = listAudit.where((user) => user.refAudit.toString().contains(_searchResult)
                              || user.champ!.toLowerCase().contains(_searchResult)
                          ).toList();
                        });
                      },
                    ),
                  ),
                  Flexible(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        final ref_audit =  filterAudit[index].refAudit;
                        return
                          Column(
                            children: [
                              ListTile(
                                title: Text(
                                  ' Ref Audit : ${ref_audit}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 5.0,),
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
                                            TextSpan(text: '${filterAudit[index].dateDebPrev}'),

                                            //TextSpan(text: '${action.declencheur}'),
                                          ],

                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 2, bottom: 2),
                                        child: RichText(
                                          text: TextSpan(
                                            style: Theme.of(context).textTheme.bodyLarge,
                                            children: [
                                              WidgetSpan(
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                                  child: Text('Champ : ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),),
                                                ),
                                              ),
                                              TextSpan(text: '${filterAudit[index].champ}'),
                                            ],

                                          ),
                                        ),
                                      ),
                                      Text('Ref interne : ${filterAudit[index].interne}',
                                      style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[700]),)
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
                                          final _addItemFormKey = GlobalKey<FormState>();
                                          TextEditingController commentaireController = TextEditingController();
                                          Object? affectation = 1;
                                          //get confirm Audit audite
                                          await AuditService().getConfirmAuditAudite(ref_audit, 0)
                                          .then((response){
                                            setState(() {
                                              commentaireController.text = response['commentaire'].toString();
                                              affectation = response['confirme'] ?? 1;
                                            });
                                          },
                                          onError: (error){
                                            ShowSnackBar.snackBar('Error', error.toString(), Colors.red);
                                          });
                                          //confirme/decline audite

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
                                                  child: StatefulBuilder(
                                                    builder: (BuildContext context, StateSetter setState) {
                                                      return ListBody(
                                                        children: <Widget>[
                                                          SizedBox(height: 5.0,),
                                                          Padding(
                                                            padding: const EdgeInsets.all(5.0),
                                                            child: Center(
                                                              child: Text('Ref N°${filterAudit[index].idAudit} : Confirmation/Declination', style: TextStyle(
                                                                  fontWeight: FontWeight.w500, fontFamily: "Brand-Bold",
                                                                  color: Color(0xFF0769D2), fontSize: 20.0
                                                              ),),
                                                            ),
                                                          ),
                                                          SizedBox(height: 15.0,),
                                                          Form(
                                                            key: _addItemFormKey,
                                                            child: Column(
                                                              children: [
                                                                Column(
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Radio(value: 1,
                                                                          groupValue: affectation,
                                                                          onChanged: (value){
                                                                            setState(() => affectation = value);
                                                                          },
                                                                          activeColor: Colors.blue,
                                                                          fillColor: MaterialStateProperty.all(Colors.blue),),
                                                                        const Text("Je confirme ma participation", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),)
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Radio(value: 0,
                                                                          groupValue: affectation,
                                                                          onChanged: (value){
                                                                            setState(() => affectation = value);
                                                                          },
                                                                          activeColor: Colors.blue,
                                                                          fillColor: MaterialStateProperty.all(Colors.blue),),
                                                                        const Text("Je décline ma participation", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),)
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                                SizedBox(height: 10,),
                                                                Padding(
                                                                  padding: const EdgeInsets.only(left: 10, right: 10),
                                                                  child: TextFormField(
                                                                    controller: commentaireController,
                                                                    keyboardType: TextInputType.text,
                                                                    textInputAction: TextInputAction.next,
                                                                    decoration: InputDecoration(
                                                                      labelText: 'Commentaire',
                                                                      hintText: 'Commentaire',
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
                                                                    minLines: 2,
                                                                    maxLines: 5,
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
                                                                      if(_addItemFormKey.currentState!.validate()){
                                                                        try {
                                                                          await AuditService().confirmeAuditEnTantqueAuditeur({
                                                                            "mat": matricule.toString(),
                                                                            "refAudit": ref_audit,
                                                                            "confirm": affectation.toString(),
                                                                            "commentaire": commentaireController.text
                                                                          }).then((response) async {
                                                                            await ApiControllersCall().getAuditEnTantQueAuditeur();
                                                                            Get.back();
                                                                            ShowSnackBar.snackBar("Successfully", "data added ", Colors.green);
                                                                            //Get.offAll(ActionIncidentSecuritePage(numFiche: widget.numFiche));
                                                                           /* setState(() {
                                                                              listAudit.clear();
                                                                              controller.clear();
                                                                              filterAudit.clear();
                                                                              getData();
                                                                            }); */
                                                                          },
                                                                              onError: (error){
                                                                                ShowSnackBar.snackBar("error", error.toString(), Colors.red);
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
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                ),
                                              )
                                          );

                                        },
                                        icon: Icon(Icons.edit, color: Colors.green,),
                                        tooltip: 'Confirmation/Déclinaison',
                                      ),
                                    ],
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
                      itemCount: filterAudit.length,
                    ),
                  )
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
