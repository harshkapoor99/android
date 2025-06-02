import 'package:flutter/material.dart';
import 'package:guftagu_mobile/components/label_text.dart';
import 'package:guftagu_mobile/components/pin_put.dart';
import 'package:guftagu_mobile/components/text_input_widget.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';

class VerificationSection extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextEditingController otpController;
  final TextInputType keyboardType;
  final bool showButton;
  final bool isOtpSent;
  final bool isVerified;
  final bool isLoading;
  final VoidCallback onSendOtp;
  final Function(String) onVerifyOtp;
  final String hintText;
  final String? prefixText;
  final int? maxLength;

  const VerificationSection({
    super.key,
    required this.label,
    required this.controller,
    required this.otpController,
    required this.keyboardType,
    required this.showButton,
    required this.isOtpSent,
    required this.isVerified,
    required this.isLoading,
    required this.onSendOtp,
    required this.onVerifyOtp,
    required this.hintText,
    this.prefixText,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Input field with Send OTP button
          LabelText(label),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextInputWidget(
                  controller: controller,
                  label: label,
                  hint: "Enter $label",
                  maxLength: maxLength,
                  keyboardType: keyboardType,
                  prefixText: prefixText,
                  suffix:
                      isVerified
                          ? const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 16,
                          )
                          : null,
                ),
              ),
              AnimatedContainer(
                height: 45,
                width: !showButton ? 0 : 110,
                curve: showButton ? Curves.easeOutBack : Curves.easeInBack,
                duration: Durations.short3,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: ElevatedButton(
                    onPressed: isVerified || isLoading ? null : onSendOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isVerified ? Colors.green : Colors.blueAccent,
                      disabledBackgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      minimumSize: const Size(80, 40),

                      padding: EdgeInsets.zero,
                    ),
                    child:
                        isLoading
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : Text(
                              isVerified
                                  ? 'Verified'
                                  : (isOtpSent ? 'Resend' : 'Send OTP'),
                              style: context.appTextStyle.text.copyWith(
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                              softWrap: false,
                              overflow: TextOverflow.fade,
                              maxLines: 1,
                            ),
                  ),
                ),
              ),
            ],
          ),

          // Verification status indicator
          // if (isVerified)
          //   const Padding(
          //     padding: EdgeInsets.only(top: 8.0),
          //     child: Row(
          //       children: [
          //         Icon(Icons.check_circle, color: Colors.green, size: 16),
          //         SizedBox(width: 4),
          //         Text(
          //           'Verified successfully',
          //           style: TextStyle(color: Colors.green, fontSize: 12),
          //         ),
          //       ],
          //     ),
          //   ),

          // OTP input field (shown only when OTP is sent and not yet verified)
          if (isOtpSent && !isVerified) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, top: 10.0),
              child: Text(
                'Enter OTP sent to your ${label.toLowerCase()}',
                style: TextStyle(
                  color: context.colorExt.textHint,
                  fontSize: 12,
                ),
              ),
            ),
            PinPutWidget(
              pinCodeController: otpController,
              onCompleted: onVerifyOtp,
              validator: (value) {
                if (value == null || value.length < 6) {
                  return 'Please enter complete OTP';
                }
                return null;
              },
            ),
          ],
        ],
      ),
    );
  }
}
