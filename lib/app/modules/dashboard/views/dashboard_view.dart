import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:news/app/modules/cari/views/cari_view.dart';
import 'package:news/app/modules/home/views/home_view.dart';

import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.pageIndex.value,
          children: [HomeView(), CariView()],
        ),
      ),

      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          onTap: controller.changePage,
          currentIndex: controller.pageIndex.value,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.grey[600],
          elevation: 0,
          items: [
            bottomNavigationBarItem(
              icon: Icons.home,
              label: 'Home',
              activeIcon: Icons.home,
            ),
            bottomNavigationBarItem(
              icon: Icons.search,
              label: 'Search',
              activeIcon: Icons.search,
            ),
          ],
        ),
      ),
    );
  }
}

BottomNavigationBarItem bottomNavigationBarItem({
  required IconData icon,
  required String label,
  required IconData activeIcon,
}) {
  return BottomNavigationBarItem(
    icon: Icon(icon, color: Colors.black),
    label: label,
    activeIcon: Icon(activeIcon, color: Colors.white),
  );
}
