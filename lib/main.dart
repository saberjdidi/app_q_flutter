import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Controllers/login_controller.dart';
import 'Route/app_page.dart';
import 'Route/app_route.dart';
import 'Utils/localisation/change_local.dart';
import 'Utils/localisation/translation.dart';
import 'Utils/shared_preference.dart';
import 'Views/login/login_screen.dart';

late Timer _timer;
void main() async {
  /// 1- Pour initialiser la Firebase pour assurer la liaison entre la couche de widget flutter et le plug-in Firebase ///
  WidgetsFlutterBinding.ensureInitialized(); //use if you have async/await
  //await Firebase.initializeApp();
  //sharedPref = await SharedPreferences.getInstance();
  await SharedPreference.init();
  HttpOverrides.global = MyHttpOverrides(); //for certificate verify error
  runApp( MyApp());
  //runApp( const MyApp());
}

//added to verifiy timer to automatic logout
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => AppRoot();
}

class AppRoot extends StatefulWidget {
  @override
  AppRootState createState() => AppRootState();
}

class AppRootState extends State<AppRoot> {

  bool forceLogout = false;
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();

    _initializeTimer();
  }

  void _initializeTimer() {
    //_timer = Timer.periodic(const Duration(seconds: 10), (_) => _logOutUser);
    _timer = Timer(const Duration(minutes: 15), _logOutUser);
  }

  void _logOutUser() {
    // Log out the user if they're logged in, then cancel the timer.
    // You'll have to make sure to cancel the timer if the user manually logs out
    //   and to call _initializeTimer once the user logs in
    print('logout use timer');
    _timer.cancel();
    setState(() {
      forceLogout = true;
      //print('forceLogout : $forceLogout');
    });
  }

  // You'll probably want to wrap this function in a debounce
  void _handleUserInteraction([_]) {
    //print("_handleUserInteraction");
    if (!_timer.isActive) {
      // This means the user has been logged out
      return;
    }

    _timer.cancel();
    _initializeTimer();
  }
  void navToLoginPage(BuildContext context) {
    if(kDebugMode){
      print("navigate to login");
    }
    //Clear all pref's
    SharedPreference.clearSharedPreference();
    Get.find<LoginController>().usernameController.clear();
    Get.find<LoginController>().passwordController.clear();
    Get.offAll(LoginScreen());
   /* navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
            (Route<dynamic> route) => false); */
  }

  @override
  Widget build(BuildContext context) {
    TranslationController translationController = Get.put(TranslationController());
    if (forceLogout) {
      print("ForceLogout is $forceLogout");
      navToLoginPage(context);
    }
    return Listener(
      //onTap: _handleUserInteraction,
      //onPanDown: _handleUserInteraction,
      //onScaleStart: _handleUserInteraction,
      // ... repeat this for all gesture events
      behavior: HitTestBehavior.translucent,
      onPointerDown: _handleUserInteraction,
      onPointerMove: _handleUserInteraction,
      onPointerUp: _handleUserInteraction,
      child: GetMaterialApp(
        navigatorKey: navigatorKey,
        translations: MyTranslation(),
        title: 'Qualipro',
        debugShowCheckedModeBanner: false,
        locale: translationController.language,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        //initialRoute: SharedPreference.getMatricule() == null ? AppRoute.login : AppRoute.dashboard,
        getPages: AppPage.routesList,

      ),
    );
  }
}
//latest
/*class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

 /* loadData() async {
    await Get.find<ParticipantController>().getData();
  } */

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //Get.lazyPut(() => ParticipantController());
    //loadData();
    TranslationController translationController = Get.put(TranslationController());
    return GetMaterialApp(
      translations: MyTranslation(),
      title: 'Qualipro',
      debugShowCheckedModeBanner: false,
      locale: translationController.language,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //initialRoute: SharedPreference.getMatricule() == null ? AppRoute.login : AppRoute.dashboard,
      getPages: AppPage.routesList,

    );
  }
} */

//for certificate verify error
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}