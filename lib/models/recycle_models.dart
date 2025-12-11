import 'package:json_annotation/json_annotation.dart';

part 'recycle_models.g.dart';

/// Type of recyclable material
enum RecycleOrderType {
  @JsonValue('plastic_bottle')
  plasticBottle,
}

/// Order lifecycle status
enum RecycleOrderStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('processing')
  processing,
  @JsonValue('picked_up')
  pickedUp,
  @JsonValue('completed')
  completed,
  @JsonValue('failed')
  failed,
}

/// Available timeslot with display range and value
@JsonSerializable()
class PickupSlotTimeslot {
  @JsonKey(name: 'display_time')
  final String displayTime;
  final String value;

  const PickupSlotTimeslot({
    required this.displayTime,
    required this.value,
  });

  factory PickupSlotTimeslot.fromJson(Map<String, dynamic> json) =>
      _$PickupSlotTimeslotFromJson(json);

  Map<String, dynamic> toJson() => _$PickupSlotTimeslotToJson(this);
}

/// Available date with timeslots
@JsonSerializable(explicitToJson: true)
class PickupSlotDate {
  final String date;
  final List<PickupSlotTimeslot> timeslots;

  const PickupSlotDate({
    required this.date,
    required this.timeslots,
  });

  factory PickupSlotDate.fromJson(Map<String, dynamic> json) =>
      _$PickupSlotDateFromJson(json);

  Map<String, dynamic> toJson() => _$PickupSlotDateToJson(this);
}

/// Available pickup dates and timeslots
@JsonSerializable(explicitToJson: true)
class AvailablePickupSlotsData {
  @JsonKey(name: 'available_dates')
  final List<PickupSlotDate> availableDates;

  const AvailablePickupSlotsData({
    required this.availableDates,
  });

  factory AvailablePickupSlotsData.fromJson(Map<String, dynamic> json) =>
      _$AvailablePickupSlotsDataFromJson(json);

  Map<String, dynamic> toJson() => _$AvailablePickupSlotsDataToJson(this);
}

/// Envelope containing available pickup slots
@JsonSerializable(explicitToJson: true)
class AvailablePickupSlotsEnvelope {
  final AvailablePickupSlotsData data;

  const AvailablePickupSlotsEnvelope({required this.data});

  factory AvailablePickupSlotsEnvelope.fromJson(Map<String, dynamic> json) =>
      _$AvailablePickupSlotsEnvelopeFromJson(json);

  Map<String, dynamic> toJson() => _$AvailablePickupSlotsEnvelopeToJson(this);
}

/// Pickup location address
@JsonSerializable()
class RecycleOrderAddress {
  @JsonKey(name: 'district_id')
  final String districtId;
  @JsonKey(name: 'sub_district_id')
  final String subDistrictId;
  final String address;

  const RecycleOrderAddress({
    required this.districtId,
    required this.subDistrictId,
    required this.address,
  });

  factory RecycleOrderAddress.fromJson(Map<String, dynamic> json) =>
      _$RecycleOrderAddressFromJson(json);

  Map<String, dynamic> toJson() => _$RecycleOrderAddressToJson(this);
}

/// Request body for creating a recycle order
@JsonSerializable()
class RecycleOrderCreateRequest {
  @JsonKey(name: 'subscription_id')
  final String subscriptionId;
  @JsonKey(name: 'pickup_date')
  final String pickupDate;
  @JsonKey(name: 'pickup_time')
  final String pickupTime;

  const RecycleOrderCreateRequest({
    required this.subscriptionId,
    required this.pickupDate,
    required this.pickupTime,
  });

  factory RecycleOrderCreateRequest.fromJson(Map<String, dynamic> json) =>
      _$RecycleOrderCreateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RecycleOrderCreateRequestToJson(this);
}

