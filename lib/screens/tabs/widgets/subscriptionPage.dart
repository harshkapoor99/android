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
            // Background content
            Column(
              children: [
                // Top section with image and title
                Container(
                  height: MediaQuery.of(context).size.height * 0.60,
                  child: Stack(
                    children: [
                      // Background image
                      Positioned.fill(
                        child: Image.asset(
                          'assets/images/model/mod_img5.jpeg',
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter.add(Alignment(0, 0.2)),
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
                        top: MediaQuery.of(context).size.height * 0.3,
                        left: 0,
                        right: 0,
                        child: Column(
                          children: [
                            const Text(
                              'My Subscription',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                              decoration: BoxDecoration(
                                color: Color(0xFF7800B7),
                                borderRadius: BorderRadius.circular(4.58),
                              ),
                              child: const Text(
                                'PRO',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ✅ Features (Positioned lower in screen)
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.38,
                        left: MediaQuery.of(context).size.width * 0.211,
                        right: 0,
                        child: Column(
                          children: [
                            const SizedBox(height: 32),
                            _featureTile('Unlimited Chat'),
                            _featureTile('Unlock AI Calling'),
                            _featureTile('Unlock Images & Videos'),
                            _featureTile('Personalized Experience'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Rest of the content
                Expanded(
                  child: Stack(
                    children: [
                      // 🧾 Actual Scrollable Content
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 24),

                            // Plan Options
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      width: MediaQuery.of(context).size.width * 0.27,
                                      padding: const EdgeInsets.only(top: 16),
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
                                              color: Color(0xFFf2f2f2),
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            plan['price'],
                                            style: TextStyle(
                                              color: Color(0xFF999999),
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 54.34),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 5),
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
                                                    color: Color(0xFFe5e5e5),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                Text(
                                                  plan['perWeekText'],
                                                  style: TextStyle(
                                                    color: Color(0xFFe5e5e5),
                                                    fontSize: 14,
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
                              ),
                            ),

                            const SizedBox(height: 32),

                            // Continue Button
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Container(
                                width: double.infinity,
                                height: 56,
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
                                  child: const Text(
                                    'CONTINUE',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      color: Colors.white,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 23),

                            const Text(
                              'Subscription renews automatically. You can cancel anytime',
                              style: TextStyle(color: Color(0xffa3a3a3), fontSize: 12,fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 23),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    'Privacy Policy',
                                    style: TextStyle(
                                        color: Color(0xffa3a3a3),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 12,
                                  width: 1,
                                  color: Colors.grey,
                                  margin: const EdgeInsets.symmetric(horizontal: 8),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    'Term and Condition',
                                    style: TextStyle(
                                      color: Color(0xffa3a3a3),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Back button in the top-left corner
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              left: 23,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Color(0xFF5D5D5D),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
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

  Widget _featureTile(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/tabler_hand-finger-right.svg',
            width: 24,
            height: 24,
          ),
          const SizedBox(width: 14),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}