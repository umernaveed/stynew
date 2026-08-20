import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:straight_to_yard/app/core/routes/app_pages.dart';
import 'package:straight_to_yard/app/util/flush_snackbar.dart';
import 'package:straight_to_yard/presentation/auth/controllers/login_controller.dart';
import 'package:straight_to_yard/presentation/base_screen.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      wrapWithAnnotatedRegion: true,
      value: SystemUiOverlayStyle.dark,
      showGradients: false,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          const Positioned.fill(
            child: CustomPaint(
              painter: _LoginBackgroundPainter(),
            ),
          ),
          Positioned.fill(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.5.w),
                  child: FormBuilder(
                    key: controller.formKey,
                    clearValueOnUnregister: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 6.5.h),
                        SvgPicture.asset(
                          'assets/svgs/app_logo_straight_to_yard.svg',
                          width: 58.w,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: 5.6.h),
                        _LoginCard(controller: controller),
                        SizedBox(height: 8.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginCard extends StatelessWidget {
  const _LoginCard({required this.controller});

  final LoginController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(26, 31, 26, 31),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.97),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFBFD0EA).withOpacity(0.34),
            offset: const Offset(0, 18),
            blurRadius: 32,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome Back! \u{1F44B}',
            style: TextStyle(
              color: Color(0xFF129C48),
              fontSize: 22,
              fontWeight: FontWeight.w700,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'Log In',
            style: TextStyle(
              color: Color(0xFF030A22),
              fontSize: 44,
              fontWeight: FontWeight.w800,
              height: 0.94,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Enter your email and password to continue',
            style: TextStyle(
              color: Color(0xFF687184),
              fontSize: 17,
              fontWeight: FontWeight.w400,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 34),
          _LoginField(
            name: 'email',
            title: 'Email Address',
            hint: 'Enter your email',
            icon: Icons.mail_outline_rounded,
            iconColor: const Color(0xFF0D5AE6),
            keyboardType: TextInputType.emailAddress,
            validator: FormBuilderValidators.compose(
              [
                FormBuilderValidators.required(),
                FormBuilderValidators.email(),
              ],
            ),
          ),
          const SizedBox(height: 29),
          ValueListenableBuilder<bool>(
            valueListenable: controller.passwordVisibility,
            builder: (context, value, child) {
              return _LoginField(
                name: 'password',
                title: 'Password',
                hint: 'Enter your password',
                icon: Icons.lock_outline_rounded,
                iconColor: const Color(0xFF139A4A),
                obscureText: value,
                obscuringCharacter: '\u2022',
                suffixIcon: IconButton(
                  onPressed: controller.onPasswordToggle,
                  icon: Icon(
                    value
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: const Color(0xFF778195),
                    size: 26,
                  ),
                ),
                validator: FormBuilderValidators.compose(
                  [
                    FormBuilderValidators.required(),
                    FormBuilderValidators.minLength(6),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 15),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Get.toNamed(AppPages.forgetPassword),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF006CF1),
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 38),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Forgot Password?',
                style: TextStyle(
                  color: Color(0xFF006CF1),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 26),
          _LoginPrimaryButton(
            onTap: () {
              controller.onLoginPress().then((value) {
                final isDone = value.isDone;
                final message = value.message;
                if (isDone) {
                  Get.offAllNamed(AppPages.bottomNav);
                } else {
                  if (message.isEmpty) return;
                  FlushSnackbar.showSnackBar(message);
                }
              });
            },
          ),
          const SizedBox(height: 31),
          const _OrDivider(),
          const SizedBox(height: 25),
          Center(
            child: Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: "Don't have an account? ",
                    style: TextStyle(
                      color: Color(0xFF030A22),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.baseline,
                    baseline: TextBaseline.alphabetic,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(4),
                      onTap: () => Get.toNamed(AppPages.signUp),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Color(0xFF006CF1),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginField extends StatelessWidget {
  const _LoginField({
    required this.name,
    required this.title,
    required this.hint,
    required this.icon,
    required this.iconColor,
    this.keyboardType,
    this.validator,
    this.obscureText = false,
    this.obscuringCharacter = '\u2022',
    this.suffixIcon,
  });

  final String name;
  final String title;
  final String hint;
  final IconData icon;
  final Color iconColor;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool obscureText;
  final String obscuringCharacter;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF050B25),
            fontSize: 16,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 13),
        FormBuilderTextField(
          name: name,
          validator: validator,
          obscureText: obscureText,
          obscuringCharacter: obscuringCharacter,
          keyboardType: keyboardType,
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
          style: const TextStyle(
            color: Color(0xFF050B25),
            fontSize: 17,
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xFF737E94),
              fontSize: 17,
              fontWeight: FontWeight.w400,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 22,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 17, 12),
              child: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: iconColor,
                  borderRadius: BorderRadius.circular(13),
                  boxShadow: [
                    BoxShadow(
                      color: iconColor.withOpacity(0.22),
                      offset: const Offset(0, 8),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ),
            suffixIcon: suffixIcon,
            prefixIconConstraints: const BoxConstraints(
              minWidth: 77,
              minHeight: 70,
            ),
            suffixIconConstraints: const BoxConstraints(
              minWidth: 56,
              minHeight: 70,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: Color(0xFFDCE4F0),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: Color(0xFF0D6BF2),
                width: 1.2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: Color(0xFFE55555),
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: Color(0xFFE55555),
                width: 1.2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LoginPrimaryButton extends StatelessWidget {
  const _LoginPrimaryButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 69,
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
              color: const Color(0xFF075DE5).withOpacity(0.28),
              offset: const Offset(0, 9),
              blurRadius: 16,
            ),
          ],
        ),
        child: TextButton.icon(
          onPressed: onTap,
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          icon: const Icon(
            Icons.lock_outline_rounded,
            size: 27,
          ),
          label: const Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text(
              'Log In',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFDDE4EE),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: Text(
            'OR',
            style: TextStyle(
              color: Color(0xFF6D7586),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFDDE4EE),
          ),
        ),
      ],
    );
  }
}

class _LoginBackgroundPainter extends CustomPainter {
  const _LoginBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFFF8FBFF),
    );

    final paleBlue = Paint()
      ..color = const Color(0xFFE9F2FF).withOpacity(0.75)
      ..style = PaintingStyle.fill;
    final leftWave = Path()
      ..moveTo(0, 0)
      ..cubicTo(size.width * .34, 0, size.width * .18, size.height * .16,
          size.width * .04, size.height * .25)
      ..cubicTo(size.width * -.05, size.height * .31, size.width * .02,
          size.height * .38, 0, size.height * .42)
      ..close();
    canvas.drawPath(leftWave, paleBlue);

    final rightSoft = Path()
      ..moveTo(size.width * .56, 0)
      ..cubicTo(size.width * .75, size.height * .05, size.width * .93,
          size.height * .12, size.width, size.height * .21)
      ..lineTo(size.width, size.height * .58)
      ..cubicTo(size.width * .9, size.height * .51, size.width * .83,
          size.height * .36, size.width * .83, size.height * .24)
      ..cubicTo(size.width * .82, size.height * .11, size.width * .68,
          size.height * .05, size.width * .56, 0)
      ..close();
    canvas.drawPath(rightSoft, paleBlue);

    final topYellowPath = Path()
      ..moveTo(size.width * .67, 0)
      ..cubicTo(size.width * .83, size.height * .02, size.width * .96,
          size.height * .09, size.width, size.height * .18)
      ..lineTo(size.width, size.height * .105)
      ..cubicTo(size.width * .91, size.height * .045, size.width * .8,
          size.height * .012, size.width * .67, 0)
      ..close();
    canvas.drawPath(topYellowPath, Paint()..color = const Color(0xFFF2D20A));

    final greenTop = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF05A64F), Color(0xFF007B3B)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(
        Rect.fromLTWH(
          size.width * .72,
          0,
          size.width * .28,
          size.height * .23,
        ),
      );
    final topGreenPath = Path()
      ..moveTo(size.width * .73, 0)
      ..cubicTo(size.width * .85, size.height * .03, size.width * .95,
          size.height * .09, size.width, size.height * .18)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(topGreenPath, greenTop);

    final dotsPaint = Paint()
      ..color = Colors.white.withOpacity(0.22)
      ..style = PaintingStyle.fill;
    for (var row = 0; row < 4; row++) {
      for (var col = 0; col < 7; col++) {
        canvas.drawCircle(
          Offset(
            size.width * .86 + col * 11,
            size.height * .052 + row * 15,
          ),
          2.1,
          dotsPaint,
        );
      }
    }

    final yellowBottomPath = Path()
      ..moveTo(0, size.height * .85)
      ..cubicTo(size.width * .26, size.height * 1.02, size.width * .48,
          size.height * .95, size.width * .65, size.height * .99)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(yellowBottomPath, Paint()..color = const Color(0xFFF2D20A));

    final greenBottom = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF069A4B), Color(0xFF006C3F)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(
        Rect.fromLTWH(
          0,
          size.height * .84,
          size.width * .72,
          size.height * .16,
        ),
      );
    final greenBottomPath = Path()
      ..moveTo(0, size.height * .88)
      ..cubicTo(size.width * .22, size.height * .99, size.width * .39,
          size.height * .98, size.width * .57, size.height * .96)
      ..cubicTo(size.width * .43, size.height, size.width * .24,
          size.height * 1.02, 0, size.height)
      ..close();
    canvas.drawPath(greenBottomPath, greenBottom);

    final blueBottom = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF087CF8), Color(0xFF003DCC)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(
        Rect.fromLTWH(
          size.width * .35,
          size.height * .9,
          size.width * .65,
          size.height * .1,
        ),
      );
    final blueBottomPath = Path()
      ..moveTo(size.width * .36, size.height)
      ..cubicTo(size.width * .52, size.height * .94, size.width * .62,
          size.height * .91, size.width * .76, size.height * .95)
      ..cubicTo(size.width * .85, size.height * .98, size.width * .92,
          size.height * .99, size.width, size.height)
      ..close();
    canvas.drawPath(blueBottomPath, blueBottom);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AuthWidgetSpanBuilder extends StatelessWidget {
  const AuthWidgetSpanBuilder({
    super.key,
    required this.firstTitle,
    required this.secondTitle,
    this.onTap,
  });

  final String firstTitle;
  final String secondTitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: firstTitle,
              style: context.textTheme.bodySmall?.copyWith(
                color: const Color(0xFF181725),
                fontSize: 9.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            WidgetSpan(
              child: InkWell(
                splashColor: Colors.blue,
                borderRadius: BorderRadius.circular(3),
                onTap: onTap,
                child: Text(
                  secondTitle,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF4791CE),
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AppButton extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? textColor;
  final BorderSide side;
  final double buttonBorderRadius;

  /// .h is internally used.
  final double height;
  final double? width;
  final double? fontSize;
  const AppButton({
    super.key,
    required this.title,
    this.onTap,
    this.backgroundColor,
    this.textColor,
    this.side = BorderSide.none,
    this.buttonBorderRadius = 19,
    this.height = 6.9,
    this.fontSize,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? context.width,
      height: height.h,
      child: TextButton(
        style: TextButton.styleFrom(
          disabledBackgroundColor: Colors.black12.withOpacity(0.1),
          backgroundColor: backgroundColor ?? const Color(0xFF4791CE),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonBorderRadius),
            side: side,
          ),
        ),
        onPressed: onTap,
        child: Text(
          title,
          style: TextStyle(
            color: textColor ?? const Color(0xFFFFF9FF),
            fontSize: fontSize ?? 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
