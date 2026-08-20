// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvoiceDetailResponse _$InvoiceDetailResponseFromJson(
        Map<String, dynamic> json) =>
    InvoiceDetailResponse(
      invoiceId: (json['invoice_id'] as num?)?.toInt() ?? -1,
      invoiceNo: (json['invoice_no'] as num?)?.toInt() ?? -1,
      mailboxNo: json['mailbox_no'] as String? ?? '',
      userName: json['user_name'] as String? ?? '',
      gct: (json['gct'] as num?)?.toInt() ?? -1,
      discountPrice: json['discount_price'] as String? ?? '',
      datePaid: json['date_paid'] as String? ?? '',
      email: json['email'] as String? ?? '',
      address1: json['address_1'] as String? ?? '',
      companyName: json['company_name'] as String? ?? '',
      localAddress: json['local_address'] as String? ?? '',
      gstPersent: json['gst_persent'] as String? ?? '',
      gstTotal: json['gst_total'] as String? ?? '',
      subTotal: json['sub_total'] as String? ?? '',
      grandTotal: json['grand_total'] as String? ?? '',
      invoiceDetail: (json['invoice_detail'] as List<dynamic>?)
              ?.map((e) => InvoiceDetail.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      siteEmail: json['site_email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      additionalFee: (json['additional_fee'] as List<dynamic>?)
              ?.map((e) => AdditionalFee.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      freightType: json['freight_type'] as String? ?? '',
    );

Map<String, dynamic> _$InvoiceDetailResponseToJson(
        InvoiceDetailResponse instance) =>
    <String, dynamic>{
      'invoice_id': instance.invoiceId,
      'invoice_no': instance.invoiceNo,
      'mailbox_no': instance.mailboxNo,
      'user_name': instance.userName,
      'gct': instance.gct,
      'discount_price': instance.discountPrice,
      'date_paid': instance.datePaid,
      'email': instance.email,
      'address_1': instance.address1,
      'company_name': instance.companyName,
      'local_address': instance.localAddress,
      'gst_persent': instance.gstPersent,
      'gst_total': instance.gstTotal,
      'sub_total': instance.subTotal,
      'grand_total': instance.grandTotal,
      'site_email': instance.siteEmail,
      'phone': instance.phone,
      'freight_type': instance.freightType,
      'invoice_detail': instance.invoiceDetail,
      'additional_fee': instance.additionalFee,
    };

InvoiceDetail _$InvoiceDetailFromJson(Map<String, dynamic> json) =>
    InvoiceDetail(
      id: (json['id'] as num?)?.toInt() ?? -1,
      invoiceId: (json['invoiceId'] as num?)?.toInt() ?? -1,
      trackingNo: json['tracking_no'] as String? ?? '',
      packageDescription: json['package_description'] as String? ?? '',
      packagePrice: json['package_price'] as String? ?? '',
      customFee: json['custom_fee'] as String? ?? '',
      serviceFee: json['service_fee'] as String? ?? '',
      packageWeight: (json['package_weight'] as num?)?.toInt() ?? 0,
      status: (json['status'] as num?)?.toInt() ?? 0,
      packageTotal: json['package_total'] as String? ?? '',
      manifestNo: json['manifest_no'] as String? ?? '',
    );

Map<String, dynamic> _$InvoiceDetailToJson(InvoiceDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'invoiceId': instance.invoiceId,
      'tracking_no': instance.trackingNo,
      'package_description': instance.packageDescription,
      'package_price': instance.packagePrice,
      'custom_fee': instance.customFee,
      'service_fee': instance.serviceFee,
      'package_weight': instance.packageWeight,
      'status': instance.status,
      'package_total': instance.packageTotal,
      'manifest_no': instance.manifestNo,
    };

AdditionalFee _$AdditionalFeeFromJson(Map<String, dynamic> json) =>
    AdditionalFee(
      id: (json['id'] as num?)?.toInt() ?? -1,
      invoiceId: json['invoice_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      serviceFee: json['service_fee'] as String? ?? '0',
    );

Map<String, dynamic> _$AdditionalFeeToJson(AdditionalFee instance) =>
    <String, dynamic>{
      'id': instance.id,
      'invoice_id': instance.invoiceId,
      'name': instance.name,
      'service_fee': instance.serviceFee,
    };
