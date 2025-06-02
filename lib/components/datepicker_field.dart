import 'package:flutter/material.dart';
import 'package:guftagu_mobile/utils/app_constants.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:intl/intl.dart';

class DatePickerField extends StatelessWidget {
  final String label;
  final DateTime? selectedDate;
  final VoidCallback onTap;

  const DatePickerField({
    super.key,
    required this.label,
    required this.selectedDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final String displayDate =
        selectedDate == null
            ? 'Select Age'
            : DateFormat('dd MMM yyyy').format(selectedDate!);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: context.appTextStyle.characterGenLabel),
          const SizedBox(height: 16),
          InkWell(
            onTap: onTap,
            child: InputDecorator(
              decoration: AppConstants.inputDecoration(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    displayDate,
                    style:
                        selectedDate == null
                            ? AppConstants.inputDecoration(context).hintStyle
                            : context.appTextStyle.characterGenLabel,
                  ),
                  Icon(
                    Icons.calendar_today,
                    color: context.colorExt.textPrimary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
