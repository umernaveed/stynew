import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:straight_to_yard/app/core/assets/drawables.dart';
import 'package:straight_to_yard/app/extensions/string_ext.dart';
import 'package:straight_to_yard/presentation/onboarding/controllers/on_boarding_controller.dart';
import 'package:straight_to_yard/presentation/widgets/cache_image.dart';

enum AuthScreenType {
  withLargeAppLogo,
  withSmallAppLogo;

  bool get isSmall => this == AuthScreenType.withSmallAppLogo;
}

class AuthCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AuthCustomAppBar({
    super.key,
    this.appLogoVisble = true,
    this.backButtonVisible = true,
    this.usingNavigator = false,
    this.backID,
  }) : _type = AuthScreenType.withLargeAppLogo;
  final bool appLogoVisble;
  final bool backButtonVisible;
  final AuthScreenType _type;
  final bool usingNavigator;
  final int? backID;

  const AuthCustomAppBar.withSmallAppLogo({
    super.key,
    this.backButtonVisible = true,
    this.appLogoVisble = true,
    this.usingNavigator = false,
    this.backID,
  }) : _type = AuthScreenType.withSmallAppLogo;

  @override
  Size get preferredSize => Size.fromHeight(_type.isSmall ? 8.h : 17.h);

  @override
  Widget build(BuildContext context) {
    final onBoardingController = Get.find<OnBoardingController>();

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: ExactAssetImage(
            'assets/images/main_account_gradient.png',
          ),
        ),
      ),
      alignment: Alignment.bottomCenter,
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (backButtonVisible) ...[
              IconButton(
                icon: SvgPicture.asset(Drawables.icBack),
                onPressed: () {
                  if (usingNavigator) {
                    Navigator.of(context).pop();
                  } else {
                    Get.back(id: backID);
                  }
                },
              ),
            ] else ...[
              SizedBox(
                width: 10.2.w,
                height: 8.h,
              ),
            ],
            const Spacer(),
            SizedBox(width: 8.1.w),
            Visibility(
              visible: appLogoVisble,
              child: Obx(
                () {
                  final appLogo =
                      onBoardingController.meta.value.setting?.appLogo ?? '';
                  final isEmpty = appLogo.isEmpty;
                  final isSVG = appLogo.isSvgOrPngUrl();
                  return Container(
                    margin: _type.isSmall
                        ? EdgeInsets.zero
                        : EdgeInsets.only(top: 2.3.h),
                    child: isEmpty
                        ? Padding(
                            padding: EdgeInsets.only(
                                right: _type.isSmall ? 0 : 10.w),
                            child: Image.asset(
                              'assets/images/icon.png',
                              fit: BoxFit.fill,
                              width: _type.isSmall ? 20.2 : 49.w,
                              height: _type.isSmall ? 7.h : 14.h,
                            ),
                          )
                        : isSVG
                            ? SvgPicture.network(
                                appLogo,
                                fit: BoxFit.fill,
                                width: _type.isSmall ? 20.2 : 49.w,
                                height: _type.isSmall ? 7.h : 14.h,
                                placeholderBuilder: (context) {
                                  return Container(
                                    color: Colors.white,
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                },
                              )
                            : Center(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      right: _type.isSmall ? 0 : 10.w),
                                  child: CachedImage(
                                    imageUrl: appLogo,
                                    height: _type.isSmall ? 7.h : 14.h,
                                    width: _type.isSmall ? 100 : 49.w,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                  );
                },
              ),
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
