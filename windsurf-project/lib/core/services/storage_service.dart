import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadProfileImage(String userId, XFile imageFile) async {
    try {
      Reference ref = _storage
          .ref()
          .child('profile_images')
          .child(userId)
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

      UploadTask uploadTask = ref.putFile(File(imageFile.path));
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw 'Error uploading profile image: $e';
    }
  }

  Future<String> uploadProgressPhoto(String userId, XFile imageFile, DateTime date) async {
    try {
      Reference ref = _storage
          .ref()
          .child('progress_photos')
          .child(userId)
          .child('${date.millisecondsSinceEpoch}.jpg');

      UploadTask uploadTask = ref.putFile(File(imageFile.path));
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw 'Error uploading progress photo: $e';
    }
  }

  Future<void> deleteProfileImage(String imageUrl) async {
    try {
      Reference ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      throw 'Error deleting profile image: $e';
    }
  }

  Future<void> deleteProgressPhoto(String imageUrl) async {
    try {
      Reference ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      throw 'Error deleting progress photo: $e';
    }
  }

  Future<List<String>> getUserProgressPhotoUrls(String userId) async {
    try {
      ListResult result = await _storage
          .ref()
          .child('progress_photos')
          .child(userId)
          .listAll();

      List<String> urls = [];
      for (Reference ref in result.items) {
        String url = await ref.getDownloadURL();
        urls.add(url);
      }
      return urls;
    } catch (e) {
      throw 'Error fetching progress photos: $e';
    }
  }
}
