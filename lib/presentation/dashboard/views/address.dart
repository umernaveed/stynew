import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:straight_to_yard/app/util/flush_snackbar.dart';
import 'package:straight_to_yard/data/models/dashboard_address_data/dashboard_address_data.dart';
import 'package:straight_to_yard/presentation/dashboard/controllers/dashboard_address_controller.dart';
import 'package:straight_to_yard/presentation/widgets/shimmer_widget.dart';

class Address extends GetView<DashboardAddressController> {
  const Address({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.refreshData,
      color: const Color(0xFF0DB04A),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 2.5.h),
        child: controller.obx(
          onLoading: const _ShimmerLoading(),
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
                AddressItemWidget.air(data: state),
                SizedBox(height: 2.h),
                AddressItemWidget.sea(data: state),
              ],
            );
          },
        ),
      ),
    );
  }
}

class AddressItemWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<_AddressRowData> rows;
  final Color accent;

  const AddressItemWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.rows,
    required this.accent,
  });

  factory AddressItemWidget.air({required DashboardAddressData data}) {
    final setting = data.setting;
    final user = data.userInfo;
    return AddressItemWidget(
      title: 'Your Air Shipping Address',
      subtitle: 'Use this address when shopping online',
      accent: const Color(0xFF0D62F0),
      rows: [
        _AddressRowData(
          label: 'NAME',
          value: user.userName,
          icon: Icons.person_outline_rounded,
        ),
        _AddressRowData(
          label: 'ADDRESS LINE 1',
          value: setting.packageShippingAddress1,
          icon: Icons.home_outlined,
        ),
        _AddressRowData(
          label: 'ADDRESS LINE 2',
          value: user.addressLine2,
          icon: Icons.apartment_rounded,
        ),
        _AddressRowData(
          label: 'CITY',
          value: setting.city,
          icon: Icons.location_city_outlined,
        ),
        _AddressRowData(
          label: 'STATE',
          value: setting.state,
          icon: Icons.place_outlined,
        ),
        _AddressRowData(
          label: 'COUNTRY',
          value: setting.country,
          icon: Icons.flag_outlined,
          flag: _flagForCountry(setting.country),
        ),
        _AddressRowData(
          label: 'ZIP',
          value: setting.zip,
          icon: Icons.mail_outline_rounded,
        ),
      ],
    );
  }

  factory AddressItemWidget.sea({required DashboardAddressData data}) {
    final setting = data.setting;
    final user = data.userInfo;
    return AddressItemWidget(
      title: 'Your Sea Shipping Address',
      subtitle: 'Use this address for sea freight packages',
      accent: const Color(0xFF078A20),
      rows: [
        _AddressRowData(
          label: 'NAME',
          value: user.userName,
          icon: Icons.person_outline_rounded,
        ),
        _AddressRowData(
          label: 'ADDRESS LINE 1',
          value: setting.seaShippingAddress1,
          icon: Icons.home_outlined,
        ),
        _AddressRowData(
          label: 'ADDRESS LINE 2',
          value: setting.seaShippingAddress2,
          icon: Icons.apartment_rounded,
        ),
        _AddressRowData(
          label: 'CITY',
          value: setting.seaCity,
          icon: Icons.location_city_outlined,
        ),
        _AddressRowData(
          label: 'STATE',
          value: setting.seaState,
          icon: Icons.place_outlined,
        ),
        _AddressRowData(
          label: 'COUNTRY',
          value: setting.seaCountry,
          icon: Icons.flag_outlined,
          flag: _flagForCountry(setting.seaCountry),
        ),
        _AddressRowData(
          label: 'ZIP',
          value: setting.seaZip,
          icon: Icons.mail_outline_rounded,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibleRows =
        rows.where((row) => row.value.trim().isNotEmpty).toList();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 19, 20, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB8C5D8).withOpacity(0.23),
            offset: const Offset(0, 10),
            blurRadius: 26,
          ),
        ],
      ),
      child: Column(
        children: [
          _AddressHero(
            title: title,
            subtitle: subtitle,
            accent: accent,
          ),
          const SizedBox(height: 19),
          ...visibleRows.map(
            (row) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _AddressRow(
                data: row,
                accent: accent,
              ),
            ),
          ),
          const SizedBox(height: 2),
          _SecureHint(accent: accent),
        ],
      ),
    );
  }
}

String _flagForCountry(String country) {
  final normalized = country.trim().toLowerCase();
  if (normalized.contains('united states') || normalized == 'usa') {
    return '🇺🇸';
  }
  if (normalized.contains('jamaica')) {
    return '🇯🇲';
  }
  return '🏳️';
}

class _AddressHero extends StatelessWidget {
  const _AddressHero({
    required this.title,
    required this.subtitle,
    required this.accent,
  });

