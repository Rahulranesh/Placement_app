import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseStorageService {
  final SupabaseClient client = Supabase.instance.client;

  Future<String> uploadFile(File file, String prefix, {String extension = ".jpg"}) async {
    if (!extension.startsWith(".")) {
      extension = ".$extension";
    }
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User not logged in.");
    }
    final String userId = user.uid;
    final String fileName =
        '${prefix}_${userId}_${DateTime.now().millisecondsSinceEpoch}$extension';

    String contentType = 'application/octet-stream';
    if (extension.toLowerCase() == ".jpg" || extension.toLowerCase() == ".jpeg") {
      contentType = 'image/jpeg';
    } else if (extension.toLowerCase() == ".png") {
      contentType = 'image/png';
    } else if (extension.toLowerCase() == ".pdf") {
      contentType = 'application/pdf';
    }

    try {
      final String uploadResult = await client.storage.from('uploads').upload(
            fileName,
            file,
            fileOptions: FileOptions(contentType: contentType),
          );
      final String publicURL =
          client.storage.from('uploads').getPublicUrl(fileName).trim();
      return publicURL;
    } catch (e) {
      throw Exception("Error during file upload: $e");
    }
  }
}
