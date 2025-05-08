import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:guftagu_mobile/models/master/master_models.dart';
import 'package:guftagu_mobile/providers/character_creation_provider.dart';
import 'package:guftagu_mobile/providers/master_data_provider.dart';
import 'package:guftagu_mobile/screens/tabs/widgets/preference_picker.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:guftagu_mobile/utils/entensions.dart';

class Step2Widget extends ConsumerWidget {
  const Step2Widget({super.key});

  static const double _horizontalPadding = 24.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(characterCreationProvider);
    final masterData = ref.read(
      masterDataProvider,
    ); // Read once for options list
    final characterProvider = ref.watch(
      characterCreationProvider,
    ); // Watch for selected values

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: _horizontalPadding,
        vertical: 5.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "What type of category fits your companion",
            style: context.appTextStyle.characterGenLabel,
          ),
          16.ph,
          buildOptionTile<CharacterType>(
            context: context,
            ref: ref,
            title: "Category",
            options: masterData.characterTypes,
            optionToString: (c) => c.charactertypeName,
            onSelect:
                (p0) =>
                ref
                    .read(characterCreationProvider.notifier)
                    .updateWith(characterType: p0),
            selected: provider.characterType,
            icon: SvgPicture.asset(
              'assets/icons/mdi_category-outline.svg',
              width: 24,
              height: 24,
            ),
          ),
          36.ph,
          Text(
            "What\'s your companion\'s relationship to you",
            style: context.appTextStyle.characterGenLabel,
          ),
          16.ph,
          buildOptionTile<Relationship>(
            context: context,
            ref: ref,
            title: "Relationship",
            options: masterData.relationships,
            optionToString: (c) => c.title,
            onSelect:
                (p0) =>
                ref
                    .read(characterCreationProvider.notifier)
                    .updateWith(relationship: p0),
            selected: provider.relationship,
            icon: SvgPicture.asset(
              'assets/icons/carbon_friendship.svg',
              width: 24,
              height: 24,
            ),
          ),
          36.ph,
          Text(
            "What\'s your companion\'s personality type",
            style: context.appTextStyle.characterGenLabel,
          ),
          16.ph,
          buildOptionTile<Personality>(
            context: context,
            ref: ref,
            title: "Personality",
            options: masterData.personalities,
            optionToString: (c) => c.title,
            onSelect:
                (p0) =>
                ref
                    .read(characterCreationProvider.notifier)
                    .updateWith(personality: p0),
            selected: provider.personality,
            icon: SvgPicture.asset(
              'assets/icons/solar_mask-sad-linear.svg',
              width: 24,
              height: 24,
            ),
          ),
          36.ph,
          Text(
            "Which behaviour\'s match your companion",
            style: context.appTextStyle.characterGenLabel,
          ),
          16.ph,
          buildOptionTile<Behaviour>(
            context: context,
            ref: ref,
            title: "Behaviour",
            options: masterData.behaviours,
            optionToString: (c) => c.title,
            onSelect:
                (p0) =>
                ref
                    .read(characterCreationProvider.notifier)
                    .updateWith(behaviour: p0),
            selected: provider.behaviour,
            icon: SvgPicture.asset(
              'assets/icons/material-symbols_mindfulness-outline.svg',
              width: 24,
              height: 24,
            ),
          ),
          36.ph,
        ],
      ),
    );
  }
}