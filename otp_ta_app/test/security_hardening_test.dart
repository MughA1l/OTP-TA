import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:otp_ta_app/core/utils/secure_upload_validator.dart';

void main() {
  group('SecureUploadValidator', () {
    test('accepts supported report file types within size limits', () {
      final tempFile = File('${Directory.systemTemp.path}/report.pdf');
      tempFile.writeAsBytesSync(List.filled(1024, 0));

      final result = SecureUploadValidator.validateFile(
        tempFile,
        allowedExtensions: {'pdf'},
      );

      expect(result.isValid, isTrue);
      expect(result.message, isNull);
      tempFile.deleteSync();
    });

    test('rejects unsupported extensions and oversized files', () {
      final tempFile = File('${Directory.systemTemp.path}/report.exe');
      tempFile.writeAsBytesSync(List.filled(6 * 1024 * 1024, 0));

      final result = SecureUploadValidator.validateFile(
        tempFile,
        allowedExtensions: {'pdf', 'jpg', 'jpeg', 'png'},
        maxSizeBytes: 5 * 1024 * 1024,
      );

      expect(result.isValid, isFalse);
      expect(result.message, contains('unsupported'));
      tempFile.deleteSync();
    });
  });
}
