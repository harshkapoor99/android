import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateTab extends StatefulWidget {
  const CreateTab({super.key});

  @override
  State<CreateTab> createState() => _CreateTab();
}

class _CreateTab extends State<CreateTab> {
  final TextEditingController _nameController = TextEditingController();

  String selectedAge = '';
  String selectedGender = '';

  // age option
  final List<String> ageOptions = ['Teen (+18)', '20s', '30s', '40-55s'];

  // gender option
  final List<Map<String, dynamic>> genderOptions = [
    {
      'label': 'Female',
      'image': 'assets/images/model/mod_img5.jpeg',
      'icon': 'assets/icons/female.png',
      'value': 'female',
    },
    {
      'label': 'Male',
      'image': 'assets/images/onboarding/ob_img14.webp',
      'icon': 'assets/icons/male.png',
      'value': 'male',
    },
    {
      'label': 'Others',
      'image': 'assets/images/les.png',
      'icon': 'assets/icons/lesbo.png',
      'value': 'others',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // spacing
              SizedBox(height: 14),
              // Character creation row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Character Creation',
                    style: GoogleFonts.openSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      height: 1.0,
                      letterSpacing: 0.0,
                      color: Color(0xFFC9C9C9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        'STEP',
                        style: GoogleFonts.openSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          height: 1.0,
                          color: Color(0xFFA3A3A3),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '1/4',
                        style: GoogleFonts.openSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          height: 1.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 40),

              SizedBox(
                width: 374,
                height: 90,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Character Name',
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        height: 1.0,
                        color: Color(0xFFF2F2F2),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _nameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xFF23222F),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              Text(
                'Choose Age',
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1.0,
                  color: Color(0xFFF2F2F2),
                ),
              ),

              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                children:
                    ageOptions.map((age) {
                      final isSelected = selectedAge == age;
                      return ChoiceChip(
                        label: Text(age),
                        selected: isSelected,
                        onSelected: (_) {
                          setState(() => selectedAge = age);
                        },
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.black : Colors.white,
                        ),
                        selectedColor: Colors.white,
                        backgroundColor: Colors.grey[800],
                      );
                    }).toList(),
              ),
              const SizedBox(height: 40),
              Text('Gender', style: GoogleFonts.poppins(color: Colors.white)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:
                    genderOptions.map((gender) {
                      final isSelected = selectedGender == gender['value'];
                      return GestureDetector(
                        onTap: () {
                          setState(() => selectedGender = gender['value']);
                        },
                        child: Column(
                          children: [
                            Container(
                              height: 106.86,
                              width: 116.75,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color:
                                      isSelected
                                          ? Colors.white
                                          : Colors.transparent,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: AssetImage(gender['image']),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              gender['label'],
                              style: GoogleFonts.poppins(
                                color: Color(0xFFE5E5E5),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
              ),

              const Spacer(),

              Align(
                alignment: Alignment.centerRight,
                child: Material(
                  borderRadius: BorderRadius.circular(12),
                  child: Ink(
                    width: 132,
                    height: 46,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF9D00C6),
                          Color(0xFF00FFED),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        // onPressed logic
                      },
                      child: const Center(
                        child: Text(
                          'Next',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'OpenSans', // Make sure you added OpenSans in pubspec.yaml
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            height: 1.0, // line-height 100%
                            letterSpacing: 0.0,
                            color: Colors.white, // Assuming white text
                          ),
                        ),

                      ),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
