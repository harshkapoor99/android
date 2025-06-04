// character_type_state.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guftagu_mobile/models/common/common_response_model.dart';
import 'package:guftagu_mobile/models/master/master_models.dart';
import 'package:guftagu_mobile/providers/master_data_provider.dart';
import 'package:guftagu_mobile/services/hive_service.dart';
import 'package:guftagu_mobile/services/user_profile_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '../gen/providers/character_type_provider.gen.dart';

@riverpod
bool userInterestButtonStatus(Ref ref) {
  final providerAsync = ref
      .watch(userInterestProvider)
      .whenData((value) => value);
  return providerAsync.maybeWhen(
    data: (data) => data.selectedCharacterTypes.length < 5,
    orElse: () => false,
  );
}

@riverpod
class UserInterest extends _$UserInterest {
  @override
  Future<UserInterestState> build() async {
    try {
      await ref.read(masterDataProvider.notifier).fetchCharacterTypes();
      final List<CharacterType> characterTypes =
          ref.read(masterDataProvider).characterTypes;

      return UserInterestState(
        characterTypes: characterTypes,
        selectedCharacterTypes: [],
      );
    } catch (e, st) {
      // Convert any errors to AsyncValue error state
      throw AsyncError(e, st);
    }
  }

  void toggleCharacterType(CharacterType characterType) async {
    final currentState = await future;

    List<CharacterType> selected = currentState.selectedCharacterTypes;

    if (currentState.selectedCharacterTypes.contains(characterType)) {
      selected.remove(characterType);
    } else {
      selected.add(characterType);
    }

    currentState.selectedCharacterTypes = selected;
    state = AsyncData(currentState);
  }

  Future<CommonResponse> saveInterests() async {
    final currentState = await future;
    List<CharacterType> characterTypes = currentState.characterTypes;
    state = AsyncData(currentState.updateWith(isLoading: true));
    try {
      var res = await ref
          .read(profileServiceProvider)
          .saveInterests(
            ref.read(hiveServiceProvider.notifier).getUserId()!,
            characterTypes.map((e) => e.id).toList(),
          );

      if (res.statusCode == 200) {
        ref
            .read(hiveServiceProvider.notifier)
            .updateUserInfo(
              characterTypeIds: characterTypes.map((e) => e.id).toList(),
            );
      }
      return CommonResponse(isSuccess: true, message: res.data["message"]);
    } catch (e) {
      print(e);
      return CommonResponse(
        isSuccess: false,
        message: "Something went wrong: ${e.toString()}",
      );
    } finally {
      state = AsyncData(currentState.updateWith(isLoading: false));
    }
  }
}

class UserInterestState {
  UserInterestState({
    this.isLoading = false,
    required this.characterTypes,
    required this.selectedCharacterTypes,
  });

  bool isLoading;
  List<CharacterType> characterTypes;
  List<CharacterType> selectedCharacterTypes;

  UserInterestState updateWith({
    bool? isLoading,
    List<CharacterType>? characterTypes,
    List<CharacterType>? selectedCharacterTypes,
  }) {
    return UserInterestState(
      isLoading: isLoading ?? this.isLoading,
      characterTypes: characterTypes ?? this.characterTypes,
      selectedCharacterTypes:
          selectedCharacterTypes ?? this.selectedCharacterTypes,
    );
  }
}
