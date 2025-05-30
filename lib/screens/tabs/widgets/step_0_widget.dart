import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/providers/character_creation_provider.dart';
import 'package:guftagu_mobile/screens/tabs/widgets/preference_picker.dart';
import 'package:guftagu_mobile/utils/age_input_formatter.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
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
              labelColor: const Color(0xFFF2F2F2),
              controller: provider.characterNameController,
              label: 'Character Name',
              hintText: 'Name',
            ),
            26.ph,
            LabeledTextField(
              labelColor: const Color(0xFFF2F2F2),
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
            Text('Gender', style: context.appTextStyle.characterGenLabel),
            12.ph,
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
            Text(
              'Sexual Orientation',
              style: context.appTextStyle.characterGenLabel,
            ),
            16.ph,
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
                                    ? Color(0xFFBEBEBE)
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
            Text(
              'Companion’s  Voice',
              style: context.appTextStyle.textSemibold.copyWith(
                color: const Color(0xFFF2F2F2),
              ),
            ),
            16.ph,
            buildOptionTile<Voice>(
              context: context,
              ref: ref,
              title: 'Voice',
              options: masterData.voices,
              optionToString: (v) => v.fullName,
              onSelect:
                  (p0) => ref
                      .read(characterCreationProvider.notifier)
                      .updateWith(voice: p0),
              selected: characterProvider.voice,
            ),
            20.ph,
          ],
        ),
      ),
    );
  }
}