  final String title;
  final String subtitle;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 14.h,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -8,
            top: -18,
            bottom: -18,
            child: Container(
              width: 155,
              decoration: BoxDecoration(
                color: accent.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: 26,
            bottom: 16,
            child: _ShippingIllustration(accent: accent),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 0, 120, 0),
            child: Row(
              children: [
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        accent,
                        const Color(0xFF0DB04A),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: accent.withOpacity(0.22),
                        offset: const Offset(0, 8),
                        blurRadius: 18,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.location_on_rounded,
                    color: Colors.white,
                    size: 45,
                  ),
                ),
                const SizedBox(width: 23),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(text: 'Your '),
                            TextSpan(
                              text: title.contains('Air')
                                  ? 'Air Shipping'
                                  : 'Sea Shipping',
                              style: TextStyle(color: accent),
                            ),
                            const TextSpan(text: ' Address'),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF08102A),
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          height: 1.12,
                        ),
                      ),
                      const SizedBox(height: 9),
                      Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF566078),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          height: 1.2,
                        ),
                      ),
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

class _ShippingIllustration extends StatelessWidget {
  const _ShippingIllustration({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 125,
      height: 90,
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: Transform.rotate(
              angle: -0.22,
              child: Icon(
                Icons.flight_rounded,
                color: accent.withOpacity(0.85),
                size: 62,
              ),
            ),
          ),
          Positioned(
            right: 4,
            bottom: 0,
            child: Icon(
              Icons.inventory_2_rounded,
              color: const Color(0xFFD79A52).withOpacity(0.92),
              size: 66,
            ),
          ),
          Positioned(
            left: 12,
            bottom: 16,
            child: Container(
              width: 34,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: const Icon(
                Icons.flag_rounded,
                color: Color(0xFF0D62F0),
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddressRowData {
  const _AddressRowData({
    required this.label,
    required this.value,
    required this.icon,
    this.flag,
  });

  final String label;
  final String value;
  final IconData icon;
  final String? flag;
}

class _AddressRow extends StatelessWidget {
  const _AddressRow({
    required this.data,
    required this.accent,
  });

  final _AddressRowData data;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 76),
      padding: const EdgeInsets.fromLTRB(16, 12, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE1E7F0),
        ),
      ),
      child: Row(
        children: [
          _RowIcon(
            icon: data.icon,
            accent: accent,
            flag: data.flag,
          ),
          const SizedBox(width: 25),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  data.label,
                  style: TextStyle(
                    color: accent,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  data.value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF08102A),
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _CopyButton(
            accent: accent,
            value: data.value,
          ),
        ],
      ),
    );
  }
}

class _RowIcon extends StatelessWidget {
  const _RowIcon({
    required this.icon,
    required this.accent,
    this.flag,
  });

  final IconData icon;
  final Color accent;
  final String? flag;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7F1),
        borderRadius: BorderRadius.circular(13),
      ),
      alignment: Alignment.center,
      child: flag != null
          ? Text(
              flag!,
              style: TextStyle(fontSize: 35),
            )
          : Icon(
              icon,
              color: accent,
              size: 35,
            ),
    );
  }
}

class _CopyButton extends StatelessWidget {
  const _CopyButton({
    required this.accent,
    required this.value,
  });

  final Color accent;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF5F6F8),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () async {
          await Clipboard.setData(ClipboardData(text: value));
          FlushSnackbar.showSnackBar('Copied to Clipboard');
        },
        child: SizedBox(
          width: 54,
          height: 54,
          child: Icon(
            Icons.copy_rounded,
            color: accent,
            size: 29,
          ),
        ),
      ),
    );
  }
}

class _SecureHint extends StatelessWidget {
  const _SecureHint({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FBF6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: accent,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'Copy this address and use at checkout.',
              style: TextStyle(
                color: Color(0xFF566078),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShimmerLoading extends StatelessWidget {
  const _ShimmerLoading();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ShimmerAddressItemWidget(),
        SizedBox(height: 2.h),
        const ShimmerAddressItemWidget(),
      ],
    );
  }
}

class ShimmerAddressItemWidget extends StatelessWidget {
  const ShimmerAddressItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 19, 20, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB8C5D8).withOpacity(0.23),
            offset: const Offset(0, 10),
            blurRadius: 26,
          ),
        ],
      ),
      child: Column(
        children: [
          ShimmerWidget(
            height: 14.h,
            radius: BorderRadius.circular(20),
            width: double.infinity,
            child: const SizedBox.shrink(),
          ),
          const SizedBox(height: 19),
          ...List.generate(
            7,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ShimmerWidget(
                radius: BorderRadius.circular(16),
                width: double.infinity,
                height: 76,
                child: const SizedBox.shrink(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
