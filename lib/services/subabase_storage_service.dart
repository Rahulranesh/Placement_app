import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseStorageService {
  final SupabaseClient client = Supabase.instance.client;

  /// Uploads a file to the Supabase bucket named 'uploads'.
<<<<<<< HEAD
  /// The [prefix] distinguishes file types (e.g., 'staff_image', 'qn_paper', 'placement_material').
  /// The [extension] must include the leading dot (e.g., ".jpg", ".pdf").
  Future<String> uploadFile(File file, String prefix,
      {String extension = ".jpg"}) async {
    // Ensure the extension begins with a dot.
    if (!extension.startsWith(".")) {
      extension = ".$extension";
    }

    // Retrieve the current Firebase user.
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User not logged in.");
    }
    final String userId = user.uid;

    // Construct a unique file name using the prefix, user ID, and current timestamp.
    final String fileName =
        '${prefix}_${userId}_${DateTime.now().millisecondsSinceEpoch}$extension';

    // Determine the content type based on the file extension.
    String contentType = 'application/octet-stream';
    if (extension.toLowerCase() == ".jpg" ||
        extension.toLowerCase() == ".jpeg") {
      contentType = 'image/jpeg';
    } else if (extension.toLowerCase() == ".png") {
      contentType = 'image/png';
    } else if (extension.toLowerCase() == ".pdf") {
      contentType = 'application/pdf';
    }

    try {
      // Upload the file using the latest API that accepts a File.
      final String uploadResult = await client.storage.from('uploads').upload(
            fileName,
            file,
            fileOptions: FileOptions(contentType: contentType),
          );

      // Retrieve the public URL and trim any accidental spaces.
      final String publicURL =
          client.storage.from('uploads').getPublicUrl(fileName).trim();
      return publicURL;
    } catch (e) {
      throw Exception("Error during file upload: $e");
=======
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
>>>>>>> ffe1626e32d9e8b5423444e786f6984724fbfb96
    }
  }
}
