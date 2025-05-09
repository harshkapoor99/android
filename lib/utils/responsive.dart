double getResponsiveHorizontalPadding(
  double screenWidth, {
  double small = 16.0,
  double medium = 24.0,
  double large = 28.0,
}) {
  if (screenWidth < 360) {
    return small;
  } else if (screenWidth < 600) {
    return medium;
  } else {
    return large;
  }
}

// --- Helper for Responsive Vertical Spacing ---
double getResponsiveVerticalSpacing(
  double screenHeight, {
  double factor = 0.03,
}) {
  return (screenHeight * factor).clamp(10.0, 40.0);
}
