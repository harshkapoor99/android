/// A utility function to get the full name of a locale from its locale code.
///
/// This function supports a predefined set of locale codes and their
/// corresponding names, including a priority on Indian languages
/// and commonly used global languages.
///
/// Args:
///   localeCode: The locale code (e.g., 'en', 'hi', 'bn').
///
/// Returns:
///   The full locale name (e.g., 'English', 'Hindi'), or Locale Code
///   if the code is not found in the predefined list.
String getLocaleName(String localeCode) {
  // A map storing locale codes to their corresponding full names.
  // Indian languages are prioritized as requested.
  final Map<String, String> localeNames = {
    // Indian Languages (Priority)
    'en': 'English', // English is also widely used in India
    'hi': 'Hindi',
    'bn': 'Bengali',
    'mr': 'Marathi',
    'ta': 'Tamil',
    'te': 'Telugu',
    'gu': 'Gujarati',
    'kn': 'Kannada',
    'or': 'Odia', // ISO 639-1 code for Odia (formerly Oriya)
    'ur': 'Urdu',
    'ml': 'Malayalam',

    // Global Languages
    'es': 'Spanish',
    'ar': 'Arabic',
    'zh': 'Mandarin', // Using 'zh' for generic Chinese/Mandarin
    'fr': 'French',
    'de': 'German',
    'pt': 'Portuguese',
    'ja': 'Japanese',
    'ru': 'Russian',
    'ko': 'Korean',
  };

  // Convert the localeCode to lowercase to handle case insensitivity
  // and then look up the name in the map.
  // If the key is not found, it defaults to 'Unknown Locale'.
  return localeNames[localeCode.toLowerCase()] ?? localeCode;
}
