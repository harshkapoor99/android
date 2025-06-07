import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/models/master/master_models.dart';
import 'package:guftagu_mobile/providers/audio_provider.dart';
import 'package:guftagu_mobile/utils/app_constants.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:guftagu_mobile/utils/extensions.dart';
import 'package:guftagu_mobile/utils/responsive.dart';

Widget buildOptionTile<T>({
  required BuildContext context,
  required WidgetRef ref,
  required String title,
  required List<T> options,
  String? emptyOptionHint,
  Widget? icon,
  double? width,
  required String Function(T) optionToString,
  String Function(T)? optionToStringSubtitle,
  bool isLast = false,
  T? selected,
  String? selectedValue,
  List<T>? multiSelected,
  required Function(T) onSelect,
  Function(List<T>)? onMultiSelect,
  bool? isMultiple,
  int? maxSelectToClose,
  bool showLoading = false,
}) {
  final titleStyle = context.appTextStyle.textSemibold;
  return Container(
    decoration: BoxDecoration(
      color: context.colorExt.surface,
      borderRadius: BorderRadius.circular(10),
    ),
    child: ListTile(
      leading: icon,
      title: Text(
        selectedValue ??
            (selected != null
                ? optionToString(selected)
                : isMultiple == true &&
                    multiSelected != null &&
                    multiSelected.isNotEmpty
                ? "${multiSelected.length} $title Selected"
                : "Select"),
        style:
            selectedValue != null ||
                    selected != null ||
                    (isMultiple == true &&
                        multiSelected != null &&
                        multiSelected.isNotEmpty)
                ? titleStyle
                : AppConstants.inputDecoration(context).hintStyle,
      ),
      trailing:
          showLoading
              ? SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: context.colorExt.textPrimary,
                ),
              )
              : Icon(
                Icons.arrow_forward_ios,
                color: context.colorExt.textPrimary,
                size: 16,
              ),
      onTap: () {
        if (showLoading) return;
        if (T == Voice) {
          _showVoiceOptionPopup(
            context,
            ref,
            title,
            options as List<Voice>,
            optionToString: optionToString as String Function(Voice),
            optionToStringSubtitle:
                optionToStringSubtitle as String Function(Voice)?,
            emptyOptionHint: emptyOptionHint,
            onSelect: onSelect as Function(Voice),
            selected: selected as Voice?,
          );
        } else if (T == Country || T == City || T == Language) {
          _showOptionPopupWithSearch<T>(
            context,
            ref,
            title,
            options,
            optionToString: optionToString,
            onSelect: onSelect,
            selected: selected,
          );
        } else {
          if (isMultiple == true) {
            _showOptionPopupWithMultiselect<T>(
              context,
              ref,
              title,
              options,
              emptyOptionHint: emptyOptionHint,
              optionToString: optionToString,
              onSelect: onMultiSelect!,
              selected: multiSelected,
              maxSelectToClose: maxSelectToClose,
            );
          } else {
            _showOptionPopup<T>(
              context,
              ref,
              title,
              options,
              emptyOptionHint: emptyOptionHint,
              optionToString: optionToString,
              onSelect: onSelect,
              selected: selected,
            );
          }
        }
      },
    ),
  );
}

