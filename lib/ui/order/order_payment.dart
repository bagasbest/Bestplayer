import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../common/common.dart';
import '../../database/database_service.dart';
import '../../widget/theme.dart';
import '../homepage_screen.dart';
import '../logn_screen.dart';

class OrderPayment extends StatefulWidget {
  final double discount;
  final int total;
  final String orderId;
  final String paymentProof;
  final String status;
  final String role;
  final String paymentStatus;
  final String teamId;
  final String paymentMethod;

  OrderPayment({
    required this.discount,
    required this.total,
    required this.orderId,
    required this.paymentProof,
    required this.status,
    required this.role,
    required this.paymentStatus,
    required this.teamId,
    required this.paymentMethod,
  });

  @override
  State<OrderPayment> createState() => _OrderPaymentState();
}

class _OrderPaymentState extends State<OrderPayment> {
  String dropdownValue = 'Pembayaran DP';
  final NumberFormat format = NumberFormat('#,##0', 'en_US');
  bool isImageAdd = false;
  XFile? _image;
  bool _visible = false;
  final keteraganPembayaran = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Themes(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Pembayaran'),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: (widget.status == 'Accepted' ||
                      widget.status == 'Payment' ||
                      widget.status == 'Dikemas')
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        (widget.role == 'user')
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Keterangan Pembayaran',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  (widget.status != 'Dikemas')
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            (widget.paymentStatus != '')
                                                ? Text(
                                                    'Keterangan Penolakan Pembayaran: ${widget.paymentStatus}',
                                                    style: TextStyle(
                                                      color: Color(0xFFD94555),
                                                    ),
                                                  )
                                                : Container(),
                                            SizedBox(
                                              height: 16,
                                            ),
                                            Text(
                                                'Silahkan pilih salah satu dari 2 metode pembayaran di bawah ini:'),
                                            SizedBox(
                                              height: 16,
                                            ),
                                            DropdownButton<String>(
                                              isExpanded: true,
                                              value: dropdownValue,
                                              elevation: 16,
                                              style: const TextStyle(
                                                  color: Color(0xFFD94555)),
                                              underline: Container(
                                                height: 2,
                                                color: Color(0xFFD94555),
                                              ),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  dropdownValue = newValue!;
                                                });
                                              },
                                              items: <String>[
                                                'Pembayaran DP',
                                                'Pembayaran Lunas',
                                              ].map<DropdownMenuItem<String>>(
                                                (String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                },
                                              ).toList(),
                                            ),
                                            SizedBox(
                                              height: 16,
                                            ),
                                            Text((dropdownValue ==
                                                    'Pembayaran DP')
                                                ? 'Silahkan melakukan pembayaran dengan nominal minimal Rp.${format.format(widget.discount)} ke norek ${Common.bankAccountNumber} atau cash ke toko langsung'
                                                : 'Silahkan melakukan pembayaran dengan nominal total Rp.${format.format(widget.total)} ke norek ${Common.bankAccountNumber} atau cash ke toko langsung'),
                                            SizedBox(
                                              height: 16,
                                            ),
                                          ],
                                        )
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                'Silahkan melakukan pelunasan dengan nominal Rp.${format.format(widget.discount)} ke norek ${Common.bankAccountNumber} atau cash ke toko langsung')
                                          ],
                                        ),
                                  Text(
                                    'Bank: ${Common.bankName}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'No. Rekening: ${Common.bankAccountNumber}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text('Silahkan unggah bukti pembayaran:'),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Visibility(
                                    visible: _visible,
                                    child: const SpinKitRipple(
                                      color: Color(0xFFD94555),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  (widget.paymentProof == '')
                                      ? (!isImageAdd)
                                          ? GestureDetector(
                                              onTap: () async {
                                                bool uploadPaymentProof = false;
                                                setState(() {
                                                  _visible = true;
                                                });

                                                if (widget.status !=
                                                    'Dikemas') {
                                                  _image = await DatabaseService
                                                      .getImageGallery();
                                                  String url =
                                                      await DatabaseService
                                                          .uploadImageReport(
                                                              _image!);
                                                  uploadPaymentProof =
                                                      await DatabaseService
                                                          .uploadPaymentProof(
                                                    url,
                                                    widget.orderId,
                                                    'Payment',
                                                    dropdownValue,
                                                  );

                                                  String uid = FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .uid;
                                                  await DatabaseService
                                                      .updateChat(
                                                    uid,
                                                    'Payment',
                                                  );
                                                } else {
                                                  _image = await DatabaseService
                                                      .getImageGallery();
                                                  String url =
                                                      await DatabaseService
                                                          .uploadImageReport(
                                                              _image!);
                                                  uploadPaymentProof =
                                                      await DatabaseService
                                                          .uploadPelunasan(
                                                    url,
                                                    widget.orderId,
                                                  );
                                                }

                                                setState(() {
                                                  _visible = false;
                                                });

                                                if (uploadPaymentProof) {
                                                  showSuccessUploadPaymentProof();
                                                  setState(() {
                                                    isImageAdd = true;
                                                    toast(
                                                        'Berhasil mengunggah bukti pembayaran');
                                                  });
                                                  Navigator.of(context)
                                                      .pushAndRemoveUntil(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  HomepageScreen()),
                                                          (Route<dynamic>
                                                                  route) =>
                                                              false);
                                                } else {
                                                  setState(() {
                                                    toast(
                                                        "Gagal mengunggah bukti pembayaran");
                                                  });
                                                }
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: DottedBorder(
                                                  color: Colors.grey,
                                                  strokeWidth: 1,
                                                  dashPattern: [6, 6],
                                                  child: Container(
                                                    child: Center(
                                                      child:
                                                          Text("* Tambah Foto"),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Image.file(
                                                File(
                                                  _image!.path,
                                                ),
                                                fit: BoxFit.cover,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                              ),
                                            )
                                      : Column(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.network(
                                                widget.paymentProof,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 16,
                                            ),
                                          ],
                                        ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 16,
                                  ),
                                  (widget.paymentProof != '')
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text((widget.status != 'Dikemas') ?
                                              'Keterangan Pembayaran: ${widget.paymentMethod}' : 'Keterangan Pembayaran: Pelunasan',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.network(
                                                widget.paymentProof,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 30,
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                bool confirmPayment = false;

                                                if (widget.status !=
                                                    'Dikemas') {
                                                  confirmPayment =
                                                      await DatabaseService
                                                          .confirmPayment(
                                                    widget.orderId,
                                                    'Completed',
                                                    '',
                                                  );

                                                  await DatabaseService
                                                      .updateChat(widget.teamId,
                                                          'Completed');
                                                } else {
                                                  confirmPayment =
                                                      await DatabaseService
                                                          .confirmPelunasanan(
                                                    widget.orderId,
                                                    'FULL',
                                                    '',
                                                  );
                                                }

                                                if (confirmPayment) {
                                                  toast(
                                                      'Berhasil Konfirmasi Pembayaran');
                                                  Navigator.of(context)
                                                      .pushAndRemoveUntil(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  HomepageScreen()),
                                                          (Route<dynamic>
                                                                  route) =>
                                                              false);
                                                } else {
                                                  toast(
                                                      'Gagal Konfirmasi Pembayaran');
                                                }
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Color(0xFFD94555),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'Konfirmasi Pembayaran',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 16,
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                _showDeclineDialog();
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.red[200],
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'Tolak Pembayaran',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Text(
                                          'User belum mengunggah bukti pembayaran'),
                                  SizedBox(
                                    height: 16,
                                  ),
                                ],
                              )
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            widget.paymentProof,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        )),
      ),
    );
  }

  void showSuccessUploadPaymentProof() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Berhasil Mengunggah Bukti Pembayaran"),
          content: const Text(
            'Silahkan tunggu admin untuk mengecek & mengonfirmasi pembayaran anda',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.check,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _showDeclineDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.all(
              Radius.circular(16),
            ),
          ),
          backgroundColor: Color(0xFFD94555),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text(
                  'Konfirmasi Penolakan Pembayaran',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                  right: MediaQuery.of(context).size.width * 0.1,
                ),
                child: Divider(
                  color: Colors.white,
                  height: 3,
                  thickness: 3,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                'Silahkan masukkan alasan mengapa anda menolak pembayaran',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                margin: const EdgeInsets.only(
                  top: 10,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  controller: keteraganPembayaran,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    hintText: 'Keterangan Penolakan Pembayaran',
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 26,
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.clear,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            IconButton(
              icon: Icon(
                Icons.check,
                color: Colors.white,
              ),
              onPressed: () async {
                if (keteraganPembayaran.text != '') {
                  bool declinePayment = await DatabaseService.declinePayment(
                      widget.orderId, keteraganPembayaran.text);

                  if (declinePayment) {
                    toast('Berhasil menolak pembayaran');
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => HomepageScreen()),
                        (Route<dynamic> route) => false);
                  } else {
                    toast('Gagal menolak pembayaran');
                  }
                } else {
                  toast('Silahkan masukkan alasan penolakan pembayaran');
                }
              },
            ),
          ],
          elevation: 10,
        );
      },
    );
  }
}
