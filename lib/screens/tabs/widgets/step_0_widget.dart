import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guftagu_mobile/components/label_text.dart';
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

  final List<String> sexualOrientationOptions = const [
    'Straight',
    'Gay',
    'Lesbian',
  ];

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
            22.ph,
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
            22.ph,
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
            22.ph,
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
                                    ? context.colorExt.button
                                    : context.colorExt.surface,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            option,
                            style: context.appTextStyle.textSemibold.copyWith(
                              fontSize: 14,
                              color:
                                  isSelected
                                      ? context.colorExt.buttonText
                                      : null,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),

            20.ph,
          ],
        ),
      ),
    );
  }
}
