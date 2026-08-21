import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sizer/sizer.dart';
import 'package:straight_to_yard/app/core/get_di.dart';
import 'package:straight_to_yard/app/extensions/string_ext.dart';
import 'package:straight_to_yard/app/util/flush_snackbar.dart';
import 'package:straight_to_yard/data/models/get_packages_ready_for_pickup_response/get_packages_ready_for_pickup_response.dart';
import 'package:straight_to_yard/presentation/controller/download_file_controller.dart';
import 'package:straight_to_yard/presentation/dashboard/controllers/dashboard_packages_controller.dart';
import 'package:straight_to_yard/presentation/widgets/dialogs/download_dialog.dart';
import 'package:straight_to_yard/presentation/widgets/dialogs/file_upload_dialog.dart';
import 'package:straight_to_yard/presentation/widgets/shimmer_widget.dart';

class Packages extends GetView<DashboardPackagesController> {
  const Packages({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      margin: EdgeInsets.fromLTRB(4.w, 0, 4.w, 2.5.h),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
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
          _SearchAndFilter(controller: controller.textEditingController),
          const SizedBox(height: 21),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => Future.sync(
                () => controller.pagingController.refresh(),
              ),
              color: const Color(0xFF0DB04A),
              child: PagedListView<int, Package>.separated(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const AlwaysScrollableScrollPhysics(),
                pagingController: controller.pagingController,
                builderDelegate: PagedChildBuilderDelegate<Package>(
                  animateTransitions: true,
                  transitionDuration: 500.milliseconds,
                  firstPageProgressIndicatorBuilder: (context) {
                    return const ShimmerListView();
                  },
                  newPageProgressIndicatorBuilder: (context) {
                    return const ShimmerListView();
                  },
                  noItemsFoundIndicatorBuilder: (context) {
                    return const Center(
                      child: Text(
                        'No packages found',
                        style: TextStyle(
                          color: Color(0xFF08102A),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  },
                  itemBuilder: (context, item, index) {
                    return _PackagesItemWidget(item);
                  },
                ),
                separatorBuilder: (context, index) => const SizedBox(height: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchAndFilter extends StatelessWidget {
  const _SearchAndFilter({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            style: const TextStyle(
              color: Color(0xFF08102A),
              fontSize: 17,
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              hintText: 'Search by Tracking ID, Shipper...',
              hintStyle: const TextStyle(
                color: Color(0xFF838A9A),
                fontSize: 17,
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: Color(0xFF08102A),
                size: 32,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 19,
              ),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: Color(0xFFDCE4F0),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: Color(0xFF0D62F0),
                  width: 1.3,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 15),
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () {},
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: const Color(0xFFDCE4F0),
                ),
              ),
              child: const Icon(
                Icons.filter_list_rounded,
                color: Color(0xFF078A20),
                size: 32,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PackagesItemWidget extends GetView<DashboardPackagesController> {
  const _PackagesItemWidget(this.item);

  final Package item;

  @override
  Widget build(BuildContext context) {
    final rows = [
      _PackageRowData(
        title: 'Date',
        value: item.createdAt.toDDMMYYYY,
        icon: Icons.calendar_month_outlined,
      ),
      _PackageRowData(
        title: 'Shipper',
        value: item.courier,
        icon: Icons.person_outline_rounded,
      ),
      _PackageRowData(
        title: 'Weight',
        value: item.weight,
        icon: Icons.scale_outlined,
      ),
      _PackageRowData(
        title: 'Carrier Tracking',
        value: item.supplierTrackingNo,
        icon: Icons.local_shipping_outlined,
        copyable: true,
      ),
      _PackageRowData(
        title: 'Shipment Status',
        value: item.statusName,
        icon: Icons.assignment_turned_in_outlined,
        status: true,
      ),
      _PackageRowData(
        title: 'Description',
        value: item.itemDescription,
        icon: Icons.description_outlined,
      ),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(26, 27, 26, 26),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE8EDF5),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB8C5D8).withOpacity(0.18),
            offset: const Offset(0, 8),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            _PackageTimelineRow(
              data: rows[i],
              isLast: i == rows.length - 1,
            ),
          ],
          const SizedBox(height: 23),
          _InvoiceButton(
            showDownloadButton: item.invoice.isNotEmpty,
            id: item.packegId,
            fileURL: item.invoice,
            onDone: () {
              if (Get.isDialogOpen ?? false) Get.back();
              controller.onUploadingInvoiceDone(item.packegId);
            },
          ),
        ],
      ),
    );
  }
}

class _PackageRowData {
  const _PackageRowData({
    required this.title,
    required this.value,
    required this.icon,
    this.copyable = false,
    this.status = false,
  });

  final String title;
  final String value;
  final IconData icon;
  final bool copyable;
  final bool status;
}

class _PackageTimelineRow extends StatelessWidget {
  const _PackageTimelineRow({
    required this.data,
    required this.isLast,
  });

  final _PackageRowData data;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 74,
            child: Column(
              children: [
                _TimelineIcon(icon: data.icon),
                if (!isLast)
                  Expanded(
                    child: CustomPaint(
                      painter: _DashedLinePainter(),
                      child: const SizedBox(width: 1),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 22),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              decoration: BoxDecoration(
                border: isLast
                    ? null
                    : const Border(
                        bottom: BorderSide(
                          color: Color(0xFFE5EAF1),
                        ),
                      ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.title,
                          style: const TextStyle(
                            color: Color(0xFF222B45),
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 11),
                        data.status
                            ? _StatusPill(status: data.value)
                            : Text(
                                data.value.isEmpty ? '-' : data.value,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Color(0xFF08102A),
                                  fontSize: 19,
                                  fontWeight: FontWeight.w800,
                                  height: 1.18,
                                ),
                              ),
                      ],
                    ),
                  ),
                  if (data.copyable) ...[
                    const SizedBox(width: 12),
                    _CopyTrackingButton(value: data.value),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineIcon extends StatelessWidget {
  const _TimelineIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFFEFF4FF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        icon,
        color: const Color(0xFF0D62F0),
        size: 31,
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final text = status.isEmpty ? 'PENDING' : status.toUpperCase();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F8EA),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 25,
            height: 25,
            decoration: const BoxDecoration(
              color: Color(0xFF0AA033),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
              color: Color(0xFF078A20),
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _CopyTrackingButton extends StatelessWidget {
  const _CopyTrackingButton({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF5F6F8),
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        borderRadius: BorderRadius.circular(13),
        onTap: () async {
          await Clipboard.setData(ClipboardData(text: value));
          FlushSnackbar.showSnackBar('Copied to Clipboard');
        },
        child: const SizedBox(
          width: 47,
          height: 47,
          child: Icon(
            Icons.copy_rounded,
            color: Color(0xFF078A20),
            size: 27,
          ),
        ),
      ),
    );
  }
}

class _InvoiceButton extends StatelessWidget {
  const _InvoiceButton({
    required this.showDownloadButton,
    required this.id,
    this.onDone,
    this.fileURL,
  });

  final bool showDownloadButton;
  final int id;
  final VoidCallback? onDone;
  final String? fileURL;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 71,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF168BFF),
              Color(0xFF0051E4),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF075DE5).withOpacity(0.26),
              offset: const Offset(0, 9),
              blurRadius: 16,
            ),
          ],
        ),
        child: TextButton.icon(
          onPressed: () {
            if (showDownloadButton && (fileURL?.isNotEmpty ?? false)) {
              final controller = find<FileDownloadController>();
              controller.downloadFile(fileURL!);
              Get.dialog(const DownloadDialog());
            } else {
              Get.dialog(
                FileUploadDialog(
                  id: id,
                  onDone: onDone,
                ),
              );
            }
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          icon: Icon(
            showDownloadButton
                ? Icons.file_download_outlined
                : Icons.upload_file_outlined,
            size: 31,
            color: Colors.white,
          ),
          label: Padding(
            padding: const EdgeInsets.only(left: 14),
            child: Text(
              showDownloadButton ? 'Download Invoice' : 'Upload Invoice',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DescriptionWidget extends StatelessWidget {
  const DescriptionWidget({
    super.key,
    required this.description,
    this.title = 'Description',
    this.descStyle,
  });

  final String description;
  final String title;
  final TextStyle? descStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title:',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.black,
            fontSize: 9.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          description,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: descStyle ??
              TextStyle(
                color: Colors.black,
                fontSize: 9.sp,
                fontWeight: FontWeight.w400,
              ),
        ),
      ],
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD7DEEA)
      ..strokeWidth = 1.3;
    const dashHeight = 5.0;
    const dashSpace = 5.0;
    var startY = 0.0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ShimmerListView extends StatelessWidget {
  const ShimmerListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 2,
      itemBuilder: (context, index) {
        return const PackagesShimmer();
      },
      separatorBuilder: (context, index) => const SizedBox(height: 18),
    );
  }
}

class PackagesShimmer extends StatelessWidget {
  const PackagesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(26, 27, 26, 26),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE8EDF5),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB8C5D8).withOpacity(0.18),
            offset: const Offset(0, 8),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        children: List.generate(
          6,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Row(
              children: [
                ShimmerWidget(
                  height: 56,
                  width: 56,
                  radius: BorderRadius.circular(14),
                  child: const SizedBox.shrink(),
                ),
                const SizedBox(width: 38),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerWidget(
                        height: 18,
                        width: 90,
                        radius: BorderRadius.circular(5),
                        child: const SizedBox.shrink(),
                      ),
                      const SizedBox(height: 12),
                      ShimmerWidget(
                        height: 24,
                        width: double.infinity,
                        radius: BorderRadius.circular(6),
                        child: const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
