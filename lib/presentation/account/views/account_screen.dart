import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:straight_to_yard/app/core/get_di.dart';
import 'package:straight_to_yard/app/core/routes/app_pages.dart';
import 'package:straight_to_yard/app/util/flush_snackbar.dart';
import 'package:straight_to_yard/data/models/user/user.dart';
import 'package:straight_to_yard/presentation/account/controllers/account_controller.dart';
import 'package:straight_to_yard/presentation/auth/widgets/auth_app_bar.dart';
import 'package:straight_to_yard/presentation/base_screen.dart';
import 'package:straight_to_yard/presentation/bottom_nav/controllers/bottom_nav_controller.dart';
import 'package:straight_to_yard/presentation/widgets/dialogs/account_delete_dialog.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomController = find<BottomNavController>();
    return BaseScreen(
      backgroundColor: const Color(0xFFF8FBFF),
      appBar: const AuthCustomAppBar.withSmallAppLogo(backButtonVisible: false),
      showGradients: false,
      value: SystemUiOverlayStyle.dark,
      body: Stack(
        children: [
          const Positioned.fill(child: _AccountBackground()),
          CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 4.h),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      const UserProfileWidget(),
                      SizedBox(height: 2.2.h),
                      _AccountMenuCard(bottomController: bottomController),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AccountMenuCard extends StatelessWidget {
  const _AccountMenuCard({required this.bottomController});

  final BottomNavController bottomController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB8C5D8).withOpacity(0.24),
            offset: const Offset(0, 12),
            blurRadius: 28,
          ),
        ],
      ),
      child: Column(
        children: [
          _AccountTile(
            title: 'Dashboard',
            icon: Icons.home_outlined,
            color: const Color(0xFF0D62F0),
            onTap: () => bottomController.onTabChange(0),
          ),
          const AppDivider(),
          _ExpandableAccountTile(
            title: 'Authorize User',
            icon: Icons.person_rounded,
            color: const Color(0xFF743BEA),
            children: [
              _TileChildWidgetBuilder(
                title: 'Create Authorize User',
                onTap: () {
                  Get.toNamed(
                    AppPages.addAuthorizeUser,
                    id: bottomController.bottomNavNestedID,
                  );
                },
              ),
              _TileChildWidgetBuilder(
                title: 'Authorize Users',
                onTap: () => bottomController.onTabChange(1),
              ),
            ],
          ),
          const AppDivider(),
          _ExpandableAccountTile(
            title: 'My Account',
            icon: Icons.badge_outlined,
            color: const Color(0xFF0DB04A),
            children: [
              _TileChildWidgetBuilder(
                title: 'Add Pre-Alert',
                onTap: () {
                  Get.toNamed(
                    AppPages.addPreAlertScreen,
                    id: bottomController.bottomNavNestedID,
                  );
                },
              ),
              _TileChildWidgetBuilder(
                title: 'Track Packages',
                onTap: () {
                  Get.toNamed(
                    AppPages.trackPackages,
                    id: bottomController.bottomNavNestedID,
                  );
                },
              ),
              _TileChildWidgetBuilder(
                title: 'Invoices',
                onTap: () {
                  Get.toNamed(
                    AppPages.invoices,
                    id: bottomController.bottomNavNestedID,
                  );
                },
              ),
            ],
          ),
          const AppDivider(),
          _ExpandableAccountTile(
            title: 'Delivery System',
            icon: Icons.location_on_rounded,
            color: const Color(0xFFFF8A00),
            children: [
              _TileChildWidgetBuilder(
                title: 'Request Delivery',
                onTap: () => bottomController.onTabChange(2),
              ),
            ],
          ),
          const AppDivider(),
          _ExpandableAccountTile(
            title: 'Purchase Request',
            icon: Icons.shopping_bag_rounded,
            color: const Color(0xFF02B8BB),
            children: [
              _TileChildWidgetBuilder(
                title: 'Create Purchase Request',
                onTap: () {
                  Get.toNamed(
                    AppPages.addPurchase,
                    id: bottomController.bottomNavNestedID,
                  );
                },
              ),
              _TileChildWidgetBuilder(
                title: 'Purchase Requests',
                onTap: () {
                  Get.toNamed(
                    AppPages.purchase,
                    id: bottomController.bottomNavNestedID,
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 18),
          const _LogoutButton(),
          const SizedBox(height: 16),
          const _DeleteButton(),
        ],
      ),
    );
  }
}

class UserProfileWidget extends StatelessWidget {
  const UserProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = find<AccountController>();
    return Obx(
      () {
        final user = controller.user.value;
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(28, 28, 24, 28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFB8C5D8).withOpacity(0.24),
                offset: const Offset(0, 12),
                blurRadius: 28,
              ),
            ],
          ),
          child: Stack(
            children: [
              const Positioned(
                right: -24,
                top: -28,
                bottom: -28,
                child: _ProfileCardPattern(),
              ),
              Row(
                children: [
                  _ProfileAvatar(user: user),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                _displayName(user),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Color(0xFF08102A),
                                  fontSize: 31,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () => Get.toNamed(AppPages.updateProfile),
                              child: const Padding(
                                padding: EdgeInsets.all(5),
                                child: Icon(
                                  Icons.edit_outlined,
                                  color: Color(0xFF0DB04A),
                                  size: 25,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          user.email.isEmpty ? '-' : user.email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF565D6E),
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static String _displayName(User user) {
    final name = user.completeName.trim();
    if (name.isNotEmpty) return name;
    if (user.userName.trim().isNotEmpty) return user.userName.trim();
    return 'User';
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final name = UserProfileWidget._displayName(user);
    final initial = name.isEmpty ? 'U' : name.substring(0, 1);
    return Container(
      width: 112,
      height: 112,
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              Color(0xFFFF633F),
              Color(0xFFFF1717),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Text(
            initial.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 52,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

class _AccountTile extends StatelessWidget {
  const _AccountTile({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 13),
        child: Row(
          children: [
            _MenuIcon(icon: icon, color: color),
            const SizedBox(width: 22),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF08102A),
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF08102A),
              size: 34,
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpandableAccountTile extends StatelessWidget {
  const _ExpandableAccountTile({
    required this.title,
    required this.icon,
    required this.color,
    required this.children,
  });

  final String title;
  final IconData icon;
  final Color color;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: const EdgeInsets.only(left: 84, bottom: 10),
        expandedAlignment: Alignment.centerLeft,
        leading: _MenuIcon(icon: icon, color: color),
        trailing: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Color(0xFF08102A),
          size: 34,
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF08102A),
            fontSize: 21,
            fontWeight: FontWeight.w800,
          ),
        ),
        children: children,
      ),
    );
  }
}

class _TileChildWidgetBuilder extends StatelessWidget {
  const _TileChildWidgetBuilder({
    required this.title,
    this.onTap,
  });

  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF0D62F0),
              size: 22,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF34405B),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context) {
    return _ActionButton(
      title: 'Log Out',
      icon: Icons.logout_rounded,
      color: const Color(0xFF0D62F0),
      backgroundColor: const Color(0xFFF4F8FF),
      borderColor: const Color(0xFFD7E6FF),
      onTap: () {
        final c = find<AccountController>();
        c.onLogOut().then((value) {
          final isDone = value.isDone;
          final message = value.message;
          if (isDone) {
            Get.offAllNamed(AppPages.login);
          } else {
            if (message.isEmpty) return;
            FlushSnackbar.showSnackBar(message);
          }
        });
      },
    );
  }
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton();

  @override
  Widget build(BuildContext context) {
    return _ActionButton(
      title: 'Delete Account',
      icon: Icons.delete_outline_rounded,
      color: const Color(0xFFFF1717),
      backgroundColor: const Color(0xFFFFF2F4),
      borderColor: const Color(0xFFFFD7DE),
      onTap: () async {
        final result =
            await Get.dialog<bool>(const AccountDeleteConfirmationDialog());
        if (!(result ?? false)) return;
        final c = find<AccountController>();
        await c.deleteAccount();
      },
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.title,
    required this.icon,
    required this.color,
    required this.backgroundColor,
    required this.borderColor,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final Color borderColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        height: 76,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            _MenuIcon(
              icon: icon,
              color: color,
              backgroundColor: color.withOpacity(0.1),
            ),
            const SizedBox(width: 22),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: color,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: color,
              size: 32,
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuIcon extends StatelessWidget {
  const _MenuIcon({
    required this.icon,
    required this.color,
    this.backgroundColor,
  });

  final IconData icon;
  final Color color;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: backgroundColor ?? color.withOpacity(0.11),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(
        icon,
        color: color,
        size: 35,
      ),
    );
  }
}

class AppDivider extends StatelessWidget {
  const AppDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      thickness: 1,
      indent: 84,
      color: Color(0xFFE1E7F1),
    );
  }
}

class _ProfileCardPattern extends StatelessWidget {
  const _ProfileCardPattern();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      child: CustomPaint(
        painter: _ProfileCardPatternPainter(),
      ),
    );
  }
}

