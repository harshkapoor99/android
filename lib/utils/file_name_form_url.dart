/// A utility function to extract the filename from a given URL string.
///
/// This function parses the URL, retrieves its path, and then extracts the
/// last segment of the path, which is typically the filename. It correctly
/// handles URLs with query parameters.
///
/// [url]: The URL string from which to extract the filename.
/// Returns the extracted filename as a String, or an empty string if no
/// filename can be determined (e.g., if the URL is invalid or has no path).
String getFileNameFromUrl(String url) {
  if (url.isEmpty) {
    return ''; // Return empty string for empty URL
  }

  try {
    // Parse the URL string into a Uri object.
    // This automatically handles encoding and separates components like path and query.
    final uri = Uri.parse(url);

    // Get the path segments. The path is typically everything after the domain
    // and before the query string or fragment.
    // Example: For "http://example.com/path/to/file.txt?query=abc", uri.path will be "/path/to/file.txt"
    final pathSegments = uri.pathSegments;

    // Check if there are any path segments and if the last one is not empty.
    // The last segment is generally the filename.
    if (pathSegments.isNotEmpty) {
      final lastSegment = pathSegments.last;
      if (lastSegment.isNotEmpty) {
        return lastSegment;
      }
    }

    // If no specific file name is found in the path segments,
    // or if the last segment is empty (e.g., "http://example.com/path/"),
    // return an empty string.
    return '';
  } on FormatException catch (e) {
    // Catch FormatException if the URL string is not a valid URI.
    print('Error parsing URL "$url": $e');
    return ''; // Return empty string for invalid URLs
  } catch (e) {
    // Catch any other potential errors during processing.
    print('An unexpected error occurred while processing URL "$url": $e');
    return '';
  }
}
