import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:guftagu_mobile/models/master/master_models.dart'; // Adjust path as needed
import 'package:guftagu_mobile/models/user_model.dart'; // Adjust path as needed

void main() {
  group('User Model Tests', () {
    const String userJsonString = '''
      {
        "id": "user123",
        "username": "testuser",
        "email": "test@example.com",
        "mobile_number": "1234567890",
        "created_date": "2023-01-01T10:00:00Z",
        "updated_date": "2023-01-01T11:00:00Z",
        "status": 1,
        "profile": {
          "full_name": "Test User",
          "date_of_birth": "1990-05-15",
          "gender": "Male",
          "profile_picture": "http://example.com/pic.jpg",
          "bio": "A sample bio",
          "country": {
            "_id": "country456",
            "country_name": "India",
            "flag": "🇮🇳",
            "created_date": "2022-01-01T00:00:00Z",
            "updated_date": "2022-01-01T00:00:00Z",
            "status": 1
          },
          "city": {
            "_id": "city789",
            "city_name": "Bhubaneswar",
            "country_id": "country456",
            "created_date": "2022-02-01T00:00:00Z",
            "updated_date": "2022-02-01T00:00:00Z",
            "status": 1
          },
          "timezone": "Asia/Kolkata"
        },
        "charactertype_id": ["typeA", "typeB"]
      }
    ''';

    const String userJsonStringAltId = '''
      {
        "_id": "user123",
        "username": "testuser",
        "email": "test@example.com",
        "mobile_number": "1234567890",
        "created_date": "2023-01-01T10:00:00Z",
        "updated_date": "2023-01-01T11:00:00Z",
        "status": 1,
        "profile": {
          "full_name": "Test User",
          "date_of_birth": "1990-05-15",
          "gender": "Male",
          "profile_picture": "http://example.com/pic.jpg",
          "bio": "A sample bio",
          "country": {
            "id": "country456",
            "name": "India",
            "flag": "🇮🇳",
            "created_date": "2022-01-01T00:00:00Z",
            "updated_date": "2022-01-01T00:00:00Z",
            "status": 1
          },
          "city": {
            "id": "city789",
            "name": "Bhubaneswar",
            "country": "country456",
            "created_date": "2022-02-01T00:00:00Z",
            "updated_date": "2022-02-01T00:00:00Z",
            "status": 1
          },
          "timezone": "Asia/Kolkata"
        },
        "charactertype_id": ["typeA", "typeB"]
      }
    ''';

    const String userJsonStringWithNullData = '''
      {
        "_id": "user123",
        "username": "testuser",
        "email": null,
        "mobile_number": null,
        "created_date": "2023-01-01T10:00:00Z",
        "updated_date": "2023-01-01T11:00:00Z",
        "status": 1,
        "profile": {
          "full_name": null,
          "date_of_birth": null,
          "gender": null,
          "profile_picture": null,
          "bio": null,
          "country": null,
          "city": null,
          "timezone": null
        },
        "charactertype_id": []
      }
    ''';

    test('User.fromMap should correctly parse JSON with "id"', () {
      final user = userFromMap(userJsonString);

      expect(user.id, 'user123');
      expect(user.username, 'testuser');
      expect(user.email, 'test@example.com');
      expect(user.mobileNumber, '1234567890');
      expect(user.createdDate, DateTime.parse("2023-01-01T10:00:00Z"));
      expect(user.updatedDate, DateTime.parse("2023-01-01T11:00:00Z"));
      expect(user.status, 1);
      expect(user.profile.fullName, 'Test User');
      expect(user.profile.country?.countryName, 'India');
      expect(user.profile.city?.cityName, 'Bhubaneswar');
      expect(user.characterTypeIds, ['typeA', 'typeB']);
    });

    test('User.fromMap should correctly parse JSON with "_id"', () {
      final user = userFromMap(userJsonStringAltId);

      expect(user.id, 'user123');
      expect(user.username, 'testuser');
      expect(user.email, 'test@example.com');
      expect(user.mobileNumber, '1234567890');
      expect(user.createdDate, DateTime.parse("2023-01-01T10:00:00Z"));
      expect(user.updatedDate, DateTime.parse("2023-01-01T11:00:00Z"));
      expect(user.status, 1);
      expect(user.profile.fullName, 'Test User');
      expect(user.profile.country?.countryName, 'India');
      expect(user.profile.city?.cityName, 'Bhubaneswar');
      expect(user.characterTypeIds, ['typeA', 'typeB']);
    });

    test('User.fromMap should correctly parse JSON for new user', () {
      final user = userFromMap(userJsonStringWithNullData);

      expect(user.id, 'user123');
      expect(user.username, 'testuser');
      expect(user.email, "");
      expect(user.mobileNumber, "");
      expect(user.createdDate, DateTime.parse("2023-01-01T10:00:00Z"));
      expect(user.updatedDate, DateTime.parse("2023-01-01T11:00:00Z"));
      expect(user.status, 1);
      expect(user.profile.fullName, null);
      expect(user.profile.country?.countryName, null);
      expect(user.profile.city?.cityName, null);
      expect(user.characterTypeIds, []);
    });

    test('User.toMap should correctly convert to JSON', () {
      final user = User(
        id: "user123",
        username: "testuser",
        email: "test@example.com",
        mobileNumber: "1234567890",
        createdDate: DateTime.parse("2023-01-01T10:00:00Z"),
        updatedDate: DateTime.parse("2023-01-01T11:00:00Z"),
        status: 1,
        profile: Profile(
          fullName: "Test User",
          dateOfBirth: "1990-05-15",
          gender: "Male",
          profilePicture: "http://example.com/pic.jpg",
          bio: "A sample bio",
          country: Country(
            id: "country456",
            countryName: "India",
            flag: "🇮🇳",
            createdDate: DateTime.parse("2022-01-01T00:00:00Z"),
            updatedDate: DateTime.parse("2022-01-01T00:00:00Z"),
            status: 1,
          ),
          city: City(
            id: "city789",
            cityName: "Bhubaneswar",
            countryId: "country456",
            createdDate: DateTime.parse("2022-02-01T00:00:00Z"),
            updatedDate: DateTime.parse("2022-02-01T00:00:00Z"),
            status: 1,
          ),
          timezone: "Asia/Kolkata",
        ),
        characterTypeIds: ["typeA", "typeB"],
      );

      final Map<String, dynamic> jsonMap = user.toMap();

      expect(jsonMap['id'], 'user123');
      expect(jsonMap['username'], 'testuser');
      expect(jsonMap['email'], 'test@example.com');
      expect(jsonMap['mobile_number'], '1234567890');
      expect(jsonMap['created_date'], "2023-01-01T10:00:00.000Z");
      expect(jsonMap['updated_date'], "2023-01-01T11:00:00.000Z");
      expect(jsonMap['status'], 1);
      expect(jsonMap['profile']['full_name'], 'Test User');
      expect(jsonMap['profile']['country']['country_name'], 'India');
      expect(jsonMap['profile']['city']['city_name'], 'Bhubaneswar');
      expect(jsonMap['charactertype_id'], ['typeA', 'typeB']);

      // Check the integrity after round-tripping
      final User decodedUser = User.fromMap(jsonMap);
      expect(decodedUser.id, user.id);
      expect(decodedUser.username, user.username);
      expect(decodedUser.email, user.email);
      expect(decodedUser.mobileNumber, user.mobileNumber);
      expect(decodedUser.createdDate, user.createdDate);
      expect(decodedUser.updatedDate, user.updatedDate);
      expect(decodedUser.status, user.status);
      expect(decodedUser.profile.fullName, user.profile.fullName);
      expect(
        decodedUser.profile.country?.countryName,
        user.profile.country?.countryName,
      );
      expect(decodedUser.profile.city?.cityName, user.profile.city?.cityName);
      expect(decodedUser.characterTypeIds, user.characterTypeIds);
    });

    test('User.fromMap should handle null/missing optional fields', () {
      const String userJsonWithoutOptional = '''
        {
          "id": "user456",
          "username": "anotheruser",
          "created_date": "2023-02-01T10:00:00Z",
          "updated_date": "2023-02-01T11:00:00Z",
          "status": 0,
          "profile": {},
          "charactertype_id": []
        }
      ''';

      final user = userFromMap(userJsonWithoutOptional);

      expect(user.id, 'user456');
      expect(user.username, 'anotheruser');
      expect(user.email, ''); // Default value from fromMap
      expect(user.mobileNumber, ''); // Default value from fromMap
      expect(user.characterTypeIds, []);
      expect(user.profile.fullName, null);
      expect(user.profile.country, null);
      expect(user.profile.city, null);
    });

    test('User.toMap should handle null optional fields', () {
      final user = User(
        id: "user456",
        username: "anotheruser",
        email: "test@example.com",
        mobileNumber: "1234567890",
        createdDate: DateTime.parse("2023-02-01T10:00:00Z"),
        updatedDate: DateTime.parse("2023-02-01T11:00:00Z"),
        status: 0,
        profile: Profile(), // Empty profile
        characterTypeIds: [],
      );

      final Map<String, dynamic> jsonMap = user.toMap();

      expect(jsonMap['id'], 'user456');
      expect(jsonMap['username'], 'anotheruser');
      expect(jsonMap['email'], "test@example.com");
      expect(jsonMap['mobile_number'], "1234567890");
      expect(jsonMap['profile']['full_name'], null);
      expect(jsonMap['profile']['country'], null);
      expect(jsonMap['profile']['city'], null);
      expect(jsonMap['charactertype_id'], []);
    });
  });

  group('Profile Model Tests', () {
    const String profileJsonString = '''
      {
        "full_name": "Profile User",
        "date_of_birth": "1985-11-20",
        "gender": "Female",
        "profile_picture": "http://example.com/profile.png",
        "bio": "Another bio here.",
        "country": {
          "_id": "country001",
          "country_name": "USA",
          "flag": "🇺🇸"
        },
        "city": {
          "_id": "city001",
          "city_name": "New York",
          "country_id": "country001"
        },
        "timezone": "America/New_York"
      }
    ''';

    test('Profile.fromMap should correctly parse JSON', () {
      final profile = Profile.fromMap(json.decode(profileJsonString));

      expect(profile.fullName, 'Profile User');
      expect(profile.dateOfBirth, '1985-11-20');
      expect(profile.gender, 'Female');
      expect(profile.profilePicture, 'http://example.com/profile.png');
      expect(profile.bio, 'Another bio here.');
      expect(profile.country?.countryName, 'USA');
      expect(profile.city?.cityName, 'New York');
      expect(profile.timezone, 'America/New_York');
    });

    test('Profile.toMap should correctly convert to JSON', () {
      final profile = Profile(
        fullName: "Profile User",
        dateOfBirth: "1985-11-20",
        gender: "Female",
        profilePicture: "http://example.com/profile.png",
        bio: "Another bio here.",
        country: Country(id: "country001", countryName: "USA", flag: "🇺🇸"),
        city: City(
          id: "city001",
          cityName: "New York",
          countryId: "country001",
        ),
        timezone: "America/New_York",
      );

      final Map<String, dynamic> jsonMap = profile.toMap();

      expect(jsonMap['full_name'], 'Profile User');
      expect(jsonMap['date_of_birth'], '1985-11-20');
      expect(jsonMap['gender'], 'Female');
      expect(jsonMap['profile_picture'], 'http://example.com/profile.png');
      expect(jsonMap['bio'], 'Another bio here.');
      expect(jsonMap['country']['country_name'], 'USA');
      expect(jsonMap['city']['city_name'], 'New York');
      expect(jsonMap['timezone'], 'America/New_York');
    });

    test('Profile.fromMap should handle null/missing optional fields', () {
      const String profileJsonWithoutOptional = '''
        {
          "full_name": "Simple Profile"
        }
      ''';

      final profile = Profile.fromMap(json.decode(profileJsonWithoutOptional));
      expect(profile.fullName, 'Simple Profile');
      expect(profile.dateOfBirth, null);
      expect(profile.gender, null);
      expect(profile.profilePicture, null);
      expect(profile.bio, null);
      expect(profile.country, null);
      expect(profile.city, null);
      expect(profile.timezone, null);
    });
  });

  group('Country Model Tests', () {
    const String countryJsonString = '''
      {
        "_id": "country101",
        "country_name": "Canada",
        "flag": "🇨🇦",
        "created_date": "2021-01-01T00:00:00Z",
        "updated_date": "2021-01-01T01:00:00Z",
        "status": 1
      }
    ''';

    const String countryJsonStringAltName = '''
      {
        "id": "country101",
        "name": "Canada",
        "flag": "🇨🇦",
        "created_date": "2021-01-01T00:00:00Z",
        "updated_date": "2021-01-01T01:00:00Z",
        "status": 1
      }
    ''';

    test(
      'Country.fromMap should correctly parse JSON with "_id" and "country_name"',
      () {
        final country = Country.fromMap(json.decode(countryJsonString));

        expect(country.id, 'country101');
        expect(country.countryName, 'Canada');
        expect(country.flag, '🇨🇦');
        expect(country.createdDate, DateTime.parse("2021-01-01T00:00:00Z"));
        expect(country.updatedDate, DateTime.parse("2021-01-01T01:00:00Z"));
        expect(country.status, 1);
      },
    );

    test(
      'Country.fromMap should correctly parse JSON with "id" and "name"',
      () {
        final country = Country.fromMap(json.decode(countryJsonStringAltName));

        expect(country.id, 'country101');
        expect(country.countryName, 'Canada');
        expect(country.flag, '🇨🇦');
        expect(country.createdDate, DateTime.parse("2021-01-01T00:00:00Z"));
        expect(country.updatedDate, DateTime.parse("2021-01-01T01:00:00Z"));
        expect(country.status, 1);
      },
    );

    test('Country.toMap should correctly convert to JSON', () {
      final country = Country(
        id: "country101",
        countryName: "Canada",
        flag: "🇨🇦",
        createdDate: DateTime.parse("2021-01-01T00:00:00Z"),
        updatedDate: DateTime.parse("2021-01-01T01:00:00Z"),
        status: 1,
      );

      final Map<String, dynamic> jsonMap = country.toMap();

      expect(jsonMap['_id'], 'country101');
      expect(jsonMap['country_name'], 'Canada');
      expect(jsonMap['flag'], '🇨🇦');
      expect(jsonMap['created_date'], "2021-01-01T00:00:00.000Z");
      expect(jsonMap['updated_date'], "2021-01-01T01:00:00.000Z");
      expect(jsonMap['status'], 1);
    });

    test('Country.fromMap should handle null/missing optional fields', () {
      const String countryJsonWithoutOptional = '''
        {
          "_id": "country_no_flag",
          "country_name": "Germany"
        }
      ''';
      final country = Country.fromMap(json.decode(countryJsonWithoutOptional));
      expect(country.id, 'country_no_flag');
      expect(country.countryName, 'Germany');
      expect(country.flag, null);
      expect(country.createdDate, null);
      expect(country.updatedDate, null);
      expect(country.status, null);
    });
  });

  group('City Model Tests', () {
    const String cityJsonString = '''
      {
        "_id": "city202",
        "city_name": "Vancouver",
        "country_id": "country101",
        "created_date": "2021-02-01T00:00:00Z",
        "updated_date": "2021-02-01T01:00:00Z",
        "status": 1
      }
    ''';

    const String cityJsonStringAltNameCountry = '''
      {
        "id": "city202",
        "name": "Vancouver",
        "country": "country101",
        "created_date": "2021-02-01T00:00:00Z",
        "updated_date": "2021-02-01T01:00:00Z",
        "status": 1
      }
    ''';

    test(
      'City.fromMap should correctly parse JSON with "_id", "city_name", and "country_id"',
      () {
        final city = City.fromMap(json.decode(cityJsonString));

        expect(city.id, 'city202');
        expect(city.cityName, 'Vancouver');
        expect(city.countryId, 'country101');
        expect(city.createdDate, DateTime.parse("2021-02-01T00:00:00Z"));
        expect(city.updatedDate, DateTime.parse("2021-02-01T01:00:00Z"));
        expect(city.status, 1);
      },
    );

    test(
      'City.fromMap should correctly parse JSON with "id", "name", and "country"',
      () {
        final city = City.fromMap(json.decode(cityJsonStringAltNameCountry));

        expect(city.id, 'city202');
        expect(city.cityName, 'Vancouver');
        expect(city.countryId, 'country101');
        expect(city.createdDate, DateTime.parse("2021-02-01T00:00:00Z"));
        expect(city.updatedDate, DateTime.parse("2021-02-01T01:00:00Z"));
        expect(city.status, 1);
      },
    );

    test('City.toMap should correctly convert to JSON', () {
      final city = City(
        id: "city202",
        cityName: "Vancouver",
        countryId: "country101",
        createdDate: DateTime.parse("2021-02-01T00:00:00Z"),
        updatedDate: DateTime.parse("2021-02-01T01:00:00Z"),
        status: 1,
      );

      final Map<String, dynamic> jsonMap = city.toMap();

      expect(jsonMap['_id'], 'city202');
      expect(jsonMap['city_name'], 'Vancouver');
      expect(jsonMap['country_id'], 'country101');
      expect(jsonMap['created_date'], "2021-02-01T00:00:00.000Z");
      expect(jsonMap['updated_date'], "2021-02-01T01:00:00.000Z");
      expect(jsonMap['status'], 1);
    });

    test('City.fromMap should handle null/missing optional fields', () {
      const String cityJsonWithoutOptional = '''
        {
          "_id": "city_no_country",
          "city_name": "Paris"
        }
      ''';
      final city = City.fromMap(json.decode(cityJsonWithoutOptional));
      expect(city.id, 'city_no_country');
      expect(city.cityName, 'Paris');
      expect(city.countryId, null);
      expect(city.createdDate, null);
      expect(city.updatedDate, null);
      expect(city.status, null);
    });
  });
}
