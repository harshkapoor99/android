import 'package:flutter/material.dart';

/// Shows a bottom sheet that slides up from the bottom of the screen
/// with custom content for selection.
Future<T?> showBottomUp<T>({
  required BuildContext context,
  required String title,
  required Widget content,
  double? maxHeight,
  bool isDismissible = true,
  bool enableDrag = true,
}) async {
  return await showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Container(
        constraints: BoxConstraints(
          maxHeight: maxHeight ?? MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: const BoxDecoration(
          color: Color(0xFF1E1E2D),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Bottom sheet drag handle
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            // Title bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  // Close button
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            const Divider(color: Colors.grey, height: 1),

            // Main content area
            Flexible(
              child: SingleChildScrollView(
                child: content,
              ),
            ),
          ],
        ),
      );
    },
  );
}