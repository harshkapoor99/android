import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:guftagu_mobile/utils/file_type_from_mime.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';

class MessageBox extends StatefulWidget {
  const MessageBox({
    super.key,
    required this.controller,
    required this.recordingController,
    this.focusNodes,
    required this.hasMessage,
    required this.isRecordig,
    this.isImage = false,
    this.onStarPressed,
    this.onPlusPressed,
    this.attachedFile,
    this.onFileRemovePressed,
  });

  final bool hasMessage, isRecordig, isImage;
  final FocusNode? focusNodes;
  final TextEditingController controller;
  final RecorderController recordingController;
  final VoidCallback? onStarPressed;
  final VoidCallback? onPlusPressed;
  final File? attachedFile;
  final VoidCallback? onFileRemovePressed;

  @override
  State<MessageBox> createState() => _MessageBoxState();
}

class _MessageBoxState extends State<MessageBox> {
  bool isFocused = false;

  @override
  void didUpdateWidget(covariant MessageBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRecordig != oldWidget.isRecordig && widget.isRecordig) {
      setState(() {
        isFocused = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (value) {
        setState(() {
          isFocused = value;
        });
      },
      child: AnimatedContainer(
        duration: Durations.short2,
        padding: const EdgeInsets.only(left: 12),
        constraints: const BoxConstraints(minHeight: 52),
        decoration: BoxDecoration(
          color: context.colorExt.surface,
          borderRadius: BorderRadius.circular(
            widget.hasMessage || isFocused ? 10 : 30,
          ),
          border: Border.all(
            color:
                isFocused ? context.colorExt.primary : context.colorExt.surface,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            if (widget.attachedFile != null)
              Container(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    widget.isImage
                        ? const Icon(Icons.image, size: 30)
                        : const Icon(Icons.file_present_rounded, size: 30),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            basename(widget.attachedFile!.path),
                            style: context.appTextStyle.textSmall,
                          ),
                          Text(
                            getFileTypeFromMime(
                              lookupMimeType(widget.attachedFile!.path),
                            ),
                            style: context.appTextStyle.textSmall.copyWith(
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: widget.onFileRemovePressed,
                    ),
                  ],
                ),
              ),
            AnimatedSwitcher(
              duration: Durations.long2,
              child:
                  widget.isRecordig
                      ? Center(
                        child: AudioWaveforms(
                          size: const Size(double.infinity, 40),
                          recorderController: widget.recordingController,
                          waveStyle: const WaveStyle(
                            waveColor: Colors.white,
                            extendWaveform: true,
                            showMiddleLine: false,
                          ),
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                        ),
                      )
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 16,
                            width: 16,
                            alignment: Alignment.center,
                            child: SvgPicture.asset(
                              Assets.svgs.icChatPrefix,
                              height: 16,
                              width: 16,
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              textCapitalization: TextCapitalization.sentences,
                              controller: widget.controller,
                              keyboardType: TextInputType.multiline,
                              minLines: 1,
                              maxLines: 5,
                              focusNode: widget.focusNodes,
                              style: context.appTextStyle.text,
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(
                                  top: 5,
                                  bottom: 5,
                                  left: 8,
                                ),

                                hintText: "Chat here",
                                hintStyle: context.appTextStyle.textSmall
                                    .copyWith(
                                      // list item text font size reduced
                                      fontSize: 14,
                                      color: context.colorExt.textPrimary
                                          .withValues(alpha: 0.7),
                                    ),
                                fillColor: context.colorExt.surface,
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          AnimatedContainer(
                            height: 40,
                            margin: EdgeInsets.only(
                              right: widget.hasMessage ? 0 : 8,
                            ),
                            width: widget.hasMessage ? 0 : 40,
                            duration: const Duration(milliseconds: 100),
                            child: IconButton(
                              // padding: const EdgeInsets.only(right: 8),
                              onPressed: widget.onPlusPressed,
                              icon: SvgPicture.asset(
                                Assets.svgs.icPlus,
                                height: 28,
                                width: 28,
                                colorFilter: ColorFilter.mode(
                                  context.colorExt.textHint,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
