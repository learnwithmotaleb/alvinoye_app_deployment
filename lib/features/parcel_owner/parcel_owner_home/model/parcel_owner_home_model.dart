class HomeModel {
  final bool? success;
  final String? message;
  final Data? data;

  HomeModel({this.success, this.message, this.data});

  factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  final Meta? meta;
  final List<ParcelItem>? data;

  Data({this.meta, this.data});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    data: json["data"] == null
        ? []
        : List<ParcelItem>.from(
            json["data"]!.map((x) => ParcelItem.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "meta": meta?.toJson(),
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class ParcelItem {
  final String? id;
  final String? parcelId;
  final UserId? userId;
  final String? parcelName;
  final String? size;
  final String? vehicleType;
  final double? weight;
  final Location? pickupLocation;
  final Location? handoverLocation;
  final String? priority;
  final DateTime? date;
  final String? time;
  final List<String>? parcelImages;
  final String? receiverName;
  final String? receiverPhone;
  final String? senderRemarks;
  final String? status;
  final dynamic finalPrice;
  final String? priceStatus;
  final String? rejectionReason;
  final dynamic acceptedBy;
  final dynamic acceptedAt;
  final dynamic completedAt;
  final dynamic stripeCheckoutSessionId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? datumId;

  ParcelItem({
    this.id,
    this.parcelId,
    this.userId,
    this.parcelName,
    this.size,
    this.vehicleType,
    this.weight,
    this.pickupLocation,
    this.handoverLocation,
    this.priority,
    this.date,
    this.time,
    this.parcelImages,
    this.receiverName,
    this.receiverPhone,
    this.senderRemarks,
    this.status,
    this.finalPrice,
    this.priceStatus,
    this.rejectionReason,
    this.acceptedBy,
    this.acceptedAt,
    this.completedAt,
    this.stripeCheckoutSessionId,
    this.createdAt,
    this.updatedAt,
    this.datumId,
  });

  factory ParcelItem.fromJson(Map<String, dynamic> json) => ParcelItem(
    id: json["_id"],
    parcelId: json["parcel_id"],
    userId: json["user_id"] == null ? null : UserId.fromJson(json["user_id"]),
    parcelName: json["parcel_name"],
    size: json["size"],
    vehicleType: json["vehicle_type"],
    weight: json["weight"]?.toDouble(),
    pickupLocation: json["pickup_location"] == null
        ? null
        : Location.fromJson(json["pickup_location"]),
    handoverLocation: json["handover_location"] == null
        ? null
        : Location.fromJson(json["handover_location"]),
    priority: json["priority"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    time: json["time"],
    parcelImages: json["parcel_images"] == null
        ? []
        : List<String>.from(json["parcel_images"]!.map((x) => x)),
    receiverName: json["receiver_name"],
    receiverPhone: json["receiver_phone"],
    senderRemarks: json["sender_remarks"],
    status: json["status"],
    finalPrice: json["final_price"],
    priceStatus: json["price_status"],
    rejectionReason: json["rejection_reason"],
    acceptedBy: json["accepted_by"],
    acceptedAt: json["accepted_at"],
    completedAt: json["completed_at"],
    stripeCheckoutSessionId: json["stripe_checkout_session_id"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    datumId: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "parcel_id": parcelId,
    "user_id": userId?.toJson(),
    "parcel_name": parcelName,
    "size": size,
    "vehicle_type": vehicleType,
    "weight": weight,
    "pickup_location": pickupLocation?.toJson(),
    "handover_location": handoverLocation?.toJson(),
    "priority": priority,
    "date": date != null
        ? "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}"
        : null,
    "time": time,
    "parcel_images": parcelImages == null
        ? []
        : List<dynamic>.from(parcelImages!.map((x) => x)),
    "receiver_name": receiverName,
    "receiver_phone": receiverPhone,
    "sender_remarks": senderRemarks,
    "status": status,
    "final_price": finalPrice,
    "price_status": priceStatus,
    "rejection_reason": rejectionReason,
    "accepted_by": acceptedBy,
    "accepted_at": acceptedAt,
    "completed_at": completedAt,
    "stripe_checkout_session_id": stripeCheckoutSessionId,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "id": datumId,
  };
}

class Location {
  final String? address;
  final double? latitude;
  final double? longitude;

  Location({this.address, this.latitude, this.longitude});

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    address: json["address"],
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "address": address,
    "latitude": latitude,
    "longitude": longitude,
  };
}

class UserId {
  final String? id;
  final String? fullName;
  final String? email;
  final String? role;
  final String? status;
  final String? profilePicture;
  final bool? isProfileCompleted;
  final bool? isVerified;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? passwordChangedAt;
  final int? v;
  final String? address;
  final String? phoneNumber;
  final String? userIdId;

  UserId({
    this.id,
    this.fullName,
    this.email,
    this.role,
    this.status,
    this.profilePicture,
    this.isProfileCompleted,
    this.isVerified,
    this.createdAt,
    this.updatedAt,
    this.passwordChangedAt,
    this.v,
    this.address,
    this.phoneNumber,
    this.userIdId,
  });

  factory UserId.fromJson(Map<String, dynamic> json) => UserId(
    id: json["_id"],
    fullName: json["full_name"],
    email: json["email"],
    role: json["role"],
    status: json["status"],
    profilePicture: json["profile_picture"],
    isProfileCompleted: json["is_profile_completed"],
    isVerified: json["is_verified"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    passwordChangedAt: json["password_changed_at"] == null
        ? null
        : DateTime.parse(json["password_changed_at"]),
    v: json["__v"],
    address: json["address"],
    phoneNumber: json["phone_number"],
    userIdId: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "full_name": fullName,
    "email": email,
    "role": role,
    "status": status,
    "profile_picture": profilePicture,
    "is_profile_completed": isProfileCompleted,
    "is_verified": isVerified,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "password_changed_at": passwordChangedAt?.toIso8601String(),
    "__v": v,
    "address": address,
    "phone_number": phoneNumber,
    "id": userIdId,
  };
}

class Meta {
  final int? total;
  final int? page;
  final int? limit;
  final int? totalPages;

  Meta({this.total, this.page, this.limit, this.totalPages});

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    total: json["total"],
    page: json["page"],
    limit: json["limit"],
    totalPages: json["totalPages"],
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "page": page,
    "limit": limit,
    "totalPages": totalPages,
  };
}
