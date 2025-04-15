import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

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
        final separatorWidth = 16.0 * (options.length - 1);
        final rawItemWidth = (constraints.maxWidth - separatorWidth) / options.length;

        // Clamp width and height
        final itemWidth = rawItemWidth.clamp(0.0, 116.0);
        final imageHeight = 106.0;

        return SizedBox(
          height: imageHeight + 11 + 24, // image + spacing + label/icon
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(options.length * 2 - 1, (index) {
              if (index.isOdd) {
                // Gap between items
                return const SizedBox(width: 11.8);
              }

              final actualIndex = index ~/ 2;
              final option = options[actualIndex];
              final isSelected = selected == option['value'];

              return GestureDetector(
                onTap: () => onChanged(option['value']),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                          alignment: option['label'] == 'Female' ? const Alignment(0, -0.8) : Alignment.center,
                          colorFilter: isSelected
                              ? null
                              : ColorFilter.mode(
                            Colors.black.withOpacity(0.4),
                            BlendMode.darken,
                          ),
                        ),

                      ),
                    ),
                    const SizedBox(height: 11),
                    SizedBox(
                      width: itemWidth,
                      child: Row(
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
                            const SizedBox(width: 8),
                          ],
                          Flexible(
                            child: Text(
                              option['label'],
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    blurRadius: 4,
                                    color: Colors.black.withOpacity(0.7),
                                    offset: const Offset(0, 2),
                                  )
                                ],
                              ),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),

        );
      },
    );
  }
}
