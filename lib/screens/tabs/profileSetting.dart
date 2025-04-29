import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/providers/tab.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import '../../components/labeled_text_field.dart';
import 'package:guftagu_mobile/utils/entensions.dart'; // If .pw is here


const Color darkBackgroundColor = Color(0xFF0A0A0A);
const Color inputBackgroundColor = Color(0xFF23222F);
const Color primaryTextColor = Colors.white;
const Color secondaryTextColor = Colors.grey;
const Color iconColor = Colors.white;
const Gradient editIconGradient = LinearGradient(
  colors: [Colors.blueAccent, Colors.purpleAccent],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

// Helper class for Bottom Navigation Bar items
class BottomBarIconLabel {
  BottomBarIconLabel({required this.assetName, required this.label});
  String assetName;
  String label;
}

class ProfileSettingsPage extends ConsumerStatefulWidget {
  const ProfileSettingsPage({super.key});

  @override
  ConsumerState<ProfileSettingsPage> createState() =>
      _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends ConsumerState<ProfileSettingsPage> {
  String? _selectedAge;
  String? _selectedCountry;
  String? _selectedCity;
  // --- New State Variables ---
  String? _selectedGender;
  DateTime? _selectedDate;
  // --- End New State Variables ---

  // --- Dropdown Data ---
  final List<String> _ageRanges = ['18-24', '25-34', '35-44', '45+'];
  final List<String> _countries = ['India', 'USA', 'Canada', 'UK', 'Australia'];
  final Map<String, List<String>> _cities = {
    'India': ['Mumbai', 'Delhi', 'Bangalore', 'Imphal'],
    'USA': ['New York', 'Los Angeles', 'Chicago'],
    'Canada': ['Toronto', 'Vancouver', 'Montreal'],
    'UK': ['London', 'Manchester', 'Birmingham'],
    'Australia': ['Sydney', 'Melbourne', 'Brisbane'],
  };
  List<String> _currentCities = [];
  // --- New Gender Data ---
  final List<String> _genders = ['Male', 'Female', 'Other', 'Prefer not to say'];
  // --- End New Gender Data ---

  // --- Text Editing Controllers ---
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  // --- Bottom Bar Tab Data ---
  final List<BottomBarIconLabel> _tabWidgets = [
    BottomBarIconLabel(assetName: Assets.svgs.icChat, label: 'Chat'),
    BottomBarIconLabel(assetName: Assets.svgs.icCreate, label: 'Create'),
    BottomBarIconLabel(assetName: Assets.svgs.icMyAi, label: 'My AIs'),
    BottomBarIconLabel(assetName: Assets.svgs.icProfile, label: 'Profile'),
  ];

  @override
  void initState() {
    super.initState();
    _updateCities(_selectedCountry);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _updateCities(String? selectedCountry) {
    setState(() {
      _selectedCountry = selectedCountry;
      _currentCities = _cities[selectedCountry] ?? [];
      if (!_currentCities.contains(_selectedCity)) {
        _selectedCity = null;
      }
    });
  }

  // --- New Date Picker Logic ---
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        // Sensible initial date (e.g., 20 years ago)
        initialDate: _selectedDate ?? DateTime.now().subtract(const Duration(days: 365 * 20)),
        // Allow selection from 100 years ago up to today
        firstDate: DateTime.now().subtract(const Duration(days: 365 * 100)),
        lastDate: DateTime.now(), // User cannot select future date for birthday
        builder: (context, child) { // Optional: Theme the date picker
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.dark( // Example dark theme
                primary: Colors.blueAccent, // header background color
                onPrimary: Colors.white, // header text color
                onSurface: Colors.white, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blueAccent, // button text color
                ),
              ),
            ),
            child: child!,
          );
        }
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
  // --- End New Date Picker Logic ---


  InputDecoration _buildInputDecoration() {
    // (logic kept as is)
    return InputDecoration(
      filled: true,
      fillColor: inputBackgroundColor,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 15.0,
        horizontal: 15.0,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide.none,
      ),
      hintStyle: TextStyle(color: secondaryTextColor.withOpacity(0.5)),
      suffixIconColor: iconColor, // Ensure suffix icons are visible
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: primaryTextColor),
        title: Row(
          children: [
            SvgPicture.asset(Assets.svgs.logo, height: 50, width: 50),
            5.pw,
            Text(
              'Guftagu',
              style: const TextStyle(
                color: primaryTextColor,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
          ],
        ),
        // Save button moved below
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Align( // Save Button
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    print('Save button pressed');
                    print('Name: ${_nameController.text}');
                    print('Age: $_selectedDate');
                    print('Gender: $_selectedGender');
                    print('Country: $_selectedCountry');
                    print('City: $_selectedCity');
                    print('Email: ${_emailController.text}');
                    print('Phone: ${_phoneController.text}');
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      color: primaryTextColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center( // Profile Picture
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage('assets/images/model/ayushImg.jpg'),
                    ),
                    Positioned(
                      bottom: -10,
                      right: -30,
                      child: Container(
                        child: IconButton(
                          icon: SvgPicture.asset(
                            'assets/icons/solar_pen-2-bold.svg', // Your icon path
                            width: 30,
                            height: 30,
                          ),
                          onPressed: () {
                            print('Edit profile picture');
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          splashRadius: 24,
                          tooltip: 'Change Profile Picture',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // --- Form Fields ---
              // Name
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: LabeledTextField(
                  controller: _nameController,
                  label: 'Name',
                  fillColor: inputBackgroundColor,
                  labelColor: primaryTextColor,
                  inputTextStyle: const TextStyle(color: primaryTextColor),
                  borderRadius: 12.0,
                ),
              ),
              // Age Dropdown
              _buildDatePickerField( // Using helper method
                label: 'Age',
                selectedDate: _selectedDate,
                onTap: () => _selectDate(context),
              ),
              // Gender Dropdown (NEW)
              _buildDropdownField(
                label: 'Gender',
                value: _selectedGender,
                items: _genders,
                onChanged: (value) {
                  setState(() { _selectedGender = value; });
                },
              ),
              // Country Dropdown
              _buildDropdownField(
                label: 'Country',
                value: _selectedCountry,
                items: _countries,
                onChanged: _updateCities,
              ),
              // City Dropdown
              _buildDropdownField(
                label: 'City',
                value: _selectedCity,
                items: _currentCities,
                onChanged:
                (_selectedCountry == null || _currentCities.isEmpty)
                    ? null
                    : (value) { setState(() { _selectedCity = value; }); },
                hintText: _selectedCountry == null ? 'Select Country First' : 'Select City',
              ),
              // Email
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: LabeledTextField(
                  controller: _emailController,
                  label: 'Email ID',
                  keyboardType: TextInputType.emailAddress,
                  fillColor: inputBackgroundColor,
                  labelColor: primaryTextColor,
                  inputTextStyle: const TextStyle(color: primaryTextColor),
                  borderRadius: 12.0,
                ),
              ),
              // Phone
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: LabeledTextField(
                  controller: _phoneController,
                  label: 'Phone number',
                  keyboardType: TextInputType.phone,
                  fillColor: inputBackgroundColor,
                  labelColor: primaryTextColor,
                  inputTextStyle: const TextStyle(color: primaryTextColor),
                  borderRadius: 12.0,
                ),
              ),

              const SizedBox(height: 20), // Bottom padding inside Column
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar( // Kept as is
        type: BottomNavigationBarType.fixed,
        currentIndex: 3,
        backgroundColor: const Color(0xFF171717),
        selectedItemColor: context.colorExt.textPrimary,
        showUnselectedLabels: true,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 3) return;
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
          ref.read(tabIndexProvider.notifier).changeTab(index);
        },
        items:
        _tabWidgets
            .map(
              (BottomBarIconLabel iconLabel) => BottomNavigationBarItem(
            activeIcon: SvgPicture.asset(
              iconLabel.assetName,
              height: 18, width: 18,
              colorFilter: ColorFilter.mode(
                context.colorExt.textPrimary, BlendMode.srcIn,
              ),
            ),
            icon: SvgPicture.asset(
              iconLabel.assetName,
              height: 18, width: 18,
              colorFilter: ColorFilter.mode(
                context.colorExt.textPrimary.withOpacity(0.6), BlendMode.srcIn,
              ),
            ),
            label: iconLabel.label,
          ),
        )
            .toList(),
      ),
    );
  }

  // Helper for Dropdowns (Unchanged)
  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?>? onChanged,
    String? hintText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: primaryTextColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: value,
            items:
            items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text( item, style: const TextStyle(color: primaryTextColor)),
              );
            }).toList(),
            onChanged: onChanged,
            decoration: _buildInputDecoration().copyWith(
              hintText: hintText ?? 'Select $label',
            ),
            dropdownColor: inputBackgroundColor,
            iconEnabledColor: iconColor,
            style: const TextStyle(color: primaryTextColor),
            isExpanded: true,
            disabledHint: Text(
              hintText ?? 'Select $label',
              style: TextStyle(color: secondaryTextColor.withOpacity(0.5)),
            ),
          ),
        ],
      ),
    );
  }

  // --- New Helper Widget for Date Picker Field ---
  Widget _buildDatePickerField({
    required String label,
    required DateTime? selectedDate,
    required VoidCallback onTap,
  }) {
    // Format the date, handle null
    final String displayDate = selectedDate == null
        ? 'Select Age'
    // Using intl package for formatting - ensure imported
        : DateFormat('dd MMM yyyy').format(selectedDate);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: primaryTextColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          InkWell( // Makes the whole area tappable
            onTap: onTap,
            child: InputDecorator( // Provides the input field look
              decoration: _buildInputDecoration().copyWith(
                hintText: 'Select Birthday', // Hint if needed
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    displayDate,
                    style: TextStyle(
                      color: selectedDate == null
                          ? secondaryTextColor.withOpacity(0.5) // Hint color
                          : primaryTextColor, // Selected date color
                    ),
                  ),
                  const Icon(
                    Icons.calendar_today,
                    color: iconColor, // Use defined icon color
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
