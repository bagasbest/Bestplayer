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
        'keteranganRevisi': '',
        'paymentProof': '',
        'paymentStatus': '',
        'resi': '',
        'paymentMethod': '',
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

  static uploadDesign(String uid, String orderId, String desainUrl, String keterangan) async {
    try {
      await FirebaseFirestore.instance.collection('design').doc(uid).set({
        'uid': uid,
        'orderId': orderId,
        'desainUrl': desainUrl,
        'keterangan': keterangan,
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  static deleteDesign(String uid) async {
    try {
      await FirebaseFirestore.instance.collection('design').doc(uid).delete();
      toast('Sukses Menghapus Desain');
    } catch (e) {
      print(e.toString());
      toast('Gagal Menghapus Desain');
    }
  }

  static updateOrderDeadline(String orderId) async {
    try {
      await FirebaseFirestore.instance.collection('order').doc(orderId).update({
        'waktuDesainInMillis': 0,
      });
    } catch (error) {
      print(error.toString());
    }
  }

  static requestRevision(String orderId, int revisionLeft, String keteranganRevisi) async {
    try {
      await FirebaseFirestore.instance.collection('order').doc(orderId).update({
        'revisiTotal': revisionLeft,
        'status': 'Revision',
        'keteranganRevisi': keteranganRevisi,
      });
      return true;
    } catch (error) {
      print(error.toString());
      return false;
    }
  }

  static updateOrderStatus(String orderId, String status) async {
    try {
      if(status != 'Dikemas') {
        print('sadasa$status');
        await FirebaseFirestore.instance.collection('order').doc(orderId).update({
          'status': status,
        });
      } else {
        print('sd$status');
        await FirebaseFirestore.instance.collection('order').doc(orderId).update({
          'status': status,
          'paymentProof': '',
        });
      }
      return true;
    } catch (error) {
      print(error.toString());
      return false;
    }
  }

  static uploadPaymentProof(String url, String orderId, String status, String dropdownValue) async {
    try {
      if(dropdownValue == 'Pembayaran DP') {
        await FirebaseFirestore.instance.collection('order').doc(orderId).update({
          'status': status,
          'paymentProof': url,
          'paymentMethod': 'DP',
        });
        return true;
      } else {
        await FirebaseFirestore.instance.collection('order').doc(orderId).update({
          'status': status,
          'paymentProof': url,
          'paymentMethod': 'FULL',
        });
        return true;
      }
    } catch (error) {
      print(error.toString());
      return false;
    }
  }

  static declinePayment(String orderId, String text) async {
    try {
      await FirebaseFirestore.instance.collection('order').doc(orderId).update({
        'paymentStatus': text,
        'paymentProof': '',
      });
      return true;
    } catch (error) {
      print(error.toString());
      return false;
    }
  }

  static confirmPayment(String orderId, String status, String paymentStatus) async {
    try {
      await FirebaseFirestore.instance.collection('order').doc(orderId).update({
        'paymentStatus': paymentStatus,
        'status': status,
      });
      return true;
    } catch (error) {
      print(error.toString());
      return false;
    }
  }

  static uploadResi(String resi, String orderId) async {
    try {
      await FirebaseFirestore.instance.collection('order').doc(orderId).update({
        'resi': resi,
      });
      return true;
    } catch (error) {
      print(error.toString());
      return false;
    }
  }

  static uploadPelunasan(String url, String orderId) async {
    try {
      await FirebaseFirestore.instance.collection('order').doc(orderId).update({
        'paymentProof': url,
      });
      return true;
    } catch (error) {
      print(error.toString());
      return false;
    }
  }

  static confirmPelunasanan(String orderId, String paymentMethod, String paymentStatus) async {
    try {
      await FirebaseFirestore.instance.collection('order').doc(orderId).update({
        'paymentStatus': paymentStatus,
        'paymentMethod': paymentMethod,
      });
      return true;
    } catch (error) {
      print(error.toString());
      return false;
    }
  }

  static updateDikemas(String orderId, String status) async {
    try {
      await FirebaseFirestore.instance.collection('order').doc(orderId).update({
        'status': status,
      });
      return true;
    } catch (error) {
      print(error.toString());
      return false;
    }
  }

  static Future<void> updateAdminToken(String? token) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'token': token,
      });
    } catch (error) {
      print(error.toString());
    }
  }
}