class _ProfileCardPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final green = Paint()..color = const Color(0xFF0DB04A).withOpacity(0.08);
    final blue = Paint()..color = const Color(0xFF0D62F0).withOpacity(0.09);
    final dot = Paint()..color = const Color(0xFF0DB04A).withOpacity(0.18);

    final greenPath = Path()
      ..moveTo(size.width * 0.15, size.height)
      ..cubicTo(
        size.width * 0.5,
        size.height * 0.82,
        size.width * 0.38,
        size.height * 0.33,
        size.width,
        size.height * 0.23,
      )
      ..lineTo(size.width, size.height)
      ..close();

    final bluePath = Path()
      ..moveTo(size.width * 0.34, size.height)
      ..cubicTo(
        size.width * 0.68,
        size.height * 0.75,
        size.width * 0.6,
        size.height * 0.55,
        size.width,
        size.height * 0.52,
      )
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(greenPath, green);
    canvas.drawPath(bluePath, blue);

    for (var i = 0; i < 5; i++) {
      for (var j = 0; j < 4; j++) {
        canvas.drawCircle(
          Offset(size.width - 86 + i * 18, 24 + j * 18),
          2.5,
          dot,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _AccountBackground extends StatelessWidget {
  const _AccountBackground();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _AccountBackgroundPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _AccountBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final green = Paint()..color = const Color(0xFF0DB04A).withOpacity(0.14);
    final blue = Paint()..color = const Color(0xFF0D62F0).withOpacity(0.08);
    canvas.drawCircle(Offset(size.width + 30, size.height * 0.18), 95, green);
    canvas.drawCircle(Offset(size.width - 5, size.height - 10), 120, green);
    canvas.drawCircle(Offset(-35, size.height * 0.72), 85, blue);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
