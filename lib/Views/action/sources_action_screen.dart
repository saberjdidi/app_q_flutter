import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:qualipro_flutter/Models/audit_action_model.dart';
import 'package:qualipro_flutter/Models/direction_model.dart';
import 'package:qualipro_flutter/Models/employe_model.dart';
import 'package:qualipro_flutter/Models/processus_model.dart';
import 'package:qualipro_flutter/Models/product_model.dart';
import 'package:qualipro_flutter/Models/site_model.dart';
import 'package:qualipro_flutter/Models/action/source_action_model.dart';
import 'package:qualipro_flutter/Models/action/type_action_model.dart';
import 'package:qualipro_flutter/Models/type_cause_model.dart';
import '../../Models/resp_cloture_model.dart';
import '../../Services/action/local_action_service.dart';
import '../../Widgets/loading_widget.dart';
import '../dashboard_screen.dart';

class SourceActionScreen extends StatefulWidget {
  const SourceActionScreen({Key? key}) : super(key: key);

  //static const String sourceActionScreen = "sourceScreen";

  @override
  State<SourceActionScreen> createState() => _SourceActionScreenState();
}

class _SourceActionScreenState extends State<SourceActionScreen> {

  final keyRefresh = GlobalKey<RefreshIndicatorState>();

  LocalActionService service = LocalActionService();
  List<SourceActionModel> sourcesList = <SourceActionModel>[];
  List<TypeActionModel> typeList = <TypeActionModel>[];
  List<TypeCauseModel> causeList = <TypeCauseModel>[];
  List<RespClotureModel> respClotureList = <RespClotureModel>[];
  List<SiteModel> siteList = <SiteModel>[];
  List<ProcessusModel> processusList = <ProcessusModel>[];
  List<ProductModel> productList = <ProductModel>[];
  List<DirectionModel> directionList = <DirectionModel>[];
  List<EmployeModel> employeList = <EmployeModel>[];
  List<AuditActionModel> auditList = <AuditActionModel>[];

  bool _isLoading = true;

  // This method will run once widget is loaded
  // i.e when widget is mounting
  @override
  void initState() {
    super.initState();
    loadList();
  }

