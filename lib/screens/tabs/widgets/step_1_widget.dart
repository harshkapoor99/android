import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guftagu_mobile/models/master/master_models.dart';
import 'package:guftagu_mobile/providers/character_creation_provider.dart';
import 'package:guftagu_mobile/providers/master_data_provider.dart';
import 'package:guftagu_mobile/utils/entensions.dart';
import '../../../components/choice_option_selector.dart';
import '../../../components/image_option_selector.dart';

class Step1Widget extends ConsumerWidget {
  Step1Widget({super.key});
  final List<Map<String, dynamic>> styleOptions = [
    {
      'label': 'Realistic',
      'image': 'assets/images/model/mod_img9.png',
      'value': 'realistic',
    },
    {
      'label': 'Animie',
      'image': 'assets/images/model/mod_img10.png',
      'value': 'anime',
    },
  ];
  final List<String> orientationOptions = ['Straight', 'Gay', 'Lesbian'];
  final List<String> languageOptions = ['English', 'Hinglish'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(characterCreationProvider);
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Style',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFFF2F2F2),
            ),
          ),
          12.ph,
          ImageOptionSelector(
            options: styleOptions,
            selected: provider.style ?? "",
            onChanged:
                (style) => ref
                    .read(characterCreationProvider.notifier)
                    .updateWith(style: style),
          ),
          24.ph,
          const Text(
            'Sexual Orientation',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFFF2F2F2),
            ),
          ),
          12.ph,
          ChoiceOptionSelector(
            options: orientationOptions,
            selected: provider.sexualOrientation ?? "",
            onSelected:
                (value) => ref
                    .read(characterCreationProvider.notifier)
                    .updateWith(sexualOrientation: value),
          ),
          24.ph,
          const Text(
            'Primary Language',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFFF2F2F2),
            ),
          ),
          12.ph,
          ChoiceOptionSelector<Language>(
            options: ref.read(masterDataProvider).languages,
            selected: provider.language,
            optionToString: (p0) => p0.title,
            onSelected:
                (value) => ref
                    .read(characterCreationProvider.notifier)
                    .updateWith(language: value),
          ),
        ],
      ),
    );
  }
}
