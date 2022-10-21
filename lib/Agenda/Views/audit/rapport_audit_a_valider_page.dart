import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:qualipro_flutter/Models/audit/audit_model.dart';
import 'package:qualipro_flutter/Utils/shared_preference.dart';
import 'package:qualipro_flutter/Widgets/refresh_widget.dart';

import '../../../Services/audit/audit_service.dart';
import '../../../Services/audit/local_audit_service.dart';
import '../../../Utils/snack_bar.dart';
import '../../../Views/home_page.dart';
import 'valider_rapport_audit_page.dart';

class RapportAuditAValiderPage extends StatefulWidget {
  const RapportAuditAValiderPage({Key? key}) : super(key: key);

  @override
  State<RapportAuditAValiderPage> createState() => _RapportAuditAValiderPageState();
}

class _RapportAuditAValiderPageState extends State<RapportAuditAValiderPage> {

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
        var response =  await LocalAuditService().readRapportAuditAValider();
        response.forEach((element){
          setState(() {
            var model = new AuditModel();
            model.idAudit = element['idAudit'];
            model.refAudit = element['refAudit'];
            model.champ = element['champ'];
            model.typeA = element['typeA'];
            model.interne = element['interne'];
            listAudit.add(model);
            filterAudit = listAudit;
          });
        });
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile){
        await AuditService().getRapportAuditsAValider()
            .then((response){
          response.forEach((element) {
            setState(() {
              var model = new AuditModel();
              model.idAudit = element['idAudit'];
              model.refAudit = element['refAudit'];
              model.champ = element['champ'];
              model.typeA = element['typeA'];
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: TextButton(
          onPressed: (){
            Get.offAll(HomePage());
          },
          child: Icon(Icons.arrow_back, color: Colors.blue,),
        ),
        title: Text(
          'Rapport Audit A Valider : ${listAudit.length}',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(child:
           listAudit.isNotEmpty
          ? RefreshWidget(
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
                       itemCount: filterAudit.length,
                         itemBuilder: (context, index){
                           final ref_audit = filterAudit[index].refAudit;
                            return Card(
                              color: Colors.white,
                              child: ListTile(
                                title: Text(
                                  ' Ref Audit : ${ref_audit}',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 5.0,),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      Padding(
                                        padding: const EdgeInsets.only(top: 2, bottom: 2),
                                        child: Html(
                                            data: filterAudit[index].champ,
                                          style: {
                                              'body': Style(
                                                  backgroundColor: Color.fromARGB(0x50, 0xee, 0xee, 0xee),
                                                  fontSize: FontSize.large,
                                                  fontWeight: FontWeight.w500,
                                                  margin: EdgeInsets.zero,
                                                  textTransform: TextTransform.none,
                                              )
                                          },
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          style: Theme.of(context).textTheme.bodyLarge,
                                          children: [
                                            WidgetSpan(
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                                child: Text('Type : ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),),
                                              ),
                                            ),
                                            TextSpan(text: '${filterAudit[index].typeA}'),

                                            //TextSpan(text: '${action.declencheur}'),
                                          ],

                                        ),
                                      ),
                                      filterAudit[index].interne=='' ? Text('')
                                      : Text('Ref interne : ${filterAudit[index].interne}',
                                        style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[700]),)
                                    ],
                                  ),
                                ),
                                trailing: InkWell(
                                  onTap: (){
                                    Get.to(ValiderRapportAuditPage(model: filterAudit[index],), transition: Transition.cupertino);
                                  },
                                  child: Icon(Icons.edit, color: Color(
                                      0xDF0D70B3),),
                                ),
                                onTap: (){
                                  Get.to(ValiderRapportAuditPage(model: filterAudit[index],), transition: Transition.cupertino);
                                },
                                hoverColor: Color(0xFEAAF3D3),
                                focusColor: Color(0xDFA6FAFA),
                              ),
                            );
                         }
                     ),
                   ),
                 ],
               )
           )
               : Center(
             child: Text('Empty List', style: TextStyle(
                 fontSize: 20.0,
                 fontFamily: 'Brand-Bold'
             )),
      )

    ),
    );
  }
}
