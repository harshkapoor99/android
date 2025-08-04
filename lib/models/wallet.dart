class WalletModel {
  final String id;
  final String userId;
  final double coin;
  final bool isActive;
  final DateTime createdDate;
  final DateTime updatedDate;
  final int status;

  WalletModel({
    required this.id,
    required this.userId,
    required this.coin,
    required this.isActive,
    required this.createdDate,
    required this.updatedDate,
    required this.status,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) => WalletModel(
    id: json["_id"],
    userId: json["user_id"],
    coin: json["coin"],
    isActive: json["is_active"],
    createdDate: DateTime.parse(json["created_date"]),
    updatedDate: DateTime.parse(json["updated_date"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user_id": userId,
    "coin": coin,
    "is_active": isActive,
    "created_date": createdDate.toIso8601String(),
    "updated_date": updatedDate.toIso8601String(),
    "status": status,
  };
}
