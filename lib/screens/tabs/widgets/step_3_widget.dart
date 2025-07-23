import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:guftagu_mobile/components/label_text.dart';
import 'package:guftagu_mobile/providers/character_creation_provider.dart';
import 'package:guftagu_mobile/utils/app_constants.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:guftagu_mobile/utils/extensions.dart';
import 'package:guftagu_mobile/utils/file_compressor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class Step3Widget extends ConsumerStatefulWidget {
  const Step3Widget({super.key});

  @override
  ConsumerState<Step3Widget> createState() => _Step3WidgetState();
}

class _Step3WidgetState extends ConsumerState<Step3Widget> {
  final FocusNode _backstoryFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    _backstoryFocusNode.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _backstoryFocusNode.dispose();
    _descriptionFocusNode.dispose();
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
      var image = await compressImage(File(img.path));
      if (image != null) {
        // ref.read(characterCreationProvider.notifier).updateWith(uploadImage: img);
        ref
            .read(characterCreationProvider.notifier)
            .uploadImage(image: XFile(image.path));
        image = null;
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(characterCreationProvider);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Character Image with edit button
            Center(
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: context.colorExt.surface,
                          borderRadius: BorderRadius.circular(24),
                          // crash issue
                          image:
                              provider.refImageUrl.hasValue
                                  ? DecorationImage(
                                    image: NetworkImage(
                                      provider.refImageUrl ?? '',
                                    ),
                                    fit: BoxFit.cover,
                                    alignment: const Alignment(0, -0.5),
                                    colorFilter: ColorFilter.mode(
                                      // Colors.black.withValues(
                                      //   alpha:
                                      //       provider.refImageUrl.hasValue
                                      //           ? 0
                                      //           : 0.4,
                                      // ),
                                      Color.fromRGBO(
                                        0,
                                        0,
                                        0,
                                        provider.refImageUrl.hasValue
                                            ? 0.0
                                            : 0.4,
                                      ),
                                      BlendMode.darken,
                                    ),
                                  )
                                  : null,
                        ),
                        child:
                            provider.refImageUrl.hasValue
                                ? null
                                : Center(
                                  child:
                                      provider.isImageUploading
                                          ? CircularProgressIndicator(
                                            color: context.colorExt.secondary,
                                          )
                                          : const Icon(
                                            Icons.face,
                                            size: 83.25,
                                            color: Color(0xFF5B5B69),
                                          ),
                                ),
                      ),

                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: IconButton(
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
                          icon: SvgPicture.asset(
                            'assets/icons/solar_pen-2-bold.svg',
                            width: 26,
                            height: 26,
                          ),
                        ),
                      ),
                    ],
                  ),
                  16.ph,
                  Text(
                    context.l.referenceImage,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFA3A3A3),
                    ),
                  ),
                ],
              ),
            ),

            22.ph,
            LabelText(context.l.referenceImageDescrption),
            Container(
              // constraints: const BoxConstraints(minHeight: 144),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: context.colorExt.surface,
              ),
              child: Stack(
                children: [
                  TextField(
                    controller: provider.descriptionController,
                    focusNode: _descriptionFocusNode,
                    style: context.appTextStyle.text,
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: null,
                    minLines: 5,
                    decoration: InputDecoration(
                      hintStyle: context.appTextStyle.hintText.copyWith(
                        fontSize: 16,
                      ),
                      hintText: context.l.referenceImageDescrptionExample,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    right: 16,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child:
                          _descriptionFocusNode.hasFocus ||
                                  provider.descriptionController.text.isNotEmpty
                              ? null
                              : SizedBox(
                                height: 32,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    ref
                                        .read(
                                          characterCreationProvider.notifier,
                                        )
                                        .generateRandomPrompt();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: context.colorExt.sheet,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    elevation: 0,
                                  ),
                                  icon: ShaderMask(
                                    shaderCallback:
                                        (bounds) => const LinearGradient(
                                          colors: [
                                            Color(0xFFAD00FF),
                                            Color(0xFF00E0FF),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ).createShader(bounds),
                                    child: SvgPicture.asset(
                                      'assets/svgs/ic_chat_prefix.svg',
                                      width: 18,
                                      height: 18,
                                      colorFilter: const ColorFilter.mode(
                                        Colors.white,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                  label: Text(
                                    context.l.bRandomPrompt,
                                    style: context.appTextStyle.textSmall,
                                  ),
                                ),
                              ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child:
                          _descriptionFocusNode.hasFocus ||
                                  provider.descriptionController.text.isNotEmpty
                              ? null
                              : SvgPicture.asset(
                                'assets/icons/mingcute_quill-pen-line.svg',
                                width: 18,
                                height: 18,
                                colorFilter: ColorFilter.mode(
                                  context.colorExt.textPrimary,
                                  BlendMode.srcIn,
                                ),
                              ),
                    ),
                  ),
                ],
              ),
            ),

            22.ph,
            LabelText(context.l.referenceImageBackstory),
            Container(
              // constraints: const BoxConstraints(minHeight: 144),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: context.colorExt.surface,
              ),
              child: Stack(
                children: [
                  TextField(
                    controller: provider.backstoryController,
                    textCapitalization: TextCapitalization.sentences,
                    focusNode: _backstoryFocusNode,
                    style: context.appTextStyle.text,
                    maxLines: null,
                    minLines: 5,
                    decoration: InputDecoration(
                      hintStyle: context.appTextStyle.hintText.copyWith(
                        fontSize: 16,
                      ),
                      hintText: context.l.referenceImageBackstoryExample,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child:
                          _backstoryFocusNode.hasFocus ||
                                  provider.backstoryController.text.isNotEmpty
                              ? null
                              : SvgPicture.asset(
                                'assets/icons/mingcute_quill-pen-line.svg',
                                width: 18,
                                height: 18,
                                colorFilter: ColorFilter.mode(
                                  context.colorExt.textPrimary,
                                  BlendMode.srcIn,
                                ),
                              ),
                    ),
                  ),
                ],
              ),
            ),
            20.ph,
          ],
        ),
      ),
    );
  }
}
