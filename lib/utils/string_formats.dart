String removeAppNameFromProductTitle(String title) {
  final regex = RegExp(
    r'((Coin(s*))* \([^()]*\)$)|( \([^)]*\)\)$)',
    caseSensitive: false,
  );
  return title.replaceAll(regex, '');
}