void _showVoiceOptionPopup(
  BuildContext context,
  WidgetRef ref,
  String title,
  List<Voice> options, {
  required String Function(Voice) optionToString,
  String Function(Voice)? optionToStringSubtitle,
  String? emptyOptionHint,
  required Function(Voice) onSelect,
  Voice? selected,
}) {
  final screenWidth = MediaQuery.sizeOf(context).width;
  final screenHeight = MediaQuery.sizeOf(context).height;

  final horizontalPadding = getResponsiveHorizontalPadding(
    screenWidth,
    small: 16,
    medium: 24,
    large: 36,
  );
  final verticalPadding = getResponsiveHorizontalPadding(
    screenWidth,
    small: 16,
    medium: 24,
    large: 36,
  );

  Future<void> initializePlayer(
    WidgetRef ref,
    Voice voice, {
    required int samples,
  }) async {
    try {
      await ref
          .read(audioPlayerProvider.notifier)
          .preparePlayer(voice, samples: samples);
    } catch (e) {
      AppConstants.showSnackbar(
        message: "Failed to load audio:",
        isSuccess: false,
      );
    }
  }

  const style = PlayerWaveStyle(
    fixedWaveColor: Colors.black,
    liveWaveColor: Colors.lightBlue,
    backgroundColor: Colors.black,
  );

  final samples = style.getSamplesForWidth(screenWidth / 5);

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: screenHeight * 0.8),
        child: Container(
          decoration: BoxDecoration(
            color: context.colorExt.sheet,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: horizontalPadding,
                  right: horizontalPadding,
                  top: verticalPadding,
                  bottom: verticalPadding,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Choose from $title",
                        style: context.appTextStyle.sheetHeader,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.close,
                        color: context.colorExt.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Consumer(
                builder: (context, ref, child) {
                  final playerState = ref.watch(audioPlayerProvider);
                  final player = ref.read(audioPlayerProvider.notifier);

                  return options.isEmpty && emptyOptionHint != null
                      ? Text(
                        emptyOptionHint,
                        style: context.appTextStyle.textSmall,
                      )
                      : Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.only(
                            left: horizontalPadding,
                            right: horizontalPadding,
                            bottom: 10,
                            top: 5,
                          ),
                          itemCount: options.length,
                          itemBuilder: (context, index) {
                            final option = options[index];
                            final isSelected = selected == option;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? context.colorExt.primary
                                        : context.colorExt.surface,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      if (playerState.selectedVoice?.id !=
                                          option.id) {
                                        initializePlayer(
                                          ref,
                                          option,
                                          samples: samples,
                                        );
                                        return;
                                      }
                                      if (playerState.playerStatus ==
                                          PlayerStatus.playing) {
                                        await player.pausePlayer();
                                      } else {
                                        await player.startPlayer();
                                      }
                                    },
                                    child: SvgPicture.asset(
                                      playerState.selectedVoice?.id ==
                                                  option.id &&
                                              playerState.playerStatus ==
                                                  PlayerStatus.playing
                                          ? Assets.svgs.icPause
                                          : Assets.svgs.icPlay,
                                    ),
                                  ),
                                  12.pw,
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        optionToString(option),
                                        style: context.appTextStyle.textSemibold
                                            .copyWith(
                                              color:
                                                  isSelected
                                                      ? context
                                                          .colorExt
                                                          .buttonText
                                                      : null,
                                            ),
                                      ),
                                      if (optionToStringSubtitle != null)
                                        Text(
                                          optionToStringSubtitle(option),
                                          style: context
                                              .appTextStyle
                                              .textSemibold
                                              .copyWith(
                                                fontSize: 12,
                                                color:
                                                    isSelected
                                                        ? context
                                                            .colorExt
                                                            .buttonText
                                                        : null,
                                              ),
                                        ),
                                    ],
                                  ),

                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        if (option.id ==
                                            playerState.selectedVoice?.id)
                                          Expanded(
                                            child: Center(
                                              child: SizedBox(
                                                // height: 50,
                                                child:
                                                    playerState.playerStatus ==
                                                            PlayerStatus.loading
                                                        ? CircularProgressIndicator(
                                                          constraints:
                                                              BoxConstraints.tight(
                                                                const Size(
                                                                  20,
                                                                  20,
                                                                ),
                                                              ),
                                                          strokeWidth: 2,
                                                        )
                                                        : AudioFileWaveforms(
                                                          size: Size(
                                                            screenWidth / 5,
                                                            30,
                                                          ),
                                                          playerController:
                                                              playerState
                                                                  .playerController,
                                                          enableSeekGesture:
                                                              true,
                                                          waveformType:
                                                              WaveformType
                                                                  .fitWidth,
                                                          waveformData:
                                                              playerState
                                                                  .playerController
                                                                  .waveformData,
                                                          playerWaveStyle:
                                                              style,
                                                        ),
                                              ),
                                            ),
                                          ),
                                        GestureDetector(
                                          onTap: () {
                                            onSelect(option);
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: context.colorExt.surface,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                color: context.colorExt.border,
                                                width: 1,
                                              ),
                                            ),
                                            child: Center(
                                              child: SvgPicture.asset(
                                                Assets.svgs.clarityArrowLine,
                                                colorFilter: ColorFilter.mode(
                                                  context.colorExt.textPrimary,
                                                  BlendMode.srcIn,
                                                ),
                                                width: 26,
                                                height: 26,
                                                semanticsLabel: 'Arrow icon',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                },
              ),
              SizedBox(height: verticalPadding),
            ],
          ),
        ),
      );
    },
  );
}

