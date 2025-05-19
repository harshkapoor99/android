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
    final masterData = ref.read(masterDataProvider);

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
            optionToString: (c) => "${c.charactertypeName} ${c.emoji}",
            onSelect:
                (p0) => ref
                    .read(characterCreationProvider.notifier)
                    .updateRPBWith(characterType: p0),
            selected: provider.characterType,
            icon: SvgPicture.asset(
              'assets/icons/mdi_category-outline.svg',
              width: 24,
              height: 24,
            ),
          ),
          36.ph,
          Text(
            "What's your companion's relationship to you",
            style: context.appTextStyle.characterGenLabel,
          ),
          16.ph,
          buildOptionTile<Relationship>(
            context: context,
            ref: ref,
            title: "Relationship",
            options:
                masterData.relationships
                    .where(
                      (r) =>
                          r.charactertypeId ==
                          ref.read(characterCreationProvider).characterType?.id,
                    )
                    .toList(),
            optionToString: (c) => "${c.title} ${c.emoji}",
            emptyOptionHint:
                ref.read(characterCreationProvider).characterType != null
                    ? "No relationship found for this Category"
                    : "Choose a category to continue",
            onSelect:
                (p0) => ref
                    .read(characterCreationProvider.notifier)
                    .updateRPBWith(relationship: p0),
            selected: provider.relationship,
            icon: SvgPicture.asset(
              'assets/icons/carbon_friendship.svg',
              width: 24,
              height: 24,
            ),
          ),
          36.ph,
          Text(
            "What's your companion's personality type",
            style: context.appTextStyle.characterGenLabel,
          ),
          16.ph,
          buildOptionTile<Personality>(
            context: context,
            ref: ref,
            title: "Personality",
            options:
                masterData.personalities
                    .where(
                      (p) =>
                          p.relationshipId ==
                          ref.read(characterCreationProvider).relationship?.id,
                    )
                    .toList(),
            optionToString: (c) => "${c.title} ${c.emoji}",
            emptyOptionHint:
                ref.read(characterCreationProvider).relationship != null
                    ? "No personality found for this relationship"
                    : "Choose a relationship to continue",
            onSelect:
                (p0) => ref
                    .read(characterCreationProvider.notifier)
                    .updateRPBWith(personality: p0),
            selected: provider.personality,
            icon: SvgPicture.asset(
              'assets/icons/solar_mask-sad-linear.svg',
              width: 24,
              height: 24,
            ),
          ),
          36.ph,
          Text(
            "Which behaviour's match your companion",
            style: context.appTextStyle.characterGenLabel,
          ),
          16.ph,
          buildOptionTile<Behaviour>(
            context: context,
            ref: ref,
            title: "Behaviours",
            options:
                masterData.behaviours
                    .where(
                      (b) =>
                          b.personalityId ==
                          ref.read(characterCreationProvider).personality?.id,
                    )
                    .toList(),
            optionToString: (c) => "${c.title} ${c.emoji}",
            emptyOptionHint:
                ref.read(characterCreationProvider).personality != null
                    ? "No Behaviour found for this personality"
                    : "Choose a personality to continue",
            onSelect: (p0) => {},
            onMultiSelect:
                (p0) => ref
                    .read(characterCreationProvider.notifier)
                    .updateRPBWith(behaviours: p0),
            multiSelected: provider.behaviours,
            icon: SvgPicture.asset(
              'assets/icons/material-symbols_mindfulness-outline.svg',
              width: 24,
              height: 24,
            ),
            isMultiple: true,
            maxSelectToClose: 3,
          ),
          36.ph,
        ],
      ),
    );
  }
}
