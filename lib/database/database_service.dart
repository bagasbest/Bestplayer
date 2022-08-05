import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  static uploadPdf(File? filePdf) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    final Reference reference = storage.ref().child('pdf/$filePdf');
    await reference.putFile(filePdf!);

    String downloadUrl = await reference.getDownloadURL();
    if (downloadUrl != null) {
      return downloadUrl;
    } else {
      return null;
    }
  }

  static void updateProfile(String name, String image, userId, String role) {
    try {
      FirebaseFirestore.instance.collection('users').doc(userId).update({
        'name': name,
        'image': image,
      });

      if (role == 'user') {
        String uid = FirebaseAuth.instance.currentUser!.uid;
        FirebaseFirestore.instance.collection('chat').doc(uid).update({
          'userName': name,
          'userImage': image,
        });
      }

      toast('Berhasil memperbarui profil');
    } catch (error) {
      toast(
          'Gagal memperbarui profil, silahkan cek koneksi anda dan coba lagi nanti');
    }
  }

  static createOrder(
    String orderId,
    String paket,
    String gambar,
    int totalHarga,
    double discount50,
    String jerseyDepan,
    String jerseyBelakang,
    String celana,
    int waktuDesainInMillis,
    int revisiTotal,
    String teamId,
    String teamName,
    String teamPhone,
    String teamAddress,
    String orderDate,
    String status,
    String qty,
    String sponsor,
  ) async {
    try {
      await FirebaseFirestore.instance.collection('order').doc(orderId).set({
        'orderId': orderId,
        'paket': paket,
        'gambar': gambar,
        'totalHarga': totalHarga,
        'discount50': discount50,
        'jerseyDepan': jerseyDepan,
        'jerseyBelakang': jerseyBelakang,
        'celana': celana,
        'waktuDesainInMillis': waktuDesainInMillis,
        'revisiTotal': revisiTotal,
        'teamId': teamId,
        'teamName': teamName,
        'teamPhone': teamPhone,
        'teamAddress': teamAddress,
        'orderDate': orderDate,
        'status': status,
        'qty': qty,
        'sponsor': sponsor,
      });
      return true;
    } catch (error) {
      print(error.toString());
      return false;
    }
  }

  static updateChat(String teamId, String status) async {
    try {
      await FirebaseFirestore.instance.collection('chat').doc(teamId).update({
        'status': status,
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
