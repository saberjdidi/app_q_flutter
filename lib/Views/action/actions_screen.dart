import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';

import '../../Models/action/action_model.dart';
import '../../Services/action/local_action_service.dart';
import '../../Utils/Sqflite/db_helper.dart';
import '../../Widgets/loading_widget.dart';
import '../dashboard_screen.dart';
import 'action_list.dart';
import 'add_action.dart';
import 'search_action.dart';

class ActionsScreen extends StatefulWidget {
  const ActionsScreen({Key? key}) : super(key: key);

  @override
  State<ActionsScreen> createState() => _ActionsScreenState();
}

class _ActionsScreenState extends State<ActionsScreen> {
  List<ActionModel> _actions = <ActionModel>[];
  // used to view all list in our app alse to filtered data as list when searching //
  List<ActionModel> actionsList = <ActionModel>[];
  //service
  LocalActionService actionService = LocalActionService();
  DBHelper dbHelper = DBHelper();
  bool _isLoading = true;
  var count;

  @override
  void initState() {
    super.initState();
    getData();
    getCount();
  }

  getData() async {
    var categories = await actionService.readAction();
    categories.forEach((action){
      setState(() {
        var actionModel = ActionModel();
        actionModel.nAct = action['NAct'];
        actionModel.act = action['Act'];
        //actionModel.DescPb = action['DescPb'];
        //actionModel.MatDeclancheur = action['MatDeclancheur'];
        actionModel.date = action['Date'];
        actionModel.site = action['CodeSite'];
        _actions.add(actionModel);
        actionsList = _actions;
        _isLoading = false;
        print(actionsList.length);
      });
    });

  }

  getCount() async {
    count = await dbHelper.getCountAction();
    print('count : ${count}');
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
            'Actions ${count}',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: (lightPrimary),
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: actionsList.isNotEmpty ?
            Container(
              child: RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(Duration(seconds: 1));
                  //refreshData();
                },
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    if (!_isLoading) {
                      //without search
                      return ActionList(actionModel: this.actionsList[index], );
                      //with search
                      /* return index == 0
                        ? _searchBar()
                        : ActionList(actionModel: this.actionsList[index - 1], ); */
                    } else {
                      return LoadingView();
                    }
                  },
                  itemCount: actionsList.length,
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
                label: 'New Action',
                labelBackgroundColor: Colors.white,
                backgroundColor: Colors.white,
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddAction()));
                }
            ),
            SpeedDialChild(
                labelBackgroundColor: Colors.white,
                backgroundColor: Colors.white,
                child: Icon(Icons.search, color: Colors.blue, size: 32),
                label: 'Search Action',
                onTap: (){
                  showSearch(
                    context: context,
                    delegate: SearchActionDelegate(actionsList),
                  );
                }
            )
          ],
        ),
      ),
    );
  }
}
