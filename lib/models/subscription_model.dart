class SubscriptionModel {
  final String id;
  final String subscriptionName;
  final String description;
  final int price;
  final int discountPrice;
  final int subscriptionDays;
  final bool markAsPopular;
  final bool activeStatus;
  final DateTime createdDate;
  final DateTime updatedDate;
  final int status;
  final Features features;

  SubscriptionModel({
    required this.id,
    required this.subscriptionName,
    required this.description,
    required this.price,
    required this.discountPrice,
    required this.subscriptionDays,
    required this.markAsPopular,
    required this.activeStatus,
    required this.createdDate,
    required this.updatedDate,
    required this.status,
    required this.features,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) =>
      SubscriptionModel(
        id: json["_id"],
        subscriptionName: json["subscription_name"],
        description: json["description"],
        price: json["price"],
        discountPrice: json["discount_price"],
        subscriptionDays: json["subscription_days"],
        markAsPopular: json["mark_as_popular"],
        activeStatus: json["active_status"],
        createdDate: DateTime.parse(json["created_date"]),
        updatedDate: DateTime.parse(json["updated_date"]),
        status: json["status"],
        features: Features.fromJson(json["features"]),
      );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "subscription_name": subscriptionName,
    "description": description,
    "price": price,
    "discount_price": discountPrice,
    "subscription_days": subscriptionDays,
    "mark_as_popular": markAsPopular,
    "active_status": activeStatus,
    "created_date": createdDate.toIso8601String(),
    "updated_date": updatedDate.toIso8601String(),
    "status": status,
    "features": features.toJson(),
  };
}

class Features {
  final bool chatWithStandardCharacters;
  final int voiceCallMinutes;
  final int pictureDpMonth;
  final int inChatImages;
  final int chatLimitPerDay;
  final int characterCount;

  Features({
    required this.chatWithStandardCharacters,
    required this.voiceCallMinutes,
    required this.pictureDpMonth,
    required this.inChatImages,
    required this.chatLimitPerDay,
    required this.characterCount,
  });

  factory Features.fromJson(Map<String, dynamic> json) => Features(
    chatWithStandardCharacters: json["chat_with_standard_characters"],
    voiceCallMinutes: json["voice_call_minutes"],
    pictureDpMonth: json["picture_dp_month"],
    inChatImages: json["in_chat_images"],
    chatLimitPerDay: json["chat_limit_per_day"],
    characterCount: json["character_count"],
  );

  Map<String, dynamic> toJson() => {
    "chat_with_standard_characters": chatWithStandardCharacters,
    "voice_call_minutes": voiceCallMinutes,
    "picture_dp_month": pictureDpMonth,
    "in_chat_images": inChatImages,
    "chat_limit_per_day": chatLimitPerDay,
    "character_count": characterCount,
  };
}
