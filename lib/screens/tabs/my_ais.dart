import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyAisTab extends StatefulWidget {
  const MyAisTab({super.key});

  @override
  State<MyAisTab> createState() => _MyAisTabState();
}

class _MyAisTabState extends State<MyAisTab> {
  final List<String> imagePaths = [
    'assets/images/model/mod_img1.jpeg',
    'assets/images/model/mod_img5.jpeg',
    'assets/images/model/mod_img7.jpeg',
    'assets/images/model/mod_img6.jpeg',
    'assets/images/model/mod_img11.jpg',
    'assets/images/model/mod_img15.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 26),
          const Text(
            'My AIs',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFFF2F2F2),
            ),
          ),
          const SizedBox(height: 18),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 127.72 / 131,
            children: List.generate(imagePaths.length, (index) {
              return Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E27),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        imagePaths[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                    Positioned(
                      bottom: 17,
                      right: 17,
                      child: Opacity(
                        opacity: 0.8, // 👈 80% opacity for button
                        child: GestureDetector(
                          onTap: () {
                            debugPrint("SVG Button tapped on ${imagePaths[index]}");
                          },
                          child: Container(
                            width: 47,
                            height: 47,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF242424), // Deep purple
                            ),
                            padding: const EdgeInsets.all(13.5),
                            child: SvgPicture.asset(
                              'assets/svgs/ic_chat.svg',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
