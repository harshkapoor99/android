import 'package:flutter/material.dart';
import 'package:guftagu_mobile/utils/app_constants.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:guftagu_mobile/utils/extensions.dart';

class DropdownField extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?>? onChanged;
  final String? hintText;
  final InputDecoration inputDecoration;

  const DropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hintText,
    required this.inputDecoration,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: context.appTextStyle.characterGenLabel),
          16.ph,
          DropdownButtonFormField<String>(
            value: value,
            items:
                items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: context.appTextStyle.characterGenLabel,
                    ),
                  );
                }).toList(),
            onChanged: onChanged,
            hint: Text(
              hintText ?? 'Select $label',
              style: AppConstants.inputDecoration(
                context,
              ).hintStyle?.copyWith(fontFamily: 'OpenSans'),
            ),
            decoration: AppConstants.inputDecoration(context).copyWith(
              // hintText: hintText ?? 'Select $label',
              // hintStyle: AppConstants.inputDecoration(context).hintStyle,
              // labelText: "Select $label",
              // labelStyle: AppConstants.inputDecoration(context).hintStyle,
            ),
            dropdownColor: context.colorExt.border,
            style: context.appTextStyle.characterGenLabel.copyWith(
              fontFamily: 'OpenSans',
            ),
            isExpanded: true,
          ),
        ],
      ),
    );
  }
}
