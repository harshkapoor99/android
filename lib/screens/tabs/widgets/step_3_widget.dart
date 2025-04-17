import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:guftagu_mobile/providers/character_creation_provider.dart';
import 'package:guftagu_mobile/utils/entensions.dart';

class Step3Widget extends ConsumerStatefulWidget {
  const Step3Widget({super.key});

  @override
  ConsumerState<Step3Widget> createState() => _Step3WidgetState();
}

class _Step3WidgetState extends ConsumerState<Step3Widget> {
  // bool _isBackstoryEmpty = true;
  // bool _isDescriptionEmpty = true;
  final FocusNode _backstoryFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    // provider.backstoryController.addListener(() {
    //   setState(() {
    //     _isBackstoryEmpty = _backstoryController.text.isEmpty;
    //   });
    // });
    // _descriptionController.addListener(() {
    //   setState(() {
    //     _isDescriptionEmpty = _descriptionController.text.isEmpty;
    //   });
    // });
  }

  @override
  void dispose() {
    // _backstoryController.dispose();
    _backstoryFocusNode.dispose();
    // _descriptionController.dispose();
    _descriptionFocusNode.dispose();
    _pageController.dispose();
    super.dispose();
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
                        width: 167,
                        height: 167,
                        decoration: BoxDecoration(
                          color: const Color(0xFF272730),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.face,
                            size: 83.25,
                            color: Color(0xFF5B5B69),
                          ),
                        ),
                      ),
                      Positioned(
                        right: -23,
                        bottom: 0,
                        child: SvgPicture.asset(
                          'assets/icons/solar_pen-2-bold.svg',
                          width: 26,
                          height: 26,
                        ),
                      ),
                    ],
                  ),
                  10.ph,
                  const Text(
                    'Character Image',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            30.ph,

            const Text(
              'Image description (if any)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFFF2F2F2),
              ),
            ),
            10.ph,
            Container(
              width: double.infinity,
              height: 144,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: const Color(0xFF272730),
              ),
              child: Stack(
                children: [
                  Stack(
                    children: [
                      TextField(
                        controller: provider.descriptionController,
                        focusNode: _descriptionFocusNode,
                        style: const TextStyle(color: Colors.white),
                        maxLines: null,
                        expands: true,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),
                      ),
                      Positioned(
                        bottom: 12,
                        right: 12,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child:
                              _descriptionFocusNode.hasFocus
                                  ? null
                                  : SizedBox(
                                    height: 32,
                                    child: ElevatedButton.icon(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF1C1B2A,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
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
                                      label: const Text(
                                        'Random Prompt',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFFE5E5E5),
                                        ),
                                      ),
                                    ),
                                  ),
                        ),
                      ),
                    ],
                  ),

                  Positioned(
                    top: 16,
                    left: 16,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child:
                          _descriptionFocusNode.hasFocus
                              ? null
                              : SvgPicture.asset(
                                'assets/icons/mingcute_quill-pen-line.svg',
                                width: 24,
                                height: 24,
                              ),
                    ),
                  ),
                ],
              ),
            ),

            30.ph,

            const Text(
              'Back Story if any (300 words)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFFF2F2F2),
              ),
            ),
            10.ph,
            Container(
              height: 144,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: const Color(0xFF272730),
              ),
              child: Stack(
                children: [
                  TextField(
                    controller: provider.backstoryController,
                    focusNode: _backstoryFocusNode,
                    style: const TextStyle(color: Colors.white),
                    maxLines: null,
                    expands: true,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child:
                          _backstoryFocusNode.hasFocus
                              ? null
                              : SvgPicture.asset(
                                'assets/icons/mingcute_quill-pen-line.svg',
                                width: 24,
                                height: 24,
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
