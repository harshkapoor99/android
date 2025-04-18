import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guftagu_mobile/providers/character_creation_provider.dart';
import 'package:guftagu_mobile/utils/entensions.dart';
import '../../../components/choice_option_selector.dart';
import '../../../components/image_option_selector.dart';
import '../../../components/labeled_text_field.dart';

class Step0Widget extends ConsumerWidget {
  Step0Widget({super.key});

  final List<String> ageOptions = ['Teen (+18)', '20s', '30s', '40-55s'];
  final List<Map<String, dynamic>> genderOptions = [
    {
      'label': 'Female',
      'image': 'assets/images/model/mod_img5.jpeg',
      'icon': 'assets/icons/female.svg',
      'value': 'female',
    },
    {
      'label': 'Male',
      'image': 'assets/images/onboarding/ob_img14.webp',
      'icon': 'assets/icons/male.svg',
      'value': 'male',
    },
    {
      'label': 'Others',
      'image': 'assets/images/les.png',
      'icon': 'assets/icons/lesbo.svg',
      'value': 'others',
    },
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(characterCreationProvider);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LabeledTextField(
              controller: provider.characterNameController,
              label: 'Character Name',
            ),
            24.ph,
            const Text(
              'Choose Age',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFFF2F2F2),
              ),
            ),
            20.ph,
            ChoiceOptionSelector(
              options: ageOptions,
              selected: provider.age ?? "",
              onSelected: (age) {
                FocusManager.instance.primaryFocus?.unfocus();
                ref
                    .read(characterCreationProvider.notifier)
                    .updateWith(age: age);
              },
            ),
            24.ph,
            const Text(
              'Gender',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFFF2F2F2),
              ),
            ),
            12.ph,
            ImageOptionSelector(
              options: genderOptions,
              selected: provider.gender ?? "",
              onChanged:
                  (gender) => ref
                      .read(characterCreationProvider.notifier)
                      .updateWith(gender: gender),
            ),
          ],
        ),
      ),
    );
  }
}
