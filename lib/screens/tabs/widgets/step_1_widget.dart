import 'package:flutter/material.dart';

class Step1Widget extends StatefulWidget {
  const Step1Widget({super.key});

  @override
  State<Step1Widget> createState() => _Step1Widget();
}

class _Step1Widget extends State<Step1Widget> {
  String? _selectedStyle;
  String? _selectedCountry;
  String? _selectedCity;
  String? _selectedLanguage;

  final List<String> _countries = ['USA', 'India', 'Japan', 'Germany'];
  final List<String> _cities = ['New York', 'Mumbai', 'Tokyo', 'Berlin'];
  final List<String> _languages = ['English', 'Hindi', 'Japanese', 'German'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32.0),
                const Text(
                  'Character Style',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap:
                            () => setState(() => _selectedStyle = 'realistic'),
                        child: _buildStyleCard(
                          'Realistic',
                          'assets/images/model/realNew.jpg',
                          _selectedStyle == 'realistic',
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedStyle = 'anime'),
                        child: _buildStyleCard(
                          'Anime',
                          'assets/images/model/animeNew.jpg',
                          _selectedStyle == 'anime',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40.0),
                const Text(
                  'Companion\'s Country',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16.0),
                _buildSelectorButton(
                  _selectedCountry ?? 'Select',
                  () => _showSelectionDialog(
                    'Select Country',
                    _countries,
                    (value) => setState(() => _selectedCountry = value),
                  ),
                ),
                const SizedBox(height: 40.0),
                const Text(
                  'Companion\'s City',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16.0),
                _buildSelectorButton(
                  _selectedCity ?? 'Select',
                  () => _showSelectionDialog(
                    'Select City',
                    _cities,
                    (value) => setState(() => _selectedCity = value),
                  ),
                ),
                const SizedBox(height: 40.0),
                const Text(
                  'Language',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16.0),
                _buildSelectorButton(
                  _selectedLanguage ?? 'Select',
                  () => _showSelectionDialog(
                    'Select Language',
                    _languages,
                    (value) => setState(() => _selectedLanguage = value),
                  ),
                ),
                const SizedBox(height: 32.0),
              ],
            ),
          ),
        ),
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

  Widget _buildSelectorButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A3D),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(
                color: text == 'Select' ? Colors.grey : Colors.white,
                fontSize: 18,
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey, size: 24.0),
          ],
        ),
      ),
    );
  }

  void _showSelectionDialog(
    String title,
    List<String> options,
    ValueChanged<String> onSelected,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2A2A3D),
          title: Text(title, style: const TextStyle(color: Colors.white)),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
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
                );
              },
            ),
          ),
        );
      },
    );
  }
}