/// Recycle order summary for list view
@JsonSerializable()
class RecycleOrderListItem {
  final String id;
  @JsonKey(name: 'recycle_order_no')
  final String recycleOrderNo;
  @JsonKey(name: 'order_type')
  final RecycleOrderType orderType;
  @JsonKey(name: 'pickup_at')
  final DateTime pickupAt;
  final RecycleOrderStatus status;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  const RecycleOrderListItem({
    required this.id,
    required this.recycleOrderNo,
    required this.orderType,
    required this.pickupAt,
    required this.status,
    required this.createdAt,
  });

  factory RecycleOrderListItem.fromJson(Map<String, dynamic> json) =>
      _$RecycleOrderListItemFromJson(json);

  Map<String, dynamic> toJson() => _$RecycleOrderListItemToJson(this);
}

/// Single route event from SF Express tracking
@JsonSerializable()
class SfExpressRoute {
  @JsonKey(name: 'accept_time')
  final String acceptTime;
  @JsonKey(name: 'accept_address')
  final String acceptAddress;
  @JsonKey(name: 'op_code')
  final String opCode;
  final String remark;
  @JsonKey(name: 'secondaryStatusCode')
  final String? secondaryStatusCode;
  @JsonKey(name: 'secondaryStatusName')
  final String? secondaryStatusName;
  @JsonKey(name: 'firstStatusCode')
  final String? firstStatusCode;
  @JsonKey(name: 'firstStatusName')
  final String? firstStatusName;

  const SfExpressRoute({
    required this.acceptTime,
    required this.acceptAddress,
    required this.opCode,
    required this.remark,
    required this.secondaryStatusCode,
    required this.secondaryStatusName,
    this.firstStatusCode,
    this.firstStatusName,
  });

  factory SfExpressRoute.fromJson(Map<String, dynamic> json) =>
      _$SfExpressRouteFromJson(json);

  Map<String, dynamic> toJson() => _$SfExpressRouteToJson(this);
}

/// Bilingual routes from SF Express tracking
@JsonSerializable(explicitToJson: true)
class SfExpressRoutes {
  final List<SfExpressRoute> en;
  @JsonKey(name: 'zh-HK')
  final List<SfExpressRoute> zhHK;

  const SfExpressRoutes({
    required this.en,
    required this.zhHK,
  });

  factory SfExpressRoutes.fromJson(Map<String, dynamic> json) =>
      _$SfExpressRoutesFromJson(json);

  Map<String, dynamic> toJson() => _$SfExpressRoutesToJson(this);
}

/// SF Express order details for customer display
@JsonSerializable(explicitToJson: true)
class SfExpressOrder {
  @JsonKey(name: 'waybill_no')
  final String? waybillNo;
  final SfExpressRoutes routes;
  @JsonKey(name: 'routes_synced_at')
  final DateTime? routesSyncedAt;

  const SfExpressOrder({
    this.waybillNo,
    required this.routes,
    this.routesSyncedAt,
  });

  factory SfExpressOrder.fromJson(Map<String, dynamic> json) =>
      _$SfExpressOrderFromJson(json);

  Map<String, dynamic> toJson() => _$SfExpressOrderToJson(this);
}

/// Logistics order details for customer display
@JsonSerializable(explicitToJson: true)
class LogisticsOrder {
  @JsonKey(name: 'logistics_order_id')
  final String logisticsOrderId;
  @JsonKey(name: 'logistics_order_no')
  final String logisticsOrderNo;
  final String provider;
  final String status;
  @JsonKey(name: 'is_finalized')
  final bool isFinalized;
  @JsonKey(name: 'tracking_no')
  final String? trackingNo;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @JsonKey(name: 'sf_express_order')
  final SfExpressOrder? sfExpressOrder;

  const LogisticsOrder({
    required this.logisticsOrderId,
    required this.logisticsOrderNo,
    required this.provider,
    required this.status,
    required this.isFinalized,
    this.trackingNo,
    required this.createdAt,
    required this.updatedAt,
    this.sfExpressOrder,
  });

  factory LogisticsOrder.fromJson(Map<String, dynamic> json) =>
      _$LogisticsOrderFromJson(json);

  Map<String, dynamic> toJson() => _$LogisticsOrderToJson(this);
}

