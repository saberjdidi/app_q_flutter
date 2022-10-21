import 'package:get/get.dart';
import 'package:qualipro_flutter/Views/action/sources_action_screen.dart';
import 'package:qualipro_flutter/Views/action/sous_action/sous_action_page.dart';
import 'package:qualipro_flutter/Views/audit/audit_page.dart';
import 'package:qualipro_flutter/Views/documentation/documentation_page.dart';
import '../Bindings/dashboard_binding.dart';
import '../Middleware/auth_middleware.dart';
import '../Views/action/action_page.dart';
import '../Views/home_page.dart';
import '../Views/incident_environnement/incident_env_page.dart';
import '../Views/incident_securite/incident_securite_page.dart';
import '../Views/login/login_screen.dart';
import '../Views/login/onboarding_page.dart';
import '../Views/pnc/pnc_navigation_bar_page.dart';
import '../Views/reunion/reunion_page.dart';
import '../Views/task/task_local_screen.dart';
import '../Views/task/task_screen.dart';
import '../Views/visite_securite/new_visite_securite.dart';
import '../Views/visite_securite/visite_securite_page.dart';
import 'app_route.dart';

class AppPage {
  static var routesList = [
    GetPage(
        name: AppRoute.login,
        page: () => LoginScreen(),
        binding: DashboardBinding(),
      middlewares: [
        AuthMiddleware()
      ]
    ),
    GetPage(
        name: AppRoute.on_boarding,
        page: () => OnBoardingPage(),
        binding: DashboardBinding()
    ),
    GetPage(
        name: AppRoute.dashboard,
        page: () => HomePage(),
        binding: DashboardBinding()
    ),
    GetPage(
        name: AppRoute.action,
        page: () => ActionPage(),
        binding: DashboardBinding()
    ),
    GetPage(
        name: AppRoute.sous_action,
        page: () => SousActionPage(),
        binding: DashboardBinding()
    ),
    GetPage(
        name: AppRoute.pnc,
        page: () => PNCNavigationBarPage(), //PNCPage()
        binding: DashboardBinding()
    ),
    GetPage(
        name: AppRoute.reunion,
        page: () => ReunionPage(),
        binding: DashboardBinding()
    ),
    GetPage(
        name: AppRoute.documentation,
        page: () => DocumentationPage(),
        binding: DashboardBinding()
    ),
    GetPage(
        name: AppRoute.incident_environnement,
        page: () => IncidentEnvironnementPage(),
        binding: DashboardBinding()
    ),
    GetPage(
        name: AppRoute.incident_securite,
        page: () => IncidentSecuritePage(),
        binding: DashboardBinding()
    ),
    GetPage(
        name: AppRoute.visite_securite,
        page: () => VisiteSecuritePage(),
        binding: DashboardBinding()
    ),
    GetPage(
        name: AppRoute.new_visite_securite,
        page: () => NewVisiteSecuritePage(),
        binding: DashboardBinding()
    ),
    GetPage(
        name: AppRoute.audit,
        page: () => AuditPage(),
        binding: DashboardBinding()
    ),
  /*GetPage(
        name: AppRoute.task,
        page: () => TaskScreen(),
        binding: DashboardBinding()
    ),
    GetPage(
        name: AppRoute.source_action,
        page: () => const SourceActionScreen()
    ),
    GetPage(
    name: AppRoute.action,
    page: () => const ActionsScreen()
    ),
    GetPage(
        name: AppRoute.task_local,
        page: () => const TaskLocalScreen()
    ),*/
  ];
}