void _showOptionPopup<T>(
  BuildContext context,
  WidgetRef ref,
  String title,
  List<T> options, {
  String? emptyOptionHint,
  required String Function(T) optionToString,
  required Function(T) onSelect,
  T? selected,
}) {
  final screenWidth = MediaQuery.sizeOf(context).width;
  final screenHeight = MediaQuery.sizeOf(context).height;

  final horizontalPadding = getResponsiveHorizontalPadding(
    screenWidth,
    small: 16,
    medium: 24,
    large: 36,
  );
  final verticalPadding = getResponsiveHorizontalPadding(
    screenWidth,
    small: 16,
    medium: 24,
    large: 36,
  );

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: screenHeight * 0.8),
        child: Container(
          decoration: BoxDecoration(
            color: context.colorExt.sheet,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: horizontalPadding,
                  right: horizontalPadding,
                  top: verticalPadding,
                  bottom: verticalPadding,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Choose a $title",
                        style: context.appTextStyle.sheetHeader,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.close,
                        color: context.colorExt.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              options.isEmpty && emptyOptionHint != null
                  ? Text(emptyOptionHint, style: context.appTextStyle.textSmall)
                  : Flexible(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: horizontalPadding,
                          right: horizontalPadding,
                          bottom: 10,
                          top: 5,
                        ),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Wrap(
                            spacing: 10,
                            runSpacing: 14,
                            alignment: WrapAlignment.start,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            children:
                                options.map((option) {
                                  final isSelected = selected == option;
                                  return GestureDetector(
                                    onTap: () {
                                      onSelect(option);
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 18,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            isSelected
                                                ? context.colorExt.button
                                                : context.colorExt.surface,
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                      ),
                                      child: Text(
                                        optionToString(option),
                                        style: context.appTextStyle.text
                                            .copyWith(
                                              color:
                                                  isSelected
                                                      ? context
                                                          .colorExt
                                                          .buttonText
                                                      : null,
                                            ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
              SizedBox(height: verticalPadding),
            ],
          ),
        ),
      );
    },
  );
}

void _showOptionPopupWithMultiselect<T>(
  BuildContext context,
  WidgetRef ref,
  String title,
  List<T> options, {
  String? emptyOptionHint,
  required String Function(T) optionToString,
  required Function(List<T>) onSelect,
  List<T>? selected,
  int? maxSelectToClose,
}) {
  final screenWidth = MediaQuery.sizeOf(context).width;
  final screenHeight = MediaQuery.sizeOf(context).height;

  final horizontalPadding = getResponsiveHorizontalPadding(
    screenWidth,
    small: 16,
    medium: 24,
    large: 36,
  );
  final verticalPadding = getResponsiveHorizontalPadding(
    screenWidth,
    small: 16,
    medium: 24,
    large: 36,
  );

  final multiSelectProvider = StateProvider<List<T>>((ref) => selected ?? []);

  void toggleSelect(WidgetRef ref, T value) {
    final currentSelection = ref.read(multiSelectProvider);
    if (currentSelection.contains(value)) {
      ref.read(multiSelectProvider.notifier).state =
          currentSelection.where((item) => item != value).toList();
    } else {
      if (maxSelectToClose != null &&
          currentSelection.length == maxSelectToClose) {
        return;
      }
      ref.read(multiSelectProvider.notifier).state = [
        ...currentSelection,
        value,
      ];
    }
    if (maxSelectToClose != null &&
        ref.read(multiSelectProvider).length == maxSelectToClose) {
      Navigator.pop<List<T>>(context, ref.read(multiSelectProvider));
    }
  }

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return PopScope(
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            onSelect(ref.read(multiSelectProvider));
          }
        },
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: screenHeight * 0.8),
          child: Container(
            decoration: BoxDecoration(
              color: context.colorExt.sheet,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: horizontalPadding,
                    right: horizontalPadding,
                    top: verticalPadding,
                    bottom: verticalPadding,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Choose upto $maxSelectToClose $title",
                          style: context.appTextStyle.sheetHeader,
                        ),
                      ),
                      GestureDetector(
                        onTap:
                            () => Navigator.pop<List<T>>(
                              context,
                              ref.read(multiSelectProvider),
                            ),
                        child: Icon(
                          Icons.close,
                          color: context.colorExt.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                options.isEmpty && emptyOptionHint != null
                    ? Text(
                      emptyOptionHint,
                      style: context.appTextStyle.textSmall,
                    )
                    : Consumer(
                      builder: (context, ref, child) {
                        final seletedOptions = ref.watch(multiSelectProvider);
                        return Flexible(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: horizontalPadding,
                                right: horizontalPadding,
                                bottom: 10,
                                top: 5,
                              ),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Wrap(
                                  spacing: 10,
                                  runSpacing: 14,
                                  alignment: WrapAlignment.start,
                                  crossAxisAlignment: WrapCrossAlignment.start,
                                  children:
                                      options.map((option) {
                                        final isSelected = seletedOptions
                                            .contains(option);
                                        return GestureDetector(
                                          onTap: () {
                                            // onSelect(option);
                                            toggleSelect(ref, option);
                                            //   Navigator.pop(context);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 10,
                                              horizontal: 18,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  isSelected
                                                      ? context.colorExt.button
                                                      : context
                                                          .colorExt
                                                          .surface,
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                // Radio<T>(
                                                //   value: option,
                                                //   groupValue:
                                                //       seletedOptions.contains(
                                                //             option,
                                                //           )
                                                //           ? option
                                                //           : null,
                                                //   onChanged: (_) {
                                                //     toggleSelect(ref, option);
                                                //   },
                                                //   fillColor:
                                                //       WidgetStatePropertyAll(
                                                //         isSelected
                                                //             ? context
                                                //                 .colorExt
                                                //                 .textPrimary
                                                //             : context
                                                //                 .colorExt
                                                //                 .surface,
                                                //       ),
                                                // ),
                                                Flexible(
                                                  child: Text(
                                                    optionToString(option),
                                                    style: context
                                                        .appTextStyle
                                                        .text
                                                        .copyWith(
                                                          color:
                                                              isSelected
                                                                  ? context
                                                                      .colorExt
                                                                      .buttonText
                                                                  : null,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                SizedBox(height: verticalPadding),
              ],
            ),
          ),
        ),
      );
    },
  );
}

void _showOptionPopupWithSearch<T>(
  BuildContext context,
  WidgetRef ref,
  String title,
  List<T> options, {
  required String Function(T) optionToString,
  required Function(T) onSelect,
  T? selected,
}) {
  final screenWidth = MediaQuery.sizeOf(context).width;
  final screenHeight = MediaQuery.sizeOf(context).height;

  final horizontalPadding = getResponsiveHorizontalPadding(
    screenWidth,
    small: 16,
    medium: 24,
    large: 36,
  );
  final verticalPadding = getResponsiveHorizontalPadding(
    screenWidth,
    small: 16,
    medium: 24,
    large: 36,
  );

  final TextEditingController searchController = TextEditingController();
  // Create a provider for the search text
  final searchTextProvider = StateProvider<String>((ref) => '');

  // Create a provider for filtered options
  final filteredOptionsProvider = Provider<List<T>>((ref) {
    final searchText = ref.watch(searchTextProvider).toLowerCase();
    if (searchText.isEmpty) return options;

    return options.where((option) {
      return optionToString(option).toLowerCase().contains(searchText);
    }).toList();
  });

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: screenHeight * 0.8),
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Container(
            decoration: BoxDecoration(
              color: context.colorExt.sheet,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: horizontalPadding,
                    right: horizontalPadding,
                    top: verticalPadding,
                    bottom: verticalPadding,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Choose a $title",
                          style: context.appTextStyle.sheetHeader,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.close,
                          color: context.colorExt.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: horizontalPadding,
                    right: horizontalPadding,
                    bottom: verticalPadding,
                  ),
                  child: SizedBox(
                    height: 45,
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        // Update the search text provider when text changes
                        ref.read(searchTextProvider.notifier).state = value;
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        hintText: "Search",
                        hintStyle: context.appTextStyle.text.copyWith(
                          color: context.colorExt.textHint.withValues(
                            // alpha: 0.7,
                          ),
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 13,
                          ),
                          child: SvgPicture.asset(
                            Assets.svgs.icSearch,
                            height: 5,
                            width: 5,
                            colorFilter: ColorFilter.mode(
                              context.colorExt.textHint,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        filled: true,
                        fillColor: context.colorExt.surface,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(60),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFF47C8FC),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Consumer(
                  builder: (context, ref, child) {
                    final filteredOption = ref.watch(filteredOptionsProvider);
                    return Flexible(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: horizontalPadding,
                          right: horizontalPadding,
                          bottom: 10,
                          top: 5,
                        ),
                        child: ListView.builder(
                          // spacing: 10,
                          // runSpacing: 14,
                          // alignment: WrapAlignment.start,
                          // crossAxisAlignment: WrapCrossAlignment.start,
                          // children:
                          itemCount: filteredOption.length,
                          itemBuilder: (context, index) {
                            bool isSelected = filteredOption[index] == selected;
                            return GestureDetector(
                              onTap: () {
                                onSelect(filteredOption[index]);
                                Navigator.pop(context);
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 18,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      isSelected
                                          ? context.colorExt.primary
                                          : null,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border(
                                    bottom: BorderSide(
                                      width: 1,
                                      color: context.colorExt.surface,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  optionToString(filteredOption[index]),
                                  style: context.appTextStyle.textSmall
                                      .copyWith(
                                        color:
                                            isSelected
                                                ? context.colorExt.buttonText
                                                : null,
                                      ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
  ).then((value) {
    // Wait for the bottom sheet to close
    if (value != null) {
      // Handle value returned by Navigator.pop()
    }
    // Dispose the controller here
    // MyController controller = context.findAncestorWidgetOfExactType<MyBottomSheetWidget>().controller;
    // controller?.dispose();
    // searchController.dispose();
  });
}
