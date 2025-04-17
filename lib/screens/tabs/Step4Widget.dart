import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Step4Widget extends StatefulWidget {
  const Step4Widget({super.key});

  @override
  State<Step4Widget> createState() => _Step4WidgetState();
}

class _Step4WidgetState extends State<Step4Widget> {
  final List<String> imagePaths = [
    'assets/images/model/mod_img11.jpg',
    'assets/images/onboarding/ob_img7.webp',
    'assets/images/model/mod_img1.jpeg',
    'assets/images/model/mod_img12.jpg',
    'assets/images/model/mod_img13.jpg',
    'assets/images/model/mod_img14.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16), // Optional padding
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
                      'assets/images/onboarding/ob_img6.webp',
                      fit: BoxFit.cover,
                      alignment: const Alignment(0, -0.5), // move image slightly up
                      errorBuilder: (context, error, stackTrace) {
                        print('Error loading image: $error');
                        return const Center(
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
                const Text(
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
          const Text(
            'Or choose from images',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFFF2F2F2),
            ),
          ),
          const SizedBox(height: 10),

          // 3×2 grid layout with premium tag on 2nd and 6th
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 127.72 / 131,
            children: List.generate(imagePaths.length, (index) {
              final isPremium = index == 1 || index == 5; // 2nd and 6th
              return Stack(
                children: [
                  Material(
                    borderRadius: BorderRadius.circular(10.92),
                    clipBehavior: Clip.antiAlias,
                    color: const Color(0xFF272730),
                    child: Ink.image(
                      image: AssetImage(imagePaths[index]),
                      fit: BoxFit.cover,
                      width: 127.72,
                      height: 131,
                      child: InkWell(
                        onTap: () {
                          debugPrint("Tapped on ${imagePaths[index]}");
                        },
                        splashColor: Colors.white24,
                        highlightColor: Colors.transparent,
                      ),
                    ),
                  ),
                  if (isPremium)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: SvgPicture.asset(
                        'assets/svgs/premium.svg',
                        width: 24,
                        height: 24,
                      ),
                    ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}