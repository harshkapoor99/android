import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../components/choice_option_selector.dart';
import '../../components/image_option_selector.dart';
import '../../components/labeled_text_field.dart';

class Step3Widget extends StatefulWidget {
  const Step3Widget({super.key});

  @override
  State<Step3Widget> createState() => _Step3WidgetState();
}

class _Step3WidgetState extends State<Step3Widget> {

  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _backstoryController = TextEditingController();
  bool _isBackstoryEmpty = true;
  bool _isDescriptionEmpty = true;
  final FocusNode _backstoryFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();

    // Listen to changes in the backstory TextField
    _backstoryController.addListener(() {
      setState(() {
        _isBackstoryEmpty = _backstoryController.text.isEmpty;
      });
    });

    // Listen to changes in the image description TextField
    _descriptionController.addListener(() {
      setState(() {
        _isDescriptionEmpty = _descriptionController.text.isEmpty;
      });
    });
  }

  @override
  void dispose() {
    // Dispose the controllers and focus nodes
    _backstoryController.dispose();
    _backstoryFocusNode.dispose();
    _descriptionController.dispose();
    _descriptionFocusNode.dispose();
    _pageController.dispose(); // Dispose the PageController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Character Image with edit button
          Center(
            child: Column(
              children: [
                Stack(
                  clipBehavior:
                  Clip.none, // Allow children to be placed outside the box
                  children: [
                    // Character image container
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
                    // Edit icon positioned 10px outside the box to the right
                    Positioned(
                      right:
                      -23, // Positioning the icon 10px outside the container
                      bottom: 0,
                      child: SvgPicture.asset(
                        'assets/icons/solar_pen-2-bold.svg', // Your SVG asset path
                        width: 26,
                        height: 26,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                Text(
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

          const SizedBox(height: 30),

          // Image description section
          Text(
            'Image description (if any)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFFF2F2F2),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: 374,
            height: 144,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.transparent,
              ), // Remove green border
              borderRadius: BorderRadius.circular(
                16,
              ), // Keep other properties
              color: const Color(0xFF272730), // Background color
            ),
            child: Stack(
              children: [
                // Text field with a nested Stack for layering
                Stack(
                  children: [
                    TextField(
                      controller: _descriptionController,
                      focusNode: _descriptionFocusNode,
                      style: const TextStyle(color: Colors.white),
                      maxLines: null,
                      expands: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: '',
                        hintStyle: TextStyle(color: Colors.grey),
                        contentPadding: EdgeInsets.all(16),
                      ),
                    ),

                    // Conditionally show floating Random Prompt button
                    if (_isDescriptionEmpty)
                      Positioned(
                        bottom: 12,
                        right: 12,
                        child: SizedBox(
                          width: 148,
                          height: 32,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Your prompt logic here
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1C1B2A),
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
                                colorFilter: ColorFilter.mode(
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
                  ],
                ),

                // Feather icon when empty
                if (_isDescriptionEmpty)
                  Positioned(
                    top: 16,
                    left: 16,
                    child: SvgPicture.asset(
                      'assets/icons/mingcute_quill-pen-line.svg',
                      width: 24,
                      height: 24,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Back Story section
          Text(
            'Back Story if any (300 words)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFFF2F2F2),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 144,
            width: 374,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.transparent,
              ), // Remove green border
              borderRadius: BorderRadius.circular(
                16,
              ), // Keep other properties
              color: const Color(0xFF272730), // Background color
            ),
            child: Stack(
              children: [
                // Text field
                TextField(
                  controller: _backstoryController,
                  focusNode: _backstoryFocusNode, // Attach the FocusNode
                  style: const TextStyle(color: Colors.white),
                  maxLines: null,
                  expands: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: '',
                  ),
                ),
                // Feather icon (conditionally displayed)
                if (_isBackstoryEmpty) // Show icon only when the TextField is empty
                  Positioned(
                    top: 16,
                    left: 16,
                    child: SvgPicture.asset(
                      'assets/icons/mingcute_quill-pen-line.svg',
                      width: 24,
                      height: 24,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
