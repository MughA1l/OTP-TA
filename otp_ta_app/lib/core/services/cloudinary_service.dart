import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import '../constants/app_config.dart';

class CloudinaryService {
  static final CloudinaryPublic _cloudinary = CloudinaryPublic(
    AppConfig.cloudinaryCloudName,
    AppConfig.cloudinaryUploadPresetReports,
    cache: false,
  );

  /// Uploads a report file (PDF or Image) to Cloudinary and returns the secure URL
  static Future<String?> uploadReport(File file) async {
    try {
      final response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          file.path,
          resourceType: CloudinaryResourceType.Auto,
        ),
      );
      return response.secureUrl;
    } catch (e) {
      print('CloudinaryService.uploadReport Error: $e');
      return null;
    }
  }
}
