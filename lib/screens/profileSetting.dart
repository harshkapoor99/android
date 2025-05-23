import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:guftagu_mobile/screens/tabs/widgets/preference_picker.dart';
import 'package:intl/intl.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/providers/tab.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import '../components/labeled_text_field.dart';
import 'package:guftagu_mobile/utils/entensions.dart';
import '../models/master/master_models.dart';
import '../models/user_model.dart';
import '../providers/character_creation_provider.dart';
import '../providers/master_data_provider.dart';
import '../services/hive_service.dart';

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
  bool _isSaving = false;
  DateTime? _selectedDate;
  User? _userInfo;
  String? _selectedGender;

  final List<String> _genders = [
    'Male',
    'Female',
    'Other',
    'Prefer not to say',
  ];

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final List<BottomBarIconLabel> _tabWidgets = [
    BottomBarIconLabel(assetName: Assets.svgs.icChat, label: 'Chat'),
    BottomBarIconLabel(assetName: Assets.svgs.icCreate, label: 'Create'),
    BottomBarIconLabel(assetName: Assets.svgs.icMyAi, label: 'My AIs'),
    BottomBarIconLabel(assetName: Assets.svgs.icProfile, label: 'Profile'),
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    _userInfo = ref.read(hiveServiceProvider.notifier).getUserInfo();

    if (_userInfo != null) {
      _nameController.text = _userInfo?.profile.fullName ?? '';
      _emailController.text = _userInfo!.email.hasValue ? _userInfo!.email : "N/A";
      _phoneController.text = _userInfo!.mobileNumber.hasValue ? _userInfo!.mobileNumber : "N/A";

      // Set gender if available
      if (_userInfo!.profile.gender != null && _userInfo!.profile.gender!.isNotEmpty) {
        _selectedGender = _userInfo!.profile.gender;
      }

      // Set date of birth if available
      if (_userInfo!.profile.dateOfBirth != null && _userInfo!.profile.dateOfBirth!.isNotEmpty) {
        try {
          _selectedDate = DateTime.parse(_userInfo!.profile.dateOfBirth!);
        } catch (e) {
          _selectedDate = null;
        }
      }

      _loadLocationData();
    }
  }

  void _loadLocationData() {
    if (_userInfo?.profile.country != null || _userInfo?.profile.city != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final masterData = ref.read(masterDataProvider);

        if (_userInfo!.profile.country != null && _userInfo!.profile.country!.isNotEmpty) {
          final country = masterData.countries.where((c) =>
          c.countryName.toLowerCase() == _userInfo!.profile.country!.toLowerCase()
          ).firstOrNull;

          if (country != null) {
            ref.read(characterCreationProvider.notifier).updateCountryCityWith(country: country);

            if (_userInfo!.profile.city != null && _userInfo!.profile.city!.isNotEmpty) {
              final city = masterData.cities.where((c) =>
              c.cityName.toLowerCase() == _userInfo!.profile.city!.toLowerCase() &&
                  c.countryId == country.id
              ).firstOrNull;

              if (city != null) {
                ref.read(characterCreationProvider.notifier).updateCountryCityWith(city: city);
              }
            }
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      // Sensible initial date (e.g., 20 years ago)
      initialDate:
          _selectedDate ??
          DateTime.now().subtract(const Duration(days: 365 * 20)),
      // Allow selection from 100 years ago up to today
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 100)),
      lastDate: DateTime.now(), // User cannot select future date for birthday
      builder: (context, child) {
        // Optional: Theme the date picker
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              // Example dark theme
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
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveProfileData() async {
    if (_userInfo == null) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final provider = ref.read(characterCreationProvider);

      ref.read(hiveServiceProvider.notifier).updateUserInfo(
        username: _userInfo!.username,
        email: _emailController.text.trim() != "N/A" ? _emailController.text.trim() : _userInfo!.email,
        mobileNumber: _phoneController.text.trim() != "N/A" ? _phoneController.text.trim() : _userInfo!.mobileNumber,
        fullName: _nameController.text.trim(),
        gender: _selectedGender,
        dateOfBirth: _selectedDate?.toIso8601String(),
        country: provider.country?.countryName,
        city: provider.city?.cityName,
        profilePicture: _userInfo!.profile.profilePicture,
        bio: _userInfo!.profile.bio,
        timezone: _userInfo!.profile.timezone,
        status: _userInfo!.status,
      );

      _userInfo = ref.read(hiveServiceProvider.notifier).getUserInfo();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save profile: $error'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  bool _hasUnsavedChanges() {
    if (_userInfo == null) return false;

    final provider = ref.read(characterCreationProvider);

    return _nameController.text.trim() != (_userInfo!.profile.fullName ?? '') ||
        _selectedGender != _userInfo!.profile.gender ||
        _emailController.text.trim() != "N/A" && _emailController.text.trim() != _userInfo!.email ||
        _phoneController.text.trim() != "N/A" && _phoneController.text.trim() != _userInfo!.mobileNumber ||
        provider.country?.countryName != _userInfo!.profile.country ||
        provider.city?.cityName != _userInfo!.profile.city;
  }

  InputDecoration _buildInputDecoration() {
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
      suffixIconColor: iconColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(characterCreationProvider);
    final masterData = ref.watch(masterDataProvider);
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: _isSaving
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(primaryTextColor),
                  ),
                )
                    : TextButton(
                  onPressed: _hasUnsavedChanges() ? _saveProfileData : null,
                  child: Text(
                    'Save',
                    style: TextStyle(
                      color: _hasUnsavedChanges() ? primaryTextColor : secondaryTextColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                // Profile Picture
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage(
                        'assets/images/model/ayushImg.jpg',
                      ),
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
              _buildDatePickerField(
                label: 'Age',
                selectedDate: _selectedDate,
                onTap: () => _selectDate(context),
              ),
              _buildDropdownField(
                label: 'Gender',
                value: _selectedGender,
                items: _genders,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
              ),
              Text(
                "Country",
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
                    .updateCountryCityWith(country: p0),
                selected: provider.country,
              ),
              16.ph,
              Text(
                "City",
                style: context.appTextStyle.characterGenLabel,
              ),
              16.ph,
              Consumer(
                builder: (context, ref, child) {
                  final masterData = ref.watch(masterDataProvider);
                  return buildOptionTile<City>(
                    context: context,
                    ref: ref,
                    title: "City",
                    showLoading: masterData.isLoading,
                    options:
                    masterData.cities
                        .where(
                          (c) =>
                      c.countryId ==
                          ref.read(characterCreationProvider).country?.id,
                    )
                        .toList(),
                    optionToString: (c) => c.cityName,
                    onSelect:
                        (p0) => ref
                        .read(characterCreationProvider.notifier)
                        .updateCountryCityWith(city: p0),
                    selected: provider.city,
                  );
                },
              ),

              16.ph,

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

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
                      height: 18,
                      width: 18,
                      colorFilter: ColorFilter.mode(
                        context.colorExt.textPrimary,
                        BlendMode.srcIn,
                      ),
                    ),
                    icon: SvgPicture.asset(
                      iconLabel.assetName,
                      height: 18,
                      width: 18,
                      colorFilter: ColorFilter.mode(
                        context.colorExt.textPrimary.withOpacity(0.6),
                        BlendMode.srcIn,
                      ),
                    ),
                    label: iconLabel.label,
                  ),
                )
                .toList(),
      ),
    );
  }

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
            style: context.appTextStyle.characterGenLabel,
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
            value: value,
            items:
            items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: context.appTextStyle.characterGenLabel,
                ),
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

  Widget _buildDatePickerField({
    required String label,
    required DateTime? selectedDate,
    required VoidCallback onTap,
  }) {
    final String displayDate =
        selectedDate == null
            ? 'Select Age'
            : DateFormat('dd MMM yyyy').format(selectedDate);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.appTextStyle.characterGenLabel,
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: onTap,
            child: InputDecorator(
              decoration: _buildInputDecoration().copyWith(
                hintText: 'Select Birthday',
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    displayDate,
                    style: context.appTextStyle.characterGenLabel,
                  ),
                  const Icon(
                    Icons.calendar_today,
                    color: iconColor,
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
