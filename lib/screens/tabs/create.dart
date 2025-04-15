import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../components/choice_option_selector.dart';
import '../../components/labeled_text_field.dart';
import '../../components/image_option_selector.dart';
import '../../components/next_button.dart';

class CreateTab extends StatefulWidget {
  const CreateTab({super.key});

  @override
  State<CreateTab> createState() => _CreateTab();
}

class _CreateTab extends State<CreateTab> {
  final TextEditingController _nameController = TextEditingController();
  String selectedAge = '';
  String selectedGender = '';
  String selectedStyle = '';
  String selectedOrientation = '';
  String selectedLanguage = '';
  int currentStep = 0;

  // case 3
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _backstoryController = TextEditingController();
  final FocusNode _backstoryFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  bool _isBackstoryEmpty = true;
  bool _isDescriptionEmpty = true;

  final List<String> ageOptions = ['Teen (+18)', '20s', '30s', '40-55s'];

  final List<Map<String, dynamic>> genderOptions = [
    {
      'label': 'Female',
      'image': 'assets/images/model/mod_img5.jpeg',
      'icon': 'assets/icons/female.svg',
      'value': 'female',
    },
    {
      'label': 'Male',
      'image': 'assets/images/onboarding/ob_img14.webp',
      'icon': 'assets/icons/male.svg',
      'value': 'male',
    },
    {
      'label': 'Others',
      'image': 'assets/images/les.png',
      'icon': 'assets/icons/lesbo.svg',
      'value': 'others',
    },
  ];

  final List<Map<String, dynamic>> styleOptions = [
    {
      'label': 'Realistic',
      'image': 'assets/images/model/mod_img9.png',
      'value': 'realistic',
    },
    {
      'label': 'Animie',
      'image': 'assets/images/model/mod_img10.png',
      'value': 'anime',
    },
  ];

