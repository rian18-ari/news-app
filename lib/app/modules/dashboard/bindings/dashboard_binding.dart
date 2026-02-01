import 'package:get/get.dart';
import 'package:news/app/modules/cari/bindings/cari_binding.dart';
import 'package:news/app/modules/cari/controllers/cari_controller.dart';
import 'package:news/app/modules/home/bindings/home_binding.dart';
import 'package:news/app/modules/home/controllers/home_controller.dart';

import '../controllers/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(
      () => DashboardController(),
    );
    Get.put(HomeController());
    Get.put(CariController());
  }
}
