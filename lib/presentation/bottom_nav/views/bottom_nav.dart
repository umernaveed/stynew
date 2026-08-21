import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:straight_to_yard/app/core/routes/app_routes.dart';
import 'package:straight_to_yard/presentation/base_screen.dart';
import 'package:straight_to_yard/presentation/bottom_nav/controllers/bottom_nav_controller.dart';

class BottomNavScreen extends GetView<BottomNavController> {
  const BottomNavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      value: SystemUiOverlayStyle.dark,
      showGradients: false,
      extendBody: true,
      wrapWithAnnotatedRegion: true,
      body: Container(
        margin: const EdgeInsets.only(bottom: 118),
        child: Navigator(
          key: Get.nestedKey(controller.bottomNavNestedID),
          onGenerateRoute: (settings) {
            Get.routing.args = settings.arguments;
            final page = AppRoutes.routes.firstWhere(
              (r) => r.name == settings.name,
            );
            return GetPageRoute<dynamic>(
              page: page.page,
              settings: settings,
              binding: page.binding,
              transition: page.transition,
              parameter: page.parameters,
              opaque: page.opaque,
              popGesture: page.popGesture,
              fullscreenDialog: page.fullscreenDialog,
              maintainState: page.maintainState,
              curve: page.curve,
              middlewares: page.middlewares,
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 1.2.h),
          child: Container(
            height: 78,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFB8C5D8).withOpacity(0.28),
                  offset: const Offset(0, 10),
                  blurRadius: 28,
                ),
              ],
            ),
            child: Obx(
              () => Row(
                children: [
                  _NavItem(
                    label: 'Dashboard',
                    icon: Icons.home_rounded,
                    selectedColor: const Color(0xFF078A20),
                    selectedStyle: _NavSelectedStyle.filled,
                    selected: controller.currentIndex.value == 0,
                    onTap: () => controller.onTabChange(0),
                  ),
                  _NavItem(
                    label: 'Authorize User',
                    icon: Icons.person_outline_rounded,
                    selectedColor: const Color(0xFF0D62F0),
                    selectedStyle: _NavSelectedStyle.underline,
                    selected: controller.currentIndex.value == 1,
                    onTap: () => controller.onTabChange(1),
                  ),
                  _NavItem(
                    label: 'Delivery',
                    icon: Icons.location_on_outlined,
                    selectedColor: const Color(0xFF0D62F0),
                    selectedStyle: _NavSelectedStyle.soft,
                    selected: controller.currentIndex.value == 2,
                    onTap: () => controller.onTabChange(2),
                  ),
                  _NavItem(
                    label: 'News',
                    icon: Icons.newspaper_rounded,
                    selectedColor: const Color(0xFF0D62F0),
                    selectedStyle: _NavSelectedStyle.underline,
                    selected: controller.currentIndex.value == 3,
                    onTap: () => controller.onTabChange(3),
                  ),
                  _NavItem(
                    label: 'Account',
                    icon: Icons.person_outline_rounded,
                    selectedColor: const Color(0xFF0D62F0),
                    selectedStyle: _NavSelectedStyle.underline,
                    selected: controller.currentIndex.value == 4,
                    onTap: () => controller.onTabChange(4),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum _NavSelectedStyle {
  filled,
  soft,
  underline,
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.selectedColor,
    required this.selectedStyle,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color selectedColor;
  final _NavSelectedStyle selectedStyle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final filled = selected && selectedStyle == _NavSelectedStyle.filled;
    final soft = selected && selectedStyle == _NavSelectedStyle.soft;
    final underline = selected && selectedStyle == _NavSelectedStyle.underline;
    final color = selected ? selectedColor : const Color(0xFF08102A);

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(17),
        onTap: onTap,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: filled || soft ? 48 : 38,
                  height: filled || soft ? 48 : 38,
                  decoration: BoxDecoration(
                    color: soft ? const Color(0xFFEFF4FF) : null,
                    borderRadius: BorderRadius.circular(16),
                    gradient: filled
                        ? const LinearGradient(
                            colors: [
                              Color(0xFF0DB04A),
                              Color(0xFF007E39),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                  ),
                  child: Icon(
                    icon,
                    color: filled ? Colors.white : color,
                    size: selected ? 28 : 25,
                  ),
                ),
                const SizedBox(height: 3),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      label,
                      maxLines: 1,
                      style: TextStyle(
                        color: color,
                        fontSize: 10,
                        fontWeight:
                            selected ? FontWeight.w800 : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (underline)
              Positioned(
                bottom: 0,
                child: Container(
                  width: 28,
                  height: 4,
                  decoration: BoxDecoration(
                    color: selectedColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
