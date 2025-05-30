import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/models/master/master_models.dart';
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
  // Theme.of(context).textTheme.titleMedium?.copyWith(
  //   color: Colors.white,
  //   fontWeight: FontWeight.w600,
  // ) ??
  // const TextStyle(
  //   color: Colors.white,
  //   fontSize: 16,
  //   fontWeight: FontWeight.w600,
  // );
  return Container(
    decoration: BoxDecoration(
      color: const Color(0xFF23222F),
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
              : const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
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

  double responsiveRightMargin;
  if (screenWidth < 380) {
    responsiveRightMargin = 24.0;
  } else if (screenWidth < 600) {
    responsiveRightMargin = 40.0;
  } else {
    responsiveRightMargin = 64.0;
  }

  final voiceProvider = StateProvider<Voice?>((ref) => null);

  void togglePlay(WidgetRef ref, Voice option) {
    ref.read(voiceProvider.notifier).state =
        ref.read(voiceProvider) == option ? null : option;
  }

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: screenHeight * 0.8),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF0D0D18),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
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
                    const Expanded(
                      child: Text(
                        "Choose from here",
                        style: TextStyle(
                          color: Color(0xFFA3A3A3),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, color: Color(0xFFA3A3A3)),
                    ),
                  ],
                ),
              ),
              Consumer(
                builder: (context, ref, child) {
                  final provider = ref.watch(voiceProvider);
                  return Flexible(
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
                        final isPlaying = provider == option;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF23222F),
                            borderRadius: BorderRadius.circular(10),
                            border:
                                isSelected
                                    ? Border.all(
                                      color: const Color(0xFF47C8FC),
                                      width: 1,
                                    )
                                    : null,
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () => togglePlay(ref, option),
                                child: SvgPicture.asset(
                                  provider != null && provider.id == option.id
                                      ? Assets.svgs.icPause
                                      : Assets.svgs.icPlay,
                                ),
                              ),
                              12.pw,
                              Text(
                                optionToString(option),
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.85),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Spacer(),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (isPlaying)
                                    Container(
                                      margin: EdgeInsets.only(
                                        right: responsiveRightMargin,
                                      ),
                                      child: SvgPicture.asset(
                                        Assets.svgs.waves,
                                        colorFilter: const ColorFilter.mode(
                                          Color(0xFF9D93FF),
                                          BlendMode.srcIn,
                                        ),
                                        width: 26,
                                        height: 26,
                                        semanticsLabel: 'Waves icon',
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
                                        color: const Color(0xFF16151E),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Center(
                                        child: SvgPicture.asset(
                                          Assets.svgs.clarityArrowLine,
                                          colorFilter: const ColorFilter.mode(
                                            Colors.white,
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
          decoration: const BoxDecoration(
            color: Color(0xFF0D0D18),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
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
                        style: const TextStyle(
                          color: Color(0xFFA3A3A3),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, color: Color(0xFFA3A3A3)),
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
                                                ? context.colorExt.textHint
                                                : context.colorExt.border,
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
                                                      ? Colors.black
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
            decoration: const BoxDecoration(
              color: Color(0xFF0D0D18),
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
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
                          style: const TextStyle(
                            color: Color(0xFFA3A3A3),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap:
                            () => Navigator.pop<List<T>>(
                              context,
                              ref.read(multiSelectProvider),
                            ),
                        child: const Icon(
                          Icons.close,
                          color: Color(0xFFA3A3A3),
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
                                            padding: const EdgeInsets.only(
                                              // vertical: 10,
                                              // horizontal: 18,
                                              right: 15,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  isSelected
                                                      ? context
                                                          .colorExt
                                                          .textHint
                                                      : context.colorExt.border,
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Radio<T>(
                                                  value: option,
                                                  groupValue:
                                                      seletedOptions.contains(
                                                            option,
                                                          )
                                                          ? option
                                                          : null,
                                                  onChanged: (_) {
                                                    toggleSelect(ref, option);
                                                  },
                                                  fillColor:
                                                      WidgetStatePropertyAll(
                                                        context
                                                            .colorExt
                                                            .primary,
                                                      ),
                                                  activeColor: Colors.red,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    optionToString(option),
                                                    style: context
                                                        .appTextStyle
                                                        .text
                                                        .copyWith(
                                                          color:
                                                              isSelected
                                                                  ? Colors.black
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
            decoration: const BoxDecoration(
              color: Color(0xFF0D0D18),
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
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
                          style: const TextStyle(
                            color: Color(0xFFA3A3A3),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.close,
                          color: Color(0xFFA3A3A3),
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
                        fillColor: context.colorExt.border,
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
                          itemBuilder:
                              (context, index) => GestureDetector(
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
                                    border: Border(
                                      bottom: BorderSide(
                                        width: 1,
                                        color: context.colorExt.border,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    optionToString(filteredOption[index]),
                                    style: const TextStyle(
                                      color: Color(0xFFE5E5E5),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
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
