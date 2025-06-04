import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guftagu_mobile/components/label_text.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/providers/character_creation_provider.dart';
import 'package:guftagu_mobile/screens/tabs/widgets/preference_picker.dart';
import 'package:guftagu_mobile/utils/age_input_formatter.dart';
import 'package:guftagu_mobile/utils/extensions.dart';
import '../../../components/image_option_selector.dart';
import '../../../components/labeled_text_field.dart';
import '../../../models/master/master_models.dart';
import '../../../providers/master_data_provider.dart';

class Step0Widget extends ConsumerWidget {
  Step0Widget({super.key});

  final List<String> sexualOrientationOptions = ['Straight', 'Gay', 'Lesbian'];

  final List<ImageOptions> genderOptions = [
    ImageOptions(
      label: 'Female',
      image: Assets.images.female,
      icon: Assets.icons.female,
      value: 'female',
    ),
    ImageOptions(
      label: 'Male',
      image: Assets.images.male,
      icon: Assets.icons.male,
      value: 'male',
    ),
    ImageOptions(
      label: 'Others',
      image: Assets.images.trans,
      icon: Assets.icons.lesbo,
      value: 'others',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final masterData = ref.watch(masterDataProvider);
    final characterProvider = ref.watch(characterCreationProvider);

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
              hintText: 'Name',
            ),
            26.ph,
            LabeledTextField(
              controller: provider.ageController,
              label: 'Age (years - minimum 18+)',
              hintText: 'Eg. 26',
              keyboardType: TextInputType.number,
              // maxLength: 2,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                // LengthLimitingTextInputFormatter(2),
                TwoDigitRangeTextInputFormatter(min: 18, max: 99),
              ],
            ),
            26.ph,
            const LabelText("Gender"),
            ImageOptionSelector(
              options: genderOptions,
              selected: provider.gender ?? "",
              onChanged: (gender) {
                ref
                    .read(characterCreationProvider.notifier)
                    .updateWith(gender: gender);
                FocusManager.instance.primaryFocus?.unfocus();
              },
            ),
            26.ph,
            const LabelText("Sexual Orientation"),
            Row(
              children:
                  sexualOrientationOptions.map((option) {
                    final isSelected = provider.sexualOrientation == option;
                    return Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: InkWell(
                        onTap: () {
                          ref
                              .read(characterCreationProvider.notifier)
                              .updateWith(sexualOrientation: option);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? const Color(0xFFBEBEBE)
                                    : const Color(0xFF23222F),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            option,
                            style:
                                isSelected
                                    ? const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF000000),
                                    )
                                    : const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
            26.ph,
            const LabelText("Companion's  Language"),
            buildOptionTile<Language>(
              context: context,
              ref: ref,
              title: "Language",
              options: masterData.languages,
              optionToString: (c) => c.title,
              onSelect:
                  (p0) => ref
                      .read(characterCreationProvider.notifier)
                      .updateLanguageVoiceWith(language: p0),
              selected: provider.language,
            ),
            26.ph,
            const LabelText("Companion's  Voice"),
            buildOptionTile<Voice>(
              context: context,
              ref: ref,
              title: 'Voices',
              options: masterData.voices,
              showLoading: masterData.isLoading,
              emptyOptionHint:
                  ref.read(characterCreationProvider).language != null
                      ? "No Voice found for this Language"
                      : "Choose a Language to continue",
              optionToString: (v) => v.fullName,
              optionToStringSubtitle: (v) => v.gender,
              onSelect:
                  (p0) => ref
                      .read(characterCreationProvider.notifier)
                      .updateLanguageVoiceWith(voice: p0),
              selected: characterProvider.voice,
            ),
            20.ph,
          ],
        ),
      ),
    );
  }
}
