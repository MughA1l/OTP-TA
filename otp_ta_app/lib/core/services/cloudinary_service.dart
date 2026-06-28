import 'dart:developer' as developer;
import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import '../constants/app_config.dart';
import '../utils/secure_upload_validator.dart';

class CloudinaryService {
  static final CloudinaryPublic _cloudinary = CloudinaryPublic(
    AppConfig.cloudinaryCloudName,
    AppConfig.cloudinaryUploadPresetReports,
    cache: false,
  );

  /// Uploads a report file (PDF or Image) to Cloudinary and returns the secure URL
  static Future<String?> uploadReport(File file) async {
    final validation = SecureUploadValidator.validateFile(
      file,
      allowedExtensions: {'pdf', 'jpg', 'jpeg', 'png'},
      maxSizeBytes: 5 * 1024 * 1024,
    );

    if (!validation.isValid) {
      return null;
    }

    try {
      final response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          file.path,
          resourceType: CloudinaryResourceType.Auto,
        ),
      );
      return response.secureUrl;
    } catch (e) {
      developer.log(
        'CloudinaryService.uploadReport Error',
        error: e,
        name: 'CloudinaryService',
      );
      return null;
    }
  }
}
