import 'package:guftagu_mobile/utils/extensions.dart';

/// A utility function to convert a MIME type string into a more human-readable file type string.
///
/// This function takes a MIME type (e.g., "image/jpeg", "application/pdf")
/// and returns a user-friendly string representing the file type (e.g., "JPEG Image", "PDF Document").
///
/// If the MIME type is not explicitly mapped, it attempts to derive a readable
/// string from the subtype (e.g., "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
/// might become "Word Document" if a specific mapping exists, or "Document File" otherwise).
///
/// [mimeType]: The MIME type string to convert.
/// Returns a human-readable string representing the file type.
String getFileTypeFromMime(String? mimeType) {
  if (mimeType == null || mimeType.isEmpty) {
    // If the MIME type is null or empty string
    return 'Unknown File Type';
  }
  // Normalize the MIME type to lowercase for consistent matching
  final normalizedMimeType = mimeType.toLowerCase();

  // A map of common MIME types to their human-readable names
  final Map<String, String> mimeTypeMap = {
    // Images
    'image/jpeg': 'JPEG Image',
    'image/png': 'PNG Image',
    'image/gif': 'GIF Image',
    'image/bmp': 'BMP Image',
    'image/webp': 'WebP Image',
    'image/svg+xml': 'SVG Image',
    'image/tiff': 'TIFF Image',

    // Audio
    'audio/mpeg': 'MP3 Audio',
    'audio/wav': 'WAV Audio',
    'audio/ogg': 'OGG Audio',
    'audio/aac': 'AAC Audio',
    'audio/flac': 'FLAC Audio',

    // Video
    'video/mp4': 'MP4 Video',
    'video/webm': 'WebM Video',
    'video/ogg': 'OGG Video',
    'video/quicktime': 'QuickTime Video',
    'video/x-msvideo': 'AVI Video',

    // Documents
    'application/pdf': 'PDF Document',
    'text/plain': 'Plain Text File',
    'application/msword': 'Word Document',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document':
        'Word Document',
    'application/vnd.ms-excel': 'Excel Spreadsheet',
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet':
        'Excel Spreadsheet',
    'application/vnd.ms-powerpoint': 'PowerPoint Presentation',
    'application/vnd.openxmlformats-officedocument.presentationml.presentation':
        'PowerPoint Presentation',
    'application/rtf': 'RTF Document',
    'application/vnd.oasis.opendocument.text': 'ODT Document',
    'application/vnd.oasis.opendocument.spreadsheet': 'ODS Spreadsheet',
    'application/vnd.oasis.opendocument.presentation': 'ODP Presentation',

    // Archives
    'application/zip': 'ZIP Archive',
    'application/x-rar-compressed': 'RAR Archive',
    'application/x-7z-compressed': '7z Archive',
    'application/gzip': 'GZIP Archive',

    // Code/Data
    'application/json': 'JSON File',
    'text/html': 'HTML Document',
    'text/css': 'CSS Stylesheet',
    'application/javascript': 'JavaScript File',
    'text/csv': 'CSV File',
    'application/xml': 'XML File',
    'text/xml': 'XML File', // Common alternative for XML
    // Executables
    'application/x-msdownload': 'Executable File', // For .exe
    'application/octet-stream': 'Binary File', // Generic binary data
  };

  // Check if the exact MIME type is in our map
  if (mimeTypeMap.containsKey(normalizedMimeType)) {
    return mimeTypeMap[normalizedMimeType]!;
  }

  // If not found, try to derive from the main type and subtype
  final parts = normalizedMimeType.split('/');
  if (parts.length == 2) {
    final mainType = parts[0];
    final subType = parts[1];

    switch (mainType) {
      case 'image':
        return '${subType.capitalize()} Image';
      case 'audio':
        return '${subType.capitalize()} Audio';
      case 'video':
        return '${subType.capitalize()} Video';
      case 'application':
        // Handle common application subtypes that might not be explicitly mapped
        if (subType.contains('pdf')) return 'PDF Document';
        if (subType.contains('word')) return 'Word Document';
        if (subType.contains('excel') || subType.contains('spreadsheet')) {
          return 'Excel Spreadsheet';
        }
        if (subType.contains('powerpoint') ||
            subType.contains('presentation')) {
          return 'PowerPoint Presentation';
        }
        if (subType.contains('zip') || subType.contains('archive')) {
          return 'Archive File';
        }
        if (subType.contains('json')) return 'JSON File';
        if (subType.contains('xml')) return 'XML File';
        if (subType.contains('javascript')) return 'JavaScript File';
        if (subType.contains('octet-stream')) return 'Binary File';
        // Fallback for other application types
        return '${subType.replaceAll('.', ' ').replaceAll('-', ' ').capitalize()} File';
      case 'text':
        return '${subType.capitalize()} Text File';
      default:
        // For any other unknown main type, just return a generic file type
        return '${mainType.capitalize()} File';
    }
  }

  // If the MIME type format is unexpected or completely unknown
  return 'Unknown File Type';
}
