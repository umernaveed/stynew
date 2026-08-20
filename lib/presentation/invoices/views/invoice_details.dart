import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:straight_to_yard/app/extensions/string_ext.dart';
import 'package:straight_to_yard/data/models/invoice_detail/invoice_detail.dart';
import 'package:straight_to_yard/presentation/auth/widgets/auth_app_bar.dart';
import 'package:straight_to_yard/presentation/base_screen.dart';
import 'package:straight_to_yard/presentation/invoices/controller/invoice_detail_controller.dart';
import 'package:straight_to_yard/presentation/widgets/shimmer_widget.dart';

class InvoiceDetails extends GetView<InvoiceDetailController> {
  const InvoiceDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    if (args != null) {
      controller.getInviceDetails(args.toString());
    }

    return BaseScreen(
      wrapWithAnnotatedRegion: true,
      backgroundColor: const Color(0xFFF8FBFF),
      value: SystemUiOverlayStyle.dark,
      appBar: const AuthCustomAppBar.withSmallAppLogo(
        backButtonVisible: true,
        usingNavigator: true,
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: _InvoiceBackground()),
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(3.6.w, 1.2.h, 3.6.w, 3.h),
            child: controller.obx(
              onLoading: const _InvoiceShimmer(),
              onError: (error) => SizedBox(
                height: context.height / 1.5,
                width: context.width,
                child: const Center(
                  child: Text(
                    'Something went wrong try again later',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF08102A),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              (state) {
                if (state == null) return const SizedBox.shrink();
                return _InvoiceContent(state: state);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _InvoiceContent extends StatelessWidget {
  const _InvoiceContent({required this.state});

  final InvoiceDetailResponse state;

  @override
  Widget build(BuildContext context) {
    final firstDetail = state.invoiceDetail.isNotEmpty
        ? state.invoiceDetail.first
        : null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CompanyHeader(state: state),
          const SizedBox(height: 24),
          _InvoiceToSection(state: state),
          const SizedBox(height: 20),
          const _SectionTitle('INVOICE DETAILS'),
          const SizedBox(height: 14),
          if (firstDetail != null)
            _InvoiceDetailsGrid(
              state: state,
              detail: firstDetail,
            )
          else
            const _EmptyDetailsCard(),
          if (state.additionalFee?.isNotEmpty ?? false) ...[
            const SizedBox(height: 16),
            _AdditionalFee(data: state),
          ],
          const SizedBox(height: 20),
          _TotalsCard(state: state),
          const SizedBox(height: 18),
          _ContactStrip(state: state),
        ],
      ),
    );
  }
}

class _CompanyHeader extends StatelessWidget {
  const _CompanyHeader({required this.state});

  final InvoiceDetailResponse state;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: _firstWords(state.companyName, 1),
                      style: const TextStyle(color: Color(0xFF078A20)),
                    ),
                    TextSpan(
                      text: _remainingWords(state.companyName, 1),
                      style: const TextStyle(color: Color(0xFF0D62F0)),
                    ),
                  ],
                ),
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                  height: 1.12,
                ),
              ),
              const SizedBox(height: 18),
              _HeaderLine(
                icon: Icons.location_on_outlined,
                text: state.localAddress,
              ),
              const SizedBox(height: 12),
              _HeaderLine(
                icon: Icons.phone_in_talk_outlined,
                text: 'Phone: ${state.phone}',
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        const _InvoiceArt(),
      ],
    );
  }

  static String _firstWords(String value, int count) {
    final words = value.trim().split(RegExp(r'\s+'));
    if (words.isEmpty || words.first.isEmpty) return 'STRAIGHT';
    return '${words.take(count).join(' ')} ';
  }

  static String _remainingWords(String value, int count) {
    final words = value.trim().split(RegExp(r'\s+'));
    if (words.length <= count) return 'TO YARD COURIER';
    return words.skip(count).join(' ');
  }
}

