import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';

class ImageOptions {
  ImageOptions({
    required this.label,
    required this.image,
    this.icon,
    required this.value,
  });
  final String label;
  final AssetGenImage image;
  final String? icon;
  final String value;
}

class ImageOptionSelector extends StatelessWidget {
  final List<ImageOptions> options;
  final String selected;
  final Function(String) onChanged;

  const ImageOptionSelector({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 12.0;
        final totalSpacing = spacing * (options.length - 1);
        final itemWidth =
            (constraints.maxWidth - totalSpacing) / options.length;
        final imageHeight = itemWidth * 1;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children:
              options.map((option) {
                final isSelected = selected == option.value;

                return GestureDetector(
                  onTap: () => onChanged(option.value),
                  child: SizedBox(
                    width: itemWidth,
                    child: Column(
                      children: [
                        Container(
                          width: itemWidth,
                          height: imageHeight,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border:
                                isSelected
                                    ? Border.all(
                                      color: context.colorExt.primary,
                                      width: 2,
                                    )
                                    : null,
                            image: DecorationImage(
                              image: option.image.provider(),
                              fit: BoxFit.cover,
                              alignment:
                                  option.label == 'Female'
                                      ? const Alignment(0, -0.8)
                                      : Alignment.center,
                              colorFilter:
                                  isSelected
                                      ? null
                                      : ColorFilter.mode(
                                        Colors.black.withValues(alpha: .4),
                                        BlendMode.darken,
                                      ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (option.icon != null)
                              SvgPicture.asset(
                                option.icon!,
                                height: 16,
                                width: 16,
                                colorFilter: ColorFilter.mode(
                                  context.colorExt.textPrimary,
                                  BlendMode.srcIn,
                                ),
                              ),
                            const SizedBox(width: 6),

                            Flexible(
                              child: Text(
                                option.label,
                                style: context.appTextStyle.textSmall,
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
