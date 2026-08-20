import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:straight_to_yard/app/core/get_di.dart';
import 'package:straight_to_yard/data/models/user/user.dart';
import 'package:straight_to_yard/presentation/account/controllers/account_controller.dart';
import 'package:straight_to_yard/presentation/auth/widgets/auth_app_bar.dart';
import 'package:straight_to_yard/presentation/base_screen.dart';
import 'package:straight_to_yard/presentation/dashboard/controllers/dashboard_tabbar_controller.dart';
import 'package:straight_to_yard/presentation/dashboard/views/address.dart';
import 'package:straight_to_yard/presentation/dashboard/views/dashboard.dart';
import 'package:straight_to_yard/presentation/dashboard/views/packages.dart';

class DashboardMainScreen extends GetView<DashboardTabBarController> {
  const DashboardMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      value: SystemUiOverlayStyle.dark,
      showGradients: false,
      backgroundColor: const Color(0xFFF8FBFF),
      body: Stack(
        children: [
          const Positioned.fill(
            child: CustomPaint(
              painter: _DashboardBackgroundPainter(),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(4.w, 1.6.h, 4.w, 0),
                  child: Column(
                    children: [
                      const _DashboardTopBar(),
                      SizedBox(height: 2.8.h),
                      Obx(
                        () => AnimatedSwitcher(
                          duration: const Duration(milliseconds: 180),
                          child: controller.isDashboardSelected
                              ? const Column(
                                  key: ValueKey('dashboard-account-card'),
                                  children: [
                                    _AccountSummaryCard(),
                                    SizedBox(height: 24),
                                  ],
                                )
                              : const SizedBox.shrink(
                                  key: ValueKey('compact-dashboard-header'),
                                ),
                        ),
                      ),
                      _DashboardPillTabs(controller: controller),
                    ],
                  ),
                ),
                SizedBox(height: 1.8.h),
                Expanded(
                  child: TabBarView(
                    controller: controller.tabController,
                    children: const [
                      Dashboard(),
                      Packages(),
                      Address(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardTopBar extends StatelessWidget {
  const _DashboardTopBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _SquareIconButton(
          icon: Icons.menu_rounded,
          onTap: () {},
        ),
        const Spacer(),
        DynamicAppLogo(
          width: 37.w,
          height: 10.h,
          fit: BoxFit.contain,
        ),
        const Spacer(),
        Stack(
          clipBehavior: Clip.none,
          children: [
            _SquareIconButton(
              icon: Icons.notifications_none_rounded,
              onTap: () {},
            ),
            Positioned(
              right: -3,
              top: -4,
              child: Container(
                width: 27,
                height: 27,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF1F1F),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Text(
                  '3',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SquareIconButton extends StatelessWidget {
  const _SquareIconButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      elevation: 10,
      shadowColor: const Color(0xFFB7C6DA).withOpacity(0.35),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: SizedBox(
          width: 64,
          height: 64,
          child: Icon(
            icon,
            color: const Color(0xFF08102A),
            size: 31,
          ),
        ),
      ),
    );
  }
}

class _AccountSummaryCard extends StatelessWidget {
  const _AccountSummaryCard();

  @override
  Widget build(BuildContext context) {
    final accountController = Get.isRegistered<AccountController>()
        ? find<AccountController>()
        : null;

    if (accountController == null) {
      return _buildCard(User.empty());
    }

    return Obx(
      () {
        final user = accountController.user.value;
        return _buildCard(user);
      },
    );
  }

  Widget _buildCard(User user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 21, 20, 21),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB8C5D8).withOpacity(0.25),
            offset: const Offset(0, 12),
            blurRadius: 28,
          ),
        ],
      ),
      child: Row(
        children: [
          _Avatar(user: user),
          const SizedBox(width: 19),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, ${_firstName(user)}',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF08102A),
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Account ID: ${user.mailbox.isEmpty ? '-' : user.mailbox}',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF34405B),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(width: 7),
                    const Icon(
                      Icons.copy_rounded,
                      color: Color(0xFF34405B),
                      size: 21,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBF1),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: const Color(0xFFFFE3A9),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.star_rounded,
                  color: Color(0xFFF5A400),
                  size: 22,
                ),
                SizedBox(width: 8),
                Text(
                  'Gold Member',
                  style: TextStyle(
                    color: Color(0xFFF5A400),
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: 5),
                Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFFF5A400),
                  size: 24,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _firstName(User user) {
    if (user.firstName.trim().isNotEmpty) return user.firstName.trim();
    if (user.completeName.trim().isNotEmpty) return user.completeName.trim();
    return 'User';
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final initials = _initials(user);
    return Container(
      width: 78,
      height: 78,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            Color(0xFF0D62F0),
            Color(0xFF0B9C3B),
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 27,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  String _initials(User user) {
    final first = user.firstName.trim();
    final last = user.lastName.trim();
    final fallback = user.userName.trim();
    final a = first.isNotEmpty
        ? first[0]
        : (fallback.isNotEmpty ? fallback[0] : 'U');
    final b = last.isNotEmpty ? last[0] : (first.length > 1 ? first[1] : '');
    return '$a$b'.toUpperCase();
  }
}

class _DashboardPillTabs extends StatelessWidget {
  const _DashboardPillTabs({required this.controller});

  final DashboardTabBarController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        children: [
          Expanded(
            child: _PillTab(
              title: 'Dashboard',
              icon: Icons.grid_view_rounded,
              selected: controller.isDashboardSelected,
              selectedStyle: _SelectedTabStyle.gradient,
              onTap: () => controller.tabController.animateTo(0),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _PillTab(
              title: 'Packages',
              icon: Icons.inventory_2_outlined,
              selected: controller.isPackagesSelected,
              selectedStyle: _SelectedTabStyle.underline,
              onTap: () => controller.tabController.animateTo(1),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _PillTab(
              title: 'Address',
              icon: Icons.location_on_outlined,
              selected: controller.isAddressSelected,
              selectedStyle: _SelectedTabStyle.gradient,
              onTap: () => controller.tabController.animateTo(2),
            ),
          ),
        ],
      ),
    );
  }
}

enum _SelectedTabStyle {
  gradient,
  underline,
}

class _PillTab extends StatelessWidget {
  const _PillTab({
    required this.title,
    required this.icon,
    required this.selected,
    required this.selectedStyle,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final bool selected;
  final _SelectedTabStyle selectedStyle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isUnderlineSelected =
        selected && selectedStyle == _SelectedTabStyle.underline;
    final foregroundColor = selected
        ? (isUnderlineSelected ? const Color(0xFF0D62F0) : Colors.white)
        : const Color(0xFF08102A);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFB8C5D8).withOpacity(0.24),
              offset: const Offset(0, 10),
              blurRadius: 25,
            ),
          ],
          gradient: selected && selectedStyle == _SelectedTabStyle.gradient
              ? const LinearGradient(
                  colors: [
                    Color(0xFF0DB04A),
                    Color(0xFF0D62F0),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : null,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: foregroundColor,
                  size: 26,
                ),
                const SizedBox(width: 9),
                Flexible(
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: foregroundColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            if (isUnderlineSelected)
              Positioned(
                bottom: 0,
                left: 45,
                right: 45,
                child: Container(
                  height: 3,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D62F0),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DashboardBackgroundPainter extends CustomPainter {
  const _DashboardBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFFF8FBFF),
    );

    final green = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF8DE18F), Color(0xFF0DB04A)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(
        Rect.fromLTWH(0, size.height * .86, size.width * .24, size.height * .14),
      );
    final greenPath = Path()
      ..moveTo(0, size.height * .9)
      ..cubicTo(size.width * .12, size.height * .95, size.width * .13,
          size.height, size.width * .22, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(greenPath, green);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
