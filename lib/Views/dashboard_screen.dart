import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controllers/api_controllers_call.dart';
import '../Controllers/onboarding_controller.dart';
import '../Utils/custom_colors.dart';
import '../Widgets/app_bar_title.dart';
import '../Widgets/navigation_drawer_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);
  static const String idScreen = "mainScreen";
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  ApiControllersCall apiControllersCall = ApiControllersCall();

  @override
  void initState() {
    super.initState();
    //syncApiCallToLocalDB();
  }

  Future syncApiCallToLocalDB() async {
    //await Get.find<OnBoardingController>().syncApiCallToLocalDB();
    var connection = await Connectivity().checkConnectivity();
    if(connection == ConnectivityResult.none) {
      Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue,
          snackPosition: SnackPosition.TOP);
    }
    else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
      Get.snackbar(
          "Internet Connection", "Please wait to add all data in DB local", colorText: Colors.blue,
          snackPosition: SnackPosition.TOP);

      await apiControllersCall.getDomaineAffectation();
      await apiControllersCall.getSourceAction();
      await apiControllersCall.getTypeAction();
      await apiControllersCall.getTypeCauseAction();
      await apiControllersCall.getResponsableCloture();
      await apiControllersCall.getSite();
      await apiControllersCall.getProcessus();
      await apiControllersCall.getProduct();
      await apiControllersCall.getDirection();
      await apiControllersCall.getEmploye();
      await apiControllersCall.getAuditAction();
      await apiControllersCall.getActivity();
      await apiControllersCall.getService();
      await apiControllersCall.getPriorite();
      await apiControllersCall.getGravite();
      await apiControllersCall.getChampObligatoireAction();
      await apiControllersCall.getProcessusEmploye();
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        /// 2- to call ui of AppBarTitle class ///
        title: AppBarTitle(),
        iconTheme: IconThemeData(color: CustomColors.blueAccent),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              splashColor: CustomColors.blueAccent,
              onTap: (){
                syncApiCallToLocalDB();
              },
              child: Icon(Icons.sync, color: CustomColors.blueMarin,),
            ),
          )
        ],
      ),
      drawer: NavigationDrawerWidget(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 20.0,
          ),

          /// 5- to call ui of ItemList class and show them in DashboardScreen ///
          child: Center(
            child: Text('Agenda', style: TextStyle(
              color: Colors.black
            ),),
          ),
        ),
      ),
    );
  }
}
