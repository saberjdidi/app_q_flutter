import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:qualipro_flutter/Views/home_page.dart';
import '../../Models/action/action_sync.dart';
import '../../Models/task_model.dart';
import '../../Services/action/local_action_service.dart';
import '../../Services/local_task_service.dart';
import '../../Utils/Sqflite/db_helper.dart';
import '../../Widgets/loading_widget.dart';
import '../dashboard_screen.dart';

class TaskLocalScreen extends StatefulWidget {
  const TaskLocalScreen({Key? key}) : super(key: key);

  @override
  State<TaskLocalScreen> createState() => _TaskLocalScreenState();
}

class _TaskLocalScreenState extends State<TaskLocalScreen> {
  final keyRefresh = GlobalKey<RefreshIndicatorState>();

  LocalActionService service = LocalActionService();
  List<ActionSync> list = <ActionSync>[];
  /// this variable use to check if the app still fetching data or not. ///
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

    var response = await service.readActionSync();
    response.forEach((action){
      setState(() {
        var sourceModel = ActionSync();
        //sourceModel.id = action['_id'];
        sourceModel.action = action['action'];
        sourceModel.typea = action['typea'];
        sourceModel.codesource = action['codesource'];
        sourceModel.refAudit = action['refAudit'];
        sourceModel.descpb = action['descpb'];
        sourceModel.datepa = action['datepa'];
        sourceModel.codesite = action['codesite'];
        sourceModel.matdeclencheur = action['matdeclencheur'];
        sourceModel.commentaire = action['commentaire'];
        sourceModel.respsuivi = action['respsuivi'];
        sourceModel.matOrigine = action['matOrigine'];
        sourceModel.listTypeCause = null;
        //sourceModel.createdAt = action['createdAt'];
        list.add(sourceModel);
        _isLoading = false;
        print(list.length);
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
              Get.offAll(HomePage());
            },
            child: Icon(Icons.arrow_back, color: Colors.blue,),
          ),
          title: Text(
            'Action Local',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: (lightPrimary),
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: list.isNotEmpty ?
            Container(
              child: RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(Duration(seconds: 1),
                          (){
                        setState(() {
                          list;
                        });
                      }
                  );
                  //refreshData();
                },
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    final site = list[index].action;
                    if (!_isLoading) {
                      return Card(
                        color: Colors.white60,
                        child: ListTile(
                          textColor: Colors.black87,
                          title: Text(site!, style: TextStyle(
                            fontSize: 18.0,
                            fontFamily: "Brand-Regular",
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.normal,//make underline
                            decorationStyle: TextDecorationStyle.double, //dou
                            decorationThickness: 1.5,// ble underline
                          ),),
                          //subtitle: Text("${list[index].SourceAct}"),

                        ),
                      );
                    } else {
                      return LoadingView();
                    }
                  },
                  itemCount: list.length,
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
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            //service.saveTaskStatic();
            print('save');
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 32,),
          backgroundColor: Colors.blue,
        ),
      ),
    );
  }

}