/// Complete recycle order details
@JsonSerializable(explicitToJson: true)
class RecycleOrderDetail {
  final String id;
  @JsonKey(name: 'recycle_order_no')
  final String recycleOrderNo;
  @JsonKey(name: 'customer_id')
  final String customerId;
  @JsonKey(name: 'subscription_id')
  final String subscriptionId;
  @JsonKey(name: 'recycling_profile_id')
  final String recyclingProfileId;
  @JsonKey(name: 'order_type')
  final RecycleOrderType orderType;
  @JsonKey(name: 'delivery_address')
  final RecycleOrderAddress deliveryAddress;
  @JsonKey(name: 'pickup_at')
  final DateTime pickupAt;
  final RecycleOrderStatus status;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @JsonKey(name: 'logistics_order')
  final LogisticsOrder? logisticsOrder;

  const RecycleOrderDetail({
    required this.id,
    required this.recycleOrderNo,
    required this.customerId,
    required this.subscriptionId,
    required this.recyclingProfileId,
    required this.orderType,
    required this.deliveryAddress,
    required this.pickupAt,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.logisticsOrder,
  });

  factory RecycleOrderDetail.fromJson(Map<String, dynamic> json) =>
      _$RecycleOrderDetailFromJson(json);

  Map<String, dynamic> toJson() => _$RecycleOrderDetailToJson(this);
}

/// Envelope containing created recycle order details
@JsonSerializable(explicitToJson: true)
class RecycleOrderCreateEnvelope {
  final RecycleOrderDetail data;

  const RecycleOrderCreateEnvelope({required this.data});

  factory RecycleOrderCreateEnvelope.fromJson(Map<String, dynamic> json) =>
      _$RecycleOrderCreateEnvelopeFromJson(json);

  Map<String, dynamic> toJson() => _$RecycleOrderCreateEnvelopeToJson(this);
}

/// Envelope containing single recycle order details
@JsonSerializable(explicitToJson: true)
class RecycleOrderDetailEnvelope {
  final RecycleOrderDetail data;

  const RecycleOrderDetailEnvelope({required this.data});

  factory RecycleOrderDetailEnvelope.fromJson(Map<String, dynamic> json) =>
      _$RecycleOrderDetailEnvelopeFromJson(json);

  Map<String, dynamic> toJson() => _$RecycleOrderDetailEnvelopeToJson(this);
}

/// Envelope containing array of recycle orders
@JsonSerializable(explicitToJson: true)
class RecycleOrderListEnvelope {
  final List<RecycleOrderListItem> data;

  const RecycleOrderListEnvelope({required this.data});

  factory RecycleOrderListEnvelope.fromJson(Map<String, dynamic> json) =>
      _$RecycleOrderListEnvelopeFromJson(json);

  Map<String, dynamic> toJson() => _$RecycleOrderListEnvelopeToJson(this);
}

/// Error body shape for recycle endpoints
@JsonSerializable()
class RecycleErrorBody {
  final String code;
  @JsonKey(name: 'http_status')
  final int httpStatus;
  @JsonKey(name: 'user_message')
  final String? userMessage;
  @JsonKey(name: 'debug_message')
  final String? debugMessage;
  @JsonKey(name: 'fields')
  final Map<String, List<FieldViolation>>? fields;

  const RecycleErrorBody({
    required this.code,
    required this.httpStatus,
    this.userMessage,
    this.debugMessage,
    this.fields,
  });

  factory RecycleErrorBody.fromJson(Map<String, dynamic> json) =>
      _$RecycleErrorBodyFromJson(json);

  Map<String, dynamic> toJson() => _$RecycleErrorBodyToJson(this);
}

/// Field-level violation structure
@JsonSerializable()
class FieldViolation {
  final String code;
  final String message;

  const FieldViolation({
    required this.code,
    required this.message,
  });

  factory FieldViolation.fromJson(Map<String, dynamic> json) =>
      _$FieldViolationFromJson(json);

  Map<String, dynamic> toJson() => _$FieldViolationToJson(this);
}

