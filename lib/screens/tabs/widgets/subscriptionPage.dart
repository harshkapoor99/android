import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({Key? key}) : super(key: key);

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  int selectedIndex = 2;

  final List<Map<String, dynamic>> plans = [
    {'title': '1 WEEK', 'price': '₹500.00', 'perWeek': '₹500.00', 'perWeekText': 'PER WEEK'},
    {'title': '1 MONTH', 'price': '₹1000.00', 'perWeek': '₹250.00', 'perWeekText': 'PER WEEK'},
    {'title': '1 YEAR', 'price': '₹2000.00', 'perWeek': '₹41.66', 'perWeekText': 'PER WEEK'},
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final topPadding = MediaQuery.of(context).padding.top;

    // Calculate responsive dimensions
    final featureWidth = screenWidth * 0.7; // 70% of screen width
    final imageHeight = screenHeight * 0.6;
    final featuresTop = imageHeight * 0.63; // Position features at 63% of image height

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        // Full screen gradient
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0A0A0A), // 0%
              Color(0xFF0A0A0A), // 100%
            ],
          ),
        ),
        child: Stack(
          children: [
            // Main scrollable content
            SingleChildScrollView(
              child: Column(
                children: [
                  // Top section with image and title
                  SizedBox(
                    height: imageHeight,
                    child: Stack(
                      children: [
                        // Background image
                        Positioned.fill(
                          child: Image.asset(
                            'assets/images/model/mod_img5.jpeg',
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter.add(const Alignment(0, 0.2)),
                          ),
                        ),

                        // Gradient overlay
                        Positioned.fill(
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color.fromRGBO(10, 10, 10, 0),
                                  Color(0xFF0A0A0A),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Title and badge
                        Positioned(
                          top: imageHeight * 0.5,
                          left: 0,
                          right: 0,
                          child: Column(
                            children: [
                              Text(
                                'My Subscription',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.07, // Responsive font size
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.06,
                                  vertical: screenHeight * 0.008,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF7800B7),
                                  borderRadius: BorderRadius.circular(4.58),
                                ),
                                child: Text(
                                  'PRO',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: screenWidth * 0.04, // Responsive font size
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // ✅ Features
                        Positioned(
                          top: featuresTop,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: FractionallySizedBox(
                              widthFactor: 0.8, // Take 80% of screen width
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: screenHeight * 0.03),
                                  _featureTile('Unlimited Chat', screenWidth),
                                  _featureTile('Unlock AI Calling', screenWidth),
                                  _featureTile('Unlock Images & Videos', screenWidth),
                                  _featureTile('Personalized Experience', screenWidth),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Plan Options
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(plans.length, (index) {
                            final plan = plans[index];
                            final isSelected = index == selectedIndex;
                            final itemWidth = (constraints.maxWidth - 16) / 3;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                });
                              },
                              child: Container(
                                width: itemWidth,
                                padding: EdgeInsets.only(top: screenHeight * 0.02),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isSelected ? const Color(0xFF7800B7) : Colors.grey[800]!,
                                    width: isSelected ? 0.91 : 2,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      plan['title'],
                                      style: TextStyle(
                                        color: const Color(0xFFf2f2f2),
                                        fontSize: screenWidth * 0.04, // Responsive font size
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.01),
                                    Text(
                                      plan['price'],
                                      style: TextStyle(
                                        color: const Color(0xFF999999),
                                        fontSize: screenWidth * 0.045, // Responsive font size
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.05),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: itemWidth * 0.15,
                                        vertical: screenHeight * 0.006,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: isSelected
                                            ? const LinearGradient(
                                          colors: [
                                            Color(0xFF9D01C6), // Purple
                                            Color(0xFF22C6E4), // Cyan
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        )
                                            : null,
                                        color: isSelected ? null : Colors.grey[850],
                                        borderRadius: BorderRadius.circular(9.03),
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            plan['perWeek'],
                                            style: TextStyle(
                                              color: const Color(0xFFe5e5e5),
                                              fontSize: screenWidth * 0.03, // Responsive font size
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Text(
                                            plan['perWeekText'],
                                            style: TextStyle(
                                              color: const Color(0xFFe5e5e5),
                                              fontSize: screenWidth * 0.03, // Responsive font size
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.04),

                  // Continue Button
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                    child: Container(
                      width: double.infinity,
                      height: screenHeight * 0.07,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xff9D00C6),
                            Color(0xff00FFED),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          // Your logic here
                        },
                        child: Text(
                          'CONTINUE',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: screenWidth * 0.04, // Responsive font size
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.025),

                  Text(
                    'Subscription renews automatically. You can cancel anytime',
                    style: TextStyle(
                        color: const Color(0xffa3a3a3),
                        fontSize: screenWidth * 0.03, // Responsive font size
                        fontWeight: FontWeight.w600
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: screenHeight * 0.025),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Privacy Policy',
                          style: TextStyle(
                            color: const Color(0xffa3a3a3),
                            fontSize: screenWidth * 0.035, // Responsive font size
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        height: screenHeight * 0.015,
                        width: 1,
                        color: Colors.grey,
                        margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Term and Condition',
                          style: TextStyle(
                            color: const Color(0xffa3a3a3),
                            fontSize: screenWidth * 0.035, // Responsive font size
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Add extra padding at the bottom for scrolling past content
                  SizedBox(height: screenHeight * 0.1),
                ],
              ),
            ),

            // Back button in the top-left corner (outside ScrollView)
            Positioned(
              top: topPadding + screenHeight * 0.01,
              left: screenWidth * 0.06,
              child: Container(
                width: screenWidth * 0.09,
                height: screenWidth * 0.09,
                decoration: const BoxDecoration(
                  color: Color(0xFF5D5D5D),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                    size: screenWidth * 0.07,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero, // ensures icon is centered
                  constraints: const BoxConstraints(), // remove default padding
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _featureTile(String title, double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02,horizontal: screenWidth*0.08),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset(
            'assets/icons/tabler_hand-finger-right.svg',
            width: screenWidth * 0.06,
            height: screenWidth * 0.06,
          ),
          SizedBox(width: screenWidth * 0.035),
          Flexible(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth * 0.042, // Responsive font size
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}