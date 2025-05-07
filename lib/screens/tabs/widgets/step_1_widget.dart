import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../components/build_selector_button.dart';
import '../../../components/image_option_selector.dart';
import '../../../components/show_bottom_up.dart';
import '../../../providers/character_creation_provider.dart';

class Step1Widget extends ConsumerStatefulWidget {
  const Step1Widget({super.key});

  @override
  ConsumerState<Step1Widget> createState() => _Step1WidgetState();
}

class _Step1WidgetState extends ConsumerState<Step1Widget> {
  String? _selectedStyle;
  String? _selectedCountry;
  String? _selectedCity;
  String? _selectedLanguage;

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

  final List<String> _countries = ['USA', 'India', 'Japan', 'Germany'];
  final List<String> _cities = ['New York', 'Mumbai', 'Tokyo', 'Berlin'];
  final List<String> _languages = ['English', 'Hindi', 'Japanese', 'German'];

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(characterCreationProvider);
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Character Style',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFFA3A3A3),
            ),
          ),
          const SizedBox(height: 12),
          ImageOptionSelector(
            options: styleOptions,
            selected: provider.style ?? "",
            onChanged: (style) =>
                ref.read(characterCreationProvider.notifier).updateWith(style: style),
          ),
          const SizedBox(height: 48.0),
          BuildSelectorButton(
            label: "Companion's Country",
            selectedValue: _selectedCountry,
            onTap: () => _showSelectionBottomSheet(
              'Select Country',
              _countries,
                  (value) => setState(() => _selectedCountry = value),
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A3D),
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          const SizedBox(height: 40.0),
          BuildSelectorButton(
            label: "Companion's City",
            selectedValue: _selectedCity,
            onTap: () => _showSelectionBottomSheet(
              'Select City',
              _cities,
                  (value) => setState(() => _selectedCity = value),
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A3D),
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          const SizedBox(height: 40.0),
          BuildSelectorButton(
            label: "Language",
            selectedValue: _selectedLanguage,
            onTap: () => _showSelectionBottomSheet(
              'Select Language',
              _languages,
                  (value) => setState(() => _selectedLanguage = value),
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A3D),
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          const SizedBox(height: 32.0),
        ],
      ),
    );
  }

  Widget _buildStyleCard(String label, String imagePath, bool isSelected) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E2E),
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(
              color: isSelected ? Colors.blue : Colors.transparent,
              width: 2.0,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Container(
            height: 180,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _showSelectionBottomSheet(
      String title,
      List<String> options,
      ValueChanged<String> onSelected,
      ) {
    showBottomUp(
      context: context,
      title: title,
      content: _buildSelectionList(options, onSelected),
    );
  }

  Widget _buildSelectionList(List<String> options, ValueChanged<String> onSelected) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: options.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            options[index],
            style: const TextStyle(color: Colors.white),
          ),
          onTap: () {
            onSelected(options[index]);
            Navigator.of(context).pop();
          },
          contentPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
        );
      },
    );
  }
}