  final List<String> orientationOptions = ['Straight', 'Gay', 'Lesbian'];
  final List<String> languageOptions = ['English', 'Hinglish'];

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
    super.dispose();
  }

  void _nextStep() {
    if (currentStep < 4) {
      // Allow incrementing up to step 4
      setState(() => currentStep++);
    } else {
      debugPrint("Name: ${_nameController.text}");
      debugPrint("Age: $selectedAge");
      debugPrint("Gender: $selectedGender");
      debugPrint("Style: $selectedStyle");
      debugPrint("Orientation: $selectedOrientation");
      debugPrint("Language: $selectedLanguage");
      // Navigate or finish action
    }
  }

  void _prevStep() {
    if (currentStep > 0) setState(() => currentStep--);
  }

  Widget _buildOptionTile(String title, String icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Container(
        width: 333, // Set width
        height: 56, // Set height
        decoration: BoxDecoration(
          color: const Color(0xFF23222F), // Background color #23222F
          borderRadius: BorderRadius.circular(10), // Border radius 10px
        ),
        child: ListTile(
          leading: SizedBox(
            height: 16,
            width: 16,
            child: SvgPicture.asset(icon, height: 16, width: 16),
          ),

          title: Text(
            title,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ), // White text
          trailing: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
            size: 16,
          ),
          onTap: () {
            _showOptionPopup(context);
          },
        ),
      ),
    );
  }

  void _showOptionPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent, // Remove default background color
      builder: (context) {
        return Container(
          height: 552, // Increase height slightly for title
          decoration: BoxDecoration(
            color: Color(0xFF141416),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Choose from here',
                          style: TextStyle(
                            color: Color(0xFFF2F2F2),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(Icons.close, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // 3 columns
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 2.5,
                    ),
                    itemCount: 21, // 7 rows x 3 columns
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 106, // Width of the button
                          height: 46, // Height of the button
                          padding: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 16,
                          ), // Padding
                          decoration: BoxDecoration(
                            color: Color(0xFF23222F),
                            borderRadius: BorderRadius.circular(
                              100,
                            ), // Border-radius of 100px
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Choose type',
                                style: TextStyle(
                                  color: Color(0xFFE5E5E5),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ), // Gap between text and any other widget (e.g., icon)
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildStepContent(int step) {
    switch (step) {
      case 0:
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LabeledTextField(
                controller: _nameController,
                label: 'Character Name',
              ),
              const SizedBox(height: 24),
              Text(
                'Choose Age',
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFF2F2F2),
                ),
              ),
              const SizedBox(height: 20),
              ChoiceOptionSelector(
                options: ageOptions,
                selected: selectedAge,
                onSelected: (age) => setState(() => selectedAge = age),
              ),
              const SizedBox(height: 24),
              Text(
                'Gender',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFF2F2F2),
                ),
              ),
              const SizedBox(height: 12),
              ImageOptionSelector(
                options: genderOptions,
                selected: selectedGender,
                onChanged: (gender) => setState(() => selectedGender = gender),
              ),
            ],
          ),
        );
      case 1:
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Style',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFF2F2F2),
                ),
              ),
              const SizedBox(height: 12),
              ImageOptionSelector(
                options: styleOptions,
                selected: selectedStyle,
                onChanged: (style) => setState(() => selectedStyle = style),
              ),
              const SizedBox(height: 24),
              Text(
                'Sexual Orientation',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFF2F2F2),
                ),
              ),
              const SizedBox(height: 12),
              ChoiceOptionSelector(
                options: orientationOptions,
                selected: selectedOrientation,
                onSelected:
                    (value) => setState(() => selectedOrientation = value),
              ),
              const SizedBox(height: 24),
              Text(
                'Primary Language',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFF2F2F2),
                ),
              ),
              const SizedBox(height: 12),
              ChoiceOptionSelector(
                options: languageOptions,
                selected: selectedLanguage,
                onSelected: (value) => setState(() => selectedLanguage = value),
              ),
            ],
          ),
        );
      case 2:
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose Character’s',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFF2F2F2),
                ),
              ),
              const SizedBox(height: 20),
              Positioned(
                top: 191,
                left: 28,
                child: Container(
                  width: 374,
                  height: 509,
                  decoration: BoxDecoration(
                    color: Color(0xFF151519), // Background color #151519
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: Column(
                      children: [
                        _buildOptionTile(
                          'Personality',
                          'assets/icons/solar_mask-sad-linear.svg',
                        ),
                        _buildOptionTile(
                          'Relationship',
                          'assets/icons/carbon_friendship.svg',
                        ),
                        _buildOptionTile(
                          'Behaviour',
                          'assets/icons/token_mind.svg',
                        ),
                        _buildOptionTile(
                          'Voice',
                          'assets/icons/ri_voice-ai-fill.svg',
                        ),
                        _buildOptionTile('Country', 'assets/icons/ci_flag.svg'),
                        _buildOptionTile(
                          'City',
                          'assets/icons/mage_location.svg',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        );

      case 3:
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
                            color:
                                Colors
                                    .cyan, // If you want to apply color to the SVG
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
                    // Text field
                    TextField(
                      controller: _descriptionController,
                      focusNode: _descriptionFocusNode, // Attach the FocusNode
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
                    if (_isDescriptionEmpty) // Show icon only when the TextField is empty
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

      case 4:
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    // Character image container
                    Container(
                      width: 167,
                      height: 167,
                      decoration: BoxDecoration(
                        color: const Color(0xFF272730),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.asset(
                          'assets/onboarding/ob_img6.webp',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            print('Error loading image: $error');
                            // Fallback to placeholder when image fails to load
                            return Center(
                              child: Icon(
                                Icons.image_not_supported,
                                size: 83.25,
                                color: Color(0xFF5B5B69),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                    Text(
                      'Here is your Chat Partner',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              Text(
                'Or choose from images',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFF2F2F2),
                ),
              ),
              const SizedBox(height: 10),

              // Image option selector for choosing from images
              // 3×2 grid layout with 6 image boxes
              GridView.count(
                crossAxisCount: 3, // 3 columns
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                padding: EdgeInsets.symmetric(horizontal: 16),
                childAspectRatio: 127.72 / 131, // Width/Height ratio
                children: List.generate(6, (index) {
                  return Container(
                    width: 127.72,
                    height: 131,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.92),
                      color: const Color(0xFF272730), // Background color
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.92),
                      child: Image.asset(
                        'assets/images/image${index + 1}.jpg', // Replace with your image paths
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(
                              Icons.image,
                              size: 50,
                              color: Color(0xFF5B5B69),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and current step number
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Character Creation',
                    style: GoogleFonts.openSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFC9C9C9),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'STEP',
                        style: GoogleFonts.openSans(
                          fontSize: 16,
                          color: const Color(0xFFA3A3A3),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${currentStep + 1 > 4 ? 4 : currentStep + 1}/4', // Ensure it doesn't exceed 4
                        style: GoogleFonts.openSans(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 32),
              Expanded(child: buildStepContent(currentStep)),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (currentStep > 0)
                    TextButton(
                      onPressed: _prevStep,
                      child: const Text(
                        "Previous",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  else
                    const SizedBox(),

                  NextButton(
                    label:
                        currentStep == 3
                            ? "Preview"
                            : (currentStep == 4 ? "Create" : "Next"),
                    onPressed:
                        currentStep == 4
                            ? () {
                              // Add your create functionality here
                              debugPrint("Character Created!");
                            }
                            : _nextStep,
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
