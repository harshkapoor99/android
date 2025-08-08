enum ChatType {
  text,
  audio,
  file,
  document,
  image,
  call;

  static ChatType? fromString(String? value) {
    if (value == null) {
      return null;
    }
    // Iterate through all values of the ChatType enum
    for (var type in ChatType.values) {
      // Compare the lowercase name of the enum value with the input value
      if (type.name.toLowerCase() == value.toLowerCase()) {
        return type;
      }
    }
    return null; // Return null if no match is found
  }
}
