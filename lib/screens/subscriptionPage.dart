import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
// Import math for clamp

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  // Default selection matches the image (1 YEAR)
  int selectedIndex = 2;

  final List<Map<String, dynamic>> plans = [
    {
      'title': '1 WEEK',
      'price': '₹500.00',
      'perWeek': '₹500.00',
      'perWeekText': 'PER WEEK',
    },
    {
      'title': '1 MONTH',
      'price': '₹1000.00',
      'perWeek': '₹250.00',
      'perWeekText': 'PER WEEK',
    },
    {
      'title': '1 YEAR',
      'price': '₹2000.00',
      'perWeek': '₹41.66',
      'perWeekText': 'PER WEEK',
    },
  ];

  // Helper function for responsive font size calculation
  double _getResponsiveFontSize(BuildContext context, double baseSize) {
    double screenWidth = MediaQuery.of(context).size.width;
    return (screenWidth * 0.04 * (baseSize / 16.0)).clamp(
      baseSize * 0.85,
      baseSize * 1.3,
    );
  }

  // Define the gradient reused in plan card and button
  final Gradient _highlightGradient = const LinearGradient(
    colors: [
      Color(0xFF9D01C6), // Purple start
      Color(0xFF22C6E4), // Cyan end
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          // Apply base background color
          color: const Color(0xFF0A0A0A),
          // Use Stack to overlay the fixed back button
          child: Stack(
            children: [
              // *** Make the entire content column scrollable ***
              SingleChildScrollView(
                child: Column(
                  children: [
                    // --- Top Section (will now scroll) ---
                    Container(
                      // Height still defines its initial size within the scroll view
                      height: screenHeight * 0.58,
                      child: Stack(
                        children: [
                          // Background image
                          Positioned.fill(
                            child: Image.asset(
                              'assets/images/model/mod_img5.jpeg', // Ensure path is correct
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter.add(
                                const Alignment(0, 0.1),
                              ),
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
                                    Colors.transparent,
                                    Color.fromRGBO(10, 10, 10, 0.8),
                                    Color(0xFF0A0A0A),
                                  ],
                                  stops: [0.4, 0.8, 1.0],
                                ),
                              ),
                            ),
                          ),
                          // Content positioned OVER the image and gradient
                          Positioned.fill(
                            bottom: screenHeight * 0.02,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'My Subscription',
                                  style: TextStyle(
                                    fontSize: _getResponsiveFontSize(
                                      context,
                                      28,
                                    ),
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.01),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.06,
                                    vertical: screenHeight * 0.007,
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
                                      fontSize: _getResponsiveFontSize(
                                        context,
                                        16,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.025),
                                // Features List
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.15,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _featureTile('Unlimited Chat', context),
                                      _featureTile(
                                        'Unlock AI Calling',
                                        context,
                                      ),
                                      _featureTile(
                                        'Unlock Images & Videos',
                                        context,
                                      ),
                                      _featureTile(
                                        'Personalized Experience',
                                        context,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // --- End Top Section ---

                    // --- Bottom Section Content (Now directly part of the main Column) ---
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: screenHeight * 0.03,
                          ), // Space below features
                          // Plan Options
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(plans.length, (index) {
                              final plan = plans[index];
                              final isSelected = index == selectedIndex;

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = index;
                                  });
                                },
                                child: Container(
                                  width: screenWidth * 0.28,
                                  padding: EdgeInsets.only(
                                    top: screenHeight * 0.02,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[900]?.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color:
                                          isSelected
                                              ? const Color(0xFF7800B7)
                                              : Colors.grey[700]!,
                                      width: isSelected ? 2 : 1,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        plan['title'],
                                        style: TextStyle(
                                          color: const Color(0xFFf2f2f2),
                                          fontSize: _getResponsiveFontSize(
                                            context,
                                            16,
                                          ),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: screenHeight * 0.01),
                                      Text(
                                        plan['price'],
                                        style: TextStyle(
                                          color: const Color(0xFF999999),
                                          fontSize: _getResponsiveFontSize(
                                            context,
                                            18,
                                          ),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: screenHeight * 0.035),
                                      // Bottom Price Box - Conditional Styling
                                      Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.symmetric(
                                          vertical: screenHeight * 0.01,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient:
                                              isSelected
                                                  ? _highlightGradient
                                                  : null,
                                          color:
                                              isSelected
                                                  ? null
                                                  : Colors.grey[800],
                                          borderRadius: BorderRadius.circular(
                                            9,
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Text(
                                              plan['perWeek'],
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                    _getResponsiveFontSize(
                                                      context,
                                                      14,
                                                    ),
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Text(
                                              plan['perWeekText'],
                                              style: TextStyle(
                                                color: Colors.white.withOpacity(
                                                  0.8,
                                                ),
                                                fontSize:
                                                    _getResponsiveFontSize(
                                                      context,
                                                      10,
                                                    ),
                                                fontWeight: FontWeight.w600,
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
                          ),

                          SizedBox(height: screenHeight * 0.04),

                          // Continue Button
                          Container(
                            width: double.infinity,
                            height: screenHeight * 0.065,
                            constraints: const BoxConstraints(
                              minHeight: 45,
                              maxHeight: 60,
                            ),
                            decoration: BoxDecoration(
                              gradient: _highlightGradient,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                /* Your logic here */
                              },
                              child: Text(
                                'CONTINUE',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: _getResponsiveFontSize(context, 16),
                                  color: Colors.white,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.025),

                          // Footer Text
                          Text(
                            'Subscription renews automatically. You can cancel anytime',
                            style: TextStyle(
                              color: const Color(0xffa3a3a3),
                              fontSize: _getResponsiveFontSize(context, 12),
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          SizedBox(height: screenHeight * 0.015),

                          // Links Row (using Wrap)
                          Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 8.0,
                            runSpacing: 0.0,
                            children: [
                              TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  foregroundColor: const Color(0xffa3a3a3),
                                ),
                                child: Text(
                                  'Privacy Policy',
                                  style: TextStyle(
                                    fontSize: _getResponsiveFontSize(
                                      context,
                                      13,
                                    ),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Container(
                                height: _getResponsiveFontSize(context, 12),
                                width: 1,
                                color: Colors.grey,
                              ),
                              TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  foregroundColor: const Color(0xffa3a3a3),
                                ),
                                child: Text(
                                  'Term and Condition',
                                  style: TextStyle(
                                    fontSize: _getResponsiveFontSize(
                                      context,
                                      13,
                                    ),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(
                            height: screenHeight * 0.03,
                          ), // Bottom padding
                        ],
                      ),
                    ),
                    // --- End Bottom Section Content ---
                  ],
                ),
              ),

              // Back button (Remains fixed due to Stack positioning)
              Positioned(
                top: 10,
                left: screenWidth * 0.05,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Feature tile widget
  Widget _featureTile(String title, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight =
        MediaQuery.of(context).size.height; // Define here if needed
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.008),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/icons/tabler_hand-finger-right.svg', // Verify path
            width: 22,
            height: 22,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          SizedBox(width: screenWidth * 0.03),
          Flexible(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: _getResponsiveFontSize(context, 16),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