  Future loadList() async {
    //keyRefresh.currentState?.show();
    //await Future.delayed(Duration(milliseconds: 4000));

    var responseSource = await service.readSourceAction();
    responseSource.forEach((action){
      setState(() {
        //source
        var sourceModel = SourceActionModel();
        sourceModel.codeSouceAct = action['codeSouceAct'];
        sourceModel.sourceAct = action['sourceAct'];
        sourcesList.add(sourceModel);
      });
    });

    var responseType = await service.readTypeAction();
    responseType.forEach((action){
      setState(() {
        //type
        var typeModel = TypeActionModel();
        typeModel.codetypeAct = action['codetypeAct'];
        typeModel.typeAct = action['typeAct'];
        typeModel.actSimpl = action['actSimpl'];
        typeModel.analyseCause = action['analyseCause'];
        typeList.add(typeModel);
        _isLoading = false;
      });
    });

    var responseCause = await service.readTypeCauseAction();
    responseCause.forEach((action){
      setState(() {
        //type
        var typeModel = TypeCauseModel();
        typeModel.codetypecause = action['codetypecause'];
        typeModel.typecause = action['typecause'];
        causeList.add(typeModel);
        _isLoading = false;
      });
    });

    var responseCloture = await service.readResponsableCloture();
    responseCloture.forEach((action){
      setState(() {
        //type
        var typeModel = RespClotureModel();
        typeModel.mat = action['mat'];
        typeModel.codeSite = action['codeSite'];
        typeModel.codeProcessus = action['codeProcessus'];
        typeModel.nompre = action['nompre'];
        typeModel.site = action['site'];
        typeModel.processus = action['processus'];
        respClotureList.add(typeModel);
        _isLoading = false;
      });
    });

    var responseSite = await service.readSite();
    responseSite.forEach((action){
      setState(() {
        //type
        var typeModel = SiteModel();
        typeModel.codesite = action['codesite'];
        typeModel.site = action['site'];
        siteList.add(typeModel);
        _isLoading = false;
      });
    });

    var responseProcessus = await service.readProcessus();
    responseProcessus.forEach((action){
      setState(() {
        //type
        var typeModel = ProcessusModel();
        typeModel.codeProcessus = action['codeProcessus'];
        typeModel.processus = action['processus'];
        processusList.add(typeModel);
        _isLoading = false;
      });
    });

    var responseProduct = await service.readProduct();
    responseProduct.forEach((action){
      setState(() {
        //type
        var typeModel = ProductModel();
        typeModel.codePdt = action['codePdt'];
        typeModel.produit = action['produit'];
        typeModel.prix = action['prix'];
        typeModel.typeProduit = action['typeProduit'];
        typeModel.codeTypeProduit = action['codeTypeProduit'];
        productList.add(typeModel);
        _isLoading = false;
      });
    });

    var responseDirection = await service.readDirection();
    responseDirection.forEach((action){
      setState(() {
        //type
        var typeModel = DirectionModel();
        typeModel.codeDirection = action['codeDirection'];
        typeModel.direction = action['direction'];
        directionList.add(typeModel);
        _isLoading = false;
      });
    });

    var responseEmploye = await service.readEmploye();
    responseEmploye.forEach((action){
      setState(() {
        //type
        var typeModel = EmployeModel();
        typeModel.mat = action['mat'];
        typeModel.nompre = action['nompre'];
        employeList.add(typeModel);
        _isLoading = false;
      });
    });

    var responseAudit = await service.readAuditAction();
    responseAudit.forEach((action){
      setState(() {
        //type
        var typeModel = AuditActionModel();
        typeModel.refAudit = action['refAudit'];
        typeModel.idaudit = action['idaudit'];
        typeModel.interne = action['interne'];
        auditList.add(typeModel);
        _isLoading = false;
      });
    });

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
              //Navigator.pushNamedAndRemoveUntil(context, DashboardScreen.idScreen, (route) => false);
              Get.offAll(DashboardScreen());
            },
            child: Icon(Icons.arrow_back, color: Colors.blue,),
          ),
          title: Text(
            'Sources',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: (lightPrimary),
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: sourcesList.isNotEmpty ?
            Container(
              child: RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(Duration(seconds: 1),
                      (){
                        setState(() {
                          sourcesList;
                        });
                      }
                  );
                  //refreshData();
                },
                child: ListView.builder(
                  itemCount: auditList.length,
                  itemBuilder: (context, index) {
                    final name = auditList[index].idaudit;
                    if (!_isLoading) {
                      return Card(
                        color: Colors.white60,
                        child: ListTile(
                          textColor: Colors.black87,
                          title: Text('${name}', style: TextStyle(
                            fontSize: 18.0,
                            fontFamily: "Brand-Regular",
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.normal,//make underline
                            decorationStyle: TextDecorationStyle.double, //dou
                            decorationThickness: 1.5,// ble underline
                          ),),
                          //subtitle: Text("${sourcesList[index].SourceAct}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  //_showDialog(context, sourcesList[index].CodeSourceAct);

                                },
                                icon: Icon(Icons.delete, color: Colors.red,),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return LoadingView();
                    }
                  },
                  //itemCount: actionsList.length + 1,
                ),
                triggerMode: RefreshIndicatorTriggerMode.anywhere,
                color: Colors.white,
                backgroundColor: Colors.blue,
              ),
            )
                : const Center(child: Text('Empty List', style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'Brand-Bold'
            )),)
        ),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          spacing: 10.0,
          closeManually: false,
          backgroundColor: Colors.blue,
          spaceBetweenChildren: 15.0,
          children: [
            SpeedDialChild(
                child: Icon(Icons.add, color: Colors.blue, size: 32),
                label: 'New Source',
                labelBackgroundColor: Colors.white,
                backgroundColor: Colors.white,
                onTap: (){
                 // Navigator.push(context, MaterialPageRoute(builder: (context) => AddSourceAction()));
                }
            ),
            SpeedDialChild(
                labelBackgroundColor: Colors.white,
                backgroundColor: Colors.white,
                child: Icon(Icons.search, color: Colors.blue, size: 32),
                label: 'Search Source',
                onTap: (){
                 /* showSearch(
                    context: context,
                    delegate: SearchActionDelegate(actionsList),
                  ); */
                }
            )
          ],
        ),
      ),
    );
  }

  /*void _showDialog(context, position) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: const Text('Are you sure to delete this item?'),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.redAccent,
                ),
                onPressed: () async {
                  int response = await service.deleteSourceAction(position);
                  if(response > 0){
                    //sites.removeWhere((element) => element['id'] == position);
                    sourcesList.removeWhere((element) => element.CodeSourceAct == position);
                    setState(() {});
                  }
                  Navigator.of(context).pop();
                }
            ),
            new FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  } */
}

