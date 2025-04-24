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

          onTap: () {

// Use specialized popup for Voice type

            if (T.toString() == 'Voice') {

              _showVoiceOptionPopup(

                context,

                title,

                options as List<Voice>,

                optionToString: optionToString as String Function(Voice),

                onSelect: onSelect as Function(Voice),

                selected: selected as Voice?,

              );

            } else {

// Use regular popup for other types

              _showOptionPopup<T>(

                context,

                title,

                options,

                optionToString: optionToString,

                onSelect: onSelect,

              );

            }

          },

        ),

      ),

    );

  }



//voice pop up

  void _showVoiceOptionPopup(

      BuildContext context,

      String title,

      List<Voice> options, {

        required String Function(Voice) optionToString,

        required Function(Voice) onSelect,

        Voice? selected,

      }) {

    showModalBottomSheet(

      context: context,

      backgroundColor: Colors.transparent,

      builder: (context) {

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

                        "Choose from here",

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

                child: ListView.builder(

                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

                  itemCount: options.length,

                  itemBuilder: (context, index) {

                    final option = options[index];

                    final isSelected = selected == option;



                    return Container(

                      margin: const EdgeInsets.only(bottom: 10),

                      decoration: BoxDecoration(

                        color: const Color(0xFF23222F),

                        borderRadius: BorderRadius.circular(10),

                        border: isSelected ?

                        Border.all(color: Color(0xFF5C67FF), width: 1) : null,

                      ),

                      child: ListTile(

                        leading: Container(

                          width: 40,

                          height: 40,

                          decoration: const BoxDecoration(

                            color: Color(0xFFA099FF),

                            shape: BoxShape.circle,

                          ),

                          child: Center(

                            child: Icon(

                              isSelected ? Icons.pause : Icons.play_arrow,

                              color: Color(0xFF16151E),

                            ),

                          ),

                        ),

                        title: Text(

                          optionToString(option),

                          style: const TextStyle(

                            color: Colors.white,

                            fontSize: 16,

                            fontWeight: FontWeight.w500,

                          ),

                        ),

                          trailing: Row(
                            mainAxisSize: MainAxisSize.min, // Important to keep the Row compact
                            children: [
                              // This part only appears if isSelected is true
                              if (isSelected)
                                Container(
                                  // This margin controls the space AFTER the SVG container
                                  // and BEFORE the next widget in the Row (the arrow container).
                                  margin: const EdgeInsets.only(right: 84),

                                  // The SvgPicture itself
                                  child: SvgPicture.asset(
                                      'assets/svgs/waves.svg',
                                      colorFilter: ColorFilter.mode(
                                        Color(0xFF9D93FF), // Your desired color
                                        BlendMode.srcIn,    // Blend mode for tinting
                                      ),
                                      // Use the size you specified previously for the SVG
                                      width: 26,
                                      height: 26,
                                      semanticsLabel: 'Waves icon' // Optional: for accessibility
                                  ),
                                ),

                              // The black container with the arrow icon remains the same
                              Container(
                                width: 40,  // The container size remains 40x40
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.black, // Background color remains black
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                // Replace the Icon child with SvgPicture.asset
                                child: Center( // Use Center to position the potentially smaller SVG within the container
                                  child: SvgPicture.asset(
                                    'assets/svgs/clarity_arrow-line.svg', // <-- Path to your clarity SVG. Verify this path is correct!
                                    // Apply the white color like the original Icon
                                    colorFilter: ColorFilter.mode(
                                      Colors.white,
                                      BlendMode.srcIn,
                                    ),
                                    // Set the desired size for the SVG, similar to the original Icon's size
                                    width: 20,
                                    height: 20,
                                    semanticsLabel: 'Arrow icon', // Or 'Arrow icon' if it represents that
                                  ),
                                ),
                              ),
                            ],
                          ),

                        onTap: () {

                          onSelect(option);

                          Navigator.pop(context);

                        },

                      ),

                    );

                  },

                ),

              ),

            ],

          ),

        );

      },

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

        final screenWidth = MediaQuery.of(context).size.width;

        final crossAxisCount =

        screenWidth < 400

            ? 2

            : screenWidth < 700

            ? 3

            : 4;



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

                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(

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