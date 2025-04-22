import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:guftagu_mobile/models/master/master_models.dart';
import 'package:guftagu_mobile/providers/character_creation_provider.dart';
import 'package:guftagu_mobile/providers/master_data_provider.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:guftagu_mobile/utils/entensions.dart';

class Step2Widget extends ConsumerWidget {
  const Step2Widget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final maxContainerWidth = screenWidth * 0.9;
    final masterData = ref.read(masterDataProvider);
    final characterProvider = ref.watch(characterCreationProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Choose Character\'s',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFFF2F2F2),
            ),
          ),
          25.ph,
          Center(
            child: Container(
              width: maxContainerWidth,
              decoration: BoxDecoration(
                color: const Color(0xFF151519),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 18),
              child: Column(
                children: [
                  _buildOptionTile<Relationship>(
                    context,
                    'Relationship',
                    'assets/icons/carbon_friendship.svg',
                    maxContainerWidth,
                    masterData.relationships,
                    optionToString: (r) => r.title,
                    onSelect:
                        (p0) => ref
                            .read(characterCreationProvider.notifier)
                            .updateWith(relationship: p0),
                    selected: characterProvider.relationship,
                  ),
                  _buildOptionTile<Personality>(
                    context,
                    'Personality',
                    'assets/icons/solar_mask-sad-linear.svg',
                    maxContainerWidth,
                    masterData.personalities,
                    optionToString: (p) => p.title,
                    onSelect:
                        (p0) => ref
                            .read(characterCreationProvider.notifier)
                            .updateWith(personality: p0),
                    selected: characterProvider.personality,
                  ),
                  _buildOptionTile<Behaviour>(
                    context,
                    'Behaviour',
                    'assets/icons/token_mind.svg',
                    maxContainerWidth,
                    masterData.behaviours,
                    optionToString: (b) => b.title,
                    onSelect:
                        (p0) => ref
                            .read(characterCreationProvider.notifier)
                            .updateWith(behaviour: p0),
                    selected: characterProvider.behaviour,
                  ),
                  _buildOptionTile<Voice>(
                    context,
                    'Voice',
                    'assets/icons/ri_voice-ai-fill.svg',
                    maxContainerWidth,
                    masterData.voices,
                    optionToString: (v) => v.fullName,
                    onSelect:
                        (p0) => ref
                            .read(characterCreationProvider.notifier)
                            .updateWith(voice: p0),
                    selected: characterProvider.voice,
                  ),
                  _buildOptionTile<Country>(
                    context,
                    'Country',
                    'assets/icons/ci_flag.svg',
                    maxContainerWidth,
                    masterData.countries,
                    optionToString: (c) => c.countryName,
                    onSelect:
                        (p0) => ref
                            .read(characterCreationProvider.notifier)
                            .updateWith(country: p0),
                    selected: characterProvider.country,
                  ),
                  _buildOptionTile<City>(
                    context,
                    'City',
                    'assets/icons/mage_location.svg',
                    maxContainerWidth,
                    masterData.cities,
                    optionToString: (c) => c.cityName,
                    onSelect:
                        (p0) => ref
                            .read(characterCreationProvider.notifier)
                            .updateWith(city: p0),
                    selected: characterProvider.city,
                    isLast: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile<T>(
    BuildContext context,
    String title,
    String icon,
    double width,
    List<T> options, {
    required String Function(T) optionToString,
    bool isLast = false,
    T? selected,
    required Function(T) onSelect,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
      child: Container(
        width: width,
        // height: 56,
        decoration: BoxDecoration(
          color: const Color(0xFF23222F),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: SvgPicture.asset(icon),
          title: Text(title, style: context.appTextStyle.textSemibold),
          subtitle:
              selected != null
                  ? Text(
                    optionToString(selected),
                    style: context.appTextStyle.textSmall,
                  )
                  : null,
          trailing: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
            size: 16,
          ),
          onTap:
              () => _showOptionPopup<T>(
                context,
                title,
                options,
                optionToString: optionToString,
                onSelect: onSelect,
              ),
        ),
      ),
    );
  }

  void _showOptionPopup<T>(
    BuildContext context,
    String title,
    List<T> options, {
    required String Function(T) optionToString,
    required Function(T) onSelect,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        // final screenWidth = MediaQuery.of(context).size.width;
        const crossAxisCount = 2;
        // screenWidth < 400
        //     ? 2
        //     : screenWidth < 700
        //     ? 3
        //     : 4;

        return Container(
          height: 552,
          decoration: const BoxDecoration(
            color: Color(0xFF141416),
            borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 33,
                  vertical: 21,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Choose a $title",
                        style: const TextStyle(
                          color: Color(0xFFF2F2F2),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 33),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 2.5,
                        ),
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option = options[index];
                      return GestureDetector(
                        onTap: () {
                          // Handle selection here
                          onSelect(option);
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF23222F),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Center(
                            child: Text(
                              optionToString(option),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFFE5E5E5),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
