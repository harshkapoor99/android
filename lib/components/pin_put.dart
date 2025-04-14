import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:pinput/pinput.dart';

class PinPutWidget extends StatefulWidget {
  final void Function(String)? onCompleted;
  final String? Function(String?)? validator;
  final TextEditingController pinCodeController;
  const PinPutWidget({
    super.key,
    required this.onCompleted,
    required this.validator,
    required this.pinCodeController,
  });

  @override
  State<PinPutWidget> createState() => _PinputExampleState();
}

class _PinputExampleState extends State<PinPutWidget> {
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  void _handleCompleted(String pin) {
    if (widget.onCompleted != null) {
      widget.onCompleted!(pin);
    }
  }

  String? _validatePin(String? value) {
    return widget.validator!(value);
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 80.h,
      height: 60.h,
      textStyle: const TextStyle(fontSize: 22),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: context.colorExt.textHint),
        borderRadius: BorderRadius.circular(13),
      ),
    );

    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Directionality(
            textDirection: TextDirection.ltr,
            child: Pinput(
              length: 6,
              preFilledWidget: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 16.h),
                    width: 16,
                    height: 1,
                  ),
                ],
              ),
              controller: widget.pinCodeController,
              focusNode: focusNode,
              defaultPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  color: context.colorExt.border,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: context.colorExt.border),
                ),
              ),
              separatorBuilder: (index) => const SizedBox(width: 8),
              validator: _validatePin,
              hapticFeedbackType: HapticFeedbackType.lightImpact,
              onCompleted: _handleCompleted,
              cursor: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 16.h),
                    width: 16,
                    height: 1,
                    color: context.colorExt.tertiary,
                  ),
                ],
              ),
              focusedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  color: context.colorExt.border,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: context.colorExt.primary),
                ),
              ),
              submittedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  color: context.colorExt.border,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: context.colorExt.border),
                ),
              ),
              errorPinTheme: defaultPinTheme.copyBorderWith(
                border: Border.all(color: Colors.redAccent),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
