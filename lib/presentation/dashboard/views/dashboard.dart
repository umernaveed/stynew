import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:straight_to_yard/presentation/dashboard/controllers/dashboard_controller.dart';
import 'package:straight_to_yard/presentation/widgets/shimmer_widget.dart';

class Dashboard extends GetView<DashboardController> {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.refreshData,
      color: const Color(0xFF0DB04A),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 2.5.h),
        child: controller.obx(
          onLoading: const _ShimmerWidget(),
          onEmpty: SizedBox(
            height: 36.h,
            child: const Center(
              child: Text(
                'No data found',
                style: TextStyle(
                  color: Color(0xFF08102A),
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          onError: (error) => SizedBox(
            height: 36.h,
            width: context.width,
            child: const Center(
              child: Text(
                'Something went wrong try again late',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF08102A),
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          (state) {
            if (state == null) return const SizedBox.shrink();
            return Column(
              children: [
                _MetricCard(
                  value: state.wherehouse.toString(),
                  label: 'Total Packages at',
                  highlight: 'Miami Warehouse',
                  color: const Color(0xFF0D62F0),
                  icon: Icons.warehouse_outlined,
                  illustration: Icons.home_work_rounded,
                ),
                SizedBox(height: 2.h),
                _MetricCard(
                  value: state.inTransit.toString(),
                  label: 'Total Packages',
                  highlight: 'In Transit',
                  color: const Color(0xFF078A20),
                  icon: Icons.local_shipping_outlined,
                  illustration: Icons.pin_drop_rounded,
                  showRoute: true,
                ),
                SizedBox(height: 2.h),
                _MetricCard(
                  value: state.outstandingPackage.toString(),
                  label: 'Total Packages',
                  highlight: 'Ready for Pick Up',
                  color: const Color(0xFFFF6A00),
                  icon: Icons.shopping_bag_outlined,
                  illustration: Icons.task_alt_rounded,
                ),
                SizedBox(height: 2.h),
                _MetricCard(
                  value: _balanceText(state.outstandingBalance),
                  label: 'Total Outstanding',
                  highlight: 'Balance',
                  color: const Color(0xFF6539D8),
                  icon: Icons.account_balance_wallet_outlined,
                  illustration: Icons.wallet_rounded,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  String _balanceText(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return '0.00 JMD';
    if (trimmed.toLowerCase().contains('jmd')) return trimmed;
    return '$trimmed JMD';
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.value,
    required this.label,
    required this.highlight,
    required this.color,
    required this.icon,
    required this.illustration,
    this.showRoute = false,
  });

  final String value;
  final String label;
  final String highlight;
  final Color color;
  final IconData icon;
  final IconData illustration;
  final bool showRoute;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 19.h,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB8C5D8).withOpacity(0.22),
            offset: const Offset(0, 10),
            blurRadius: 26,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 6,
              color: color,
            ),
          ),
          Positioned(
            right: 22,
            top: 16,
            child: _DotPattern(color: color),
          ),
          Positioned(
            right: 20,
            bottom: 15,
            child: _Illustration(
              color: color,
              icon: illustration,
              showRoute: showRoute,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(31, 27, 24, 25),
            child: Row(
              children: [
                _IconPanel(
                  color: color,
                  icon: icon,
                ),
                const SizedBox(width: 31),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: color,
                          fontSize: value.length > 8 ? 29 : 39,
                          fontWeight: FontWeight.w800,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 17),
                      Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF29344E),
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        highlight,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: color,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 21.w),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IconPanel extends StatelessWidget {
  const _IconPanel({
    required this.color,
    required this.icon,
  });

  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 94,
      height: 94,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(19),
      ),
      child: Icon(
        icon,
        color: color,
        size: 60,
      ),
    );
  }
}

class _Illustration extends StatelessWidget {
  const _Illustration({
    required this.color,
    required this.icon,
    required this.showRoute,
  });

  final Color color;
  final IconData icon;
  final bool showRoute;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 145,
      height: 95,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (showRoute)
            Positioned(
              left: 0,
              right: 12,
              bottom: 26,
              child: CustomPaint(
                size: const Size(125, 35),
                painter: _RoutePainter(color: color),
              ),
            ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Icon(
              icon,
              color: color.withOpacity(0.88),
              size: 82,
            ),
          ),
          Positioned(
            left: 10,
            bottom: 0,
            child: Container(
              width: 24,
              height: 36,
              decoration: BoxDecoration(
                color: color.withOpacity(0.16),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          Positioned(
            left: 43,
            bottom: 0,
            child: Container(
              width: 27,
              height: 51,
              decoration: BoxDecoration(
                color: color.withOpacity(0.22),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DotPattern extends StatelessWidget {
  const _DotPattern({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 54,
      height: 42,
      child: Wrap(
        spacing: 9,
        runSpacing: 8,
        children: List.generate(
          12,
          (_) => Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

class _RoutePainter extends CustomPainter {
  const _RoutePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(0, size.height * .72)
      ..cubicTo(size.width * .22, size.height * .1, size.width * .42,
          size.height * .95, size.width * .62, size.height * .38)
      ..cubicTo(size.width * .78, -2, size.width * .86, size.height * .65,
          size.width, size.height * .46);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ShimmerWidget extends StatelessWidget {
  const _ShimmerWidget();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      separatorBuilder: (context, index) => SizedBox(height: 2.h),
      itemBuilder: (context, index) {
        return const _DashboardShimmerCard();
      },
    );
  }
}

class _DashboardShimmerCard extends StatelessWidget {
  const _DashboardShimmerCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      height: 19.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB8C5D8).withOpacity(0.22),
            offset: const Offset(0, 10),
            blurRadius: 26,
          ),
        ],
      ),
      padding: const EdgeInsets.all(28),
      child: Row(
        children: [
          ShimmerWidget(
            radius: BorderRadius.circular(19),
            width: 94,
            height: 94,
            child: const SizedBox(),
          ),
          const SizedBox(width: 31),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerWidget(
                  radius: BorderRadius.circular(6),
                  width: 70,
                  height: 34,
                  child: const SizedBox(),
                ),
                const SizedBox(height: 18),
                ShimmerWidget(
                  radius: BorderRadius.circular(6),
                  width: 160,
                  height: 18,
                  child: const SizedBox(),
                ),
                const SizedBox(height: 9),
                ShimmerWidget(
                  radius: BorderRadius.circular(6),
                  width: 140,
                  height: 20,
                  child: const SizedBox(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
