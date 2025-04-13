// To parse this JSON data, do
//
//     final user = userFromMap(jsonString);

import 'dart:convert';

User userFromMap(String str) => User.fromMap(json.decode(str));

String userToMap(User data) => json.encode(data.toMap());

class User {
  final String id;
  final String username;
  final String email;
  final String mobileNumber;
  final DateTime createdDate;
  final DateTime updatedDate;
  final int status;
  final Profile profile;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.mobileNumber,
    required this.createdDate,
    required this.updatedDate,
    required this.status,
    required this.profile,
  });

  User copyWith({
    String? id,
    String? username,
    String? email,
    String? mobileNumber,
    DateTime? createdDate,
    DateTime? updatedDate,
    int? status,
    Profile? profile,
  }) => User(
    id: id ?? this.id,
    username: username ?? this.username,
    email: email ?? this.email,
    mobileNumber: mobileNumber ?? this.mobileNumber,
    createdDate: createdDate ?? this.createdDate,
    updatedDate: updatedDate ?? this.updatedDate,
    status: status ?? this.status,
    profile: profile ?? this.profile,
  );

  factory User.fromMap(Map<String, dynamic> json) => User(
    id: json["id"],
    username: json["username"],
    email: json["email"],
    mobileNumber: json["mobile_number"],
    createdDate: DateTime.parse(json["created_date"]),
    updatedDate: DateTime.parse(json["updated_date"]),
    status: json["status"],
    profile: Profile.fromMap(json["profile"].cast<String, dynamic>()),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "username": username,
    "email": email,
    "mobile_number": mobileNumber,
    "created_date": createdDate.toIso8601String(),
    "updated_date": updatedDate.toIso8601String(),
    "status": status,
    "profile": profile.toMap(),
  };
}

class Profile {
  final String fullName;
  final DateTime? dateOfBirth;
  final String gender;
  final String profilePicture;
  final String bio;
  final String country;
  final String city;
  final String timezone;

  Profile({
    required this.fullName,
    required this.dateOfBirth,
    required this.gender,
    required this.profilePicture,
    required this.bio,
    required this.country,
    required this.city,
    required this.timezone,
  });

  Profile copyWith({
    String? fullName,
    DateTime? dateOfBirth,
    String? gender,
    String? profilePicture,
    String? bio,
    String? country,
    String? city,
    String? timezone,
  }) => Profile(
    fullName: fullName ?? this.fullName,
    dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    gender: gender ?? this.gender,
    profilePicture: profilePicture ?? this.profilePicture,
    bio: bio ?? this.bio,
    country: country ?? this.country,
    city: city ?? this.city,
    timezone: timezone ?? this.timezone,
  );

  factory Profile.fromMap(Map<String, dynamic> json) => Profile(
    fullName: json["full_name"],
    dateOfBirth: json["date_of_birth"],
    gender: json["gender"],
    profilePicture: json["profile_picture"],
    bio: json["bio"],
    country: json["country"],
    city: json["city"],
    timezone: json["timezone"],
  );

  Map<String, dynamic> toMap() => {
    "full_name": fullName,
    "date_of_birth": dateOfBirth,
    "gender": gender,
    "profile_picture": profilePicture,
    "bio": bio,
    "country": country,
    "city": city,
    "timezone": timezone,
  };
}
