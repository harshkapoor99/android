import 'package:flutter/material.dart';

import 'package:guftagu_mobile/configs/app_text_style.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';

class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    this.width = double.infinity,
    required this.title,
    required this.onTap,
    this.showLoading = false,
    this.disabled = false,
  });

  final double width;
  final String title;
  final VoidCallback onTap;
  final bool showLoading, disabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 50,
      decoration: BoxDecoration(
        gradient:
            !disabled
                ? LinearGradient(
                  colors: [context.colorExt.primary, context.colorExt.tertiary],
                  begin: const Alignment(-0.5, -1.5),
                  end: const Alignment(1.3, 1.5),
                )
                : null,
        borderRadius: BorderRadius.circular(10),
        color: disabled ? context.colorExt.surface : null,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),

        onPressed: disabled || showLoading ? null : onTap,
        child: Center(
          child:
              showLoading
                  ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(),
                  )
                  : Text(
                    title.toUpperCase(),
                    style: AppTextStyle(context).buttonText,
                  ),
        ),
      ),
    );
  }
}
