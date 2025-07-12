import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:guftagu_mobile/components/datepicker_field.dart';
import 'package:guftagu_mobile/components/dropdown_field.dart';
import 'package:guftagu_mobile/components/fade_network_placeholder_image.dart';
import 'package:guftagu_mobile/components/verification_section.dart';
import 'package:guftagu_mobile/providers/user_profile_provider.dart';
import 'package:guftagu_mobile/screens/tabs/widgets/preference_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:permission_handler/permission_handler.dart';
import '../components/labeled_text_field.dart';
import 'package:guftagu_mobile/utils/extensions.dart';
import '../models/master/master_models.dart';
import '../providers/master_data_provider.dart';
import '../utils/app_constants.dart';
import '../utils/file_compressor.dart';

class UserProfileScreen extends ConsumerWidget {
  UserProfileScreen({super.key});

  final ImagePicker picker = ImagePicker();

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

  Future getImage(ImageSource media, WidgetRef ref) async {
    if (media == ImageSource.camera) {
      await getPermission(Permission.camera);
    } else {
      await getPermission(Permission.photos);
    }

    var img = await picker.pickImage(source: media);
    if (img != null) {
      var image = await compressImage(File(img.path));
      if (image != null) {
        ref
            .read(userProfileProvider.notifier)
            .uploadProfileImage(XFile(image.path));
        image = null;
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(userProfileProvider);
    final profileNotifier = ref.read(userProfileProvider.notifier);
    final masterData = ref.watch(masterDataProvider);

    ref.listen<UserProfileState>(userProfileProvider, (previous, current) {
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
        title: Row(
          children: [
            SvgPicture.asset(Assets.svgs.logo, height: 50, width: 50),
            5.pw,
            const Text(
              'Guftagu',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
          ],
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  10.ph,
                  Align(
                    alignment: Alignment.centerRight,
                    child:
                        profileState.isLoading
                            ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  context.colorExt.primary,
                                ),
                              ),
                            )
                            : Consumer(
                              builder: (context, ref, child) {
                                bool hasChanges = ref.watch(
                                  hasUnsavedChangesProvider,
                                );
                                return TextButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        hasChanges
                                            ? WidgetStateProperty.all(
                                              context.colorExt.surface,
                                            )
                                            : null,
                                  ),
                                  onPressed:
                                      hasChanges
                                          ? () async {
                                            final success =
                                                await profileNotifier
                                                    .updateProfile();
                                            if (success) {
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
                                    style: context.appTextStyle.text.copyWith(
                                      color:
                                          hasChanges
                                              ? context.colorExt.textPrimary
                                              : context.colorExt.textHint,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                );
                              },
                            ),
                  ),
                  10.ph,
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
                                      .profilePicture ??
                                  "",
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
                          bottom: 0,
                          right: 0,
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
                                  getImage(ImageSource.camera, ref);
                                  Navigator.of(context).pop();
                                },
                                pressGallery: () {
                                  getImage(ImageSource.gallery, ref);
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
                  40.ph,

                  LabeledTextField(
                    controller: profileState.nameController,
                    label: 'Name',
                    hintText: "Name",
                  ),
                  26.ph,
                  // Age Dropdown
                  DatePickerField(
                    label: 'Date Of Birth',
                    selectedDate: profileState.dob,
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate:
                            profileState.dob ??
                            DateTime.now().subtract(
                              const Duration(days: 20 * 365),
                            ),
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
                  DropdownField(
                    label: 'Gender',
                    value: profileState.gender,
                    items: profileState.genders,
                    onChanged: (value) {
                      profileNotifier.setGender(value);
                    },
                    inputDecoration: AppConstants.inputDecoration(context),
                  ),
                  26.ph,
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
                        (p0) =>
                            profileNotifier.updateCountryCityWith(country: p0),
                    selectedValue: profileState.country?.countryName,
                  ),
                  26.ph,
                  Text("City", style: context.appTextStyle.characterGenLabel),
                  16.ph,
                  Consumer(
                    builder: (context, ref, child) {
                      final masterDataCities = ref.watch(
                        masterDataProvider.select((value) => value.cities),
                      );
                      final seletedCity = ref.watch(
                        userProfileProvider.select((value) => value.city),
                      );

                      final profileNotifierCity = ref.read(
                        userProfileProvider.notifier,
                      );

                      return buildOptionTile<City>(
                        context: context,
                        ref: ref,
                        title: "City",
                        showLoading: masterData.isLoading,
                        options: masterDataCities,
                        optionToString: (c) => c.cityName,
                        onSelect:
                            (p0) => profileNotifierCity.updateCountryCityWith(
                              city: p0,
                            ),
                        selectedValue: seletedCity?.cityName,
                      );
                    },
                  ),

                  26.ph,

                  VerificationSection(
                    label: "Email",
                    controller: profileState.emailController,
                    otpController: profileState.emailOtpController,
                    keyboardType: TextInputType.emailAddress,
                    showButton: ref.watch(hasEmailChangedProvider),
                    isOtpSent: profileState.isEmailOtpSent,
                    isVerified: profileState.isEmailVerified,
                    isLoading: profileState.isEmailLoading,
                    onSendOtp: () => profileNotifier.sendOtp(true),
                    onVerifyOtp: (otp) => profileNotifier.verifyOtp(true, otp),
                    hintText: "Enter your email",
                  ),
                  VerificationSection(
                    label: "Phone",
                    controller: profileState.phoneController,
                    otpController: profileState.phoneOtpController,
                    keyboardType: TextInputType.phone,
                    showButton: ref.watch(hasPhoneChangedProvider),
                    isOtpSent: profileState.isPhoneOtpSent,
                    isVerified: profileState.isPhoneVerified,
                    isLoading: profileState.isPhoneLoading,
                    onSendOtp: () => profileNotifier.sendOtp(false),
                    onVerifyOtp: (otp) => profileNotifier.verifyOtp(false, otp),
                    hintText: "Enter your phone",
                    prefixText: "+91",
                    maxLength: 10,
                  ),

                  // Padding(
                  //   padding: const EdgeInsets.only(bottom: 20.0),
                  //   child: LabeledTextField(
                  //     controller: profileState.emailController,
                  //     label: 'Email ID',
                  //     keyboardType: TextInputType.emailAddress,
                  //     fillColor: inputBackgroundColor,
                  //     labelColor: primaryTextColor,
                  //     borderRadius: 12.0,
                  //   ),
                  // ),
                  // // Phone
                  // Padding(
                  //   padding: const EdgeInsets.only(bottom: 20.0),
                  //   child: LabeledTextField(
                  //     controller: profileState.phoneController,
                  //     label: 'Phone number',
                  //     hintText: "",
                  //     keyboardType: TextInputType.phone,
                  //     fillColor: inputBackgroundColor,
                  //     labelColor: primaryTextColor,
                  //     borderRadius: 12.0,
                  //   ),
                  // ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
