import 'package:guftagu_mobile/models/character.dart';
import 'package:guftagu_mobile/services/hive_service.dart';
import 'package:guftagu_mobile/services/my_ai_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '../gen/providers/my_ai_provider.gen.dart';

@Riverpod(keepAlive: true)
class MyAi extends _$MyAi {
  @override
  MyAiState build() {
    return MyAiState(myAiList: []);
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
      state = state._updateWith(myAiList: myAiList);
    } catch (e) {
      rethrow;
    } finally {
      state = state._updateWith(isLoading: false);
    }
  }
}

class MyAiState {
  MyAiState({required this.myAiList, this.isLoading = false});

  final List<Character> myAiList;
  final bool isLoading;

  MyAiState _updateWith({List<Character>? myAiList, bool? isLoading}) {
    return MyAiState(
      myAiList: myAiList ?? this.myAiList,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
