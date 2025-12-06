// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recycle_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PickupSlotTimeslot _$PickupSlotTimeslotFromJson(Map<String, dynamic> json) =>
    PickupSlotTimeslot(
      displayTime: json['display_time'] as String,
      value: json['value'] as String,
    );

Map<String, dynamic> _$PickupSlotTimeslotToJson(PickupSlotTimeslot instance) =>
    <String, dynamic>{
      'display_time': instance.displayTime,
      'value': instance.value,
    };

PickupSlotDate _$PickupSlotDateFromJson(Map<String, dynamic> json) =>
    PickupSlotDate(
      date: json['date'] as String,
      timeslots: (json['timeslots'] as List<dynamic>)
          .map((e) => PickupSlotTimeslot.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PickupSlotDateToJson(PickupSlotDate instance) =>
    <String, dynamic>{
      'date': instance.date,
      'timeslots': instance.timeslots.map((e) => e.toJson()).toList(),
    };

AvailablePickupSlotsData _$AvailablePickupSlotsDataFromJson(
  Map<String, dynamic> json,
) => AvailablePickupSlotsData(
  availableDates: (json['available_dates'] as List<dynamic>)
      .map((e) => PickupSlotDate.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$AvailablePickupSlotsDataToJson(
  AvailablePickupSlotsData instance,
) => <String, dynamic>{
  'available_dates': instance.availableDates.map((e) => e.toJson()).toList(),
};

AvailablePickupSlotsEnvelope _$AvailablePickupSlotsEnvelopeFromJson(
  Map<String, dynamic> json,
) => AvailablePickupSlotsEnvelope(
  data: AvailablePickupSlotsData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AvailablePickupSlotsEnvelopeToJson(
  AvailablePickupSlotsEnvelope instance,
) => <String, dynamic>{'data': instance.data.toJson()};

RecycleOrderAddress _$RecycleOrderAddressFromJson(Map<String, dynamic> json) =>
    RecycleOrderAddress(
      districtId: json['district_id'] as String,
      subDistrictId: json['sub_district_id'] as String,
      address: json['address'] as String,
    );

Map<String, dynamic> _$RecycleOrderAddressToJson(
  RecycleOrderAddress instance,
) => <String, dynamic>{
  'district_id': instance.districtId,
  'sub_district_id': instance.subDistrictId,
  'address': instance.address,
};

RecycleOrderCreateRequest _$RecycleOrderCreateRequestFromJson(
  Map<String, dynamic> json,
) => RecycleOrderCreateRequest(
  subscriptionId: json['subscription_id'] as String,
  pickupDate: json['pickup_date'] as String,
  pickupTime: json['pickup_time'] as String,
);

Map<String, dynamic> _$RecycleOrderCreateRequestToJson(
  RecycleOrderCreateRequest instance,
) => <String, dynamic>{
  'subscription_id': instance.subscriptionId,
  'pickup_date': instance.pickupDate,
  'pickup_time': instance.pickupTime,
};

RecycleOrderListItem _$RecycleOrderListItemFromJson(
  Map<String, dynamic> json,
) => RecycleOrderListItem(
  id: json['id'] as String,
  recycleOrderNo: json['recycle_order_no'] as String,
  orderType: $enumDecode(_$RecycleOrderTypeEnumMap, json['order_type']),
  pickupDate: json['pickup_date'] as String,
  pickupTime: json['pickup_time'] as String,
  status: $enumDecode(_$RecycleOrderStatusEnumMap, json['status']),
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$RecycleOrderListItemToJson(
  RecycleOrderListItem instance,
) => <String, dynamic>{
  'id': instance.id,
  'recycle_order_no': instance.recycleOrderNo,
  'order_type': _$RecycleOrderTypeEnumMap[instance.orderType]!,
  'pickup_date': instance.pickupDate,
  'pickup_time': instance.pickupTime,
  'status': _$RecycleOrderStatusEnumMap[instance.status]!,
  'created_at': instance.createdAt.toIso8601String(),
};

const _$RecycleOrderTypeEnumMap = {
  RecycleOrderType.plasticBottle: 'plastic_bottle',
};

const _$RecycleOrderStatusEnumMap = {
  RecycleOrderStatus.pending: 'pending',
  RecycleOrderStatus.processing: 'processing',
  RecycleOrderStatus.pickedUp: 'picked_up',
  RecycleOrderStatus.completed: 'completed',
  RecycleOrderStatus.failed: 'failed',
};

SfExpressRoute _$SfExpressRouteFromJson(Map<String, dynamic> json) =>
    SfExpressRoute(
      acceptTime: json['acceptTime'] as String,
      acceptAddress: json['acceptAddress'] as String,
      opCode: json['opCode'] as String,
      remark: json['remark'] as String,
      secondaryStatusCode: json['secondaryStatusCode'] as String,
      secondaryStatusName: json['secondaryStatusName'] as String,
      firstStatusCode: json['firstStatusCode'] as String?,
      firstStatusName: json['firstStatusName'] as String?,
    );

Map<String, dynamic> _$SfExpressRouteToJson(SfExpressRoute instance) =>
    <String, dynamic>{
      'acceptTime': instance.acceptTime,
      'acceptAddress': instance.acceptAddress,
      'opCode': instance.opCode,
      'remark': instance.remark,
      'secondaryStatusCode': instance.secondaryStatusCode,
      'secondaryStatusName': instance.secondaryStatusName,
      'firstStatusCode': instance.firstStatusCode,
      'firstStatusName': instance.firstStatusName,
    };

SfExpressRoutes _$SfExpressRoutesFromJson(Map<String, dynamic> json) =>
    SfExpressRoutes(
      en: (json['en'] as List<dynamic>)
          .map((e) => SfExpressRoute.fromJson(e as Map<String, dynamic>))
          .toList(),
      zhHK: (json['zh-HK'] as List<dynamic>)
          .map((e) => SfExpressRoute.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SfExpressRoutesToJson(SfExpressRoutes instance) =>
    <String, dynamic>{
      'en': instance.en.map((e) => e.toJson()).toList(),
      'zh-HK': instance.zhHK.map((e) => e.toJson()).toList(),
    };

SfExpressOrder _$SfExpressOrderFromJson(Map<String, dynamic> json) =>
    SfExpressOrder(
      waybillNo: json['waybill_no'] as String?,
      routes: SfExpressRoutes.fromJson(json['routes'] as Map<String, dynamic>),
      routesSyncedAt: json['routes_synced_at'] == null
          ? null
          : DateTime.parse(json['routes_synced_at'] as String),
    );

Map<String, dynamic> _$SfExpressOrderToJson(SfExpressOrder instance) =>
    <String, dynamic>{
      'waybill_no': instance.waybillNo,
      'routes': instance.routes.toJson(),
      'routes_synced_at': instance.routesSyncedAt?.toIso8601String(),
    };

LogisticsOrder _$LogisticsOrderFromJson(Map<String, dynamic> json) =>
    LogisticsOrder(
      logisticsOrderId: json['logistics_order_id'] as String,
      logisticsOrderNo: json['logistics_order_no'] as String,
      provider: json['provider'] as String,
      status: json['status'] as String,
      isFinalized: json['is_finalized'] as bool,
      trackingNo: json['tracking_no'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      sfExpressOrder: json['sf_express_order'] == null
          ? null
          : SfExpressOrder.fromJson(
              json['sf_express_order'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$LogisticsOrderToJson(LogisticsOrder instance) =>
    <String, dynamic>{
      'logistics_order_id': instance.logisticsOrderId,
      'logistics_order_no': instance.logisticsOrderNo,
      'provider': instance.provider,
      'status': instance.status,
      'is_finalized': instance.isFinalized,
      'tracking_no': instance.trackingNo,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'sf_express_order': instance.sfExpressOrder?.toJson(),
    };

RecycleOrderDetail _$RecycleOrderDetailFromJson(Map<String, dynamic> json) =>
    RecycleOrderDetail(
      id: json['id'] as String,
      recycleOrderNo: json['recycle_order_no'] as String,
      customerId: json['customer_id'] as String,
      subscriptionId: json['subscription_id'] as String,
      recyclingProfileId: json['recycling_profile_id'] as String,
      orderType: $enumDecode(_$RecycleOrderTypeEnumMap, json['order_type']),
      deliveryAddress: RecycleOrderAddress.fromJson(
        json['delivery_address'] as Map<String, dynamic>,
      ),
      pickupAt: DateTime.parse(json['pickup_at'] as String),
      pickupDate: json['pickup_date'] as String,
      pickupTime: json['pickup_time'] as String,
      status: $enumDecode(_$RecycleOrderStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      logisticsOrder: json['logistics_order'] == null
          ? null
          : LogisticsOrder.fromJson(
              json['logistics_order'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$RecycleOrderDetailToJson(RecycleOrderDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'recycle_order_no': instance.recycleOrderNo,
      'customer_id': instance.customerId,
      'subscription_id': instance.subscriptionId,
      'recycling_profile_id': instance.recyclingProfileId,
      'order_type': _$RecycleOrderTypeEnumMap[instance.orderType]!,
      'delivery_address': instance.deliveryAddress.toJson(),
      'pickup_at': instance.pickupAt.toIso8601String(),
      'pickup_date': instance.pickupDate,
      'pickup_time': instance.pickupTime,
      'status': _$RecycleOrderStatusEnumMap[instance.status]!,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'logistics_order': instance.logisticsOrder?.toJson(),
    };

RecycleOrderCreateEnvelope _$RecycleOrderCreateEnvelopeFromJson(
  Map<String, dynamic> json,
) => RecycleOrderCreateEnvelope(
  data: RecycleOrderDetail.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$RecycleOrderCreateEnvelopeToJson(
  RecycleOrderCreateEnvelope instance,
) => <String, dynamic>{'data': instance.data.toJson()};

RecycleOrderDetailEnvelope _$RecycleOrderDetailEnvelopeFromJson(
  Map<String, dynamic> json,
) => RecycleOrderDetailEnvelope(
  data: RecycleOrderDetail.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$RecycleOrderDetailEnvelopeToJson(
  RecycleOrderDetailEnvelope instance,
) => <String, dynamic>{'data': instance.data.toJson()};

RecycleOrderListEnvelope _$RecycleOrderListEnvelopeFromJson(
  Map<String, dynamic> json,
) => RecycleOrderListEnvelope(
  data: (json['data'] as List<dynamic>)
      .map((e) => RecycleOrderListItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$RecycleOrderListEnvelopeToJson(
  RecycleOrderListEnvelope instance,
) => <String, dynamic>{'data': instance.data.map((e) => e.toJson()).toList()};

RecycleErrorBody _$RecycleErrorBodyFromJson(Map<String, dynamic> json) =>
    RecycleErrorBody(
      code: json['code'] as String,
      httpStatus: (json['http_status'] as num).toInt(),
      userMessage: json['user_message'] as String?,
      debugMessage: json['debug_message'] as String?,
      fields: (json['fields'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
          k,
          (e as List<dynamic>)
              .map((e) => FieldViolation.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      ),
    );

Map<String, dynamic> _$RecycleErrorBodyToJson(RecycleErrorBody instance) =>
    <String, dynamic>{
      'code': instance.code,
      'http_status': instance.httpStatus,
      'user_message': instance.userMessage,
      'debug_message': instance.debugMessage,
      'fields': instance.fields,
    };

FieldViolation _$FieldViolationFromJson(Map<String, dynamic> json) =>
    FieldViolation(
      code: json['code'] as String,
      message: json['message'] as String,
    );

Map<String, dynamic> _$FieldViolationToJson(FieldViolation instance) =>
    <String, dynamic>{'code': instance.code, 'message': instance.message};
