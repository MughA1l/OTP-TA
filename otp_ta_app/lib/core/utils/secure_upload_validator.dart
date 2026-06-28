import 'dart:io';

class SecureUploadValidationResult {
  final bool isValid;
  final String? message;

  const SecureUploadValidationResult({required this.isValid, this.message});
}

class SecureUploadValidator {
  static SecureUploadValidationResult validateFile(
    File file, {
    required Set<String> allowedExtensions,
    int maxSizeBytes = 5 * 1024 * 1024,
  }) {
    final extension = file.path.split('.').last.toLowerCase();
    final isAllowedExtension = allowedExtensions.contains(extension);

    if (!isAllowedExtension) {
      return const SecureUploadValidationResult(
        isValid: false,
        message:
            'unsupported file type. only approved medical document formats are allowed.',
      );
    }

    if (file.lengthSync() > maxSizeBytes) {
      return const SecureUploadValidationResult(
        isValid: false,
        message: 'File is too large for secure upload.',
      );
    }

    return const SecureUploadValidationResult(isValid: true);
  }
}
