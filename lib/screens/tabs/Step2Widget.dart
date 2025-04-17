import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Step2Widget extends StatefulWidget {
  const Step2Widget({super.key});

  @override
  State<Step2Widget> createState() => _Step2WidgetState();
}

class _Step2WidgetState extends State<Step2Widget> {

  Widget _buildOptionTile(String title, String icon, double width, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: title == 'City' ? 0 : 24),
      child: Container(
        width: width,
        height: 56,
        decoration: BoxDecoration(
          color: const Color(0xFF23222F),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: SizedBox(
            height: 16,
            width: 16,
            child: SvgPicture.asset(icon, height: 16, width: 16),
          ),
          title: Text(
            title,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
          onTap: () => _showOptionPopup(context),
        ),
      ),
    );
  }


  void _showOptionPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width;
        final crossAxisCount = screenWidth < 400
            ? 2
            : screenWidth < 700
            ? 3
            : 4;

        return Container(
          height: 552,
          decoration: const BoxDecoration(
            color: Color(0xFF141416),
            borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
          ),
          child: Column(
            children: [
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  children: [
                    const Expanded(
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
                      child: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 2.5,
                    ),
                    itemCount: 21,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF23222F),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: const Center(
                            child: Text(
                              'Choose type',
                              style: TextStyle(
                                color: Color(0xFFE5E5E5),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
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
    final screenWidth = MediaQuery.of(context).size.width;
    final maxContainerWidth = screenWidth * 0.9; // 90% of screen width

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Choose Character’s',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFFF2F2F2),
            ),
          ),
          const SizedBox(height: 25),
          Center(
            child: Container(
              width: maxContainerWidth,
              decoration: BoxDecoration(
                color: const Color(0xFF151519),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
              child: Column(
                children: [
                  _buildOptionTile('Personality', 'assets/icons/solar_mask-sad-linear.svg', maxContainerWidth),
                  _buildOptionTile('Relationship', 'assets/icons/carbon_friendship.svg', maxContainerWidth),
                  _buildOptionTile('Behaviour', 'assets/icons/token_mind.svg', maxContainerWidth),
                  _buildOptionTile('Voice', 'assets/icons/ri_voice-ai-fill.svg', maxContainerWidth),
                  _buildOptionTile('Country', 'assets/icons/ci_flag.svg', maxContainerWidth),
                  _buildOptionTile('City', 'assets/icons/mage_location.svg', maxContainerWidth),
                ],
              ),
            ),
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}