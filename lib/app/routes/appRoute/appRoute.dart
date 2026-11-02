import 'package:flutter_application_1/app/core/widgets/homenavigation/homenagivation.dart';
import 'package:flutter_application_1/app/core/widgets/homenavigation/homenavbinding.dart';
import 'package:flutter_application_1/app/module/Additem/binding/additem_binding.dart';
import 'package:flutter_application_1/app/module/Additem/view/additem.dart';
import 'package:flutter_application_1/app/module/Dashboard/binding/DashBinding.dart';
import 'package:flutter_application_1/app/module/Dashboard/view/Homescreen.dart';
import 'package:flutter_application_1/app/module/Login/binding/loginBinding.dart';
import 'package:flutter_application_1/app/module/Login/view/login.dart';
import 'package:flutter_application_1/app/module/StockMovment/Binding/StockBinding.dart';
import 'package:flutter_application_1/app/module/StockMovment/view/stockMovement.dart';
import 'package:flutter_application_1/app/module/Stockhistory/stockBinding/stockBind.dart';
import 'package:flutter_application_1/app/module/Stockhistory/view/stockhistory.dart';
import 'package:flutter_application_1/app/module/chartandanalyse/chartBinding/chartBinding.dart';
import 'package:flutter_application_1/app/module/chartandanalyse/view/analysisView.dart';
import 'package:flutter_application_1/app/module/reports/reportbinding/reportBinding.dart';
import 'package:flutter_application_1/app/module/reports/view/reportview.dart';
import 'package:flutter_application_1/app/routes/appPage/appPage.dart';
import 'package:get/get.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.login,
      page: () => const Loginview(),
      binding: Loginbinding(),
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => Dashboard(),
      binding: Dashbinding(),
    ),
    GetPage(
      name: AppRoutes.addItem,
      page: () => const AddItemView(),
      binding: AddItemBinding(),
    ),
    GetPage(
      name: AppRoutes.analysis,
      page: () => const AnalyticsView(),
      binding: AnalyticsBinding(),
    ),
    GetPage(
      name: AppRoutes.report,
      page: () => const ReportView(),
      binding: ReportBinding(),
    ),
    GetPage(
      name: AppRoutes.homenavbar,
      page: () => const Homenagivation(),
      bindings: [Homenavbinding(), Dashbinding(), AnalyticsBinding()],
    ),
    GetPage(
      name: AppRoutes.stockhistory,
      page: () => const Stockhistory(),
      binding: stockBinding(),
    ),
    GetPage(
      name: AppRoutes.stockmovement,
      page: () => const Stockmovement(),
      binding: Stockoutbinding(),
    ),
  ];
}
