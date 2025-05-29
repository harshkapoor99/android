import 'package:flutter/material.dart';
import 'package:guftagu_mobile/components/labeled_text_field.dart';
import 'package:guftagu_mobile/components/pin_put.dart';

class VerificationSection extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextEditingController otpController;
  final TextInputType keyboardType;
  final bool isOtpSent;
  final bool isVerified;
  final bool isLoading;
  final VoidCallback onSendOtp;
  final Function(String) onVerifyOtp;
  final String hintText;
  final Color inputBackgroundColor;
  final Color primaryTextColor;
  final Color secondaryTextColor;

  const VerificationSection({
    super.key,
    required this.label,
    required this.controller,
    required this.otpController,
    required this.keyboardType,
    required this.isOtpSent,
    required this.isVerified,
    required this.isLoading,
    required this.onSendOtp,
    required this.onVerifyOtp,
    required this.hintText,
    required this.inputBackgroundColor,
    required this.primaryTextColor,
    required this.secondaryTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Input field with Send OTP button
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: LabeledTextField(
                  controller: controller,
                  label: label,
                  keyboardType: keyboardType,
                  fillColor: inputBackgroundColor,
                  labelColor: primaryTextColor,
                  inputTextStyle: TextStyle(color: primaryTextColor),
                  borderRadius: 12.0,
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                child: ElevatedButton(
                  onPressed: isVerified || isLoading ? null : onSendOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isVerified ? Colors.green : Colors.blueAccent,
                    disabledBackgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
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
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                ),
              ),
            ],
          ),

          // Verification status indicator
          if (isVerified)
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 16),
                  SizedBox(width: 4),
                  Text(
                    'Verified successfully',
                    style: TextStyle(color: Colors.green, fontSize: 12),
                  ),
                ],
              ),
            ),

          // OTP input field (shown only when OTP is sent and not yet verified)
          if (isOtpSent && !isVerified) ...[
            const SizedBox(height: 10),
            Text(
              'Enter OTP sent to your ${label.toLowerCase()}',
              style: TextStyle(color: secondaryTextColor, fontSize: 12),
            ),
            const SizedBox(height: 8),
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
