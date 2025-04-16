import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImageOptionSelector extends StatelessWidget {
  final List<Map<String, dynamic>> options;
  final String selected;
  final Function(String) onChanged;

  const ImageOptionSelector({
    Key? key,
    required this.options,
    required this.selected,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 12.0;
        const totalSpacing = spacing * 2; // between 3 items
        final itemWidth = (constraints.maxWidth - totalSpacing) / 3;
        final imageHeight = itemWidth * 0.9;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: options.map((option) {
            final isSelected = selected == option['value'];

            return GestureDetector(
              onTap: () => onChanged(option['value']),
              child: SizedBox(
                width: itemWidth,
                child: Column(
                  children: [
                    Container(
                      width: itemWidth,
                      height: imageHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: isSelected
                            ? Border.all(color: Colors.pinkAccent, width: 2)
                            : null,
                        image: DecorationImage(
                          image: AssetImage(option['image']),
                          fit: BoxFit.cover,
                          alignment: option['label'] == 'Female'
                              ? const Alignment(0, -0.8)
                              : Alignment.center,
                          colorFilter: isSelected
                              ? null
                              : ColorFilter.mode(
                            Colors.black.withOpacity(0.4),
                            BlendMode.darken,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (option['icon'] != null) ...[
                          option['icon'].toString().endsWith('.svg')
                              ? SvgPicture.asset(
                            option['icon'],
                            height: 16,
                            width: 16,
                            color: Colors.white,
                          )
                              : Image.asset(
                            option['icon'],
                            height: 16,
                            width: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 6),
                        ],
                        Flexible(
                          child: Text(
                            option['label'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Colors.white,
                              overflow: TextOverflow.ellipsis,
                              shadows: [
                                Shadow(
                                  blurRadius: 4,
                                  color: Colors.black,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
