import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../ui/logn_screen.dart';


class DatabaseService {
  static Future<XFile?> getImageGallery() async {
    var image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (image != null) {
      return image;
    } else {
      return null;
    }
  }

  static uploadImageReport(XFile imageFile) async {
    String filename = basename(imageFile.path);

    FirebaseStorage storage = FirebaseStorage.instance;
    final Reference reference = storage.ref().child('product/$filename');
    await reference.putFile(File(imageFile.path));

    String downloadUrl = await reference.getDownloadURL();
    if (downloadUrl != null) {
      return downloadUrl;
    } else {
      return null;
    }
  }

  static void updateProfile(String name, String image, userId ) {
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({
        'name': name,
        'image': image,
      });
      toast('Berhasil memperbarui profil');
    } catch (error) {
      toast(
          'Gagal memperbarui profil, silahkan cek koneksi anda dan coba lagi nanti');
    }
  }
}