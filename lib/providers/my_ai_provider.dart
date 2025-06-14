import 'package:flutter/widgets.dart';
import 'package:guftagu_mobile/models/character.dart';
import 'package:guftagu_mobile/services/hive_service.dart';
import 'package:guftagu_mobile/services/my_ai_service.dart';
import 'package:guftagu_mobile/utils/app_constants.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '../gen/providers/my_ai_provider.gen.dart';

@Riverpod(keepAlive: true)
class MyAi extends _$MyAi {
  @override
  MyAiState build() {
    MyAiState iniState = MyAiState(
      searchController: TextEditingController(),
      myAiList: [],
      filteredAiList: [],
    );
    iniState.searchController.addListener(() {
      state = state._updateWith(
        searchController: state.searchController,
        filteredAiList:
            state.myAiList
                .where(
                  (element) => element.name.toLowerCase().contains(
                    state.searchController.text,
                  ),
                )
                .toList(),
      );
    });
    return iniState;
  }

  void toggleSearch() {
    state = state._updateWith(isSearching: !state.isSearching);
    state.searchController.clear();
  }

  void fetchMyAis() async {
    // state = state._updateWith(isLoading: true);
    try {
      final response = await ref
          .read(myAiServiceProvider)
          .fetchMyAis(
            creatorId: ref.read(hiveServiceProvider.notifier).getUserId()!,
          );
      final List<dynamic> characters = response.data["characters"];
      final List<Character> myAiList =
          characters.map((character) => Character.fromMap(character)).toList();
      state = state._updateWith(myAiList: myAiList, filteredAiList: myAiList);
    } catch (e) {
      rethrow;
    } finally {
      state = state._updateWith(isLoading: false);
    }
  }

  void deleteCharacter(String characterId) async {
    final res = await ref
        .read(myAiServiceProvider)
        .deleteCharacter(characterId: characterId);
    if (res.statusCode == 200) {
      AppConstants.showSnackbar(message: "Character deleted", isSuccess: true);
      fetchMyAis();
    }
  }
}

class MyAiState {
  MyAiState({
    required this.myAiList,
    required this.filteredAiList,
    this.isLoading = false,
    this.isSearching = false,
    required this.searchController,
  });

  final List<Character> myAiList;
  final List<Character> filteredAiList;
  final bool isLoading;
  final TextEditingController searchController;
  final bool isSearching;

  MyAiState _updateWith({
    List<Character>? myAiList,
    List<Character>? filteredAiList,
    bool? isLoading,
    TextEditingController? searchController,
    bool? isSearching,
  }) {
    return MyAiState(
      myAiList: myAiList ?? this.myAiList,
      filteredAiList: filteredAiList ?? this.filteredAiList,
      isLoading: isLoading ?? this.isLoading,
      searchController: searchController ?? this.searchController,
      isSearching: isSearching ?? this.isSearching,
    );
  }
}
