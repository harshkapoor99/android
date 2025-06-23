import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:guftagu_mobile/components/label_text.dart';
import 'package:guftagu_mobile/models/master/master_models.dart';
import 'package:guftagu_mobile/providers/character_creation_provider.dart';
import 'package:guftagu_mobile/providers/master_data_provider.dart';
import 'package:guftagu_mobile/screens/tabs/widgets/preference_picker.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:guftagu_mobile/utils/extensions.dart';

class Step2Widget extends ConsumerWidget {
  const Step2Widget({super.key});

  static const double _horizontalPadding = 24.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(characterCreationProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: _horizontalPadding,
        vertical: 5.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LabelText("What type of category fits your companion"),
          buildOptionTile<CharacterType>(
            context: context,
            ref: ref,
            title: "Category",
            options: ref.watch(
              masterDataProvider.select((state) => state.characterTypes),
            ),
            optionToString: (c) => "${c.charactertypeName} ${c.emoji}",
            onSelect:
                (p0) => ref
                    .read(characterCreationProvider.notifier)
                    .updateCRPBWith(characterType: p0),
            selected: provider.characterType,
            icon: SvgPicture.asset(
              'assets/icons/mdi_category-outline.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                context.colorExt.tertiary,
                BlendMode.srcIn,
              ),
            ),
          ),
          26.ph,
          const LabelText("What's your companion's relationship to you"),
          buildOptionTile<Relationship>(
            context: context,
            ref: ref,
            title: "Relationship",
            options: ref.watch(
              masterDataProvider.select((state) => state.relationships),
            ),
            optionToString: (c) => "${c.title} ${c.emoji}",
            showLoading: ref.watch(
              masterDataProvider.select((v) => v.isRelationshipLoading),
            ),
            emptyOptionHint:
                ref.read(characterCreationProvider).characterType != null
                    ? "No relationship found for this Category"
                    : "Choose a category to continue",
            onSelect:
                (p0) => ref
                    .read(characterCreationProvider.notifier)
                    .updateCRPBWith(relationship: p0),
            selected: provider.relationship,
            icon: SvgPicture.asset(
              'assets/icons/carbon_friendship.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                context.colorExt.tertiary,
                BlendMode.srcIn,
              ),
            ),
          ),
          26.ph,
          const LabelText("What's your companion's personality type"),
          buildOptionTile<Personality>(
            context: context,
            ref: ref,
            title: "Personality",
            options: ref.watch(
              masterDataProvider.select((state) => state.personalities),
            ),
            optionToString: (c) => "${c.title} ${c.emoji}",
            showLoading: ref.watch(
              masterDataProvider.select((v) => v.isPersonalityLoading),
            ),
            emptyOptionHint:
                ref.read(characterCreationProvider).relationship != null
                    ? "No personality found for this relationship"
                    : "Choose a relationship to continue",
            onSelect:
                (p0) => ref
                    .read(characterCreationProvider.notifier)
                    .updateCRPBWith(personality: p0),
            selected: provider.personality,
            icon: SvgPicture.asset(
              'assets/icons/solar_mask-sad-linear.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                context.colorExt.tertiary,
                BlendMode.srcIn,
              ),
            ),
          ),
          26.ph,
          const LabelText("Which behaviour's match your companion"),
          buildOptionTile<Behaviour>(
            context: context,
            ref: ref,
            title: "Behaviours",
            options: ref.watch(
              masterDataProvider.select((state) => state.behaviours),
            ),
            optionToString: (c) => "${c.title.capitalize()} ${c.emoji}",
            showLoading: ref.watch(
              masterDataProvider.select((v) => v.isBehaviourLoading),
            ),
            emptyOptionHint:
                ref.read(characterCreationProvider).personality != null
                    ? "No Behaviour found for this personality"
                    : "Choose a personality to continue",
            onSelect: (p0) => {},
            onMultiSelect:
                (p0) => ref
                    .read(characterCreationProvider.notifier)
                    .updateCRPBWith(behaviours: p0),
            multiSelected: provider.behaviours,
            icon: SvgPicture.asset(
              'assets/icons/material-symbols_mindfulness-outline.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                context.colorExt.tertiary,
                BlendMode.srcIn,
              ),
            ),
            isMultiple: true,
            maxSelectToClose: 3,
          ),
          20.ph,
        ],
      ),
    );
  }
}
