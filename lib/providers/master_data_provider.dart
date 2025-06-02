import 'package:guftagu_mobile/models/character.dart';
import 'package:guftagu_mobile/models/master/master_models.dart';
import 'package:guftagu_mobile/providers/character_creation_provider.dart';
import 'package:guftagu_mobile/services/hive_service.dart';
import 'package:guftagu_mobile/services/master_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '../gen/providers/master_data_provider.gen.dart';

@Riverpod(keepAlive: true)
class MasterData extends _$MasterData {
  @override
  MasterDataState build() {
    return const MasterDataState(
      languages: [],
      behaviours: [],
      personalities: [],
      relationships: [],
      voices: [],
      countries: [],
      cities: [],
      characterTypes: [],
      characters: [],
    );
  }

  Future<void> fetchLanguages() async {
    final response = await ref.read(masterServiceProvider).fetchLanguages();
    try {
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        final List<Language> languages =
            data.map((e) => Language.fromMap(e)).toList().cast<Language>();
        state = state.copyWith(languages: languages);
      }
    } catch (e) {
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  // 25, 64, 73, API
  Future<void> fetchBehaviours() async {
    final response = await ref.read(masterServiceProvider).fetchBehavious();
    try {
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        final List<Behaviour> behaviours =
            data.map((e) => Behaviour.fromMap(e)).toList().cast<Behaviour>();
        state = state.copyWith(behaviours: behaviours);
      }
    } catch (e) {
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> fetchPersonalities() async {
    final response =
        await ref.read(masterServiceProvider).fetchPersionalities();
    try {
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        final List<Personality> personalities =
            data
                .map((e) => Personality.fromMap(e))
                .toList()
                .cast<Personality>();
        state = state.copyWith(personalities: personalities);
      }
    } catch (e) {
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> fetchRelationships() async {
    final response = await ref.read(masterServiceProvider).fetchRelationships();
    try {
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        final List<Relationship> relationships =
            data
                .map((e) => Relationship.fromMap(e))
                .toList()
                .cast<Relationship>();
        state = state.copyWith(relationships: relationships);
      }
    } catch (e) {
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> fetchVoices() async {
    final response = await ref.read(masterServiceProvider).fetchVoices();
    try {
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        final List<Voice> voices =
            data.map((e) => Voice.fromMap(e)).toList().cast<Voice>();
        state = state.copyWith(voices: voices);
      }
    } catch (e) {
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> fetchCountries() async {
    final response = await ref.read(masterServiceProvider).fetchCountries();
    try {
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        final List<Country> countries =
            data.map((e) => Country.fromMap(e)).toList().cast<Country>();
        state = state.copyWith(countries: countries);
      }
    } catch (e) {
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> fetchCities() async {
    final response = await ref.read(masterServiceProvider).fetchCities();
    try {
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        final List<City> cities =
            data.map((e) => City.fromMap(e)).toList().cast<City>();
        state = state.copyWith(cities: cities);
      }
    } catch (e) {
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> fetchCitiesByCountry({required Country country}) async {
    state = state.copyWith(isLoading: true);
    final response = await ref
        .read(masterServiceProvider)
        .fetchCitiesByCountry(countryId: country.id);
    try {
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        final List<City> cities =
            data.map((e) => City.fromMap(e)).toList().cast<City>();
        state = state.copyWith(cities: cities);
      }
    } catch (e) {
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> fetchCharacterTypes() async {
    final response =
        await ref.read(masterServiceProvider).fetchCharacterTypes();
    try {
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        // response CTs
        final List<CharacterType> resCharacterTypes =
            data
                .map((e) => CharacterType.fromMap(e))
                .toList()
                .cast<CharacterType>();
        // user interested CTs
        final userInterests =
            ref
                .read(hiveServiceProvider.notifier)
                .getUserInfo()!
                .characterTypeIds;

        for (var element in resCharacterTypes) {
          if (userInterests.contains(element.id)) {
            resCharacterTypes.remove(element);
            resCharacterTypes.add(element);
          }
        }

        state = state.copyWith(
          characterTypes: resCharacterTypes.reversed.toList(),
        );
      }
    } catch (e) {
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void fetchAllMasterData() async {
    Future.wait([
      fetchCharacterTypes(),
      fetchCountries(),
      fetchLanguages(),
      fetchVoices(),
      fetchMasterCharacters(),
      // fetchRelationships(),
      // fetchPersonalities(),
      // fetchBehaviours(),
    ]);
  }

  Future<void> fetchBehaviousByPersonality() async {
    final response = await ref
        .read(masterServiceProvider)
        .fetchBehaviousByPersonality(
          ref.read(characterCreationProvider).personality!.id,
        );
    try {
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        final List<Behaviour> behaviours =
            data.map((e) => Behaviour.fromMap(e)).toList().cast<Behaviour>();
        state = state.copyWith(behaviours: behaviours);
      }
    } catch (e) {
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> fetchPersionalitiesByRelationship() async {
    final response = await ref
        .read(masterServiceProvider)
        .fetchPersionalitiesByRelationship(
          ref.read(characterCreationProvider).relationship!.id,
        );
    try {
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        final List<Personality> personalities =
            data
                .map((e) => Personality.fromMap(e))
                .toList()
                .cast<Personality>();
        state = state.copyWith(personalities: personalities, behaviours: []);
      }
    } catch (e) {
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> fetchRelationshipsByCharactertype() async {
    final response = await ref
        .read(masterServiceProvider)
        .fetchRelationshipsByCharactertype(
          ref.read(characterCreationProvider).characterType!.id,
        );
    try {
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        final List<Relationship> relationships =
            data
                .map((e) => Relationship.fromMap(e))
                .toList()
                .cast<Relationship>();
        state = state.copyWith(
          relationships: relationships,
          personalities: [],
          behaviours: [],
        );
      }
    } catch (e) {
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> fetchMasterCharacters() async {
    final response =
        await ref.read(masterServiceProvider).fetchMasterCharacters();
    try {
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        final List<Character> characters =
            data.map((e) => Character.fromMap(e)).toList().cast<Character>();
        state = state.copyWith(characters: characters);
      }
    } catch (e) {
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void selectCharacterTypeFilter(CharacterType characterType) {
    state = state.copyWith(seletedCharacterTypeTab: characterType);
    // TODO: get all master Characters with the filter
  }
}

class MasterDataState {
  const MasterDataState({
    this.isLoading = false,
    required this.languages,
    required this.behaviours,
    required this.personalities,
    required this.relationships,
    required this.voices,
    required this.countries,
    required this.cities,
    required this.characterTypes,
    required this.characters,
    this.seletedCharacterTypeTab,
  });

  final bool isLoading;

  final List<Language> languages;
  final List<Behaviour> behaviours;
  final List<Personality> personalities;
  final List<Relationship> relationships;
  final List<Voice> voices;
  final List<Country> countries;
  final List<City> cities;
  final List<CharacterType> characterTypes;
  final List<Character> characters;

  final CharacterType? seletedCharacterTypeTab;

  MasterDataState copyWith({
    bool? isLoading,
    List<Language>? languages,
    List<Behaviour>? behaviours,
    List<Personality>? personalities,
    List<Relationship>? relationships,
    List<Voice>? voices,
    List<Country>? countries,
    List<City>? cities,
    List<CharacterType>? characterTypes,
    List<Character>? characters,
    CharacterType? seletedCharacterTypeTab,
  }) {
    return MasterDataState(
      isLoading: isLoading ?? this.isLoading,
      languages: languages ?? this.languages,
      behaviours: behaviours ?? this.behaviours,
      personalities: personalities ?? this.personalities,
      relationships: relationships ?? this.relationships,
      voices: voices ?? this.voices,
      countries: countries ?? this.countries,
      cities: cities ?? this.cities,
      characterTypes: characterTypes ?? this.characterTypes,
      characters: characters ?? this.characters,
      seletedCharacterTypeTab:
          seletedCharacterTypeTab ?? this.seletedCharacterTypeTab,
    );
  }
}
