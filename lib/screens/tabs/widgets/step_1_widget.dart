import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guftagu_mobile/components/label_text.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/models/master/master_models.dart';
import 'package:guftagu_mobile/providers/master_data_provider.dart';
import 'package:guftagu_mobile/screens/tabs/widgets/preference_picker.dart';
import 'package:guftagu_mobile/utils/extensions.dart';
import '../../../components/image_option_selector.dart';
import '../../../providers/character_creation_provider.dart';

class Step1Widget extends ConsumerWidget {
  Step1Widget({super.key});

  final List<ImageOptions> styleOptions = [
    ImageOptions(
      label: 'Realistic',
      image: Assets.images.realistic,
      value: 'realistic',
    ),
    ImageOptions(label: 'Animated', image: Assets.images.anime, value: 'anime'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(characterCreationProvider);
    final masterData = ref.watch(masterDataProvider);
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LabelText('Character Style'),
          ImageOptionSelector(
            options: styleOptions,
            selected: provider.style ?? "",
            onChanged:
                (style) => ref
                    .read(characterCreationProvider.notifier)
                    .updateWith(style: style),
          ),
          22.ph,
          const LabelText("Companion's Country"),
          buildOptionTile<Country>(
            context: context,
            ref: ref,
            title: "Country",
            options: masterData.countries,
            optionToString: (c) => c.countryName,
            onSelect:
                (p0) => ref
                    .read(characterCreationProvider.notifier)
                    .updateCountryCityWith(country: p0),
            selected: provider.country,
          ),
          22.ph,
          const LabelText("Companion's City"),
          Consumer(
            builder: (context, ref, child) {
              final masterData = ref.watch(masterDataProvider);
              return buildOptionTile<City>(
                context: context,
                ref: ref,
                title: "City",
                showLoading: masterData.isLoading,
                options:
                    masterData.cities
                        .where(
                          (c) =>
                              c.countryId ==
                              ref.read(characterCreationProvider).country?.id,
                        )
                        .toList(),
                optionToString: (c) => c.cityName,
                onSelect:
                    (p0) => ref
                        .read(characterCreationProvider.notifier)
                        .updateCountryCityWith(city: p0),
                selected: provider.city,
              );
            },
          ),
          22.ph,
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
          22.ph,
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
            // onSelect:
            //     (p0) => ref
            //         .read(characterCreationProvider.notifier)
            //         .updateLanguageVoiceWith(voice: p0),
            selected: provider.voice,
          ),
          20.ph,
        ],
      ),
    );
  }
}