class _HeaderLine extends StatelessWidget {
  const _HeaderLine({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF0D62F0), size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text.isEmpty ? '-' : text,
            style: const TextStyle(
              color: Color(0xFF34405B),
              fontSize: 15,
              fontWeight: FontWeight.w500,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}

class _InvoiceArt extends StatelessWidget {
  const _InvoiceArt();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 114,
      height: 126,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            right: 4,
            top: 22,
            child: Container(
              width: 92,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFF0DB04A).withOpacity(0.14),
                borderRadius: BorderRadius.circular(40),
              ),
            ),
          ),
          Transform.rotate(
            angle: 0.08,
            child: Container(
              width: 74,
              height: 96,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF7FAFF),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF9FB3D5).withOpacity(0.22),
                    offset: const Offset(0, 9),
                    blurRadius: 18,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'INVOICE',
                    style: TextStyle(
                      color: Color(0xFF0D3DAE),
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 13),
                  for (var i = 0; i < 3; i++) ...[
                    Container(
                      height: 3,
                      width: i == 2 ? 28 : 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF5E86E9),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 18,
            child: Container(
              width: 46,
              height: 46,
              decoration: const BoxDecoration(
                color: Color(0xFF135EF4),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.attach_money_rounded,
                color: Colors.white,
                size: 31,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InvoiceToSection extends StatelessWidget {
  const _InvoiceToSection({required this.state});

  final InvoiceDetailResponse state;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFFE1E7F1)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB8C5D8).withOpacity(0.14),
            offset: const Offset(0, 8),
            blurRadius: 18,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle('INVOICE TO'),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final stacked = constraints.maxWidth < 600;
              final user = _InvoiceUserInfo(state: state);
              final meta = _InvoiceMetaCard(state: state);
              if (stacked) {
                return Column(
                  children: [
                    user,
                    const SizedBox(height: 16),
                    meta,
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: user),
                  const SizedBox(width: 18),
                  SizedBox(width: 250, child: meta),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _InvoiceUserInfo extends StatelessWidget {
  const _InvoiceUserInfo({required this.state});

  final InvoiceDetailResponse state;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SoftIcon(icon: Icons.person_outline_rounded),
        const SizedBox(width: 18),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _StrongText(state.userName),
              const SizedBox(height: 10),
              _BodyText(state.address1),
              const SizedBox(height: 10),
              _BodyText('Account no : ${state.mailboxNo}'),
              const SizedBox(height: 10),
              _BodyText('Email : ${state.email}'),
            ],
          ),
        ),
      ],
    );
  }
}

class _InvoiceMetaCard extends StatelessWidget {
  const _InvoiceMetaCard({required this.state});

  final InvoiceDetailResponse state;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FBFF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFDDE6F4)),
      ),
      child: Column(
        children: [
          _MetaRow(
            icon: Icons.receipt_long_outlined,
            label: 'Invoice No.',
            value: '#${state.invoiceNo}',
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 11),
            child: Divider(height: 1, color: Color(0xFFDCE4F0)),
          ),
          _MetaRow(
            icon: Icons.calendar_month_outlined,
            label: 'Date',
            value: state.datePaid.toDDMMYYYY,
          ),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _SmallIcon(icon: icon),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _BodyText(label),
              const SizedBox(height: 6),
              _StrongText(value),
            ],
          ),
        ),
      ],
    );
  }
}

class _InvoiceDetailsGrid extends StatelessWidget {
  const _InvoiceDetailsGrid({
    required this.state,
    required this.detail,
  });

  final InvoiceDetailResponse state;
  final InvoiceDetail detail;

