import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../components/choice_option_selector.dart';
import '../../components/image_option_selector.dart';
import '../../components/labeled_text_field.dart';

class Step2Widget extends StatefulWidget {
  const Step2Widget({super.key});

  @override
  State<Step2Widget> createState() => _Step2WidgetState();
}

class _Step2WidgetState extends State<Step2Widget> {

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

  @override
  Widget build(BuildContext context) {
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
  }
}
