String removeAppNameFromProductTitle(String title) {
  final regex = RegExp(r'( \([^()]*\)$)|( \([^)]*\)\)$)', caseSensitive: false);
  return title.replaceAll(regex, '');
}