  @override
  Widget build(BuildContext context) {
    final freight =
        state.freightType.toLowerCase() == 'straight_to_yard'
            ? 'Regular Air Freight'
            : 'Express Air Freight';

    final rows = [
      _DetailTileData(Icons.tag_rounded, 'SR.#', '1'),
      _DetailTileData(Icons.inventory_2_outlined, 'HAWB', detail.manifestNo),
      _DetailTileData(
        Icons.flight_takeoff_rounded,
        freight,
        '${detail.packagePrice} JMD',
      ),
      _DetailTileData(
        Icons.inventory_outlined,
        'Custom Fee',
        '${detail.customFee} JMD',
      ),
      _DetailTileData(Icons.local_offer_outlined, 'Service Fee',
          '${detail.serviceFee} JMD'),
      _DetailTileData(
        Icons.description_outlined,
        'Description',
        '${detail.packageDescription} / ${detail.packageWeight} lbs',
      ),
      _DetailTileData(
        Icons.account_balance_wallet_outlined,
        'Amount',
        '${detail.packageTotal} JMD',
      ),
      _DetailTileData(Icons.inventory_2_outlined, 'GCT', '${state.gstTotal} JMD'),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth > 520 ? 2 : 1;
        return GridView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: rows.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            childAspectRatio: columns == 2 ? 3.15 : 4.1,
            crossAxisSpacing: 18,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) => _DetailTile(rows[index]),
        );
      },
    );
  }
}

class _DetailTileData {
  const _DetailTileData(this.icon, this.label, this.value);

  final IconData icon;
  final String label;
  final String value;
}

class _DetailTile extends StatelessWidget {
  const _DetailTile(this.data);

  final _DetailTileData data;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _SoftIcon(icon: data.icon, size: 50, iconSize: 26),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _BodyText(data.label),
              const SizedBox(height: 7),
              Text(
                data.value.isEmpty ? '-' : data.value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF08102A),
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  height: 1.18,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AdditionalFee extends StatelessWidget {
  const _AdditionalFee({this.data});

  final InvoiceDetailResponse? data;

  @override
  Widget build(BuildContext context) {
    final fee = data?.additionalFee ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle('ADDITIONAL FEE'),
        const SizedBox(height: 12),
        for (final item in fee) ...[
          _DetailTile(
            _DetailTileData(
              Icons.add_card_outlined,
              item.name,
              '${item.serviceFee} JMD',
            ),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _TotalsCard extends StatelessWidget {
  const _TotalsCard({required this.state});

  final InvoiceDetailResponse state;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBFE3C8)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final stacked = constraints.maxWidth < 520;
          final breakdown = Column(
            children: [
              _TotalLine('Sub - Total amount', '${state.subTotal} JMD'),
              const SizedBox(height: 15),
              _TotalLine('Discount', '${state.discountPrice} JMD'),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Divider(height: 1, color: Color(0xFFDCE4F0)),
              ),
              _TotalLine(
                'Total',
                '${state.grandTotal} JMD',
                strong: true,
              ),
            ],
          );
          final total = _GrandTotal(value: state.grandTotal);

          if (stacked) {
            return Column(
              children: [
                breakdown,
                const SizedBox(height: 18),
                total,
              ],
            );
          }

          return Row(
            children: [
              Expanded(child: breakdown),
              Container(
                width: 1,
                height: 110,
                margin: const EdgeInsets.symmetric(horizontal: 26),
                color: const Color(0xFFDCE4F0),
              ),
              SizedBox(width: 210, child: total),
            ],
          );
        },
      ),
    );
  }
}

class _TotalLine extends StatelessWidget {
  const _TotalLine(
    this.label,
    this.value, {
    this.strong = false,
  });

