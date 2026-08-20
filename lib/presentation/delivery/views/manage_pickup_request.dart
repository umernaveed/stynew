import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:straight_to_yard/app/core/get_di.dart';
import 'package:straight_to_yard/data/models/manage_pick_up_request_meta/area.dart';
import 'package:straight_to_yard/data/models/manage_pick_up_request_meta/day.dart';
import 'package:straight_to_yard/presentation/auth/views/login_screen.dart';
import 'package:straight_to_yard/presentation/auth/widgets/drop_down.dart';
import 'package:straight_to_yard/presentation/base_screen.dart';
import 'package:straight_to_yard/presentation/bottom_nav/controllers/bottom_nav_controller.dart';
import 'package:straight_to_yard/presentation/delivery/controllers/manage_pickup_request_controller.dart';

class ManagePickupRequest extends GetView<ManagePickUpRequestController> {
  const ManagePickupRequest({super.key});

  @override
  Widget build(BuildContext context) {
    final instantUser = controller.getInstantUser();
    return BaseScreen(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            final bottomNavNestedID =
                find<BottomNavController>().bottomNavNestedID;
            Get.back(id: bottomNavNestedID);
          },
        ),
        centerTitle: false,
        title: Text(
          'Manage Delivery Request',
          style: context.textTheme.bodyLarge?.copyWith(
            color: const Color(0xFF4791CE),
            fontSize: 16.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      value: SystemUiOverlayStyle.dark,
      body: SingleChildScrollView(
        child: FormBuilder(
          clearValueOnUnregister: true,
          key: controller.formKey,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: GetBuilder<ManagePickUpRequestController>(
                id: 'manage_pickup_request',
                builder: (_) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 3.5.h),
                      _FieldWithLable(
                        name: 'name',
                        hint: 'Johan Doe',
                        initialValue: instantUser.userName,
                        lable: 'who should we expecting',
                        validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required()],
                        ),
                      ),
                      SizedBox(height: 2.5.h),
                      _FieldWithLable(
                        name: 'contact',
                        lable: 'Contact',
                        initialValue: instantUser.phone,
                        hint: '#####',
                        validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required()],
                        ),
                      ),
                      SizedBox(height: 2.5.h),
                      CustomDropDown<Day>(
                        name: 'select_day',
                        spaceBTW: 10,
                        title: 'Select Day',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                            width: 0.5,
                            color: Colors.grey.withOpacity(
                              0.6,
                            ),
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                            width: 0.5,
                            color: Colors.grey.withOpacity(
                              0.6,
                            ),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                            width: 0.5,
                            color: Colors.grey.withOpacity(
                              0.6,
                            ),
                          ),
                        ),
                        onItemSelected: (e) {},
                        hint: 'Monday',
                        items: controller.days,
                      ),
                      SizedBox(height: 2.5.h),
                      CustomDropDown<Area>(
                        name: 'select_area',
                        title: 'Select Area',
                        onItemSelected: (e) {
                          if (e == null) return;
                          controller.onAreaChange(e);
                        },
                        spaceBTW: 10,
                        hint: 'CITY CENTER',
                        isDense: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                            width: 0.5,
                            color: Colors.grey.withOpacity(
                              0.6,
                            ),
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                            width: 0.5,
                            color: Colors.grey.withOpacity(
                              0.6,
                            ),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                            width: 0.5,
                            color: Colors.grey.withOpacity(
                              0.6,
                            ),
                          ),
                        ),
                        items: controller.areas,
                      ),
                      SizedBox(height: 2.5.h),
                      _FieldWithLable(
                        name: 'delivery_coast',
                        lable: 'Delivery Coast',
                        hint: '00.00',
                        controller: controller.coastController,
                        readOnly: true,
                        validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required()],
                        ),
                      ),
                      SizedBox(height: 2.5.h),
                      _FieldWithLable(
                        name: 'address',
                        lable: 'Address',
                        initialValue: instantUser.address1,
                        hint: 'CITY CENTER, JERUSALEM',
                        validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required()],
                        ),
                      ),
                      SizedBox(height: 2.5.h),
                      _FieldWithLable(
                        name: 'notes',
                        lable: 'Notes',
                        maxLines: 5,
                        hint: 'Notes',
                        validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required()],
                        ),
                      ),
                      SizedBox(height: 2.5.h),
                      AppButton(
                        title: 'Schedule Delivery',
                        buttonBorderRadius: 10,
                        backgroundColor: Colors.pinkAccent,
                        onTap: () => controller.onSchedule(),
                      ),
                      SizedBox(height: 2.h),
                      AppButton(
                        title: 'Cancel',
                        buttonBorderRadius: 10,
                        backgroundColor: Colors.transparent,
                        textColor: Colors.black,
                        side: const BorderSide(
                          color: Colors.black,
                          width: 0.5,
                        ),
                        onTap: () => Get.back(),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FieldWithLable extends StatelessWidget {
  const _FieldWithLable({
    required this.lable,
    required this.name,
    required this.validator,
    required this.hint,
    this.maxLines,
    this.inputDecoration,
    this.initialValue,
    this.readOnly = false,
    this.controller,
  });
  final String lable;
  final String name;
  final String? Function(String?)? validator;
  final String hint;
  final int? maxLines;
  final InputDecoration? inputDecoration;
  final String? initialValue;
  final bool readOnly;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          lable,
          style: TextStyle(
            color: const Color(0xFF7C7C7C),
            fontSize: 11.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 10),
        FormBuilderTextField(
          name: name,
          maxLines: maxLines,
          readOnly: readOnly,
          controller: controller,
          initialValue: initialValue,
          decoration: inputDecoration ??
              InputDecoration(
                isDense: true,
                hintText: hint,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    width: 0.5,
                    color: Colors.grey.withOpacity(
                      0.6,
                    ),
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    width: 0.5,
                    color: Colors.grey.withOpacity(
                      0.6,
                    ),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    width: 0.5,
                    color: Colors.grey.withOpacity(
                      0.6,
                    ),
                  ),
                ),
              ),
          validator: validator,
          style: const TextStyle(
            color: Color(0xFF181725),
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
