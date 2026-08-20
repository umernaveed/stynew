import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:straight_to_yard/app/core/routes/app_pages.dart';
import 'package:straight_to_yard/presentation/auth/controllers/signup_controller.dart';
import 'package:straight_to_yard/presentation/auth/widgets/auth_app_bar.dart';
import 'package:straight_to_yard/presentation/auth/widgets/drop_down.dart';
import 'package:straight_to_yard/presentation/base_screen.dart';

class SignUpScreen extends GetView<SignUpController> {
  const SignUpScreen({super.key});

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
              painter: _RegisterBackgroundPainter(),
            ),
          ),
          Positioned.fill(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: FormBuilder(
                    key: controller.formKey,
                    clearValueOnUnregister: true,
                    autovalidateMode: AutovalidateMode.disabled,
                    child: Column(
                      children: [
                        const SizedBox(height: 18),
                        _RegisterHeader(controller: controller),
                        const SizedBox(height: 25),
                        _RegisterCard(controller: controller),
                        const SizedBox(height: 28),
                        const _RegisterOrDivider(),
                        const SizedBox(height: 20),
                        _LoginFooter(),
                        const SizedBox(height: 54),
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

class _RegisterHeader extends StatelessWidget {
  const _RegisterHeader({required this.controller});

  final SignUpController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: _BackButton(),
          ),
        ),
        Column(
          children: [
            DynamicAppLogo(
              width: 44.w,
              height: 13.h,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 33),
            Text.rich(
              const TextSpan(
                children: [
                  TextSpan(
                    text: 'Create ',
                    style: TextStyle(color: Color(0xFF05112F)),
                  ),
                  TextSpan(
                    text: 'Account',
                    style: TextStyle(color: Color(0xFF078A20)),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w800,
                height: 1,
              ),
            ),
            const SizedBox(height: 13),
            const Text(
              'Fill in your details to get started',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF666A76),
                fontSize: 18,
                fontWeight: FontWeight.w400,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 17),
            Container(
              width: 56,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF078A20),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      elevation: 8,
      shadowColor: const Color(0xFFB6C0D0).withOpacity(0.35),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: Get.back,
        child: const SizedBox(
          width: 54,
          height: 54,
          child: Icon(
            Icons.chevron_left_rounded,
            color: Color(0xFF078A20),
            size: 36,
          ),
        ),
      ),
    );
  }
}

class _RegisterCard extends StatelessWidget {
  const _RegisterCard({required this.controller});

  final SignUpController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(21, 27, 21, 26),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.97),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB9C8DD).withOpacity(0.34),
            offset: const Offset(0, 16),
            blurRadius: 30,
          ),
        ],
      ),
      child: Column(
        children: [
          GetBuilder<SignUpController>(
            id: 'managers',
            builder: (_) {
              if (_.managers.managers.isEmpty) return const SizedBox.shrink();
              return Column(
                children: [
                  _RegisterDropdown<OutLetPair>(
                    name: 'managerId',
                    title: 'Managers (Optional)',
                    hint: 'Select Manager',
                    icon: Icons.person_pin_circle_outlined,
                    onItemSelected: (e) {},
                    validator: FormBuilderValidators.compose([]),
                    items: controller.managers.managers
                        .map(
                          (e) => OutLetPair(
                            key: e.id.toString(),
                            value: e.name,
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 24),
                ],
              );
            },
          ),
          GetBuilder<SignUpController>(
            id: 'outLet',
            builder: (_) {
              return _RegisterDropdown<OutLetPair>(
                name: 'outletId',
                title: 'Outlet',
                hint: 'Select Outlet',
                icon: Icons.storefront_outlined,
                onItemSelected: (e) {},
                items: controller.outLet.outLets
                    .map(
                      (e) => OutLetPair(
                        key: e.outletId,
                        value: e.outletName,
                      ),
                    )
                    .toList(),
              );
            },
          ),
          const SizedBox(height: 24),
          _RegisterDropdown<NormalString>(
            name: 'userType',
            title: 'User Type',
            hint: 'Select User Type',
            icon: Icons.person_outline_rounded,
            onItemSelected: (e) {
              controller.onUserTypeSelect(e?.key ?? 'Personal');
            },
            items: const ['Personal', 'Business']
                .map((e) => NormalString(key: e, value: e))
                .toList(),
          ),
          const SizedBox(height: 28),
          const _TinyDivider(),
          const SizedBox(height: 26),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _RegisterTextField(
                  name: 'firstName',
                  title: 'First Name',
                  hint: 'Enter first name',
                  icon: Icons.person_outline_rounded,
                  validator: FormBuilderValidators.compose(
                    [FormBuilderValidators.required()],
                  ),
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: _RegisterTextField(
                  name: 'lastName',
                  title: 'Last Name',
                  hint: 'Enter last name',
                  icon: Icons.person_outline_rounded,
                  validator: FormBuilderValidators.compose(
                    [FormBuilderValidators.required()],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _RegisterTextField(
            name: 'email',
            title: 'Email',
            hint: 'Enter email address',
            icon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
            validator: FormBuilderValidators.compose(
              [
                FormBuilderValidators.required(),
                FormBuilderValidators.email(),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _RegisterTextField(
            name: 'confirm_email',
            title: 'Confirm Email',
            hint: 'Confirm email address',
            icon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
            validator: FormBuilderValidators.compose(
              [
                FormBuilderValidators.required(),
                FormBuilderValidators.email(),
                (value) {
                  final email =
                      controller.formKey.currentState?.instantValue['email'];
                  return value?.toLowerCase() == email?.toLowerCase()
                      ? null
                      : 'Emails do not match';
                }
              ],
            ),
          ),
          const SizedBox(height: 24),
          ValueListenableBuilder<bool>(
            valueListenable: controller.passwordVisibility,
            builder: (context, value, child) {
              return _RegisterTextField(
                name: 'password',
                title: 'Password',
                hint: 'Enter password',
                icon: Icons.lock_outline_rounded,
                obscureText: value,
                suffixIcon: IconButton(
                  onPressed: controller.onPasswordToggle,
                  icon: Icon(
                    value
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: const Color(0xFF667085),
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
          const SizedBox(height: 24),
          ValueListenableBuilder<bool>(
            valueListenable: controller.confirmPasswordVisibility,
            builder: (context, value, child) {
              return _RegisterTextField(
                name: 'confirm_password',
                title: 'Confirm Password',
                hint: 'Confirm password',
                icon: Icons.lock_outline_rounded,
                obscureText: value,
                suffixIcon: IconButton(
                  onPressed: controller.onConfirmPasswordToggle,
                  icon: Icon(
                    value
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: const Color(0xFF667085),
                  ),
                ),
                validator: FormBuilderValidators.compose(
                  [
                    FormBuilderValidators.required(),
                    FormBuilderValidators.minLength(6),
                    (value) {
                      final pwd = controller
                          .formKey.currentState?.instantValue['password'];
                      return value?.toLowerCase() == pwd?.toLowerCase()
                          ? null
                          : 'Passwords do not match';
                    }
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          _RegisterTextField(
            name: 'phone',
            title: 'Phone (Optional)',
            hint: 'Phone number',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: FormBuilderValidators.compose(
              [FormBuilderValidators.numeric()],
            ),
          ),
          const SizedBox(height: 24),
          _RegisterTextField(
            name: 'address1',
            title: 'Address 1 (Optional)',
            hint: 'Address 1',
            icon: Icons.location_on_outlined,
          ),
          const SizedBox(height: 24),
          const _SecureNotice(),
          const SizedBox(height: 24),
          _CreateAccountButton(
            onTap: controller.onSignUpPress,
          ),
        ],
      ),
    );
  }
}

class _RegisterDropdown<T extends Pair> extends StatelessWidget {
  const _RegisterDropdown({
    required this.name,
    required this.title,
    required this.hint,
    required this.icon,
    required this.items,
    required this.onItemSelected,
    this.validator,
  });

  final String name;
  final String title;
  final String hint;
  final IconData icon;
  final List<T> items;
  final void Function(T?) onItemSelected;
  final String? Function(T?)? validator;

  @override
  Widget build(BuildContext context) {
    return _RegisterFieldFrame(
      title: title,
      child: FormBuilderDropdown<T>(
        name: name,
        validator: validator ??
            FormBuilderValidators.compose(
              [FormBuilderValidators.required()],
            ),
        isExpanded: true,
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Color(0xFF101828),
          size: 30,
        ),
        decoration: _fieldDecoration(
          hint: hint,
          icon: icon,
        ),
        style: const TextStyle(
          color: Color(0xFF101828),
          fontSize: 17,
          fontWeight: FontWeight.w400,
        ),
        onChanged: onItemSelected,
        items: items
            .map(
              (item) => DropdownMenuItem<T>(
                value: item,
                child: Text(
                  item.value,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _RegisterTextField extends StatelessWidget {
  const _RegisterTextField({
    required this.name,
    required this.title,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.validator,
    this.obscureText = false,
    this.suffixIcon,
  });

  final String name;
  final String title;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return _RegisterFieldFrame(
      title: title,
      child: FormBuilderTextField(
        name: name,
        keyboardType: keyboardType,
        validator: validator,
        obscureText: obscureText,
        obscuringCharacter: '\u2022',
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
        style: const TextStyle(
          color: Color(0xFF101828),
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        decoration: _fieldDecoration(
          hint: hint,
          icon: icon,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}

class _RegisterFieldFrame extends StatelessWidget {
  const _RegisterFieldFrame({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF05112F),
            fontSize: 17,
            fontWeight: FontWeight.w700,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 13),
        child,
      ],
    );
  }
}

InputDecoration _fieldDecoration({
  required String hint,
  required IconData icon,
  Widget? suffixIcon,
}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(
      color: Color(0xFF8A8F9C),
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 18,
      vertical: 20,
    ),
    prefixIcon: Padding(
      padding: const EdgeInsets.fromLTRB(12, 11, 15, 11),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFFEAF8ED),
          borderRadius: BorderRadius.circular(11),
        ),
        child: Icon(
          icon,
          color: const Color(0xFF078A20),
          size: 25,
        ),
      ),
    ),
    suffixIcon: suffixIcon,
    prefixIconConstraints: const BoxConstraints(
      minWidth: 72,
      minHeight: 68,
    ),
    suffixIconConstraints: const BoxConstraints(
      minWidth: 52,
      minHeight: 68,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(
        color: Color(0xFFD9E0EA),
        width: 1,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(
        color: Color(0xFF078A20),
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
  );
}

class _TinyDivider extends StatelessWidget {
  const _TinyDivider();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: Divider(
            color: Color(0xFFE2E7EF),
            thickness: 1,
            height: 1,
          ),
        ),
        SizedBox(width: 13),
        SizedBox(
          width: 82,
          child: Divider(
            color: Color(0xFF078A20),
            thickness: 1,
            height: 1,
          ),
        ),
        SizedBox(width: 13),
        Expanded(
          child: Divider(
            color: Color(0xFFE2E7EF),
            thickness: 1,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _SecureNotice extends StatelessWidget {
  const _SecureNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FCFA),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFDDE5E1)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Color(0xFF0A982A),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 27,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your information is secure with us',
                  style: TextStyle(
                    color: Color(0xFF05112F),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'We never share your details with anyone',
                  style: TextStyle(
                    color: Color(0xFF666A76),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.25,
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

class _CreateAccountButton extends StatelessWidget {
  const _CreateAccountButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 72,
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
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF075DE5).withOpacity(0.28),
              offset: const Offset(0, 9),
              blurRadius: 16,
            ),
          ],
        ),
        child: TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.person_add_alt_1_outlined,
                color: Colors.white,
                size: 30,
              ),
              const SizedBox(width: 19),
              const Flexible(
                child: Text(
                  'Create Account',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Container(
                width: 51,
                height: 51,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF0051E4),
                  size: 34,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RegisterOrDivider extends StatelessWidget {
  const _RegisterOrDivider();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: Divider(
            color: Color(0xFFDDE4EE),
            thickness: 1,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 22),
          child: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.white,
            child: Text(
              'OR',
              style: TextStyle(
                color: Color(0xFF05112F),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: Color(0xFFDDE4EE),
            thickness: 1,
          ),
        ),
      ],
    );
  }
}

class _LoginFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          const TextSpan(
            text: 'Already have an account? ',
            style: TextStyle(
              color: Color(0xFF05112F),
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: InkWell(
              borderRadius: BorderRadius.circular(4),
              onTap: () => Get.offAllNamed(AppPages.login),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  'Log In',
                  style: TextStyle(
                    color: Color(0xFF006CF1),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          const WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Padding(
              padding: EdgeInsets.only(left: 7),
              child: Icon(
                Icons.arrow_forward_rounded,
                color: Color(0xFF006CF1),
                size: 22,
              ),
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _RegisterBackgroundPainter extends CustomPainter {
  const _RegisterBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFFFAFCFF),
    );

    final paleGreen = Paint()
      ..color = const Color(0xFFD8F1DA).withOpacity(0.82)
      ..style = PaintingStyle.fill;
    final topGreen = Path()
      ..moveTo(size.width * .88, 0)
      ..cubicTo(size.width * .84, size.height * .04, size.width * .89,
          size.height * .09, size.width, size.height * .115)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(topGreen, paleGreen);

    final bottomGreen = Path()
      ..moveTo(0, size.height * .84)
      ..cubicTo(size.width * .16, size.height * .88, size.width * .15,
          size.height * .94, size.width * .15, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(bottomGreen, paleGreen);

    final blue = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF7EBBFF), Color(0xFF0B70F3)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(
        Rect.fromLTWH(
          size.width * .72,
          size.height * .83,
          size.width * .28,
          size.height * .17,
        ),
      );
    final bluePath = Path()
      ..moveTo(size.width * .73, size.height)
      ..cubicTo(size.width * .79, size.height * .92, size.width * .88,
          size.height * .88, size.width, size.height * .86)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(bluePath, blue);

    final dotPaint = Paint()
      ..color = const Color(0xFF078A20).withOpacity(0.72)
      ..style = PaintingStyle.fill;
    for (var row = 0; row < 5; row++) {
      for (var col = 0; col < 5; col++) {
        canvas.drawCircle(
          Offset(
            size.width * .86 + col * 15,
            size.height * .145 + row * 15,
          ),
          2.2,
          dotPaint,
        );
      }
    }

    final linePaint = Paint()
      ..color = const Color(0xFF51A3FF).withOpacity(0.46)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (var i = 0; i < 6; i++) {
      final inset = i * 11.0;
      canvas.drawArc(
        Rect.fromLTWH(
          size.width * .74 + inset,
          size.height * .66 + inset,
          size.width * .42,
          size.width * .42,
        ),
        2.75,
        2.55,
        false,
        linePaint,
      );
      canvas.drawArc(
        Rect.fromLTWH(
          -size.width * .26 - inset,
          size.height * .28 + inset,
          size.width * .34,
          size.width * .34,
        ),
        -1.25,
        2.5,
        false,
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BusinnesTypeWidgets extends StatelessWidget {
  const _BusinnesTypeWidgets();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignUpController>(
      id: 'onUserTypeSelect',
      builder: (_) {
        return Visibility(
          visible: _.isTypeBusinnes,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppDatePicker(
                title: 'TCC Issue Date',
                hint: 'TCC Issue Date',
                name: 'tccIssueDate',
              ),
              SizedBox(height: 3.h),
              const AppDatePicker(
                title: 'TCC Expiry Date',
                hint: 'TCC Expiry Date',
                name: 'tccExpiryDate',
              ),
              SizedBox(height: 3.h),
              _RegisterTextField(
                name: 'businessTrn',
                title: 'Business TRN #',
                hint: 'Business TRN #',
                icon: Icons.badge_outlined,
                validator: FormBuilderValidators.compose(
                  [FormBuilderValidators.required()],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class AppDatePicker extends StatelessWidget {
  final String title;
  final String hint;
  final String name;
  const AppDatePicker({
    super.key,
    required this.title,
    required this.hint,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return _RegisterFieldFrame(
      title: title,
      child: FormBuilderDateTimePicker(
        name: name,
        format: DateFormat('yyyy-MM-dd'),
        enabled: true,
        initialDate: null,
        inputType: InputType.date,
        onChanged: (e) {},
        style: const TextStyle(
          color: Color(0xFF101828),
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        decoration: _fieldDecoration(
          hint: hint,
          icon: Icons.calendar_today_outlined,
        ),
      ),
    );
  }
}

extension FormBuilderValidatorsX on FormBuilderValidators {
  static FormFieldValidator<T> equalX<T>(
    Object? value, {
    String? errorText,
  }) =>
      (T? valueCandidate) {
        return valueCandidate != value ? errorText : null;
      };
}
