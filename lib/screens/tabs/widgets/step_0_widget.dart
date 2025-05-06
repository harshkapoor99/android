import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:guftagu_mobile/providers/character_creation_provider.dart';

class Step0Widget extends ConsumerWidget {
  Step0Widget({super.key});

  // Define options for sexual orientation
  final List<String> sexualOrientationOptions = ['Straight', 'Gay', 'Lesbian'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(characterCreationProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          color: Colors.black,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Character Name Field
              const Text(
                'Character Name',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFFF2F2F2),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1F1F2C),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: provider.characterNameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    hintText: 'Type',
                    hintStyle: TextStyle(color: Color(0xFF969696)),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Age Field
              const Text(
                'Age ( yrs )',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFFF2F2F2),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1F1F2C),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: TextEditingController(),
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    hintText: 'Type Eg. 26',
                    hintStyle: TextStyle(color: Color(0xFF969696)),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Gender Selection
              const Text(
                'Gender',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildGenderOption(
                    context,
                    label: 'Female',
                    iconData: Icons.female,
                    isSelected: provider.gender == 'female',
                    onTap:
                        () => ref
                        .read(characterCreationProvider.notifier)
                        .updateWith(gender: 'female'),
                    screenWidth: screenWidth,
                  ),
                  _buildGenderOption(
                    context,
                    label: 'Male',
                    iconData: Icons.male,
                    isSelected: provider.gender == 'male',
                    onTap:
                        () => ref
                        .read(characterCreationProvider.notifier)
                        .updateWith(gender: 'male'),
                    screenWidth: screenWidth,
                  ),
                  _buildGenderOption(
                    context,
                    label: 'Others',
                    iconData: Icons.transgender,
                    isSelected: provider.gender == 'others',
                    onTap:
                        () => ref
                        .read(characterCreationProvider.notifier)
                        .updateWith(gender: 'others'),
                    screenWidth: screenWidth,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Sexual Orientation Selection
              const Text(
                'Sexual Orientation',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFFF2F2F2),
                ),
              ),
              const SizedBox(height: 16),
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
              const SizedBox(height: 24),

              // Companion's Voice selection
              const Text(
                "Companion's Voice",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFFF2F2F2),
                ),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () {
                  // TODO: Implement voice selection logic
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1F1F2C),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Select', style: TextStyle(color: Colors.grey)),
                      Icon(Icons.chevron_right, color: Colors.white),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGenderIcon(String label) {
    String? svgPath;

    if (label == 'Female') {
      svgPath = 'assets/icons/female.svg';
    } else if (label == 'Male') {
      svgPath = 'assets/icons/male.svg';
    } else if (label == 'Others') {
      svgPath = 'assets/icons/lesbo.svg';
    } else {
      return const Icon(Icons.transgender, color: Colors.white, size: 16);
    }

    if (svgPath != null) {
      return SvgPicture.asset(
        svgPath,
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        height: 16,
        width: 16,
      );
    } else {
      return const SizedBox.shrink(); // Or some other fallback widget
    }
  }

  Widget _buildGenderOption(
      BuildContext context, {
        required String label,
        required IconData iconData,
        required bool isSelected,
        required VoidCallback onTap,
        required double screenWidth,
      }) {
    // Calculate width to make 3 items fit with small gap
    final itemWidth = (screenWidth - 72) / 3;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: itemWidth,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            // Image container
            Container(
              width: itemWidth,
              height: itemWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFF1F1F2C),
                border:
                isSelected
                    ? Border.all(color: Colors.deepPurpleAccent, width: 2)
                    : null,
              ),
              // Use image assets based on gender selection
              child:
              label == 'Female'
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/images/model/femaleNew.jpg',
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter.add(const Alignment(0.0, 0.2)), // Adjust the 0.2 value
                ),
              )
                  : label == 'Male'
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/images/model/maleNew.jpg',
                  fit: BoxFit.cover,
                ),
              )
                  : ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/images/model/lesboNew.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Gender label with icon
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildGenderIcon(label), // Use the function to display the SVG or fallback icon
                const SizedBox(width: 4),
                Text(
                  label,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}