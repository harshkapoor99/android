import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guftagu_mobile/models/master/master_models.dart';
import 'package:guftagu_mobile/providers/master_data_provider.dart';
import 'package:guftagu_mobile/screens/tabs/widgets/preference_picker.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:guftagu_mobile/utils/entensions.dart';
import '../../../components/image_option_selector.dart';
import '../../../providers/character_creation_provider.dart';

class Step1Widget extends ConsumerWidget {
  Step1Widget({super.key});

  final List<Map<String, dynamic>> styleOptions = [
    {
      'label': 'Realistic',
      'image': 'assets/images/model/realNew.png',
      'value': 'realistic',
    },
    {
      'label': 'Animie',
      'image': 'assets/images/model/animeNew.png',
      'value': 'anime',
    },
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
          Text(
            'Character Style',
            style: context.appTextStyle.characterGenLabel,
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
          36.ph,
          Text(
            "Companion's Country",
            style: context.appTextStyle.characterGenLabel,
          ),
          16.ph,
          buildOptionTile<Country>(
            context: context,
            ref: ref,
            title: "Country",
            options: masterData.countries,
            optionToString: (c) => c.countryName,
            onSelect:
                (p0) => ref
                    .read(characterCreationProvider.notifier)
                    .updateWith(country: p0),
            selected: provider.country,
          ),
          36.ph,
          Text(
            "Companion's City",
            style: context.appTextStyle.characterGenLabel,
          ),
          16.ph,
          buildOptionTile<City>(
            context: context,
            ref: ref,
            title: "City",
            options: masterData.cities,
            optionToString: (c) => c.cityName,
            onSelect:
                (p0) => ref
                    .read(characterCreationProvider.notifier)
                    .updateWith(city: p0),
            selected: provider.city,
          ),
          36.ph,
          Text(
            "Companion's Language",
            style: context.appTextStyle.characterGenLabel,
          ),

          16.ph,
          buildOptionTile<Language>(
            context: context,
            ref: ref,
            title: "Language",
            options: masterData.languages,
            optionToString: (c) => c.title,
            onSelect:
                (p0) => ref
                    .read(characterCreationProvider.notifier)
                    .updateWith(language: p0),
            selected: provider.language,
          ),
          32.ph,
        ],
      ),
    );
  }
}
