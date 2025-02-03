import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseStorageService {
  final SupabaseClient client = Supabase.instance.client;

  /// Uploads a file to the Supabase bucket named 'uploads'.
  /// [pathPrefix] distinguishes file types (e.g., 'staff_image', 'qn_paper', 'placement_material').
  /// [extension] should include the leading dot (e.g., ".jpg", ".pdf").
  Future<String> uploadFile(File file, String pathPrefix,
      {String extension = ".jpg"}) async {
    final fileName =
        '$pathPrefix_${DateTime.now().millisecondsSinceEpoch}$extension';
    final fileBytes = await file.readAsBytes();
    final response = await client.storage.from('uploads').uploadBinary(
          fileName,
          fileBytes,
        );
    if (response.error != null) {
      throw Exception('File upload failed: ${response.error!.message}');
    }
    final publicURL = client.storage.from('uploads').getPublicUrl(fileName);
    return publicURL;
  }
}