  final String label;
  final String value;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: strong ? const Color(0xFF0D62F0) : const Color(0xFF08102A),
              fontSize: 15,
              fontWeight: strong ? FontWeight.w800 : FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: strong ? const Color(0xFF0D62F0) : const Color(0xFF08102A),
            fontSize: 15,
            fontWeight: strong ? FontWeight.w900 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _GrandTotal extends StatelessWidget {
  const _GrandTotal({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 43,
          height: 43,
          decoration: const BoxDecoration(
            color: Color(0xFF078A20),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.attach_money_rounded,
            color: Colors.white,
            size: 28,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'JMD',
          style: TextStyle(
            color: Color(0xFF08102A),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          value.isEmpty ? '0.00' : value,
          style: const TextStyle(
            color: Color(0xFF08102A),
            fontSize: 32,
            fontWeight: FontWeight.w900,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _ContactStrip extends StatelessWidget {
  const _ContactStrip({required this.state});

  final InvoiceDetailResponse state;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FBFF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFDDE6F4)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final stacked = constraints.maxWidth < 520;
          final phone = _ContactItem(
            icon: Icons.phone_in_talk_outlined,
            label: 'Phone',
            value: state.phone,
          );
          final email = _ContactItem(
            icon: Icons.mail_outline_rounded,
            label: 'Email',
            value: state.siteEmail,
          );

          if (stacked) {
            return Column(
              children: [
                phone,
                const SizedBox(height: 14),
                email,
              ],
            );
          }

          return Row(
            children: [
              Expanded(child: phone),
              Container(
                width: 1,
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 22),
                color: const Color(0xFFDCE4F0),
              ),
              Expanded(child: email),
            ],
          );
        },
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  const _ContactItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _SoftIcon(icon: icon, size: 50, iconSize: 27),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _BodyText(label),
              const SizedBox(height: 6),
              _StrongText(value),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: const TextStyle(
            color: Color(0xFF0D62F0),
            fontSize: 17,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: 14,
          height: 2,
          color: const Color(0xFF0DB04A),
        ),
      ],
    );
  }
}

class _SoftIcon extends StatelessWidget {
  const _SoftIcon({
    required this.icon,
    this.size = 58,
    this.iconSize = 31,
  });

  final IconData icon;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFEFF8F1),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Icon(
        icon,
        color: const Color(0xFF078A20),
        size: iconSize,
      ),
    );
  }
}

class _SmallIcon extends StatelessWidget {
  const _SmallIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 51,
      height: 51,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDDE6F4)),
      ),
      child: Icon(
        icon,
        color: const Color(0xFF078A20),
        size: 27,
      ),
    );
  }
}

class _StrongText extends StatelessWidget {
  const _StrongText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.isEmpty ? '-' : text,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: Color(0xFF08102A),
        fontSize: 16,
        fontWeight: FontWeight.w800,
        height: 1.18,
      ),
    );
  }
}

class _BodyText extends StatelessWidget {
  const _BodyText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.isEmpty ? '-' : text,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: Color(0xFF34405B),
        fontSize: 15,
        fontWeight: FontWeight.w500,
        height: 1.28,
      ),
    );
  }
}

class _EmptyDetailsCard extends StatelessWidget {
  const _EmptyDetailsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FBFF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFDDE6F4)),
      ),
      child: const Center(
        child: Text(
          'No invoice details found',
          style: TextStyle(
            color: Color(0xFF08102A),
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _InvoiceBackground extends StatelessWidget {
  const _InvoiceBackground();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _InvoiceBackgroundPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _InvoiceBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final green = Paint()..color = const Color(0xFF0DB04A).withOpacity(0.18);
    final blue = Paint()..color = const Color(0xFF0D62F0).withOpacity(0.12);
    final dot = Paint()..color = const Color(0xFF0DB04A).withOpacity(0.22);

    canvas.drawCircle(Offset(size.width + 22, size.height * 0.18), 95, green);
    canvas.drawCircle(Offset(size.width - 5, size.height - 10), 110, green);
    canvas.drawCircle(Offset(-18, size.height * 0.72), 82, blue);

    for (var i = 0; i < 7; i++) {
      for (var j = 0; j < 8; j++) {
        canvas.drawCircle(
          Offset(8 + i * 13, size.height * 0.43 + j * 13),
          1.9,
          dot,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _InvoiceShimmer extends StatelessWidget {
  const _InvoiceShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerWidget(
            height: 40,
            width: context.width * 0.75,
            radius: BorderRadius.circular(6),
            child: const SizedBox.shrink(),
          ),
          const SizedBox(height: 26),
          for (var i = 0; i < 8; i++) ...[
            ShimmerWidget(
              height: 58,
              width: double.infinity,
              radius: BorderRadius.circular(12),
              child: const SizedBox.shrink(),
            ),
            const SizedBox(height: 14),
          ],
        ],
      ),
    );
  }
}
