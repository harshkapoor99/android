// character_type_state.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guftagu_mobile/services/master_service.dart';
import '../models/master/master_models.dart';

// Holds list of character types
final characterTypesProvider = StateProvider<List<CharacterType>>((ref) => []);

// Fetches character types and updates state
final characterTypesFutureProvider = FutureProvider<void>((ref) async {
  final masterService = ref.read(masterServiceProvider);
  final characterTypes = await masterService.fetchCharacterTypes();

  ref.read(characterTypesProvider.notifier).state = characterTypes as List<CharacterType>;
});
