import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:guftagu_mobile/components/fade_network_placeholder_image.dart';
import 'package:guftagu_mobile/components/verification_section.dart';
import 'package:guftagu_mobile/providers/profile_settings_provider.dart';
import 'package:guftagu_mobile/screens/tabs/widgets/preference_picker.dart';
import 'package:guftagu_mobile/services/hive_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:permission_handler/permission_handler.dart';
import '../components/labeled_text_field.dart';
import 'package:guftagu_mobile/utils/entensions.dart';
import '../models/master/master_models.dart';
import '../providers/master_data_provider.dart';
import '../utils/app_constants.dart';
import '../utils/file_compressor.dart';

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
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getPermission(Permission permission) async {
    var checkStatus = await permission.status;

    if (checkStatus.isGranted) {
      return;
    } else {
      var status = await permission.request();
      if (status.isGranted) {
      } else if (status.isDenied) {
        getPermission(permission);
      } else {
        openAppSettings();
      }
    }
  }

  Future getImage(ImageSource media) async {
    if (media == ImageSource.camera) {
      await getPermission(Permission.camera);
    } else {
      await getPermission(Permission.photos);
    }

    var img = await picker.pickImage(source: media);
    if (img != null) {
      print(img.path);
      var image = await compressImage(File(img.path));
      if (image != null) {
        ref
            .read(profileSettingsProvider.notifier)
            .uploadProfileImage(XFile(image.path));
        image = null;
        setState(() {});
      }
    }
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
    final profileState = ref.watch(profileSettingsProvider);
    final profileNotifier = ref.read(profileSettingsProvider.notifier);
    final masterData = ref.watch(masterDataProvider);

    ref.listen<ProfileSettingsState>(profileSettingsProvider, (
      previous,
      current,
    ) {
      if (current.error != null && current.error != previous?.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${current.error}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: context.colorExt.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: primaryTextColor),
        title: Row(
          children: [
            SvgPicture.asset(Assets.svgs.logo, height: 50, width: 50),
            5.pw,
            const Text(
              'Guftagu',
              style: TextStyle(
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
                child:
                    profileState.isLoading
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              primaryTextColor,
                            ),
                          ),
                        )
                        : TextButton(
                          onPressed:
                              profileNotifier.hasUnsavedChanges()
                                  ? () async {
                                    final success =
                                        await profileNotifier.updateProfile();
                                    if (success && mounted) {
                                      AppConstants.showSnackbar(
                                        message:
                                            "   'Profile updated successfully!',",
                                        isSuccess: true,
                                      );
                                    }
                                  }
                                  : null,
                          child: Text(
                            'Save',
                            style: TextStyle(
                              color:
                                  profileNotifier.hasUnsavedChanges()
                                      ? primaryTextColor
                                      : secondaryTextColor,
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
                    ClipRRect(
                      borderRadius: BorderRadius.circular(70),
                      child: SizedBox(
                        height: 126,
                        width: 126,
                        child: NetworkImageWithPlaceholder(
                          imageUrl:
                              profileState.imageUrl ??
                              profileState
                                  .initialUserInfo!
                                  .profile
                                  .profilePicture,
                          placeholder: SvgPicture.asset(
                            Assets.svgs.icProfilePlaceholder,
                          ),
                          fit: BoxFit.cover,
                          errorWidget: SvgPicture.asset(
                            Assets.svgs.icProfilePlaceholder,
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: -10,
                      right: -25,
                      child: IconButton(
                        icon: SvgPicture.asset(
                          'assets/icons/solar_pen-2-bold.svg',
                          width: 30,
                          height: 30,
                        ),
                        onPressed: () {
                          AppConstants.getPickImageAlert(
                            context: context,
                            pressCamera: () {
                              getImage(ImageSource.camera);
                              Navigator.of(context).pop();
                            },
                            pressGallery: () {
                              getImage(ImageSource.gallery);
                              Navigator.of(context).pop();
                            },
                          );
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        splashRadius: 24,
                        tooltip: 'Change Profile Picture',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: LabeledTextField(
                  controller: profileState.nameController,
                  label: 'Name',
                  fillColor: inputBackgroundColor,
                  labelColor: primaryTextColor,
                  inputTextStyle: const TextStyle(color: primaryTextColor),
                  borderRadius: 12.0,
                ),
              ),
              // Age Dropdown
              _buildDatePickerField(
                label: 'Date Of Birth',
                selectedDate: profileState.dob,
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate:
                        profileState.dob ??
                        DateTime.now().subtract(const Duration(days: 20 * 365)),
                    firstDate: DateTime.now().subtract(
                      const Duration(days: 100 * 365),
                    ),
                    lastDate: DateTime.now(), // Today
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.dark(
                            primary: Colors.blueAccent,
                            onPrimary: Colors.white,
                            onSurface: Colors.white,
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.blueAccent,
                            ),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null && picked != profileState.dob) {
                    profileNotifier.setDob(picked);
                  }
                },
              ),
              _buildDropdownField(
                label: 'Gender',
                value: profileState.gender,
                items: profileState.genders,
                onChanged: (value) {
                  profileNotifier.setGender(value);
                },
              ),
              Text("Country", style: context.appTextStyle.characterGenLabel),
              16.ph,
              buildOptionTile<Country>(
                context: context,
                ref: ref,
                title: "Country",
                options: masterData.countries,
                optionToString: (c) => c.countryName,
                onSelect:
                    (p0) => profileNotifier.updateCountryCityWith(country: p0),
                selectedValue: profileState.country,
              ),
              16.ph,
              Text("City", style: context.appTextStyle.characterGenLabel),
              16.ph,
              Consumer(
                builder: (context, ref, child) {
                  final masterDataCities = ref.watch(
                    masterDataProvider.select((value) => value.cities),
                  );
                  final seletedCountryId = ref.watch(
                    profileSettingsProvider.select((value) => value.countryId),
                  );
                  final seletedCity = ref.watch(
                    profileSettingsProvider.select((value) => value.city),
                  );

                  final profileNotifierCity = ref.read(
                    profileSettingsProvider.notifier,
                  );

                  final filteredCities =
                      masterDataCities
                          .where((c) => c.countryId == seletedCountryId)
                          .toList();

                  return buildOptionTile<City>(
                    context: context,
                    ref: ref,
                    title: "City",
                    showLoading: masterData.isLoading,
                    options: filteredCities,
                    optionToString: (c) => c.cityName,
                    onSelect:
                        (p0) =>
                            profileNotifierCity.updateCountryCityWith(city: p0),
                    selectedValue: seletedCity,
                  );
                },
              ),

              16.ph,

              // VerificationSection(
              //   label: "Email",
              //   controller: profileState.emailController,
              //   otpController: profileState.otpController,
              //   keyboardType: TextInputType.emailAddress,
              //   isOtpSent: false,
              //   isVerified: false,
              //   isLoading: false,
              //   onSendOtp: () {},
              //   onVerifyOtp: (p0) {},
              //   hintText: "Enter your email",
              //   inputBackgroundColor: inputBackgroundColor,
              //   primaryTextColor: primaryTextColor,
              //   secondaryTextColor: secondaryTextColor,
              // ),
              //  VerificationSection(
              //   label: "Phone",
              //   controller: profileState.phoneController,
              //   otpController: profileState.otpController,
              //   keyboardType: TextInputType.emailAddress,
              //   isOtpSent: false,
              //   isVerified: false,
              //   isLoading: false,
              //   onSendOtp: () {},
              //   onVerifyOtp: (p0) {},
              //   hintText: "Enter your email",
              //   inputBackgroundColor: inputBackgroundColor,
              //   primaryTextColor: primaryTextColor,
              //   secondaryTextColor: secondaryTextColor,
              // ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: LabeledTextField(
                  controller: profileState.emailController,
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
                  controller: profileState.phoneController,
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
          Text(label, style: context.appTextStyle.characterGenLabel),
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
              style: TextStyle(
                color: secondaryTextColor.withValues(alpha: 0.5),
              ),
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
          Text(label, style: context.appTextStyle.characterGenLabel),
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
                  const Icon(Icons.calendar_today, color: iconColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
